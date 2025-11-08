---
title: await_in_late_local_variable_initializer
description: >-
  Detalhes sobre o diagnóstico await_in_late_local_variable_initializer
  produzido pelo analisador Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_A expressão 'await' não pode ser usada no inicializador de uma variável local 'late'._

## Description

O analisador produz este diagnóstico quando uma variável local que possui o
modificador `late` usa uma expressão `await` no inicializador.

## Example

O código a seguir produz este diagnóstico porque uma expressão `await`
é usada no inicializador de `v`, uma variável local marcada como `late`:

```dart
Future<int> f() async {
  late var v = [!await!] 42;
  return v;
}
```

## Common fixes

Se o inicializador puder ser reescrito para não usar `await`, então reescreva-o:

```dart
Future<int> f() async {
  late var v = 42;
  return v;
}
```

Se o inicializador não puder ser reescrito, então remova o modificador `late`:

```dart
Future<int> f() async {
  var v = await 42;
  return v;
}
```
