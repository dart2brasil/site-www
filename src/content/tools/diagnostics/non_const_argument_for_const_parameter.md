---
ia-translate: true
title: non_const_argument_for_const_parameter
description: "Detalhes sobre o diagnóstico non_const_argument_for_const_parameter produzido pelo analisador do Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_Argument '{0}' must be a constant._

## Description

O analisador produz este diagnóstico quando um parâmetro é
anotado com a annotation [`mustBeConst`][meta-mustBeConst] e
o argumento correspondente não é uma expressão constante.

## Example

O código a seguir produz este diagnóstico na invocação da
função `f` porque o valor do argumento passado para a
função `g` não é uma constante:

```dart
import 'package:meta/meta.dart' show mustBeConst;

int f(int value) => g([!value!]);

int g(@mustBeConst int value) => value + 1;
```

## Common fixes

Se uma constante adequada está disponível para uso, então substitua o argumento
por uma constante:

```dart
import 'package:meta/meta.dart' show mustBeConst;

const v = 3;

int f() => g(v);

int g(@mustBeConst int value) => value + 1;
```

[meta-mustBeConst]: https://pub.dev/documentation/meta/latest/meta/mustBeConst-constant.html
