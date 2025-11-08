---
title: abstract_field_initializer
description: >-
  Details about the abstract_field_initializer
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_Abstract fields can't have initializers._

## Descrição

O analisador produz este diagnóstico quando um campo que tem the `abstract`
modifier também tem um inicializador.

## Exemplos

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

## Correções comuns

Se o campo deve ser abstrato, remova o inicializador:

```dart
abstract class C {
  abstract int f;
}
```

Se o campo não precisa ser abstrato, remova a palavra-chave:

```dart
abstract class C {
  int f = 0;
}
```
