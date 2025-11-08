---
ia-translate: true
title: invalid_factory_method_impl
description: "Detalhes sobre o diagnóstico invalid_factory_method_impl produzido pelo analisador do Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_O método factory '{0}' não retorna um objeto recém-alocado._

## Description

O analisador produz este diagnóstico quando um método que é anotado com a
annotation [`factory`][meta-factory] não retorna um objeto recém-alocado.

## Example

O código a seguir produz este diagnóstico porque o método `createC` retorna
o valor de um campo em vez de uma instância recém-criada de `C`:

```dart
import 'package:meta/meta.dart';

class Factory {
  C c = C();

  @factory
  C [!createC!]() => c;
}

class C {}
```

## Common fixes

Altere o método para retornar uma instância recém-criada do tipo de
retorno:

```dart
import 'package:meta/meta.dart';

class Factory {
  @factory
  C createC() => C();
}

class C {}
```

[meta-factory]: https://pub.dev/documentation/meta/latest/meta/factory-constant.html
