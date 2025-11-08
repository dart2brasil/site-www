---
title: redirect_generative_to_missing_constructor
description: >-
  Details about the redirect_generative_to_missing_constructor
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_The constructor '{0}' couldn't be found in '{1}'._

## Descrição

O analisador produz este diagnóstico quando a generative constructor
redirects to a constructor that isn't defined.

## Exemplo

O código a seguir produz este diagnóstico porque the constructor `C.a`
redirects to the constructor `C.b`, but `C.b` isn't defined:

```dart
class C {
  C.a() : [!this.b()!];
}
```

## Correções comuns

If the missing constructor must be called, then define it:

```dart
class C {
  C.a() : this.b();
  C.b();
}
```

If the missing constructor doesn't need to be called, then remove the
redirect:

```dart
class C {
  C.a();
}
```
