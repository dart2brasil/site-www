---
ia-translate: true
title: definitely_unassigned_late_local_variable
description: "Detalhes sobre o diagnóstico definitely_unassigned_late_local_variable produzido pelo analisador do Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_A variável local late '{0}' está definitivamente não atribuída neste ponto._

## Description

O analisador produz este diagnóstico quando a análise de [definite assignment][]
mostra que uma variável local que está marcada como `late` é lida antes de ser
atribuída.

## Example

O código a seguir produz este diagnóstico porque `x` não foi atribuído um
valor antes de ser lido:

```dart
void f(bool b) {
  late int x;
  print([!x!]);
}
```

## Common fixes

Atribua um valor à variável antes de ler dela:

```dart
void f(bool b) {
  late int x;
  x = b ? 1 : 0;
  print(x);
}
```

[definite assignment]: /resources/glossary#definite-assignment
