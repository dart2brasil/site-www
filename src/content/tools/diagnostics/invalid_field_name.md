---
ia-translate: true
title: invalid_field_name
description: >-
  Detalhes sobre o diagnóstico invalid_field_name
  produzido pelo analisador do Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_Nomes de campos de record não podem ser um cifrão seguido de um inteiro quando o inteiro é o índice de um campo posicional._

_Nomes de campos de record não podem ser privados._

_Nomes de campos de record não podem ser os mesmos de um membro de 'Object'._

## Description

O analisador produz este diagnóstico quando um literal de record ou uma
annotation de tipo record tem um campo cujo nome é inválido. O nome é
inválido se ele é:
- privado (começa com `_`)
- o mesmo que um dos membros definidos em `Object`
- o mesmo que o nome de um campo posicional (uma exceção é feita se o campo
  é um campo posicional com o nome especificado)

## Examples

O código a seguir produz este diagnóstico porque o literal de record tem um
campo chamado `toString`, que é um método definido em `Object`:

```dart
var r = (a: 1, [!toString!]: 4);
```

O código a seguir produz este diagnóstico porque a annotation de tipo record
tem um campo chamado `hashCode`, que é um getter definido em `Object`:

```dart
void f(({int a, int [!hashCode!]}) r) {}
```

O código a seguir produz este diagnóstico porque o literal de record tem um
campo privado chamado `_a`:

```dart
var r = ([!_a!]: 1, b: 2);
```

O código a seguir produz este diagnóstico porque a annotation de tipo record
tem um campo privado chamado `_a`:

```dart
void f(({int [!_a!], int b}) r) {}
```

O código a seguir produz este diagnóstico porque o literal de record tem um
campo chamado `$1`, que também é o nome de um parâmetro posicional
diferente:

```dart
var r = (2, [!$1!]: 1);
```

O código a seguir produz este diagnóstico porque a annotation de tipo record
tem um campo chamado `$1`, que também é o nome de um parâmetro posicional
diferente:

```dart
void f((int, String, {int [!$1!]}) r) {}
```

## Common fixes

Renomeie o campo:

```dart
var r = (a: 1, d: 4);
```
