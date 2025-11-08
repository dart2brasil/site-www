---
ia-translate: true
title: prefer_is_not_empty
description: "Detalhes sobre o diagnóstico prefer_is_not_empty produzido pelo analisador Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/prefer_is_not_empty"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_Use 'isNotEmpty' em vez de negar o resultado de 'isEmpty'._

## Description

O analisador produz este diagnóstico quando o resultado de invocar
`Iterable.isEmpty` ou `Map.isEmpty` é negado.

## Example

O código a seguir produz este diagnóstico porque o resultado de invocar
`Iterable.isEmpty` é negado:

```dart
void f(Iterable<int> p) => [!!p.isEmpty!] ? p.first : 0;
```

## Common fixes

Reescreva o código para usar `isNotEmpty`:

```dart
void f(Iterable<int> p) => p.isNotEmpty ? p.first : 0;
```
