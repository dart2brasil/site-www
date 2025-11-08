---
ia-translate: true
title: optional_parameter_in_operator
description: >-
  Detalhes sobre o diagnóstico optional_parameter_in_operator
  produzido pelo analisador do Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_Parâmetros opcionais não são permitidos ao definir um operador._

## Description

O analisador produz este diagnóstico quando um ou mais dos parâmetros em
uma declaração de operador são opcionais.

## Example

O código a seguir produz este diagnóstico porque o parâmetro `other`
é um parâmetro opcional:

```dart
class C {
  C operator +([[!C? other!]]) => this;
}
```

## Common fixes

Faça todos os parâmetros serem parâmetros obrigatórios:

```dart
class C {
  C operator +(C other) => this;
}
```
