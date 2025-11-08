---
ia-translate: true
title: prefer_collection_literals
description: >-
  Detalhes sobre o diagnóstico prefer_collection_literals
  produzido pelo analisador Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/prefer_collection_literals"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_Invocação desnecessária de construtor._

## Description

O analisador produz este diagnóstico quando um construtor é usado para criar
uma lista, mapa ou conjunto, mas um literal produziria o mesmo resultado.

## Example

O código a seguir produz este diagnóstico porque o construtor de
`Map` está sendo usado para criar um mapa que também poderia ser criado usando um
literal:

```dart
var m = [!Map<String, String>()!];
```

## Common fixes

Use a representação literal:

```dart
var m = <String, String>{};
```
