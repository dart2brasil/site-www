---
ia-translate: true
title: empty_record_type_named_fields_list
description: "Detalhes sobre o diagnóstico empty_record_type_named_fields_list produzido pelo analisador Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_A lista de campos nomeados em um tipo record não pode estar empty._

## Description

O analisador produz este diagnóstico quando um tipo record tem uma lista empty
de campos nomeados.

## Example

O código a seguir produz este diagnóstico porque o tipo record tem uma
lista empty de campos nomeados:

```dart
void f((int, int, {[!}!]) r) {}
```

## Common fixes

Se o record deve ter campos nomeados, então adicione os tipos e
nomes dos campos:

```dart
void f((int, int, {int z}) r) {}
```

Se o record não deve ter campos nomeados, então remova as chaves:

```dart
void f((int, int) r) {}
```
