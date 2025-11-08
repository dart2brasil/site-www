---
title: invalid_annotation_constant_value_from_deferred_library
description: >-
  Details about the invalid_annotation_constant_value_from_deferred_library
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_Constant values from a deferred library can't be used in annotations._

## Descrição

O analisador produz este diagnóstico quando a constant defined in a library
that is imported as a deferred library is referenced in the argument list
of an annotation. Annotations are evaluated at compile time, and values
from deferred libraries aren't available at compile time.

For more information, check out
[Lazily loading a library](https://dart.dev/language/libraries#lazily-loading-a-library).

## Exemplo

O código a seguir produz este diagnóstico porque the constant `pi` is
being referenced in the argument list of an annotation, even though the
library that defines it is being imported as a deferred library:

```dart
import 'dart:math' deferred as math;

class C {
  const C(double d);
}

@C(math.[!pi!])
void f () {}
```

## Correções comuns

If you need to reference the imported constant, then remove the `deferred`
keyword:

```dart
import 'dart:math' as math;

class C {
  const C(double d);
}

@C(math.pi)
void f () {}
```

If the import is required to be deferred and there's another constant that
is appropriate, then use that constant in place of the constant from the
deferred library.
