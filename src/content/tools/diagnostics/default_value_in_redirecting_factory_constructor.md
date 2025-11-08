---
title: default_value_in_redirecting_factory_constructor
description: >-
  Details about the default_value_in_redirecting_factory_constructor
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_Default values aren't allowed in factory constructors that redirect to another constructor._

## Descrição

O analisador produz este diagnóstico quando a factory constructor that
redirects to another constructor specifies a default value for an optional
parameter.

## Exemplo

O código a seguir produz este diagnóstico porque the factory constructor
in `A` has a default value for the optional parameter `x`:

```dart
class A {
  factory A([int [!x!] = 0]) = B;
}

class B implements A {
  B([int x = 1]) {}
}
```

## Correções comuns

Remove the default value from the factory construtor:

```dart
class A {
  factory A([int x]) = B;
}

class B implements A {
  B([int x = 1]) {}
}
```

Note that this fix might change the value used when the optional parameter
is omitted. If that happens, and if that change is a problem, then consider
making the optional parameter a required parameter in the factory method:

```dart
class A {
 factory A(int x) = B;
}

class B implements A {
  B([int x = 1]) {}
}
```
