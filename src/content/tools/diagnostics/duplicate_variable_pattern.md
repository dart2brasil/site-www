---
ia-translate: true
title: duplicate_variable_pattern
description: "Detalhes sobre o diagnóstico duplicate_variable_pattern produzido pelo analisador do Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_A variável '{0}' já está definida neste pattern._

## Description

O analisador produz este diagnóstico quando um branch de um logical-and
pattern declara uma variável que já está declarada em um branch anterior
do mesmo pattern.

## Example

O código a seguir produz este diagnóstico porque a variável `a` está
declarada em ambos os branches do logical-and pattern:

```dart
void f((int, int) r) {
  if (r case (var a, 0) && (0, var [!a!])) {
    print(a);
  }
}
```

## Common fixes

Se você precisa capturar o valor correspondente em múltiplos branches, então altere
os nomes das variáveis para que sejam únicos:

```dart
void f((int, int) r) {
  if (r case (var a, 0) && (0, var b)) {
    print(a + b);
  }
}
```

Se você só precisa capturar o valor correspondente em um branch, então remova
o variable pattern de todos menos um branch:

```dart
void f((int, int) r) {
  if (r case (var a, 0) && (0, _)) {
    print(a);
  }
}
```
