---
ia-translate: true
title: relational_pattern_operand_type_not_assignable
description: "Detalhes sobre o diagnóstico relational_pattern_operand_type_not_assignable produzido pelo analisador do Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_O tipo da expressão constante '{0}' não é atribuível ao tipo do parâmetro '{1}' do operador '{2}'._

## Description

O analisador produz este diagnóstico quando o operando de um relational
pattern tem um tipo que não é atribuível ao parâmetro do operador
que será invocado.

## Example

O código a seguir produz este diagnóstico porque o operando no
relational pattern (`0`) é um `int`, mas o operador `>` definido em `C`
espera um objeto do tipo `C`:

```dart
class C {
  const C();

  bool operator >(C other) => true;
}

void f(C c) {
  switch (c) {
    case > [!0!]:
      print('positive');
  }
}
```

## Common fixes

Se o switch está usando o valor correto, então altere o case para comparar
o valor com o tipo correto de objeto:

```dart
class C {
  const C();

  bool operator >(C other) => true;
}

void f(C c) {
  switch (c) {
    case > const C():
      print('positive');
  }
}
```

Se o switch está usando o valor errado, então altere a expressão usada para
calcular o valor sendo comparado:

```dart
class C {
  const C();

  bool operator >(C other) => true;

  int get toInt => 0;
}

void f(C c) {
  switch (c.toInt) {
    case > 0:
      print('positive');
  }
}
```
