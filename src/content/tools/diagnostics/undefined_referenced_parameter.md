---
title: undefined_referenced_parameter
description: >-
  Details about the undefined_referenced_parameter
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_The parameter '{0}' isn't defined by '{1}'._

## Descrição

O analisador produz este diagnóstico quando an annotation of the form
[`UseResult.unless(parameterDefined: parameterName)`][meta-UseResult]
specifies a parameter name that isn't defined by the annotated function.

## Exemplo

O código a seguir produz este diagnóstico porque the function `f`
doesn't have a parameter named `b`:

```dart
import 'package:meta/meta.dart';

@UseResult.unless(parameterDefined: [!'b'!])
int f([int? a]) => a ?? 0;
```

## Correções comuns

Change the argument named `parameterDefined` to match the name of one of
the parameters to the function:

```dart
import 'package:meta/meta.dart';

@UseResult.unless(parameterDefined: 'a')
int f([int? a]) => a ?? 0;
```

[meta-UseResult]: https://pub.dev/documentation/meta/latest/meta/UseResult-class.html
