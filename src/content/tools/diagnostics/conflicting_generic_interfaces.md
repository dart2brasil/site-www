---
ia-translate: true
title: conflicting_generic_interfaces
description: "Detalhes sobre o diagnóstico conflicting_generic_interfaces produzido pelo analisador do Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_O {0} '{1}' não pode implementar tanto '{2}' quanto '{3}' porque os argumentos de tipo são diferentes._

## Descrição

O analisador produz este diagnóstico quando uma classe tenta implementar uma
interface genérica várias vezes, e os valores dos argumentos de tipo
não são os mesmos.

## Exemplo

O código a seguir produz este diagnóstico porque `C` é definida para
implementar tanto `I<int>` (porque estende `A`) quanto `I<String>` (porque
implementa `B`), mas `int` e `String` não são o mesmo tipo:

```dart
class I<T> {}
class A implements I<int> {}
class B implements I<String> {}
class [!C!] extends A implements B {}
```

## Correções comuns

Refaça a hierarquia de tipos para evitar esta situação. Por exemplo, você pode
tornar um ou ambos os tipos herdados genéricos para que `C` possa especificar o
mesmo tipo para ambos os argumentos de tipo:

```dart
class I<T> {}
class A<S> implements I<S> {}
class B implements I<String> {}
class C extends A<String> implements B {}
```
