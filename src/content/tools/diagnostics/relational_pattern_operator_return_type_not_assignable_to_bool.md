---
ia-translate: true
title: relational_pattern_operator_return_type_not_assignable_to_bool
description: >-
  Detalhes sobre o diagnóstico relational_pattern_operator_return_type_not_assignable_to_bool
  produzido pelo analisador do Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_O tipo de retorno dos operadores usados em relational patterns deve ser atribuível a 'bool'._

## Description

O analisador produz este diagnóstico quando um relational pattern referencia
um operador que não produz um valor do tipo `bool`.

## Example

O código a seguir produz este diagnóstico porque o operador `>`, usado
no relational pattern `> c2`, retorna um valor do tipo `int` em vez de
um `bool`:

```dart
class C {
  const C();

  int operator >(C c) => 3;

  bool operator <(C c) => false;
}

const C c2 = C();

void f(C c1) {
  if (c1 case [!>!] c2) {}
}
```

## Common fixes

Se existe um operador diferente que deveria ser usado, então altere o
operador:

```dart
class C {
  const C();

  int operator >(C c) => 3;

  bool operator <(C c) => false;
}

const C c2 = C();

void f(C c1) {
  if (c1 case < c2) {}
}
```

Se espera-se que o operador retorne `bool`, então atualize a declaração
do operador:

```dart
class C {
  const C();

  bool operator >(C c) => true;

  bool operator <(C c) => false;
}

const C c2 = C();

void f(C c1) {
  if (c1 case > c2) {}
}
```
