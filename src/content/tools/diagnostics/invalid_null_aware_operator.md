---
ia-translate: true
title: invalid_null_aware_operator
description: >-
  Detalhes sobre o diagnóstico invalid_null_aware_operator
  produzido pelo analisador do Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_O elemento não pode ser null, então o operador null-aware '?' é desnecessário._

_A chave da entrada do mapa não pode ser null, então o operador null-aware '?' é desnecessário._

_O valor da entrada do mapa não pode ser null, então o operador null-aware '?' é desnecessário._

_O receptor não pode ser 'null' devido ao curto-circuito, então o operador null-aware '{0}' não pode ser usado._

_O receptor não pode ser null, então o operador null-aware '{0}' é desnecessário._

## Description

O analisador produz este diagnóstico quando um operador null-aware (`?.`,
`?..`, `?[`, `?..[` ou `...?`) é usado em um receptor que é conhecido por
ser não-nulável.

## Examples

O código a seguir produz este diagnóstico porque `s` não pode ser `null`:

```dart
int? getLength(String s) {
  return s[!?.!]length;
}
```

O código a seguir produz este diagnóstico porque `a` não pode ser `null`:

```dart
var a = [];
var b = [[!...?!]a];
```

O código a seguir produz este diagnóstico porque `s?.length` não pode
retornar `null`:

```dart
void f(String? s) {
  s?.length[!?.!]isEven;
}
```

A razão pela qual `s?.length` não pode retornar `null` é porque o operador
null-aware após `s` interrompe (short-circuits) a avaliação de `length` e
`isEven` se `s` é `null`. Em outras palavras, se `s` é `null`, nem `length`
nem `isEven` serão invocados, e se `s` não é `null`, então `length` não pode
retornar um valor `null`. De qualquer forma, `isEven` não pode ser invocado
em um valor `null`, então o operador null-aware não é necessário. Veja
[Understanding null safety](/null-safety/understanding-null-safety#smarter-null-aware-methods)
para mais detalhes.

O código a seguir produz este diagnóstico porque `s` não pode ser `null`.

```dart
void f(Object? o) {
  var s = o as String;
  s[!?.!]length;
}
```

A razão pela qual `s` não pode ser null, apesar do fato de que `o` pode ser
`null`, é por causa da conversão para `String`, que é um tipo não-nulável.
Se `o` alguma vez tiver o valor `null`, a conversão falhará e a invocação de
`length` não acontecerá.

O código a seguir produz este diagnóstico porque `s` não pode ser `null`:

```dart
List<String> makeSingletonList(String s) {
  return <String>[[!?!]s];
}
```

## Common fixes

Substitua o operador null-aware por um equivalente não-null-aware; por
exemplo, mude `?.` para `.`:

```dart
int getLength(String s) {
  return s.length;
}
```

(Observe que o tipo de retorno também foi alterado para ser não-nulável, o
que pode não ser apropriado em alguns casos.)
