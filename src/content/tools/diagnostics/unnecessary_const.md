---
ia-translate: true
title: unnecessary_const
description: >-
  Detalhes sobre o diagnóstico unnecessary_const
  produzido pelo analisador Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/unnecessary_const"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_Keyword 'const' desnecessária._

## Description

O analisador produz este diagnóstico quando a keyword `const` é usada em
um [contexto constante][constant context]. A keyword não é necessária porque está implícita.

## Example

O código a seguir produz este diagnóstico porque a keyword `const` no
literal de lista não é necessária:

```dart
const l = [!const!] <int>[];
```

A lista é implicitamente `const` por causa da keyword `const` na
declaração da variável.

## Common fixes

Remova a keyword desnecessária:

```dart
const l = <int>[];
```

[constant context]: /resources/glossary#constant-context
