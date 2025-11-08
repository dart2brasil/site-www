---
ia-translate: true
title: provide_deprecation_message
description: "Detalhes sobre o diagnóstico provide_deprecation_message produzido pelo analisador do Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/provide_deprecation_message"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_Faltando uma mensagem de depreciação._

## Description

O analisador produz este diagnóstico quando uma anotação `deprecated` é
usada em vez da anotação `Deprecated`.

## Example

O código a seguir produz este diagnóstico porque a função `f` é
anotada com `deprecated`:

```dart
[!@deprecated!]
void f() {}
```

## Common fixes

Converta o código para usar a forma mais longa:

```dart
@Deprecated('Use g instead. Will be removed in 4.0.0.')
void f() {}
```
