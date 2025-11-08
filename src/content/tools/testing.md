---
title: Dart testing
shortTitle: Testing
description: How to test Flutter, web, and VM applications.
ia-translate: true
---

Testes de software, uma parte importante do desenvolvimento de aplicativos, ajudam a verificar se
seu aplicativo está funcionando corretamente antes de você lançá-lo.
Este guia de testes Dart descreve vários tipos de testes e aponta
para onde você pode aprender como testar seus
aplicativos [Flutter]({{site.flutter}}), [web](/web),
e [aplicativos e scripts do lado do servidor](/server).

Você pode executar testes na linha de comando
usando o comando [`dart test`][]
(ou, para aplicativos Flutter, [`flutter test`][]).

[`dart test`]: /tools/dart-test
[`flutter test`]: {{site.flutter-docs}}/reference/flutter-cli

## Tipos de testes

A documentação de testes Dart se concentra em três tipos de testes, dos
[muitos tipos de testes](https://en.wikipedia.org/wiki/Software_testing)
com os quais você pode estar familiarizado: unitário, de componente e end-to-end
(uma forma de teste de integração). A terminologia de testes varia,
mas estes são os termos e conceitos que você provavelmente encontrará
ao usar tecnologias Dart:

* Testes _unitários_ focam em verificar a menor parte testável
  de software, como uma função, método ou classe. Seus conjuntos de testes
  devem ter mais testes unitários do que outros tipos de testes.

* Testes de _componente_ (chamados de testes de _widget_ no Flutter)
  verificam se um componente (que geralmente consiste em várias classes)
  se comporta conforme esperado.
  Um teste de componente geralmente requer o uso de mock objects
  que podem imitar ações do usuário, eventos, executar layout
  e instanciar componentes filhos.

* Testes de _integração_ e _end-to-end_ verificam o comportamento de
  um aplicativo inteiro, ou uma grande parte de um aplicativo. Um teste de integração
  geralmente é executado em um dispositivo simulado ou real
  ou em um navegador (para a web) e consiste em duas partes:
  o próprio aplicativo e o aplicativo de teste que coloca
  o aplicativo à prova. Um teste de integração geralmente mede desempenho,
  então o aplicativo de teste geralmente é executado em um dispositivo ou SO diferente
  do aplicativo sendo testado.

## Bibliotecas geralmente úteis

Embora seus testes dependam parcialmente da plataforma para a qual seu código se destina—
Flutter, web ou lado do servidor, por exemplo—os
seguintes pacotes são úteis em todas as plataformas Dart:

* [package:test]({{site.pub-pkg}}/test)<br>
  Fornece uma maneira padrão de escrever testes em Dart. Você pode usar o pacote test
  para:
    * Escrever testes únicos ou grupos de testes.
    * Usar a anotação `@TestOn` para restringir testes a serem executados em
      ambientes específicos.
    * Escrever testes assíncronos da mesma forma que você escreveria testes
      síncronos.
    * Marcar testes usando a anotação `@Tag`. Por exemplo, defina uma tag para
      criar uma configuração personalizada para alguns testes, ou para identificar alguns testes
      como precisando de mais tempo para serem concluídos.
    * Criar um arquivo `dart_test.yaml` para configurar testes marcados em
      vários arquivos ou em um pacote inteiro.


* [package:mockito]({{site.pub-pkg}}/mockito)<br>
  Fornece uma maneira de criar
  [mock objects,](https://en.wikipedia.org/wiki/Mock_object)
  facilmente configurados para uso em cenários fixos, e para verificar
  se o sistema em teste interage com o mock object de
  maneiras esperadas.
  Para um exemplo que usa tanto package:test quanto package:mockito,
  veja a [biblioteca API da Estação Espacial Internacional e seus testes
  unitários]({{site.repo.dart.org}}/mockito/tree/master/example/iss)
  no [pacote mockito]({{site.repo.dart.org}}/mockito).

## Testes Flutter

Use os seguintes recursos para aprender mais sobre testes de aplicativos Flutter:

* [Testing Flutter Apps]({{site.flutter-docs}}/testing)<br>
  Como executar testes unitários, de widget ou de integração em um aplicativo Flutter.
* [flutter_test]({{site.flutter-api}}/flutter/flutter_test/flutter_test-library.html)<br>
  Uma biblioteca de testes para Flutter construída sobre package:test.
* [flutter_driver]({{site.flutter-api}}/flutter/flutter_driver/flutter_driver-library.html)<br>
  Uma biblioteca de testes para testar aplicativos Flutter em dispositivos reais e
  emuladores (em um processo separado).
* [flutter_gallery](https://github.com/flutter/gallery)<br>
  Código-fonte e testes para o exemplo da galeria Flutter.
* [flutter/dev/manual_tests](https://github.com/flutter/flutter/tree/master/dev/manual_tests)<br>
  Muitos exemplos de testes no Flutter SDK.

## Outras ferramentas e recursos

Você também pode achar os seguintes recursos úteis para desenvolver e
depurar aplicativos Dart.

### IDE

Quando se trata de depuração, sua primeira linha de defesa é seu IDE.
Plugins Dart existem para muitas [IDEs comumente usadas](/tools#editors).

### Dart DevTools

Dart DevTools é um conjunto de ferramentas de desempenho para Dart e Flutter.
Para detalhes, veja a
[documentação do Dart DevTools.](/tools/dart-devtools)


### Integração contínua

Considere usar integração contínua (CI) para compilar seu projeto
e executar seus testes após cada commit. Dois serviços de CI para GitHub são
[GitHub Actions](https://github.com/features/actions) e
[AppVeyor](https://www.appveyor.com/).

Saiba mais sobre GitHub Actions:

* Muitos pacotes fornecidos pela equipe Dart usam GitHub Actions.
  Para um exemplo, veja
  [`markdown.yaml`][markdown-ci] no repositório do pacote markdown.
  Para ver como esse repositório migrou do Travis CI para GitHub Actions,
  veja o [PR #353]({{site.repo.dart.org}}/markdown/pull/353).

[markdown-ci]: {{site.repo.dart.org}}/tools/blob/main/.github/workflows/markdown.yaml
