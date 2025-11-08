---
ia-translate: true
title: mixin_of_non_class
description: >-
  Detalhes sobre o diagnóstico mixin_of_non_class
  produzido pelo analisador Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_Classes só podem misturar mixins e classes._

## Description

O analisador produz este diagnóstico quando um nome em uma cláusula `with` é
definido como algo diferente de um mixin ou uma classe.

## Example

O código a seguir produz este diagnóstico porque `F` é definido como um
tipo de função:

```dart
typedef F = int Function(String);

class C with [!F!] {}
```

## Common fixes

Remova o nome inválido da lista, possivelmente substituindo-o pelo nome
do mixin ou classe pretendido:

```dart
typedef F = int Function(String);

class C {}
```
