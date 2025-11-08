---
ia-translate: true
title: invalid_super_formal_parameter_location
description: >-
  Detalhes sobre o diagnóstico invalid_super_formal_parameter_location
  produzido pelo analisador do Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_Parâmetros super só podem ser usados em construtores generativos que não redirecionam._

## Description

O analisador produz este diagnóstico quando um parâmetro super é usado
em qualquer lugar que não seja um construtor generativo que não redireciona.

## Examples

O código a seguir produz este diagnóstico porque o parâmetro super
`x` está em um construtor generativo que redireciona:

```dart
class A {
  A(int x);
}

class B extends A {
  B.b([!super!].x) : this._();
  B._() : super(0);
}
```

O código a seguir produz este diagnóstico porque o parâmetro super
`x` não está em um construtor generativo:

```dart
class A {
  A(int x);
}

class C extends A {
  factory C.c([!super!].x) => C._();
  C._() : super(0);
}
```

O código a seguir produz este diagnóstico porque o parâmetro super
`x` está em um método:

```dart
class A {
  A(int x);
}

class D extends A {
  D() : super(0);

  void m([!super!].x) {}
}
```

## Common fixes

Se a função que contém o parâmetro super pode ser alterada para ser um
construtor generativo que não redireciona, então faça isso:

```dart
class A {
  A(int x);
}

class B extends A {
  B.b(super.x);
}
```

Se a função que contém o parâmetro super não pode ser alterada para ser um
construtor generativo que não redireciona, então remova o `super`:

```dart
class A {
  A(int x);
}

class D extends A {
  D() : super(0);

  void m(int x) {}
}
```
