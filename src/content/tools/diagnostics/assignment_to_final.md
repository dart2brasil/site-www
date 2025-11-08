---
ia-translate: true
title: assignment_to_final
description: >-
  Detalhes sobre o diagnóstico assignment_to_final
  produzido pelo analisador do Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_'{0}' não pode ser usado como setter porque é final._

## Description

O analisador produz este diagnóstico quando encontra uma invocação de um
setter, mas não há setter porque o campo com o mesmo nome foi
declarado como `final` ou `const`.

## Example

O código a seguir produz este diagnóstico porque `v` é final:

```dart
class C {
  final v = 0;
}

f(C c) {
  c.[!v!] = 1;
}
```

## Common fixes

Se você precisa ser capaz de definir o valor do campo, então remova o
modificador `final` do campo:

```dart
class C {
  int v = 0;
}

f(C c) {
  c.v = 1;
}
```
