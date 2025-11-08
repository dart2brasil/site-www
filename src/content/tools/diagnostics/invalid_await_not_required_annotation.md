---
ia-translate: true
title: invalid_await_not_required_annotation
description: >-
  Detalhes sobre o diagnóstico invalid_await_not_required_annotation
  produzido pelo analisador do Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_A annotation 'awaitNotRequired' só pode ser aplicada a uma função que retorna Future, ou a um campo do tipo Future._

## Description

O analisador produz este diagnóstico quando algo diferente de uma função
que retorna `Future` ou um campo ou variável de nível superior do tipo
`Future` é anotado com [`awaitNotRequired`][meta-awaitNotRequired].

## Example

O código a seguir produz este diagnóstico porque a annotation está em uma
função que retorna `void`:

```dart
import 'package:meta/meta.dart';

@[!awaitNotRequired!]
void f() {}
```

## Common fixes

Remova a annotation:

```dart
void f() {}
```

[meta-awaitNotRequired]: https://pub.dev/documentation/meta/latest/meta/awaitNotRequired-constant.html
