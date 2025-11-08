---
title: not_a_type
description: >-
  Details about the not_a_type
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_{0} isn't a type._

## Descrição

O analisador produz este diagnóstico quando a name is used as a type but
declared to be something other than a type.

## Exemplo

O código a seguir produz este diagnóstico porque `f` is a function:

```dart
f() {}
g([!f!] v) {}
```

## Correções comuns

Replace the name with the name of a type.
