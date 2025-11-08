---
ia-translate: true
title: invalid_inline_function_type
description: "Detalhes sobre o diagnóstico invalid_inline_function_type produzido pelo analisador do Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_Tipos de função inline não podem ser usados para parâmetros em um tipo de função genérica._

## Description

O analisador produz este diagnóstico quando um tipo de função genérica tem
um parâmetro com valor de função que é escrito usando a sintaxe de tipo de
função inline mais antiga.

## Example

O código a seguir produz este diagnóstico porque o parâmetro `f`, no tipo
de função genérica usado para definir `F`, usa a sintaxe de tipo de função
inline:

```dart
typedef F = int Function(int f[!(!]String s));
```

## Common fixes

Use a sintaxe de função genérica para o tipo do parâmetro:

```dart
typedef F = int Function(int Function(String));
```
