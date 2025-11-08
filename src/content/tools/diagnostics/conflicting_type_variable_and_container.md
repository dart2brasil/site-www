---
title: conflicting_type_variable_and_container
description: >-
  Details about the conflicting_type_variable_and_container
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_'{0}' can't be used to name both a type parameter and the class in which the type parameter is defined._

_'{0}' can't be used to name both a type parameter and the enum in which the type parameter is defined._

_'{0}' can't be used to name both a type parameter and the extension in which the type parameter is defined._

_'{0}' can't be used to name both a type parameter and the extension type in which the type parameter is defined._

_'{0}' can't be used to name both a type parameter and the mixin in which the type parameter is defined._

## Descrição

O analisador produz este diagnóstico quando a class, mixin, or extension
declaration declares a type parameter with the same name as the class,
mixin, or extension that declares it.

## Exemplo

O código a seguir produz este diagnóstico porque the type parameter `C`
has the same name as the class `C` of which it's a part:

```dart
class C<[!C!]> {}
```

## Correções comuns

Rename either the type parameter, or the class, mixin, or extension:

```dart
class C<T> {}
```
