---
ia-translate: true
title: invalid_factory_method_decl
description: "Detalhes sobre o diagnóstico invalid_factory_method_decl produzido pelo analisador do Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_O método factory '{0}' deve ter um tipo de retorno._

## Description

O analisador produz este diagnóstico quando um método que é anotado com a
annotation [`factory`][meta-factory] tem um tipo de retorno `void`.

## Example

O código a seguir produz este diagnóstico porque o método `createC` é
anotado com a annotation [`factory`][meta-factory] mas não retorna nenhum
valor:

```dart
import 'package:meta/meta.dart';

class Factory {
  @factory
  void [!createC!]() {}
}

class C {}
```

## Common fixes

Altere o tipo de retorno para algo diferente de `void`:

```dart
import 'package:meta/meta.dart';

class Factory {
  @factory
  C createC() => C();
}

class C {}
```

[meta-factory]: https://pub.dev/documentation/meta/latest/meta/factory-constant.html
