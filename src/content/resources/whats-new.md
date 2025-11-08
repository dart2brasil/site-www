---
ia-translate: true
title: Novidades
description: Uma lista do que há de novo no dart.dev e sites relacionados.
lastVerified: 2025-08-08
---

Esta página descreve o que há de novo no site e blog do Dart.
Para ver as novidades no Flutter, visite a
[página de novidades do Flutter.][flutter-whats-new]

Para uma lista de mudanças na linguagem Dart em cada Dart SDK, veja a
[página de evolução da linguagem][evolution].
Para ficar por dentro dos anúncios, incluindo breaking changes,
participe do [grupo Google de anúncios do Dart][dart-announce]
e siga o [blog do Dart][].

[flutter-whats-new]: {{site.flutter-docs}}/whats-new
[dart-announce]: https://groups.google.com/a/dartlang.org/d/forum/announce
[Dart blog]: https://blog.dart.dev

## Versão 3.9

_Lançada em: 13 de agosto de 2025_

Esta seção lista mudanças notáveis feitas de 20 de maio de 2025
até 13 de agosto de 2025 no [dart.dev](https://dart.dev/docs).
Para detalhes sobre a versão 3.9 do Dart,
confira o [anúncio do 3.9][] e o
[changelog do SDK 3.9][3-8-changelog].

### Documentação atualizada ou adicionada ao dart.dev {:.no_toc}

Além de correções de bugs e melhorias incrementais,
fizemos as seguintes alterações na documentação deste site:

* [Habilitamos breadcrumbs por padrão][] em todo o site.
* Atualizamos a [documentação do `dart compile`][] para cross-compilation para ARM e
  RISC-V64.
* Reformulamos a [documentação de metadata e annotations][].
* Reestruturamos a [página do `dart create`][] para explicar melhor os templates.
* Adicionamos um [guia abrangente do Dart MCP Server][].
* Expandimos o [glossário][] com "combinator", "bottom type", "context type",
  "shadowing", "immutable", "wildcard", "late", "zone", e
  "type alias". (Obrigado, [IldySilva](https://github.com/IldySilva))
* Atualizamos a [documentação do JNIGen][] para remover uma referência desatualizada do Maven.

[JNIGen documentation]: /interop/java-interop
[`dart compile` documentation]: /tools/dart-compile
[Dart MCP Server guide]: {{site.flutter-docs}}/ai/mcp-server
[`dart create` page]: /tools/dart-create
[metadata and annotations documentation]: /language/metadata
["external resource type"]: {{site.repo.this}}/pull/6762
[Enabled breadcrumbs by default]: {{site.repo.this}}/pull/6767
[glossary]: /resources/glossary

[3.9 announcement]: https://blog.dart.dev/announcing-dart-3-9-ba49e8f38298
[3-9-changelog]: {{site.repo.dart.sdk}}/blob/main/CHANGELOG.md#390

## Versão 3.8

_Lançada em: 20 de maio de 2025_

Esta seção lista mudanças notáveis feitas de 13 de fevereiro de 2025
até 20 de maio de 2025 no [dart.dev](https://dart.dev/docs).
Para detalhes sobre a versão 3.8 do Dart,
confira o [anúncio do 3.8][] e o
[changelog do SDK 3.8][3-8-changelog].

### Documentação atualizada ou adicionada ao dart.dev {:.no_toc}

Além de correções de bugs e melhorias incrementais,
fizemos as seguintes alterações na documentação deste site:

* Adicionamos a documentação de [Collection elements][3-8-c-elements],
  que inclui os vários tipos de collection elements,
  incluindo expression elements, map entry elements,
  spread elements, null-aware spread elements, if elements,
  for elements. A nova documentação também explica como aninhar
  elementos.

* Adicionamos a documentação de [Doc imports][], que explica como usar a
  tag de documentação `@docImport` para referenciar elementos externos
  em comentários de documentação.

* Adicionamos a documentação de [Cross-compilation][] para o comando
  `dart compile`. Cross-compilation para Linux x64 e ARM64 agora é
  suportada nos seguintes sistemas operacionais host de 64 bits:
  macOS, Windows e Linux.

* Adicionamos a documentação de [Null-aware elements][3-8-null-aware], que
  explicam como usar o null-aware element.

* Adicionamos a documentação de [Labels][] para loops. Esta adição mostra como
  usar labels com as declarações de controle de fluxo `break` e `continue`.

* Adicionamos documentação para o arquivo [`pubspec_overrides.yaml`][].
  Este arquivo permite que você substitua certos aspectos do
  arquivo `pubspec.yaml` sem alterar o arquivo
  `pubspec.yaml`.

* Adicionamos a documentação de [Inference using bounds][] para o
  sistema de tipos.

* Adicionamos a documentação de [Records as simple data structures][] para
  tipos record.

* Adicionamos a documentação de [Self-referential type parameter restrictions (F-bounds)][]
  para tipos generic.

* Adicionamos a documentação de [Implicit downcast from `dynamic`][] que
  explica como fazer cast implícito de expressões com tipo
  estático `dynamic` para um tipo mais específico.

* Adicionamos uma [política de suporte][] para o Dart SDK.

* Atualizamos a orientação sobre quando usar ou não
  class modifiers no guia [Effective Dart Design][].

* Atualizamos a orientação para preferir uma frase nominal ou
  frase verbal não imperativa para uma função ou método no
  guia [Effective Dart Documentation][]. Também incluímos
  várias pequenas alterações na orientação de documentação existente.
  Para mais informações, veja o [PR 6522][].

* Alteramos a orientação para preferir uma frase nominal ou
  frase verbal não imperativa para uma função ou método no
  guia [Effective Dart Documentation][].

### Mudanças no site para o dart.dev {:.no_toc}

Além de correções de bugs e melhorias incrementais,
fizemos as seguintes mudanças estruturais neste site:

* Adicionamos um novo design baseado em cards e a capacidade de pesquisar
  por entradas no [glossário][].

  <img src="/assets/img/whats-new/3-8-glossary.png" alt="Glossary" style="width:50%">

* Novos botões de página anterior e próxima para o site de documentação.

  <img src="/assets/img/whats-new/3-8-prev-next-buttons-new.png" alt="New page buttons" style="width:80%">

* Adicionamos páginas individuais para algumas [mensagens de diagnóstico][].
  Para ver uma página individual para uma mensagem de diagnóstico, selecione
  o botão **Learn more**.

  <img src="/assets/img/whats-new/3-8-diagnostic-docs.png" alt="Learn more button" style="width:50%">

[3.8 announcement]: https://blog.dart.dev/announcing-dart-3-8-724eaaec9f47
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

## Versão 3.7

_Lançada em: 12 de fevereiro de 2025_

Esta seção lista mudanças notáveis feitas de 12 de dezembro de 2024
até 12 de fevereiro de 2025.
Para detalhes sobre a versão 3.7 do Dart,
confira o [anúncio do 3.7][] e o [changelog do SDK][3-7-changelog].

[3.7 announcement]: https://blog.dart.dev/announcing-dart-3-7-bf864a1b195c
[3-7-changelog]: {{site.repo.dart.sdk}}/blob/main/CHANGELOG.md#370

### Documentação atualizada ou adicionada ao dart.dev {:.no_toc}

Além de correções de bugs e melhorias incrementais,
fizemos as seguintes alterações neste site:

* Introduzimos o novo algoritmo do sistema de tipos, [inference using bounds][].
* Adicionamos links para nossa nova conta no [Bluesky][].
* Atualizamos a página do [`dart format`][] para refletir o novo estilo do formatter,
  incluindo o novo recurso de [configurable line length][].
* Documentamos o novo recurso de [shared analysis options][].
* Alteramos a entrada do Effective Dart sobre [line length][] devido ao novo
  estilo do formatter.
* Introduzimos detalhes sobre [stray files][] na página Workspaces.
* Adicionamos o novo recurso da linguagem [wildcard variables][] à página Variables.
* Movemos a [explicação de covariant][] para a página Type system, que é mais adequada.
* Alteramos as referências às bibliotecas de [legacy JS interop][] explicitamente para "deprecated".
* Removemos a página experimental de macros, já que a equipe [pausou indefinidamente][]
  o trabalho no recurso.
* Adicionamos um [aviso][map-warn] de que desestruturar um padrão Map por uma chave inexistente
  lançará um `StateError`.
* Reformulamos a página de [linter rules][] com novos cards, formato de pesquisa e
  ícones com código de cores nas páginas de lint individuais ([por exemplo][]).
* Redesenhamos a implementação do layout e sidenav para eficiência.
* Removemos a página da biblioteca `dart:html` oficialmente descontinuada.

[inference using bounds]: /language/type-system/#type-argument-inference
[for example]: /tools/linter-rules/annotate_overrides
[Bluesky]: https://bsky.app/profile/dart.dev
[configurable line length]: /tools/dart-format#configuring-formatter-page-width
[shared analysis options]: /tools/analysis#including-shared-options
[line length]: /effective-dart/style#prefer-lines-80-characters-or-fewer
[stray files]: /tools/pub/workspaces#stray-files
[wildcard variables]: /language/variables#wildcard-variables
[covariant explanation]: /language/type-system#covariant-keyword
[legacy JS interop]: /interop/js-interop/past-js-interop
[indefinitely paused]: https://blog.dart.dev/an-update-on-dart-macros-data-serialization-06d3037d4f12
[map-warn]: /language/pattern-types#map

## Versão 3.6

_Lançada em: 11 de dezembro de 2024_

Esta seção lista mudanças notáveis feitas de 7 de agosto de 2024
até 11 de dezembro de 2024.
Para detalhes sobre a versão 3.6 do Dart,
confira o [anúncio do 3.6][] e o [changelog do SDK][3-6-changelog].

[3.6 announcement]: https://blog.dart.dev/announcing-dart-3-6-778dd7a80983
[3-6-changelog]: {{site.repo.dart.sdk}}/blob/main/CHANGELOG.md#360

### Documentação atualizada ou adicionada ao dart.dev {:.no_toc}

Além de correções de bugs e melhorias incrementais,
fizemos as seguintes alterações neste site:

* Documentamos o novo recurso [pub workspaces][].
* Explicamos a nova flag `pub get` [`--enforce-lockfile`][].
* Introduzimos orientação sobre [synchronous communication][] entre muitos isolates
  na página Concurrency.
* Adicionamos o novo recurso da linguagem [digit separators][] à página Built-in types.
* Definimos [variance and variance positions][] na página do glossário.
* Criamos uma nova página para o novo recurso [documentation comment references][].
* Atualizamos e melhoramos o [gráfico de plataformas Dart][] para incluir suporte recém-disponível
  para compilação para RISC-V e WASM.
* Definimos [function types][].
* Adicionamos definições no glossário para os diferentes tipos de code fixes disponíveis
  do analyzer ([assists][], [refactors][] e [quick fixes][]).
* Criamos uma [página][bump-page] para o novo comando `pub bump`.
* Atualizamos o [exemplo para generative constructors][] para refletir o uso de
  parâmetros posicionais opcionais com valores padrão.
* Melhoramos a [documentação de import/export][] condicional na página de criação de pacotes.
* Incluímos annotations `@override` nos [exemplos de código de mixin][] para mostrar corretamente
  como trabalhar com funções mixed-in.
* Fornecemos uma alternativa ao SSH para acessar dependências de repositórios privados na
  [página de dependências pub][].
* Adicionamos um novo aviso do `pub publish` sobre validação de `git status` limpo à
  [lista de tarefas de publicação][].
* Descontinuamos as páginas Language e Library tour (o conteúdo agora está em páginas individuais
  em [Language][lang-sidenav] e [Core libraries][lib-sidenav]
  no painel de navegação lateral esquerdo).

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

## Versão 3.5

_Lançada em: 6 de agosto de 2024_

Esta seção lista mudanças notáveis feitas de 15 de maio de 2024
até 6 de agosto de 2024.
Para detalhes sobre a versão 3.5 do Dart,
confira o [anúncio do 3.5][] e o [changelog do SDK][3-5-changelog].

[3.5 announcement]: https://blog.dart.dev/dart-3-5-6ca36259fa2f
[3-5-changelog]: {{site.repo.dart.sdk}}/blob/main/CHANGELOG.md#350---2024-08-06

### Documentação atualizada ou adicionada ao dart.dev {:.no_toc}

Além de correções de bugs e melhorias incrementais,
fizemos as seguintes alterações neste site:

* Esclarecemos o status e usos pretendidos das
  [bibliotecas de plataforma web][] novas e legadas.
* Expandimos a documentação sobre [publicação de versões prerelease][]
  de pacotes no site pub.dev.
* Adicionamos uma página cobrindo o novo [comando `dart pub unpack`][].
* Documentamos a nova [flag `--skip-validation`][] para `dart pub publish` e
  a [flag `--tighten`][] para `dart pub downgrade`.
* Fornecemos orientação de melhores práticas para autores de pacotes
  [testarem seus pacotes com dependências rebaixadas][].
* Melhoramos o guia [Fixing type promotion failures][] e adicionamos
  destaque de código para indicar melhor o código relevante.
* Complementamos a [documentação de instalação do Dart][] com
  instruções de desinstalação e limpeza.
* Introduzimos nova documentação e exemplos de código cobrindo
  [function][func-tear] e [constructor][cons-tear] tear-offs.
* Explicamos como [exportar funções e objetos Dart para serem usados a partir de JS][].
* Adicionamos entradas no glossário para [subclass][] e [subtype][]
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

## Versão 3.4

_Lançada em: 14 de maio de 2024_

Esta seção lista mudanças notáveis feitas de 16 de fevereiro de 2024
até 14 de maio de 2024.
Para detalhes sobre a versão 3.4,
confira o [post do blog 3.4][] e o [changelog do SDK][3-4-changelog].

[3.4 blog post]: https://blog.dart.dev/dart-3-4-bd8d23b4462a
[3-4-changelog]: {{site.repo.dart.sdk}}/blob/main/CHANGELOG.md#340---2024-05-14

### Documentação atualizada ou adicionada ao dart.dev {:.no_toc}

Além de correções de bugs e melhorias incrementais,
fizemos as seguintes alterações neste site:

* Adicionamos uma página documentando o recurso experimental da linguagem [Macros][].
* Adicionamos uma página para acompanhar os desenvolvimentos de [Wasm][] para o Dart.
* Refatoramos a página [Constructors][].
* Esclarecemos as instruções na seção [Renames][] da página de migração do
  `package:web`.
* Ajustamos a entrada do Effective Dart sobre [enabling type promotion][] para recomendar
  o padrão null-check antes de outros idiomas.
* Revisamos a lista de [Web libraries and packages][] para representar melhor as
  soluções recomendadas.
* Explicamos como desestruturar campos nomeados nas páginas [Records][] e [Patterns][].
* Incluímos uma [tabela antes-e-depois][] de soluções web na página JS interop.
* Adicionamos uma seção explicando [spread operators][] à página Operators.
* Esclarecemos a ordem de [parenthetical patterns][] na página Pattern types.
* Adicionamos documentação para [`ExternalDartReference`][] à página JS types.
* Atualizamos o site para novas [linter rules][] e [mensagens de diagnóstico][],
  por exemplo, adicionando documentação para o novo diagnóstico de annotation [`@mustBeConst`][].

[Macros]: https://blog.dart.dev/an-update-on-dart-macros-data-serialization-06d3037d4f12
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
[before-and-after table]: /interop/js-interop/#next-generation-js-interop
[spread operators]: /language/operators/#spread-operators
[parenthetical patterns]: /language/pattern-types/#parenthesized
[`ExternalDartReference`]: /interop/js-interop/js-types/#jsboxeddartobject-vs-externaldartreference

### Artigos adicionados ao blog do Dart {:.no_toc}

Publicamos os seguintes artigos no blog do Dart:

* [History of JS interop in Dart][blog-3-28-24]
* [Dart in Google Summer of Code 2024][blog-3-5-24]

[blog-3-28-24]: https://blog.dart.dev/history-of-js-interop-in-dart-98b06991158f
[blog-3-5-24]: https://blog.dart.dev/dart-in-google-summer-of-code-2024-8ca45fb6dc4e

## Versão 3.3

_Lançada em: 15 de fevereiro de 2024_

Esta seção lista mudanças notáveis feitas de 16 de novembro de 2023
até 15 de fevereiro de 2024.
Para detalhes sobre a versão 3.3,
confira o [post do blog 3.3][] e o [changelog do SDK][3-3-changelog].

[3.3 blog post]: https://blog.dart.dev/dart-3-3-325bf2bf6c13
[3-3-changelog]: {{site.repo.dart.sdk}}/blob/main/CHANGELOG.md#330

### Documentação atualizada ou adicionada ao dart.dev {:.no_toc}

Além de correções de bugs e melhorias incrementais,
fizemos as seguintes alterações neste site:

* Alteramos a infraestrutura do site para [executar no 11ty][] em vez de Jekyll.
* Adicionamos uma página cobrindo o novo recurso da linguagem [extension types][].
* Adicionamos um novo conjunto de documentação sobre [JavaScript interop][]:
  * [Usage][]
  * [JS types][]
  * [Tutorials][], dos quais o primeiro é sobre [Mocks][]
  * [Past JS interop][]
* Atualizamos a visão geral de [Concurrency][], além de uma nova página prática sobre uso de [Isolates][].
* Adicionamos uma seção sobre [`external`][] à página [Functions][].
* Removemos o DartPad incorporado de algumas páginas para acomodar
  a nova versão do [DartPad][].
* Incluímos uma definição para "Function" no [Glossário][].
* Desconstruímos o [Library tour][] em páginas individuais para cada biblioteca.
* Atualizamos a página [Breaking changes][] para 3.3.
* Atualizamos algumas entradas desatualizadas na página de [FAQ](/resources/faq).
* Expandimos a documentação sobre [`dart doc`][].
* Atualizamos e simplificamos o conteúdo de [plataformas suportadas][].
* Consolidamos múltiplos conteúdos de [`dart format`][].
* Atualizamos vários locais para sugerir [`package:web`][] em vez de `dart:html`.
* Deixamos de recomendar [`dart:html`][] e [`dart:io`][]
  para fazer requisições HTTP, em favor de `package:http`.
* Documentamos [supressão de diagnósticos em um arquivo pubspec][].
* Adicionamos conteúdo sobre [criação][] e [ignorar][] avisos de segurança em um arquivo pubspec.
* Documentamos [como migrar de uma versão de pacote retraída][retract].

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


## Versão 3.2

_Lançada em: 15 de novembro de 2023_

Esta seção lista mudanças notáveis feitas de 17 de agosto de 2023
até 15 de novembro de 2023.
Para detalhes sobre a versão 3.2,
confira o [post do blog 3.2][] e o [changelog do SDK][3-2-changelog].

[3.2 blog post]: https://blog.dart.dev/dart-3-2-c8de8fe1b91f
[3-2-changelog]: {{site.repo.dart.sdk}}/blob/main/CHANGELOG.md#320---2023-11-15

### Documentação atualizada ou adicionada ao dart.dev {:.no_toc}

Além de correções de bugs e melhorias incrementais,
fizemos as seguintes alterações neste site:

* Atualizamos a página [Fixing type promotion failures][no-promo]
  para um novo recurso de type promotion: private final field promotion.
  * Fizemos pequenos ajustes relacionados à entrada do Effective Dart sobre
    [type promotion][], a página [Understanding Null Safety][] e outros vários
    lugares no site.
* Introduzimos documentação sobre o recurso experimental native assets
  à página [C interop][].
* Criamos uma nova página dedicada a documentar [Breaking changes][].
* Contabilizamos novos e atualizados [lints][] e [diagnostics][] em suas
  respectivas páginas de documentação.
* Adicionamos documentação para a nova flag `--tighten` à página [`pub upgrade`].
* Removemos o cheatsheet em favor da página [Language overview][].
* Esclarecemos a relação entre [guard clauses and patterns][].
* Ajustamos a página [Constructors][] para representar melhor as melhores práticas.
* Melhoramos o conteúdo da página [Package dependencies][] para ser mais acionável
  e mais fácil de seguir.
* Elaboramos sobre membros estáticos na página [Extension methods][].
* Alteramos o conteúdo de limitações de multithreading [Objective-C][] para contabilizar
  a nova API `NativeCallable`.
* Adicionamos novas annotations e mencionamos descontinuações na página [Metadata][].
* Melhoramos o contraste ajustando cores de texto e destaque
  em exemplos de código em todo o site.
* Reorganizamos e simplificamos a infraestrutura do site de modo geral, em preparação
  para [deixar de usar Jekyll][].

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

## Versão 3.1

_Lançada em: 16 de agosto de 2023_

Esta seção lista mudanças notáveis feitas de 11 de maio de 2023
até 16 de agosto de 2023.
Para detalhes sobre a versão 3.1,
confira
[Dart 3.1 & a retrospective on functional style programming in Dart 3][]
e o [changelog do SDK][3-1-changelog].

[Dart 3.1 & a retrospective on functional style programming in Dart 3]: https://blog.dart.dev/dart-3-1-a-retrospective-on-functional-style-programming-in-dart-3-a1f4b3a7cdda
[3-1-changelog]: {{site.repo.dart.sdk}}/blob/main/CHANGELOG.md#310---2023-08-16

### Documentação atualizada ou adicionada ao dart.dev {:.no_toc}

Além de correções de bugs e melhorias incrementais,
fizemos as seguintes alterações neste site:

* Reformulamos a documentação de linter rule para substituir o antigo site do linter:
  * Movemos a documentação de cada linter rule para sua própria página.
    Por exemplo: [`avoid_dynamic_calls`][].
  * Adicionamos um exemplo de `analysis_options.yaml` que habilita
    [todas as linter rules][] disponíveis na versão mais recente do Dart.
  * Atualizamos o [índice de todas as linter rules disponíveis][]
    para permitir descoberta mais fácil de lints.
* Aumentamos a documentação de [class modifiers][] adicionando uma
  [Class modifiers reference][] para delinear como eles interagem entre si.
* Introduzimos um guia [Class modifiers for API maintainers][] para ajudar
  desenvolvedores a usar melhor os class modifiers.
* Reescrevemos a documentação de [switch expression][]
  para contabilizar melhor suas diferenças com switch statements.
* Documentamos o suporte para especificar [topics][] no seu arquivo pubspec
  para categorizar seu pacote no site pub.dev.
* Esclarecemos que [package screenshots][] são destinados a
  mostrar a funcionalidade do pacote, não o logo ou ícone do pacote.
* Adicionamos botões anterior e próximo à
  [documentação da linguagem][] do Dart para permitir uma experiência de aprendizado guiada.
* Continuamos expandindo o novo [glossário][] em todo o site.
* Adicionamos uma nota de migração sobre como a
  [movimentação do pub cache][] no Windows foi finalizada no Dart 3.
* Simplificamos e atualizamos documentação antiga agora que
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

### Artigos adicionados ao blog do Dart {:.no_toc}

Publicamos o seguinte artigo no blog do Dart:

* [Dart DevTools: Analyzing application performance with the CPU Profiler][blog-6-12-23]

[blog-6-12-23]: https://blog.dart.dev/dart-devtools-analyzing-application-performance-with-the-cpu-profiler-3e94a0ec06ae

## Versão 3.0

_Lançada em: 10 de maio de 2023_

Esta seção lista mudanças notáveis feitas de 26 de janeiro de 2023
até 10 de maio de 2023.
Para detalhes sobre a versão principal 3.0,
confira [Announcing Dart 3][]
e o [changelog do SDK][3-0-changelog].

[Announcing Dart 3]: https://blog.dart.dev/announcing-dart-3-53f065a10635
[3-0-changelog]: {{site.repo.dart.sdk}}/blob/main/CHANGELOG.md#300---2023-05-10

### Documentação atualizada ou adicionada ao dart.dev {:.no_toc}

Em preparação para o Dart 3, dividimos e reorganizamos o
Language Tour em novas categorias conceituais.
Você pode acessar a documentação de linguagem reestruturada
em **Language** no menu de navegação lateral, ou
visitando a [Introduction to Dart][] atualizada.

Aproveitando essa nova estrutura,
adicionamos documentação para cada um dos principais recursos do Dart 3:

- [Pattern matching][] e os diferentes [tipos de patterns][].
- [Switch expressions][] com suporte para
  patterns e [exhaustiveness checking][].
- [If statements with case clauses][] para suportar pattern matching.
- [Records][], um novo tipo anônimo, imutável e agregado
  que permite [múltiplos retornos][].
- [Class modifiers][] que dão às bibliotecas mais controle sobre tipos exportados.

Para ajudá-lo na transição para a aplicação de [sound null safety][] do Dart 3
e outras mudanças, também preparamos as seguintes atualizações:

- Criamos um [guia de migração para Dart 3][] abrangente.
- Migramos toda a documentação e exemplos de código
  para Dart 3, as versões mais recentes das ferramentas e as dependências mais recentes.
- Esclarecemos que o sistema de tipos do Dart agora é sempre null-safe no Dart 3.
- Atualizamos e reorganizamos a página [Language evolution][]
  e sua discussão sobre [language versioning][].
- Removemos resquícios de documentos, notas e recursos do Dart 1 e início do Dart 2.

Além do novo conteúdo do Dart 3 e
atualizações correspondentes em todo o site,
fizemos as seguintes alterações:

- Adicionamos um guia sobre configuração de [compilation environment declarations][].
- Continuamos o trabalho de interoperabilidade nativa do Dart
  adicionando um guia sobre suporte experimental para [Java interop][].
- Esclarecemos o uso e limitações de [unnamed extensions][].
- Adicionamos uma página para o novo comando [`dart info`][]
  que ajuda com diagnósticos de ferramentas.
- Reformulamos a documentação de [`dart pub add`][]
  para cobrir sua nova sintaxe [source descriptor][].
- Disponibilizamos builds de preview Linux RISC-V (RV64GC) no
  canal beta no [arquivo SDK][].
- Iniciamos um novo [glossário][] em todo o site para conter
  termos comuns usados em todo o site.
- Destacamos o trabalho experimental no [suporte de JS static interop][] do Dart.
- Documentamos a existência e limitações atuais de [analyzer plugins][].

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
[language versioning]: /resources/language/evolution#language-versioning
[compilation environment declarations]: /libraries/core/environment-declarations
[Java interop]: /interop/java-interop
[unnamed extensions]: /language/extension-methods#unnamed-extensions
[`dart info`]: /tools/dart-info
[`dart pub add`]: /tools/pub/cmd/pub-add
[source descriptor]: /tools/pub/cmd/pub-add#source-descriptor
[SDK archive]: /get-dart/archive
[glossary]: /resources/glossary
[JS static interop support]: /interop/js-interop
[analyzer plugins]: /tools/analysis#plugins

### Artigos adicionados ao blog do Dart {:.no_toc}

Publicamos o seguinte artigo no blog do Dart:

* [Introducing Realm for Dart & Flutter][blog-2-09-23]

[blog-2-09-23]: https://blog.dart.dev/introducing-realm-for-dart-flutter-e30cb05eb313

### Vídeos lançados pela equipe Dart {:.no_toc}

Durante o Google I/O 2023, lançamos os seguintes vídeos:

* [What's new in Dart and Flutter][] ([versão em American Sign Language][])
* [Rethinking Dart interoperability with Android][]
* [How to build a package in Dart][]

[What's new in Dart and Flutter]: {{site.yt.watch}}?v=yRlwOdCK7Ho
[American Sign Language version]: {{site.yt.watch}}?v=QbMgjVB0XMI
[Rethinking Dart interoperability with Android]: {{site.yt.watch}}?v=ZWp2FJ2TuJs
[How to build a package in Dart]: {{site.yt.watch}}?v=8V_TLiWszK0

## Versões 2.19 + 3.0 alpha

_Lançadas em: 25 de janeiro de 2023_

Esta seção lista mudanças notáveis feitas de 31 de agosto de 2022
até 25 de janeiro de 2023.
Para detalhes sobre as versões 2.19 + 3.0 alpha,
veja [Introducing Dart 3 alpha][]
e o [changelog do SDK][2-19-changelog].

[Introducing Dart 3 alpha]: https://blog.dart.dev/dart-3-alpha-f1458fb9d232
[2-19-changelog]: {{site.repo.dart.sdk}}/blob/main/CHANGELOG.md#2190---2023-01-24

### Documentação atualizada ou adicionada ao dart.dev {:.no_toc}

Além de correções de bugs e melhorias incrementais,
fizemos as seguintes alterações neste site:

* Introduzimos o tutorial [Fetch data from the internet][] sobre uso de `package:http`.
* Adicionamos uma página sobre [Automated publishing of packages to pub.dev][].
* Incluímos links para duas novas traduções do site em nossa seção [community resources][]:
  * [Versão coreana deste site (한국어)](https://dart-ko.dev/)
  * [Versão em chinês tradicional deste site (正體中文版)](https://dart.tw.gh.miniasp.com/)
* Atualizamos o conteúdo de null safety em preparação para o Dart 3:
  * Alteramos as restrições de versão no [guia de migração][] para compatibilidade com Dart 3.
  * Adicionamos visão geral completa de sound null safety do Dart 3 à página [Sound null safety][].
  * Enfatizamos a incompatibilidade do Dart 3 com [unsound null safety][] em uma nota.
* Introduzimos o novo guia [Learning Dart as a Swift developer][].
* Substituímos uma seção do Effective Dart por orientação mais geral sobre [booleans and equality operators][].
* Documentamos [content-hashing][] em toda a documentação do pub.
* Iniciamos esforço para reformular a página [Zones][]
  alterando exemplos para usar `runZonedGuarded` em vez de `onError`.
* Atualizamos o conteúdo sobre bibliotecas para cobrir o novo desenvolvimento de declarações sem nome:
  * Effective Dart: [Documentation][], [Style][] e [Usage][]
  * Nova seção de library directive em [The language tour][]
* Melhoramos a clareza em torno do status single-threaded ou multi-threaded do Dart:
  * Removemos a página desatualizada do `dart:io`.
  * Expandimos sobre as [capacidades de concorrência web do Dart][].
* Rearranjamos e esclarecemos a [discussão][] de valores padrão para parâmetros opcionais e posicionais.
* Atualizamos [Concurrency in Dart][] para usar como padrão a nova função `Isolate.run()`.
* Documentamos especificar um caminho de arquivo ao ativar um pacote na [página `pub global`][].
* Reescrevemos [Learning Dart as a JavaScript developer][].
* Adicionamos uma breve visão geral do Dart DevTools à [página `dart run`][].
* Fornecemos mais clareza sobre [operator precedence and associativity][] no Language tour.
* Expandimos a seção Library tour sobre [Building URIs][] com informações sobre URI http e factory constructor.
* Contabilizamos a [transição do pub para pub.dev][] de pub.dartlang.org.
* Adicionamos documentação sobre [package screenshots][].
* Melhoramos a [seção explicit downcast][] da página The Dart type system.
* Aumentamos a cobertura de [analyzer][] e [lint][]:
  * Incluímos informações de suporte de versão do SDK para linter rules.
  * Adicionamos mensagens de diagnóstico e lint para mudanças do 2.19.
 
[Fetch data from the internet]: /tutorials/server/fetch-data
[Automated publishing of packages to pub.dev]: /tools/pub/automated-publishing
[community resources]: /community
[migration guide]: /null-safety/migration-guide
[unsound null safety]: /null-safety/unsound-null-safety
[Learning Dart as a Swift developer]: /resources/coming-from/swift-to-dart
[booleans and equality operators]: /effective-dart/usage#dont-use-true-or-false-in-equality-operations
[content-hashing]: /resources/glossary#pub-content-hash
[Zones]: /libraries/async/zones
[Documentation]: /effective-dart/documentation#consider-writing-a-library-level-doc-comment
[Style]: /effective-dart/style#dont-explicitly-name-libraries
[Usage]: /effective-dart/usage#do-use-strings-in-part-of-directives
[The language tour]: /language/libraries#library-directive
[Is Dart single-threaded?]: /resources/faq#q-is-dart-single-threaded
[Is Dart single-threaded on the web?]: /resources/faq#q-is-dart-single-threaded-on-the-web
[Dart's web concurrency capabilities]: /language/concurrency#concurrency-on-the-web
[discussion]: /language/functions#parameters
[Concurrency in Dart]: /language/concurrency
[`pub global` page]: /tools/pub/cmd/pub-global
[Learning Dart as a JavaScript developer]: /resources/coming-from/js-to-dart
[`dart run` page]: /tools/dart-run#debugging
[operator precedence and associativity]: /language/operators
[Building URIs]: /libraries/dart-core#building-uris
[pub's transition to pub.dev]: /tools/pub/troubleshoot#pub-get-socket-error
[package screenshots]: /tools/pub/pubspec#screenshots
[explicit downcast section]: /language/type-system#generic-type-assignment
[analyzer]: /tools/diagnostic-messages
[lint]: /tools/linter-rules

### Artigos adicionados ao blog do Dart {:.no_toc}

Publicamos os seguintes artigos no blog do Dart:

* [Better isolate management with Isolate.run()][blog-1-24-23]
* [Screenshots and automated publishing for pub.dev][blog-1-18-23]
* [The road to Dart 3: A fully sound, null safe language][blog-12-8-22]
* [Google Summer of Code 2022 Results][blog-11-3-22]
* [Partnering with GitHub on supply chain security for Dart packages][blog-10-6-22]

[blog-1-24-23]: https://blog.dart.dev/better-isolate-management-with-isolate-run-547ef3d6459b
[blog-1-18-23]: https://blog.dart.dev/screenshots-and-automated-publishing-for-pub-dev-9bceb19edf79
[blog-12-8-22]: https://blog.dart.dev/the-road-to-dart-3-afdd580fbefa
[blog-11-3-22]: https://blog.dart.dev/google-summer-of-code-2022-results-a3ce1c13c06c
[blog-10-6-22]: https://blog.dart.dev/partnering-with-github-on-an-supply-chain-security-485eed1fc388


## Versão 2.18

_Lançada em: 30 de agosto de 2022_

Esta seção lista mudanças notáveis feitas de 12 de maio de 2022
até 30 de agosto de 2022.
Para detalhes sobre a versão 2.18,
veja [Dart 2.18: Objective-C & Swift interop][]
e o [changelog do SDK][2-18-changelog].

[Dart 2.18: Objective-C & Swift interop]: https://blog.dart.dev/dart-2-18-f4b3101f146c
[2-18-changelog]: {{site.repo.dart.sdk}}/blob/main/CHANGELOG.md#2180---2022-08-30

Além de correções de bugs e melhorias incrementais,
fizemos as seguintes alterações neste site:

* Introduzimos a página [Objective-C and Swift interop][],
  que explica como usar pacotes Dart para chamar APIs dessas linguagens.
* Adicionamos uma solução alternativa para Fixing common type problems,
  para o caso raro em que a inferência de tipo pode inferir incorretamente que um tipo de argumento é null.
* Removemos toda menção de arquivos `.packages` descontinuados de [What not to commit][].
  Se você ainda precisa gerar um arquivo `.packages` devido a dependências legadas de terceiros,
  veja [Opções do `dart pub get`][].
* Removemos páginas dedicadas e qualquer outra menção das ferramentas de linha de comando descontinuadas `dart2js`
  e `dartdevc`.
  * Adicionamos opções de linha de comando e problemas conhecidos anteriormente associados ao
  `dart2js` à página [`dart compile`][].
  * Adicionamos informações sobre depuração de código de produção a [Debugging Dart web apps][].
* Adicionamos suporte para download de builds experimentais Windows ARM
  ao [arquivo do Dart SDK][].
* Atualizamos o [Library tour][] para incluir informações sobre weak references e finalizers.
* Adicionamos uma seção sobre personalização de [`dart fix`][].

[Objective-C and Swift interop]: /interop/objective-c-interop
[What not to commit]: /tools/pub/private-files
[`dart pub get` Options]: /tools/pub/cmd/pub-get#options
[`dart compile`]: /tools/dart-compile
[Debugging Dart web apps]: /web/debugging
[Dart SDK archive]: /get-dart/archive
[Library tour]: /libraries/dart-core#weak-references-and-finalizers
[`dart fix`]: /tools/dart-fix#customize

## Versão 2.17

_Lançada em: 11 de maio de 2022_

Esta seção lista mudanças notáveis feitas de 4 de fevereiro de 2022
até 11 de maio de 2022.
Para detalhes sobre a versão 2.17,
veja [Dart 2.17: Productivity and integration][].

[Dart 2.17: Productivity and integration]: https://blog.dart.dev/dart-2-17-b216bfc80c5d

### Documentação atualizada ou adicionada ao dart.dev {:.no_toc}

Além de correções de bugs e melhorias incrementais,
fizemos as seguintes alterações neste site:

* Introduzimos o guia [Learning Dart as a JavaScript developer][],
  que visa aproveitar seu conhecimento de programação JavaScript
  ao aprender Dart.
* Documentamos os recursos e mudanças introduzidos no Dart 2.17:
  * Atualizamos a seção [Named parameters][] do language tour
    para refletir o suporte para especificar argumentos nomeados em qualquer lugar.
  * Adicionamos documentação para [super-initializer parameters][].
  * Expandimos a seção [Enumerated types][] do language tour
    e documentamos [enhanced enums][].
  * Documentamos o suporte para [assinatura][] de executáveis macOS e Windows
    compilados com `dart compile exe`.
  * Atualizamos os templates suportados por [`dart create`][]
    para seus novos nomes padronizados.
* Contabilizamos mudanças no [site pub.dev][] e na [ferramenta pub][].
  * Listamos vendors oferecendo [repositórios de pacotes Dart como serviço][].
  * Removemos a documentação para o comando descontinuado `dart pub uploader`.
  * Expandimos a documentação para gerenciamento de [uploaders][] de projeto pub.
  * Removemos a maioria das menções ao arquivo `.packages` descontinuado,
    apontando em vez disso para sua substituição `.dart_tool/package_config.json`.
* Atualizamos a documentação para atualização e instalação do Dart:
  * Documentamos como alternar entre versões do Dart
    com Homebrew nas [instruções de instalação][get-dart-install] do macOS.
  * Atualizamos as [instruções de instalação][get-dart-install] do Linux
    para usar [SecureApt][] e seguir as melhores práticas mais recentes.
  * Adicionamos suporte para download de builds experimentais Linux RISC-V (RV64GC)
    do [arquivo do Dart SDK][].
* Continuamos o trabalho para melhorar e atualizar a documentação
  da [ferramenta `dart` unificada][dart-tool]:
  * Expandimos a documentação sobre a funcionalidade da ferramenta [`dart fix`][].
  * Ajustamos as diretrizes e documentação para a ferramenta [`dart doc`][]
    para corresponder à sua funcionalidade e comportamento subjacente.
  * Adicionamos mais documentação e exemplos de [`dart compile js`][].
  * Removemos menções de ferramentas standalone removidas.
* Atualizamos a documentação e uso do analyzer e linter:
  * Documentamos os novos [strict language modes][] do analyzer.
  * Incorporamos mudanças às páginas de
    [mensagens de diagnóstico][] e [linter rules][].
  * Atualizamos documentação e exemplos
    para usar a versão `2.0.0` do pacote `lints`.
* Iniciamos uma reformulação da documentação para compilação web:
  * Documentamos a descontinuação e remoção planejada
    das ferramentas standalone `dart2js` e `dartdevc`.
  * Consolidamos e esclarecemos a documentação
    de [dart2js][] e [dartdevc][]
    como os compiladores subjacentes de ferramentas como
    [`dart compile js`][] e [`webdev`][].
* Aumentamos a cobertura de documentação de null safety:
  * Documentamos o operador not-null assertion (`!`) como parte da
    seção [Other operators][] do language tour.
  * Migramos os [tutoriais de HTML de baixo nível][] para suportar null safety
    e discutir como interagir com APIs web ao usá-lo.
* Fizemos outras atualizações diversas:
  * Documentamos os [tipos nativos][] fornecidos por `dart:ffi`
    para uso em interoperabilidade C.
  * Introduzimos uma nova seção ao language tour documentando
    [initializing formal parameters][].
  * Documentamos o [suporte a pacotes][] do DartPad.
  * Corrigimos a formatação no [tutorial de programação assíncrona][]
    e elaboramos sobre [por que código assíncrono importa][].
  * Atualizamos a página de [segurança][] para corresponder às nossas práticas de segurança atuais.
  * Adicionamos uma combinação de teclas (`/`) para focar automaticamente a barra de pesquisa.

[Learning Dart as a JavaScript developer]: /resources/coming-from/js-to-dart

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

[dart2js]: /tools/dart2js
[dartdevc]: /tools/dartdevc
[`webdev`]: /tools/webdev

[Other operators]: /language/operators#other-operators
[Low-level HTML tutorials]: /web/get-started

[native types]: /interop/c-interop#interface-with-native-types
[initializing formal parameters]: /language/constructors#use-initializing-formal-parameters
[support for packages]: /tools/dartpad#library-support
[asynchronous programming tutorial]: /libraries/async/async-await
[why asynchronous code matters]: /libraries/async/async-await#why-asynchronous-code-matters
[security]: /security


### Artigos adicionados ao blog do Dart {:.no_toc}

Publicamos os seguintes artigos no blog do Dart:

* [Bulk application of fixes][blog-5-5-22]
* [Dart asynchronous programming: Streams][blog-4-14-22]
* [Contributors for Google Summer of Code 2022][blog-4-7-22]
* [Gradual null safety migration for large Dart projects][blog-3-31-22]
* [Hosting a private Dart package repository][blog-3-16-22]
* [Quick fixes for analysis issues][blog-3-4-22]

[blog-5-5-22]: https://blog.dart.dev/bulk-application-of-fixes-e6add333c3c1
[blog-4-14-22]: https://blog.dart.dev/dart-asynchronous-programming-streams-dab952023ed7
[blog-4-7-22]: https://blog.dart.dev/contributors-for-google-summer-of-code-2022-17e777f043f0
[blog-3-31-22]: https://blog.dart.dev/gradual-null-safety-migration-for-large-dart-projects-85acb10b64a9
[blog-3-16-22]: https://blog.dart.dev/hosting-a-private-dart-package-repository-774c3c51dff9
[blog-3-4-22]: https://blog.dart.dev/quick-fixes-for-analysis-issues-c10df084971a

## Versão 2.16

_Lançada em: 3 de fevereiro de 2022_

Esta seção lista mudanças notáveis feitas de 8 de dezembro de 2021
até 3 de fevereiro de 2022.
Para detalhes sobre a versão 2.16,
veja [Dart 2.16: Improved tooling and platform handling][].

[Dart 2.16: Improved tooling and platform handling]: https://blog.dart.dev/dart-2-16-improved-tooling-and-platform-handling-dd87abd6bad1

### Documentação atualizada ou adicionada ao dart.dev {:.no_toc}

[Atualizamos a infraestrutura do site][] para uma configuração baseada em Docker
para permitir [contribuições mais fáceis][] e alinhar mais de perto com
a configuração do [docs.flutter.dev]({{site.flutter-docs}}).

Além de outras correções de bugs e melhorias incrementais,
fizemos as seguintes alterações neste site:

* Mudamos para documentar a nova ferramenta [`dart doc`][]
  que substitui `dartdoc`.
* Documentamos a nova [entrada `platform`][] para especificar plataformas suportadas
  no `pubspec.yaml` de um pacote.
* Atualizamos as páginas de [mensagens de diagnóstico][] e [linter rules][].
* Documentamos como [ignorar todas as linter rules][] em um arquivo.
* Removemos menções das antigas ferramentas standalone da [visão geral do Dart SDK][].
* Atualizamos as menções restantes das antigas ferramentas standalone
  para seus equivalentes da ferramenta [`dart`].
* Adicionamos esclarecimentos à orientação do Effective Dart
  [PREFER using interpolation to compose strings and values][].

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


## Versão 2.15

_Lançada em: 8 de dezembro de 2021_

Esta seção lista mudanças notáveis feitas de 9 de setembro de 2021
até 8 de dezembro de 2021.
Para detalhes sobre a versão 2.15, veja [Announcing Dart 2.15][].

[Announcing Dart 2.15]: https://blog.dart.dev/dart-2-15-7e7a598e508a

### Documentação atualizada ou adicionada ao dart.dev {:.no_toc}

Além de correções de bugs e melhorias incrementais,
fizemos as seguintes alterações neste site:

* Adicionamos [Concurrency in Dart][], que discute recursos como
  isolates que permitem execução paralela de código Dart.
* Documentamos recursos do pub adicionados ou melhorados no 2.15:
  * Adicionamos uma página para um novo subcomando pub, [dart pub token][],
    e uma página sobre [repositórios de pacotes personalizados][]
  * Adicionamos informações sobre [retração de pacotes][]
  * Adicionamos o campo [false_secrets][] à página pubspec
  * Atualizamos a sintaxe para [dependências hospedadas][]
* Removemos todas as entradas de [livros][] do Dart 1
* Expandimos sobre [dicas de solução de problemas do DartPad][]
* Atualizamos a página de [mensagens de diagnóstico][]
* Atualizamos a página de [linter rules][];
  removemos referências a conjuntos de regras descontinuadas como
  `effective_dart`
* Atualizamos as instruções para instalação e uso do
  [Dart DevTools][]
* Adicionamos informações sobre o que o [runtime do Dart][] fornece,
  e esclarecemos os [formatos de compilação][]

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


## Versão 2.14

_Lançada em: 8 de setembro de 2021_

Esta seção lista mudanças notáveis feitas de 20 de maio de 2021
até 8 de setembro de 2021.
Para detalhes sobre a versão 2.14, veja [Announcing Dart 2.14][].

[Announcing Dart 2.14]: https://blog.dart.dev/announcing-dart-2-14-b48b9bb2fb67

### Documentação atualizada ou adicionada ao dart.dev {:.no_toc}

Além de correções de bugs e melhorias incrementais,
fizemos as seguintes alterações neste site:

* Desenvolvemos a página sobre [fixing type promotion failures][no-promo].
* Documentamos como usar o [arquivo `.pubignore`][],
  um recurso que foi introduzido no Dart 2.14.
* Adicionamos cobertura do [unsigned shift operator][] (`>>>`),
  que foi introduzido no Dart 2.14.
* Construímos a [página de linter rule][];
  atualizamos o Effective Dart para vincular a ela.
* Adicionamos páginas para os
  comandos [`dart create`][] e [`dart test`][].
* Terminamos de converter exemplos do uso de antigas ferramentas de linha de comando
  (por exemplo, `dartfmt`) para usar a [ferramenta `dart` unificada][dart-tool]
  (por exemplo, `dart format`).
* Atualizamos o código do site para usar as [linter rules recomendadas][],
  em vez de pedantic.
* Atualizamos as listas de [bibliotecas principais][] e [pacotes comumente usados][].
* Adicionamos um redirecionamento de [dart.dev/jobs][] para flutter.dev/jobs,
  para facilitar a localização de vagas abertas nas
  equipes Dart e Flutter.
* Terminamos de migrar todo código analisado ou testado para null safety,
  atualizando o texto para corresponder.
  Encontramos mais código do site que não havia sido analisado; corrigimos isso.

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

### Artigos adicionados ao blog do Dart {:.no_toc}

Publicamos os seguintes artigos no blog do Dart:

* [Experimenting with Dart and Wasm][blog-7-27-21]
* [How Dart's null safety helped me augment my projects][blog-6-23-21]
* [Implementing structs by value in Dart FFI][blog-6/8-21]

[blog-7-27-21]: https://blog.dart.dev/experimenting-with-dart-and-wasm-ef7f1c065577
[blog-6-23-21]: https://blog.dart.dev/how-darts-null-safety-helped-me-augment-my-projects-af58f8129cf
[blog-6/8-21]: https://blog.dart.dev/implementing-structs-by-value-in-dart-ffi-1cb1829d11a9


## Versão 2.13

_Lançada em: 19 de maio de 2021_

Esta seção lista mudanças notáveis feitas de 4 de março de 2021
até 19 de maio de 2021.
Para detalhes sobre a versão 2.13, veja [Announcing Dart 2.13][].

[Announcing Dart 2.13]: https://blog.dart.dev/announcing-dart-2-13-c6d547b57067

### Documentação atualizada ou adicionada ao dart.dev {:.no_toc}

Além de correções de bugs e melhorias incrementais,
fizemos as seguintes alterações neste site:

* Atualizamos a [seção typedef][] do language tour para refletir
  aliases de tipos não-função,
  que foram introduzidos no Dart 2.13.
* Publicamos ou atualizamos documentação relacionada à linha de comando e servidores:
  * [Using Google Cloud][] descreve produtos do Google Cloud que
    servidores Dart podem usar,
    frequentemente com a ajuda de imagens Docker pré-empacotadas.
  * O [tutorial de servidor HTTP][],
    que apresentava o pacote `http_server` descontinuado,
    foi temporariamente substituído por
    uma página "em construção" que
    vincula a documentação e exemplos úteis.
  * O [tutorial de linha de comando][] foi completamente atualizado.
* Publicamos algumas outras páginas novas:
  * Codelab de null safety que ensina sobre o sistema de tipos null-safe do Dart,
    que foi introduzido no Dart 2.12.
  * [Numbers in Dart][] tem
    detalhes sobre diferenças entre implementações de números nativas e web.
  * [Using Google APIs][] aponta para recursos para
    ajudá-lo a usar Firebase e APIs de cliente Google a partir de um app Dart.
  * [Writing package pages][] dá dicas para
    escrever um README de pacote que funcione bem no pub.dev.
  * [Fixing type promotion failures][]
    tem informações para ajudá-lo a entender
    por que falhas de type promotion ocorrem, e dá dicas sobre como corrigi-las.
  * A nova [página `dart run`][]
    descreve como executar um programa Dart a partir da linha de comando.
* Continuamos o trabalho de migração de código para null safety, em particular o
  [tutorial de streams][].
* Fizemos outras atualizações diversas:
  * Removemos referências ao Stagehand, em favor de [`dart create`][].
  * Alteramos as opções de analytics para código de exemplo do dart.dev de
    usar `pedantic` para usar as regras recomendadas em [`lints`][].
  * Adicionamos Docker como uma forma de [obter Dart][].
  * Atualizamos a [página de evolução da linguagem][evolution] para refletir o Dart 2.13.

[command-line tutorial]: /tutorials/server/cmdline
[`dart run` page]: /tools/dart-run
[`dart create`]: /tools/dart-create
[Fixing type promotion failures]: /tools/non-promotion-reasons
[get Dart]: /get-dart
[HTTP server tutorial]: /tutorials/server/httpserver
[`lints`]: {{site.pub-pkg}}/lints
[Numbers in Dart]: /resources/language/number-representation
[streams tutorial]: /libraries/async/using-streams
[typedef section]: /language/typedefs
[Using Google APIs]: /resources/google-apis
[Using Google Cloud]: /server/google-cloud
[Writing package pages]: /tools/pub/writing-package-pages


### Artigos adicionados ao blog do Dart {:.no_toc}

Publicamos os seguintes artigos no blog do Dart:

* [AngularDart, Flutter, and the web: Spring update][blog-5-12-21]
* [Announcing Dart support for GitHub Actions][blog-3-24-21]
* [Dart in Google Summer of Code 2021][blog-3-13-21]

[blog-5-12-21]: https://blog.dart.dev/angulardart-flutter-and-the-web-spring-update-f7f5b8b10001
[blog-3-24-21]: https://blog.dart.dev/announcing-dart-support-for-github-actions-3d892642104
[blog-3-13-21]: https://blog.dart.dev/dart-in-google-summer-of-code-2021-e89eaf1d177a


## Versão 2.12

_Lançada em: 3 de março de 2021_

Esta seção lista mudanças notáveis feitas de 2 de outubro de 2020
até 3 de março de 2021.
Para detalhes sobre a versão 2.12, veja [Announcing Dart 2.12][].


### Documentação atualizada ou adicionada ao dart.dev {:.no_toc}

Além de correções de bugs e melhorias incrementais, fizemos as seguintes alterações neste site:

* Atualizamos e desenvolvemos a documentação de null safety. Notavelmente:
  * Fornecemos um [guia de migração][].
  * Adicionamos um [FAQ][ns-faq].
  * Criamos [Unsound null safety][].
  * Simplificamos a [página inicial de null safety][].
* Renovamos o [Effective Dart][], atualizando código para ser null safe e
  alterando regras para refletir nova orientação.
* Renovamos o [language tour][], atualizando código para ser null safe e
  adicionando informações sobre novos recursos como
  [variáveis `late`][].
* Atualizamos a [página de evolução da linguagem][evolution]
  para adicionar informações sobre versionamento de linguagem
  e para refletir o Dart 2.12.
* Atualizamos o [library tour][] e [tutoriais][]
  para refletir sound null safety.
* Atualizamos páginas em todo o site para usar [a ferramenta `dart`][]
  em vez de comandos descontinuados.
  Começamos a adicionar páginas para vários comandos `dart`, incluindo
  [`dart analyze`][], [`dart compile`][], [`dart fix`][]
  e [`dart format`][].
* Criamos uma página documentando a qualidade e suporte de [pacotes da equipe Dart][].
* Substituímos a página Platforms por uma nova [página Overview][].
* Criamos esta página ("Novidades").

Também mudamos do Travis CI para GitHub Actions, e fizemos múltiplas alterações CSS para melhorar a legibilidade do site.

[Announcing Dart 2.12]: https://blog.dart.dev/announcing-dart-2-12-499a6e689c87
[migration guide]: /null-safety/migration-guide
[ns-faq]: /null-safety/faq
[Unsound null safety]: /null-safety/unsound-null-safety
[null safety homepage]: /null-safety
[Overview page]: /overview
[Effective Dart]: /effective-dart
[language tour]: /language
[`late` variables]: /language/variables#late-variables
[library tour]: /libraries
[tutorials]: /tutorials
[the `dart` tool]: /tools/dart-tool
[`dart analyze`]: /tools/dart-analyze
[`dart compile`]: /tools/dart-compile
[`dart fix`]: /tools/dart-fix
[`dart format`]: /tools/dart-format
[Dart team packages]: /resources/dart-team-packages


### Artigos adicionados ao blog do Dart {:.no_toc}

Publicamos os seguintes artigos no blog do Dart:

* [Preparing the Dart and Flutter ecosystem for null safety][blog-2-16-21]
  anunciou estabilidade da API de null safety e
  convidou desenvolvedores a publicar versões estáveis e null-safe de seus pacotes.
* [Dart and the performance benefits of sound types][blog-1-19-21]
  demonstrou como soundness e null safety permitem que compiladores Dart
  gerem código mais rápido e menor.
* [Why nullable types?][blog-12-7-20]
  expandiu uma discussão no subreddit /r/dart_lang,
  respondendo à pergunta "Por que não se livrar completamente de null?"
* [Announcing Dart null safety beta][blog-11-19-20]
  convidou desenvolvedores a começar a planejar sua migração para null safety.

[blog-2-16-21]: https://blog.dart.dev/preparing-the-dart-and-flutter-ecosystem-for-null-safety-e550ce72c010
[blog-1-19-21]: https://blog.dart.dev/dart-and-the-performance-benefits-of-sound-types-6ceedd5b6cdc
[blog-12-7-20]: https://blog.dart.dev/why-nullable-types-7dd93c28c87a
[blog-11-19-20]: https://blog.dart.dev/announcing-dart-null-safety-beta-87610fee6730

## Versão 2.10

_Lançada em: 1º de outubro de 2020_

Esta seção lista mudanças notáveis feitas de
1º de julho até 1º de outubro de 2020.
Para detalhes sobre a versão 2.10, veja [Announcing Dart 2.10.][210-ann]

[210-ann]: https://blog.dart.dev/announcing-dart-2-10-350823952bd5

<div class="no_toc_section">

### Documentação atualizada ou adicionada ao dart.dev {:.no_toc}

Além de correções de bugs e pequenas melhorias,
fizemos as seguintes alterações neste site:

* Adicionamos uma [página da ferramenta `dart`][dart-tool]
  para documentar a nova interface de linha de comando para o Dart SDK.
  A nova ferramenta `dart` é análoga à ferramenta `flutter` no Flutter SDK.
  Anteriormente, o comando `dart` apenas executava apps de linha de comando.
  Atualizamos a página anterior do `dart` de acordo
  e planejamos atualizar referências a outras ferramentas ao longo do tempo.
* Atualizamos a [documentação de changelog de pacote][changelog-docs]
  para recomendar um formato padrão para arquivos `CHANGELOG.md`.
  Este novo formato permite que ferramentas
  (como o pub.dev relançado)
  analisem changelogs.
* Alteramos uma orientação do [Effective Dart][] para favorecer
  usar `Object` em vez de `dynamic`.
  Para detalhes, veja a orientação revisada
  [AVOID using `dynamic` unless you want to disable static checking.][dynamic]
* Atualizamos a [página de mensagens de diagnóstico][diagnostics] para
  incluir mais mensagens produzidas pelo analyzer Dart.
* Atualizamos a [página de evolução][evolution]
  para incluir 2.9 e 2.10.
* Reorganizamos a [página de especificação da linguagem][spec]
  para facilitar a localização da versão PDF da
  especificação mais recente em andamento.
* Adicionamos ou atualizamos documentação relacionada a [sound null safety][],
  um recurso que está chegando à linguagem Dart:
  * Esclarecemos como usar [experiment flags com IDEs][experiments].
  * Atualizamos a página de null safety, adicionando informações sobre
    [como habilitar null safety][ns-enable].
  * Adicionamos uma análise profunda sobre null safety,
    [Understanding null safety][],
    escrita pelo engenheiro Dart Bob Nystrom.

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

### Artigos adicionados ao blog do Dart {:.no_toc}

Publicamos os seguintes artigos no [blog do Dart:][Dart blog]

* [Exploring collections in Dart][] ajuda você a usar collections
  (listas, maps, sets e mais), com atenção especial aos
  recursos da linguagem 2.3 como collection if, collection for e spreads.
* [Google Summer of Code 2020 results][] descreve os resultados de
  cinco projetos que a equipe Dart orientou.
* [Introducing a brand new pub.dev][] anuncia o relançamento do
  [site pub.dev,][pub.dev] com novas métricas de pontuação de pacotes, pesquisa melhorada
  e uma UI redesenhada.

Também melhoramos a navegação do blog,
adicionando abas **announcement** e **archive**, além de um link para dart.dev.

:::tip
Todos os artigos no blog do Dart são gratuitos para ler.
:::

</div>

[Dart blog]: https://blog.dart.dev
[Exploring collections in Dart]: https://blog.dart.dev/exploring-collections-in-dart-f66b6a02d0b1
[Google Summer of Code 2020 results]: https://blog.dart.dev/google-summer-of-code-2020-results-a38cd072c9fe
[Introducing a brand new pub.dev]: https://blog.dart.dev/pub-dev-redesign-747406dcb486
[pub.dev]: {{site.pub}}
