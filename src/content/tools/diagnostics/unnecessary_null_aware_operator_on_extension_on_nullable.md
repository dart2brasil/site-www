---
ia-translate: true
title: unnecessary_null_aware_operator_on_extension_on_nullable
description: >-
  Detalhes sobre o diagnóstico unnecessary_null_aware_operator_on_extension_on_nullable
  produzido pelo analisador Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/unnecessary_null_aware_operator_on_extension_on_nullable"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_Uso desnecessário de um operador null-aware para invocar um método de extensão em um tipo nullable._

## Description

O analisador produz este diagnóstico quando um operador null-aware é usado
para invocar um método de extensão em uma extensão cujo tipo é nullable.

## Example

O código a seguir produz este diagnóstico porque o método de extensão
`m` é invocado usando `?.` quando não precisa ser:

```dart
extension E on int? {
  int m() => 1;
}

int? f(int? i) => i[!?.!]m();
```

## Common fixes

Se não for um requisito não invocar o método quando o receptor é
`null`, então remova o ponto de interrogação da invocação:

```dart
extension E on int? {
  int m() => 1;
}

int? f(int? i) => i.m();
```
