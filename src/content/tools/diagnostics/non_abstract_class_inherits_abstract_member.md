---
ia-translate: true
title: non_abstract_class_inherits_abstract_member
description: >-
  Detalhes sobre o diagnóstico non_abstract_class_inherits_abstract_member
  produzido pelo analisador do Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_Missing concrete implementation of '{0}'._

_Missing concrete implementations of '{0}' and '{1}'._

_Missing concrete implementations of '{0}', '{1}', '{2}', '{3}', and {4} more._

_Missing concrete implementations of '{0}', '{1}', '{2}', and '{3}'._

_Missing concrete implementations of '{0}', '{1}', and '{2}'._

## Description

O analisador produz este diagnóstico quando uma classe concreta herda um ou
mais membros abstract, e não fornece ou herda uma implementação para
pelo menos um desses membros abstract.

## Example

O código a seguir produz este diagnóstico porque a classe `B` não possui
uma implementação concreta de `m`:

```dart
abstract class A {
  void m();
}

class [!B!] extends A {}
```

## Common fixes

Se a subclasse pode fornecer uma implementação concreta para alguns ou todos os
membros abstract herdados, então adicione as implementações concretas:

```dart
abstract class A {
  void m();
}

class B extends A {
  void m() {}
}
```

Se há um mixin que fornece uma implementação dos métodos
herdados, então aplique o mixin à subclasse:

```dart
abstract class A {
  void m();
}

class B extends A with M {}

mixin M {
  void m() {}
}
```

Se a subclasse não pode fornecer uma implementação concreta para todos os
membros abstract herdados, então marque a subclasse como sendo abstract:

```dart
abstract class A {
  void m();
}

abstract class B extends A {}
```
