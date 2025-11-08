---
ia-translate: true
title: empty_record_type_with_comma
description: "Detalhes sobre o diagnóstico empty_record_type_with_comma produzido pelo analisador Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_Um tipo record sem campos não pode ter uma vírgula final._

## Description

O analisador produz este diagnóstico quando um tipo record que não tem
campos possui uma vírgula final. Tipos de record empty não podem conter uma vírgula.

## Example

O código a seguir produz este diagnóstico porque o tipo record empty
tem uma vírgula final:

```dart
void f(([!,!]) r) {}
```

## Common fixes

Se o tipo record deve ser empty, então remova a vírgula:

```dart
void f(() r) {}
```

Se o tipo record deve ter um ou mais campos, então adicione os
tipos desses campos:

```dart
void f((int, int) r) {}
```
