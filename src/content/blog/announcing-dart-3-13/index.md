---
ia-translate: true
title: "Anunciando o Dart 3.13"
description: "Trazendo concisão e simplicidade para bases de código, ferramentas e plataformas do Dart."
publishDate: 2026-08-12
author: conooi
image: images/dart3-13.webp
socialImage: images/dart3-13-cover.webp
category: releases
layout: blog
---

<DashImage
  src="images/dart3-13.webp"
  alt="Dart 3.13 release banner animation with the Dart logo."
  caption="Announcing Dart 3.13"
/>

Estamos muito animados em anunciar o Dart 3.13!

Nesta versão, celebramos um tema que todo desenvolvedor adora:
código limpo e leve.
O Dart 3.13 traz esse foco para todas as camadas da experiência do desenvolvedor.
Na linguagem, os construtores primários eliminam o código repetitivo,
para que você possa definir classes em uma única linha de código.
Nas ferramentas de desenvolvimento, melhorias no `dart format` mantêm seu código organizado
de acordo com as [regras de estilo do Effective Dart](https://dart.dev/effective-dart/style#ordering),
enquanto o `dart pub` introduz novos comandos de workspace para manter os monorepos em ordem.
No pub.dev, recursos de documentação mais ricos, como as tags `<callout-box>` e
as diretivas `{@example}`, tornam a documentação dos pacotes mais clara.
Por baixo dos panos, o tree-shaking de bibliotecas nativas (`@RecordUse`) e
o carregamento adiado do WebAssembly ajudam a manter
os binários compilados dos seus aplicativos o mais compactos possível.

Então, [atualize o Dart](https://dart.dev/get-dart) ou
rode o [`flutter upgrade`](https://docs.flutter.dev/install/upgrade)
e acompanhe enquanto exploramos as novidades do Dart 3.13!

## Atualizações da linguagem {:#language-updates}

### Construtores primários {:#primary-constructors}

Depois de uma prévia experimental no Dart 3.12,
os construtores primários agora são oficialmente estáveis no Dart 3.13!

Os construtores primários representam um grande avanço em concisão de classes.
Ouvimos dos desenvolvedores que repetir nomes e tipos de campos
no corpo das classes e nas listas de parâmetros pode ser cansativo.
Os construtores primários removem essa repetição, permitindo, por exemplo,
definir uma classe `Point` com dois campos e um construtor em uma única linha de código:

```dart
class Point(final int x, final int y);
```

Esse recurso também inclui
[sintaxe concisa para construtores](https://dart.dev/language/constructors#concise-constructor-syntax)
usando as palavras-chave `new` ou `factory`,
permitindo que declarações com corpo vazio terminem com `;`.

Para ajudar você a adotar os construtores primários e manter um estilo consistente
em toda a base de código, introduzimos vários novos lints com correções automáticas:

- [`empty_container_bodies`](https://dart.dev/tools/linter-rules/empty_container_bodies):
  Incentiva a brevidade, usando `;` em vez de `{}` em declarações do tipo classe.
- [`initialize_in_field_declaration`](https://dart.dev/tools/linter-rules/initialize_in_field_declaration):
  Incentiva a clareza, movendo a inicialização de campos
  de um construtor primário para a declaração do campo.
- [`unnecessary_const_in_enum_constructor`](https://dart.dev/tools/linter-rules/unnecessary_const_in_enum_constructor):
  Incentiva a brevidade, removendo `const` dos construtores de enums.
- [`unnecessary_primary_constructor_body`](https://dart.dev/tools/linter-rules/unnecessary_primary_constructor_body):
  Incentiva a brevidade, removendo corpos de construtores primários desnecessários.
- [`unnecessary_type_name_in_constructor`](https://dart.dev/tools/linter-rules/unnecessary_type_name_in_constructor):
  Incentiva a brevidade, substituindo o nome do tipo
  por `new` nas declarações de construtores.
- [`use_declaring_parameters`](https://dart.dev/tools/linter-rules/use_declaring_parameters):
  Incentiva a brevidade, usando parâmetros declarativos sempre que possível.

Junto com esses lints, também adicionamos novas refatorações na IDE
para automatizar a migração do seu código:

- **Converter para construtor primário**:
  Converte um construtor elegível, definido no corpo da classe, em um construtor primário.
- **Converter para construtor no corpo da classe**:
  Converte um construtor primário em um construtor definido no corpo da classe.
- **Converter para parâmetro declarativo**:
  Converte um parâmetro não declarativo de um construtor primário em
  um parâmetro declarativo.
- **Mover a inicialização para a declaração do campo**:
  Move a inicialização do campo da lista de inicializadores do construtor para
  a declaração do campo.

**Saiba mais:** [documentação de construtores primários](https://dart.dev/language/primary-constructors)

## Atualizações da plataforma web {:#web-platform-updates}

### Prévia do carregamento adiado (deferred loading) do WebAssembly {:#webassembly-deferred-loading-preview}

Temos trabalhado duro para expandir as capacidades do WebAssembly para o Dart na web.
No Dart 3.13, estamos felizes em compartilhar uma prévia inicial do
suporte a carregamento adiado ao compilar com `dart2wasm`.
Você pode habilitá-lo hoje usando a flag experimental do compilador:

```bash
dart compile wasm -O2 --enable-deferred-loading
```

:::note
O carregamento adiado exige que o embedder do seu aplicativo forneça um callback
responsável por carregar os bytes dos módulos Wasm.
Para mais detalhes, consulte a documentação de `CompiledApp.instantiate`
no arquivo `<app>.mjs` gerado para o seu aplicativo.
:::

Em aplicações grandes que usam carregamento adiado, o `dart2wasm` oferece melhorias
significativas no tempo de carregamento inicial da página (IPL) em comparação com o `dart2js`,
beneficiando tanto apps web com Flutter quanto aplicações web baseadas em DOM.

Como lembrete, as bibliotecas web legadas, como `dart:html` e `package:js`,
não são suportadas pelo `dart2wasm` e foram descontinuadas no Dart 3.7
(e deixarão de funcionar no `dart2js` no futuro).
Muitos pacotes já foram migrados,
então atualizar as dependências do seu pacote costuma resolver os problemas automaticamente.
No entanto, se o seu código usa diretamente essas bibliotecas legadas,
confira nossos guias de migração para adotar hoje as bibliotecas suportadas
[`dart:js_interop`](https://dart.dev/interop/js-interop) e
[`package:web`](https://dart.dev/interop/js-interop/package-web).

**Saiba mais:** [documentação do WebAssembly](https://dart.dev/web/wasm)

## Atualizações do núcleo e do runtime {:#core-engine-and-runtime-updates}

### Destaques de engenharia {:#engineering-highlights}

Paralelamente ao progresso na plataforma web, nossa equipe está constantemente melhorando
a base do Dart.
Aqui estão alguns destaques do que trabalhamos nos bastidores
nos últimos três meses:

- **Correção de solidez na promoção de tipos**:
  Corrigimos um [caso raro de falta de solidez](https://github.com/dart-lang/sdk/issues/62889)
  na promoção de tipos envolvendo funções aninhadas.
- **Refatoração do front-end comum**:
  Refatoramos componentes internos do front-end comum para
  permitir maior compartilhamento de código com o analyzer do Dart.
- **Unificação do sistema de módulos do DDC**:
  Continuamos removendo sistemas de módulos legados do Dart Development Compiler (DDC)
  nas ferramentas, para estabelecer um único sistema de módulos unificado.
- **Segurança de memória do runtime nativo**:
  Melhoramos a segurança de memória do runtime nativo
  introduzindo uma “gaiola de memória” (memory cage) ao redor do heap do Dart.
- **Vinculação dinâmica de módulos**:
  Iniciamos experimentos com
  [módulos dinâmicos](https://github.com/dart-lang/sdk/blob/f29989d506b2dd82957da5d1917bcc76628c5ddb/pkg/dynamic_modules/README.md)
  para permitir a vinculação dinâmica de código, abrindo caminho para
  fluxos de trabalho de desenvolvimento melhores, como o compartilhamento rápido de protótipos dentro de uma equipe.

## Atualizações de ferramentas {:#tools-updates}

### Formatador do Dart {:#dart-formatter}

Manter as bases de código organizadas e fáceis de ler é prioridade máxima para o `dart format`.
No Dart 3.13, introduzimos alguns ajustes de estilo
para deixar o código formatado ainda mais limpo.
Embora a maioria das mudanças seja pequena, algumas atualizações importantes vão tornar
seu código do dia a dia visivelmente mais fácil de ler:

- **Correção de formatação incorreta em chamadas de método**:
  Corrigimos um bug em que uma otimização às vezes era aplicada
  de forma errada e formatava o código incorretamente.
  Isso acontece principalmente em chamadas de método que contêm literais de coleção grandes:

  ```dart
  // Before:
  await MethodChannelContainer()
      .onMethodChannelInvoke('reportCrash', <String, Object?>{
        'time': nowTime,
        'errorValue': errorName,
        'reason': reason,
        'stacktrace': stacktrace,
      });

  // After:
  await MethodChannelContainer().onMethodChannelInvoke(
    'reportCrash',
    <String, Object?>{
      'time': nowTime,
      'errorValue': errorName,
      'reason': reason,
      'stacktrace': stacktrace,
    },
  );
  ```

- **Heurísticas para quebrar cadeias de métodos**:
  Mudamos as heurísticas que decidem se o formatador quebra uma cadeia de chamadas de método
  no `.` ou dentro de uma das listas de argumentos. Se o alvo da cadeia for um literal de coleção
  ou uma chamada de função com um único elemento ou argumento, agora o formatador prefere quebrar
  a cadeia em vez do alvo:

  ```dart
  // Before, split the target:
  function(
    argument,
  ).method().another();

  // After, split the chain:
  function(argument)
      .method()
      .another();
  ```

- **Separação de seções nos imports**:
  O formatador agora insere uma linha em branco
  entre as diferentes “seções” de uma série de imports.
  Ele não ordena os imports,
  mas agora os separa,
  de acordo com [as regras do Effective Dart](https://dart.dev/effective-dart/style#ordering):

  ```dart
  // Before:
  import 'dart:io';
  import 'dart:math';
  import 'package:args/args.dart';
  import 'package:test/test.dart';
  import 'my_library.dart';

  // After:
  import 'dart:io';
  import 'dart:math';

  import 'package:args/args.dart';
  import 'package:test/test.dart';

  import 'my_library.dart';
  ```

Há outros ajustes de estilo descritos no
[changelog do `dart_style`](https://pub.dev/packages/dart_style/changelog#3110),
mas essas são as mudanças mais visíveis.
Sabemos que mudanças de formatação podem causar ruído incômodo,
então tentamos ser conservadores ao alterar o estilo.
Ao mesmo tempo, uma melhoria de estilo pode tornar o código mais fácil de ler,
o que é um benefício valioso em uma época em que todos revisamos mais código do que nunca
graças à IA generativa.
Além da correção de otimização, essas mudanças de estilo são
[versionadas por linguagem](https://dart.dev/language/versioning).
Você só as verá depois de atualizar seu código para o Dart 3.13.

**Saiba mais:** [documentação do formatador do Dart](https://dart.dev/tools/dart-format)

### Atualizações do pub {:#pub-updates}

#### Atualizações da documentação de pacotes {:#package-documentation-updates}

Uma documentação de pacote clara e bem estruturada é
essencial para um ecossistema saudável.
Para ajudar os autores de pacotes a criar documentação mais limpa e fácil de manter, o pub.dev agora
oferece suporte às tags `<callout-box>` e às diretivas `{@example}` de ponta a ponta.
Você pode extrair trechos de código diretamente de arquivos de exemplo
para a sua documentação da API, ocultando o código repetitivo desnecessário.

Por exemplo, defina uma região de trecho em `example/foo.dart`:

```dart
// example/foo.dart
void main() {
  // #region abc
  // Included in documentation
  foo();
  assert(false); // #hide
  // #endregion
}
```

Depois, faça referência a essa região nos seus comentários de documentação em Dart:

```dart
/// This is a great function.
///
/// Example usage:
/// {@example /example/foo.dart#abc}
void foo() {}
```

O pub.dev renderiza a região de código especificada diretamente
na documentação gerada.

<DashImage
  src="images/pub-doc-callout-example.webp"
  alt="The cupertino_ui documentation on pub.dev displaying a 'callout-box' element with a blue border alongside an embedded '{@example}' code block."
  caption="The cupertino_ui documentation on pub.dev displaying a `<callout-box>` with a blue border alongside an embedded `{@example}` code block."
/>

Nos bastidores, o pub.dev também implantou um
índice de hash de dois níveis para a busca de arquivos do dartdoc.
Essa atualização acelera drasticamente a renderização da documentação para
pacotes grandes com mais de 100 mil arquivos gerados.

<DashImage
  src="images/pub-latency-blob-index.webp"
  alt="Chart showing Docs Request Latency drop after deploying the new blob index."
  caption="Docs Request Latency drop after deploying the new blob index."
/>

**Saiba mais:** [documentação da classe `CupertinoActivityIndicator`](https://pub.dev/documentation/cupertino_ui/latest/cupertino_ui/CupertinoActivityIndicator-class.html)

## Interoperabilidade nativa {:#native-interop-updates}

### Tree-shaking de bibliotecas nativas com `@RecordUse` e `package:record_use` {:#tree-shaking-native-libraries-with-recorduse-and-package-record_use}

Nosso compromisso com a eficiência chega até os binários compilados dos seus aplicativos.
Ao construir apps Dart e Flutter que interoperam com código nativo em C, C++ ou Rust usando
`dart:ffi` e Code Assets, o compilador Dart sempre fez tree-shaking das funções wrapper
do Dart não utilizadas.
No entanto, o código nativo subjacente tradicionalmente permanecia empacotado por inteiro.

Com `@RecordUse` (em `package:meta`) e `package:record_use`,
o Dart e o Flutter agora podem fazer tree-shaking das bibliotecas nativas junto com o seu código Dart.
Isso garante que o pacote final do seu aplicativo contenha apenas
o código nativo que ele realmente invoca.

#### Como funciona {:#how-it-works}

1.  **Anote as vinculações FFI nativas com `@RecordUse()`**:
    Marque suas vinculações FFI nativas (como as geradas pelo `ffigen`)
    com a anotação `@RecordUse()`:

    ```dart
    import 'dart:ffi';
    import 'package:meta/meta.dart';

    @RecordUse()
    @Native<Int32 Function(Int32, Int32)>()
    external int sqlite3_open(
      Pointer<Utf8> filename,
      Pointer<Pointer<sqlite3>> ppDb,
    );

    @RecordUse()
    @Native<Int32 Function(Pointer<sqlite3>)>()
    external int sqlite3_close(Pointer<sqlite3> db);
    ```

2.  **Rastreie as chamadas alcançáveis durante a compilação**:
    Durante a compilação de programa inteiro e o tree-shaking nos builds AOT do Dart,
    o compilador rastreia quais vinculações anotadas com `@RecordUse()`
    são alcançáveis no código executável.
    Chamadas que estão em código Dart não utilizado, removido pelo tree-shaking,
    são excluídas automaticamente.

3.  **Remova os símbolos nativos não utilizados no seu link hook**:
    No link hook do seu pacote (`hook/link.dart`),
    obtenha `input.recordedUses`.
    Usando `package:record_use`,
    consulte as chamadas registradas e instrua seu toolchain nativo
    (como `package:native_toolchain_c` ou um script de build em Rust)
    a manter apenas os símbolos que o Dart realmente chama:

    ```dart
    import 'package:hooks/hooks.dart';
    import 'package:native_toolchain_c/native_toolchain_c.dart';
    import 'package:record_use/record_use.dart';
    import 'package:my_package/src/c_library.dart';
    import 'package:my_package/src/record_use_mapping.dart';

    void main(List<String> arguments) async {
      await link(arguments, (input, output) async {
        // Extract symbols for functions called in reachable Dart code:
        final symbolsToKeep = input.recordedUses?.calls.keys
            .cast<Method>()
            .map((method) => recordUseMapping[method.name]!);

        await cLibrary.link(
          input: input,
          output: output,
          linkerOptions: LinkerOptions.treeshake(
            symbolsToKeep: symbolsToKeep,
          ),
        );
      });
    }
    ```

#### Por que isso importa {:#why-this-matters}

- **Binários muito menores**:
  Dependências nativas pesadas, como SQLite, criptografia, decodificadores de imagem
  ou motores de áudio, expõem centenas de funções.
  Durante os builds de release, o linker remove o código nativo não referenciado,
  os arquivos objeto mortos e as exportações não utilizadas.
- **Omissão completa de bibliotecas nativas não utilizadas**:
  Se o seu aplicativo nunca invoca as vinculações nativas de um pacote,
  o link hook remove o binário nativo por completo
  do pacote final do aplicativo.
- **Integração fluida com as ferramentas**:
  Ferramentas como o `ffigen` anotam automaticamente as vinculações geradas,
  enquanto o `package:native_toolchain_c` se integra diretamente aos link hooks
  para o tree-shaking nativo de ponta a ponta.

**Saiba mais:** [documentação dos link hooks nativos](https://dart.dev/tools/hooks#link-hooks)
e [documentação do Record use](https://pub.dev/packages/record_use)

## Para encerrar {:#wrap-up}

O Dart 3.13 torna realidade nossa visão de uma experiência de desenvolvimento mais simples e limpa.
Ao conectar recursos expressivos da linguagem, como os construtores primários,
a ferramentas mais inteligentes, documentação mais rica no pub.dev
e tree-shaking nativo compacto, esta versão ajuda você a
focar no que mais importa: construir ótimos apps.

Tudo nesta versão foi informado pelos seus insights do mundo real,
relatórios de bugs e contribuições para pacotes.
O ecossistema Dart prospera graças à sua participação ativa,
e somos profundamente gratos pela sua parceria
na definição de para onde a linguagem vai a seguir.

Mal podemos esperar para ver o que você vai criar com o Dart 3.13!
Reserve um momento para [atualizar o Dart](https://dart.dev/get-dart)
ou rodar o [`flutter upgrade`](https://docs.flutter.dev/install/upgrade) hoje,
e participe da conversa no
nosso [issue tracker no GitHub](https://github.com/dart-lang/sdk/issues).
Obrigado por ser uma comunidade tão apaixonada e por
construir o futuro do Dart conosco!

**Saiba mais:** [changelog do SDK do Dart](https://github.com/dart-lang/sdk/blob/main/CHANGELOG.md#3130)
