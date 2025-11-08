---
ia-translate: true
title: integer_literal_imprecise_as_double
description: "Detalhes sobre o diagnóstico integer_literal_imprecise_as_double produzido pelo analisador do Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_O literal de inteiro está sendo usado como um double, mas não pode ser representado como um double de 64 bits sem overflow ou perda de precisão: '{0}'._

## Description

O analisador produz este diagnóstico quando um literal de inteiro está sendo
convertido implicitamente para um double, mas não pode ser representado como um double de 64 bits
sem overflow ou perda de precisão. Literais de inteiro são
convertidos implicitamente para um double se o contexto requer o tipo `double`.

## Example

O código a seguir produz este diagnóstico porque o valor inteiro
`9223372036854775807` não pode ser representado exatamente como um double:

```dart
double x = [!9223372036854775807!];
```

## Common fixes

Se você precisa usar o valor exato, então use a classe `BigInt` para
representar o valor:

```dart
var x = BigInt.parse('9223372036854775807');
```

Se você precisa usar um double, então altere o valor para um que possa ser
representado exatamente:

```dart
double x = 9223372036854775808;
```
