---
ia-translate: true
title: unnecessary_nan_comparison
description: "Detalhes sobre o diagnóstico unnecessary_nan_comparison produzido pelo analisador Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_Um double não pode ser igual a 'double.nan', então a condição é sempre 'false'._

_Um double não pode ser igual a 'double.nan', então a condição é sempre 'true'._

## Description

O analisador produz este diagnóstico quando um valor é comparado a
`double.nan` usando `==` ou `!=`.

Dart segue o padrão de ponto flutuante [IEEE 754] para a semântica de
operações de ponto flutuante, que afirma que, para qualquer valor de ponto flutuante
`x` (incluindo NaN, infinito positivo e infinito negativo),
- `NaN == x` é sempre false
- `NaN != x` é sempre true

Como resultado, comparar qualquer valor a NaN é inútil porque o resultado já é
conhecido (com base no operador de comparação sendo usado).

## Example

O código a seguir produz este diagnóstico porque `d` está sendo comparado
a `double.nan`:

```dart
bool isNaN(double d) => d [!== double.nan!];
```

## Common fixes

Use o getter `double.isNaN` em vez disso:

```dart
bool isNaN(double d) => d.isNaN;
```

[IEEE 754]: https://en.wikipedia.org/wiki/IEEE_754
