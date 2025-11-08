---
title: break_label_on_switch_member
description: "Detalhes sobre o diagnóstico break_label_on_switch_member produzido pelo analisador Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_Um rótulo de break resolve para a instrução 'case' ou 'default'._

## Description

O analisador produz este diagnóstico quando um break em uma cláusula case dentro
de uma instrução switch tem um rótulo que está associado a outra cláusula case.

## Example

O código a seguir produz este diagnóstico porque o rótulo `l` está
associado à cláusula case para `0`:

```dart
void f(int i) {
  switch (i) {
    l: case 0:
      break;
    case 1:
      break [!l!];
  }
}
```

## Common fixes

Se a intenção é transferir o controle para a instrução após o switch,
então remova o rótulo da instrução break:

```dart
void f(int i) {
  switch (i) {
    case 0:
      break;
    case 1:
      break;
  }
}
```

Se a intenção é transferir o controle para um bloco case diferente, então use
`continue` ao invés de `break`:

```dart
void f(int i) {
  switch (i) {
    l: case 0:
      break;
    case 1:
      continue l;
  }
}
```
