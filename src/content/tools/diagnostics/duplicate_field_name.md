---
ia-translate: true
title: duplicate_field_name
description: >-
  Detalhes sobre o diagnóstico duplicate_field_name
  produzido pelo analisador Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_O nome do campo '{0}' já está sendo usado neste record._

## Description

O analisador produz este diagnóstico quando um literal de record ou uma
anotação de tipo record contém um campo cujo nome é o mesmo de um
campo declarado anteriormente no mesmo literal ou tipo.

## Examples

O código a seguir produz este diagnóstico porque o literal de record tem
dois campos nomeados `a`:

```dart
var r = (a: 1, [!a!]: 2);
```

O código a seguir produz este diagnóstico porque a anotação de tipo record
tem dois campos nomeados `a`, um campo posicional e outro
um campo nomeado:

```dart
void f((int a, {int [!a!]}) r) {}
```

## Common fixes

Renomeie um ou ambos os campos:

```dart
var r = (a: 1, b: 2);
```
