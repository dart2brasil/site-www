---
ia-translate: true
title: use_if_null_to_convert_nulls_to_bools
description: "Detalhes sobre o diagnóstico use_if_null_to_convert_nulls_to_bools produzido pelo analisador Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/use_if_null_to_convert_nulls_to_bools"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_Use um operador if-null para converter um 'null' em um 'bool'._

## Descrição

O analisador produz este diagnóstico quando uma expressão com valor `bool` nullable
é comparada (usando `==` ou `!=`) a um literal booleano.

## Exemplo

O código a seguir produz este diagnóstico porque a variável booleana nullable
`b` é comparada a `true`:

```dart
void f(bool? b) {
  if ([!b == true!]) {
    // Trata `null` como `false`.
  }
}
```

## Correções comuns

Reescreva a condição para usar `??` em vez disso:

```dart
void f(bool? b) {
  if (b ?? false) {
    // Trata `null` como `false`.
  }
}
```
