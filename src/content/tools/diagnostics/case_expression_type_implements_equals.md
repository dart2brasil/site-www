---
title: case_expression_type_implements_equals
description: >-
  Details about the case_expression_type_implements_equals
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_The switch case expression type '{0}' can't override the '==' operator._

## Descrição

O analisador produz este diagnóstico quando the type of the expression
following the keyword `case` has an implementation of the `==` operator
other than the one in `Object`.

## Exemplo

O código a seguir produz este diagnóstico porque the expression
following the keyword `case` (`C(0)`) has the type `C`, and the class `C`
overrides the `==` operator:

```dart
class C {
  final int value;

  const C(this.value);

  bool operator ==(Object other) {
    return false;
  }
}

void f(C c) {
  switch (c) {
    case [!C(0)!]:
      break;
  }
}
```

## Correções comuns

If there isn't a strong reason not to do so, then rewrite the code to use
an if-else structure:

```dart
class C {
  final int value;

  const C(this.value);

  bool operator ==(Object other) {
    return false;
  }
}

void f(C c) {
  if (c == C(0)) {
    // ...
  }
}
```

If you can't rewrite the switch statement and the implementation of `==`
isn't necessary, then remove it:

```dart
class C {
  final int value;

  const C(this.value);
}

void f(C c) {
  switch (c) {
    case C(0):
      break;
  }
}
```

If you can't rewrite the switch statement and you can't remove the
definition of `==`, then find some other value that can be used to control
the switch:

```dart
class C {
  final int value;

  const C(this.value);

  bool operator ==(Object other) {
    return false;
  }
}

void f(C c) {
  switch (c.value) {
    case 0:
      break;
  }
}
```
