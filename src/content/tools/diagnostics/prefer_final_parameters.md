---
ia-translate: true
title: prefer_final_parameters
description: >-
  Detalhes sobre o diagnóstico prefer_final_parameters
  produzido pelo analisador Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/prefer_final_parameters"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_O parâmetro '{0}' deve ser final._

## Description

O analisador produz este diagnóstico quando um parâmetro de um construtor,
método, função ou closure não está marcado como `final`.

## Example

O código a seguir produz este diagnóstico porque o parâmetro `s`
não é um parâmetro `final`:

```dart
String f([!String s!]) => s;
```

## Common fixes

Adicione o modificador `final` ao parâmetro:

```dart
String f(final String s) => s;
```
