---
title: slash_for_doc_comments
description: >-
  Details about the slash_for_doc_comments
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/slash_for_doc_comments"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_Use the end-of-line form ('///') for doc comments._

## Descrição

O analisador produz este diagnóstico quando a documentation comment uses
the block comment style (delimited by `/**` and `*/`).

## Exemplo

O código a seguir produz este diagnóstico porque the documentation
comment for `f` uses a block comment style:

```dart
[!/**!]
 [!* Example.!]
 [!*/!]
void f() {}
```

## Correções comuns

Use an end-of-line comment style:

```dart
/// Example.
void f() {}
```
