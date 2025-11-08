---
ia-translate: true
title: empty_constructor_bodies
description: "Detalhes sobre o diagnóstico empty_constructor_bodies produzido pelo analisador Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/empty_constructor_bodies"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_Corpos de construtores empty devem ser escritos usando ';' ao invés de '{}'._

## Description

O analisador produz este diagnóstico quando um construtor tem um
corpo de bloco empty.

## Example

O código a seguir produz este diagnóstico porque o construtor de
`C` tem um corpo de bloco que está empty:

```dart
class C {
  C() [!{}!]
}
```

## Common fixes

Substitua o bloco por um ponto e vírgula:

```dart
class C {
  C();
}
```
