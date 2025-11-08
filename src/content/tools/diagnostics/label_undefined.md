---
ia-translate: true
title: label_undefined
description: "Detalhes sobre o diagnóstico label_undefined produzido pelo analisador do Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_Não é possível referenciar um label indefinido '{0}'._

## Description

O analisador produz este diagnóstico quando encontra uma referência a um label
que não está definido no escopo do statement `break` ou `continue` que
está referenciando-o.

## Example

O código a seguir produz este diagnóstico porque o label `loop` não está
definido em lugar algum:

```dart
void f() {
  for (int i = 0; i < 10; i++) {
    for (int j = 0; j < 10; j++) {
      if (j != 0) {
        break [!loop!];
      }
    }
  }
}
```

## Common fixes

Se o label deve estar no statement `do`, `for`, `switch`, ou
`while` envolvente mais interno, então remova o label:

```dart
void f() {
  for (int i = 0; i < 10; i++) {
    for (int j = 0; j < 10; j++) {
      if (j != 0) {
        break;
      }
    }
  }
}
```

Se o label deve estar em algum outro statement, então adicione o label:

```dart
void f() {
  loop: for (int i = 0; i < 10; i++) {
    for (int j = 0; j < 10; j++) {
      if (j != 0) {
        break loop;
      }
    }
  }
}
```
