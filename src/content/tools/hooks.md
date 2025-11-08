---
ia-translate: true
title: Hooks
description: Execute scripts de build personalizados.
---

:::version-note
O suporte para build hooks foi introduzido no Dart 3.10.
:::

Este guia explica o que são hooks e como usá-los
com um pacote.

## Introdução

Você pode atualmente usar hooks para fazer coisas
como compilar ou baixar native assets (código escrito em
outras linguagens que são compiladas em machine code), e
então chamar esses assets do código Dart de um pacote.

Hooks são scripts Dart colocados no diretório `hook/` do
seu pacote Dart. Eles têm um formato predefinido para seu
input e output, o que permite ao Dart SDK:

1. Descobrir os hooks.
1. Executar os hooks com o input necessário.
1. Consumir o output produzido pelos hooks.

Exemplo de projeto com um build hook:

```plaintext
📁  example_project                   // Project with hooks.
    📁  hook                          // Add hook scripts here.
        📄 build.dart
    📁  lib                           // Use your assets here.
        📄 example.dart
    📁  src                           // Add native sources here.
        📄 example_native_library.c
        📄 example_native_library.h
    📁  test                          // Test your assets here.
        📄 example_test.dart
```

## Hooks

Atualmente, o build hook está disponível, mas mais estão
planejados. Para saber mais, consulte o seguinte.

### Build hooks {:.no_toc}

Com build hooks, um pacote pode fazer coisas como
compilar ou baixar native assets como bibliotecas C ou Rust.
Depois disso, esses assets podem ser chamados do código Dart de
um pacote.

O build hook de um pacote é automaticamente invocado pelo
Dart SDK em um momento apropriado durante o processo de build.
Build hooks são executados em paralelo com a compilação Dart e
podem fazer operações de longa duração, como download ou
chamar um compilador nativo.

Use a função [`build`][] para analisar o
input do hook com [`BuildInput`] e então escrever o output do hook
com [`BuildOutputBuilder`]. O hook deve colocar
assets baixados e gerados em
[`BuildInput.sharedOutputDirectory`][].

Os assets produzidos para seu pacote podem depender de
[`assets`][] ou [`metadata`][] produzidos pelos build hooks
dos pacotes nas dependências diretas no pubspec. Portanto,
build hooks são executados na ordem das dependências no pubspec, e dependências
cíclicas entre pacotes não são suportadas ao usar hooks.

[`assets`]: {{site.pub-api}}/hooks/latest/hooks/BuildInput/assets.html
[`build`]: {{site.pub-api}}/hooks/latest/hooks/build.html
[`BuildInput`]: {{site.pub-api}}/hooks/latest/hooks/BuildInput-class.html
[`BuildOutputBuilder`]: {{site.pub-api}}/hooks/latest/hooks/BuildOutputBuilder-class.html
[`BuildInput.sharedOutputDirectory`]: {{site.pub-api}}/hooks/latest/hooks/HookInput/outputDirectoryShared.html
[`metadata`]: {{site.pub-api}}/hooks/latest/hooks/BuildInput/metadata.html

## Assets

Assets são os arquivos que são produzidos por um hook e então
empacotados em uma aplicação Dart. Assets podem ser acessados
em tempo de execução do código Dart. Atualmente, o Dart SDK pode
usar o tipo `CodeAsset`, mas mais tipos de assets estão planejados.
Para saber mais, consulte o seguinte.

### Tipo CodeAsset {:.no_toc}

Um [`CodeAsset`][] representa um code asset. Um code asset é uma biblioteca dinâmica
compilada de uma linguagem diferente de Dart, como C, C++, Rust ou Go.
`CodeAsset` faz parte do pacote `code_asset`. APIs fornecidas por code assets
são acessadas em tempo de execução através de membros Dart externos correspondentes anotados
com a anotação [`@Native`][] de `dart:ffi`.

[`CodeAsset`]: {{site.pub-api}}/code_assets/latest/code_assets/CodeAsset-class.html
[`@Native`]: {{site.dart-api}}/dart-ffi/Native-class.html

## Usar um hook {: #use-hooks-assets }

Para adicionar assets ao seu projeto, use um hook. Para detalhes,
consulte as seções seguintes.

### Adicionar dependências {: #add-dependencies-hooks-assets }

Para usar um hook, você deve primeiro adicionar os pacotes auxiliares
`hooks` e `code_assets` às dependências do seu `pubspec.yaml`:

1. `dart pub add hooks code_assets`.

Se você precisa compilar fontes C, você também precisará do pacote `native_toolchain_c`:

2. `dart pub add native_toolchain_c`.

:::note
Você precisa adicionar as dependências em `dependencies`, não
`dev_dependencies`. Os hooks serão executados por pacotes e
aplicações que dependem do seu pacote, então o
código Dart precisa fazer parte da resolução nesses
pacotes.
:::

Exemplo de dependências para um build hook:

```yaml title="pubspec.yaml"
name: native_add_library
description: Sums two numbers with native code.
version: 0.1.0

environment:
  sdk: '^3.9.0'

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
native assets (como bibliotecas C ou Rust), que então são
disponibilizados para serem chamados do código Dart de um pacote,
crie um script `build.dart` semelhante ao seguinte:

1.  No seu projeto Dart, crie ou abra `hooks/build.dart`.

1.  No método `main`, chame a função `build` de
    `package:hooks/hooks.dart` e use a toolchain apropriada
    para compilar a biblioteca nativa. Por exemplo:

    ```dart title="hooks/build.dart" highlightLines=6
    import 'package:hooks/hooks.dart';
    import 'package:logging/logging.dart';
    import 'package:native_toolchain_c/native_toolchain_c.dart';

    void main(List<String> args) async {
      await build(args, (input, output) async {
        final packageName = input.packageName;
        final cBuilder = CBuilder.library(
          name: packageName,
          assetName: '$packageName.dart',
          sources: ['src/$packageName.c'],
        );
        await cBuilder.run(
          input: input,
          output: output,
          logger: Logger('')
            ..level = Level.ALL
            ..onRecord.listen((record) => print(record.message)),
        );
      });
    }
    ```

    O segundo parâmetro de `build` espera uma função para a qual passará dois
    argumentos:

    * `input`: O input somente leitura para o hook.
      Inclui informações para o hook
      produzir o tipo de asset correto (por exemplo,
      sistema operacional alvo, arquitetura alvo, diretório de output, e
      mais). Para detalhes, consulte a classe [`BuildInput`][].

    * `output`: O builder somente escrita para o output do hook. Depois que o
      build hook lê o input, ele produz um asset e
      então fornece o que produziu como output.
      Para detalhes, consulte a classe [`BuildOutputBuilder`][].

[`BuildInput`]: {{site.pub-api}}/hooks/latest/hooks/BuildInput-class.html
[`BuildOutputBuilder`]: {{site.pub-api}}/hooks/latest/hooks/BuildOutputBuilder-class.html

### Assets empacotados automaticamente {: #generate-assets }

Os hooks são executados automaticamente ao invocar os comandos `run`, `build` ou `test`.
Os assets resultantes são armazenados no diretório de output especificado no
input do hook. O Dart SDK então automaticamente empacota esses assets com
seu aplicativo Dart para que possam ser acessados em tempo de execução.

### Usar assets {: #reference-assets }

Assets são os arquivos que os hooks criam. Uma vez que um asset é
criado, você pode referenciá-lo em seu código e em tempo de execução
com seu asset ID ([`assetId`][]). Asset IDs são estruturados
como `package:<package-name>/<asset-name>`. Build hooks podem
apenas produzir assets em seu próprio pacote. `CBuilder` no
build hook no exemplo anterior produz o asset ID
`package:native_add_library/native_add_library.dart`, e é
baseado no `packageName` e `assetName`.

O exemplo seguinte ilustra como fazer o binding para a função
C nativa `add` de `native_add_library.c` e chamá-la:

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

O asset ID em `@Native` é opcional e assume como padrão a
URI da biblioteca. No exemplo anterior, isso é
`package:native_add_library/native_add_library.dart`, que
é o mesmo asset ID produzido pelo build hook. Isso
permite ao Dart conectar um asset referenciado em tempo de execução ao
fornecido pelo hook durante o processo de build.

[`assetId`]: {{site.dart-api}}/dart-ffi/Native/assetId.html

### Testar assets {: #test-assets }

Depois de ter escrito um hook que gera um asset e
usado esse asset em seu código Dart, considere escrever
um teste para verificar se o hook e o asset gerado funcionam
como esperado.

No exemplo seguinte, um teste é criado para
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

## Projetos de exemplo

Existem vários projetos de exemplo para ajudá-lo a começar
com hooks e code assets:

| **Projeto**                  | **Descrição**                                                                         |
| ---------------------------- | --------------------------------------------------------------------------------------- |
| [`sqlite`][]                 | Um pacote compilando, empacotando e usando um mecanismo de banco de dados nativo.                       |
| [`mini_audio`][]             | Um pacote compilando, empacotando e usando um player de áudio nativo.                          |
| [`stb_image`][]              | Um pacote compilando, empacotando e usando uma biblioteca de imagens nativa.                         |
| [`host_name`][]              | Um pacote usando uma biblioteca de sistema nativa.                                                |
| [`native_add_library`][]     | Um pacote compilando, empacotando e usando código C simples.                             |
| [`native_add_app`][]         | Uma aplicação CLI Dart que depende de `native_add_library`.                            |
| [`download_asset`][]         | Um pacote empacotando e usando assets pré-compilados que são baixados no build hook.    |
| [`native_dynamic_linking`][] | Um pacote compilando, empacotando e usando três bibliotecas nativas que dependem umas das outras. |
| [`use_dart_api`][]           | Um pacote que usa a API C da Dart VM.                                           |

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

## Mais informações

Consulte os links seguintes para mais informações:

* [Pacote Hooks][Hooks package]
* [Referência da biblioteca Hooks][Hooks library reference]
* [Pacote Code assets][Code assets package]
* [Referência da biblioteca Code assets][Code assets library reference]
* [Interoperabilidade C][C interop]

[Hooks package]: {{site.pub-pkg}}/hooks
[Hooks library reference]: {{site.pub-api}}/hooks/latest/hooks/
[Code assets package]: {{site.pub-pkg}}/code_assets
[Code assets library reference]: {{site.pub-api}}/code_assets/latest/code_assets/
[C interop]: /interop/c-interop
