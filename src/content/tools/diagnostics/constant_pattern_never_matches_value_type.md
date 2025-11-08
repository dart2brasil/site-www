---
ia-translate: true
title: constant_pattern_never_matches_value_type
description: "Detalhes sobre o diagnóstico constant_pattern_never_matches_value_type produzido pelo analisador do Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_O tipo '{0}' do valor correspondente nunca pode ser igual a esta constante do tipo '{1}'._

## Descrição

O analisador produz este diagnóstico quando um padrão constante nunca pode
corresponder ao valor contra o qual está sendo testado porque o tipo da constante
é conhecido por nunca corresponder ao tipo do valor.

## Exemplo

O código a seguir produz este diagnóstico porque o tipo do
padrão constante `(true)` é `bool`, e o tipo do valor sendo
correspondido (`x`) é `int`, e um Boolean nunca pode corresponder a um inteiro:

```dart
void f(int x) {
  if (x case [!true!]) {}
}
```

## Correções comuns

Se o tipo do valor estiver correto, então reescreva o padrão para ser
compatível:

```dart
void f(int x) {
  if (x case 3) {}
}
```

Se o tipo da constante estiver correto, então reescreva o valor para ser
compatível:

```dart
void f(bool x) {
  if (x case true) {}
}
```
