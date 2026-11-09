---
ia-translate: true
title: Novidades
description: Uma lista do que há de novo no dart.dev e em sites relacionados.
lastVerified: 2026-08-12
---

Esta página descreve o que há de novo no site e no blog do Dart.
Para ver as novidades do Flutter, visite a
[página de novidades do Flutter.][flutter-whats-new]

Para uma lista das mudanças na linguagem Dart em cada Dart SDK, veja o
[changelog do Dart][dart-changelog].
Para ficar por dentro dos anúncios, incluindo breaking changes,
participe do [grupo Google de anúncios do Dart][dart-announce]
e siga o [blog do Dart][Dart blog].

[flutter-whats-new]: {{site.flutter-docs}}/whats-new
[dart-changelog]: /changelog
[dart-announce]: https://groups.google.com/a/dartlang.org/d/forum/announce
[Dart blog]: /blog

## Versão 3.13 {:#3-13-release}

_Lançada em: 12 de agosto de 2026_

Esta seção lista mudanças notáveis feitas de 18 de maio de 2026
até 12 de agosto de 2026 no [dart.dev](https://dart.dev/docs).
Para detalhes sobre a versão 3.13 do Dart,
confira o [anúncio do 3.13][3.13 announcement] e o
[changelog do SDK 3.13][3-13-changelog].

[3.13 announcement]: /blog/announcing-dart-3-13
[3-13-changelog]: {{site.repo.dart.sdk}}/blob/main/CHANGELOG.md#3130

### Atualizações da documentação {:.no_toc} {:#documentation-updates}

* Expandimos a documentação do novo recurso de linguagem [construtores primários][primary constructors],
  incluindo seções sobre enums e construtores constantes.
* Adicionamos um novo guia de solução de problemas sobre
  [motivos pelos quais uma variável não pode ser promovida][non-promotion reasons]
  para ajudar a diagnosticar falhas de promoção de tipo.
* Recomendamos declarar construtores dentro de classes usando a nova
  [sintaxe concisa de construtores][concise constructor syntax] no Effective Dart.
* Expandimos a documentação dos native build hooks para cobrir a
  [configuração de user-defines][user-defines] no `pubspec.yaml` e o uso de
  [link hooks][link hooks] com uso registrado para tree-shaking de código nativo.
* Detalhamos o comportamento de verificação de tipos em tempo de execução do WebAssembly e adicionamos
  exemplos de binding de Zone na documentação de [JavaScript e interop com Web][js interop].
* Documentamos o [suporte experimental a deferred loading para WebAssembly][wasm deferred loading].
* Unificamos a documentação de distribuição da linha de comando do Dart
  em torno do [`dart install`][dart install].
* Esclarecemos a diferença entre instâncias de `Error` e `Exception`
  no [tutorial de tratamento de erros][error handling tutorial].
* Adicionamos links e dicas rápidas para iniciantes
  na [página de visão geral da documentação][overview].
  (Obrigado, [Syed Muhammad Mobasil][Mobasil-Git].)
* Atualizamos as diretrizes sobre [nomenclatura de métodos e funções][naming methods]
  no Effective Dart.
  (Obrigada, [Polina Cherkasova][polina-c].)
* Adicionamos o [Publy][] à lista de
  [serviços de repositório de pacotes Dart][package repositories] hospedados.
  (Obrigado, [Timophei Lemeshchenko][Another1dd].)
* Expandimos o [Glossário][Glossary] com novos termos de linguagem e web,
  incluindo "[dot shorthand][]", "[extension type][]",
  "[primary constructor][]", "[private named parameter][]",
  "[potentially constant][]" e "[WebAssembly (Wasm)][]".

[primary constructors]: /language/primary-constructors
[non-promotion reasons]: /tools/non-promotion-reasons
[concise constructor syntax]: /effective-dart/usage#prefer-using-concise-constructor-syntax
[user-defines]: /tools/hooks#hook-configuration
[link hooks]: /tools/hooks#create-link-hook
[js interop]: /interop/js-interop/js-types
[wasm deferred loading]: /web/wasm#webassembly-support
[dart install]: /tools/dart-install
[error handling tutorial]: /learn/tutorial/error-handling
[overview]: /overview
[naming methods]: /effective-dart/design#avoid-starting-a-method-name-with-get
[Publy]: https://publy.dev
[package repositories]: /tools/pub/custom-package-repositories
[Glossary]: /resources/glossary
[dot shorthand]: /resources/glossary#dot-shorthand
[extension type]: /resources/glossary#extension-type
[primary constructor]: /resources/glossary#primary-constructor
[private named parameter]: /resources/glossary#private-named-parameter
[potentially constant]: /resources/glossary#potentially-constant
[WebAssembly (Wasm)]: /resources/glossary#webassembly-wasm

[Mobasil-Git]: https://github.com/Mobasil-Git
[polina-c]: https://github.com/polina-c
[Another1dd]: https://github.com/Another1dd

## Versão 3.12 {:#3-12-release}

_Lançada em: 18 de maio de 2026_

Esta seção lista mudanças notáveis feitas de 12 de fevereiro de 2026
até 18 de maio de 2026 no [dart.dev](https://dart.dev/docs).
Para detalhes sobre a versão 3.12 do Dart,
confira o [anúncio do 3.12][3.12 announcement] e o
[changelog do SDK 3.12][3-12-changelog].

[3.12 announcement]: /blog/announcing-dart-3-12
[3-12-changelog]: {{site.repo.dart.sdk}}/blob/main/CHANGELOG.md#3120

### Atualizações da documentação {:.no_toc} {:#documentation-updates}

* Adicionamos a documentação do novo recurso de linguagem [parâmetros nomeados privados][private named parameters].
* Adicionamos a documentação do recurso experimental de linguagem [construtores primários][primary constructors].
* Criamos uma página dedicada de [versionamento da linguagem][language versioning] e atualizamos os links em
  todo o site.
* Documentamos o suporte do Dart ao [Firebase Functions][Firebase Functions] e ao Admin SDK.
* Documentamos que os [workspaces do pub][pub workspaces] podem ser aninhados.
  (Obrigado, [Soufian El-Fouzari][SoufianElfouzari].)
* Documentamos a opção [`--no-example`][] dos comandos do pub.
* Centralizamos a documentação dos [descritores de pacote][package descriptors] do pub.
* Adicionamos a documentação sobre restrições para os [nomes de dylib de code assets][code asset dylib names]
  dos build hooks.
* Atualizamos a [lição de programação orientada a objetos][object-oriented programming lesson] do tutorial
  e melhoramos a formatação dela.
* Expandimos o [Glossário][Glossary] com novos termos, incluindo "top type", "null safety",
  "sound", "reified generics" e "uninitialized".
  (Obrigado, [IldySilva][].)
* Adicionamos mais [soluções comunitárias de interop][community interop solutions] à documentação.
  (Obrigada, [ANUSHREE BONDIA][Anushreebasics].)
* Removemos e arquivamos a documentação legada de [migração para null safety][null safety migration].

### Melhorias no site {:.no_toc} {:#site-improvements}

* Criamos um espaço dedicado para o [blog do Dart][Dart blog space] em `/blog`,
  migrando todas as publicações históricas do Medium.
* Implementamos prefetch e prerendering de páginas para uma navegação mais rápida em todo
  o site.

[primary constructors]: /language/primary-constructors
[private named parameters]: /language/constructors#private-named-parameters
[language versioning]: /language/versioning
[Firebase Functions]: /server/google-cloud#cloud-functions-for-firebase
[pub workspaces]: /tools/pub/workspaces#nested-workspaces
[`--no-example`]: /tools/pub/cmd/pub-get#no-example
[package descriptors]: /tools/pub/dependencies#package-descriptors
[code asset dylib names]: /tools/hooks#create-hook
[object-oriented programming lesson]: /learn/tutorial/object-oriented
[Glossary]: /resources/glossary
[top type]: /resources/glossary#top-type
[null safety]: /resources/glossary#null-safety
[sound]: /resources/glossary#sound
[reified generics]: /resources/glossary#reified-generics
[uninitialized]: /resources/glossary#uninitialized
[community interop solutions]: /interop#community-interop
[null safety migration]: https://github.com/dart-community/migrate-to-null-safety
[Dart blog space]: /blog

[SoufianElfouzari]: https://github.com/SoufianElfouzari
[IldySilva]: https://github.com/IldySilva
[Anushreebasics]: https://github.com/Anushreebasics

## Versão 3.11 {:#3-11-release}

_Lançada em: 11 de fevereiro de 2026_

Esta seção lista mudanças notáveis feitas de 13 de novembro de 2025
até 11 de fevereiro de 2026 no [dart.dev](https://dart.dev/docs).
Para detalhes sobre a versão 3.11 do Dart,
confira o [anúncio do 3.11][3.11 announcement] e o
[changelog do SDK 3.11][3-11-changelog].

[3.11 announcement]: /blog/announcing-dart-3-11
[3-11-changelog]: {{site.repo.dart.sdk}}/blob/main/CHANGELOG.md#3110

### Atualizações da documentação {:.no_toc} {:#documentation-updates}

*   Lançamos uma nova [experiência de primeiros passos][learn] para aprender Dart.
*   Atualizamos a [página do IntelliJ e Android Studio][IntelliJ & Android Studio page] após a
    transição do plugin do Dart para a equipe Dart.
*   Adicionamos documentação sobre as variáveis de ambiente disponíveis para os
    [build hooks][build hooks] do Dart.
*   Incluímos instruções de configuração de "Format on save" para IDEs
    na página do [dart format][dart format].
    (Obrigada, [Anushree Bondia](https://github.com/Anushreebasics).)
*   Expandimos o [Glossário][Glossary] com novos termos, incluindo "dependency graph",
    "AOT", "JIT", "interop" e "scope".
    (Obrigado, [IldySilva](https://github.com/IldySilva)
    e [Anushree Bondia](https://github.com/Anushreebasics).)

[learn]: /learn
[Glossary]: /resources/glossary
[IntelliJ & Android Studio page]: /tools/jetbrains-plugin
[build hooks]: /tools/hooks
[dart format]: /tools/dart-format

## Versão 3.10 {:#3-10-release}

_Lançada em: 12 de novembro de 2025_

Esta seção lista mudanças notáveis feitas de 14 de agosto de 2025
até 12 de novembro de 2025 no [dart.dev](https://dart.dev/docs).
Para detalhes sobre a versão 3.10 do Dart,
confira o [anúncio do 3.10][3.10 announcement] e o
[changelog do SDK 3.10][3-10-changelog].

[3.10 announcement]: /blog/announcing-dart-3-10
[3-10-changelog]: {{site.repo.dart.sdk}}/blob/main/CHANGELOG.md#3100

### Atualizações da documentação {:.no_toc} {:#documentation-updates}

*   Adicionamos um guia para o novo recurso de linguagem [dot shorthands][].
*   Adicionamos um guia para o novo suporte a [plugins do analyzer][analyzer plugin].
*   Adicionamos a referência da ferramenta [`dart build`][].
*   Adicionamos a referência da ferramenta [`dart install`][].
*   Documentamos as novas variedades da [anotação `@Deprecated`][`@Deprecated` annotation].
*   Expandimos o [Glossário][Glossary] com novos termos, incluindo "obviously typed",
    "closurization", "callback", "tree shaking" e "native asset".
    (Obrigado, [IldySilva](https://github.com/IldySilva))

[dot shorthands]: /language/dot-shorthands
[analyzer plugin]: /tools/analyzer-plugins
[`dart build`]: /tools/dart-build
[`dart install`]: /tools/dart-install
[`@Deprecated` annotation]: /language/metadata
[Glossary]: /resources/glossary

### Melhorias no site {:.no_toc} {:#site-improvements}

*   Migramos a infraestrutura central do site para o [framework Jaspr][Jaspr migration]
    para melhorar a experiência de quem contribui.
*   Melhoramos o Glossário com a nova [filtragem por rótulo][Glossary filtering]
    e [tooltips][Glossary tooltips].
*   Redesenhamos a [página da Comunidade][Community page redesign] com um layout moderno
    baseado em cards.
*   Começamos a compilar o código Dart do lado do cliente para [Wasm][Wasm compilation].

[Jaspr migration]: https://jaspr.site
[Table of Contents extension]: {{site.repo.this}}/pull/6886
[Glossary filtering]: {{site.repo.this}}/pull/6945
[Glossary tooltips]: {{site.repo.this}}/pull/6969
[Community page redesign]: {{site.repo.this}}/pull/6900
[Wasm compilation]: {{site.repo.this}}/pull/6953

### Artigos adicionados ao blog do Dart {:.no_toc} {:#articles-added-to-the-dart-blog}

Publicamos os seguintes artigos no blog do Dart:

* [Resultados do Google Summer of Code 2025][blog-10-21-25]

[blog-10-21-25]: /blog/google-summer-of-code-2025-results

## Versão 3.9 {:#3-9-release}

_Lançada em: 13 de agosto de 2025_

Esta seção lista mudanças notáveis feitas de 20 de maio de 2025
até 13 de agosto de 2025 no [dart.dev](https://dart.dev/docs).
Para detalhes sobre a versão 3.9 do Dart,
confira o [anúncio do 3.9][3.9 announcement] e o
[changelog do SDK 3.9][3-8-changelog].

### Documentação atualizada ou adicionada ao dart.dev {:.no_toc} {:#docs-updated-or-added-to-dart-dev}

Além de correções de bugs e melhorias incrementais,
fizemos as seguintes mudanças na documentação deste site:

* [Habilitamos breadcrumbs por padrão][Enabled breadcrumbs by default] em todo o site.
* Atualizamos a [documentação do `dart compile`][`dart compile` documentation] para cross-compilation para ARM e
  RISC-V64.
* Reformulamos a [documentação de metadata e annotations][metadata and annotations documentation].
* Reestruturamos a [página do `dart create`][`dart create` page] para explicar melhor os templates.
* Adicionamos um [guia abrangente do Dart MCP Server][Dart MCP Server guide].
* Expandimos o [glossário][glossary] com "combinator", "bottom type", "context type",
  "shadowing", "immutable", "wildcard", "late", "zone" e
  "type alias". (Obrigado, [IldySilva](https://github.com/IldySilva))
* Atualizamos a [documentação do JNIGen][JNIGen documentation] para remover uma referência desatualizada ao Maven.

[JNIGen documentation]: /interop/java-interop
[`dart compile` documentation]: /tools/dart-compile
[Dart MCP Server guide]: {{site.flutter-docs}}/ai/mcp-server
[`dart create` page]: /tools/dart-create
[metadata and annotations documentation]: /language/metadata
["external resource type"]: {{site.repo.this}}/pull/6762
[Enabled breadcrumbs by default]: {{site.repo.this}}/pull/6767
[glossary]: /resources/glossary

[3.9 announcement]: /blog/announcing-dart-3-9
[3-9-changelog]: {{site.repo.dart.sdk}}/blob/main/CHANGELOG.md#390

## Versão 3.8 {:#3-8-release}

_Lançada em: 20 de maio de 2025_

Esta seção lista mudanças notáveis feitas de 13 de fevereiro de 2025
até 20 de maio de 2025 no [dart.dev](https://dart.dev/docs).
Para detalhes sobre a versão 3.8 do Dart,
confira o [anúncio do 3.8][3.8 announcement] e o
[changelog do SDK 3.8][3-8-changelog].

### Documentação atualizada ou adicionada ao dart.dev {:.no_toc} {:#docs-updated-or-added-to-dart-dev}

Além de correções de bugs e melhorias incrementais,
fizemos as seguintes mudanças na documentação deste site:

* Adicionamos a documentação de [Collection elements][3-8-c-elements],
  que inclui os vários tipos de elementos de coleção: elementos de expressão, elementos de entrada de map,
  elementos de spread, elementos de spread com null-aware, elementos if e
  elementos for. A nova documentação também explica como aninhar
  elementos.

* Adicionamos a documentação de [Doc imports][], que explica como usar a
  tag de documentação `@docImport` para referenciar elementos externos
  em comentários de documentação.

* Adicionamos a documentação de [Cross-compilation][] para o comando
  `dart compile`. A cross-compilation para Linux x64 e ARM64 agora é
  suportada nos seguintes sistemas operacionais host de 64 bits:
  macOS, Windows e Linux.

* Adicionamos a documentação de [Null-aware elements][3-8-null-aware], que
  explica como usar o elemento null-aware.

* Adicionamos a documentação de [Labels][] para loops. Essa adição mostra como
  usar labels com as instruções de controle de fluxo `break` e `continue`.

* Adicionamos a documentação do arquivo [`pubspec_overrides.yaml`][]. Esse arquivo
  permite sobrescrever certos aspectos do arquivo `pubspec.yaml` sem alterar
  o próprio `pubspec.yaml`.

* Adicionamos a documentação de [Inference using bounds][] para o
  sistema de tipos.

* Adicionamos a documentação de [Records como estruturas de dados simples][Records as simple data structures] para
  tipos record.

* Adicionamos a documentação de [restrições de parâmetros de tipo autorreferenciados (F-bounds)][Self-referential type parameter restrictions (F-bounds)]
  para tipos genéricos.

* Adicionamos a documentação de [Downcast implícito a partir de `dynamic`][Implicit downcast from `dynamic`], que
  explica como converter implicitamente expressões com tipo estático `dynamic`
  para um tipo mais específico.

* Adicionamos uma [política de suporte][support policy] para o Dart SDK.

* Atualizamos as orientações sobre quando e quando não usar
  class modifiers no guia [Effective Dart Design][].

* Atualizamos a orientação para preferir uma frase nominal ou uma frase verbal
  não imperativa para uma função ou método no guia [Effective Dart Documentation][]. Também incluímos
  várias pequenas mudanças nas orientações de documentação existentes.
  Para mais informações, veja o [PR 6522][].

* Mudamos a orientação para preferir uma frase nominal ou uma frase verbal
  não imperativa para uma função ou método no guia [Effective Dart Documentation][].

### Mudanças no site para o dart.dev {:.no_toc} {:#site-changes-for-dart-dev}

Além de correções de bugs e melhorias incrementais,
fizemos as seguintes mudanças estruturais neste site:

* Adicionamos um novo design baseado em cards e a possibilidade de pesquisar
  entradas no [glossário][glossary].

  <img src="/assets/img/whats-new/3-8-glossary.png" alt="Glossário" style="width:50%">

* Novos botões de página anterior e próxima para o site de documentação.

  <img src="/assets/img/whats-new/3-8-prev-next-buttons-new.png" alt="Novos botões de página" style="width:80%">

* Adicionamos páginas individuais para algumas [mensagens de diagnóstico][diagnostic messages].
  Para ver a página individual de uma mensagem de diagnóstico, selecione
  o botão **Learn more** dela.

  <img src="/assets/img/whats-new/3-8-diagnostic-docs.png" alt="Botão Learn more" style="width:50%">

[3.8 announcement]: /blog/announcing-dart-3-8
[3-8-changelog]: {{site.repo.dart.sdk}}/blob/main/CHANGELOG.md#380
[3-8-c-elements]: /language/collections#collection-elements
[3-8-null-aware]: /language/collections#null-aware-element
[glossary]: /resources/glossary
[Records as simple data structures]: /language/records#records-as-simple-data-structures
[Self-referential type parameter restrictions (F-bounds)]: /language/generics#f-bounds
[Inference using bounds]: /language/type-system#inference-using-bounds
[Effective Dart Design]: /effective-dart/design#do-use-class-modifiers-to-control-if-your-class-can-be-extended
[Effective Dart Documentation]: /effective-dart/documentation#prefer-a-noun-phrase-or-non-imperative-verb-phrase-for-a-function-or-method-if-returning-a-value-is-its-primary-purpose
[Labels]: /language/loops#labels
[`pubspec_overrides.yaml`]: /tools/pub/dependencies#pubspec-overrides
[support policy]: /tools/sdk#support-policy
[Implicit downcast from `dynamic`]: /language/type-system#implicit-downcasts-from-dynamic
[PR 6522]: {{site.repo.this}}/pull/6522
[Doc imports]: /tools/doc-comments/references#doc-imports
[Cross-compilation]: /tools/dart-compile
[diagnostic messages]: /tools/diagnostics

## Versão 3.7 {:#3-7-release}

_Lançada em: 12 de fevereiro de 2025_

Esta seção lista mudanças notáveis feitas de 12 de dezembro de 2024
até 12 de fevereiro de 2025.
Para detalhes sobre a versão 3.7 do Dart,
confira o [anúncio do 3.7][3.7 announcement] e o [changelog do SDK][3-7-changelog].

[3.7 announcement]: /blog/announcing-dart-3-7
[3-7-changelog]: {{site.repo.dart.sdk}}/blob/main/CHANGELOG.md#370

### Documentação atualizada ou adicionada ao dart.dev {:.no_toc} {:#docs-updated-or-added-to-dart-dev}

Além de correções de bugs e melhorias incrementais,
fizemos as seguintes mudanças neste site:

* Introduzimos o novo algoritmo do sistema de tipos, [inference using bounds][].
* Adicionamos links para nossa nova conta no [Bluesky][].
* Atualizamos a página do [`dart format`][] para refletir o novo estilo do formatador,
  incluindo o novo recurso de [tamanho de linha configurável][configurable line length].
* Documentamos o novo recurso de [opções de análise compartilhadas][shared analysis options].
* Alteramos o item do Effective Dart sobre [tamanho de linha][line length] por causa do
  novo estilo do formatador.
* Introduzimos os detalhes sobre [arquivos avulsos][stray files] na página de Workspaces.
* Adicionamos o novo recurso de linguagem [variáveis curinga][wildcard variables] na página de Variáveis.
* Movemos a [explicação de covariant][covariant explanation] para a página de Sistema de tipos, mais adequada.
* Alteramos as referências às bibliotecas de [interop JS legadas][legacy JS interop]
  para serem explicitamente "deprecated".
* Removemos a página de macros experimentais, pois a equipe
  [pausou indefinidamente][indefinitely paused] o trabalho no recurso.
* Adicionamos um [aviso][map-warn] de que desestruturar um padrão de Map com
  uma chave inexistente vai lançar um `StateError`.
* Reformulamos a página de [regras do linter][linter rules] com novos cards, formato de pesquisa e
  ícones coloridos nas páginas individuais de lint ([por exemplo][for example]).
* Redesenhamos a implementação do layout e a sidenav para mais eficiência.
* Removemos a página da biblioteca `dart:html`, oficialmente depreciada.

[inference using bounds]: /language/type-system/#type-argument-inference
[for example]: /tools/linter-rules/annotate_overrides
[Bluesky]: https://bsky.app/profile/dart.dev
[configurable line length]: /tools/dart-format#page-width
[shared analysis options]: /tools/analysis#including-shared-options
[line length]: /effective-dart/style#prefer-lines-80-characters-or-fewer
[stray files]: /tools/pub/workspaces#stray-files
[wildcard variables]: /language/variables#wildcard-variables
[covariant explanation]: /language/type-system#covariant-keyword
[legacy JS interop]: /interop/js-interop/past-js-interop
[indefinitely paused]: /blog/an-update-on-dart-macros-data-serialization
[map-warn]: /language/pattern-types#map

## Versão 3.6 {:#3-6-release}

_Lançada em: 11 de dezembro de 2024_

Esta seção lista mudanças notáveis feitas de 7 de agosto de 2024
até 11 de dezembro de 2024.
Para detalhes sobre a versão 3.6 do Dart,
confira o [anúncio do 3.6][3.6 announcement] e o [changelog do SDK][3-6-changelog].

[3.6 announcement]: /blog/announcing-dart-3-6
[3-6-changelog]: {{site.repo.dart.sdk}}/blob/main/CHANGELOG.md#360

### Documentação atualizada ou adicionada ao dart.dev {:.no_toc} {:#docs-updated-or-added-to-dart-dev}

Além de correções de bugs e melhorias incrementais,
fizemos as seguintes mudanças neste site:

* Documentamos o novo recurso [pub workspaces][].
* Explicamos a nova flag do `pub get` [`--enforce-lockfile`][].
* Introduzimos orientações sobre [comunicação síncrona][synchronous communication] entre isolates demais
  na página de Concorrência.
* Adicionamos o novo recurso de linguagem [separadores de dígitos][digit separators] à página de Tipos built-in.
* Definimos [variância e posições de variância][variance and variance positions] na página do glossário.
* Criamos uma nova página para o novo recurso de [referências em comentários de documentação][documentation comment references].
* Atualizamos e melhoramos o [gráfico de plataformas do Dart][Dart platforms graphic] para incluir o
  suporte recém-disponível à compilação para RISC-V e WASM.
* Definimos [tipos de função][function types].
* Adicionamos definições no glossário para os diferentes tipos de correções de código disponíveis
  no analyzer ([assists][], [refactors][] e [quick fixes][]).
* Criamos uma [página][bump-page] para o novo comando `pub bump`.
* Atualizamos o [exemplo de construtores generativos][example for generative constructors] para refletir o uso de
  parâmetros posicionais opcionais com valores padrão.
* Melhoramos a [documentação de import/export condicional][import/export documentation] na página de criação de pacotes.
* Incluímos anotações `@override` nos [exemplos de código de mixins][mixin code examples] para mostrar corretamente
  como trabalhar com funções mixadas.
* Oferecemos uma alternativa ao SSH para acessar dependências de repositórios privados na
  [página de dependências do pub][pub dependencies page].
* Adicionamos um novo aviso do `pub publish` sobre a validação de `git status` limpo à
  [lista de tarefas de publicação][publishing task list].
* Depreciamos as páginas de tour pela linguagem e pelas bibliotecas (o conteúdo agora está em páginas individuais
  em [Linguagem][lang-sidenav] e [Bibliotecas principais][lib-sidenav],
  no painel lateral esquerdo).

[pub workspaces]: /tools/pub/workspaces
[`--enforce-lockfile`]: /tools/pub/packages#get-dependencies-for-production
[synchronous communication]: /language/concurrency#synchronous-blocking-communication-between-isolates
[digit separators]: /language/built-in-types#digit-separators
[variance and variance positions]: /resources/glossary#variance
[documentation comment references]: /tools/doc-comments/references
[Dart platforms graphic]: /overview#platform
[function types]: /language/functions#function-types
[assists]: /resources/glossary#assist
[refactors]: /resources/glossary#refactor
[quick fixes]: /resources/glossary#quick-fix
[bump-page]: /tools/pub/cmd/pub-bump
[example for generative constructors]: /language/constructors#generative-constructors
[import/export documentation]: /tools/pub/create-packages#conditionally-importing-and-exporting-library-files
[mixin code examples]: /language/mixins
[pub dependencies page]: /tools/pub/dependencies#git-packages
[publishing task list]: /tools/pub/publishing#publish-to-pub-dev
[lib-sidenav]: /libraries
[lang-sidenav]: /language

## Versão 3.5 {:#3-5-release}

_Lançada em: 6 de agosto de 2024_

Esta seção lista mudanças notáveis feitas de 15 de maio de 2024
até 6 de agosto de 2024.
Para detalhes sobre a versão 3.5,
confira o [anúncio do 3.5][3.5 announcement] e o [changelog do SDK][3-5-changelog].

[3.5 announcement]: /blog/announcing-dart-3-5-and-an-update-on-the-dart-roadmap
[3-5-changelog]: {{site.repo.dart.sdk}}/blob/main/CHANGELOG.md#350---2024-08-06

### Documentação atualizada ou adicionada ao dart.dev {:.no_toc} {:#docs-updated-or-added-to-dart-dev}

Além de correções de bugs e melhorias incrementais,
fizemos as seguintes mudanças neste site:

* Esclarecemos o status e os usos pretendidos das
  [bibliotecas de plataforma web][web platform libraries], tanto as novas quanto as legadas.
* Expandimos a documentação sobre [publicação de versões prerelease][publishing prerelease versions]
  de pacotes no site pub.dev.
* Adicionamos uma página sobre o novo [comando `dart pub unpack`][`dart pub unpack` command].
* Documentamos a nova [flag `--skip-validation`][`--skip-validation` flag] do `dart pub publish` e
  a [flag `--tighten`][`--tighten` flag] do `dart pub downgrade`.
* Oferecemos orientações de boas práticas para autores de pacotes
  [testarem seus pacotes com dependências rebaixadas][test their package with downgraded dependencies].
* Melhoramos o guia [Corrigindo falhas de promoção de tipo][Fixing type promotion failures] e adicionamos
  destaque de código para indicar melhor o código relevante.
* Complementamos a [documentação de instalação do Dart][Dart installation documentation] com
  instruções de desinstalação e limpeza.
* Introduzimos novos documentos e exemplos de código sobre
  [tear-offs de função][func-tear] e [tear-offs de construtor][cons-tear].
* Explicamos como [exportar funções e objetos Dart para serem usados a partir de JS][export Dart functions and objects to be used from JS].
* Adicionamos entradas no glossário para [subclass][] e [subtype][],
  explicando os termos no contexto do Dart.

[web platform libraries]: /libraries#web-platform-libraries
[publishing prerelease versions]: /tools/pub/publishing#publishing-prereleases
[`dart pub unpack` command]: /tools/pub/cmd/pub-unpack
[`--skip-validation` flag]: /tools/pub/cmd/pub-lish#skip-validation
[`--tighten` flag]: /tools/pub/cmd/pub-downgrade#tighten
[test their package with downgraded dependencies]: /tools/pub/dependencies#test-with-downgraded-dependencies
[Fixing type promotion failures]: /tools/non-promotion-reasons
[Dart installation documentation]: /get-dart
[func-tear]: /language/functions#tear-offs
[cons-tear]: /language/constructors#constructor-tear-offs
[export Dart functions and objects to be used from JS]: /interop/js-interop/usage#export
[subclass]: /resources/glossary#subclass
[subtype]: /resources/glossary#subtype

## Versão 3.4 {:#3-4-release}

_Lançada em: 14 de maio de 2024_

Esta seção lista mudanças notáveis feitas de 16 de fevereiro de 2024
até 14 de maio de 2024.
Para detalhes sobre a versão 3.4,
confira o [post do blog sobre o 3.4][3.4 blog post] e o [changelog do SDK][3-4-changelog].

[3.4 blog post]: /blog/announcing-dart-3-4
[3-4-changelog]: {{site.repo.dart.sdk}}/blob/main/CHANGELOG.md#340---2024-05-14

### Documentação atualizada ou adicionada ao dart.dev {:.no_toc} {:#docs-updated-or-added-to-dart-dev}

Além de correções de bugs e melhorias incrementais,
fizemos as seguintes mudanças neste site:

* Adicionamos uma página documentando o recurso experimental de linguagem [Macros][].
* Adicionamos uma página para acompanhar os avanços do [Wasm][] no Dart.
* Refatoramos a página de [Construtores][Constructors].
* Esclarecemos as instruções na seção [Renames][] da página de migração para o `package:web`.
* Ajustamos a entrada do Effective Dart sobre [habilitar a promoção de tipo][enabling type promotion] para recomendar
  o padrão de null-check antes de outras construções.
* Revisamos a lista de [Bibliotecas e pacotes web][Web libraries and packages] para representar melhor as
  soluções recomendadas.
* Explicamos como desestruturar campos nomeados nas páginas de [Records][] e [Patterns][].
* Incluímos uma [tabela antes e depois][before-and-after table] das soluções web na página de interop com JS.
* Adicionamos uma seção explicando os [operadores spread][spread operators] na página de Operadores.
* Esclarecemos a ordem dos [padrões entre parênteses][parenthetical patterns] na página de tipos de padrão.
* Adicionamos documentação do [`ExternalDartReference`][] na página de tipos JS.
* Atualizamos o site para as novas [regras do linter][linter rules] e [mensagens de diagnóstico][diagnostic messages],
  por exemplo, adicionando documentação da nova mensagem de diagnóstico da anotação [`@mustBeConst`][].

[Macros]: /blog/an-update-on-dart-macros-data-serialization
[Wasm]: /web/wasm
[Constructors]: /language/constructors/
[Renames]: /interop/js-interop/package-web/#renames
[enabling type promotion]: /effective-dart/usage/#consider-type-promotion-or-null-check-patterns-for-using-nullable-types
[linter rules]: /tools/linter-rules/
[diagnostic messages]: /tools/diagnostic-messages/
[`@mustBeConst`]: /tools/diagnostic-messages/#non_const_argument_for_const_parameter
[Web libraries and packages]: /web/libraries/
[Records]: /language/records/#multiple-returns
[Patterns]: /language/patterns/#destructuring-multiple-returns
[before-and-after table]: /interop/js-interop/past-js-interop#next-generation-js-interop
[spread operators]: /language/operators/#spread-operators
[parenthetical patterns]: /language/pattern-types/#parenthesized
[`ExternalDartReference`]: /interop/js-interop/js-types/#jsboxeddartobject-vs-externaldartreference

### Artigos adicionados ao blog do Dart {:.no_toc} {:#articles-added-to-the-dart-blog}

Publicamos os seguintes artigos no blog do Dart:

* [Histórico da interop com JS no Dart][blog-3-28-24]
* [Dart no Google Summer of Code 2024][blog-3-5-24]

[blog-3-28-24]: /blog/history-of-js-interop-in-dart
[blog-3-5-24]: /blog/dart-in-google-summer-of-code-2024

## Versão 3.3 {:#3-3-release}

_Lançada em: 15 de fevereiro de 2024_

Esta seção lista mudanças notáveis feitas de 16 de novembro de 2023
até 15 de fevereiro de 2024.
Para detalhes sobre a versão 3.3,
confira o [post do blog sobre o 3.3][3.3 blog post] e o [changelog do SDK][3-3-changelog].

[3.3 blog post]: /blog/new-in-dart-3-3-extension-types-javascript-interop-and-more
[3-3-changelog]: {{site.repo.dart.sdk}}/blob/main/CHANGELOG.md#330

### Documentação atualizada ou adicionada ao dart.dev {:.no_toc} {:#docs-updated-or-added-to-dart-dev}

Além de correções de bugs e melhorias incrementais,
fizemos as seguintes mudanças neste site:

* Mudamos a infraestrutura do site para [rodar em 11ty][run on 11ty] em vez de Jekyll.
* Adicionamos uma página sobre o novo recurso de linguagem [extension types][].
* Adicionamos um novo conjunto de documentação sobre [interop com JavaScript][JavaScript interop]:
  * [Uso][Usage]
  * [Tipos JS][JS types]
  * [Tutoriais][Tutorials], o primeiro deles sobre [Mocks][]
  * [Interop com JS legada][Past JS interop]
* Atualizamos a visão geral de [Concorrência][Concurrency] e adicionamos uma nova página prática sobre o uso de [Isolates][].
* Adicionamos uma seção sobre [`external`][] na página de [Funções][Functions].
* Removemos o DartPad incorporado de algumas páginas para acomodar
  a nova versão do [DartPad][].
* Incluímos uma definição de "Function" no [Glossário][Glossary].
* Desmembramos o [Tour pelas bibliotecas][Library tour] em páginas individuais para cada biblioteca.
* Atualizamos a página de [Breaking changes][] para a 3.3.
* Atualizamos algumas entradas desatualizadas da página de FAQ. _(Agora removidas)_
* Expandimos a documentação sobre [`dart doc`][].
* Atualizamos e simplificamos o conteúdo sobre [plataformas suportadas][supported platforms].
* Consolidamos vários conteúdos do [`dart format`][].
* Atualizamos vários lugares para sugerir o [`package:web`][] em vez de `dart:html`.
* Deixamos de recomendar o [`dart:html`][] e o [`dart:io`][] para fazer requisições HTTP,
  em favor do `package:http`.
* Documentamos [como suprimir diagnósticos em um arquivo pubspec][suppressing diagnostics in a pubspec file].
* Adicionamos conteúdo sobre [criar][creating] e [ignorar][ignoring] avisos de segurança em um arquivo pubspec.
* Documentamos [como migrar para longe de uma versão de pacote retraída][retract].

[run on 11ty]: {{site.repo.this}}/pull/5483
[Extension types]: /language/extension-types
[JavaScript interop]: /interop/js-interop
[Usage]: /interop/js-interop/usage
[JS types]: /interop/js-interop/js-types
[Tutorials]: /interop/js-interop/tutorials
[Mocks]: /interop/js-interop/mock
[Past JS interop]: /interop/js-interop/past-js-interop
[Concurrency]: /language/concurrency
[Isolates]: /language/isolates
[`external`]: /language/functions#external
[Functions]: /language/functions
[DartPad]: {{site.dartpad}}
[Glossary]: /resources/glossary#function
[Library tour]: /libraries
[Breaking changes]: /resources/breaking-changes#3-3-0
[FAQ]: {{site.repo.this}}/pull/5479
[`dart doc`]: /tools/dart-doc
[supported platforms]: /get-dart
[`dart format`]: /tools/dart-format
[`package:web`]: /interop/js-interop/package-web
[`dart:html`]: /libraries/dart-html#using-http-resources-with-httprequest
[`dart:io`]: /libraries/dart-io#http-client
[suppressing diagnostics in a pubspec file]: /tools/analysis#suppressing-diagnostics-in-a-pubspec-file
[ignoring]: /tools/pub/pubspec#ignored_advisories
[creating]: /tools/pub/security-advisories
[retract]: /tools/pub/publishing#how-to-migrate-away-from-a-retracted-package-version


## Versão 3.2 {:#3-2-release}

_Lançada em: 15 de novembro de 2023_

Esta seção lista mudanças notáveis feitas de 17 de agosto de 2023
até 15 de novembro de 2023.
Para detalhes sobre a versão 3.2,
confira o [post do blog sobre o 3.2][3.2 blog post] e o [changelog do SDK][3-2-changelog].

[3.2 blog post]: /blog/announcing-dart-3-2
[3-2-changelog]: {{site.repo.dart.sdk}}/blob/main/CHANGELOG.md#320---2023-11-15

### Documentação atualizada ou adicionada ao dart.dev {:.no_toc} {:#docs-updated-or-added-to-dart-dev}

Além de correções de bugs e melhorias incrementais,
fizemos as seguintes mudanças neste site:

* Atualizamos a página [Corrigindo falhas de promoção de tipo][no-promo] para um novo
  recurso de promoção de tipo: promoção de campos finais privados.
  * Fizemos pequenos ajustes relacionados na entrada do Effective Dart sobre
    [promoção de tipo][type promotion], na página [Entendendo o Null Safety][Understanding Null Safety] e em outros
    lugares do site.
* Introduzimos documentação sobre o recurso experimental de native assets
  na página de [interop com C][C interop].
* Criamos uma nova página dedicada à documentação de [Breaking changes][Breaking changes].
* Consideramos novos e atualizados [lints][] e [diagnósticos][diagnostics]
  nas respectivas páginas de documentação.
* Adicionamos documentação da nova flag `--tighten ` à página do [`pub upgrade`][`pub upgrade`].
* Removemos a cola de referência rápida em favor da página [Visão geral da linguagem][Language overview].
* Esclarecemos a relação entre [guard clauses e padrões][guard clauses and patterns].
* Ajustamos a página de [Construtores][Constructors] para representar melhor as boas práticas.
* Melhoramos o conteúdo da página de [Dependências de pacotes][Package dependencies] para ser mais prático
  e fácil de seguir.
* Detalhamos os membros estáticos na página de [Métodos de extensão][Extension methods].
* Alteramos o conteúdo sobre as limitações de multithreading do [Objective-C][] para considerar
  a nova API `NativeCallable`.
* Adicionamos novas anotações e mencionamos depreciações na página de [Metadata][].
* Melhoramos o contraste ajustando as cores do texto e os destaques
  nos exemplos de código de todo o site.
* Reorganizamos e simplificamos a infraestrutura do site como um todo, em preparação para
  [deixar de usar o Jekyll][move away from using Jekyll].

[type promotion]: /effective-dart/usage#consider-type-promotion-or-null-check-patterns-for-using-nullable-types
[Understanding Null Safety]: /null-safety/understanding-null-safety
[C interop]: /interop/c-interop#native-assets
[Breaking changes]: /resources/breaking-changes
[lints]: /tools/linter-rules
[diagnostics]: /tools/diagnostic-messages
[`pub upgrade`]: /tools/pub/cmd/pub-upgrade#tighten
[Language overview]: /language
[guard clauses and patterns]: /language/patterns#switch-statements-and-expressions
[Constructors]: /language/constructors
[Package dependencies]: /tools/pub/dependencies
[Extension methods]: /language/extension-methods
[Objective-C]: /interop/objective-c-interop#callbacks-and-multithreading-limitations
[Metadata]: /language/metadata
[move away from using Jekyll]: {{site.repo.this}}/issues/5177

## Versão 3.1 {:#3-1-release}

_Lançada em: 16 de agosto de 2023_

Esta seção lista mudanças notáveis feitas de 11 de maio de 2023
até 16 de agosto de 2023.
Para detalhes sobre a versão 3.1,
confira o
[Dart 3.1 & a retrospective on functional style programming in Dart 3][Dart 3.1 & a retrospective on functional style programming in Dart 3]
e o [changelog do SDK][3-1-changelog].

[Dart 3.1 & a retrospective on functional style programming in Dart 3]: /blog/dart-3-1-a-retrospective-on-functional-style-programming-in-dart-3
[3-1-changelog]: {{site.repo.dart.sdk}}/blob/main/CHANGELOG.md#310---2023-08-16

### Documentação atualizada ou adicionada ao dart.dev {:.no_toc} {:#docs-updated-or-added-to-dart-dev}

Além de correções de bugs e melhorias incrementais,
fizemos as seguintes mudanças neste site:

* Reformulamos a documentação das regras do linter para substituir o antigo site de linter:
  * Movemos a documentação de cada regra do linter para a sua própria página.
    Por exemplo: [`avoid_dynamic_calls`][].
  * Adicionamos um exemplo de `analysis_options.yaml` que habilita
    [todas as regras do linter][all linter rules] disponíveis na última versão do Dart.
  * Atualizamos o [índice de todas as regras do linter disponíveis][index of all available linter rules]
    para facilitar a descoberta de lints.
* Ampliamos a documentação de [class modifiers][] adicionando uma
  [referência de class modifiers][Class modifiers reference] para mostrar como eles interagem entre si.
* Introduzimos o guia [Class modifiers para mantenedores de APIs][Class modifiers for API maintainers] para ajudar
  os desenvolvedores a usar melhor os class modifiers.
* Reescrevemos a documentação de [switch expression][] para explicar melhor suas diferenças em relação
  aos switch statements.
* Documentamos o suporte a especificar [topics][] no seu arquivo pubspec para
  categorizar seu pacote no site pub.dev.
* Esclarecemos que os [screenshots de pacote][package screenshots] servem para
  mostrar a funcionalidade do pacote, e não o logo ou o ícone dele.
* Adicionamos botões de página anterior e próxima na [documentação da linguagem][language documentation]
  do Dart, para oferecer uma experiência de aprendizado guiada.
* Continuamos expandindo o novo [glossário][glossary] do site inteiro.
* Adicionamos uma nota de migração sobre como a [mudança do cache do pub][pub cache move] no Windows
  foi finalizada no Dart 3.
* Simplificamos e atualizamos documentos mais antigos, agora que
  o sistema de tipos do Dart é sempre [null safe][].

[class modifiers]: /language/class-modifiers
[Class modifiers reference]: /language/modifier-reference
[Class modifiers for API maintainers]: /language/class-modifiers-for-apis
[`avoid_dynamic_calls`]: /tools/linter-rules/avoid_dynamic_calls
[all linter rules]: /tools/linter-rules/all
[index of all available linter rules]: /tools/linter-rules#rules
[switch expression]: /language/branches#switch-expressions
[topics]: /tools/pub/pubspec#topics
[language documentation]: /language
[package screenshots]: /tools/pub/pubspec#screenshots
[glossary]: /resources/glossary
[pub cache move]: /resources/dart-3-migration#other-tools-changes
[null safe]: /null-safety

### Artigos adicionados ao blog do Dart {:.no_toc} {:#articles-added-to-the-dart-blog}

Publicamos o seguinte artigo no blog do Dart:

* [Dart DevTools: analisando o desempenho de aplicações com o CPU Profiler][blog-6-12-23]

[blog-6-12-23]: /blog/dart-devtools-analyzing-application-performance-with-the-cpu-profiler

## Versão 3.0 {:#3-0-release}

_Lançada em: 10 de maio de 2023_

Esta seção lista mudanças notáveis feitas de 26 de janeiro de 2023
até 10 de maio de 2023.
Para detalhes sobre a versão principal 3.0,
confira [Announcing Dart 3][Announcing Dart 3],
e o [changelog do SDK][3-0-changelog].

[Announcing Dart 3]: /blog/announcing-dart-3
[3-0-changelog]: {{site.repo.dart.sdk}}/blob/main/CHANGELOG.md#300---2023-05-10

### Documentação atualizada ou adicionada ao dart.dev {:.no_toc} {:#docs-updated-or-added-to-dart-dev}

Em preparação para o Dart 3, dividimos e reorganizamos o
Tour pela linguagem em novas categorias conceituais.
Você pode acessar a documentação da linguagem reestruturada
em **Language** no menu lateral de navegação, ou visitando a
[Introdução ao Dart][Introduction to Dart] atualizada.

Aproveitando essa nova estrutura,
adicionamos documentação para cada um dos principais recursos do Dart 3:

- [Pattern matching][] e os diferentes [tipos de padrões][types of patterns].
- [Switch expressions][] com suporte a
  padrões e [verificação de exaustividade][exhaustiveness checking].
- [If statements com cláusulas case][If statements with case clauses] para dar suporte ao pattern matching.
- [Records][], um novo tipo anônimo, imutável e agregado que
  permite [múltiplos retornos][multiple returns].
- [Class modifiers][] que dão às bibliotecas mais controle sobre os tipos exportados.

Para ajudar você a fazer a transição para a imposição de [sound null safety][sound null safety]
no Dart 3 e para outras mudanças, também preparamos as seguintes atualizações:

- Criamos um [guia completo de migração para o Dart 3][Dart 3 migration guide].
- Migramos toda a documentação e os exemplos de código
  para o Dart 3, as versões mais recentes das ferramentas e as dependências mais recentes.
- Esclarecemos que o sistema de tipos do Dart agora é sempre null-safe no Dart 3.
- Atualizamos e reorganizamos a página de [Evolução da linguagem][language evolution]
  e a sua discussão sobre o [versionamento da linguagem][language versioning].
- Removemos resquícios da documentação, notas e recursos do Dart 1 e do início do Dart 2.

Além do novo conteúdo do Dart 3 e das atualizações correspondentes
em todo o site, fizemos as seguintes mudanças:

- Adicionamos um guia sobre como configurar [declarações de ambiente de compilação][compilation environment declarations].
- Continuamos o trabalho de interoperabilidade nativa do Dart
  adicionando um guia sobre o suporte experimental à [interop com Java][Java interop].
- Esclarecemos o uso e as limitações de [extensões sem nome][unnamed extensions].
- Adicionamos uma página para o novo comando [`dart info`][] que
  ajuda com diagnósticos de ferramentas.
- Reformulamos a documentação do [`dart pub add`][] para cobrir a nova sintaxe de
  [descritor de pacote][package descriptor].
- Disponibilizamos builds de preview do Linux RISC-V (RV64GC) no canal beta,
  no [arquivo do SDK][SDK archive].
- Começamos um novo [glossário][glossary] para todo o site, com
  termos comuns usados em todo o conteúdo.
- Destacamos o trabalho experimental no [suporte a interop estática com JS][JS static interop support] do Dart.
- Documentamos a existência e as limitações atuais dos [plugins do analyzer][analyzer plugins].

[Introduction to Dart]: /language
[Pattern matching]: /language/patterns
[types of patterns]: /language/pattern-types
[If statements with case clauses]: /language/branches#if-case
[Switch expressions]: /language/branches#switch-expressions
[exhaustiveness checking]: /language/branches#exhaustiveness-checking
[Records]: /language/records
[multiple returns]: /language/records#multiple-returns
[Class modifiers]: /language/class-modifiers
[class-modifier-reference]: /language/modifier-reference
[sound null safety]: /null-safety
[Dart 3 migration guide]: /resources/dart-3-migration
[language evolution]: /resources/language/evolution
[language versioning]: /language/versioning
[compilation environment declarations]: /libraries/core/environment-declarations
[Java interop]: /interop/java-interop
[unnamed extensions]: /language/extension-methods#unnamed-extensions
[`dart info`]: /tools/dart-info
[`dart pub add`]: /tools/pub/cmd/pub-add
[package descriptor]: /tools/pub/dependencies#package-descriptors
[SDK archive]: /get-dart/archive
[glossary]: /resources/glossary
[JS static interop support]: /interop/js-interop
[analyzer plugins]: /tools/analysis#plugins

### Artigos adicionados ao blog do Dart {:.no_toc} {:#articles-added-to-the-dart-blog}

Publicamos o seguinte artigo no blog do Dart:

* [Apresentando o Realm para Dart & Flutter][blog-2-09-23]

[blog-2-09-23]: /blog/introducing-realm-for-dart-flutter

### Vídeos lançados pela equipe Dart {:.no_toc} {:#videos-released-by-the-dart-team}

Durante o Google I/O 2023, lançamos os seguintes vídeos:

* [O que há de novo no Dart e no Flutter][What's new in Dart and Flutter] ([versão em American Sign Language][American Sign Language version])
* [Repensando a interoperabilidade do Dart com Android][Rethinking Dart interoperability with Android]
* [Como criar um pacote em Dart][How to build a package in Dart]

[What's new in Dart and Flutter]: {{site.yt.watch}}?v=yRlwOdCK7Ho
[American Sign Language version]: {{site.yt.watch}}?v=QbMgjVB0XMI
[Rethinking Dart interoperability with Android]: {{site.yt.watch}}?v=ZWp2FJ2TuJs
[How to build a package in Dart]: {{site.yt.watch}}?v=8V_TLiWszK0

## Versões 2.19 + 3.0 alpha {:#2-19-3-0-alpha-releases}

_Lançadas em: 25 de janeiro de 2023_

Esta seção lista mudanças notáveis feitas de 31 de agosto de 2022
até 25 de janeiro de 2023.
Para detalhes sobre as versões alpha 2.19 + 3.0,
veja [Introducing Dart 3 alpha][Introducing Dart 3 alpha],
e o [changelog do SDK][2-19-changelog].

[Introducing Dart 3 alpha]: /blog/introducing-dart-3-alpha
[2-19-changelog]: {{site.repo.dart.sdk}}/blob/main/CHANGELOG.md#2190---2023-01-24

### Documentação atualizada ou adicionada ao dart.dev {:.no_toc} {:#docs-updated-or-added-to-dart-dev}

Além de correções de bugs e melhorias incrementais,
fizemos as seguintes mudanças neste site:

* Introduzimos o tutorial [Buscar dados da internet][Fetch data from the internet] sobre o uso do `package:http`.
* Adicionamos uma página sobre [publicação automatizada de pacotes no pub.dev][Automated publishing of packages to pub.dev].
* Incluímos links para duas novas traduções do site na seção [recursos da comunidade][community resources]:
  * [Versão coreana deste site (한국어)](https://dart-ko.dev/)
  * [Versão em chinês tradicional deste site (正體中文版)](https://dart.tw.gh.miniasp.com/)
* Atualizamos o conteúdo de null safety em preparação para o Dart 3:
  * Alteramos as restrições de versão no guia de migração para compatibilidade com o Dart 3.
  * Adicionamos uma visão geral do sound null safety completo do Dart 3 na página [Sound null safety][Sound null safety].
  * Destacamos, em uma nota, a incompatibilidade do Dart 3 com o null safety não sólido.
* Introduzimos o guia "Aprendendo Dart como desenvolvedor Swift". _(Agora removido)_
* Substituímos uma seção do Effective Dart por orientações mais gerais sobre [booleanos e operadores de igualdade][booleans and equality operators].
* Documentamos o [content-hashing][content-hashing] em toda a documentação do pub.
* Começamos a reformular a página de [Zones][Zones], trocando os exemplos para usar `runZonedGuarded` em vez de `onError`.
* Atualizamos o conteúdo sobre bibliotecas para cobrir o novo desenvolvimento de declarações sem nome:
  * Effective Dart: [Documentação][Documentation], [Estilo][Style] e [Uso][Usage]
  * Nova seção sobre a diretiva de biblioteca em [O tour pela linguagem][The language tour]
* Melhoramos a clareza sobre o status de thread única ou multithread do Dart:
  * Removemos a página desatualizada do `dart:io`.
  * Expandimos a seção sobre [recursos de concorrência do Dart na web][Dart's web concurrency capabilities].
* Reorganizamos e esclarecemos a [discussão][discussion] sobre valores padrão para parâmetros opcionais e posicionais.
* Atualizamos [Concorrência em Dart][Concurrency in Dart] para usar, por padrão, a nova função `Isolate.run()`.
* Documentamos como especificar um caminho de arquivo ao ativar um pacote na [página do `pub global`][`pub global` page].
* Reescrevemos "Aprendendo Dart como desenvolvedor JavaScript". _(Agora removido)_
* Adicionamos uma breve visão geral do Dart DevTools na [página do `dart run`][`dart run` page].
* Esclarecemos melhor a [precedência e associatividade de operadores][operator precedence and associativity] no tour pela linguagem.
* Expandimos a seção do tour de bibliotecas sobre [Construção de URIs][Building URIs] com informações sobre URI http e construtor factory.
* Levamos em conta a [transição do pub para o pub.dev][pub's transition to pub.dev] a partir do pub.dartlang.org.
* Adicionamos documentação sobre [screenshots de pacotes][package screenshots].
* Melhoramos a [seção de downcast explícito][explicit downcast section] da página de sistema de tipos do Dart.
* Ampliamos a cobertura de [analyzer][analyzer] e de [lints][lint]:
  * Incluímos informações de suporte à versão do SDK para as regras do linter.
  * Adicionamos mensagens de diagnóstico e de lint para as mudanças da 2.19.

[Fetch data from the internet]: /server/fetch-data
[Automated publishing of packages to pub.dev]: /tools/pub/automated-publishing
[community resources]: /community
[booleans and equality operators]: /effective-dart/usage#dont-use-true-or-false-in-equality-operations
[content-hashing]: /resources/glossary#pub-content-hash
[Zones]: /libraries/async/zones
[Documentation]: /effective-dart/documentation#consider-writing-a-library-level-doc-comment
[Style]: /effective-dart/style#dont-explicitly-name-libraries
[Usage]: /effective-dart/usage#do-use-strings-in-part-of-directives
[The language tour]: /language/libraries#library-directive
[Dart's web concurrency capabilities]: /language/concurrency#concurrency-on-the-web
[discussion]: /language/functions#parameters
[Concurrency in Dart]: /language/concurrency
[`pub global` page]: /tools/pub/cmd/pub-global
[`dart run` page]: /tools/dart-run#debugging
[operator precedence and associativity]: /language/operators
[Building URIs]: /libraries/dart-core#building-uris
[pub's transition to pub.dev]: /tools/pub/troubleshoot#pub-get-socket-error
[package screenshots]: /tools/pub/pubspec#screenshots
[explicit downcast section]: /language/type-system#generic-type-assignment
[analyzer]: /tools/diagnostic-messages
[lint]: /tools/linter-rules

### Artigos adicionados ao blog do Dart {:.no_toc} {:#articles-added-to-the-dart-blog}

Publicamos os seguintes artigos no blog do Dart:

* [Melhor gerenciamento de isolates com Isolate.run()][blog-1-24-23]
* [Screenshots e publicação automatizada para o pub.dev][blog-1-18-23]
* [O caminho para o Dart 3: uma linguagem totalmente sólida e null safe][blog-12-8-22]
* [Resultados do Google Summer of Code 2022][blog-11-3-22]
* [Parceria com o GitHub sobre segurança da cadeia de suprimentos para pacotes Dart][blog-10-6-22]

[blog-1-24-23]: /blog/better-isolate-management-with-isolate-run
[blog-1-18-23]: /blog/screenshots-and-automated-publishing-for-pub-dev
[blog-12-8-22]: /blog/the-road-to-dart-3-a-fully-sound-null-safe-language
[blog-11-3-22]: /blog/google-summer-of-code-2022-results
[blog-10-6-22]: /blog/partnering-with-github-on-supply-chain-security-for-dart-packages


## Versão 2.18 {:#2-18-release}

_Lançada em: 30 de agosto de 2022_

Esta seção lista mudanças notáveis feitas de 12 de maio de 2022
até 30 de agosto de 2022.
Para detalhes sobre a versão 2.18,
veja [Dart 2.18: Objective-C & Swift interop][Dart 2.18: Objective-C & Swift interop],
e o [changelog do SDK][2-18-changelog].

[Dart 2.18: Objective-C & Swift interop]: /blog/dart-2-18-objective-c-swift-interop
[2-18-changelog]: {{site.repo.dart.sdk}}/blob/main/CHANGELOG.md#2180---2022-08-30

Além de correções de bugs e melhorias incrementais,
fizemos as seguintes mudanças neste site:

* Introduzimos a página [Interop com Objective-C e Swift][Objective-C and Swift interop],
  que explica como usar pacotes Dart para chamar APIs dessas linguagens.
* Adicionamos uma solução alternativa em Corrigindo problemas comuns de tipo,
  para o caso raro em que a inferência de tipo possa inferir incorretamente que um argumento é null.
* Removemos todas as menções aos arquivos `.packages`, descontinuados, de [O que não commitar][What not to commit].
  Se você ainda precisar gerar um arquivo `.packages` por causa de dependências legadas de terceiros,
  veja as [opções do `dart pub get`][`dart pub get` Options].
* Removemos as páginas dedicadas e qualquer outra menção às ferramentas de linha de comando
  `dart2js` e `dartdevc`, descontinuadas.
  * Adicionamos as opções de linha de comando e os problemas conhecidos antes associados ao
  `dart2js` na página do [`dart compile`][`dart compile`].
  * Adicionamos informações sobre depuração de código de produção em [Depurando aplicações web Dart][Debugging Dart web apps].
* Adicionamos suporte ao download de builds experimentais do Windows ARM
  no [arquivo do SDK do Dart][Dart SDK archive].
* Atualizamos o [Tour de bibliotecas][Library tour] para incluir informações sobre weak references e finalizers.
* Adicionamos uma seção sobre como personalizar o [`dart fix`][`dart fix`].

[Objective-C and Swift interop]: /interop/objective-c-interop
[What not to commit]: /tools/pub/private-files
[`dart pub get` Options]: /tools/pub/cmd/pub-get#options
[`dart compile`]: /tools/dart-compile
[Debugging Dart web apps]: /web/debugging
[Dart SDK archive]: /get-dart/archive
[Library tour]: /libraries/dart-core#weak-references-and-finalizers
[`dart fix`]: /tools/dart-fix#customize

## Versão 2.17 {:#2-17-release}

_Lançada em: 11 de maio de 2022_

Esta seção lista mudanças notáveis feitas de 4 de fevereiro de 2022
até 11 de maio de 2022.
Para detalhes sobre a versão 2.17,
veja [Dart 2.17: Productivity and integration][Dart 2.17: Productivity and integration].

[Dart 2.17: Productivity and integration]: /blog/dart-2-17-productivity-and-integration

### Documentação atualizada ou adicionada ao dart.dev {:.no_toc} {:#docs-updated-or-added-to-dart-dev}

Além de correções de bugs e melhorias incrementais,
fizemos as seguintes mudanças neste site:

* Introduzimos o guia "Aprendendo Dart como desenvolvedor JavaScript",
  que visa aproveitar o seu conhecimento de programação em JavaScript
  ao aprender Dart. _(Agora removido)_
* Documentamos os recursos e as mudanças introduzidos no Dart 2.17:
  * Atualizamos a seção [Named parameters][Named parameters] do tour pela linguagem
    para refletir o suporte a especificar argumentos nomeados em qualquer posição.
  * Adicionamos documentação sobre [parâmetros de inicializador de super][super-initializer parameters].
  * Expandimos a seção [Tipos enumerados][Enumerated types] do tour pela linguagem
    e documentamos os [enums aprimorados][enhanced enums].
  * Documentamos o suporte à [assinatura][signing] de executáveis macOS e Windows
    compilados com `dart compile exe`.
  * Atualizamos os templates suportados pelo [`dart create`][`dart create`]
    para seus novos nomes padronizados.
* Levamos em conta as mudanças no [site pub.dev][pub.dev site] e na [ferramenta pub][pub tool].
  * Listamos fornecedores que oferecem [repositórios de pacotes Dart como serviço][Dart package repositories as a service].
  * Removemos a documentação do comando `dart pub uploader`, agora descontinuado.
  * Expandimos a documentação sobre como gerenciar [uploaders][uploaders] de projetos pub.
  * Removemos a maioria das menções ao arquivo `.packages`, depreciado,
    indicando em seu lugar o substituto `.dart_tool/package_config.json`.
* Atualizamos a documentação sobre como atualizar e instalar o Dart:
  * Documentamos como alternar entre versões do Dart com o Homebrew
    nas [instruções de instalação][get-dart-install] para macOS.
  * Atualizamos as [instruções de instalação][get-dart-install] para Linux
    para usar o [SecureApt][SecureApt] e seguir as melhores práticas mais recentes.
  * Adicionamos suporte ao download de builds experimentais para Linux RISC-V (RV64GC)
    no [arquivo do SDK do Dart][Dart SDK archive].
* Continuamos o trabalho para melhorar e atualizar a documentação da
  [ferramenta `dart` unificada][dart-tool]:
  * Expandimos a documentação sobre as funcionalidades da ferramenta [`dart fix`][`dart fix`].
  * Ajustamos as diretrizes e a documentação da ferramenta [`dart doc`][`dart doc`]
    para corresponder à sua funcionalidade e ao comportamento subjacente.
  * Adicionamos mais documentação e exemplos de [`dart compile js`][`dart compile js`].
  * Removemos menções a ferramentas standalone que foram removidas.
* Atualizamos a documentação e o uso do analyzer e do linter:
  * Documentamos os novos [modos estritos de linguagem][strict language modes] do analyzer.
  * Incorporamos mudanças nas páginas de
    [mensagens de diagnóstico][diagnostic messages] e [regras do linter][linter rules].
  * Atualizamos a documentação e os exemplos
    para usar a versão `2.0.0` do pacote `lints`.
* Começamos uma reformulação da documentação de compilação para a web:
  * Documentamos a depreciação e a remoção planejada das ferramentas standalone
    `dart2js` e `dartdevc`.
  * Consolidamos e esclarecemos a documentação de `dart2js` e `dartdevc`
    como os compiladores subjacentes de ferramentas como
    [`dart compile js`][`dart compile js`] e [`webdev`][`webdev`].
* Aumentamos a cobertura da documentação sobre null safety:
  * Documentamos o operador de asserção de não nulo (`!`) como parte da
    seção [Outros operadores][Other operators] do tour pela linguagem.
  * Migramos os [tutoriais de HTML de baixo nível][Low-level HTML tutorials] para dar suporte a null safety
    e discutir como interagir com APIs web usando-o.
* Fizemos outras atualizações variadas:
  * Documentamos os [tipos nativos][native types] fornecidos por `dart:ffi`
    para uso em interop com C.
  * Introduzimos uma nova seção no tour pela linguagem documentando
    [inicialização de parâmetros formais][initializing formal parameters].
  * Documentamos o [suporte a pacotes][support for packages] do DartPad.
  * Corrigimos a formatação do [tutorial de programação assíncrona][asynchronous programming tutorial]
    e detalhamos [por que o código assíncrono importa][why asynchronous code matters].
  * Atualizamos a página de [segurança][security] para refletir nossas práticas de segurança atuais.
  * Adicionamos um atalho de teclado (`/`) para focar automaticamente a barra de pesquisa.

[Named parameters]: /language/functions#named-parameters
[Enumerated types]: /language/enums
[enhanced enums]: /language/enums#declaring-enhanced-enums
[super-initializer parameters]: /language/constructors#super-parameters
[signing]: /tools/dart-compile#signing
[`dart create`]: /tools/dart-create

[pub.dev site]: {{site.pub}}
[pub tool]: /tools/pub/cmd
[Dart package repositories as a service]: /tools/pub/custom-package-repositories#dart-package-repositories-as-a-service
[uploaders]: /tools/pub/publishing#uploaders

[get-dart-install]: /get-dart#install
[SecureApt]: https://wiki.debian.org/SecureApt
[Dart SDK archive]: /get-dart/archive

[dart-tool]: /tools/dart-tool
[`dart fix`]: /tools/dart-fix
[`dart doc`]: /tools/dart-doc
[`dart compile js`]: /tools/dart-compile#js

[strict language modes]: /tools/analysis#enabling-additional-type-checks
[diagnostic messages]: /tools/diagnostic-messages
[linter rules]: /tools/linter-rules

[`webdev`]: /tools/webdev

[Other operators]: /language/operators#other-operators
[Low-level HTML tutorials]: /web/get-started

[native types]: /interop/c-interop#interface-with-native-types
[initializing formal parameters]: /language/constructors#use-initializing-formal-parameters
[support for packages]: /tools/dartpad#library-support
[asynchronous programming tutorial]: /libraries/async/async-await
[why asynchronous code matters]: /libraries/async/async-await#why-asynchronous-code-matters
[security]: /security


### Artigos adicionados ao blog do Dart {:.no_toc} {:#articles-added-to-the-dart-blog}

Publicamos os seguintes artigos no blog do Dart:

* [Aplicação em massa de correções][blog-5-5-22]
* [Programação assíncrona em Dart: Streams][blog-4-14-22]
* [Colaboradores do Google Summer of Code 2022][blog-4-7-22]
* [Migração gradual para null safety em projetos Dart grandes][blog-3-31-22]
* [Hospedando um repositório privado de pacotes Dart][blog-3-16-22]
* [Quick fixes para problemas de análise][blog-3-4-22]

[blog-5-5-22]: /blog/bulk-application-of-fixes
[blog-4-14-22]: /blog/dart-asynchronous-programming-streams
[blog-4-7-22]: /blog/contributors-for-google-summer-of-code-2022
[blog-3-31-22]: /blog/gradual-null-safety-migration-for-large-dart-projects
[blog-3-16-22]: /blog/hosting-a-private-dart-package-repository
[blog-3-4-22]: /blog/quick-fixes-for-analysis-issues

## Versão 2.16 {:#2-16-release}

_Lançada em: 3 de fevereiro de 2022_

Esta seção lista mudanças notáveis feitas de 8 de dezembro de 2021
até 3 de fevereiro de 2022.
Para detalhes sobre a versão 2.16,
veja [Dart 2.16: Improved tooling and platform handling][Dart 2.16: Improved tooling and platform handling].

[Dart 2.16: Improved tooling and platform handling]: /blog/dart-2-16-improved-tooling-and-platform-handling

### Documentação atualizada ou adicionada ao dart.dev {:.no_toc} {:#docs-updated-or-added-to-dart-dev}

Nós [atualizamos a infraestrutura do site][updated the website infrastructure] para uma configuração baseada em Docker
para permitir [contribuições mais fáceis][easier contributions] e alinhar-nos melhor com
a configuração de [docs.flutter.dev]({{site.flutter-docs}}).

Além de outras correções de bugs e melhorias incrementais,
fizemos as seguintes mudanças neste site:

* Passamos a documentar a nova ferramenta [`dart doc`][`dart doc`],
  que substitui o `dartdoc`.
* Documentamos a nova [entrada `platform`][`platform` entry] para especificar as plataformas suportadas
  no `pubspec.yaml` de um pacote.
* Atualizamos as páginas de [mensagens de diagnóstico][diagnostic messages] e [regras do linter][linter rules].
* Documentamos como [ignorar todas as regras do linter][ignore all linter rules] em um arquivo.
* Removemos menções às antigas ferramentas standalone da [visão geral do Dart SDK][Dart SDK overview].
* Atualizamos as menções restantes às antigas ferramentas standalone
  para os equivalentes na ferramenta [`dart`][`dart`].
* Adicionamos esclarecimentos à diretriz do Effective Dart
  [PREFER using interpolation to compose strings and values][PREFER using interpolation to compose strings and values].

[updated the website infrastructure]: {{site.repo.this}}/pull/3765
[easier contributions]: {{site.repo.this}}#getting-started
[`dart doc`]: /tools/dart-doc
[`platform` entry]: /tools/pub/pubspec#platforms
[ignore all linter rules]: /tools/analysis#suppressing-rules-for-a-file
[diagnostic messages]: /tools/diagnostic-messages
[linter rules]: /tools/linter-rules
[Dart SDK overview]: /tools/sdk
[PREFER using interpolation to compose strings and values]: /effective-dart/usage#prefer-using-interpolation-to-compose-strings-and-values
[`dart`]: /tools/dart-tool


## Versão 2.15 {:#2-15-release}

_Lançada em: 8 de dezembro de 2021_

Esta seção lista mudanças notáveis feitas de 9 de setembro de 2021
até 8 de dezembro de 2021.
Para detalhes sobre a versão 2.15,
veja [Announcing Dart 2.15][Announcing Dart 2.15].

[Announcing Dart 2.15]: /blog/announcing-dart-2-15

### Documentação atualizada ou adicionada ao dart.dev {:.no_toc} {:#docs-updated-or-added-to-dart-dev}

Além de correções de bugs e melhorias incrementais,
fizemos as seguintes mudanças neste site:

* Adicionamos [Concorrência em Dart][Concurrency in Dart], que discute recursos como
  isolates, que permitem a execução paralela de código Dart.
* Documentamos recursos do pub adicionados ou aprimorados na 2.15:
  * Adicionamos uma página para o novo subcomando do pub, [dart pub token][dart pub token],
    e uma página sobre [repositórios de pacotes personalizados][custom package repositories]
  * Adicionamos informações sobre a [retração de pacotes][package retraction]
  * Adicionamos o campo [false_secrets][false_secrets] à página do pubspec
  * Atualizamos a sintaxe para [dependências hospedadas][hosted dependencies]
* Removemos todas as entradas de livros do Dart 1 [livros][books]
* Expandimos as [dicas de solução de problemas do DartPad][DartPad troubleshooting tips]
* Atualizamos a página de [mensagens de diagnóstico][diagnostic messages]
* Atualizamos a página de [regras do linter][linter rules];
  removemos referências a conjuntos de regras depreciados, como
  `effective_dart`
* Atualizamos as instruções para instalar e usar o [Dart DevTools][Dart DevTools]
* Adicionamos informações sobre o que o [runtime do Dart][Dart runtime] fornece,
  e esclarecemos os [formatos de compilação][compilation formats]

[books]: /resources/books
[compilation formats]: /tools/dart-compile
[Concurrency in Dart]: /language/concurrency
[custom package repositories]: /tools/pub/custom-package-repositories
[Dart DevTools]: /tools/dart-devtools
[dart pub token]: /tools/pub/cmd/pub-token
[Dart runtime]: /overview#runtime
[DartPad troubleshooting tips]: /tools/dartpad/troubleshoot
[diagnostic messages]: /tools/diagnostic-messages
[false_secrets]: /tools/pub/pubspec#false_secrets
[hosted dependencies]: /tools/pub/dependencies#hosted-packages
[linter rules]: /tools/linter-rules
[package retraction]: /tools/pub/publishing#retract


## Versão 2.14 {:#2-14-release}

_Lançada em: 8 de setembro de 2021_

Esta seção lista mudanças notáveis feitas de 20 de maio de 2021
até 8 de setembro de 2021.
Para detalhes sobre a versão 2.14,
veja [Announcing Dart 2.14][Announcing Dart 2.14].

[Announcing Dart 2.14]: /blog/announcing-dart-2-14

### Documentação atualizada ou adicionada ao dart.dev {:.no_toc} {:#docs-updated-or-added-to-dart-dev}

Além de correções de bugs e melhorias incrementais,
fizemos as seguintes mudanças neste site:

* Aprofundamos a página sobre [como corrigir falhas de promoção de tipo][no-promo].
* Documentamos como usar o [arquivo `.pubignore`][`.pubignore` file],
  um recurso introduzido no Dart 2.14.
* Adicionamos a cobertura do [operador de shift sem sinal][unsigned shift operator] (`>>>`),
  introduzido no Dart 2.14.
* Desenvolvemos a [página de regras do linter][linter rule page];
  atualizamos o Effective Dart para linkar para ela.
* Adicionamos páginas para os comandos [`dart create`][`dart create`] e [`dart test`][`dart test`].
* Terminamos de converter os exemplos que usavam as antigas ferramentas de linha de comando
  (por exemplo, `dartfmt`) para usar a [ferramenta `dart` unificada][dart-tool]
  (por exemplo, `dart format`).
* Atualizamos o código do site para usar as [regras do linter recomendadas][recommended linter rules],
  em vez do pedantic.
* Atualizamos as listas de [bibliotecas principais][core libraries] e de [pacotes comumente usados][commonly used packages].
* Adicionamos um redirecionamento de [dart.dev/jobs][dart.dev/jobs] para flutter.dev/jobs,
  para facilitar encontrar vagas abertas nas equipes do Dart e do Flutter.
* Terminamos de migrar todo o código analisado ou testado para null safety,
  atualizando o texto para corresponder.
  Encontramos mais código do site que não tinha sido analisado; corrigimos isso.

[unsigned shift operator]: /language/operators#bitwise-and-shift-operators
[`.pubignore` file]: /tools/pub/publishing#what-files-are-published
[linter rule page]: /tools/linter-rules
[dart-tool]: /tools/dart-tool
[recommended linter rules]: /tools/analysis#lints
[core libraries]: /libraries
[commonly used packages]: /resources/useful-packages
[dart.dev/jobs]: /jobs
[no-promo]: /tools/non-promotion-reasons
[`dart create`]: /tools/dart-create
[`dart test`]: /tools/dart-test

### Artigos adicionados ao blog do Dart {:.no_toc} {:#articles-added-to-the-dart-blog}

Publicamos os seguintes artigos no blog do Dart:

* [Experimentando Dart e Wasm][blog-7-27-21]
* [Como o null safety do Dart me ajudou a aprimorar meus projetos][blog-6-23-21]
* [Implementando structs por valor no Dart FFI][blog-6/8-21]

[blog-7-27-21]: /blog/experimenting-with-dart-and-wasm
[blog-6-23-21]: /blog/how-darts-null-safety-helped-me-augment-my-projects
[blog-6/8-21]: /blog/implementing-structs-by-value-in-dart-ffi


## Versão 2.13 {:#2-13-release}

_Lançada em: 19 de maio de 2021_

Esta seção lista mudanças notáveis feitas de 4 de março de 2021
até 19 de maio de 2021.
Para detalhes sobre a versão 2.13,
veja [Announcing Dart 2.13][Announcing Dart 2.13].

[Announcing Dart 2.13]: /blog/announcing-dart-2-13

### Documentação atualizada ou adicionada ao dart.dev {:.no_toc} {:#docs-updated-or-added-to-dart-dev}

Além de correções de bugs e melhorias incrementais,
fizemos as seguintes mudanças neste site:

* Atualizamos a [seção de typedef][typedef section] do tour pela linguagem para refletir
  aliases de tipos que não são de função, introduzidos no Dart 2.13.
* Publicamos ou atualizamos documentação relacionada à linha de comando e a servidores:
  * [Usando o Google Cloud][Using Google Cloud] descreve os produtos do Google Cloud que
    servidores Dart podem usar,
    frequentemente com a ajuda de imagens Docker já empacotadas.
  * O tutorial de servidor HTTP,
    que apresentava o pacote `http_server`, descontinuado, foi substituído temporariamente por
    uma página "em construção" que
    linka para documentação e exemplos úteis. _(Agora removido)_
  * O tutorial de linha de comando foi totalmente atualizado. _(Agora removido)_
* Publicamos outras páginas novas:
  * Um codelab de null safety que ensina sobre o sistema de tipos null-safe do Dart,
    introduzido no Dart 2.12.
  * [Números em Dart][Numbers in Dart] traz
    detalhes sobre as diferenças entre as implementações nativas e web de números.
  * [Usando APIs do Google][Using Google APIs] aponta recursos para
    ajudar você a usar as APIs cliente do Firebase e do Google em uma aplicação Dart.
  * [Escrevendo páginas de pacotes][Writing package pages] traz dicas para
    escrever um README de pacote que funcione bem no pub.dev.
  * [Corrigindo falhas de promoção de tipo][Fixing type promotion failures]
    tem informações para ajudar você a entender
    por que ocorrem falhas de promoção de tipo, e dicas de como corrigi-las.
  * A nova [página do `dart run`][`dart run` page]
    descreve como executar um programa Dart pela linha de comando.
* Continuamos o trabalho de migração do código para null safety, em especial o
  [tutorial de streams][streams tutorial].
* Fizemos outras atualizações variadas:
  * Removemos referências ao Stagehand, em favor do [`dart create`][`dart create`].
  * Alteramos as opções de análise do código de exemplo do dart.dev de
    `pedantic` para as regras recomendadas em [`lints`][`lints`].
  * Adicionamos o Docker como forma de [obter o Dart][get Dart].
  * Atualizamos a [página de evolução da linguagem][language evolution page] para refletir o Dart 2.13.

[`dart run` page]: /tools/dart-run
[`dart create`]: /tools/dart-create
[Fixing type promotion failures]: /tools/non-promotion-reasons
[get Dart]: /get-dart
[`lints`]: {{site.pub-pkg}}/lints
[Numbers in Dart]: /resources/language/number-representation
[streams tutorial]: /libraries/async/using-streams
[typedef section]: /language/typedefs
[Using Google APIs]: /resources/google-apis
[Using Google Cloud]: /server/google-cloud
[Writing package pages]: /tools/pub/writing-package-pages
[language evolution page]: /resources/language/evolution


### Artigos adicionados ao blog do Dart {:.no_toc} {:#articles-added-to-the-dart-blog}

Publicamos os seguintes artigos no blog do Dart:

* [AngularDart, Flutter e a web: atualização da primavera][blog-5-12-21]
* [Anunciando o suporte do Dart ao GitHub Actions][blog-3-24-21]
* [Dart no Google Summer of Code 2021][blog-3-13-21]

[blog-5-12-21]: /blog/angulardart-flutter-and-the-web-spring-update
[blog-3-24-21]: /blog/announcing-dart-support-for-github-actions
[blog-3-13-21]: /blog/dart-in-google-summer-of-code-2021


## Versão 2.12 {:#2-12-release}

_Lançada em: 3 de março de 2021_

Esta seção lista mudanças notáveis feitas de 2 de outubro de 2020
até 3 de março de 2021.
Para detalhes sobre a versão 2.12,
veja [Announcing Dart 2.12][Announcing Dart 2.12].


### Documentação atualizada ou adicionada ao dart.dev {:.no_toc} {:#docs-updated-or-added-to-dart-dev}

Além de correções de bugs e melhorias incrementais, fizemos as seguintes mudanças neste site:

* Atualizamos e aprofundamos a documentação de null safety _(agora [arquivada][ns-archive])_:
  * Fornecemos um guia de migração.
  * Adicionamos um FAQ.
  * Criamos a documentação de null safety não sólido.
  * Simplificamos a [página inicial de null safety][null safety homepage].
* Atualizamos o [Effective Dart][Effective Dart], alterando o código para ser null safe e
  as regras para refletir a nova orientação.
* Atualizamos o [tour pela linguagem][language tour], alterando o código para ser null safe e
  adicionando informações sobre novos recursos, como as
  [variáveis `late`][`late` variables].
* Atualizamos a [página de evolução da linguagem][evolution]
  para adicionar informações sobre o versionamento da linguagem
  e para refletir o Dart 2.12.
* Atualizamos o [tour pelas bibliotecas][library tour] e os tutoriais
  para refletir o sound null safety.
* Atualizamos páginas do site inteiro para usar [a ferramenta `dart`][the `dart` tool]
  em vez de comandos descontinuados.
  Começamos a adicionar páginas para vários comandos `dart`, incluindo
  [`dart analyze`][`dart analyze`], [`dart compile`][`dart compile`], [`dart fix`][`dart fix`]
  e [`dart format`][`dart format`].
* Criamos uma página documentando a qualidade e o suporte dos [pacotes da equipe Dart][Dart team packages].
* Substituímos a página de Plataformas por uma nova [página de visão geral][Overview page].
* Criamos esta página ("What's new").

Também migramos do Travis CI para o GitHub Actions e fizemos várias mudanças de CSS para melhorar a legibilidade do site.

[Announcing Dart 2.12]: /blog/announcing-dart-2-12
[ns-archive]: https://github.com/dart-community/migrate-to-null-safety
[null safety homepage]: /null-safety
[Overview page]: /overview
[Effective Dart]: /effective-dart
[language tour]: /language
[`late` variables]: /language/variables#late-variables
[library tour]: /libraries

[the `dart` tool]: /tools/dart-tool
[`dart analyze`]: /tools/dart-analyze
[`dart compile`]: /tools/dart-compile
[`dart fix`]: /tools/dart-fix
[`dart format`]: /tools/dart-format
[Dart team packages]: /resources/dart-team-packages


### Artigos adicionados ao blog do Dart {:.no_toc} {:#articles-added-to-the-dart-blog}

Publicamos os seguintes artigos no blog do Dart:

* [Preparando o ecossistema Dart e Flutter para o null safety][blog-2-16-21]
  anunciou a estabilidade da API de null safety e
  convidou desenvolvedores a publicar versões estáveis e null-safe de seus pacotes.
* [Dart e os benefícios de desempenho dos tipos sólidos][blog-1-19-21]
  demonstrou como a solidez e o null safety permitem que os compiladores Dart gerem
  código mais rápido e menor.
* [Por que tipos anuláveis?][blog-12-7-20]
  expandiu uma discussão no subreddit /r/dart_lang,
  respondendo à pergunta "Por que não eliminar o null completamente?"
* [Anunciando o beta do null safety do Dart][blog-11-19-20]
  convidou desenvolvedores a começar a planejar a migração para o null safety.

[blog-2-16-21]: /blog/preparing-the-dart-and-flutter-ecosystem-for-null-safety
[blog-1-19-21]: /blog/dart-and-the-performance-benefits-of-sound-types
[blog-12-7-20]: /blog/why-nullable-types
[blog-11-19-20]: /blog/announcing-dart-null-safety-beta

## Versão 2.10 {:#2-10-release}

_Lançada em: 1 de outubro de 2020_

Esta seção lista mudanças notáveis feitas de
1º de julho a 1º de outubro de 2020.
Para detalhes sobre a versão 2.10,
veja [Announcing Dart 2.10.][210-ann]

[210-ann]: /blog/announcing-dart-2-10

<div class="no_toc_section">

### Documentação atualizada ou adicionada ao dart.dev {:.no_toc} {:#docs-updated-or-added-to-dart-dev}

Além de correções de bugs e pequenas melhorias,
fizemos as seguintes mudanças neste site:

* Adicionamos uma [página da ferramenta `dart`][dart-tool]
  para documentar a nova interface de linha de comando do SDK do Dart.
  A nova ferramenta `dart` é análoga à ferramenta `flutter` do Flutter SDK.
  Antes, o comando `dart` só executava aplicações de linha de comando.
  Atualizamos a página `dart` anterior de acordo
  e planejamos atualizar as referências a outras ferramentas ao longo do tempo.
* Atualizamos a [documentação do changelog de pacotes][changelog-docs]
  para recomendar um formato padrão para arquivos `CHANGELOG.md`.
  Esse novo formato permite que ferramentas
  (como o pub.dev, relançado) façam o parse dos changelogs.
* Alteramos uma diretriz do [Effective Dart][Effective Dart] para preferir
  usar `Object` em vez de `dynamic`.
  Para detalhes, veja a diretriz revisada
  [EVITE usar `dynamic` a menos que você queira desabilitar a verificação estática.][dynamic]
* Atualizamos a [página de mensagens de diagnóstico][diagnostics] para
  incluir mais mensagens produzidas pelo analyzer do Dart.
* Atualizamos a [página de evolução][evolution]
  para incluir a 2.9 e a 2.10.
* Reorganizamos a [página da especificação da linguagem][spec]
  para facilitar encontrar a versão em PDF da
  especificação mais recente, em andamento.
* Adicionamos ou atualizamos documentação relacionada ao [sound null safety][sound null safety],
  um recurso que está chegando à linguagem Dart:
  * Esclarecemos como usar [flags de experimento com IDEs][experiments].
  * Atualizamos a página de null safety, adicionando informações sobre
    [como habilitar o null safety][ns-enable].
  * Adicionamos um mergulho profundo em null safety,
    [Entendendo o null safety][Understanding null safety],
    escrito pelo engenheiro do Dart Bob Nystrom.

[dart-tool]: /tools/dart-tool
[diagnostics]: /tools/diagnostic-messages
[dynamic]: /effective-dart/design#avoid-using-dynamic-unless-you-want-to-disable-static-checking
[Effective Dart]: /effective-dart
[evolution]: /resources/language/evolution
[experiments]: /tools/experiment-flags#using-experiment-flags-with-ides
[ns-enable]: /null-safety#enable-null-safety
[Understanding null safety]: /null-safety/understanding-null-safety
[sound null safety]: /null-safety
[diagnostics]: /tools/diagnostic-messages
[changelog-docs]: /tools/pub/package-layout#changelog
[spec]: /resources/language/spec

### Artigos adicionados ao blog do Dart {:.no_toc} {:#articles-added-to-the-dart-blog}

Publicamos os seguintes artigos no [blog do Dart:][Dart blog]

* [Explorando coleções em Dart][Exploring collections in Dart] ajuda você a usar coleções
  (listas, maps, sets e outras), com atenção especial aos recursos da linguagem 2.3,
  como collection if, collection for e spreads.
* [Resultados do Google Summer of Code 2020][Google Summer of Code 2020 results] descreve os resultados de
  cinco projetos orientados pela equipe Dart.
* [Apresentando um novo pub.dev][Introducing a brand new pub.dev] anuncia o relançamento do
  [site pub.dev,][pub.dev] com novas métricas de pontuação de pacotes, busca aprimorada
  e uma interface redesenhada.

Também melhoramos a navegação do blog,
adicionando as abas **announcement** e **archive**, além de um link para o dart.dev.

:::tip
Todos os artigos do blog do Dart são gratuitos para ler.
:::

</div>

[Dart blog]: /blog
[Exploring collections in Dart]: /blog/exploring-collections-in-dart
[Google Summer of Code 2020 results]: /blog/google-summer-of-code-2020-results
[Introducing a brand new pub.dev]: /blog/introducing-a-brand-new-pub-dev
[pub.dev]: {{site.pub}}
