---
ia-translate: true
title: const_constructor_with_field_initialized_by_non_const
description: >-
  Detalhes sobre o diagnóstico const_constructor_with_field_initialized_by_non_const
  produzido pelo analisador do Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_Can't define the 'const' constructor because the field '{0}' is initialized with a non-constant value._

## Descrição

O analisador produz este diagnóstico quando um constructor tem a keyword
`const`, mas um field na classe é inicializado com um valor não constante.

## Exemplo

O código a seguir produz este diagnóstico porque o field `s` é
inicializado com um valor não constante:

```dart
String x = '3';
class C {
  final String s = x;
  [!const!] C();
}
```

## Correções comuns

Se o field pode ser inicializado com um valor constante, então altere o
inicializador para uma expressão constante:

```dart
class C {
  final String s = '3';
  const C();
}
```

Se o field não pode ser inicializado com um valor constante, então remova a
keyword `const` do constructor:

```dart
String x = '3';
class C {
  final String s = x;
  C();
}
```
