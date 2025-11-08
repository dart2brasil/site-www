---
title: unused_label
description: >-
  Details about the unused_label
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_The label '{0}' isn't used._

## Descrição

O analisador produz este diagnóstico quando a label that isn't used is
found.

## Exemplo

O código a seguir produz este diagnóstico porque the label `loop` isn't
referenced anywhere in the method:

```dart
void f(int limit) {
  [!loop:!] for (int i = 0; i < limit; i++) {
    print(i);
  }
}
```

## Correções comuns

If the label isn't needed, then remove it:

```dart
void f(int limit) {
  for (int i = 0; i < limit; i++) {
    print(i);
  }
}
```

If the label is needed, then use it:

```dart
void f(int limit) {
  loop: for (int i = 0; i < limit; i++) {
    print(i);
    if (i != 0) {
      break loop;
    }
  }
}
```
