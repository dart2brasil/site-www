---
ia-translate: true
title: prefer_adjacent_string_concatenation
description: "Detalhes sobre o diagnóstico prefer_adjacent_string_concatenation produzido pelo analisador Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/prefer_adjacent_string_concatenation"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_Literais de string não devem ser concatenados pelo operador '+'._

## Description

O analisador produz este diagnóstico quando o operador `+` é usado para
concatenar dois literais de string.

## Example

O código a seguir produz este diagnóstico porque dois literais de string
estão sendo concatenados usando o operador `+`:

```dart
var s = 'a' [!+!] 'b';
```

## Common fixes

Remova o operador:

```dart
var s = 'a' 'b';
```
