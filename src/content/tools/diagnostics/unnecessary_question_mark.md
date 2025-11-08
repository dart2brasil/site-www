---
title: unnecessary_question_mark
description: >-
  Details about the unnecessary_question_mark
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_The '?' is unnecessary because '{0}' is nullable without it._

## Descrição

O analisador produz este diagnóstico quando either the type `dynamic` or the
type `Null` is followed by a question mark. Both of these types are
inherently nullable so the question mark doesn't change the semantics.

## Exemplo

O código a seguir produz este diagnóstico porque the question mark
following `dynamic` isn't necessary:

```dart
dynamic[!?!] x;
```

## Correções comuns

Remove the unneeded question mark:

```dart
dynamic x;
```
