---
ia-translate: true
title: constant_pattern_with_non_constant_expression
description: >-
  Detalhes sobre o diagnóstico constant_pattern_with_non_constant_expression
  produzido pelo analisador do Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_A expressão de um padrão constante deve ser uma constante válida._

## Descrição

O analisador produz este diagnóstico quando um padrão constante tem uma
expressão que não é uma constante válida.

## Exemplo

O código a seguir produz este diagnóstico porque o padrão constante
`i` não é uma constante:

```dart
void f(int e, int i) {
  switch (e) {
    case [!i!]:
      break;
  }
}
```

## Correções comuns

Se o valor que deve ser correspondido for conhecido, então substitua a expressão
por uma constante:

```dart
void f(int e, int i) {
  switch (e) {
    case 0:
      break;
  }
}
```

Se o valor que deve ser correspondido não for conhecido, então reescreva o código para
não usar um padrão:

```dart
void f(int e, int i) {
  if (e == i) {}
}
```
