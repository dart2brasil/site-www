---
title: const_constructor_with_non_const_super
description: >-
  Details about the const_constructor_with_non_const_super
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_A constant constructor can't call a non-constant super constructor of '{0}'._

## Descrição

O analisador produz este diagnóstico quando a constructor that está marcado como
`const` invokes a constructor from its superclass that isn't marked as
`const`.

## Exemplo

O código a seguir produz este diagnóstico porque the `const` constructor
in `B` invokes the constructor `nonConst` from the class `A`, and the
superclass constructor isn't um construtor `const`:

```dart
class A {
  const A();
  A.nonConst();
}

class B extends A {
  const B() : [!super.nonConst()!];
}
```

## Correções comuns

If it isn't essential to invoke the superclass constructor that is
currently being invoked, then invoke a constant constructor from the
superclass:

```dart
class A {
  const A();
  A.nonConst();
}

class B extends A {
  const B() : super();
}
```

If it's essential that the current constructor be invoked and if you can
modify it, then add `const` to the constructor in the superclass:

```dart
class A {
  const A();
  const A.nonConst();
}

class B extends A {
  const B() : super.nonConst();
}
```

If it's essential that the current constructor be invoked and you can't
modify it, then remove `const` from the constructor in the subclass:

```dart
class A {
  const A();
  A.nonConst();
}

class B extends A {
  B() : super.nonConst();
}
```
