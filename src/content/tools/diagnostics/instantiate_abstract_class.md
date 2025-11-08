---
title: instantiate_abstract_class
description: >-
  Details about the instantiate_abstract_class
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_Abstract classes can't be instantiated._

## Descrição

O analisador produz este diagnóstico quando it finds a constructor
invocation and the constructor is declared in an abstract class. Even
though you can't create an instance of an abstract class, abstract classes
can declare constructors that can be invoked by subclasses.

## Exemplo

O código a seguir produz este diagnóstico porque `C` is an abstract
class:

```dart
abstract class C {}

var c = new [!C!]();
```

## Correções comuns

If there's a concrete subclass of the abstract class that can be used, then
create an instance of the concrete subclass.
