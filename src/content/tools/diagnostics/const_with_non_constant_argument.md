---
ia-translate: true
title: const_with_non_constant_argument
description: >-
  Detalhes sobre o diagnóstico const_with_non_constant_argument
  produzido pelo analisador do Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_Arguments of a constant creation must be constant expressions._

## Descrição

O analisador produz este diagnóstico quando um constructor const é invocado
com um argumento que não é uma expressão constante.

## Exemplo

O código a seguir produz este diagnóstico porque `i` não é uma constante:

```dart
class C {
  final int i;
  const C(this.i);
}
C f(int i) => const C([!i!]);
```

## Correções comuns

Ou torne todos os argumentos expressões constantes, ou remova a
keyword `const` para usar a forma não constante do constructor:

```dart
class C {
  final int i;
  const C(this.i);
}
C f(int i) => C(i);
```
