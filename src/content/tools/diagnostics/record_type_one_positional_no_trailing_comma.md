---
ia-translate: true
title: record_type_one_positional_no_trailing_comma
description: "Detalhes sobre o diagnóstico record_type_one_positional_no_trailing_comma produzido pelo analisador Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_Um tipo record com exatamente um campo posicional requer uma vírgula final._

## Description

O analisador produz este diagnóstico quando uma anotação de tipo record com um
único campo posicional não tem uma vírgula final após o campo.

Em alguns locais, um tipo record com um único campo posicional também pode
ser uma expressão entre parênteses. Uma vírgula final é necessária para
desambiguar essas duas interpretações válidas.

## Example

O código a seguir produz este diagnóstico porque o tipo record tem
um campo posicional, mas não tem uma vírgula final:

```dart
void f((int[!)!] r) {}
```

## Common fixes

Adicione uma vírgula final:

```dart
void f((int,) r) {}
```
