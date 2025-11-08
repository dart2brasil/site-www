---
ia-translate: true
title: Estender uma classe
description: Aprenda como criar subclasses a partir de uma superclasse.
prevpage:
  url: /language/methods
  title: Methods
nextpage:
  url: /language/mixins
  title: Mixins
---

Use `extends` para criar uma subclasse, e `super` para referenciar a
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
[tipos parametrizados][parameterized types] na página de Generics.

## Sobrescrevendo membros

Subclasses podem sobrescrever métodos de instância (incluindo [operadores][operators]),
getters e setters.
Você pode usar a annotation `@override` para indicar que você está
intencionalmente sobrescrevendo um membro:

<?code-excerpt "misc/lib/language_tour/metadata/television.dart (override)" replace="/@override/[!$&!]/g"?>
```dart
class Television {
  // ···
  set contrast(int value) {
    // ···
  }
}

class SmartTelevision extends Television {
  [!@override!]
  set contrast(num value) {
    // ···
  }
  // ···
}
```

Uma declaração de método sobrescrito deve corresponder
ao método (ou métodos) que ele sobrescreve de várias maneiras:

* O tipo de retorno deve ser do mesmo tipo (ou um subtipo do)
  tipo de retorno do método sobrescrito.
* Os tipos de parâmetro devem ser do mesmo tipo (ou um supertipo dos)
  tipos de parâmetro do método sobrescrito.
  No exemplo anterior, o setter `contrast` de `SmartTelevision`
  muda o tipo de parâmetro de `int` para um supertipo, `num`.
* Se o método sobrescrito aceita _n_ parâmetros posicionais,
  então o método que sobrescreve também deve aceitar _n_ parâmetros posicionais.
* Um [método genérico][generic method] não pode sobrescrever um não-genérico,
  e um método não-genérico não pode sobrescrever um genérico.

Às vezes você pode querer restringir o tipo de
um parâmetro de método ou uma variável de instância.
Isso viola as regras normais, e
é similar a um downcast no sentido de que pode causar um erro de tipo em tempo de execução.
Ainda assim, restringir o tipo é possível
se o código pode garantir que um erro de tipo não ocorrerá.
Neste caso, você pode usar a
[keyword `covariant`](/language/type-system#covariant-keyword)
em uma declaração de parâmetro.
Para detalhes, veja a
[especificação da linguagem Dart][Dart language specification].

:::warning
Se você sobrescrever `==`, você também deve sobrescrever o getter `hashCode` de Object.
Para um exemplo de sobrescrita de `==` e `hashCode`, confira
[Implementando chaves de map](/libraries/dart-core#implementing-map-keys).
:::

## noSuchMethod()

Para detectar ou reagir sempre que o código tenta usar um método ou
variável de instância inexistente, você pode sobrescrever `noSuchMethod()`:

<?code-excerpt "misc/lib/language_tour/classes/no_such_method.dart (no-such-method-impl)" replace="/noSuchMethod(?!,)/[!$&!]/g"?>
```dart
class A {
  // Unless you override noSuchMethod, using a
  // non-existent member results in a NoSuchMethodError.
  @override
  void [!noSuchMethod!](Invocation invocation) {
    print(
      'You tried to use a non-existent member: '
      '${invocation.memberName}',
    );
  }
}
```

Você **não pode invocar** um método não implementado a menos que
**uma** das seguintes condições seja verdadeira:

* O receptor tem o tipo estático `dynamic`.

* O receptor tem um tipo estático que
define o método não implementado (abstract é aceitável),
e o tipo dinâmico do receptor tem uma implementação de `noSuchMethod()`
que é diferente daquela na classe `Object`.

Para mais informações, veja a
[especificação informal de encaminhamento noSuchMethod.]({{site.repo.dart.lang}}/blob/main/archive/feature-specifications/nosuchmethod-forwarding.md)

[parameterized types]: /language/generics#restricting-the-parameterized-type
[operators]: /language/methods#operators
[generic method]: /language/generics#using-generic-methods
[Dart language specification]: /resources/language/spec
