---
ia-translate: true
title: unnecessary_null_in_if_null_operators
description: "Detalhes sobre o diagnóstico unnecessary_null_in_if_null_operators produzido pelo analisador Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/unnecessary_null_in_if_null_operators"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_Uso desnecessário de '??' com 'null'._

## Description

O analisador produz este diagnóstico quando o operando direito do operador `??`
é o literal `null`.

## Example

O código a seguir produz este diagnóstico porque o operando do lado direito
do operador `??` é `null`:

```dart
String? f(String? s) => s ?? [!null!];
```

## Common fixes

Se um valor não-null deve ser usado para o operando do lado direito, então
altere o lado direito:

```dart
String f(String? s) => s ?? '';
```

Se não houver valor não-null para usar no operando do lado direito, então
remova o operador e o operando do lado direito:

```dart
String? f(String? s) => s;
```
