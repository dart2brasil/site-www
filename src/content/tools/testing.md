---
ia-translate: true
title: Testes em Dart
shortTitle: Testes
description: Como testar aplicativos Flutter, web e VM.
---

Testes de software, uma parte importante do desenvolvimento de aplicativos, ajudam a verificar se
seu aplicativo está funcionando corretamente antes de você lançá-lo.
Este guia de testes em Dart descreve vários tipos de testes e aponta
para onde você pode aprender a testar seus
aplicativos [Flutter]({{site.flutter}}), [web](/web)
e [aplicativos e scripts do lado do servidor](/server).

Você pode executar testes na linha de comando
usando o comando [`dart test`][]
(ou, para aplicativos Flutter, [`flutter test`][]).

[`dart test`]: /tools/dart-test
[`flutter test`]: {{site.flutter-docs}}/reference/flutter-cli

## Tipos de testes {:#kinds-of-testing}

A documentação de testes em Dart se concentra em três tipos de testes, entre os
[muitos tipos de testes](https://en.wikipedia.org/wiki/Software_testing)
que você pode conhecer: unitários, de componente e end-to-end
(uma forma de teste de integração). A terminologia de testes varia,
mas estes são os termos e conceitos que você provavelmente encontrará
ao usar tecnologias Dart:

* Testes _unitários_ focam em verificar a menor parte testável
  de um software, como uma função, um método ou uma classe. Seus conjuntos de testes
  devem ter mais testes unitários do que outros tipos de testes.

* Testes de _componente_ (chamados de testes de _widget_ no Flutter)
  verificam se um componente (que geralmente consiste em várias classes)
  se comporta como esperado.
  Um teste de componente geralmente exige o uso de mock objects
  que podem imitar ações do usuário e eventos, executar o layout
  e instanciar componentes filhos.

* Testes de _integração_ e _end-to-end_ verificam o comportamento de
  um aplicativo inteiro, ou de uma grande parte dele. Um teste de integração
  geralmente é executado em um dispositivo simulado ou real
  ou em um navegador (para a web) e consiste em duas partes:
  o próprio aplicativo e o aplicativo de teste que o submete
  a um conjunto de provas. Um teste de integração frequentemente mede desempenho,
  então o aplicativo de teste geralmente é executado em um dispositivo ou SO diferente
  do aplicativo testado.

## Bibliotecas geralmente úteis {:#generally-useful-libraries}

Embora seus testes dependam, em parte, da plataforma para a qual seu código se destina
(Flutter, web ou lado do servidor, por exemplo), os
pacotes a seguir são úteis em todas as plataformas Dart:

* [package:test]({{site.pub-pkg}}/test)<br>
  Fornece uma maneira padrão de escrever testes em Dart. Você pode usar o pacote test
  para:
    * Escrever testes isolados ou grupos de testes.
    * Usar a anotação `@TestOn` para restringir testes a
      ambientes específicos.
    * Escrever testes assíncronos da mesma forma que escreveria testes
      síncronos.
    * Marcar testes com a anotação `@Tag`. Por exemplo, defina uma tag para
      criar uma configuração personalizada para alguns testes, ou para identificar testes
      que precisam de mais tempo para serem concluídos.
    * Criar um arquivo `dart_test.yaml` para configurar testes marcados em
      vários arquivos ou em um pacote inteiro.


* [package:mockito]({{site.pub-pkg}}/mockito)<br>
  Fornece uma forma de criar
  [mock objects,](https://en.wikipedia.org/wiki/Mock_object)
  facilmente configurados para uso em cenários fixos, e de verificar
  se o sistema sob teste interage com o mock object das
  maneiras esperadas.
  Para um exemplo que usa package:test e package:mockito juntos,
  veja a [biblioteca da API da Estação Espacial Internacional e seus
  testes unitários]({{site.repo.dart.org}}/mockito/tree/master/example/iss)
  no [pacote mockito]({{site.repo.dart.org}}/mockito).

## Testes Flutter {:#flutter-testing}

Use os recursos a seguir para saber mais sobre testes de aplicativos Flutter:

* [Testando aplicativos Flutter]({{site.flutter-docs}}/testing)<br>
  Como executar testes unitários, de widget ou de integração em um aplicativo Flutter.
* [flutter_test]({{site.flutter-api}}/flutter/flutter_test/flutter_test-library.html)<br>
  Uma biblioteca de testes para Flutter, construída sobre o package:test.
* [flutter_driver]({{site.flutter-api}}/flutter/flutter_driver/flutter_driver-library.html)<br>
  Uma biblioteca de testes para aplicativos Flutter em dispositivos reais e
  emuladores (em um processo separado).
* [flutter_gallery](https://github.com/flutter/gallery)<br>
  Código-fonte e testes do exemplo Flutter gallery.
* [flutter/dev/manual_tests](https://github.com/flutter/flutter/tree/master/dev/manual_tests)<br>
  Muitos exemplos de testes no Flutter SDK.

## Outras ferramentas e recursos {:#other-tools-and-resources}

Você também pode achar os recursos a seguir úteis para desenvolver e
depurar aplicativos Dart.

### IDE {:#ide}

Na hora de depurar, sua primeira linha de defesa é a sua IDE.
Existem plugins Dart para muitas [IDEs comumente usadas](/tools#editors).

### Dart DevTools {:#dart-devtools}

O Dart DevTools é um conjunto de ferramentas de desempenho para Dart e Flutter.
Para mais detalhes, veja a
[documentação do Dart DevTools.](/tools/dart-devtools)


### Integração contínua {:#continuous-integration}

Considere usar integração contínua (CI) para compilar seu projeto
e executar seus testes após cada commit. Dois serviços de CI para GitHub são
[GitHub Actions](https://github.com/features/actions) e
[AppVeyor](https://www.appveyor.com/).

Saiba mais sobre o GitHub Actions:

* Muitos pacotes mantidos pela equipe Dart usam GitHub Actions.
  Como exemplo, veja
  [`markdown.yaml`][markdown-ci] no repositório do pacote markdown.
  Para ver como esse repositório migrou do Travis CI para o GitHub Actions,
  veja o [PR #353]({{site.repo.dart.org}}/markdown/pull/353).

[markdown-ci]: {{site.repo.dart.org}}/tools/blob/main/.github/workflows/markdown.yaml
