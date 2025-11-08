---
ia-translate: true
title: prefer_is_empty
description: "Detalhes sobre o diagnóstico prefer_is_empty produzido pelo analisador Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/prefer_is_empty"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_A comparação é sempre 'false' porque o comprimento é sempre maior ou igual a 0._

_A comparação é sempre 'true' porque o comprimento é sempre maior ou igual a 0._

_Use 'isEmpty' em vez de 'length' para testar se a coleção está vazia._

_Use 'isNotEmpty' em vez de 'length' para testar se a coleção está vazia._

## Description

O analisador produz este diagnóstico quando o resultado de invocar
`Iterable.length` ou `Map.length` é comparado para igualdade com zero
(`0`).

## Example

O código a seguir produz este diagnóstico porque o resultado de invocar
`length` é verificado para igualdade com zero:

```dart
int f(Iterable<int> p) => [!p.length == 0!] ? 0 : p.first;
```

## Common fixes

Substitua o uso de `length` por um uso de `isEmpty` ou
`isNotEmpty`:

```dart
void f(Iterable<int> p) => p.isEmpty ? 0 : p.first;
```
