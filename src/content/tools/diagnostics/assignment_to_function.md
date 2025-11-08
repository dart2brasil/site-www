---
ia-translate: true
title: assignment_to_function
description: "Detalhes sobre o diagnóstico assignment_to_function produzido pelo analisador do Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_Funções não podem receber um valor._

## Description

O analisador produz este diagnóstico quando o nome de uma função aparece
no lado esquerdo de uma expressão de atribuição.

## Example

O código a seguir produz este diagnóstico porque a atribuição à
função `f` é inválida:

```dart
void f() {}

void g() {
  [!f!] = () {};
}
```

## Common fixes

Se o lado direito deve ser atribuído a outra coisa, como uma
variável local, então altere o lado esquerdo:

```dart
void f() {}

void g() {
  var x = () {};
  print(x);
}
```

Se a intenção é alterar a implementação da função, então defina
uma variável com valor de função ao invés de uma função:

```dart
void Function() f = () {};

void g() {
  f = () {};
}
```
