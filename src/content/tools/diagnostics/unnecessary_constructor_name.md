---
ia-translate: true
title: unnecessary_constructor_name
description: "Detalhes sobre o diagnóstico unnecessary_constructor_name produzido pelo analisador Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/unnecessary_constructor_name"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_Nome de construtor '.new' desnecessário._

## Description

O analisador produz este diagnóstico quando uma referência a um
construtor sem nome usa `.new`. O único lugar onde `.new` é necessário é em um
tear-off de construtor.

## Example

O código a seguir produz este diagnóstico porque `.new` está sendo usado
para se referir ao construtor sem nome onde não é necessário:

```dart
var o = Object.[!new!]();
```

## Common fixes

Remova o `.new` desnecessário:

```dart
var o = Object();
```
