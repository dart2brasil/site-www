---
ia-translate: true
title: empty_record_literal_with_comma
description: "Detalhes sobre o diagnóstico empty_record_literal_with_comma produzido pelo analisador Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_Um literal de record sem campos não pode ter uma vírgula final._

## Description

O analisador produz este diagnóstico quando um literal de record que não tem
campos possui uma vírgula final. Literais de record empty não podem conter uma vírgula.

## Example

O código a seguir produz este diagnóstico porque o literal de record empty
tem uma vírgula final:

```dart
var r = ([!,!]);
```

## Common fixes

Se o record deve ser empty, então remova a vírgula:

```dart
var r = ();
```

Se o record deve ter um ou mais campos, então adicione as
expressões usadas para calcular os valores desses campos:

```dart
var r = (3, 4);
```
