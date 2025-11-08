---
ia-translate: true
title: unnecessary_null_comparison
description: "Detalhes sobre o diagnóstico unnecessary_null_comparison produzido pelo analisador Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_O operando não pode ser 'null', então a condição é sempre 'false'._

_O operando não pode ser 'null', então a condição é sempre 'true'._

_O operando deve ser 'null', então a condição é sempre 'false'._

_O operando deve ser 'null', então a condição é sempre 'true'._

## Description

O analisador produz este diagnóstico quando encontra uma comparação de igualdade
(seja `==` ou `!=`) com um operando `null` e o outro operando
não pode ser `null`. Tais comparações são sempre `true` ou `false`, então
não servem a nenhum propósito.

## Examples

O código a seguir produz este diagnóstico porque `x` nunca pode ser
`null`, então a comparação sempre avalia para `true`:

```dart
void f(int x) {
  if (x [!!= null!]) {
    print(x);
  }
}
```

O código a seguir produz este diagnóstico porque `x` nunca pode ser
`null`, então a comparação sempre avalia para `false`:

```dart
void f(int x) {
  if (x [!== null!]) {
    throw ArgumentError("x can't be null");
  }
}
```

## Common fixes

Se o outro operando deve poder ser `null`, então altere o tipo do
operando:

```dart
void f(int? x) {
  if (x != null) {
    print(x);
  }
}
```

Se o outro operando realmente não pode ser `null`, então remova a condição:

```dart
void f(int x) {
  print(x);
}
```
