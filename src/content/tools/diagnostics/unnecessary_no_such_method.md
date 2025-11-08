---
ia-translate: true
title: unnecessary_no_such_method
description: >-
  Detalhes sobre o diagnóstico unnecessary_no_such_method
  produzido pelo analisador Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_Declaração 'noSuchMethod' desnecessária._

## Description

O analisador produz este diagnóstico quando há uma declaração de
`noSuchMethod`, a única coisa que a declaração faz é invocar a
declaração sobrescrita, e a declaração sobrescrita não é a
declaração em `Object`.

Sobrescrever a implementação de `noSuchMethod` do `Object` (não importa o que
a implementação faça) sinaliza ao analisador que ele não deve marcar nenhum
método abstrato herdado que não está implementado nessa classe. Isso
funciona mesmo se a implementação que sobrescreve é herdada de uma superclasse,
então não há valor em declará-la novamente em uma subclasse.

## Example

O código a seguir produz este diagnóstico porque a declaração de
`noSuchMethod` em `A` torna a declaração de `noSuchMethod` em `B`
desnecessária:

```dart
class A {
  @override
  dynamic noSuchMethod(x) => super.noSuchMethod(x);
}
class B extends A {
  @override
  dynamic [!noSuchMethod!](y) {
    return super.noSuchMethod(y);
  }
}
```

## Common fixes

Remova a declaração desnecessária:

```dart
class A {
  @override
  dynamic noSuchMethod(x) => super.noSuchMethod(x);
}
class B extends A {}
```
