---
ia-translate: true
title: read_potentially_unassigned_final
description: "Detalhes sobre o diagnóstico read_potentially_unassigned_final produzido pelo analisador do Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_A variável final '{0}' não pode ser lida porque está potencialmente não atribuída neste ponto._

## Description

O analisador produz este diagnóstico quando uma variável local final que
não é inicializada no local da declaração é lida em um ponto onde o
compilador não consegue provar que a variável é sempre inicializada antes de ser
referenciada.

## Example

O código a seguir produz este diagnóstico porque a variável local
final `x` é lida (na linha 3) quando é possível que ela ainda não tenha
sido inicializada:

```dart
int f() {
  final int x;
  return [!x!];
}
```

## Common fixes

Garanta que a variável tenha sido inicializada antes de ser lida:

```dart
int f(bool b) {
  final int x;
  if (b) {
    x = 0;
  } else {
    x = 1;
  }
  return x;
}
```
