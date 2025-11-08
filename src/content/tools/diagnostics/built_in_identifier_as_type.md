---
title: built_in_identifier_as_type
description: >-
  Details about the built_in_identifier_as_type
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_The built-in identifier '{0}' can't be used as a type._

## Descrição

O analisador produz este diagnóstico quando a built-in identifier is used
where a type name is expected.

## Exemplo

O código a seguir produz este diagnóstico porque `import` can't be used
as a type because it's a built-in identifier:

```dart
[!import!]<int> x;
```

## Correções comuns

Replace the built-in identifier with the name of a valid type:

```dart
List<int> x;
```
