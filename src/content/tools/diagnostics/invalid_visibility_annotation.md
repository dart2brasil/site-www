---
ia-translate: true
title: invalid_visibility_annotation
description: "Detalhes sobre o diagnóstico invalid_visibility_annotation produzido pelo analisador do Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_O membro '{0}' está anotado com '{1}', mas esta anotação só é significativa em declarações de membros públicos._

## Description

O analisador produz este diagnóstico quando a anotação `visibleForTemplate`
ou [`visibleForTesting`][meta-visibleForTesting] é aplicada a
uma declaração não pública.

## Example

O código a seguir produz este diagnóstico:

```dart
import 'package:meta/meta.dart';

@[!visibleForTesting!]
void _someFunction() {}

void f() => _someFunction();
```

## Common fixes

Se a declaração não precisa ser usada por código de teste, então remova a
anotação:

```dart
void _someFunction() {}

void f() => _someFunction();
```

Se ela precisa, então torne-a pública:

```dart
import 'package:meta/meta.dart';

@visibleForTesting
void someFunction() {}

void f() => someFunction();
```

[meta-visibleForTesting]: https://pub.dev/documentation/meta/latest/meta/visibleForTesting-constant.html
