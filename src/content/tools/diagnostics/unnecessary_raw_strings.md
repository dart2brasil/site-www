---
ia-translate: true
title: unnecessary_raw_strings
description: "Detalhes sobre o diagnóstico unnecessary_raw_strings produzido pelo analisador Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/unnecessary_raw_strings"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_Uso desnecessário de uma string raw._

## Description

O analisador produz este diagnóstico quando um literal de string é marcado como
sendo raw (é prefixado com um `r`), mas tornar a string raw não
altera o valor da string.

## Example

O código a seguir produz este diagnóstico porque o literal de string
terá o mesmo valor sem o `r` como tem com o `r`:

```dart
var s = [!r'abc'!];
```

## Common fixes

Remova o `r` na frente do literal de string:

```dart
var s = 'abc';
```
