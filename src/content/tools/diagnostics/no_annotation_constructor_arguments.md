---
title: no_annotation_constructor_arguments
description: >-
  Details about the no_annotation_constructor_arguments
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_Annotation creation must have arguments._

## Descrição

O analisador produz este diagnóstico quando an annotation consists of a
single identifier, but that identifier is the name of a class rather than a
variable. To create an instance of the class, the identifier must be
followed by an argument list.

## Exemplo

O código a seguir produz este diagnóstico porque `C` is a class, and a
class can't be used as an annotation without invoking a `const` constructor
from the class:

```dart
class C {
  const C();
}

[!@C!]
var x;
```

## Correções comuns

Add the missing argument list:

```dart
class C {
  const C();
}

@C()
var x;
```
