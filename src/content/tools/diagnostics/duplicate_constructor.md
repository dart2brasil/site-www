---
title: duplicate_constructor
description: >-
  Details about the duplicate_constructor
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_The constructor with name '{0}' is already defined._

_The unnamed constructor is already defined._

## Descrição

O analisador produz este diagnóstico quando a class declares more than one
unnamed constructor or when it declares more than one constructor with the
same name.

## Exemplos

O código a seguir produz este diagnóstico porque há duas
declarations for the unnamed construtor:

```dart
class C {
  C();

  [!C!]();
}
```

O código a seguir produz este diagnóstico porque há duas
declarations for the constructor named `m`:

```dart
class C {
  C.m();

  [!C.m!]();
}
```

## Correções comuns

If there are multiple unnamed constructors and all of the constructors are
needed, then give all of them, or all except one of them, a name:

```dart
class C {
  C();

  C.n();
}
```

If there are multiple unnamed constructors and all except one of them are
unneeded, then remove the constructors that aren't needed:

```dart
class C {
  C();
}
```

If there are multiple named constructors and all of the constructors are
needed, then rename all except one of them:

```dart
class C {
  C.m();

  C.n();
}
```

If there are multiple named constructors and all except one of them are
unneeded, then remove the constructors that aren't needed:

```dart
class C {
  C.m();
}
```
