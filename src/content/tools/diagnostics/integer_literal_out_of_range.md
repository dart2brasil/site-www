---
ia-translate: true
title: integer_literal_out_of_range
description: "Detalhes sobre o diagnóstico integer_literal_out_of_range produzido pelo analisador do Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_O literal de inteiro {0} não pode ser representado em 64 bits._

## Description

O analisador produz este diagnóstico quando um literal de inteiro tem um valor
que é muito grande (positivo) ou muito pequeno (negativo) para ser representado em uma
palavra de 64 bits.

## Example

O código a seguir produz este diagnóstico porque o valor não pode ser
representado em 64 bits:

```dart
var x = [!9223372036854775810!];
```

## Common fixes

Se você precisa representar o valor atual, então envolva-o em uma instância da
classe `BigInt`:

```dart
var x = BigInt.parse('9223372036854775810');
```
