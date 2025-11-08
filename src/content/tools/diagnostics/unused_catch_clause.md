---
ia-translate: true
title: unused_catch_clause
description: >-
  Detalhes sobre o diagnóstico unused_catch_clause
  produzido pelo analisador Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_A variável de exceção '{0}' não é usada, então a cláusula 'catch' pode ser removida._

## Descrição

O analisador produz este diagnóstico quando uma cláusula `catch` é encontrada, e
nem o parâmetro de exceção nem o parâmetro opcional de stack trace são
usados no bloco `catch`.

## Exemplo

O código a seguir produz este diagnóstico porque `e` não é referenciado:

```dart
void f() {
  try {
    int.parse(';');
  } on FormatException catch ([!e!]) {
    // ignored
  }
}
```

## Correções comuns

Remova a cláusula `catch` não utilizada:

```dart
void f() {
  try {
    int.parse(';');
  } on FormatException {
    // ignored
  }
}
```
