---
ia-translate: true
title: ffi_native_unexpected_number_of_parameters
description: >-
  Detalhes sobre o diagnóstico ffi_native_unexpected_number_of_parameters
  produzido pelo analisador Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_Número inesperado de parâmetros de anotação Native. Esperado {0}, mas tem {1}._

## Description

O analisador produz este diagnóstico quando o número de parâmetros no
tipo de função usado como argumento de tipo para a anotação `@Native` não
corresponde ao número de parâmetros na função sendo anotada.

## Example

O código a seguir produz este diagnóstico porque o tipo de função usado
como argumento de tipo para a anotação `@Native` (`Void Function(Double)`)
tem um argumento e o tipo da função anotada
(`void f(double, double)`) tem dois argumentos:

```dart
import 'dart:ffi';

@Native<Void Function(Double)>(symbol: 'f')
external void [!f!](double x, double y);
```

## Common fixes

Se a função anotada está correta, então atualize o tipo de função na
anotação `@Native` para corresponder:

```dart
import 'dart:ffi';

@Native<Void Function(Double, Double)>(symbol: 'f')
external void f(double x, double y);
```

Se o tipo de função na anotação `@Native` está correto, então atualize
a função anotada para corresponder:

```dart
import 'dart:ffi';

@Native<Void Function(Double)>(symbol: 'f')
external void f(double x);
```
