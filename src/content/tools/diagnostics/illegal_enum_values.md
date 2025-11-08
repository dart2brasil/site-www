---
ia-translate: true
title: illegal_enum_values
description: >-
  Detalhes sobre o diagnóstico illegal_enum_values
  produzido pelo analisador do Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_Um membro de instância chamado 'values' não pode ser declarado em uma classe que implementa 'Enum'._

_Um membro de instância chamado 'values' não pode ser herdado de '{0}' em uma classe que implementa 'Enum'._

## Description

O analisador produz este diagnóstico quando uma classe que implementa
`Enum` ou um mixin com uma restrição de superclasse de `Enum` possui um membro de
instância chamado `values`.

## Examples

O código a seguir produz este diagnóstico porque a classe `C`, que
implementa `Enum`, declara um campo de instância chamado `values`:

```dart
abstract class C implements Enum {
  int get [!values!] => 0;
}
```

O código a seguir produz este diagnóstico porque a classe `B`, que
implementa `Enum`, herda um método de instância chamado `values` de `A`:

```dart
abstract class A {
  int values() => 0;
}

abstract class [!B!] extends A implements Enum {}
```

## Common fixes

Altere o nome do membro conflitante:

```dart
abstract class C implements Enum {
  int get value => 0;
}
```
