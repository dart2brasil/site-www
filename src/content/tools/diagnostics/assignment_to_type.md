---
ia-translate: true
title: assignment_to_type
description: >-
  Detalhes sobre o diagnóstico assignment_to_type
  produzido pelo analisador do Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_Tipos não podem receber um valor._

## Description

O analisador produz este diagnóstico quando o nome de um tipo aparece
no lado esquerdo de uma expressão de atribuição.

## Example

O código a seguir produz este diagnóstico porque a atribuição à
classe `C` é inválida:

```dart
class C {}

void f() {
  [!C!] = null;
}
```

## Common fixes

Se o lado direito deve ser atribuído a outra coisa, como uma
variável local, então altere o lado esquerdo:

```dart
void f() {}

void g() {
  var c = null;
  print(c);
}
```
