---
title: redirect_to_non_const_constructor
description: >-
  Details about the redirect_to_non_const_constructor
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_A constant redirecting constructor can't redirect to a non-constant constructor._

## Descrição

O analisador produz este diagnóstico quando a constructor marked as `const`
redirects to a constructor that isn't marked as `const`.

## Exemplo

O código a seguir produz este diagnóstico porque the constructor `C.a`
está marcado como `const` but redirects to the constructor `C.b`, which isn't:

```dart
class C {
  const C.a() : this.[!b!]();
  C.b();
}
```

## Correções comuns

If the non-constant constructor can be marked as `const`, then mark it as
`const`:

```dart
class C {
  const C.a() : this.b();
  const C.b();
}
```

If the non-constant constructor can't be marked as `const`, then either
remove the redirect or remove `const` from the redirecting construtor:

```dart
class C {
  C.a() : this.b();
  C.b();
}
```
