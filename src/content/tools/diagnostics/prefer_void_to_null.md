---
ia-translate: true
title: prefer_void_to_null
description: "Detalhes sobre o diagnóstico prefer_void_to_null produzido pelo analisador Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/prefer_void_to_null"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_Uso desnecessário do tipo 'Null'._

## Description

O analisador produz este diagnóstico quando `Null` é usado em um local
onde `void` seria uma escolha válida.

## Example

O código a seguir produz este diagnóstico porque a função `f` é
declarada para retornar `null` (em algum momento futuro):

```dart
Future<[!Null!]> f() async {}
```

## Common fixes

Substitua o uso de `Null` por um uso de `void`:

```dart
Future<void> f() async {}
```
