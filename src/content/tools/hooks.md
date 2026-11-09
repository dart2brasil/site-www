---
ia-translate: true
title: Hooks
description: Execute scripts de build personalizados.
---

:::version-note
O suporte a build hooks foi introduzido no Dart 3.10.
O suporte a link hooks e ao tree-shaking por uso registrado foi introduzido no
Dart 3.13.
:::

Este guia explica o que são hooks e como usá-los
com um pacote.

## Introdução {:#introduction}

Atualmente, você pode usar hooks para fazer coisas
como compilar ou baixar native assets (código escrito em
outras linguagens que é compilado para código de máquina) e
depois chamar esses assets a partir do código Dart de um pacote.

Hooks são scripts Dart colocados no diretório `hook/` do
seu pacote Dart. Eles têm um formato predefinido para
entrada e saída, o que permite ao Dart SDK:

1. Descobrir os hooks.
1. Executar os hooks com a entrada necessária.
1. Consumir a saída produzida pelos hooks.

Exemplo de projeto com um build hook:

<FileTree>

- example_project/ // Projeto com hooks.
  - hook/ // Adicione os scripts de hook aqui.
    - build.dart
  - lib/  // Use seus assets aqui.
    - example.dart
  - src/  // Adicione os fontes nativos aqui.
    - example_native_library.c
    - example_native_library.h
  - test/ // Teste seus assets aqui.
    - example_test.dart

</FileTree>

## Hooks {:#hooks}

Atualmente, há build hooks e link hooks disponíveis. Para saber mais, veja o seguinte.

### Build hooks {:.no_toc}

Com build hooks, um pacote pode fazer coisas como
compilar ou baixar native assets, como bibliotecas C ou Rust.
Depois, esses assets podem ser chamados a partir do código Dart do
pacote.

O build hook de um pacote é invocado automaticamente pelo
Dart SDK em um momento apropriado do processo de build.
Build hooks são executados em paralelo com a compilação Dart e
podem fazer operações demoradas, como download ou
chamada de um compilador nativo.

Use a função [`build`][] para analisar a
entrada do hook com [`BuildInput`] e depois escrever a saída do hook
com [`BuildOutputBuilder`]. O hook deve colocar
os assets baixados e gerados em
[`BuildInput.sharedOutputDirectory`][].

Os assets produzidos para o seu pacote podem depender de
[`assets`][] ou [`metadata`][] produzidos pelos build hooks
dos pacotes nas dependências diretas do pubspec. Por isso,
build hooks são executados na ordem das dependências no pubspec, e dependências
cíclicas entre pacotes não são suportadas ao usar hooks.

### Link hooks {:.no_toc}

Com link hooks, um pacote pode filtrar, otimizar ou fazer tree-shaking dos code assets
gerados pelos build hooks antes de empacotá-los em um aplicativo.

O Dart SDK invoca automaticamente o link hook de um pacote (`hook/link.dart`)
durante a fase de empacotamento do aplicativo. Diferentemente dos build hooks, que são executados para
cada pacote, os link hooks são executados com o contexto no nível do aplicativo, para que
possam inspecionar quais símbolos o aplicativo realmente usa.

Use a função [`link`][] para analisar a entrada do hook com [`LinkInput`][] e
escrever a saída do hook com [`LinkOutputBuilder`][].
Se o tree-shaking remover todos os símbolos de um asset, o link hook pode omitir
o asset por completo para não empacotá-lo com o aplicativo.

[`assets`]: {{site.pub-api}}/hooks/latest/hooks/BuildInput/assets.html
[`build`]: {{site.pub-api}}/hooks/latest/hooks/build.html
[`BuildInput`]: {{site.pub-api}}/hooks/latest/hooks/BuildInput-class.html
[`BuildOutputBuilder`]: {{site.pub-api}}/hooks/latest/hooks/BuildOutputBuilder-class.html
[`BuildInput.sharedOutputDirectory`]: {{site.pub-api}}/hooks/latest/hooks/HookInput/outputDirectoryShared.html
[`CLibrary`]: {{site.pub-api}}/native_toolchain_c/latest/native_toolchain_c/CLibrary-class.html
[`CLibrary.build`]: {{site.pub-api}}/native_toolchain_c/latest/native_toolchain_c/CLibrary/build.html
[`CLibrary.link`]: {{site.pub-api}}/native_toolchain_c/latest/native_toolchain_c/CLibrary/link.html
[`link`]: {{site.pub-api}}/hooks/latest/hooks/link.html
[`LinkInput`]: {{site.pub-api}}/hooks/latest/hooks/LinkInput-class.html
[`LinkInput.recordedUses`]: {{site.pub-api}}/hooks/latest/hooks/LinkInput/recordedUses.html
[`LinkOutputBuilder`]: {{site.pub-api}}/hooks/latest/hooks/LinkOutputBuilder-class.html
[`metadata`]: {{site.pub-api}}/hooks/latest/hooks/BuildInput/metadata.html

### Variáveis de ambiente {:.no_toc}

Os hooks são executados em um ambiente semi-hermético.
Isso significa que `Platform.environment` não
expõe todas as variáveis de ambiente do processo pai.
Isso garante que as invocações de hooks sejam reproduzíveis e armazenáveis em cache, e
não dependam de variáveis de ambiente acidentais.

No entanto, algumas variáveis de ambiente são necessárias para
localizar ferramentas (como compiladores) ou configurar o acesso à rede.
As seguintes variáveis de ambiente são
repassadas ao processo do hook:

*   **Caminho e raízes do sistema:**
    *   `PATH`: Invocar ferramentas nativas.
    *   `HOME`, `USERPROFILE`: Encontrar ferramentas nos locais de instalação padrão.
    *   `SYSTEMDRIVE`, `SYSTEMROOT`, `WINDIR`: Invocações de processos e
        CMake no Windows.
    *   `PROGRAMDATA`: Para o `vswhere.exe` no Windows.
*   **Diretórios temporários:**
    *   `TEMP`, `TMP`, `TMPDIR`: Diretórios temporários.
*   **Proxies HTTP:**
    *   `HTTP_PROXY`, `HTTPS_PROXY`, `NO_PROXY`: Acesso à rede atrás de proxies.
*   **Clang/LLVM:**
    *   `LIBCLANG_PATH`: `bindgen` + `clang-sys` do Rust.
*   **Android NDK:**
    *   `ANDROID_HOME`: Local padrão do Android SDK/NDK.
    *   `ANDROID_NDK`, `ANDROID_NDK_HOME`, `ANDROID_NDK_LATEST_HOME`,
        `ANDROID_NDK_ROOT`: Locais alternativos para o NDK.
*   **Nix:**
    *   Qualquer variável que comece com `NIX_`.

Qualquer alteração nessas variáveis de ambiente
invalida o cache dos hooks.

Todas as outras variáveis de ambiente são removidas.

## Assets {:#assets}

Assets são os arquivos produzidos por um hook e depois
empacotados em um aplicativo Dart. Assets podem ser acessados
em tempo de execução pelo código Dart. Atualmente, o Dart SDK pode
usar o tipo `CodeAsset`, mas outros tipos de assets estão planejados.
Para saber mais, veja o seguinte.

### Tipo CodeAsset {:.no_toc}

Um [`CodeAsset`][] representa um code asset. Um code asset é uma biblioteca dinâmica
compilada a partir de uma linguagem diferente de Dart, como C, C++, Rust ou Go.
`CodeAsset` faz parte do pacote `code_assets`. As APIs fornecidas por code assets
são acessadas em tempo de execução por meio de membros Dart externos correspondentes, anotados
com a anotação [`@Native`][] de `dart:ffi`.

[`CodeAsset`]: {{site.pub-api}}/code_assets/latest/code_assets/CodeAsset-class.html
[`@Native`]: {{site.dart-api}}/dart-ffi/Native-class.html

## Usar um hook {: #use-hooks-assets }

Para adicionar assets ao seu projeto, use um hook. Para detalhes,
veja as seções a seguir.

### Adicionar dependências {: #add-dependencies-hooks-assets }

Para usar um hook, primeiro você deve adicionar os pacotes auxiliares
`hooks` e `code_assets` às dependências do seu `pubspec.yaml`:

1. `dart pub add hooks code_assets`.

Se você precisar compilar fontes C, também precisará do pacote `native_toolchain_c`:

2. `dart pub add native_toolchain_c`.

:::note
Você precisa adicionar as dependências em `dependencies`, e não em
`dev_dependencies`. Os hooks serão executados pelos pacotes e
aplicativos que dependem do seu pacote, então o
código Dart precisa fazer parte da resolução nesses
pacotes.
:::

Exemplo de dependências para um build hook:

```yaml title="pubspec.yaml"
name: native_add_library
description: Sums two numbers with native code.
version: 0.1.0

environment:
  sdk: '^3.10.0'

dependencies:
  # ... 
  code_assets: any
  hooks: any
  native_toolchain_c: any

dev_dependencies:
  # ...
  ffigen: ^18.0.0
 ```

### Criar um build hook para gerar native assets {: #create-hook }

Se você quiser usar um build hook para compilar de forma transparente
native assets (como bibliotecas C ou Rust), que depois ficam disponíveis
para serem chamados a partir do código Dart de um pacote,
crie um script `build.dart` semelhante ao seguinte:

1.  No seu projeto Dart, crie ou abra `hook/build.dart`.

1.  No método `main`, chame a função `build` de
    `package:hooks/hooks.dart` e use a
    toolchain apropriada para compilar a biblioteca nativa. Por exemplo:

    ```dart title="hook/build.dart" highlightLines=6
    import 'package:hooks/hooks.dart';
    import 'package:native_toolchain_c/native_toolchain_c.dart';

    void main(List<String> args) async {
      await build(args, (input, output) async {
        final packageName = input.packageName;
        final cLibrary = CLibrary(
          name: packageName,
          assetName: '$packageName.dart',
          sources: ['src/$packageName.c'],
        );
        await cLibrary.build(
          input: input,
          output: output,
        );
      });
    }
    ```

    O segundo parâmetro de `build` espera uma função à qual ele passará dois
    argumentos:

    * `input`: A entrada somente leitura do hook.
      Inclui informações para que o hook
      produza o tipo de asset correto (por exemplo,
      SO de destino, arquitetura de destino, diretório de saída e
      mais). Para detalhes, veja a classe [`BuildInput`][].

    * `output`: O construtor somente escrita da saída do hook. Depois que o
      build hook lê a entrada, ele produz um asset e
      então fornece o que produziu como saída.
      Para detalhes, veja a classe [`BuildOutputBuilder`][].

[`BuildInput`]: {{site.pub-api}}/hooks/latest/hooks/BuildInput-class.html
[`BuildOutputBuilder`]: {{site.pub-api}}/hooks/latest/hooks/BuildOutputBuilder-class.html

:::note
Ao nomear suas bibliotecas dinâmicas, garanta que o nome seja
consistente em todas as arquiteturas e SDKs de destino.
Nas plataformas Apple, o sistema de build do Flutter depende de
nomes de arquivo consistentes para gerar corretamente frameworks e XCFrameworks.
Para mais detalhes, confira [Vinculando código nativo][flutter-native]
no site de documentação do Flutter.
:::

### Criar um link hook para fazer tree-shaking de native assets {: #create-link-hook }

:::version-note
O suporte a link hooks e ao tree-shaking por uso registrado foi introduzido no
Dart 3.13.
:::

Se o seu pacote gera native assets com um build hook (`hook/build.dart`),
você pode adicionar um link hook (`hook/link.dart`) para fazer tree-shaking dos code assets
não utilizados antes do empacotamento.

Durante a compilação, o compilador Dart registra quais símbolos `@Native` são
de fato referenciados pelo aplicativo e os disponibiliza aos link hooks por
meio de [`LinkInput.recordedUses`][].
Se `input.recordedUses` for `null`, o link hook desativa o tree-shaking e
mantém todos os símbolos.

1.  No seu projeto Dart, crie ou abra `hook/link.dart`.

1.  No método `main`, chame a função `link` de
    `package:hooks/hooks.dart` e passe as opções de tree-shaking para [`CLibrary.link`][].
    Por exemplo:

    ```dart title="hook/link.dart"
    import 'package:hooks/hooks.dart';
    import 'package:native_toolchain_c/native_toolchain_c.dart';
    import 'package:record_use/record_use.dart';

    import 'record_use_mapping.dart';

    void main(List<String> args) async {
      await link(args, (input, output) async {
        final packageName = input.packageName;
        final cLibrary = CLibrary(
          name: packageName,
          assetName: '$packageName.dart',
          sources: ['src/$packageName.c'],
        );

        final linkerOptions = LinkerOptions.treeshake(
          symbolsToKeep: input.recordedUses?.calls.keys
              .cast<Method>()
              .map((e) => recordUseMapping[e.name]!),
        );

        await cLibrary.link(
          input: input,
          output: output,
          linkerOptions: linkerOptions,
        );
      });
    }
    ```

Os símbolos Dart em bindings gerados por ferramentas como `ffigen` nem sempre
correspondem um a um aos nomes de símbolos C nativos.
Ao gerar bindings FFI, o `ffigen` pode gerar automaticamente um mapeamento
(`recordUseMapping`) dos identificadores de métodos Dart para os símbolos nativos.
Mapeie cada chamada de método Dart registrada (`input.recordedUses?.calls.keys`)
usando `recordUseMapping` para passar os símbolos nativos correspondentes a
`LinkerOptions.treeshake`.

Quando `symbolsToKeep` é `null` (por exemplo, quando `input.recordedUses` é
`null`), `LinkerOptions.treeshake` preserva todos os símbolos da biblioteca nativa.
Quando `symbolsToKeep` é uma lista vazia (`[]`), o que significa que o aplicativo não
referencia nenhum símbolo da biblioteca, `CLibrary.link` ignora automaticamente a
compilação e o empacotamento da biblioteca dinâmica.

### Assets empacotados automaticamente {: #generate-assets }

Os hooks são executados automaticamente ao invocar os comandos `run`, `build` ou `test`.
Os assets resultantes são armazenados no diretório de saída especificado na
entrada do hook. Em seguida, o Dart SDK empacota automaticamente esses assets com
seu aplicativo Dart para que possam ser acessados em tempo de execução.

### Usar assets {: #reference-assets }

Assets são os arquivos que os hooks criam. Depois que um asset é
criado, você pode referenciá-lo no seu código e em tempo de execução
pelo seu asset ID ([`assetId`][]). Asset IDs têm a estrutura
`package:<package-name>/<asset-name>`. Build hooks só podem
produzir assets no próprio pacote. O `CLibrary` no
build hook do exemplo anterior produz o asset ID
`package:native_add_library/native_add_library.dart`, com base no
`packageName` e no `assetName`.

:::tip
Como boa prática, use como asset ID o URI da biblioteca Dart onde você
pretende usar o code asset.
Embora você possa usar qualquer asset ID que comece com o nome do seu pacote,
usar o URI da biblioteca permite que o Dart
conecte o asset automaticamente em tempo de execução, sem
precisar especificar um `assetId` na anotação `@Native`.
:::

O exemplo a seguir ilustra como vincular à
função C nativa `add` de `native_add_library.c` e chamá-la:

```dart title="my_package/lib/my_package.dart"
import 'dart:ffi';

@Native<Int32 Function(Int32, Int32)>()
external int add(int a, int b);
```

```dart title="my_package/bin/my_package.dart"
import 'package:my_package/my_package.dart';

void main() {
  print(add(24, 18));
}
```

O asset ID em `@Native` é opcional e assume por padrão o
URI da biblioteca. No exemplo anterior, ele é
`package:native_add_library/native_add_library.dart`, que
é o mesmo asset ID produzido pelo build hook. Isso
permite que o Dart conecte um asset referenciado em tempo de execução ao
fornecido pelo hook durante o processo de build.

[`assetId`]: {{site.dart-api}}/dart-ffi/Native/assetId.html

### Testar assets {: #test-assets }

Depois de escrever um hook que gera um asset e
de usar esse asset no seu código Dart, considere escrever
um teste para verificar se o hook e o asset gerado funcionam
como esperado.

No exemplo a seguir, um teste é criado para
`native_add_library.dart`, um script que referencia uma
função C nativa chamada `add`:

```dart title="test/native_add_library_test.dart"
import 'package:native_add_library/native_add_library.dart';
import 'package:test/test.dart';

void main() {
  test('invoke native function', () {
    expect(add(24, 18), 42);
  });
}
```

## Configuração de hooks {: #hook-configuration }

Passe parâmetros personalizados ou caminhos de arquivos locais para os build e link hooks
a partir do ambiente de build do seu projeto.
Configure esses parâmetros na chave `hooks` do seu arquivo `pubspec.yaml`.
Atualmente, esse bloco suporta apenas a opção `user_defines`.

### Configurar user-defines {: #configure-user-defines }

Configure os parâmetros personalizados no arquivo `pubspec.yaml` do pacote raiz,
ou no arquivo `pubspec.yaml` do workspace, se você usar workspace.
Somente os usuários finais—os autores do aplicativo ou pacote raiz que consome
as dependências—podem configurar user-defines.
As dependências não podem fornecer seus próprios user-defines padrão.

Os valores configurados em `user_defines` podem ser de qualquer tipo compatível com JSON,
como booleanos, strings, números, mapas aninhados ou listas.
Os user-defines são filtrados por pacote.
Um hook dentro de `my_package` só pode acessar as chaves configuradas em
`hooks.user_defines.my_package`.
Ele não pode acessar os user-defines de outros pacotes.

O exemplo a seguir passa dois user-defines
para os hooks do pacote `my_package`:

```yaml title="pubspec.yaml"
hooks:
  user_defines:
    my_package:
      enable_experimental: true
      custom_lib: assets/libnative.so
```

### Acessar user-defines em um hook {: #access-user-defines }

Para acessar os user-defines configurados no seu script de hook
`build.dart` ou `link.dart`, use o objeto `input.userDefines`:

1. Leia os valores brutos com o operador de colchetes, como `input.userDefines['key']`.
1. Resolva caminhos relativos para um `Uri`
   usando o método `path()`,
   como `input.userDefines.path('key')`.
   Isso resolve o caminho relativo em relação ao diretório do `pubspec.yaml`
   onde os user-defines são declarados.

Se o hook ler um arquivo ou diretório resolvido,
registre-o como dependência usando
`output.dependencies.add()`.
Isso garante que o sistema de build invalide o cache e
execute o hook novamente quando o arquivo mudar.

O exemplo a seguir é um script de hook que acessa os
user-defines `enable_experimental` e `custom_lib`:

```dart title="hook/build.dart"
import 'dart:io';
import 'package:hooks/hooks.dart';

void main(List<String> args) async {
  await build(args, (input, output) async {
    final experimental = input.userDefines['enable_experimental'];
    if (experimental is! bool?) {
      throw const FormatException(
        'hooks.user_defines.my_package.enable_experimental must be a '
        'boolean (or omitted)',
      );
    }

    if (experimental ?? false) {
      print('Experimental features enabled.');
    }

    final customLibUri = input.userDefines.path('custom_lib');
    if (customLibUri != null) {
      final file = File.fromUri(customLibUri);
      output.dependencies.add(file.uri);
      // Use the file...
    }
  });
}
```

## Projetos de exemplo {: #example-projects }

Há vários projetos de exemplo para ajudar você a começar
com hooks e code assets:

| **Projeto**                  | **Descrição**                                                                                      |
| ---------------------------- | -------------------------------------------------------------------------------------------------- |
| [`sqlite`][]                 | Um pacote que compila, empacota, faz tree-shaking e usa um mecanismo de banco de dados nativo.                   |
| [`mini_audio`][]             | Um pacote que compila, empacota, faz tree-shaking e usa um reprodutor de áudio nativo.                      |
| [`stb_image`][]              | Um pacote que compila, empacota, faz tree-shaking e usa uma biblioteca de imagens nativa.                   |
| [`host_name`][]              | Um pacote que usa uma biblioteca nativa do sistema.                                                |
| [`native_add_library`][]     | Um pacote que compila, empacota e usa um código C simples.                               |
| [`native_add_app`][]         | Um aplicativo CLI Dart que depende de `native_add_library`.                               |
| [`download_asset`][]         | Um pacote que empacota e usa assets pré-compilados que são baixados no build hook.        |
| [`native_dynamic_linking`][] | Um pacote que compila, empacota e usa três bibliotecas nativas que dependem umas das outras. |
| [`use_dart_api`][]           | Um pacote que usa a API C da VM Dart.                                                    |

{: .table .table-striped }

[`native_add_library`]: {{site.repo.dart.org}}/native/blob/main/pkgs/hooks/example/build/native_add_library
[`native_add_app`]: {{site.repo.dart.org}}/native/tree/main/pkgs/hooks/example/build/native_add_app
[`download_asset`]: {{site.repo.dart.org}}/native/tree/main/pkgs/hooks/example/build/download_asset
[`native_dynamic_linking`]: {{site.repo.dart.org}}/native/tree/main/pkgs/hooks/example/build/native_dynamic_linking
[`use_dart_api`]: {{site.repo.dart.org}}/native/tree/main/pkgs/hooks/example/build/use_dart_api
[`host_name`]: {{site.repo.dart.org}}/native/tree/main/pkgs/code_assets/example/host_name
[`sqlite`]: {{site.repo.dart.org}}/native/tree/main/pkgs/code_assets/example/sqlite
[`mini_audio`]: {{site.repo.dart.org}}/native/tree/main/pkgs/code_assets/example/mini_audio
[`stb_image`]: {{site.repo.dart.org}}/native/tree/main/pkgs/code_assets/example/stb_image

## Mais informações {: #more-information }

Veja os links a seguir para mais informações:

* [Pacote Hooks][Hooks package]
* [Referência da biblioteca Hooks][Hooks library reference]
* [Pacote Code assets][Code assets package]
* [Referência da biblioteca Code assets][Code assets library reference]
* [Pacote Record use][Record use package]
* [Referência da biblioteca Record use][Record use library reference]
* [Interoperabilidade C][C interop]
* [Vinculando código nativo em aplicativos Flutter][flutter-native]

[Hooks package]: {{site.pub-pkg}}/hooks
[Hooks library reference]: {{site.pub-api}}/hooks/latest/hooks/
[Code assets package]: {{site.pub-pkg}}/code_assets
[Code assets library reference]: {{site.pub-api}}/code_assets/latest/code_assets/
[Record use package]: {{site.pub-pkg}}/record_use
[Record use library reference]: {{site.pub-api}}/record_use/latest/record_use/
[C interop]: /interop/c-interop
[flutter-native]: {{site.flutter-docs}}/platform-integration/bind-native-code
