---
title: optional_parameter_in_operator
description: >-
  Details about the optional_parameter_in_operator
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_Optional parameters aren't allowed when defining an operator._

## Descrição

O analisador produz este diagnóstico quando one or more of the parameters in
an operator declaration are optional.

## Exemplo

O código a seguir produz este diagnóstico porque the parameter `other`
is an optional parameter:

```dart
class C {
  C operator +([[!C? other!]]) => this;
}
```

## Correções comuns

Make all of the parameters be required parameters:

```dart
class C {
  C operator +(C other) => this;
}
```
