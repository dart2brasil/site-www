---
title: deprecated_field
description: >-
  Details about the deprecated_field
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_The '{0}' field is no longer used and can be removed._

## Descrição

O analisador produz este diagnóstico quando a key is used in a
`pubspec.yaml` file that was deprecated. Unused keys take up space and
might imply semantics that are no longer valid.

## Exemplo

O código a seguir produz este diagnóstico porque the `author` key is no
longer being used:

```dart
name: example
author: 'Dash'
```

## Correções comuns

Remove the deprecated key:

```dart
name: example
```
