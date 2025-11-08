---
title: use_named_constants
description: >-
  Details about the use_named_constants
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/use_named_constants"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_Use the constant '{0}' rather than a constructor returning the same object._

## Descrição

O analisador produz este diagnóstico quando a constant is created with the
same value as a known `const` variable.

## Exemplo

O código a seguir produz este diagnóstico porque there is a known
`const` field (`Duration.zero`) whose value is the same as what the
constructor invocation will evaluate to:

```dart
Duration d = [!const Duration(seconds: 0)!];
```

## Correções comuns

Replace the constructor invocation with a reference to the known `const`
variable:

```dart
Duration d = Duration.zero;
```
