---
title: undefined_annotation
description: >-
  Details about the undefined_annotation
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_Undefined name '{0}' used as an annotation._

## Descrição

O analisador produz este diagnóstico quando a name that isn't defined is
used as an annotation.

## Exemplo

O código a seguir produz este diagnóstico porque the name `undefined`
isn't defined:

```dart
[!@undefined!]
void f() {}
```

## Correções comuns

If the name is correct, but it isn't declared yet, then declare the name as
a constant value:

```dart
const undefined = 'undefined';

@undefined
void f() {}
```

If the name is wrong, replace the name with the name of a valid constant:

```dart
@deprecated
void f() {}
```

Otherwise, remove the annotation.
