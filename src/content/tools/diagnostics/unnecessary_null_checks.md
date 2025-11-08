---
ia-translate: true
title: unnecessary_null_checks
description: "Detalhes sobre o diagnóstico unnecessary_null_checks produzido pelo analisador Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/unnecessary_null_checks"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_Uso desnecessário de uma verificação null ('!')._

## Description

O analisador produz este diagnóstico quando um operador de verificação null (`!`) é
usado em um contexto onde um valor nullable é aceitável.

## Example

O código a seguir produz este diagnóstico porque uma verificação null está sendo
usada mesmo que `null` seja um valor válido para retornar:

```dart
int? f(int? i) {
  return i[!!!];
}
```

## Common fixes

Remova o operador de verificação null:

```dart
int? f(int? i) {
  return i;
}
```
