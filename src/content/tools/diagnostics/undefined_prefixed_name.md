---
title: undefined_prefixed_name
description: >-
  Details about the undefined_prefixed_name
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_The name '{0}' is being referenced through the prefix '{1}', but it isn't defined in any of the libraries imported using that prefix._

## Descrição

O analisador produz este diagnóstico quando a prefixed identifier is found
where the prefix is valid, but the identifier isn't declared in any of the
libraries imported using that prefix.

## Exemplo

O código a seguir produz este diagnóstico porque `dart:core` doesn't
define anything named `a`:

```dart
import 'dart:core' as p;

void f() {
  p.[!a!];
}
```

## Correções comuns

If the library in which the name is declared isn't imported yet, add an
import for the library.

If the name is wrong, then change it to one of the names that's declared in
the imported libraries.
