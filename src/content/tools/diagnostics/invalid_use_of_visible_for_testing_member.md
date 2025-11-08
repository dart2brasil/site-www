---
ia-translate: true
title: invalid_use_of_visible_for_testing_member
description: >-
  Detalhes sobre o diagnóstico invalid_use_of_visible_for_testing_member
  produzido pelo analisador do Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_O membro '{0}' só pode ser usado dentro de '{1}' ou de um teste._

## Description

O analisador produz este diagnóstico quando um membro anotado com
`@visibleForTesting` é referenciado em qualquer lugar que não seja a biblioteca em
que foi declarado ou em uma biblioteca no diretório `test`.

## Example

Dado um arquivo `c.dart` que contém o seguinte:

```dart
import 'package:meta/meta.dart';

class C {
  @visibleForTesting
  void m() {}
}
```

O código a seguir, quando não está dentro do diretório `test`, produz este
diagnóstico porque o método `m` está marcado como sendo visível apenas para
testes:

```dart
import 'c.dart';

void f(C c) {
  c.[!m!]();
}
```

## Common fixes

Se o membro anotado não deve ser referenciado fora de testes, então
remova a referência:

```dart
import 'c.dart';

void f(C c) {}
```

Se é permitido referenciar o membro anotado fora de testes, então remova
a anotação:

```dart
class C {
  void m() {}
}
```
