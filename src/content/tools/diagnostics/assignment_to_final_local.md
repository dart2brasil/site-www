---
title: assignment_to_final_local
description: >-
  Details about the assignment_to_final_local
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_The final variable '{0}' can only be set once._

## Descrição

O analisador produz este diagnóstico quando a local variable that was
declared to be final is assigned after it was initialized.

## Exemplo

O código a seguir produz este diagnóstico porque `x` is final, so it
can't have a value assigned to it after it was initialized:

```dart
void f() {
  final x = 0;
  [!x!] = 3;
  print(x);
}
```

## Correções comuns

Remove the keyword `final`, and replace it with `var` if there's no type
annotation:

```dart
void f() {
  var x = 0;
  x = 3;
  print(x);
}
```
