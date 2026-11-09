---
ia-translate: true
title: "Anunciando o suporte do Dart ao GitHub Actions"
description: "O GitHub Actions é uma opção popular de integração contínua (CI) para repositórios do GitHub. Hoje, anunciamos uma action oficial setup-dart…"
publishDate: 2021-03-24
author: mit-mit
image: images/15E8_aBC9TBl9oBUwN3jAJw.webp
category: announcements
layout: blog
---


[GitHub Actions](https://github.com/features/actions) é uma opção popular de integração contínua (CI) para repositórios do GitHub. Hoje, anunciamos uma [**action setup-dart** oficial](https://github.com/marketplace/actions/setup-dart-sdk) mantida pela equipe do Dart. Essa action permite baixar, instalar e configurar o SDK do Dart, para que você possa executar jobs de build e de testes do Dart com facilidade no GitHub Actions.

Se você é autor de um pacote Dart para o pub.dev, incentivamos a ativar testes de CI com o GitHub Actions no seu repositório, para dar a você (e aos usuários do pacote) um sinal sobre a saúde do seu pacote. Os jobs de CI no GitHub Actions são [gratuitos para repositórios públicos](https://github.com/pricing).

<DashImage src="images/15E8_aBC9TBl9oBUwN3jAJw.webp" alt="Página do GitHub Marketplace para a action Setup Dart SDK." />


## Apresentando o setup-dart {:#introducing-setup-dart}

Se você tem um repositório do GitHub com um app Dart, pode ativar testes de CI com o GitHub Actions e a action setup-dart com apenas alguns cliques. Aqui temos um novo repositório do GitHub chamado [myapp](https://github.com/mit-mit/myapp), que contém o ponto de partida de um pequeno aplicativo gerado com a ferramenta do Dart [ao executar](https://dart.dev/tutorials/server/get-started#3-create-a-small-app)
`dart create --template console-full myapp`.

Em seguida, abra a interface web do GitHub e clique na aba **Actions**:

<DashImage src="images/0IA24lXOJ0Zy1uwXF.webp" alt="A aba Actions na interface web do GitHub." />


Logo abaixo da introdução, você deve ver uma seção sugerindo um workflow para um repositório Dart:

<DashImage src="images/0tz1_DLk4qI1MpI4z.webp" alt="Um workflow Dart sugerido na interface do GitHub Actions." />


Clique no botão **Set up this workflow** e você será levado à interface do GitHub para adicionar um novo arquivo `.github/workflow/dart.yml`. Esse é um arquivo YAML que define o workflow do GitHub Actions a ser executado no repositório. Vamos revisar cada um dos componentes sugeridos pelo arquivo de [workflow](https://github.com/dart-lang/characters/blob/master/.github/workflows/test-package.yml) modelo.

Primeiro, definimos o nome do workflow, que será exibido na interface de administração de Actions:

```
name: Dart
```


Em seguida, definimos quando o workflow deve ser executado (o [evento](https://docs.github.com/en/actions/learn-github-actions/introduction-to-github-actions) que dispara o workflow). Aqui, o fluxo está configurado para rodar sempre que houver um push para a branch main, ou um PR para a branch main. Pessoalmente, descobri que, quando tenho problemas para fazer um workflow rodar, geralmente é porque escrevi errado o nome da branch.

```
on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]
```


Em seguida, vem uma lista de jobs, cada um com um nome (aqui `test`). Cada job tem sua própria definição, composta por onde o job será executado (este job roda no Ubuntu Linux) e quais passos seguir:

```
jobs:
  test:
    runs-on: ubuntu-latest
    steps:
```


Quanto ao teste em si, primeiro fazemos o checkout do repositório em `test` e, depois, executamos a nova action setup-dart. Ela baixa e instala o SDK do Dart e, em seguida, adiciona a CLI `dart` e o diretório global do pub ao path. Aqui não especificamos qual SDK do Dart instalar, então a action vai instalar o SDK mais recente do canal estável.

```
      - uses: actions/checkout@v2
      - uses: dart-lang/setup-dart@v1
```


Podemos então executar os testes desejados, como formatação, análise e testes unitários:

```
      - name: Install dependencies
        run: dart pub get

      - name: Verify formatting
        run: dart format — output=none — set-exit-if-changed .

      - name: Analyze project source
        run: dart analyze

      - name: Run tests
        run: dart test
```


Para um exemplo completo, veja nosso [workflow para o package:characters](https://github.com/dart-lang/characters/blob/master/.github/workflows/test-package.yml).

## Especificando a versão do SDK {:#specifying-sdk-version}

A action setup-dart permite especificar a versão do Dart que você deseja instalar. Isso pode ter duas formas:

* Uma versão específica, por exemplo `2.9.0` ou `2.12.0–259.12.beta`

* A versão mais recente de um [canal de lançamento](https://dart.dev/get-dart#release-channels), por exemplo `stable` ou `beta`

Para especificar uma versão, use o argumento `sdk`, diretamente ou como parte de uma [matriz de testes](https://docs.github.com/en/actions/learn-github-actions/managing-complex-workflows#using-a-build-matrix):

```
matrix:
    os: [ubuntu-latest, macos-latest, windows-latest]
    sdk: [2.10.0, stable, beta]
    runs-on: ${{ matrix.os }}
    steps:
      - uses: actions/checkout@v2
      - uses: dart-lang/setup-dart@v1.0
        with:
          sdk: ${{ matrix.sdk }}
```


O resultado dessa matriz são nove jobs executados separadamente:

<DashImage src="images/0Wm1ERed37w-oyoDq.webp" alt="Nove jobs de teste executados separadamente, resultantes da matriz do GitHub Actions." />


Agora que tudo está passando, você pode querer [adicionar um badge de status](https://docs.github.com/en/actions/managing-workflow-runs/adding-a-workflow-status-badge) ao seu arquivo `README.md` para exibir o status dos testes.

## Soluções alternativas {:#alternative-solutions}

O GitHub Actions é uma das várias soluções populares de integração contínua. Outras com suporte ao SDK do Dart incluem [Travis](https://docs.travis-ci.com/user/languages/dart/), [AppVeyor](https://www.appveyor.com/) e [CodeShip](https://documentation.codeship.com/basic/languages-frameworks/dart/). Para testar apps [Flutter](https://flutter.dev/), as opções incluem o [Codemagic da Nevercode](https://developer.nevercode.io/docs/building-flutter-apps), o [Cirrus CI](https://cirrus-ci.org/examples/#flutter) e o [Bitrise](https://devcenter.bitrise.io/getting-started/getting-started-with-flutter-apps/). O GitHub Actions para apps Flutter é viabilizado por actions criadas pela comunidade, como o [flutter-action](https://github.com/marketplace/actions/flutter-action).

É isso por enquanto. Esperamos que você goste [deste novo suporte de CI para o Dart](https://github.com/marketplace/actions/setup-dart-sdk) e, se tiver algum feedback ou problema com o setup-dart, conte para a gente no [gerenciador de issues](https://github.com/dart-lang/setup-dart/issues).
