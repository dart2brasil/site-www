---
title: Dart testing
shortTitle: Testing
description: How to test Flutter, web, and VM applications.
---

Testes de software, uma parte importante do desenvolvimento de aplicativos,
ajudam a verificar que seu aplicativo está funcionando corretamente
antes de você lançá-lo. Este guia de testes Dart descreve
vários tipos de testes e indica onde você pode aprender
como testar seus aplicativos [Flutter]({{site.flutter}}),
[web](/web) e [scripts e aplicativos do lado do servidor](/server).

Você pode executar testes na linha de comando usando
o comando [`dart test`][] (ou, para aplicativos Flutter,
[`flutter test`][]).

[`dart test`]: /tools/dart-test
[`flutter test`]: {{site.flutter-docs}}/reference/flutter-cli

## Tipos de teste {:#kinds-of-testing}

A documentação de testes Dart se concentra em três tipos de testes,
dentre os [vários tipos de testes](https://en.wikipedia.org/wiki/Software_testing)
com os quais você pode estar familiarizado: unidade, componente e
ponta a ponta (uma forma de teste de integração).
A terminologia de teste varia, mas estes são os termos e conceitos
que você provavelmente encontrará ao usar as tecnologias Dart:

* Testes de _unidade_ se concentram em verificar a menor parte
  de software testável, como uma função, método ou classe.
  Seus conjuntos de testes devem ter mais testes de unidade do que
  outros tipos de testes.

* Testes de _componente_ (chamados de testes de _widget_ no Flutter)
  verificam se um componente (que geralmente consiste em várias classes)
  se comporta conforme o esperado. Um teste de componente geralmente
  requer o uso de objetos *mock* que podem imitar ações do usuário,
  eventos, executar layout e instanciar componentes filhos.

* Testes de _integração_ e _ponta a ponta_ verificam o comportamento
  de um aplicativo inteiro ou de uma grande parte de um aplicativo.
  Um teste de integração geralmente é executado em um dispositivo
  simulado ou real ou em um navegador (para a web) e consiste em duas
  partes: o próprio aplicativo e o aplicativo de teste que
  coloca o aplicativo em funcionamento. Um teste de integração
  geralmente mede o desempenho, portanto, o aplicativo de teste
  geralmente é executado em um dispositivo ou sistema operacional
  diferente do aplicativo que está sendo testado.

## Bibliotecas geralmente úteis {:#generally-useful-libraries}

Embora seus testes dependam parcialmente da plataforma para a qual
seu código se destina - Flutter, web ou servidor, por exemplo -
os seguintes pacotes são úteis em todas as plataformas Dart:

* [package:test]({{site.pub-pkg}}/test)<br>
  Fornece uma maneira padrão de escrever testes em Dart.
  Você pode usar o pacote de teste para:
    * Escrever testes individuais ou grupos de testes.
    * Usar a anotação `@TestOn` para restringir os testes
      a serem executados em ambientes específicos.
    * Escrever testes assíncronos da mesma forma que você
      escreveria testes síncronos.
    * Marcar testes usando a anotação `@Tag`. Por exemplo,
      definir uma tag para criar uma configuração
      personalizada para alguns testes ou para identificar
      alguns testes que precisam de mais tempo para serem concluídos.
    * Criar um arquivo `dart_test.yaml` para configurar
      testes marcados em vários arquivos ou em um pacote inteiro.

* [package:mockito]({{site.pub-pkg}}/mockito)<br>
  Fornece uma maneira de criar
  [objetos *mock*](https://en.wikipedia.org/wiki/Mock_object)
  facilmente configurados para uso em cenários fixos e para
  verificar se o sistema em teste interage com o objeto *mock*
  das maneiras esperadas. Para um exemplo que usa
  package:test e package:mockito, veja a
  [biblioteca da API da Estação Espacial Internacional e seus testes
  de unidade]({{site.repo.dart.org}}/mockito/tree/master/example/iss)
  no [pacote mockito]({{site.repo.dart.org}}/mockito).

## Testes Flutter {:#flutter-testing}

Use os seguintes recursos para aprender mais sobre
como testar aplicativos Flutter:

* [Testing Flutter Apps]({{site.flutter-docs}}/testing)<br>
  Como realizar testes de unidade, *widget* ou integração
  em um aplicativo Flutter.
* [flutter_test]({{site.flutter-api}}/flutter/flutter_test/flutter_test-library.html)<br>
  Uma biblioteca de testes para Flutter construída
  sobre o package:test.
* [flutter_driver]({{site.flutter-api}}/flutter/flutter_driver/flutter_driver-library.html)<br>
  Uma biblioteca de testes para testar aplicativos Flutter
  em dispositivos reais e emuladores (em um processo separado).
* [flutter_gallery](https://github.com/flutter/gallery)<br>
  Código-fonte e testes para o exemplo da galeria do Flutter.
* [flutter/dev/manual_tests](https://github.com/flutter/flutter/tree/master/dev/manual_tests)<br>
  Muitos exemplos de testes no Flutter SDK.

## Outras ferramentas e recursos {:#other-tools-and-resources}

Você também pode achar os seguintes recursos úteis
para desenvolver e depurar aplicativos Dart.

### IDE {:#ide}

Quando se trata de depuração, sua primeira linha de defesa
é sua IDE. Existem plugins Dart para muitas
[IDEs comumente usadas](/tools#editors).

### Dart DevTools {:#dart-devtools}

O Dart DevTools é um conjunto de ferramentas de
desempenho para Dart e Flutter. Para detalhes,
consulte a [documentação do Dart
DevTools.](/tools/dart-devtools)

### Integração contínua {:#continuous-integration}

Considere usar a integração contínua (CI) para construir
seu projeto e executar seus testes após cada *commit*.
Dois serviços CI para GitHub são
[GitHub Actions](https://github.com/features/actions) e
[AppVeyor](https://www.appveyor.com/).

Saiba mais sobre o GitHub Actions:

* Many packages provided by the Dart team use GitHub Actions.
  For an example, see
  [`markdown.yaml`][markdown-ci] in the markdown package's repo.
  To see how that repo migrated from Travis CI to GitHub Actions,
  look at [PR #353]({{site.repo.dart.org}}/markdown/pull/353).

[markdown-ci]: {{site.repo.dart.org}}/tools/blob/main/.github/workflows/markdown.yaml
