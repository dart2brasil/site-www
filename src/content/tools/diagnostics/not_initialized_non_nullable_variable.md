---
ia-translate: true
title: not_initialized_non_nullable_variable
description: >-
  Detalhes sobre o diagnóstico not_initialized_non_nullable_variable
  produzido pelo analisador do Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_The non-nullable variable '{0}' must be initialized._

## Description

O analisador produz este diagnóstico quando um campo static ou variável
top-level possui um tipo que é non-nullable e não possui um inicializador.
Campos e variáveis que não possuem um inicializador são normalmente
inicializados para `null`, mas o tipo do campo ou variável não permite
que seja definido como `null`, então um inicializador explícito deve ser fornecido.

## Examples

O código a seguir produz este diagnóstico porque o campo `f` não pode ser
inicializado para `null`:

```dart
class C {
  static int [!f!];
}
```

Similarmente, o código a seguir produz este diagnóstico porque a
variável top-level `v` não pode ser inicializada para `null`:

```dart
int [!v!];
```

## Common fixes

Se o campo ou variável não pode ser inicializado para `null`, então adicione um
inicializador que o defina como um valor non-null:

```dart
class C {
  static int f = 0;
}
```

Se o campo ou variável deveria ser inicializado para `null`, então mude o
tipo para ser nullable:

```dart
int? v;
```

Se o campo ou variável não pode ser inicializado na declaração mas será
sempre inicializado antes de ser referenciado, então marque-o como `late`:

```dart
class C {
  static late int f;
}
```
