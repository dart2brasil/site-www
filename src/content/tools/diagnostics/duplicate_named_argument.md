---
ia-translate: true
title: duplicate_named_argument
description: >-
  Detalhes sobre o diagnóstico duplicate_named_argument
  produzido pelo analisador Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_O argumento para o parâmetro nomeado '{0}' já foi especificado._

## Description

O analisador produz este diagnóstico quando uma invocação tem dois ou mais
argumentos nomeados que têm o mesmo nome.

## Example

O código a seguir produz este diagnóstico porque há dois argumentos
com o nome `a`:

```dart
void f(C c) {
  c.m(a: 0, [!a!]: 1);
}

class C {
  void m({int? a, int? b}) {}
}
```

## Common fixes

Se um dos argumentos deve ter um nome diferente, então mude o nome:

```dart
void f(C c) {
  c.m(a: 0, b: 1);
}

class C {
  void m({int? a, int? b}) {}
}
```

Se um dos argumentos está errado, então remova-o:

```dart
void f(C c) {
  c.m(a: 1);
}

class C {
  void m({int? a, int? b}) {}
}
```
