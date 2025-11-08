---
ia-translate: true
title: prefer_final_in_for_each
description: "Detalhes sobre o diagnóstico prefer_final_in_for_each produzido pelo analisador Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/prefer_final_in_for_each"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_O padrão deve ser final._

_A variável '{0}' deve ser final._

## Description

O analisador produz este diagnóstico quando a variável de loop em uma instrução for-each
não está marcada como `final`.

## Example

O código a seguir produz este diagnóstico porque a variável de loop `e`
não está marcada como `final`:

```dart
void f(List<int> l) {
  for (var [!e!] in l) {
    print(e);
  }
}
```

## Common fixes

Adicione o modificador `final` à variável de loop, removendo o `var` se houver
um:

```dart
void f(List<int> l) {
  for (final e in l) {
    print(e);
  }
}
```
