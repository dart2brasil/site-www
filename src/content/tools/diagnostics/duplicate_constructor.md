---
ia-translate: true
title: duplicate_constructor
description: >-
  Detalhes sobre o diagnóstico duplicate_constructor
  produzido pelo analisador Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_O construtor com nome '{0}' já está definido._

_O construtor sem nome já está definido._

## Description

O analisador produz este diagnóstico quando uma classe declara mais de um
construtor sem nome ou quando declara mais de um construtor com o
mesmo nome.

## Examples

O código a seguir produz este diagnóstico porque há duas
declarações para o construtor sem nome:

```dart
class C {
  C();

  [!C!]();
}
```

O código a seguir produz este diagnóstico porque há duas
declarações para o construtor nomeado `m`:

```dart
class C {
  C.m();

  [!C.m!]();
}
```

## Common fixes

Se há múltiplos construtores sem nome e todos os construtores são
necessários, então dê a todos eles, ou a todos exceto um deles, um nome:

```dart
class C {
  C();

  C.n();
}
```

Se há múltiplos construtores sem nome e todos exceto um deles são
desnecessários, então remova os construtores que não são necessários:

```dart
class C {
  C();
}
```

Se há múltiplos construtores nomeados e todos os construtores são
necessários, então renomeie todos exceto um deles:

```dart
class C {
  C.m();

  C.n();
}
```

Se há múltiplos construtores nomeados e todos exceto um deles são
desnecessários, então remova os construtores que não são necessários:

```dart
class C {
  C.m();
}
```
