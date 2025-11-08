---
title: control_flow_in_finally
description: >-
  Details about the control_flow_in_finally
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
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

_Use of '{0}' in a 'finally' clause._

## Descrição

O analisador produz este diagnóstico quando a `finally` clause contains a
`return`, `break`, or `continue` statement.

## Exemplo

O código a seguir produz este diagnóstico porque there is a `return`
statement inside a `finally` block:

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

## Correções comuns

If the statement isn't needed, then remove the statement, and remove the
`finally` clause if the block is empty:

```dart
int f() {
  try {
    return 1;
  } catch (e) {
    print(e);
  }
}
```

If the statement is needed, then move the statement outside the `finally`
block:

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
