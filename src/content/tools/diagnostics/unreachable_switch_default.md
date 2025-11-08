---
ia-translate: true
title: unreachable_switch_default
description: "Detalhes sobre o diagnóstico unreachable_switch_default produzido pelo analisador do Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_Esta cláusula default é coberta pelos cases anteriores._

## Descrição

O analisador produz este diagnóstico quando uma cláusula `default` em uma
instrução `switch` não corresponde a nada porque todos os valores correspondentes
são correspondidos por uma cláusula `case` anterior.

## Exemplo

O código a seguir produz este diagnóstico porque os valores `E.e1` e
`E.e2` foram correspondidos nos cases anteriores:

```dart
enum E { e1, e2 }

void f(E x) {
  switch (x) {
    case E.e1:
      print('one');
    case E.e2:
      print('two');
    [!default!]:
      print('other');
  }
}
```

## Correções comuns

Remova a cláusula `default` desnecessária:

```dart
enum E { e1, e2 }
void f(E x) {
  switch (x) {
    case E.e1:
      print('one');
    case E.e2:
      print('two');
  }
}
```
