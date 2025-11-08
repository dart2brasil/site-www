---
title: mixin_application_not_implemented_interface
description: >-
  Details about the mixin_application_not_implemented_interface
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_'{0}' can't be mixed onto '{1}' because '{1}' doesn't implement '{2}'._

## Descrição

O analisador produz este diagnóstico quando a mixin that has a superclass
constraint is used in a [mixin application][] with a superclass that
doesn't implement the required constraint.

## Exemplo

O código a seguir produz este diagnóstico porque the mixin `M` requires
that the class to which it's applied be a subclass of `A`, but `Object`
isn't a subclass of `A`:

```dart
class A {}

mixin M on A {}

class X = Object with [!M!];
```

## Correções comuns

If you need to use the mixin, then change the superclass to be either the
same as or a subclass of the superclass constraint:

```dart
class A {}

mixin M on A {}

class X = A with M;
```

[mixin application]: /resources/glossary#mixin-application
