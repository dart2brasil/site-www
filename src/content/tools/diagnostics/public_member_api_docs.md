---
title: public_member_api_docs
description: >-
  Details about the public_member_api_docs
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/public_member_api_docs"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_Missing documentation for a public member._

## Descrição

O analisador produz este diagnóstico quando the declaration of part of the
public API of a package doesn't have a documentation comment.

## Exemplo

O código a seguir produz este diagnóstico porque a classe `C` doesn't
have a documentation comment:

```dart
class [!C!] {}
```

## Correções comuns

Add a documentation comment.

```dart
/// Documentation comment.
class C {}
```
