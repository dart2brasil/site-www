---
ia-translate: true
title: only_throw_errors
description: "Detalhes sobre o diagnóstico only_throw_errors produzido pelo analisador do Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/only_throw_errors"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_Não lance instâncias de classes que não estendem 'Exception' ou 'Error'._

## Description

O analisador produz este diagnóstico quando o valor sendo lançado não é uma
subclasse de `Exception` ou `Error`.

## Example

O código a seguir produz este diagnóstico porque a string `'f'` está
sendo lançada:

```dart
void f() => throw [!'f'!];
```

## Common fixes

Substitua o valor por uma instância de uma subclasse de `Exception` ou
`Error`:

```dart
void f() => throw ArgumentError('f');
```
