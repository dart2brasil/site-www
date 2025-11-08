---
title: unnecessary_const
description: >-
  Details about the unnecessary_const
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
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

_Unnecessary 'const' keyword._

## Descrição

O analisador produz este diagnóstico quando the keyword `const` is used in
a [constant context][]. The keyword isn't required because it's implied.

## Exemplo

O código a seguir produz este diagnóstico porque the keyword `const` in
the list literal isn't needed:

```dart
const l = [!const!] <int>[];
```

The list is implicitly `const` because of the keyword `const` on the
variable declaration.

## Correções comuns

Remove the unnecessary keyword:

```dart
const l = <int>[];
```

[constant context]: /resources/glossary#constant-context
