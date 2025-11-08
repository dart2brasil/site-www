---
ia-translate: true
title: invalid_visible_for_overriding_annotation
description: >-
  Detalhes sobre o diagnóstico invalid_visible_for_overriding_annotation
  produzido pelo analisador do Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_A anotação 'visibleForOverriding' só pode ser aplicada a um membro de instância público que pode sofrer override._

## Description

O analisador produz este diagnóstico quando algo diferente de um membro de
instância público de uma classe está anotado com
[`visibleForOverriding`][meta-visibleForOverriding]. Como apenas membros
de instância públicos podem ter override fora da biblioteca onde foram definidos, não há
valor em anotar quaisquer outras declarações.

## Example

O código a seguir produz este diagnóstico porque a anotação está em uma
classe, e classes não podem ter override:

```dart
import 'package:meta/meta.dart';

@[!visibleForOverriding!]
class C {}
```

## Common fixes

Remova a anotação:

```dart
class C {}
```

[meta-visibleForOverriding]: https://pub.dev/documentation/meta/latest/meta/visibleForOverriding-constant.html
