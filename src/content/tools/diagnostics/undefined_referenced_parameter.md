---
ia-translate: true
title: undefined_referenced_parameter
description: >-
  Detalhes sobre o diagnóstico undefined_referenced_parameter
  produzido pelo analisador Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_O parâmetro '{0}' não está definido por '{1}'._

## Descrição

O analisador produz este diagnóstico quando uma anotação da forma
[`UseResult.unless(parameterDefined: parameterName)`][meta-UseResult]
especifica um nome de parâmetro que não está definido pela função anotada.

## Exemplo

O código a seguir produz este diagnóstico porque a função `f`
não tem um parâmetro chamado `b`:

```dart
import 'package:meta/meta.dart';

@UseResult.unless(parameterDefined: [!'b'!])
int f([int? a]) => a ?? 0;
```

## Correções comuns

Mude o argumento chamado `parameterDefined` para corresponder ao nome de um dos
parâmetros da função:

```dart
import 'package:meta/meta.dart';

@UseResult.unless(parameterDefined: 'a')
int f([int? a]) => a ?? 0;
```

[meta-UseResult]: https://pub.dev/documentation/meta/latest/meta/UseResult-class.html
