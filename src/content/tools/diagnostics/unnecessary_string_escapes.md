---
title: unnecessary_string_escapes
description: >-
  Details about the unnecessary_string_escapes
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/unnecessary_string_escapes"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_Unnecessary escape in string literal._

## Descrição

O analisador produz este diagnóstico quando characters in a string are
escaped when escaping them is unnecessary.

## Exemplo

O código a seguir produz este diagnóstico porque single quotes don't
need to be escaped inside strings delimited by double quotes:

```dart
var s = "Don[!\!]'t use a backslash here.";
```

## Correções comuns

Remove the unnecessary backslashes:

```dart
var s = "Don't use a backslash here.";
```
