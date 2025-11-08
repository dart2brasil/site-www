---
ia-translate: true
title: control_flow_in_finally
description: "Detalhes sobre o diagnóstico control_flow_in_finally produzido pelo analisador do Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/control_flow_in_finally"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_Uso de '{0}' em uma cláusula 'finally'._

## Description

O analisador produz este diagnóstico quando uma cláusula `finally` contém um
statement `return`, `break`, ou `continue`.

## Example

O código a seguir produz este diagnóstico porque há um statement `return`
dentro de um bloco `finally`:

```dart
int f() {
  try {
    return 1;
  } catch (e) {
    print(e);
  } finally {
    [!return 0;!]
  }
}
```

## Common fixes

Se o statement não é necessário, então remova o statement, e remova a
cláusula `finally` se o bloco estiver vazio:

```dart
int f() {
  try {
    return 1;
  } catch (e) {
    print(e);
  }
}
```

Se o statement é necessário, então mova o statement para fora do bloco
`finally`:

```dart
int f() {
  try {
    return 1;
  } catch (e) {
    print(e);
  }
  return 0;
}
```
