---
title: deprecated_new_in_comment_reference
description: >-
  Details about the deprecated_new_in_comment_reference
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_Using the 'new' keyword in a comment reference is deprecated._

## Descrição

O analisador produz este diagnóstico quando a comment reference (the name
of a declaration enclosed in square brackets in a documentation comment)
uses the keyword `new` to refer to a constructor. This form is deprecated.

## Exemplos

O código a seguir produz este diagnóstico porque the unnamed
constructor is being referenced using `new C`:

```dart
/// See [[!new!] C].
class C {
  C();
}
```

O código a seguir produz este diagnóstico porque the constructor named
`c` is being referenced using `new C.c`:

```dart
/// See [[!new!] C.c].
class C {
  C.c();
}
```

## Correções comuns

If you're referencing a named constructor, then remove the keyword `new`:

```dart
/// See [C.c].
class C {
  C.c();
}
```

If you're referencing the unnamed constructor, then remove the keyword
`new` and append `.new` after the class name:

```dart
/// See [C.new].
class C {
  C.c();
}
```
