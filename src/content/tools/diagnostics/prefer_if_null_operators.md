---
ia-translate: true
title: prefer_if_null_operators
description: "Detalhes sobre o diagnóstico prefer_if_null_operators produzido pelo analisador Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/prefer_if_null_operators"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_Use o operador '??' em vez de '?:' ao testar por 'null'._

## Description

O analisador produz este diagnóstico quando uma expressão condicional (usando
o operador `?:`) é usada para selecionar um valor diferente quando uma variável
local é `null`.

## Example

O código a seguir produz este diagnóstico porque a variável `s` está
sendo comparada a `null` para que um valor diferente possa ser retornado quando
`s` for `null`:

```dart
String f(String? s) => [!s == null ? '' : s!];
```

## Common fixes

Use o operador if-null em vez disso:

```dart
String f(String? s) => s ?? '';
```
