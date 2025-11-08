---
ia-translate: true
title: unnecessary_new
description: >-
  Detalhes sobre o diagnóstico unnecessary_new
  produzido pelo analisador Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/unnecessary_new"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_Keyword 'new' desnecessária._

## Description

O analisador produz este diagnóstico quando a keyword `new` é usada para
invocar um construtor.

## Example

O código a seguir produz este diagnóstico porque a keyword `new` é
usada para invocar o construtor sem nome de `Object`:

```dart
var o = [!new!] Object();
```

## Common fixes

Remova a keyword `new`:

```dart
var o = Object();
```
