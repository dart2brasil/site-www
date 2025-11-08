---
ia-translate: true
title: values_declaration_in_enum
description: "Detalhes sobre o diagnóstico values_declaration_in_enum produzido pelo analisador do Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_Um membro chamado 'values' não pode ser declarado em um enum._

## Description

O analisador produz este diagnóstico quando uma declaração enum define um
membro chamado `values`, seja o membro um valor enum, um membro de
instância ou um membro estático.

Qualquer membro desse tipo entra em conflito com a declaração implícita do
getter estático chamado `values` que retorna uma lista contendo todas as
constantes enum.

## Example

O código a seguir produz este diagnóstico porque o enum `E` define
um membro de instância chamado `values`:

```dart
enum E {
  v;
  void [!values!]() {}
}
```

## Common fixes

Altere o nome do membro em conflito:

```dart
enum E {
  v;
  void getValues() {}
}
```
