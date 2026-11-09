---
ia-translate: true
title: "Anunciando o suporte ao Windows para Dart no Travis CI"
description: "Hoje, anunciamos que o Travis CI no Windows passa a oferecer suporte ao Dart SDK, para que você possa executar jobs de build e teste do Dart em todos os principais sistemas operacionais de desktop."
publishDate: 2019-04-15
author: mit-mit
image: images/1Zh0PvesZNUKCljlerYe4Sg.webp
category: announcements
layout: blog
---


Recentemente, o [Travis CI](https://travis-ci.com/) — um serviço de integração contínua (CI) para repositórios do GitHub — [anunciou](https://blog.travis-ci.com/2018-10-11-windows-early-release) o lançamento antecipado de suporte ao sistema operacional Windows. Hoje, anunciamos que o Travis CI no Windows passa a oferecer suporte ao Dart SDK, para que você possa executar jobs de build e teste do Dart nos três principais sistemas operacionais de desktop: Linux, Mac e Windows.

<DashImage src="images/1Zh0PvesZNUKCljlerYe4Sg.webp" alt="Announcement graphic for Windows support for Dart on Travis CI, showing successful build jobs for Linux, macOS, and Windows." />


### Configurando jobs do Travis CI para vários sistemas operacionais {:#configuring-travis-ci-jobs-for-multiple-operating-systems}

Se você já usa o Travis CI para compilar ou testar seu código Dart, pode executar seus jobs nos três sistemas operacionais com facilidade. Basta adicionar (ou estender) a seção `os:` no arquivo `.travis.yml` do seu repositório:

```
os:
- linux
- osx
- windows
```


Assim, sempre que o Travis CI rodar, você verá entradas para cada configuração de teste em cada um dos sistemas operacionais habilitados. Aqui está [um exemplo](https://travis-ci.org/grpc/grpc-dart/builds/517691491) do repositório [grpc-dart](https://github.com/grpc/grpc-dart), depois que [adicionamos o Windows](https://github.com/grpc/grpc-dart/commit/0cbc5401c82500bf20b89654c4adbde355dcc8d3) à matriz de testes:

<DashImage src="images/0wegLWjqUZkUfufxl.webp" alt="Travis CI test matrix running on Linux, macOS, and Windows." caption="Travis CI test matrix run on Linux, MacOS, and Windows" />


Como o suporte ao Windows no Travis CI ainda está em fase de lançamento antecipado, recomendamos que você consulte os [problemas conhecidos](https://travis-ci.community/t/current-known-issues-please-read-this-before-posting-a-new-topic/264) antes de adicionar o Windows aos seus jobs do Travis.

### Adicionando testes com Travis CI a um projeto {:#adding-travis-ci-test-support-to-a-project}

Se você ainda não usa o Travis CI para testar Dart, é muito fácil começar. O arquivo `.travis.yml` mais mínimo contém apenas uma linha:

```
language: dart
```


Essa configuração é equivalente a `pub run test`.

Liste quaisquer tarefas adicionais sob a tag `dart_task:`. Isso inclui executar análise estática e verificações de formatação de código (para detalhes completos, veja a [documentação do Travis](https://docs.travis-ci.com/user/languages/dart/)).

Veja como executar a análise estática, que verifica seu código em busca de erros de análise:

```
language: dart
dart_task:
- dartanalyzer
```


Veja como garantir que todos os arquivos Dart estão formatados corretamente:

```
language: dart
dart_task:
- dartfmt
```


Se você tiver um repositório mais complexo, com vários pacotes Dart, precisará de uma configuração um pouco mais detalhada. O comando `travis` da ferramenta [mono_repo](https://pub.dartlang.org/packages/mono_repo) é uma das possíveis soluções para criar essa configuração.

### Alternativas ao Travis CI {:#alternatives-to-travis-ci}

O Travis CI é um dos vários provedores populares de integração contínua. Outros com suporte ao Dart SDK incluem o [AppVeyor](https://www.appveyor.com/) ([exemplo](https://github.com/dart-lang/dartdoc/blob/master/appveyor.yml)) e o [Codeship](https://documentation.codeship.com/basic/languages-frameworks/dart/). Para apps [Flutter](https://flutter.dev/), as opções incluem o [NeverCode](https://developer.nevercode.io/docs/building-flutter-apps), o [CirrusCI](https://cirrus-ci.org/examples/#flutter) e o [Bitrise](https://devcenter.bitrise.io/getting-started/getting-started-with-flutter-apps/).

É isso por enquanto. Esperamos que você aproveite este novo suporte de CI para Dart.
