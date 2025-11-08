---
title: field_initializer_redirecting_constructor
description: >-
  Details about the field_initializer_redirecting_constructor
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_The redirecting constructor can't have a field initializer._

## Descrição

O analisador produz este diagnóstico quando a redirecting constructor
initializes a field in the object. This isn't allowed because the instance
that has the field hasn't been created at the point at which it should be
initialized.

## Exemplos

O código a seguir produz este diagnóstico porque the constructor
`C.zero`, which redirects to the constructor `C`, has an initializing
formal parameter that initializes the field `f`:

```dart
class C {
  int f;

  C(this.f);

  C.zero([!this.f!]) : this(f);
}
```

O código a seguir produz este diagnóstico porque the constructor
`C.zero`, which redirects to the constructor `C`, has an initializer that
initializes the field `f`:

```dart
class C {
  int f;

  C(this.f);

  C.zero() : [!f = 0!], this(1);
}
```

## Correções comuns

If the initialization is done by an initializing formal parameter, then
use a normal parameter:

```dart
class C {
  int f;

  C(this.f);

  C.zero(int f) : this(f);
}
```

If the initialization is done in an initializer, then remove the
initializer:

```dart
class C {
  int f;

  C(this.f);

  C.zero() : this(0);
}
```
