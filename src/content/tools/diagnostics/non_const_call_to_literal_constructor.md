---
title: non_const_call_to_literal_constructor
description: >-
  Details about the non_const_call_to_literal_constructor
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_This instance creation must be 'const', because the {0} constructor is marked as '@literal'._

## Descrição

O analisador produz este diagnóstico quando a constructor that has the
[`literal`][meta-literal] annotation is invoked without using the `const`
keyword, but all of the arguments to the constructor are constants. The
annotation indicates that the constructor should be used to create a
constant value whenever possible.

## Exemplo

The following code produces this diagnostic:

```dart
import 'package:meta/meta.dart';

class C {
  @literal
  const C();
}

C f() => [!C()!];
```

## Correções comuns

Add the keyword `const` before the constructor invocation:

```dart
import 'package:meta/meta.dart';

class C {
  @literal
  const C();
}

void f() => const C();
```

[meta-literal]: https://pub.dev/documentation/meta/latest/meta/literal-constant.html
