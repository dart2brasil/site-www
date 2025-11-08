---
ia-translate: true
title: invalid_literal_annotation
description: >-
  Detalhes sobre o diagnóstico invalid_literal_annotation
  produzido pelo analisador do Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_Apenas construtores const podem ter a annotation `@literal`._

## Description

O analisador produz este diagnóstico quando a annotation [`literal`][meta-literal]
é aplicada a algo diferente de um construtor const.

## Examples

O código a seguir produz este diagnóstico porque o construtor não é um
construtor `const`:

```dart
import 'package:meta/meta.dart';

class C {
  @[!literal!]
  C();
}
```

O código a seguir produz este diagnóstico porque `x` não é um construtor:

```dart
import 'package:meta/meta.dart';

@[!literal!]
var x;
```

## Common fixes

Se a annotation está em um construtor e o construtor deve sempre ser invocado
com `const`, quando possível, marque o construtor com a keyword `const`:

```dart
import 'package:meta/meta.dart';

class C {
  @literal
  const C();
}
```

Se o construtor não pode ser marcado como `const`, remova a annotation.

Se a annotation está em algo diferente de um construtor, remova a annotation:

```dart
var x;
```

[meta-literal]: https://pub.dev/documentation/meta/latest/meta/literal-constant.html
