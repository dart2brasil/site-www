---
ia-translate: true
title: assignment_of_do_not_store
description: >-
  Detalhes sobre o diagnóstico assignment_of_do_not_store
  produzido pelo analisador do Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_'{0}' está marcado como 'doNotStore' e não deve ser atribuído a um campo ou variável de nível superior._

## Description

O analisador produz este diagnóstico quando o valor de uma função
(incluindo métodos e getters) que é explícita ou implicitamente marcada pela
anotação [`doNotStore`][meta-doNotStore] é armazenado em um campo
ou variável de nível superior.

## Example

O código a seguir produz este diagnóstico porque o valor da
função `f` está sendo armazenado na variável de nível superior `x`:

```dart
import 'package:meta/meta.dart';

@doNotStore
int f() => 1;

var x = [!f()!];
```

## Common fixes

Substitua referências ao campo ou variável por invocações da
função que produz o valor.

[meta-doNotStore]: https://pub.dev/documentation/meta/latest/meta/doNotStore-constant.html
