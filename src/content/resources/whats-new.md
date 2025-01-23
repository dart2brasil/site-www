---
ia-translate: true
title: O que há de novo
description: Uma lista do que há de novo em dartbrasil.dev e sites relacionados.
lastVerified: 2024-08-06
---

Esta página descreve o que há de novo no site e blog do Dart.
Para ver o que há de novo no Flutter, visite a
[página de novidades do Flutter][flutter-whats-new].

Para obter uma lista das mudanças na linguagem Dart em cada SDK do Dart, consulte a
[página de evolução da linguagem][evolution].
Para ficar por dentro dos anúncios, incluindo mudanças que quebram compatibilidade,
junte-se ao [grupo do Google de anúncios do Dart][dart-announce]
e siga o [blog do Dart][Dart blog].

[flutter-whats-new]: {{site.flutter-docs}}/whats-new
[dart-announce]: https://groups.google.com/a/dartlang.org/d/forum/announce
[Dart blog]: https://medium.com/dartlang

## 6 de agosto de 2024: lançamento da versão 3.5 {:#august-6-2024-3-5-release}

Esta seção lista as mudanças notáveis feitas de 15 de maio de 2024,
até 6 de agosto de 2024.
Para detalhes sobre o lançamento da versão 3.5 do Dart,
confira o [anúncio da versão 3.5][3.5 announcement] e o [changelog do SDK][3-5-changelog].

[3.5 announcement]: https://medium.com/dartlang/dart-3-5-6ca36259fa2f
[3-5-changelog]: {{site.repo.dart.sdk}}/blob/main/CHANGELOG.md#350---2024-08-06

### Documentos atualizados ou adicionados em dartbrasil.dev {:.no_toc}

Além de correções de bugs e melhorias incrementais,
fizemos as seguintes alterações neste site:

* Esclarecemos o status e os usos pretendidos das
  [novas e legadas bibliotecas da plataforma web][web platform libraries].
* Expandimos a documentação sobre [publicação de versões pré-lançamento][publishing prerelease versions]
  de pacotes no site pub.dev.
* Adicionamos uma página cobrindo o novo comando [`dart pub unpack`][`dart pub unpack` command].
* Documentamos a nova *flag* [`--skip-validation`][`--skip-validation` flag] para `dart pub publish` e
  a *flag* [`--tighten`][`--tighten` flag] para `dart pub downgrade`.
* Fornecemos orientações de melhores práticas para autores de pacotes
  [testarem seus pacotes com dependências rebaixadas][test their package with downgraded dependencies].
* Melhoramos o guia [Corrigindo falhas de promoção de tipo][Fixing type promotion failures] e adicionamos
  realce de código para indicar melhor o código relevante.
* Complementamos a [documentação de instalação do Dart][Dart installation documentation] com
  instruções de desinstalação e limpeza.
* Introduzimos novos documentos e exemplos de código cobrindo
  *tear-offs* de [funções][func-tear] e [construtores][cons-tear].
* Explicamos como [exportar funções e objetos Dart para serem usados a partir de JS][export Dart functions and objects to be used from JS].
* Adicionamos entradas de glossário para [subclasse][subclass] e [subtipo][subtype]
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

## 14 de maio de 2024: lançamento da versão 3.4 {:#may-14-2024-3-4-release}

Esta seção lista as mudanças notáveis feitas de 16 de fevereiro de 2024,
até 14 de maio de 2024.
Para detalhes sobre o lançamento da versão 3.4,
confira o [post do blog 3.4][3.4 blog post] e o [changelog do SDK][3-4-changelog].

[3.4 blog post]: https://medium.com/dartlang/dart-3-4-bd8d23b4462a
[3-4-changelog]: {{site.repo.dart.sdk}}/blob/main/CHANGELOG.md#340---2024-05-14

### Documentos atualizados ou adicionados ao dartbrasil.dev {:.no_toc}

Além de correções de bugs e melhorias incrementais,
fizemos as seguintes alterações neste site:

* Adicionamos uma página documentando o recurso experimental de linguagem [Macros][Macros].
* Adicionamos uma página para acompanhar os desenvolvimentos do [Wasm][Wasm] para Dart.
* Refatoramos a página [Construtores][Constructors].
* Esclarecemos as instruções na seção [Renomeações][Renames] da
  página de migração do `package:web`.
* Ajustamos a entrada do Effective Dart sobre [habilitar a promoção de tipo][enabling type promotion] para recomendar
  o padrão de verificação nula antes de outros padrões.
* Revisamos a lista de [bibliotecas e pacotes da Web][Web libraries and packages] para melhor representar as
  soluções recomendadas.
* Explicamos como desestruturar campos nomeados nas páginas
  [Records][Records] e [Patterns][Patterns].
* Incluímos uma [tabela de antes e depois][before-and-after table] de soluções da web na página de interoperação com JS.
* Adicionamos uma seção explicando [operadores spread][spread operators] à página Operadores.
* Esclarecemos a ordem dos [padrões parentéticos][parenthetical patterns] na página Tipos de padrões.
* Adicionamos documentos para [`ExternalDartReference`][`ExternalDartReference`] à página Tipos JS.
* Atualizamos o site para novas [regras de linter][linter rules] e [mensagens de diagnóstico][diagnostic messages],
  por exemplo, adicionando documentos para o novo diagnóstico de anotação [`@mustBeConst`][`@mustBeConst`].

[Macros]: /language/macros
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

* [Histórico do *JS interop* no Dart][blog-3-28-24]
* [Dart no Google Summer of Code 2024][blog-3-5-24]

[blog-3-28-24]: https://medium.com/dartlang/history-of-js-interop-in-dart-98b06991158f
[blog-3-5-24]: https://medium.com/dartlang/dart-in-google-summer-of-code-2024-8ca45fb6dc4e

## 15 de fevereiro de 2024: lançamento da versão 3.3 {:#february-15-2024-3-3-release}

Esta seção lista as mudanças notáveis feitas de 16 de novembro de 2023,
até 15 de fevereiro de 2024.
Para detalhes sobre o lançamento da versão 3.3,
confira o [post do blog 3.3][3.3 blog post] e o [changelog do SDK][3-3-changelog].

[3.3 blog post]: https://medium.com/dartlang/dart-3-3-325bf2bf6c13
[3-3-changelog]: {{site.repo.dart.sdk}}/blob/main/CHANGELOG.md#330

### Documentos atualizados ou adicionados ao dartbrasil.dev {:.no_toc}

Além de correções de bugs e melhorias incrementais,
fizemos as seguintes alterações neste site:

* Alteramos a infraestrutura do site para [executar no 11ty][run on 11ty] em vez de Jekyll.
* Adicionamos uma página cobrindo o novo recurso de linguagem [tipos de extensão][extension types].
* Adicionamos um novo conjunto de documentação sobre [interoperação com JavaScript][JavaScript interop]:
  * [Uso][Usage]
  * [Tipos JS][JS types]
  * [Tutoriais][Tutorials], o primeiro dos quais é sobre [Mocks][Mocks]
  * [Interoperação JS anterior][Past JS interop]
* Atualizamos a visão geral de [Concorrência][Concurrency], além de uma nova página prática sobre o uso de [Isolates][Isolates].
* Adicionamos uma seção sobre [`external`][`external`] à página [Funções][Functions].
* Removemos o DartPad incorporado de algumas páginas para acomodar
  a nova versão do [DartPad][DartPad].
* Incluímos uma definição para "Função" no [Glossário][Glossary].
* Desconstruímos o [Tour da biblioteca][Library tour] em páginas individuais para cada biblioteca.
* Atualizamos a página [Mudanças que quebram a compatibilidade][Breaking changes] para 3.3.
* Atualizamos algumas entradas desatualizadas na página de [FAQ](/resources/faq).
* Expandimos a documentação sobre [`dart doc`][`dart doc`].
* Atualizamos e simplificamos o conteúdo de [plataformas suportadas][supported platforms].
* Consolidamos múltiplas ocorrências do conteúdo de [`dart format`][`dart format`].
* Atualizamos vários locais para sugerir [`package:web`][`package:web`] em vez de `dart:html`.
* Deixamos de recomendar [`dart:html`][`dart:html`] e [`dart:io`][`dart:io`]
  para fazer requisições HTTP, em favor de `package:http`.
* Documentamos [a supressão de diagnósticos em um arquivo pubspec][suppressing diagnostics in a pubspec file].
* Adicionamos conteúdo sobre [criação][creating] e [ignorando][ignoring] avisos de segurança em um arquivo pubspec.
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


## 15 de novembro de 2023: lançamento da versão 3.2 {:#november-15-2023-3-2-release}

Esta seção lista as mudanças notáveis feitas de 17 de agosto de 2023,
até 15 de novembro de 2023.
Para detalhes sobre o lançamento da versão 3.2,
confira o [post do blog 3.2][3.2 blog post] e o [changelog do SDK][3-2-changelog].

[3.2 blog post]: https://medium.com/dartlang/dart-3-2-c8de8fe1b91f
[3-2-changelog]: {{site.repo.dart.sdk}}/blob/main/CHANGELOG.md#320---2023-11-15

### Documentos atualizados ou adicionados ao dartbrasil.dev {:.no_toc}

Além de correções de bugs e melhorias incrementais,
fizemos as seguintes alterações neste site:

* Atualizamos a página [Corrigindo falhas de promoção de tipo][no-promo]
  para um novo recurso de promoção de tipo: promoção de campo final privado.
  * Fizemos pequenos ajustes relacionados à entrada do Effective Dart sobre
    [promoção de tipo][type promotion], a página [Entendendo a segurança nula][Understanding Null Safety] e outros vários
    locais em todo o site.
* Introduzimos a documentação sobre o recurso experimental de *native assets*
  na página [Interoperabilidade com C][C interop].
* Criamos uma nova página dedicada à documentação de [Mudanças que quebram a compatibilidade][Breaking changes].
* Levamos em conta as [lints][lints] e [diagnósticos][diagnostics] novos e atualizados em suas
  páginas de documentos respectivos.
* Adicionamos documentação para a nova *flag* `--tighten ` à página [`pub upgrade`].
* Removemos a folha de dicas em favor da página [Visão geral da linguagem][Language overview].
* Esclarecemos a relação entre [cláusulas de guarda e padrões][guard clauses and patterns].
* Ajustamos a página [Construtores][Constructors] para melhor representar as melhores práticas.
* Melhoramos os conteúdos da página [Dependências de pacote][Package dependencies] para serem mais acionáveis
  e fáceis de seguir.
* Detalhamos os membros estáticos na página [Métodos de extensão][Extension methods].
* Alteramos o conteúdo das limitações de *multithreading* [Objective-C][Objective-C] para levar em conta
  a nova API `NativeCallable`.
* Adicionamos novas anotações e mencionamos as depreciações na página [Metadados][Metadata].
* Melhoramos o contraste ajustando as cores do texto e o realce em
  exemplos de código em todo o site.
* Reorganizamos e simplificamos a infraestrutura do site em geral, em preparação
  para [deixar de usar o Jekyll][move away from using Jekyll].

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

## 16 de agosto de 2023: lançamento da versão 3.1 {:#august-16-2023-3-1-release}

Esta seção lista as mudanças notáveis feitas de 11 de maio de 2023,
até 16 de agosto de 2023.
Para detalhes sobre o lançamento da versão 3.1,
confira
[Dart 3.1 e uma retrospectiva sobre programação de estilo funcional no Dart 3][Dart 3.1 & a retrospective on functional style programming in Dart 3]
e o [changelog do SDK][3-1-changelog].

[Dart 3.1 & a retrospective on functional style programming in Dart 3]: https://medium.com/dartlang/dart-3-1-a-retrospective-on-functional-style-programming-in-dart-3-a1f4b3a7cdda
[3-1-changelog]: {{site.repo.dart.sdk}}/blob/main/CHANGELOG.md#310---2023-08-16

### Documentos atualizados ou adicionados ao dartbrasil.dev {:.no_toc}

Além de correções de bugs e melhorias incrementais,
fizemos as seguintes alterações neste site:

* Reformulamos a documentação das regras do linter para substituir o antigo site do linter:
  * Movemos a documentação de cada regra do linter para sua própria página.
    Por exemplo: [`avoid_dynamic_calls`][`avoid_dynamic_calls`].
  * Adicionamos um exemplo de `analysis_options.yaml` que habilita
    [todas as regras do linter][all linter rules] disponíveis na versão mais recente do Dart.
  * Atualizamos o [índice de todas as regras do linter disponíveis][index of all available linter rules]
    para permitir uma descoberta mais fácil do linter.
* Aumentamos a documentação dos [modificadores de classe][class modifiers] adicionando uma
  [Referência de modificadores de classe][Class modifiers reference] para descrever como eles interagem entre si.
* Introduzimos um guia [Modificadores de classe para mantenedores de API][Class modifiers for API maintainers] para ajudar
  os desenvolvedores a usar melhor os modificadores de classe.
* Reescrevemos a documentação da [expressão switch][switch expression]
  para melhor contabilizar suas diferenças em relação às declarações switch.
* Documentamos o suporte para especificar [tópicos][topics] em seu arquivo pubspec
  para categorizar seu pacote no site pub.dev.
* Esclarecemos que [capturas de tela de pacotes][package screenshots] destinam-se a
  mostrar a funcionalidade do pacote, não o logotipo ou ícone do pacote.
* Adicionamos botões anterior e próximo à
  [documentação da linguagem][language documentation] do Dart para permitir uma experiência de aprendizado guiada.
* Continuamos a expandir o novo [glossário][glossary] de todo o site.
* Adicionamos uma nota de migração sobre como o
  [movimento do cache do pub][pub cache move] no Windows foi finalizado no Dart 3.
* Simplificamos e atualizamos documentos mais antigos agora que
  o sistema de tipos do Dart é sempre [null safe][null safe].

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

* [Dart DevTools: Analisando o desempenho do aplicativo com o Profiler de CPU][blog-6-12-23]

[blog-6-12-23]: https://medium.com/dartlang/dart-devtools-analyzing-application-performance-with-the-cpu-profiler-3e94a0ec06ae

## 10 de maio de 2023: lançamento da versão 3.0 {:#may-10-2023-3-0-release}

Esta seção lista as mudanças notáveis feitas de 26 de janeiro de 2023,
até 10 de maio de 2023.
Para detalhes sobre o lançamento principal da versão 3.0,
confira [Anunciando o Dart 3][Announcing Dart 3]
e o [changelog do SDK][3-0-changelog].

[Announcing Dart 3]: https://medium.com/dartlang/announcing-dart-3-53f065a10635
[3-0-changelog]: {{site.repo.dart.sdk}}/blob/main/CHANGELOG.md#300---2023-05-10

### Documentos atualizados ou adicionados ao dartbrasil.dev {:.no_toc}

Em preparação para o Dart 3, dividimos e reorganizamos o
Tour da Linguagem em novas categorias conceituais.
Você pode acessar a documentação da linguagem reestruturada
em **Linguagem** no menu de navegação lateral, ou visitando a
[Introdução ao Dart][Introduction to Dart] atualizada.

Aproveitando esta nova estrutura,
adicionamos documentação para cada um dos principais recursos do Dart 3:

- [Correspondência de padrões][Pattern matching] e os diferentes [tipos de padrões][types of patterns].
- [Expressões switch][Switch expressions] com suporte para
  padrões e [verificação de exaustividade][exhaustiveness checking].
- [Declarações if com cláusulas case][If statements with case clauses] para suportar a correspondência de padrões.
- [Records][Records], um novo tipo anônimo, imutável e agregado
  que permite [múltiplos retornos][multiple returns].
- [Modificadores de classe][Class modifiers] que dão às bibliotecas mais controle sobre os tipos exportados.

Para ajudá-lo na transição para a aplicação do Dart 3 de [segurança nula sólida][sound null safety]
e outras mudanças, também preparamos as seguintes atualizações:

- Criamos um [guia de migração do Dart 3][Dart 3 migration guide] abrangente.
- Migramos toda a documentação e exemplos de código
  para o Dart 3, as versões de ferramentas mais recentes e as dependências mais recentes.
- Esclarecemos que o sistema de tipos do Dart agora é sempre *null-safe* no Dart 3.
- Atualizamos e reorganizamos a página [Evolução da linguagem][Language evolution]
  e sua discussão sobre [versionamento da linguagem][language versioning].
- Removemos os remanescentes do Dart 1 e dos primeiros documentos, notas e recursos do Dart 2.

Além do novo conteúdo do Dart 3 e
atualizações correspondentes em todo o site,
fizemos as seguintes alterações:

- Adicionamos um guia sobre a configuração de [declarações do ambiente de compilação][compilation environment declarations].
- Continuamos o trabalho de interoperabilidade nativa do Dart
  adicionando um guia sobre o suporte experimental para [interoperação com Java][Java interop].
- Esclarecemos o uso e as limitações das [extensões não nomeadas][unnamed extensions].
- Adicionamos uma página para o novo comando [`dart info`][`dart info`]
  que ajuda com diagnósticos de ferramentas.
- Reformulamos a documentação [`dart pub add`][`dart pub add`]
  para cobrir sua nova sintaxe de [descritor de origem][source descriptor].
- Apresentamos *builds* de visualização do Linux RISC-V (RV64GC) no
  canal beta no [arquivo do SDK][SDK archive].
- Iniciamos um novo [glossário][glossary] em todo o site para conter
  termos comuns usados em todo o site.
- Destacamos o trabalho experimental no [suporte à interoperação estática com JS][JS static interop support] do Dart.
- Documentamos a existência e as limitações atuais dos [plugins do analisador][analyzer plugins].

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

* [Apresentando o Realm para Dart & Flutter][blog-2-09-23]

[blog-2-09-23]: https://medium.com/dartlang/introducing-realm-for-dart-flutter-e30cb05eb313

### Vídeos lançados pela equipe Dart {:.no_toc} {:#videos-released-by-the-dart-team}

Durante o Google I/O 2023, lançamos os seguintes vídeos:

* [O que há de novo no Dart e no Flutter][What's new in Dart and Flutter] ([versão em Língua Americana de Sinais][American Sign Language version])
* [Repensando a interoperabilidade do Dart com o Android][Rethinking Dart interoperability with Android]
* [Como construir um pacote em Dart][How to build a package in Dart]

[What's new in Dart and Flutter]: {{site.yt.watch}}?v=yRlwOdCK7Ho
[American Sign Language version]: {{site.yt.watch}}?v=QbMgjVB0XMI
[Rethinking Dart interoperability with Android]: {{site.yt.watch}}?v=ZWp2FJ2TuJs
[How to build a package in Dart]: {{site.yt.watch}}?v=8V_TLiWszK0

## 25 de janeiro de 2023: lançamentos das versões 2.19 + 3.0 alpha {:#january-25-2023-2-19-3-0-alpha-releases}

Esta seção lista as mudanças notáveis feitas de 31 de agosto de 2022,
até 25 de janeiro de 2023.
Para detalhes sobre os lançamentos das versões 2.19 + 3.0 alpha,
consulte [Apresentando o Dart 3 alpha][Introducing Dart 3 alpha]
e o [changelog do SDK][2-19-changelog].

[Introducing Dart 3 alpha]: https://medium.com/dartlang/dart-3-alpha-f1458fb9d232
[2-19-changelog]: {{site.repo.dart.sdk}}/blob/main/CHANGELOG.md#2190---2023-01-24

### Documentos atualizados ou adicionados em dartbrasil.dev {:.no_toc}

Além de correções de bugs e melhorias incrementais,
fizemos as seguintes alterações neste site:

* Introduzimos o tutorial [Buscar dados da internet][Fetch data from the internet] sobre como usar `package:http`.
* Adicionamos uma página sobre [Publicação automatizada de pacotes no pub.dev][Automated publishing of packages to pub.dev].
* Incluímos links para duas novas traduções do site em nossa [seção de recursos da comunidade][community resources section]:
  * [Versão coreana deste site (한국어)](https://dart-ko.dev/)
  * [Versão em chinês tradicional deste site (正體中文版)](https://dart.tw.gh.miniasp.com/)
* Atualizamos o conteúdo de segurança nula em preparação para o Dart 3:
  * Alteramos as restrições de versão no [guia de migração][migration guide] para compatibilidade com o Dart 3.
  * Adicionamos uma visão geral completa de segurança nula sólida do Dart 3 à página [Segurança nula sólida][Sound null safety].
  * Enfatizamos a incompatibilidade do Dart 3 com [segurança nula não sólida][unsound null safety] em uma nota.
* Introduzimos o novo guia [Aprendendo Dart como um desenvolvedor Swift][Learning Dart as a Swift developer].
* Substituímos uma seção do Effective Dart por uma orientação mais geral sobre [booleanos e operadores de igualdade][booleans and equality operators].
* Documentamos [hash de conteúdo][content-hashing] em todos os documentos do pub.
* Iniciamos o esforço para reformular a página [Zonas][Zones]
  alterando os exemplos para usar `runZonedGuarded` em vez de `onError`.
* Atualizamos o conteúdo das bibliotecas para cobrir o novo desenvolvimento de declarações sem nome:
  * Effective Dart: [Documentação][Documentation], [Estilo][Style] e [Uso][Usage]
  * Nova seção de diretiva de biblioteca em [O tour da linguagem][The language tour]
* Melhoramos a clareza em torno do status de *single-threaded* ou *multi-threaded* do Dart:
  * Removemos a página `dart:io` desatualizada.
  * Expandimos as [capacidades de concorrência do Dart na web][Dart's web concurrency capabilities].
* Reorganizamos e esclarecemos a [discussão][discussion] sobre os valores padrão para parâmetros opcionais e posicionais.
* Atualizamos [Concorrência no Dart][Concurrency in Dart] para usar por padrão a nova função `Isolate.run()`.
* Documentamos a especificação de um caminho de arquivo ao ativar um pacote na [página `pub global`][`pub global` page].
* Reescrevemos [Aprendendo Dart como um desenvolvedor JavaScript][Learning Dart as a JavaScript developer].
* Adicionamos uma breve visão geral do Dart DevTools à [página `dart run`][`dart run` page].
* Fornecemos mais clareza em torno da [precedência e associatividade de operadores][operator precedence and associativity] no Tour da Linguagem.
* Expandimos a seção Tour da Biblioteca sobre [Construindo URIs][Building URIs] com informações sobre URI http e construtor de fábrica.
* Levamos em conta a [transição do pub para pub.dev][pub's transition to pub.dev] de pub.dartlang.org.
* Adicionamos documentação sobre [capturas de tela de pacotes][package screenshots].
* Melhoramos a [seção de *downcast* explícito][explicit downcast section] da página O sistema de tipos Dart.
* Aumentamos a cobertura do [analisador][analyzer] e do [lint][lint]:
  * Incluímos informações de suporte à versão do SDK para regras de linter.
  * Adicionamos mensagens de diagnóstico e lint para mudanças na versão 2.19.

[Fetch data from the internet]: /tutorials/server/fetch-data
[Automated publishing of packages to pub.dev]: /tools/pub/automated-publishing
[community resources section]: /community#additional-community-resources
[migration guide]: /null-safety/migration-guide
[unsound null safety]: /null-safety/unsound-null-safety
[Learning Dart as a Swift developer]: /resources/coming-from/swift-to-dart
[booleans and equality operators]: /effective-dart/usage#dont-use-true-or-false-in-equality-operations
[content-hashing]: /tools/pub/glossary#content-hashes
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

*   [Melhor gerenciamento de isolados com Isolate.run()][blog-1-24-23]
*   [Capturas de tela e publicação automatizada para pub.dev][blog-1-18-23]
*   [O caminho para o Dart 3: Uma linguagem totalmente *sound* e *null safe*][blog-12-8-22]
*   [Resultados do Google Summer of Code 2022][blog-11-3-22]
*   [Parceria com o GitHub na segurança da cadeia de suprimentos para pacotes Dart][blog-10-6-22]

[blog-1-24-23]: https://medium.com/dartlang/better-isolate-management-with-isolate-run-547ef3d6459b
[blog-1-18-23]: https://medium.com/dartlang/screenshots-and-automated-publishing-for-pub-dev-9bceb19edf79
[blog-12-8-22]: https://medium.com/dartlang/the-road-to-dart-3-afdd580fbefa
[blog-11-3-22]: https://medium.com/dartlang/google-summer-of-code-2022-results-a3ce1c13c06c
[blog-10-6-22]: https://medium.com/dartlang/partnering-with-github-on-an-supply-chain-security-485eed1fc388


## 30 de agosto de 2022: lançamento 2.18 {:#august-30-2022-2-18-release}

Esta seção lista as mudanças notáveis feitas de 12 de maio de 2022,
até 30 de agosto de 2022.
Para detalhes sobre o lançamento 2.18,
veja [Dart 2.18: Interoperabilidade com Objective-C e Swift][Dart 2.18: Objective-C & Swift interop],
e o [changelog do SDK][2-18-changelog].

[Dart 2.18: Objective-C & Swift interop]: https://medium.com/dartlang/dart-2-18-f4b3101f146c
[2-18-changelog]: {{site.repo.dart.sdk}}/blob/main/CHANGELOG.md#2180---2022-08-30

Além de correções de bugs e melhorias incrementais,
fizemos as seguintes mudanças neste site:

*   Apresentamos a página [Interoperabilidade com Objective-C e Swift][Objective-C and Swift interop],
    que explica como usar pacotes Dart para chamar APIs dessas linguagens.
*   Adicionamos uma solução alternativa para [Corrigindo problemas comuns de tipo][Fixing common type problems],
    para o caso raro em que a inferência de tipo pode inferir incorretamente que um tipo de argumento é nulo.
*   Removemos todas as menções a arquivos `.packages` descontinuados de [O que não commitar][What not to commit].
    Se você ainda precisar gerar um arquivo `.packages` devido a dependências legadas de terceiros,
    consulte [`dart pub get` Opções][`dart pub get` Options].
*   Removemos páginas dedicadas e qualquer outra menção às ferramentas de linha d
   comando `dart2js` e `dartdevc` descontinuadas.
    *   Adicionamos opções de linha de comando e problemas conhecidos anteriormente associados ao
        `dart2js` à página [`dart compile`][`dart compile`].
    *   Adicionamos informações sobre depuração de código de produção em [Depurando aplicativos web Dart][Debugging Dart web apps].
*   Adicionamos suporte para download de builds experimentais do Windows ARM
    para o [Arquivo do SDK Dart][Dart SDK archive].
*   Atualizamos o [Tour da biblioteca][Library tour] para incluir informações sobre referências fracas e finalizadores.
*   Adicionamos uma seção sobre personalização do [`dart fix`][`dart fix`].

[Objective-C and Swift interop]: /interop/objective-c-interop
[Fixing common type problems]: /deprecated/sound-problems
[What not to commit]: /tools/pub/private-files
[`dart pub get` Options]: /tools/pub/cmd/pub-get#options
[`dart compile`]: /tools/dart-compile
[Debugging Dart web apps]: /web/debugging
[Dart SDK archive]: /get-dart/archive
[Library tour]: /libraries/dart-core#weak-references-and-finalizers
[`dart fix`]: /tools/dart-fix#customize

## 11 de maio de 2022: lançamento 2.17 {:#may-11-2022-2-17-release}

Esta seção lista as mudanças notáveis feitas de 4 de fevereiro de 2022,
até 11 de maio de 2022.
Para detalhes sobre o lançamento 2.17,
veja [Dart 2.17: Produtividade e integração][Dart 2.17: Productivity and integration].

[Dart 2.17: Productivity and integration]: https://medium.com/dartlang/dart-2-17-b216bfc80c5d

### Documentos atualizados ou adicionados a dartbrasil.dev {:.no_toc}

Além de correções de bugs e melhorias incrementais,
fizemos as seguintes mudanças neste site:

*   Apresentamos o guia [Aprendendo Dart como um desenvolvedor JavaScript][Learning Dart as a JavaScript developer],
    que visa alavancar seu conhecimento de programação JavaScript
    ao aprender Dart.
*   Documentamos os recursos e mudanças introduzidos no Dart 2.17:
    *   Atualizamos a seção [Parâmetros nomeados][Named parameters] do tour da linguagem
        para refletir o suporte para especificar argumentos nomeados em qualquer lugar.
    *   Adicionamos documentação para [parâmetros superinicializadores][super-initializer parameters].
    *   Expandimos a seção [Tipos enumerados][Enumerated types] do tour da linguagem
        e documentamos [enums aprimorados][enhanced enums].
    *   Documentamos o suporte para [assinatura][signing] de executáveis macOS e Windows
        compilados com `dart compile exe`.
    *   Atualizamos os templates suportados por [`dart create`][`dart create`]
        para seus novos nomes padronizados.
*   Levamos em conta as mudanças no [site pub.dev][pub.dev site] e na [ferramenta pub][pub tool].
    *   Listamos os fornecedores que oferecem [repositórios de pacotes Dart como um serviço][Dart package repositories as a service].
    *   Removemos a documentação para o comando `dart pub uploader` agora descontinuado.
    *   Expandimos a documentação para gerenciamento de [uploaders][uploaders] de projetos pub.
    *   Removemos a maioria das menções ao arquivo `.packages` obsoleto,
        apontando em vez disso para sua substituição `.dart_tool/package_config.json`.
*   Atualizamos a documentação para atualizar e instalar o Dart:
    *   Documentamos como alternar entre as versões do Dart
        com o Homebrew nas [instruções de instalação][get-dart-install] do macOS.
    *   Atualizamos as [instruções de instalação][get-dart-install] do Linux
        para usar o [SecureApt][SecureApt] e seguir as melhores práticas mais recentes.
    *   Adicionamos suporte para download de builds experimentais do Linux RISC-V (RV64GC)
        do [Arquivo do SDK Dart][Dart SDK archive].
*   Continuamos o trabalho para melhorar e atualizar a documentação
    da [ferramenta unificada `dart`][dart-tool]:
    *   Expandimos a documentação sobre a funcionalidade da ferramenta [`dart fix`][`dart fix`].
    *   Ajustamos as diretrizes e a documentação para a ferramenta [`dart doc`][`dart doc`]
        para corresponder à sua funcionalidade e comportamento subjacente.
    *   Adicionamos mais documentação e exemplos de [`dart compile js`][`dart compile js`].
    *   Removemos menções de ferramentas autônomas removidas.
*   Atualizamos a documentação e o uso do analisador e do linter:
    *   Documentamos os novos [modos de linguagem estritos][strict language modes] do analisador.
    *   Incorporamos mudanças nas páginas de
    [mensagens de diagnóstico][diagnostic messages] e [regras do linter][linter rules].
    *   Atualizamos a documentação e os exemplos
        para usar a versão `2.0.0` do pacote `lints`.
*   Iniciamos uma revisão da documentação para compilação web:
    *   Documentamos a descontinuação e remoção planejada
        das ferramentas autônomas `dart2js` e `dartdevc`.
    *   Consolidamos e esclarecemos a documentação
        de [dart2js][dart2js] e [dartdevc][dartdevc]
        como os compiladores subjacentes de ferramentas como
        [`dart compile js`][`dart compile js`] e [`webdev`][`webdev`].
*   Aumentamos a cobertura da documentação sobre *null safety* (segurança nula):
    *   Documentamos o operador de asserção não nula (`!`) como parte da seção
        [Outros operadores][Other operators] do tour da linguagem.
    *   Migramos os [Tutoriais de HTML de baixo nível][Low-level HTML tutorials] para suportar *null safety*
        e discutir como interagir com as APIs da web ao usá-lo.
*   Fizemos outras atualizações diversas:
    *   Documentamos os [tipos nativos][native types] fornecidos por `dart:ffi`
        para uso em interoperação com C.
    *   Apresentamos uma nova seção ao tour da linguagem documentando
        [parâmetros formais inicializadores][initializing formal parameters].
    *   Documentamos o [suporte para pacotes][support for packages] do DartPad.
    *   Corrigimos a formatação no [tutorial de programação assíncrona][asynchronous programming tutorial]
        e detalhamos [por que o código assíncrono é importante][why asynchronous code matters].
    *   Atualizamos a página de [segurança][security] para corresponder às nossas práticas de segurança atuais.
    *   Adicionamos uma tecla de atalho (`/`) para focar automaticamente a barra de pesquisa.

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

*   [Aplicação em massa de correções][blog-5-5-22]
*   [Programação assíncrona em Dart: Streams][blog-4-14-22]
*   [Colaboradores para o Google Summer of Code 2022][blog-4-7-22]
*   [Migração gradual para *null safety* em grandes projetos Dart][blog-3-31-22]
*   [Hospedando um repositório de pacotes Dart privado][blog-3-16-22]
*   [Correções rápidas para problemas de análise][blog-3-4-22]

[blog-5-5-22]: https://medium.com/dartlang/bulk-application-of-fixes-e6add333c3c1
[blog-4-14-22]: https://medium.com/dartlang/dart-asynchronous-programming-streams-dab952023ed7
[blog-4-7-22]: https://medium.com/dartlang/contributors-for-google-summer-of-code-2022-17e777f043f0
[blog-3-31-22]: https://medium.com/dartlang/gradual-null-safety-migration-for-large-dart-projects-85acb10b64a9
[blog-3-16-22]: https://medium.com/dartlang/hosting-a-private-dart-package-repository-774c3c51dff9
[blog-3-4-22]: https://medium.com/dartlang/quick-fixes-for-analysis-issues-c10df084971a

## 3 de fevereiro de 2022: lançamento 2.16 {:#february-3-2022-2-16-release}

Esta seção lista as mudanças notáveis feitas de 8 de dezembro de 2021,
até 3 de fevereiro de 2022.
Para detalhes sobre o lançamento 2.16,
veja [Dart 2.16: Ferramentas aprimoradas e tratamento de plataforma][Dart 2.16: Improved tooling and platform handling].

[Dart 2.16: Improved tooling and platform handling]: https://medium.com/dartlang/dart-2-16-improved-tooling-and-platform-handling-dd87abd6bad1

### Documentos atualizados ou adicionados a dartbrasil.dev {:.no_toc}

[Atualizamos a infraestrutura do site][updated the website infrastructure] para uma configuração baseada em Docker
para habilitar [contribuições mais fáceis][easier contributions] e alinhar mais estreitamente com
a configuração para [docs.flutter.dev]({{site.flutter-docs}}).

Além de outras correções de bugs e melhorias incrementais,
fizemos as seguintes mudanças neste site:

*   Mudamos para documentar a nova ferramenta [`dart doc`][`dart doc`]
    que substitui `dartdoc`.
*   Documentamos a nova entrada [`platform`][`platform` entry] para especificar plataformas suportadas
    dentro do `pubspec.yaml` de um pacote.
*   Atualizamos as páginas de [mensagens de diagnóstico][diagnostic messages] e [regras do linter][linter rules].
*   Documentamos como [ignorar todas as regras do linter][ignore all linter rules] em um arquivo.
*   Removemos menções das antigas ferramentas autônomas da [Visão geral do SDK Dart][Dart SDK overview].
*   Atualizamos as menções restantes das antigas ferramentas autônomas
    para seus equivalentes na ferramenta [`dart`][`dart`].
*   Adicionamos esclarecimentos à
    diretriz [PREFIRA usar interpolação para compor strings e valores][PREFER using interpolation to compose strings and values]
    do Effective Dart.

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


## 8 de dezembro de 2021: lançamento 2.15 {:#december-8-2021-2-15-release}

Esta seção lista as mudanças notáveis feitas de 9 de setembro de 2021,
até 8 de dezembro de 2021.
Para detalhes sobre o lançamento 2.15, veja [Anunciando o Dart 2.15][Announcing Dart 2.15].

[Announcing Dart 2.15]: https://medium.com/dartlang/dart-2-15-7e7a598e508a

### Documentos atualizados ou adicionados a dartbrasil.dev {:.no_toc}

Além de correções de bugs e melhorias incrementais,
fizemos as seguintes mudanças neste site:

*   Adicionamos [Concorrência em Dart][Concurrency in Dart], que discute recursos como
    isolados que permitem a execução paralela de código Dart.
*   Documentamos os recursos pub adicionados ou aprimorados em 2.15:
    *   Adicionamos uma página para um novo subcomando pub, [dart pub token][dart pub token],
        e uma página sobre [repositórios de pacotes personalizados][custom package repositories]
    *   Adicionamos informações sobre [retração de pacotes][package retraction]
    *   Adicionamos o campo [false_secrets][false_secrets] à página pubspec
    *   Atualizamos a sintaxe para [dependências hospedadas][hosted dependencies]
*   Removemos todas as entradas para [livros][books] do Dart 1
*   Expandimos as [dicas de solução de problemas do DartPad][DartPad troubleshooting tips]
*   Atualizamos a página de [mensagens de diagnóstico][diagnostic messages]
*   Atualizamos a página de [regras do linter][linter rules];
    removemos referências a conjuntos de regras obsoletos, como
    `effective_dart`
*   Atualizamos as instruções para instalar e usar
    [Dart DevTools][Dart DevTools]
*   Adicionamos informações sobre o que o [runtime Dart][Dart runtime] fornece,
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


## 8 de setembro de 2021: lançamento 2.14 {:#september-8-2021-2-14-release}

Esta seção lista as mudanças notáveis feitas de 20 de maio de 2021,
até 8 de setembro de 2021.
Para detalhes sobre o lançamento 2.14, veja [Anunciando o Dart 2.14][Announcing Dart 2.14].

[Announcing Dart 2.14]: https://medium.com/dartlang/announcing-dart-2-14-b48b9bb2fb67

### Documentos atualizados ou adicionados a dartbrasil.dev {:.no_toc}

Além de correções de bugs e melhorias incrementais,
fizemos as seguintes mudanças neste site:

*   Desenvolvemos a página sobre [como corrigir falhas de promoção de tipo][no-promo].
*   Documentamos como usar o [arquivo `.pubignore`][`.pubignore` file],
    um recurso que foi introduzido no Dart 2.14.
*   Adicionamos cobertura do [operador de deslocamento não assinado][unsigned shift operator] (`>>>`),
    que foi introduzido no Dart 2.14.
*   Construímos a [página de regras do linter][linter rule page];
    atualizamos o Effective Dart para fazer um link para ela.
*   Adicionamos páginas para os comandos
  [`dart create`][`dart create`] e [`dart test`][`dart test`].
*   Terminamos de converter exemplos do uso de ferramentas de linha de comando antigas
    (por exemplo, `dartfmt`) para usar a [ferramenta unificada `dart`][dart-tool]
    (por exemplo, `dart format`).
*   Atualizamos o código do site para usar as [regras do linter recomendadas][recommended linter rules],
    em vez de *pedantic*.
*   Atualizamos as listas de [bibliotecas principais][core libraries] e [pacotes comumente usados][commonly used packages].
*   Adicionamos um redirecionamento de [dartbrasil.dev/jobs][dartbrasil.dev/jobs] para flutter.dev/jobs,
    para facilitar a localização de vagas nas
    equipes do Dart e Flutter.
*   Terminamos a migração de todo o código analisado ou testado para *null safety*,
    atualizando o texto para corresponder.
    Encontramos mais código do site que não havia sido analisado; corrigimos isso.

[unsigned shift operator]: /language/operators#bitwise-and-shift-operators
[`.pubignore` file]: /tools/pub/publishing#what-files-are-published
[linter rule page]: /tools/linter-rules
[dart-tool]: /tools/dart-tool
[recommended linter rules]: /tools/analysis#lints
[core libraries]: /libraries
[commonly used packages]: /resources/useful-packages
[dartbrasil.dev/jobs]: /jobs
[no-promo]: /tools/non-promotion-reasons
[`dart create`]: /tools/dart-create
[`dart test`]: /tools/dart-test

### Artigos adicionados ao blog do Dart {:.no_toc}

Publicamos os seguintes artigos no blog do Dart:

*   [Experimentando com Dart e Wasm][blog-7-27-21]
*   [Como o *null safety* do Dart me ajudou a aprimorar meus projetos][blog-6-23-21]
*   [Implementando structs por valor em Dart FFI][blog-6/8-21]

[blog-7-27-21]: https://medium.com/dartlang/experimenting-with-dart-and-wasm-ef7f1c065577
[blog-6-23-21]: https://medium.com/dartlang/how-darts-null-safety-helped-me-augment-my-projects-af58f8129cf
[blog-6/8-21]: https://medium.com/dartlang/implementing-structs-by-value-in-dart-ffi-1cb1829d11a9


## 19 de maio de 2021: lançamento 2.13 {:#may-19-2021-2-13-release}

Esta seção lista as mudanças notáveis feitas de 4 de março de 2021,
até 19 de maio de 2021.
Para detalhes sobre o lançamento 2.13, veja [Anunciando o Dart 2.13][Announcing Dart 2.13].

[Announcing Dart 2.13]: https://medium.com/dartlang/announcing-dart-2-13-c6d547b57067

### Documentos atualizados ou adicionados a dartbrasil.dev {:.no_toc}

Além de correções de bugs e melhorias incrementais,
fizemos as seguintes mudanças neste site:

*   Atualizamos a [seção de typedef][typedef section] do tour da linguagem para refletir
    aliases de tipo não função,
    que foram introduzidos no Dart 2.13.
*   Publicamos ou atualizamos documentação relacionada à linha de comando e servidores:
    *   [Usando o Google Cloud][Using Google Cloud] descreve os produtos do Google Cloud que
        servidores Dart podem usar,
        muitas vezes com a ajuda de imagens Docker pré-configuradas.
    *   O [tutorial do servidor HTTP][HTTP server tutorial],
        que apresentava o pacote `http_server` descontinuado,
        foi temporariamente substituído por uma página
        "em construção" que
        faz um link para documentação e exemplos úteis.
    *   O [tutorial de linha de comando][command-line tutorial] foi completamente atualizado.
*   Publicamos algumas outras páginas novas:
    *   Codelab de *null safety* que ensina sobre o sistema de tipos *null-safe* do Dart,
        que foi introduzido no Dart 2.12.
    *   [Números em Dart][Numbers in Dart] tem
        detalhes sobre as diferenças entre as implementações de números nativas e web.
    *   [Usando APIs do Google][Using Google APIs] aponta para recursos para
        ajudá-lo a usar o Firebase e as APIs do cliente do Google de um aplicativo Dart.
    *   [Escrevendo páginas de pacotes][Writing package pages] fornece dicas para
        escrever um README de pacote que funcione bem no pub.dev.
    *   [Corrigindo falhas de promoção de tipo][Fixing type promotion failures]
        tem informações para ajudá-lo a entender
        por que ocorrem falhas de promoção de tipo e fornece dicas sobre como corrigi-las.
    *   A nova [página `dart run`][`dart run` page]
        descreve como executar um programa Dart da linha de comando.
*   Continuamos o trabalho na migração de código para *null safety*, em particular o
    [tutorial de streams][streams tutorial].
*   Fizemos outras atualizações diversas:
    *   Removemos referências ao Stagehand, em favor de [`dart create`][`dart create`].
    *   Alteramos as opções de análise para código de exemplo dartbrasil.dev de
        usar `pedantic` para usar as regras recomendadas em [`lints`][`lints`].
    *   Adicionamos Docker como uma forma de [obter o Dart][get Dart].
    *   Atualizamos a [página de evolução da linguagem][evolution] para refletir o Dart 2.13.

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

*   [AngularDart, Flutter e a web: atualização de primavera][blog-5-12-21]
*   [Anunciando o suporte do Dart para GitHub Actions][blog-3-24-21]
*   [Dart no Google Summer of Code 2021][blog-3-13-21]

[blog-5-12-21]: https://medium.com/dartlang/angulardart-flutter-and-the-web-spring-update-f7f5b8b10001
[blog-3-24-21]: https://medium.com/dartlang/announcing-dart-support-for-github-actions-3d892642104
[blog-3-13-21]: https://medium.com/dartlang/dart-in-google-summer-of-code-2021-e89eaf1d177a


## 3 de março de 2021: lançamento 2.12 {:#march-3-2021-2-12-release}

Esta seção lista as mudanças notáveis feitas de 2 de outubro de 2020,
até 3 de março de 2021.
Para detalhes sobre o lançamento 2.12, veja [Anunciando o Dart 2.12][Announcing Dart 2.12].


### Documentos atualizados ou adicionados a dartbrasil.dev {:.no_toc}

Além de correções de bugs e melhorias incrementais, fizemos as seguintes mudanças neste site:

*   Atualizamos e desenvolvemos documentos de *null safety*. Notavelmente:
    *   Fornecemos um [guia de migração][migration guide].
    *   Adicionamos um [FAQ][ns-faq].
    *   Criamos [Null safety não-sound][Unsound null safety].
    *   Simplificamos a [página inicial de *null safety*][null safety homepage].
*   Atualizamos o [Effective Dart][Effective Dart], atualizando o código para ser *null safe* e
    alterando as regras para refletir novas orientações.
*   Atualizamos o [tour da linguagem][language tour], atualizando o código para ser *null safe* e
    adicionando informações sobre novos recursos, como
    variáveis [`late`][`late` variables].
*   Atualizamos a [página de evolução da linguagem][evolution]
    para adicionar informações sobre versionamento de linguagem
    e para refletir o Dart 2.12.
*   Atualizamos o [tour da biblioteca][library tour] e os [tutoriais][tutorials]
    para refletir o *null safety sound*.
*   Atualizamos páginas em todo o site para usar [a ferramenta `dart`][the `dart` tool]
    em vez de comandos obsoletos.
    Começamos a adicionar páginas para vários comandos `dart`, incluindo
    [`dart analyze`][`dart analyze`], [`dart compile`][`dart compile`], [`dart fix`][`dart fix`],
    e [`dart format`][`dart format`].
*   Criamos uma página documentando a qualidade e o suporte dos [pacotes da equipe Dart][Dart team packages].
*   Substituímos a página Platforms por uma nova [página Overview][Overview page].
*   Criamos esta página ("O que há de novo").

Também mudamos do Travis CI para o GitHub Actions e fizemos várias mudanças no CSS para melhorar a legibilidade do site.

[Announcing Dart 2.12]: https://medium.com/dartlang/announcing-dart-2-12-499a6e689c87
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

*   [Preparando o ecossistema Dart e Flutter para *null safety*][blog-2-16-21]
    anunciou a estabilidade da API de *null safety* e
    convidou os desenvolvedores a publicar versões estáveis e *null-safe* de seus pacotes.
*   [Dart e os benefícios de desempenho de tipos *sound*][blog-1-19-21]
    demonstrou como o *soundness* e o *null safety* permitem que os compiladores Dart
    gerem código mais rápido e menor.
*   [Por que tipos anuláveis?][blog-12-7-20]
    expandiu uma discussão no subreddit /r/dart_lang,
    respondendo à pergunta "Por que não eliminar completamente o null?"
*   [Anunciando o beta de *null safety* do Dart][blog-11-19-20]
    convidou os desenvolvedores a começar a planejar sua migração para *null safety*.

[blog-2-16-21]: https://medium.com/dartlang/preparing-the-dart-and-flutter-ecosystem-for-null-safety-e550ce72c010
[blog-1-19-21]: https://medium.com/dartlang/dart-and-the-performance-benefits-of-sound-types-6ceedd5b6cdc
[blog-12-7-20]: https://medium.com/dartlang/why-nullable-types-7dd93c28c87a
[blog-11-19-20]: https://medium.com/dartlang/announcing-dart-null-safety-beta-87610fee6730

## 1º de outubro de 2020: lançamento 2.10 {:#october-1-2020-2-10-release}

Esta seção lista as mudanças notáveis feitas de
1º de julho a 1º de outubro de 2020.
Para detalhes sobre o lançamento 2.10, veja [Anunciando Dart 2.10.][210-ann]

[210-ann]: https://medium.com/dartlang/announcing-dart-2-10-350823952bd5

<div class="no_toc_section">

### Documentos atualizados ou adicionados em dartbrasil.dev {:.no_toc}

Além de correções de bugs e pequenas melhorias,
fizemos as seguintes mudanças neste site:

* Adicionamos uma [página da ferramenta `dart`][dart-tool]
  para documentar a nova interface de linha de comando para o SDK Dart.
  A nova ferramenta `dart` é análoga à ferramenta `flutter` no SDK Flutter.
  Anteriormente, o comando `dart` apenas executava aplicativos de linha de comando.
  Atualizamos a página `dart` anterior de acordo
  e planejamos atualizar as referências a outras ferramentas ao longo do tempo.
* Atualizamos a [documentação do changelog (registro de alterações) de pacotes][changelog-docs]
  para recomendar um formato padrão para arquivos `CHANGELOG.md`.
  Este novo formato permite que as ferramentas
  (como o relançado pub.dev)
  analisem os changelogs.
* Alteramos uma diretriz do [Effective Dart][] para favorecer
  o uso de `Object` em vez de `dynamic`.
  Para detalhes, veja a diretriz revisada
  [EVITE usar `dynamic` a menos que queira desativar a verificação estática.][dynamic]
* Atualizamos a [página de mensagens de diagnóstico][diagnostics] para
  incluir mais mensagens produzidas pelo analisador Dart.
* Atualizamos a [página de evolução][evolution]
  para incluir 2.9 e 2.10.
* Reorganizamos a [página de especificação da linguagem][spec]
  para facilitar a localização da versão PDF da
  especificação mais recente em andamento.
* Adicionamos ou atualizamos documentos relacionados ao [null safety sólido][],
  um recurso que está chegando à linguagem Dart:
  * Esclarecemos como usar [flags de experimento com IDEs][experiments].
  * Atualizamos a página de null safety, adicionando informações sobre
    [como ativar o null safety][ns-enable].
  * Adicionamos um mergulho profundo no null safety,
    [Entendendo o null safety][],
    escrito pelo engenheiro Dart Bob Nystrom.

[dart-tool]: /tools/dart-tool
[diagnostics]: /tools/diagnostic-messages
[dynamic]: /effective-dart/design#avoid-using-dynamic-unless-you-want-to-disable-static-checking
[Effective Dart]: /effective-dart
[evolution]: /resources/language/evolution
[experiments]: /tools/experiment-flags#using-experiment-flags-with-ides
[ns-enable]: /null-safety#enable-null-safety
[Entendendo o null safety]: /null-safety/understanding-null-safety
[null safety sólido]: /null-safety
[diagnostics]: /tools/diagnostic-messages
[changelog-docs]: /tools/pub/package-layout#changelog
[spec]: /resources/language/spec

### Artigos adicionados ao blog do Dart {:.no_toc}

Publicamos os seguintes artigos no [blog do Dart:][blog do Dart]

* [Explorando coleções em Dart][] ajuda você a usar coleções
  (listas, maps, sets e mais), com atenção especial aos
  recursos da linguagem 2.3 como collection if, collection for e spreads.
* [Resultados do Google Summer of Code 2020][] descreve os resultados de
  cinco projetos que a equipe Dart orientou.
* [Apresentando um novo pub.dev][] anuncia o relançamento do
  [site pub.dev,][pub.dev] com novas métricas de pontuação de pacotes, pesquisa aprimorada,
  e uma interface do usuário redesenhada.

Também melhoramos a navegação do blog,
adicionando guias de **anúncio** e **arquivo**, além de um link para dartbrasil.dev.

:::tip
Todos os artigos no blog do Dart são gratuitos para leitura.
:::

</div>

[blog do Dart]: https://medium.com/dartlang
[Explorando coleções em Dart]: https://medium.com/dartlang/exploring-collections-in-dart-f66b6a02d0b1
[Resultados do Google Summer of Code 2020]: https://medium.com/dartlang/google-summer-of-code-2020-results-a38cd072c9fe
[Apresentando um novo pub.dev]: https://medium.com/dartlang/pub-dev-redesign-747406dcb486
[pub.dev]: {{site.pub}}
