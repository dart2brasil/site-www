---
ia-translate: true
title: unreachable_switch_case
description: >-
  Detalhes sobre o diagnóstico unreachable_switch_case
  produzido pelo analisador do Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_Este case é coberto pelos cases anteriores._

## Descrição

O analisador produz este diagnóstico quando uma cláusula `case` em uma instrução `switch`
não corresponde a nada porque todos os valores correspondentes são
correspondidos por uma cláusula `case` anterior.

## Exemplo

O código a seguir produz este diagnóstico porque o valor `1` foi
correspondido no case anterior:

```dart
void f(int x) {
  switch (x) {
    case 1:
      print('one');
    [!case!] 1:
      print('two');
  }
}
```

## Correções comuns

Altere um ou ambos os cases conflitantes para corresponder valores diferentes:

```dart
void f(int x) {
  switch (x) {
    case 1:
      print('one');
    case 2:
      print('two');
  }
}
```
