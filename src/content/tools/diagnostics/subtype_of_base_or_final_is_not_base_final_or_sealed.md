---
title: subtype_of_base_or_final_is_not_base_final_or_sealed
description: >-
  Details about the subtype_of_base_or_final_is_not_base_final_or_sealed
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_The mixin '{0}' must be 'base' because the supertype '{1}' is 'base'._

_The mixin '{0}' must be 'base' because the supertype '{1}' is 'final'._

_The type '{0}' must be 'base', 'final' or 'sealed' because the supertype '{1}' is 'base'._

_The type '{0}' must be 'base', 'final' or 'sealed' because the supertype '{1}' is 'final'._

## Descrição

O analisador produz este diagnóstico quando a class or mixin has a direct
or indirect supertype that is either `base` or `final`, but the class or
mixin itself isn't marked either `base`, `final`, or `sealed`.

## Exemplo

O código a seguir produz este diagnóstico porque a classe `B` is a
subtype of `A`, and `A` is a `base` class, but `B` is neither `base`,
`final` or `sealed`:

```dart
base class A {}
class [!B!] extends A {}
```

## Correções comuns

Add either `base`, `final` or `sealed` à classe or mixin declaration:

```dart
base class A {}
final class B extends A {}
```
