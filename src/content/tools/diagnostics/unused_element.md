---
title: unused_element
description: >-
  Details about the unused_element
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_The declaration '{0}' isn't referenced._

## Descrição

O analisador produz este diagnóstico quando a private declaration isn't
referenced in the library that contains the declaration. The following
kinds of declarations are analyzed:
- Private top-level declarations and all of their members
- Private members of public declarations

Not all references to an element will mark it as "used":
- Assigning a value to a top-level variable (with a standard `=`
  assignment, or a null-aware `??=` assignment) does not count as using
  it.
- Referring to an element in a doc comment reference does not count as
  using it.
- Referring to a class, mixin, or enum on the right side of an `is`
  expression does not count as using it.

## Exemplo

Assuming that no code in the library references `_C`, the following code
produces this diagnostic:

```dart
class [!_C!] {}
```

## Correções comuns

If the declaration isn't needed, then remove it.

If the declaration is intended to be used, then add the code to use it.
