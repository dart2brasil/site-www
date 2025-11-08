---
ia-translate: true
title: return_of_do_not_store
description: >-
  Detalhes sobre o diagnóstico return_of_do_not_store
  produzido pelo analisador Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_'{0}' está anotado com 'doNotStore' e não deve ser retornado a menos que '{1}' também esteja anotado._

## Description

O analisador produz este diagnóstico quando um valor que está anotado com
a anotação [`doNotStore`][meta-doNotStore] é retornado de um método,
getter ou função que não tem a mesma anotação.

## Example

O código a seguir produz este diagnóstico porque o resultado de invocar
`f` não deve ser armazenado, mas a função `g` não está anotada para preservar
essa semântica:

```dart
import 'package:meta/meta.dart';

@doNotStore
int f() => 0;

int g() => [!f()!];
```

## Common fixes

Se o valor que não deve ser armazenado é o valor correto a retornar, então
marque a função com a anotação [`doNotStore`][meta-doNotStore]:

```dart
import 'package:meta/meta.dart';

@doNotStore
int f() => 0;

@doNotStore
int g() => f();
```

Caso contrário, retorne um valor diferente da função:

```dart
import 'package:meta/meta.dart';

@doNotStore
int f() => 0;

int g() => 0;
```

[meta-doNotStore]: https://pub.dev/documentation/meta/latest/meta/doNotStore-constant.html
