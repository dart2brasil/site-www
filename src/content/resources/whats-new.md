---
ia-translate: true
title: O que há de novo
description: Uma lista do que há de novo em dartbrasil.dev e sites relacionados.
lastVerified: 2024-08-06
---

Esta página descreve o que há de novo no site e blog Dart.
Para ver o que há de novo no Flutter, visite a
[página de novidades do Flutter.][flutter-whats-new]

Para obter uma lista das alterações na linguagem Dart em cada SDK Dart, consulte a
[página de evolução da linguagem][evolution].
Para ficar por dentro dos anúncios, incluindo mudanças de quebra,
participe do [grupo do Google de anúncios do Dart][dart-announce]
e siga o [blog do Dart][].

[flutter-whats-new]: {{site.flutter-docs}}/whats-new
[dart-announce]: https://groups.google.com/a/dartlang.org/d/forum/announce
[Dart blog]: https://medium.com/dartlang

## 6 de agosto de 2024: lançamento da versão 3.5 {:#august-6-2024-3-5-release}

Esta seção lista as mudanças notáveis feitas de 15 de maio de 2024,
até 6 de agosto de 2024.
Para obter detalhes sobre o lançamento da versão 3.5 do Dart,
confira o [anúncio da versão 3.5][] e o [changelog do SDK][3-5-changelog].

[3.5 announcement]: https://medium.com/dartlang/dart-3-5-6ca36259fa2f
[3-5-changelog]: {{site.repo.dart.sdk}}/blob/main/CHANGELOG.md#350---2024-08-06

### Documentos atualizados ou adicionados em dartbrasil.dev {:.no_toc}

Além de correções de bugs e melhorias incrementais,
fizemos as seguintes alterações neste site:

* Esclarecemos o status e os usos pretendidos de ambas,
  as novas e as antigas [bibliotecas da plataforma web][].
* Expandimos a documentação sobre [publicação de versões de pré-lançamento][]
  de pacotes para o site pub.dev.
* Adicionamos uma página cobrindo o novo comando [`dart pub unpack`][].
* Documentamos a nova flag [`--skip-validation`][] para `dart pub publish` e
  a flag [`--tighten`][] para `dart pub downgrade`.
* Fornecemos orientações de melhores práticas para autores de pacotes
  para [testar seu pacote com dependências rebaixadas][].
* Melhoramos o guia [Corrigindo falhas de promoção de tipo][] e adicionamos
  realce de código para indicar melhor o código relevante.
* Complementamos a [documentação de instalação do Dart][] com
  instruções de desinstalação e limpeza.
* Introduzimos novos documentos e exemplos de código cobrindo
  [função][func-tear] e [construtor][cons-tear] *tear-offs* (desconexões).
* Explicamos como [exportar funções e objetos Dart para serem usados a partir de JS][].
* Adicionamos entradas de glossário para [subclasse][] e [subtipo][],
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
Para obter detalhes sobre o lançamento da versão 3.4,
confira a [postagem do blog 3.4][] e o [changelog do SDK][3-4-changelog].

[3.4 blog post]: https://medium.com/dartlang/dart-3-4-bd8d23b4462a
[3-4-changelog]: {{site.repo.dart.sdk}}/blob/main/CHANGELOG.md#340---2024-05-14

### Documentos atualizados ou adicionados em dartbrasil.dev {:.no_toc}

Além de correções de bugs e melhorias incrementais,
fizemos as seguintes alterações neste site:

* Adicionamos uma página documentando o recurso de linguagem experimental [Macros][].
* Adicionamos uma página para rastrear os desenvolvimentos [Wasm][] para Dart.
* Refatoramos a página [Construtores][].
* Esclarecemos as instruções na seção [Renomeações][] da `package:web`
  página de migração.
* Ajustamos a entrada Effective Dart sobre [habilitando a promoção de tipo][] para recomendar
  o padrão de verificação nula antes de outros *idioms* (maneiras de fazer).
* Revisamos a lista de [Bibliotecas e pacotes da Web][] para melhor representar as
  soluções recomendadas.
* Explicamos como desestruturar campos nomeados nas páginas
  [Registros][] e [Padrões][].
* Incluímos uma [tabela de antes e depois][] de soluções web na página *JS interop* (interoperabilidade JS).
* Adicionamos uma seção explicando os [operadores de propagação][] à página de Operadores.
* Esclarecemos a ordenação de [padrões parentéticos][] na página de tipos de Padrão.
* Adicionamos documentos para [`ExternalDartReference`][] à página de tipos JS.
* Atualizamos o site para novas [regras de linter][] e [mensagens de diagnóstico][],
  por exemplo, adicionando documentação para o novo diagnóstico de anotação [`@mustBeConst`][].

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
Para obter detalhes sobre o lançamento da versão 3.3,
confira a [postagem do blog 3.3][] e o [changelog do SDK][3-3-changelog].

[3.3 blog post]: https://medium.com/dartlang/dart-3-3-325bf2bf6c13
[3-3-changelog]: {{site.repo.dart.sdk}}/blob/main/CHANGELOG.md#330

### Documentos atualizados ou adicionados em dartbrasil.dev {:.no_toc}

Além de correções de bugs e melhorias incrementais,
fizemos as seguintes alterações neste site:

* Mudamos a infraestrutura do site para [executar em 11ty][] em vez de Jekyll.
* Adicionamos uma página cobrindo o novo recurso de linguagem [tipos de extensão][].
* Adicionamos um novo conjunto de documentação sobre [*JavaScript interop*][]:
  * [Uso][]
  * [Tipos JS][]
  * [Tutoriais][], o primeiro dos quais é sobre [Mocks][]
  * [*JS interop* passado][]
* Atualizamos a visão geral de [Concorrência][], além de uma nova página prática sobre o uso de [Isolates][].
* Adicionamos uma seção sobre [`external`][] à página [Funções][].
* Removemos o DartPad incorporado de algumas páginas para acomodar
  a nova versão do [DartPad][].
* Incluímos uma definição para "Função" no [Glossário][].
* Desconstruímos o [Roteiro da biblioteca][] em páginas individuais para cada biblioteca.
* Atualizamos a página de [Alterações interruptivas][] para 3.3.
* Atualizamos algumas entradas desatualizadas na página [FAQ](/resources/faq).
* Expandimos a documentação sobre [`dart doc`][].
* Atualizamos e simplificamos o conteúdo de [plataformas suportadas][].
* Consolidamos múltiplos conteúdos de [`dart format`][].
* Atualizamos vários locais para sugerir [`package:web`][] em vez de `dart:html`.
* Deixamos de recomendar [`dart:html`][] e [`dart:io`][]
  para fazer solicitações HTTP, em favor de `package:http`.
* Documentamos [suprimir diagnósticos em um arquivo pubspec][].
* Adicionamos conteúdo sobre [criação][] e [ignorando][] avisos de segurança em um arquivo pubspec.
* Documentamos [como migrar de uma versão de pacote retratada][retract].

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
[ignoring]: /tools/pub/pubspec#ignored-advisories
[creating]: /tools/pub/security-advisories
[retract]: /tools/pub/publishing#how-to-migrate-away-from-a-retracted-package-version


## 15 de novembro de 2023: lançamento da versão 3.2 {:#november-15-2023-3-2-release}

Esta seção lista as mudanças notáveis feitas de 17 de agosto de 2023,
até 15 de novembro de 2023.
Para obter detalhes sobre o lançamento da versão 3.2,
confira a [postagem do blog 3.2][] e o [changelog do SDK][3-2-changelog].

[3.2 blog post]: https://medium.com/dartlang/dart-3-2-c8de8fe1b91f
[3-2-changelog]: {{site.repo.dart.sdk}}/blob/main/CHANGELOG.md#320---2023-11-15

### Documentos atualizados ou adicionados em dartbrasil.dev {:.no_toc}

Além de correções de bugs e melhorias incrementais,
fizemos as seguintes alterações neste site:

* Atualizamos a página [Corrigindo falhas de promoção de tipo][no-promo]
  para um novo recurso de promoção de tipo: promoção de campo final privado.
  * Fizemos pequenos ajustes relacionados à entrada Effective Dart sobre
    [promoção de tipo][], a página [Entendendo a segurança nula][] e outros vários
    locais em todo o site.
* Introduzimos documentação sobre o recurso experimental de *assets* (recursos) nativos
  para a página [interoperabilidade C][].
* Criamos uma nova página dedicada à documentação de [Alterações interruptivas][].
* Levamos em consideração novos e atualizados [lints][] e [diagnósticos][] em seus
  respectivas páginas de documentação.
* Adicionamos documentação para a nova flag `--tighten ` à página [`pub upgrade`].
* Removemos a *cheatsheet* (folha de dicas) em favor da página [Visão geral da linguagem][].
* Esclarecemos a relação entre [cláusulas de guarda e padrões][].
* Ajustamos a página [Construtores][] para melhor representar as melhores práticas.
* Melhoramos o conteúdo da página [Dependências de pacotes][] para ser mais acionável
  e mais fácil de seguir.
* Elaboramos sobre membros estáticos na página [Métodos de extensão][].
* Mudamos o conteúdo das limitações de *multithreading* (multitarefas) [Objective-C][] para levar em consideração
  a nova API `NativeCallable`.
* Adicionamos novas anotações e mencionamos descontinuações na página [Metadados][].
* Melhoramos o contraste ajustando as cores do texto e o realce em
  exemplos de código em todo o site.
* Reorganizamos e simplificamos a infraestrutura do site em geral, em preparação
  para [deixar de usar o Jekyll][].

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
Para obter detalhes sobre o lançamento da versão 3.1,
confira
[Dart 3.1 e uma retrospectiva sobre programação de estilo funcional no Dart 3][]
e o [changelog do SDK][3-1-changelog].

[Dart 3.1 & a retrospective on functional style programming in Dart 3]: https://medium.com/dartlang/dart-3-1-a-retrospective-on-functional-style-programming-in-dart-3-a1f4b3a7cdda
[3-1-changelog]: {{site.repo.dart.sdk}}/blob/main/CHANGELOG.md#310---2023-08-16

### Documentos atualizados ou adicionados em dartbrasil.dev {:.no_toc}

Além de correções de bugs e melhorias incrementais,
fizemos as seguintes alterações neste site:

* Reformulamos a documentação das regras do linter para substituir o antigo site do linter:
  * Movemos a documentação de cada regra do linter para sua própria página.
    Por exemplo: [`avoid_dynamic_calls`][].
  * Adicionamos um exemplo `analysis_options.yaml` que habilita
    [todas as regras do linter][] disponíveis na versão mais recente do Dart.
  * Atualizamos o [índice de todas as regras do linter disponíveis][]
    para permitir uma descoberta mais fácil do linter.
* Aumentamos a documentação de [modificadores de classe][] adicionando uma
  [Referência de modificadores de classe][] para descrever como eles interagem uns com os outros.
* Introduzimos um guia [Modificadores de classe para mantenedores de API][] para ajudar
  os desenvolvedores a melhor usar os modificadores de classe.
* Reescrevemos a documentação da [expressão switch][]
  para melhor explicar suas diferenças em relação às instruções *switch*.
* Documentamos o suporte para especificar [tópicos][] no seu arquivo pubspec
  para categorizar seu pacote no site pub.dev.
* Esclarecemos que as [capturas de tela do pacote][] destinam-se a
  mostrar a funcionalidade do pacote, não o logotipo ou ícone do pacote.
* Adicionamos botões anterior e próximo à
  [documentação da linguagem][] do Dart para permitir uma experiência de aprendizado guiada.
* Continuamos a expandir o novo [glossário][] para todo o site.
* Adicionamos uma nota de migração sobre como o
  [movimento do cache do pub][] no Windows foi finalizado no Dart 3.
* Simplificamos e atualizamos documentos mais antigos agora que
  o sistema de tipos do Dart é sempre [seguro contra nulos][].

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

* [Dart DevTools: Analisando o desempenho do aplicativo com o CPU Profiler][blog-6-12-23]

[blog-6-12-23]: https://medium.com/dartlang/dart-devtools-analyzing-application-performance-with-the-cpu-profiler-3e94a0ec06ae

## 10 de maio de 2023: lançamento da versão 3.0 {:#may-10-2023-3-0-release}

Esta seção lista as mudanças notáveis feitas de 26 de janeiro de 2023,
até 10 de maio de 2023.
Para obter detalhes sobre o lançamento principal da versão 3.0,
confira [Anunciando o Dart 3][],
e o [changelog do SDK][3-0-changelog].

[Announcing Dart 3]: https://medium.com/dartlang/announcing-dart-3-53f065a10635
[3-0-changelog]: {{site.repo.dart.sdk}}/blob/main/CHANGELOG.md#300---2023-05-10

### Documentos atualizados ou adicionados em dartbrasil.dev {:.no_toc}

Em preparação para o Dart 3, dividimos e reorganizamos o
Roteiro da linguagem em novas categorias conceituais.
Você pode acessar a documentação de linguagem reestruturada
em **Linguagem** no menu de navegação lateral ou
visitando a [Introdução ao Dart][] atualizada.

Aproveitando esta nova estrutura,
adicionamos documentação para cada um dos principais recursos do Dart 3:

- [Correspondência de padrões][] e os diferentes [tipos de padrões][].
- [Expressões Switch][] com suporte para
  padrões e [verificação de exaustividade][].
- [Instruções If com cláusulas case][] para suportar correspondência de padrões.
- [Registros][], um novo tipo anônimo, imutável e agregado
  que permite [múltiplos retornos][].
- [Modificadores de classe][] que dão às bibliotecas mais controle sobre os tipos exportados.

Para ajudá-lo na transição para a aplicação do Dart 3 de [segurança nula sólida][]
e outras alterações, também preparamos as seguintes atualizações:

- Criamos um [guia abrangente de migração do Dart 3][].
- Migramos toda a documentação e exemplos de código
  para Dart 3, as versões mais recentes de ferramentas e as dependências mais recentes.
- Esclarecemos que o sistema de tipos do Dart agora é sempre seguro contra nulos no Dart 3.
- Atualizamos e reorganizamos a página [Evolução da linguagem][]
  e sua discussão sobre [controle de versão da linguagem][].
- Removemos vestígios de documentos, notas e recursos do Dart 1 e do início do Dart 2.

Além do novo conteúdo do Dart 3 e
atualizações correspondentes em todo o site,
fizemos as seguintes alterações:

- Adicionamos um guia sobre como configurar [declarações de ambiente de compilação][].
- Continuamos o trabalho de interoperabilidade nativa do Dart
  adicionando um guia sobre suporte experimental para [interoperabilidade Java][].
- Esclarecemos o uso e as limitações de [extensões sem nome][].
- Adicionamos uma página para o novo comando [`dart info`][]
  que ajuda com diagnósticos de ferramentas.
- Reformulamos a documentação [`dart pub add`][]
  para cobrir sua nova sintaxe de [descritor de origem][].
- Surgiram visualizações de builds do Linux RISC-V (RV64GC) no
  canal beta no [arquivo do SDK][].
- Iniciamos um novo [glossário][] para todo o site para conter
  termos comuns usados em todo o site.
- Destacamos o trabalho experimental no [suporte de interoperabilidade estática JS][] do Dart.
- Documentamos a existência e as limitações atuais dos [plugins do analisador][].

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
[compilation environment declarations]: /guides/environment-declarations
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

* [Apresentando o Realm para Dart e Flutter][blog-2-09-23]

[blog-2-09-23]: https://medium.com/dartlang/introducing-realm-for-dart-flutter-e30cb05eb313

### Vídeos lançados pela equipe do Dart {:.no_toc} {:#videos-released-by-the-dart-team}

Durante o Google I/O 2023, lançamos os seguintes vídeos:

* [O que há de novo em Dart e Flutter][] ([versão em Língua de Sinais Americana][])
* [Repensando a interoperabilidade do Dart com o Android][]
* [Como construir um pacote em Dart][]

[What's new in Dart and Flutter]: {{site.yt.watch}}?v=yRlwOdCK7Ho
[American Sign Language version]: {{site.yt.watch}}?v=QbMgjVB0XMI
[Rethinking Dart interoperability with Android]: {{site.yt.watch}}?v=ZWp2FJ2TuJs
[How to build a package in Dart]: {{site.yt.watch}}?v=8V_TLiWszK0

## 25 de janeiro de 2023: lançamentos das versões 2.19 + 3.0 alfa {:#january-25-2023-2-19-3-0-alpha-releases}

Esta seção lista as mudanças notáveis feitas de 31 de agosto de 2022,
até 25 de janeiro de 2023.
Para obter detalhes sobre os lançamentos alfa 2.19 + 3.0,
consulte [Apresentando o Dart 3 alfa][],
e o [changelog do SDK][2-19-changelog].

[Introducing Dart 3 alpha]: https://medium.com/dartlang/dart-3-alpha-f1458fb9d232
[2-19-changelog]: {{site.repo.dart.sdk}}/blob/main/CHANGELOG.md#2190---2023-01-24

### Documentos atualizados ou adicionados em dartbrasil.dev {:.no_toc}

Além de correções de bugs e melhorias incrementais,
fizemos as seguintes alterações neste site:

* Apresentamos o tutorial [Buscar dados da internet][] sobre como usar `package:http`.
* Adicionamos uma página sobre [Publicação automatizada de pacotes no pub.dev][].
* Incluímos links para duas novas traduções de sites em nossa [seção de recursos da comunidade][]:
  * [Versão coreana deste site (한국어)](https://dart-ko.dev/)
  * [Versão em chinês tradicional deste site (正體中文版)](https://dart.tw.gh.miniasp.com/)
* Atualizamos o conteúdo de segurança nula em preparação para o Dart 3:
  * Alteramos as restrições de versão no [guia de migração][] para compatibilidade com o Dart 3.
  * Adicionamos uma visão geral completa da segurança nula sólida do Dart 3 à página [Segurança nula sólida][].
  * Enfatizamos a incompatibilidade do Dart 3 com [segurança nula não sólida][] em uma nota.
* Introduzimos o novo guia [Aprendendo Dart como um desenvolvedor Swift][].
* Substituímos uma seção Effective Dart por orientações mais gerais sobre [booleanos e operadores de igualdade][].
* Documentamos [hash de conteúdo][] em todos os documentos do pub.
* Começamos o esforço para reformular a página [Zonas][]
  alterando exemplos para usar `runZonedGuarded` em vez de `onError`.
* Atualizamos o conteúdo sobre bibliotecas para cobrir o novo desenvolvimento de declarações sem nome:
  * Effective Dart: [Documentação][], [Estilo][] e [Uso][]
  * Nova seção de diretiva de biblioteca em [O roteiro da linguagem][]
* Melhoramos a clareza em torno do status de *single-threaded* (tarefa única) ou *multi-threaded* (multitarefa) do Dart:
  * Removemos a página desatualizada `dart:io`.
  * Expandimos as [capacidades de concorrência web do Dart][].
* Reorganizamos e esclarecemos a [discussão][] de valores padrão para parâmetros opcionais e posicionais.
* Atualizamos a [Concorrência no Dart][] para usar como padrão a nova função `Isolate.run()`.
* Documentamos como especificar um caminho de arquivo ao ativar um pacote na [página `pub global`][].
* Reescrevemos [Aprendendo Dart como um desenvolvedor JavaScript][].
* Adicionamos uma breve visão geral do Dart DevTools na [página `dart run`][].
* Fornecemos mais clareza sobre [precedência e associatividade de operadores][] no roteiro da linguagem.
* Expandimos a seção de roteiro da biblioteca em [Construindo URIs][] com informações sobre URI http e construtor de fábrica.
* Levamos em consideração a [transição do pub para pub.dev][] de pub.dartlang.org.
* Adicionamos documentação sobre [capturas de tela de pacotes][].
* Melhoramos a [seção de *downcast* (conversão) explícito][] da página O sistema de tipos do Dart.
* Aumentamos a cobertura do [analisador][] e do [linter][]:
  * Incluímos informações de suporte da versão do SDK para regras do linter.
  * Adicionamos mensagens de diagnóstico e linter para alterações 2.19.

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

* [Melhor gerenciamento de isolates com Isolate.run()][blog-1-24-23]
* [Capturas de tela e publicação automatizada para pub.dev][blog-1-18-23]
* [O caminho para o Dart 3: Uma linguagem totalmente sólida e segura para nulos][blog-12-8-22]
* [Resultados do Google Summer of Code 2022][blog-11-3-22]
* [Parceria com o GitHub em segurança da cadeia de suprimentos para pacotes Dart][blog-10-6-22]

[blog-1-24-23]: https://medium.com/dartlang/better-isolate-management-with-isolate-run-547ef3d6459b
[blog-1-18-23]: https://medium.com/dartlang/screenshots-and-automated-publishing-for-pub-dev-9bceb19edf79
[blog-12-8-22]: https://medium.com/dartlang/the-road-to-dart-3-afdd580fbefa
[blog-11-3-22]: https://medium.com/dartlang/google-summer-of-code-2022-results-a3ce1c13c06c
[blog-10-6-22]: https://medium.com/dartlang/partnering-with-github-on-an-supply-chain-security-485eed1fc388


## 30 de agosto de 2022: Lançamento 2.18 {:#august-30-2022-2-18-release}

Esta seção lista as mudanças notáveis feitas de 12 de maio de 2022,
até 30 de agosto de 2022.
Para detalhes sobre a versão 2.18,
veja [Dart 2.18: Interoperabilidade com Objective-C e Swift][],
e o [changelog do SDK][2-18-changelog].

[Dart 2.18: Interoperabilidade com Objective-C e Swift]: https://medium.com/dartlang/dart-2-18-f4b3101f146c
[2-18-changelog]: {{site.repo.dart.sdk}}/blob/main/CHANGELOG.md#2180---2022-08-30

Além de correções de bugs e melhorias incrementais,
fizemos as seguintes alterações neste site:

* Introduzida a página [Interoperabilidade com Objective-C e Swift][],
  que explica como usar pacotes Dart para chamar APIs dessas linguagens.
* Adicionada uma solução alternativa para [Corrigindo problemas de tipo comuns][],
  para o raro caso em que a inferência de tipo pode inferir incorretamente que um tipo de argumento é nulo.
* Removida toda a menção a arquivos `.packages` descontinuados de [O que não cometer][].
  Se você ainda precisar gerar um arquivo `.packages` devido a dependências legadas de terceiros,
  veja [Opções `dart pub get`][].
* Removidas páginas dedicadas e qualquer outra menção de `dart2js` descontinuado
  e ferramentas de linha de comando `dartdevc`.
  * Adicionadas opções de linha de comando e problemas conhecidos previamente associados a
  `dart2js` à página [`dart compile`][].
  * Adicionadas informações sobre depuração de código de produção em [Depurando aplicativos da web Dart][].
* Adicionado suporte para baixar builds experimentais do Windows ARM
  para o [arquivo do SDK Dart][].
* Atualizado o [Tour de bibliotecas][] para incluir informações sobre referências fracas e finalizadores.
* Adicionada uma seção sobre personalização de [`dart fix`][].

[Interoperabilidade com Objective-C e Swift]: /interop/objective-c-interop
[Corrigindo problemas de tipo comuns]: /deprecated/sound-problems
[O que não cometer]: /tools/pub/private-files
[Opções `dart pub get`]: /tools/pub/cmd/pub-get#options
[`dart compile`]: /tools/dart-compile
[Depurando aplicativos da web Dart]: /web/debugging
[arquivo do SDK Dart]: /get-dart/archive
[Tour de bibliotecas]: /libraries/dart-core#weak-references-and-finalizers
[`dart fix`]: /tools/dart-fix#customize

## 11 de maio de 2022: Lançamento 2.17 {:#may-11-2022-2-17-release}

Esta seção lista as mudanças notáveis feitas de 4 de fevereiro de 2022,
até 11 de maio de 2022.
Para detalhes sobre a versão 2.17,
veja [Dart 2.17: Produtividade e integração][].

[Dart 2.17: Produtividade e integração]: https://medium.com/dartlang/dart-2-17-b216bfc80c5d

### Documentos atualizados ou adicionados ao dart.dev {:.no_toc}

Além de correções de bugs e melhorias incrementais,
fizemos as seguintes alterações neste site:

* Introduzido o guia [Aprendendo Dart como desenvolvedor JavaScript][],
  que visa aproveitar seu conhecimento de programação JavaScript
  ao aprender Dart.
* Documentados os recursos e mudanças introduzidas no Dart 2.17:
  * Atualizada a seção [Parâmetros nomeados][] do tour da linguagem
    para refletir o suporte para especificar argumentos nomeados em qualquer lugar.
  * Adicionada documentação para [parâmetros super-inicializadores][].
  * Expandida a seção [Tipos enumerados][] do tour da linguagem
    e documentados [enums aprimorados][].
  * Documentado o suporte para [assinatura][] de executáveis macOS e Windows
    compilados com `dart compile exe`.
  * Atualizados os modelos suportados por [`dart create`][]
    para seus novos nomes padronizados.
* Levadas em conta as mudanças no [site pub.dev][] e na [ferramenta pub][].
  * Listados fornecedores que oferecem [repositórios de pacotes Dart como um serviço][].
  * Removida a documentação para o comando `dart pub uploader` agora descontinuado.
  * Expandida a documentação para gerenciamento de [uploaders][] de projetos pub.
  * Removida a maioria das menções ao arquivo `.packages` descontinuado,
    apontando em vez disso para seu substituto `.dart_tool/package_config.json`.
* Atualizada a documentação para atualização e instalação do Dart:
  * Documentado como alternar entre as versões do Dart
    com Homebrew nas [instruções de instalação][get-dart-install] do macOS.
  * Atualizadas as [instruções de instalação][get-dart-install] do Linux
    para usar [SecureApt][] e seguir as últimas práticas recomendadas.
  * Adicionado suporte para baixar builds experimentais do Linux RISC-V (RV64GC)
    do [arquivo do SDK Dart][].
* Trabalho contínuo para melhorar e atualizar a documentação
  da [ferramenta `dart` unificada][dart-tool]:
  * Expandida a documentação sobre a funcionalidade da ferramenta [`dart fix`][].
  * Ajustadas as diretrizes e a documentação da ferramenta [`dart doc`][]
    para corresponder à sua funcionalidade e comportamento subjacente.
  * Adicionada mais documentação e exemplos de [`dart compile js`][].
  * Removidas as menções de ferramentas autônomas removidas.
* Atualizada a documentação e o uso do analisador e linter:
  * Documentados os novos [modos de linguagem estritos][] do analisador.
  * Incorporadas as mudanças nas páginas
    [mensagens de diagnóstico][] e [regras do linter][].
  * Atualizada a documentação e os exemplos
    para usar a versão `2.0.0` do pacote `lints`.
* Iniciada uma revisão da documentação para compilação web:
  * Documentado para a descontinuação e remoção planejada
    das ferramentas autônomas `dart2js` e `dartdevc`.
  * Consolidada e esclarecida a documentação de
    [dart2js][] e [dartdevc][]
    como os compiladores subjacentes de ferramentas como
    [`dart compile js`][] e [`webdev`][].
* Aumentada a cobertura da documentação da segurança nula:
  * Documentado o operador de asserção não nula (`!`) como parte da seção
    [Outros operadores][] do tour da linguagem.
  * Migrados os [tutoriais HTML de baixo nível][] para suportar segurança nula
    e discutir como interagir com APIs da web ao usá-la.
* Feitas outras atualizações diversas:
  * Documentados os [tipos nativos][] fornecidos por `dart:ffi`
    para uso em interoperabilidade C.
  * Introduzida uma nova seção no tour da linguagem documentando
    [parâmetros formais de inicialização][].
  * Documentado o [suporte para pacotes][] do DartPad.
  * Corrigida a formatação no [tutorial de programação assíncrona][]
    e detalhado [por que o código assíncrono é importante][].
  * Atualizada a página [segurança][] para corresponder às nossas práticas de segurança atuais.
  * Adicionado um atalho de teclado (`/`) para focar automaticamente a barra de pesquisa.

[Aprendendo Dart como desenvolvedor JavaScript]: /resources/coming-from/js-to-dart

[Parâmetros nomeados]: /language/functions#named-parameters
[Tipos enumerados]: /language/enums
[enums aprimorados]: /language/enums#declaring-enhanced-enums
[parâmetros super-inicializadores]: /language/constructors#super-parameters
[assinatura]: /tools/dart-compile#signing
[`dart create`]: /tools/dart-create

[site pub.dev]: {{site.pub}}
[ferramenta pub]: /tools/pub/cmd
[repositórios de pacotes Dart como um serviço]: /tools/pub/custom-package-repositories#dart-package-repositories-as-a-service
[uploaders]: /tools/pub/publishing#uploaders

[instruções de instalação]: /get-dart#install
[SecureApt]: https://wiki.debian.org/SecureApt
[arquivo do SDK Dart]: /get-dart/archive

[dart-tool]: /tools/dart-tool
[`dart fix`]: /tools/dart-fix
[`dart doc`]: /tools/dart-doc
[`dart compile js`]: /tools/dart-compile#js

[modos de linguagem estrita]: /tools/analysis#enabling-additional-type-checks
[mensagens de diagnóstico]: /tools/diagnostic-messages
[regras do linter]: /tools/linter-rules

[dart2js]: /tools/dart2js
[dartdevc]: /tools/dartdevc
[`webdev`]: /tools/webdev

[Outros operadores]: /language/operators#other-operators
[tutoriais HTML de baixo nível]: /web/get-started

[tipos nativos]: /interop/c-interop#interface-with-native-types
[parâmetros formais de inicialização]: /language/constructors#use-initializing-formal-parameters
[suporte para pacotes]: /tools/dartpad#library-support
[tutorial de programação assíncrona]: /libraries/async/async-await
[por que o código assíncrono importa]: /libraries/async/async-await#why-asynchronous-code-matters
[segurança]: /security


### Artigos adicionados ao blog do Dart {:.no_toc}

Publicamos os seguintes artigos no blog do Dart:

* [Aplicação em massa de correções][blog-5-5-22]
* [Programação assíncrona em Dart: Streams][blog-4-14-22]
* [Colaboradores para o Google Summer of Code 2022][blog-4-7-22]
* [Migração gradual para null safety em grandes projetos Dart][blog-3-31-22]
* [Hospedagem de um repositório de pacotes Dart privado][blog-3-16-22]
* [Correções rápidas para problemas de análise][blog-3-4-22]

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
veja [Dart 2.16: Ferramentas e tratamento de plataforma aprimorados][].

[Dart 2.16: Ferramentas e tratamento de plataforma aprimorados]: https://medium.com/dartlang/dart-2-16-improved-tooling-and-platform-handling-dd87abd6bad1

### Documentos atualizados ou adicionados em dartbrasil.dev {:.no_toc}

[Atualizamos a infraestrutura do site][] para uma configuração baseada em Docker
para habilitar [contribuições mais fáceis][] e alinhar mais estreitamente com
a configuração para [docs.flutter.dev]({{site.flutter-docs}}).

Além de outras correções de bugs e melhorias incrementais,
fizemos as seguintes mudanças neste site:

* Mudamos para documentar a nova ferramenta [`dart doc`][]
  que substitui `dartdoc`.
* Documentamos a nova [entrada `platform`][] para especificar plataformas suportadas
  dentro do `pubspec.yaml` de um pacote.
* Atualizamos as páginas de [mensagens de diagnóstico][] e [regras do linter][].
* Documentamos como [ignorar todas as regras do linter][] em um arquivo.
* Removemos as menções das antigas ferramentas autônomas da [visão geral do SDK Dart][].
* Atualizamos as menções restantes das antigas ferramentas autônomas
  para seus equivalentes na ferramenta [`dart`][].
* Adicionamos esclarecimentos à diretriz
  [PREFIRA usar interpolação para compor strings e valores][]
  do Effective Dart.

[atualizamos a infraestrutura do site]: {{site.repo.this}}/pull/3765
[contribuições mais fáceis]: {{site.repo.this}}#getting-started
[`dart doc`]: /tools/dart-doc
[entrada `platform`]: /tools/pub/pubspec#platforms
[ignorar todas as regras do linter]: /tools/analysis#suppressing-rules-for-a-file
[mensagens de diagnóstico]: /tools/diagnostic-messages
[regras do linter]: /tools/linter-rules
[visão geral do SDK Dart]: /tools/sdk
[PREFIRA usar interpolação para compor strings e valores]: /effective-dart/usage#prefer-using-interpolation-to-compose-strings-and-values
[`dart`]: /tools/dart-tool


## 8 de dezembro de 2021: lançamento 2.15 {:#december-8-2021-2-15-release}

Esta seção lista as mudanças notáveis feitas de 9 de setembro de 2021,
até 8 de dezembro de 2021.
Para detalhes sobre o lançamento 2.15, veja [Anunciando Dart 2.15][].

[Anunciando Dart 2.15]: https://medium.com/dartlang/dart-2-15-7e7a598e508a

### Documentos atualizados ou adicionados em dartbrasil.dev {:.no_toc}

Além de correções de bugs e melhorias incrementais,
fizemos as seguintes mudanças neste site:

* Adicionamos [Concorrência em Dart][], que discute recursos como
  isolates (isolados) que permitem a execução paralela de código Dart.
* Documentamos os recursos do pub adicionados ou melhorados em 2.15:
  * Adicionamos uma página para um novo subcomando pub, [dart pub token][],
    e uma página sobre [repositórios de pacotes personalizados][]
  * Adicionamos informações sobre [retração de pacote][]
  * Adicionamos o campo [false_secrets][] à página do pubspec
  * Atualizamos a sintaxe para [dependências hospedadas][]
* Removemos todas as entradas para [livros][] do Dart 1
* Expandimos as [dicas de solução de problemas do DartPad][]
* Atualizamos a página de [mensagens de diagnóstico][]
* Atualizamos a página de [regras do linter][];
  removemos referências a conjuntos de regras obsoletos, como
  `effective_dart`
* Atualizamos as instruções para instalar e usar
  [Dart DevTools][]
* Adicionamos informações sobre o que o [runtime (ambiente de execução) Dart][] fornece,
  e esclarecemos os [formatos de compilação][]

[livros]: /resources/books
[formatos de compilação]: /tools/dart-compile
[Concorrência em Dart]: /language/concurrency
[repositórios de pacotes personalizados]: /tools/pub/custom-package-repositories
[Dart DevTools]: /tools/dart-devtools
[dart pub token]: /tools/pub/cmd/pub-token
[runtime (ambiente de execução) Dart]: /overview#runtime
[dicas de solução de problemas do DartPad]: /tools/dartpad/troubleshoot
[mensagens de diagnóstico]: /tools/diagnostic-messages
[false_secrets]: /tools/pub/pubspec#false-secrets
[dependências hospedadas]: /tools/pub/dependencies#hosted-packages
[regras do linter]: /tools/linter-rules
[retração de pacote]: /tools/pub/publishing#retract


## 8 de setembro de 2021: lançamento 2.14 {:#september-8-2021-2-14-release}

Esta seção lista as mudanças notáveis feitas de 20 de maio de 2021,
até 8 de setembro de 2021.
Para detalhes sobre o lançamento 2.14, veja [Anunciando Dart 2.14][].

[Anunciando Dart 2.14]: https://medium.com/dartlang/announcing-dart-2-14-b48b9bb2fb67

### Documentos atualizados ou adicionados em dartbrasil.dev {:.no_toc}

Além de correções de bugs e melhorias incrementais,
fizemos as seguintes mudanças neste site:

* Desenvolvemos a página sobre [como corrigir falhas de promoção de tipo][no-promo].
* Documentamos como usar o [arquivo `.pubignore`][],
  um recurso que foi introduzido no Dart 2.14.
* Adicionamos cobertura do [operador de deslocamento sem sinal][] (`>>>`),
  que foi introduzido no Dart 2.14.
* Construímos a [página de regras do linter][];
  atualizamos o Effective Dart para vincular a ela.
* Adicionamos páginas para os comandos
  [`dart create`][] e [`dart test`][].
* Terminamos de converter exemplos do uso de antigas ferramentas de linha de comando
  (por exemplo, `dartfmt`) para usar a [ferramenta unificada `dart`][dart-tool]
  (por exemplo, `dart format`).
* Atualizamos o código do site para usar as [regras do linter recomendadas][],
  em vez de pedantic.
* Atualizamos as listas de [bibliotecas principais][] e [pacotes comumente usados][].
* Adicionamos um redirecionamento de [dartbrasil.dev/jobs][] para flutter.dev/jobs,
  para facilitar a localização de vagas na
  equipes Dart e Flutter.
* Terminamos de migrar todo o código analisado ou testado para null safety,
  atualizando o texto para corresponder.
  Encontramos mais código do site que não havia sido analisado; corrigimos isso.

[operador de deslocamento sem sinal]: /language/operators#bitwise-and-shift-operators
[arquivo `.pubignore`]: /tools/pub/publishing#what-files-are-published
[página de regras do linter]: /tools/linter-rules
[dart-tool]: /tools/dart-tool
[regras do linter recomendadas]: /tools/analysis#lints
[bibliotecas principais]: /libraries
[pacotes comumente usados]: /resources/useful-packages
[dartbrasil.dev/jobs]: /jobs
[no-promo]: /tools/non-promotion-reasons
[`dart create`]: /tools/dart-create
[`dart test`]: /tools/dart-test

### Artigos adicionados ao blog do Dart {:.no_toc}

Publicamos os seguintes artigos no blog do Dart:

* [Experimentando com Dart e Wasm][blog-7-27-21]
* [Como o null safety do Dart me ajudou a aumentar meus projetos][blog-6-23-21]
* [Implementando structs por valor em Dart FFI][blog-6/8-21]

[blog-7-27-21]: https://medium.com/dartlang/experimenting-with-dart-and-wasm-ef7f1c065577
[blog-6-23-21]: https://medium.com/dartlang/how-darts-null-safety-helped-me-augment-my-projects-af58f8129cf
[blog-6/8-21]: https://medium.com/dartlang/implementing-structs-by-value-in-dart-ffi-1cb1829d11a9


## 19 de maio de 2021: lançamento 2.13 {:#may-19-2021-2-13-release}

Esta seção lista as mudanças notáveis feitas de 4 de março de 2021,
até 19 de maio de 2021.
Para detalhes sobre o lançamento 2.13, veja [Anunciando Dart 2.13][].

[Anunciando Dart 2.13]: https://medium.com/dartlang/announcing-dart-2-13-c6d547b57067

### Documentos atualizados ou adicionados em dartbrasil.dev {:.no_toc}

Além de correções de bugs e melhorias incrementais,
fizemos as seguintes mudanças neste site:

* Atualizamos a [seção typedef][] do tour da linguagem para refletir
  aliases de tipo não-funcionais,
  que foram introduzidos no Dart 2.13.
* Publicamos ou atualizamos a documentação relacionada à linha de comando e servidores:
  * [Usando o Google Cloud][] descreve os produtos do Google Cloud que
    servidores Dart podem usar,
    muitas vezes com a ajuda de imagens Docker pré-empacotadas.
  * O [tutorial do servidor HTTP][],
    que apresentava o pacote `http_server` descontinuado,
    foi temporariamente substituído por
    uma página "em construção" que
    vincula a documentação e exemplos úteis.
  * O [tutorial de linha de comando][] foi completamente atualizado.
* Publicamos algumas outras páginas novas:
  * Codelab de null safety que ensina sobre o sistema de tipos null-safe do Dart,
    que foi introduzido no Dart 2.12.
  * [Números em Dart][] tem
    detalhes sobre as diferenças entre as implementações de números nativos e web.
  * [Usando APIs do Google][] aponta para recursos para
    ajudá-lo a usar o Firebase e as APIs de cliente do Google a partir de um aplicativo Dart.
  * [Escrevendo páginas de pacotes][] dá dicas para
    escrever um README de pacote que funcione bem no pub.dev.
  * [Como corrigir falhas de promoção de tipo][]
    tem informações para ajudá-lo a entender
    por que ocorrem falhas de promoção de tipo e dá dicas sobre como corrigi-las.
  * A nova [página `dart run`][]
    descreve como executar um programa Dart a partir da linha de comando.
* Continuamos o trabalho de migração de código para null safety, em particular o
  [tutorial de streams][].
* Fizemos outras atualizações diversas:
  * Removemos as referências ao Stagehand, em favor de [`dart create`][].
  * Alteramos as opções de análise para o código de exemplo dartbrasil.dev de
    usar `pedantic` para usar as regras recomendadas em [`lints`][].
  * Adicionamos o Docker como uma forma de [obter o Dart][].
  * Atualizamos a [página de evolução da linguagem][evolution] para refletir o Dart 2.13.

[tutorial de linha de comando]: /tutorials/server/cmdline
[página `dart run`]: /tools/dart-run
[`dart create`]: /tools/dart-create
[Como corrigir falhas de promoção de tipo]: /tools/non-promotion-reasons
[obter o Dart]: /get-dart
[tutorial do servidor HTTP]: /tutorials/server/httpserver
[`lints`]: {{site.pub-pkg}}/lints
[Números em Dart]: /resources/language/number-representation
[tutorial de streams]: /libraries/async/using-streams
[seção typedef]: /language/typedefs
[Usando APIs do Google]: /resources/google-apis
[Usando o Google Cloud]: /server/google-cloud
[Escrevendo páginas de pacotes]: /tools/pub/writing-package-pages


### Artigos adicionados ao blog do Dart {:.no_toc}

Publicamos os seguintes artigos no blog do Dart:

* [AngularDart, Flutter e a web: atualização de primavera][blog-5-12-21]
* [Anunciando suporte a Dart para GitHub Actions][blog-3-24-21]
* [Dart no Google Summer of Code 2021][blog-3-13-21]

[blog-5-12-21]: https://medium.com/dartlang/angulardart-flutter-and-the-web-spring-update-f7f5b8b10001
[blog-3-24-21]: https://medium.com/dartlang/announcing-dart-support-for-github-actions-3d892642104
[blog-3-13-21]: https://medium.com/dartlang/dart-in-google-summer-of-code-2021-e89eaf1d177a


## 3 de março de 2021: lançamento 2.12 {:#march-3-2021-2-12-release}

Esta seção lista as mudanças notáveis feitas de 2 de outubro de 2020,
até 3 de março de 2021.
Para detalhes sobre o lançamento 2.12, veja [Anunciando Dart 2.12][].


### Documentos atualizados ou adicionados em dartbrasil.dev {:.no_toc}

Além de correções de bugs e melhorias incrementais, fizemos as seguintes mudanças neste site:

* Atualizamos e desenvolvemos documentos sobre null safety. Notavelmente:
  * Fornecemos um [guia de migração][].
  * Adicionamos um [FAQ][ns-faq].
  * Criamos [Null safety não sólido][].
  * Simplificamos a [homepage do null safety][].
* Atualizamos o [Effective Dart][], atualizando o código para ser null safe e
  alterando as regras para refletir as novas orientações.
* Atualizamos o [tour da linguagem][], atualizando o código para ser null safe e
  adicionando informações sobre novos recursos, como
  [variáveis `late`][].
* Atualizamos a [página de evolução da linguagem][evolution]
  para adicionar informações sobre versionamento de linguagem
  e para refletir o Dart 2.12.
* Atualizamos o [tour da biblioteca][] e os [tutoriais][]
  para refletir o null safety sólido.
* Atualizamos as páginas em todo o site para usar [a ferramenta `dart`][]
  em vez de comandos obsoletos.
  Começamos a adicionar páginas para vários comandos `dart`, incluindo
  [`dart analyze`][], [`dart compile`][], [`dart fix`][],
  e [`dart format`][].
* Criamos uma página documentando a qualidade e o suporte dos [pacotes da equipe Dart][].
* Substituímos a página Plataformas por uma nova [página Visão geral][].
* Criamos esta página ("O que há de novo").

Também mudamos do Travis CI para o GitHub Actions e fizemos várias alterações no CSS para melhorar a legibilidade do site.

[Anunciando Dart 2.12]: https://medium.com/dartlang/announcing-dart-2-12-499a6e689c87
[guia de migração]: /null-safety/migration-guide
[ns-faq]: /null-safety/faq
[Null safety não sólido]: /null-safety/unsound-null-safety
[homepage do null safety]: /null-safety
[página Visão geral]: /overview
[Effective Dart]: /effective-dart
[tour da linguagem]: /language
[variáveis `late`]: /language/variables#late-variables
[tour da biblioteca]: /libraries
[tutoriais]: /tutorials
[a ferramenta `dart`]: /tools/dart-tool
[`dart analyze`]: /tools/dart-analyze
[`dart compile`]: /tools/dart-compile
[`dart fix`]: /tools/dart-fix
[`dart format`]: /tools/dart-format
[pacotes da equipe Dart]: /resources/dart-team-packages


### Artigos adicionados ao blog do Dart {:.no_toc}

Publicamos os seguintes artigos no blog do Dart:

* [Preparando o ecossistema Dart e Flutter para null safety][blog-2-16-21]
  anunciou a estabilidade da API null safety e
  convidou os desenvolvedores a publicar versões estáveis e null-safe de seus pacotes.
* [Dart e os benefícios de desempenho de tipos sólidos][blog-1-19-21]
  demonstrou como a solidez e o null safety permitem que os compiladores Dart
  gerem código mais rápido e menor.
* [Por que tipos anuláveis?][blog-12-7-20]
  expandiu uma discussão no subreddit /r/dart_lang,
  respondendo à pergunta "Por que não se livrar completamente do nulo?"
* [Anunciando o beta do null safety do Dart][blog-11-19-20]
  convidou os desenvolvedores a começar a planejar sua migração para null safety.

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
