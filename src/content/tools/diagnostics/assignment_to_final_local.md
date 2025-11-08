---
ia-translate: true
title: assignment_to_final_local
description: >-
  Detalhes sobre o diagnóstico assignment_to_final_local
  produzido pelo analisador do Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_A variável final '{0}' só pode ser definida uma vez._

## Description

O analisador produz este diagnóstico quando uma variável local que foi
declarada como final é atribuída após ter sido inicializada.

## Example

O código a seguir produz este diagnóstico porque `x` é final, então
não pode ter um valor atribuído a ela após ter sido inicializada:

```dart
void f() {
  final x = 0;
  [!x!] = 3;
  print(x);
}
```

## Common fixes

Remova a keyword `final` e substitua por `var` se não houver anotação de tipo:

```dart
void f() {
  var x = 0;
  x = 3;
  print(x);
}
```
