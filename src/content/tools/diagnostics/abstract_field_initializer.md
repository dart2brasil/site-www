---
ia-translate: true
title: abstract_field_initializer
description: >-
  Detalhes sobre o diagnóstico abstract_field_initializer
  produzido pelo analisador do Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_Abstract fields can't have initializers._

## Description

O analisador produz este diagnóstico quando um campo que tem o modificador `abstract`
também possui um inicializador.

## Examples

O código a seguir produz este diagnóstico porque `f` está marcado como
`abstract` e tem um inicializador:

```dart
abstract class C {
  abstract int [!f!] = 0;
}
```

O código a seguir produz este diagnóstico porque `f` está marcado como
`abstract` e há um inicializador no construtor:

```dart
abstract class C {
  abstract int f;

  C() : [!f!] = 0;
}
```

## Common fixes

Se o campo deve ser abstract, então remova o inicializador:

```dart
abstract class C {
  abstract int f;
}
```

Se o campo não precisa ser abstract, então remova a keyword:

```dart
abstract class C {
  int f = 0;
}
```
