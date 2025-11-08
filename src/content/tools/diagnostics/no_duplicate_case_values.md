---
ia-translate: true
title: no_duplicate_case_values
description: >-
  Detalhes sobre o diagnóstico no_duplicate_case_values
  produzido pelo analisador do Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/no_duplicate_case_values"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_The value of the case clause ('{0}') is equal to the value of an earlier case clause ('{1}')._

## Description

O analisador produz este diagnóstico quando duas ou mais cláusulas `case` no
mesmo comando `switch` possuem o mesmo valor.

Quaisquer cláusulas `case` após a primeira não podem ser executadas, então ter cláusulas
`case` duplicadas é enganoso.

Este diagnóstico frequentemente é o resultado de um erro de digitação ou de uma mudança no
valor de uma constante.

## Example

O código a seguir produz este diagnóstico porque duas cláusulas case possuem
o mesmo valor (1):

```dart
// @dart = 2.14
void f(int v) {
  switch (v) {
    case 1:
      break;
    case [!1!]:
      break;
  }
}
```

## Common fixes

Se uma das cláusulas deveria ter um valor diferente, então mude o valor
da cláusula:

```dart
void f(int v) {
  switch (v) {
    case 1:
      break;
    case 2:
      break;
  }
}
```

Se o valor está correto, então mescle os comandos em uma única cláusula:

```dart
void f(int v) {
  switch (v) {
    case 1:
      break;
  }
}
```
