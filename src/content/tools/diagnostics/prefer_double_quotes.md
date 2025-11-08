---
title: prefer_double_quotes
description: >-
  Details about the prefer_double_quotes
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/prefer_double_quotes"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_Unnecessary use of single quotes._

## Descrição

O analisador produz este diagnóstico quando a string literal uses single
quotes (`'`) when it could use double quotes (`"`) without needing extra
escapes and without hurting readability.

## Exemplo

O código a seguir produz este diagnóstico porque the string literal
uses single quotes but doesn't need to:

```dart
void f(String name) {
  print([!'Hello $name'!]);
}
```

## Correções comuns

Use double quotes in place of single quotes:

```dart
void f(String name) {
  print("Hello $name");
}
```
