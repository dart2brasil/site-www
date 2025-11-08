---
title: tearoff_of_generative_constructor_of_abstract_class
description: >-
  Details about the tearoff_of_generative_constructor_of_abstract_class
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_A generative constructor of an abstract class can't be torn off._

## Descrição

O analisador produz este diagnóstico quando a generative constructor from an
abstract class is being torn off. This isn't allowed because it isn't valid
to create an instance of an abstract class, which means that there isn't
any valid use for the torn off constructor.

## Exemplo

O código a seguir produz este diagnóstico porque the constructor `C.new`
is being torn off and the class `C` is an abstract class:

```dart
abstract class C {
  C();
}

void f() {
  [!C.new!];
}
```

## Correções comuns

Tear off the constructor of a concrete class.
