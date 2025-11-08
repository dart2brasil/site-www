---
ia-translate: true
title: ffi_native_unexpected_number_of_parameters_with_receiver
description: "Detalhes sobre o diagnóstico ffi_native_unexpected_number_of_parameters_with_receiver produzido pelo analisador Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_Número inesperado de parâmetros de anotação Native. Esperado {0}, mas tem {1}. A anotação do método de instância nativa deve ter o receptor como primeiro argumento._

## Description

O analisador produz este diagnóstico quando o argumento de tipo usado na
anotação `@Native` de um método nativo não inclui um tipo para o
receptor do método.

## Example

O código a seguir produz este diagnóstico porque o argumento de tipo na
anotação `@Native` (`Void Function(Double)`) não inclui um tipo
para o receptor do método:

```dart
import 'dart:ffi';

class C {
  @Native<Void Function(Double)>()
  external void [!f!](double x);
}
```

## Common fixes

Adicione um parâmetro inicial cujo tipo é igual ao da classe em que o
método nativo está sendo declarado:

```dart
import 'dart:ffi';

class C {
  @Native<Void Function(C, Double)>()
  external void f(double x);
}
```
