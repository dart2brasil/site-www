---
title: prefer_final_locals
description: >-
  Details about the prefer_final_locals
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/prefer_final_locals"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_Local variables should be final._

## Descrição

O analisador produz este diagnóstico quando a local variable isn't marked
as being `final`.

## Exemplo

O código a seguir produz este diagnóstico porque the variable `s` isn't
marked as being `final`:

```dart
int f(int i) {
  [!var!] s = i + 1;
  return s;
}
```

## Correções comuns

Add the modifier `final` to the variable, removing the `var` if there is
one:

```dart
int f(int i) {
  final s = i + 1;
  return s;
}
```
