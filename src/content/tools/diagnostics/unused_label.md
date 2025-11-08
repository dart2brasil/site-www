---
ia-translate: true
title: unused_label
description: "Detalhes sobre o diagnóstico unused_label produzido pelo analisador Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_O rótulo '{0}' não é usado._

## Descrição

O analisador produz este diagnóstico quando um rótulo que não é usado é
encontrado.

## Exemplo

O código a seguir produz este diagnóstico porque o rótulo `loop` não é
referenciado em nenhum lugar do método:

```dart
void f(int limit) {
  [!loop:!] for (int i = 0; i < limit; i++) {
    print(i);
  }
}
```

## Correções comuns

Se o rótulo não é necessário, então remova-o:

```dart
void f(int limit) {
  for (int i = 0; i < limit; i++) {
    print(i);
  }
}
```

Se o rótulo é necessário, então use-o:

```dart
void f(int limit) {
  loop: for (int i = 0; i < limit; i++) {
    print(i);
    if (i != 0) {
      break loop;
    }
  }
}
```
