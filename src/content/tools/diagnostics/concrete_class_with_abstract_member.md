---
title: concrete_class_with_abstract_member
description: >-
  Details about the concrete_class_with_abstract_member
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_'{0}' must have a method body because '{1}' isn't abstract._

## Descrição

O analisador produz este diagnóstico quando a member of a concrete class is
found that doesn't have a concrete implementation. Concrete classes aren't
allowed to contain abstract members.

## Exemplo

O código a seguir produz este diagnóstico porque `m` is an abstract
method but `C` isn't an abstract class:

```dart
class C {
  [!void m();!]
}
```

## Correções comuns

If it's valid to create instances of the class, provide an implementation
for the member:

```dart
class C {
  void m() {}
}
```

If it isn't valid to create instances of the class, mark the class as being
abstract:

```dart
abstract class C {
  void m();
}
```
