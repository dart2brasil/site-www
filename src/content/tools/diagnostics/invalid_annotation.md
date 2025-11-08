---
title: invalid_annotation
description: >-
  Details about the invalid_annotation
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_Annotation must be either a const variable reference or const constructor invocation._

## Descrição

O analisador produz este diagnóstico quando an annotation is found that is
using something that is neither a variable marked as `const` or the
invocation of a `const` constructor.

Getters can't be used as annotations.

## Exemplos

O código a seguir produz este diagnóstico porque the variable `v` isn't
a `const` variable:

```dart
var v = 0;

[!@v!]
void f() {
}
```

O código a seguir produz este diagnóstico porque `f` isn't a variable:

```dart
[!@f!]
void f() {
}
```

O código a seguir produz este diagnóstico porque `f` isn't a
constructor:

```dart
[!@f()!]
void f() {
}
```

O código a seguir produz este diagnóstico porque `g` is a getter:

```dart
[!@g!]
int get g => 0;
```

## Correções comuns

If the annotation is referencing a variable that isn't a `const`
constructor, add the keyword `const` to the variable's declaration:

```dart
const v = 0;

@v
void f() {
}
```

If the annotation isn't referencing a variable, then remove it:

```dart
int v = 0;

void f() {
}
```
