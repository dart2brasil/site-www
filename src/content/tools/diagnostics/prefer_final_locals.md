---
ia-translate: true
title: prefer_final_locals
description: "Detalhes sobre o diagnóstico prefer_final_locals produzido pelo analisador Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/prefer_final_locals"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_Variáveis locais devem ser final._

## Description

O analisador produz este diagnóstico quando uma variável local não está marcada
como `final`.

## Example

O código a seguir produz este diagnóstico porque a variável `s` não está
marcada como `final`:

```dart
int f(int i) {
  [!var!] s = i + 1;
  return s;
}
```

## Common fixes

Adicione o modificador `final` à variável, removendo o `var` se houver
um:

```dart
int f(int i) {
  final s = i + 1;
  return s;
}
```
