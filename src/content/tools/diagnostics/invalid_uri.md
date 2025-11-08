---
title: invalid_uri
description: >-
  Details about the invalid_uri
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_Invalid URI syntax: '{0}'._

## Descrição

O analisador produz este diagnóstico quando a URI in a directive doesn't
conform to the syntax of a valid URI.

## Exemplo

O código a seguir produz este diagnóstico porque `'#'` isn't a valid
URI:

```dart
import [!'#'!];
```

## Correções comuns

Replace the invalid URI with a valid URI.
