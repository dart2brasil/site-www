---
title: deprecated_colon_for_default_value
description: >-
  Details about the deprecated_colon_for_default_value
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_Using a colon as the separator before a default value is deprecated and will not be supported in language version 3.0 and later._

## Descrição

O analisador produz este diagnóstico quando a colon (`:`) is used as the
separator before the default value of an optional named parameter.
While this syntax is allowed, it is deprecated in favor of
using an equal sign (`=`).

## Exemplo

O código a seguir produz este diagnóstico porque a colon is being used
before the default value of the optional parameter `i`:

```dart
void f({int i [!:!] 0}) {}
```

## Correções comuns

Replace the colon with an equal sign.

```dart
void f({int i = 0}) {}
```
