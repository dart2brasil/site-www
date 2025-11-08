---
title: super_formal_parameter_type_is_not_subtype_of_associated
description: >-
  Details about the super_formal_parameter_type_is_not_subtype_of_associated
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_The type '{0}' of this parameter isn't a subtype of the type '{1}' of the associated super constructor parameter._

## Descrição

O analisador produz este diagnóstico quando the type of a super parameter
isn't a subtype of the corresponding parameter from the super constructor.

## Exemplo

O código a seguir produz este diagnóstico porque the type of the super
parameter `x` no construtor for `B` isn't a subtype of the parameter
`x` no construtor for `A`:

```dart
class A {
  A(num x);
}

class B extends A {
  B(String super.[!x!]);
}
```

## Correções comuns

If the type of the super parameter can be the same as the parameter from
the super constructor, then remove the type annotation from the super
parameter (if the type is implicit, it is inferred from the type in the
super constructor):

```dart
class A {
  A(num x);
}

class B extends A {
  B(super.x);
}
```

If the type of the super parameter can be a subtype of the corresponding
parameter's type, then change the type of the super parameter:

```dart
class A {
  A(num x);
}

class B extends A {
  B(int super.x);
}
```

If the type of the super parameter can't be changed, then use a normal
parameter instead of a super parameter:

```dart
class A {
  A(num x);
}

class B extends A {
  B(String x) : super(x.length);
}
```
