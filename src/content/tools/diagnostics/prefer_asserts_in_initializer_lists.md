---
ia-translate: true
title: prefer_asserts_in_initializer_lists
description: >-
  Detalhes sobre o diagnóstico prefer_asserts_in_initializer_lists
  produzido pelo analisador Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/prefer_asserts_in_initializer_lists"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_Assert deve estar na lista de inicializadores._

## Description

O analisador produz este diagnóstico quando o corpo de um construtor
começa com uma ou mais instruções assert.

## Example

O código a seguir produz este diagnóstico porque o corpo do
construtor começa com uma instrução assert:

```dart
class C {
  C(int i) {
    [!assert!](i != 0);
  }
}
```

## Common fixes

Mova o assert para a lista de inicializadores, removendo o corpo se houver
apenas instruções assert nele:

```dart
class C {
  C(int i) : assert(i != 0);
}
```
