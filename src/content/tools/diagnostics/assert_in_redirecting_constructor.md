---
ia-translate: true
title: assert_in_redirecting_constructor
description: >-
  Detalhes sobre o diagnóstico assert_in_redirecting_constructor
  produzido pelo analisador Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_A redirecting constructor can't have an 'assert' initializer._

## Description

O analisador produz este diagnóstico quando um construtor de redirecionamento (um
construtor que redireciona para outro construtor na mesma classe) tem um
assert na lista de inicializadores.

## Example

O código a seguir produz este diagnóstico porque o construtor sem nome
é um construtor de redirecionamento e também tem um assert na lista de
inicializadores:

```dart
class C {
  C(int x) : [!assert(x > 0)!], this.name();
  C.name() {}
}
```

## Common fixes

Se o assert não é necessário, então remova-o:

```dart
class C {
  C(int x) : this.name();
  C.name() {}
}
```

Se o assert é necessário, então converta o construtor em um construtor
factory:

```dart
class C {
  factory C(int x) {
    assert(x > 0);
    return C.name();
  }
  C.name() {}
}
```
