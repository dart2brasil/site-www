---
ia-translate: true
title: return_in_generative_constructor
description: "Detalhes sobre o diagnóstico return_in_generative_constructor produzido pelo analisador Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_Construtores não podem retornar valores._

## Description

O analisador produz este diagnóstico quando um construtor generativo
contém uma instrução `return` que especifica um valor a ser retornado.
Construtores generativos sempre retornam o objeto que foi criado e,
portanto, não podem retornar um objeto diferente.

## Example

O código a seguir produz este diagnóstico porque a instrução `return`
tem uma expressão:

```dart
class C {
  C() {
    return [!this!];
  }
}
```

## Common fixes

Se o construtor deve criar uma nova instância, remova a
instrução `return` ou a expressão:

```dart
class C {
  C();
}
```

Se o construtor não deve criar uma nova instância, converta-o para um
construtor factory:

```dart
class C {
  factory C() {
    return _instance;
  }

  static C _instance = C._();

  C._();
}
```
