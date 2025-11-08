---
ia-translate: true
title: duplicate_pattern_field
description: >-
  Detalhes sobre o diagnóstico duplicate_pattern_field
  produzido pelo analisador Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_O campo '{0}' já foi correspondido neste pattern._

## Description

O analisador produz este diagnóstico quando um pattern de record corresponde ao
mesmo campo mais de uma vez, ou quando um pattern de objeto corresponde ao mesmo
getter mais de uma vez.

## Examples

O código a seguir produz este diagnóstico porque o campo de record `a`
é correspondido duas vezes no mesmo pattern de record:

```dart
void f(({int a, int b}) r) {
  switch (r) {
    case (a: 1, [!a!]: 2):
      return;
  }
}
```

O código a seguir produz este diagnóstico porque o getter `f` é
correspondido duas vezes no mesmo pattern de objeto:

```dart
void f(Object o) {
  switch (o) {
    case C(f: 1, [!f!]: 2):
      return;
  }
}
class C {
  int? f;
}
```

## Common fixes

Se o pattern deve corresponder a mais de um valor do campo duplicado,
então use um pattern logical-or:

```dart
void f(({int a, int b}) r) {
  switch (r) {
    case (a: 1, b: _) || (a: 2, b: _):
      break;
  }
}
```

Se o pattern deve corresponder a múltiplos campos, então mude o nome
de um dos campos:

```dart
void f(({int a, int b}) r) {
  switch (r) {
    case (a: 1, b: 2):
      return;
  }
}
```
