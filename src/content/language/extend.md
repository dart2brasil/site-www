---
ia-translate: true
title: Estender uma classe
description: Aprenda como criar subclasses a partir de uma superclasse.
prevpage:
  url: /language/methods
  title: Métodos
nextpage:
  url: /language/mixins
  title: Mixins
---

Use `extends` para criar uma subclasse e `super` para se referir à
superclasse:

<?code-excerpt "misc/lib/language_tour/classes/extends.dart (smart-tv)" replace="/extends|super/[!$&!]/g"?>
```dart
class Television {
  void turnOn() {
    _illuminateDisplay();
    _activateIrSensor();
  }
  // ···
}

class SmartTelevision [!extends!] Television {
  void turnOn() {
    [!super!].turnOn();
    _bootNetworkInterface();
    _initializeMemory();
    _upgradeApps();
  }
  // ···
}
```

Para outro uso de `extends`, veja a discussão sobre
[tipos parametrizados][] na página de Generics.

## Sobrescrevendo membros {:#overriding-members}

Subclasses podem sobrescrever métodos de instância (incluindo [operadores][]),
getters e setters.
Você pode usar a anotação `@override` para indicar que você está
intencionalmente sobrescrevendo um membro:

<?code-excerpt "misc/lib/language_tour/metadata/television.dart (override)" replace="/@override/[!$&!]/g"?>
```dart
class Television {
  // ···
  set contrast(int value) {...}
}

class SmartTelevision extends Television {
  [!@override!]
  set contrast(num value) {...}
  // ···
}
```

Uma declaração de método de sobrescrita deve corresponder
ao método (ou métodos) que ele sobrescreve de várias maneiras:

* O tipo de retorno deve ser o mesmo tipo que (ou um subtipo de)
  o tipo de retorno do método sobrescrito.
* Os tipos de parâmetro devem ser o mesmo tipo que (ou um supertipo de)
  os tipos de parâmetro do método sobrescrito.
  No exemplo anterior, o setter `contrast` de `SmartTelevision`
  altera o tipo de parâmetro de `int` para um supertipo, `num`.
* Se o método sobrescrito aceitar _n_ parâmetros posicionais,
  então o método de sobrescrita também deve aceitar _n_ parâmetros posicionais.
* Um [método genérico][] não pode sobrescrever um não genérico,
  e um método não genérico não pode sobrescrever um genérico.

Às vezes, você pode querer restringir o tipo de
um parâmetro de método ou uma variável de instância.
Isso viola as regras normais, e
é semelhante a um downcast (conversão para subtipo) pois pode causar um erro de tipo em tempo de execução.
Ainda assim, restringir o tipo é possível
se o código puder garantir que um erro de tipo não ocorrerá.
Nesse caso, você pode usar a
[`covariant` keyword (palavra-chave covariant)](/deprecated/sound-problems#the-covariant-keyword)
em uma declaração de parâmetro.
Para detalhes, veja a
[especificação da linguagem Dart][].

:::warning
Se você sobrescrever `==`, você também deve sobrescrever o getter `hashCode` de Object.
Para um exemplo de sobrescrita de `==` e `hashCode`, confira
[Implementando chaves de mapa](/libraries/dart-core#implementing-map-keys).
:::

## noSuchMethod() {:#nosuchmethod}

Para detectar ou reagir sempre que o código tentar usar um método inexistente ou
variável de instância, você pode sobrescrever `noSuchMethod()`:

<?code-excerpt "misc/lib/language_tour/classes/no_such_method.dart (no-such-method-impl)" replace="/noSuchMethod(?!,)/[!$&!]/g"?>
```dart
class A {
  // A menos que você sobrescreva noSuchMethod, usar um
  // membro inexistente resulta em um NoSuchMethodError.
  @override
  void [!noSuchMethod!](Invocation invocation) {
    print('Você tentou usar um membro inexistente: '
        '${invocation.memberName}');
  }
}
```

Você **não pode invocar** um método não implementado a menos que
**uma** das seguintes afirmações seja verdadeira:

* O receptor tenha o tipo estático `dynamic`.

* O receptor tem um tipo estático que
define o método não implementado (abstrato está OK),
e o tipo dinâmico do receptor tem uma implementação de `noSuchMethod()`
que é diferente daquela na classe `Object`.

Para mais informações, veja a informal
[especificação de encaminhamento noSuchMethod.]({{site.repo.dart.lang}}/blob/main/archive/feature-specifications/nosuchmethod-forwarding.md)

[parameterized types]: /language/generics#restricting-the-parameterized-type
[operators]: /language/methods#operators
[generic method]: /language/generics#using-generic-methods
[Dart language specification]: /resources/language/spec
