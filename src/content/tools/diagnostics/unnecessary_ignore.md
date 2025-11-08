---
ia-translate: true
title: unnecessary_ignore
description: "Detalhes sobre o diagnóstico unnecessary_ignore produzido pelo analisador Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/unnecessary_ignore"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_O diagnóstico '{0}' não é produzido neste local, então não precisa ser ignorado._

_O diagnóstico '{0}' não é produzido neste arquivo, então não precisa ser ignorado._

## Description

O analisador produz este diagnóstico quando um ignore é especificado para
ignorar um diagnóstico que não é produzido.

## Example

O código a seguir produz este diagnóstico porque o
diagnóstico `unused_local_variable` não é reportado no local ignorado:

```dart
// ignore: [!unused_local_variable!]
void f() {}
```

## Common fixes

Remova o comentário ignore:

```dart
void f() {}
```
