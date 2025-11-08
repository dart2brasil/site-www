---
ia-translate: true
title: non_const_call_to_literal_constructor
description: >-
  Detalhes sobre o diagnóstico non_const_call_to_literal_constructor
  produzido pelo analisador do Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_This instance creation must be 'const', because the {0} constructor is marked as '@literal'._

## Description

O analisador produz este diagnóstico quando um construtor que possui a
annotation [`literal`][meta-literal] é invocado sem usar a keyword `const`,
mas todos os argumentos do construtor são constantes. A
annotation indica que o construtor deve ser usado para criar um
valor constante sempre que possível.

## Example

O código a seguir produz este diagnóstico:

```dart
import 'package:meta/meta.dart';

class C {
  @literal
  const C();
}

C f() => [!C()!];
```

## Common fixes

Adicione a keyword `const` antes da invocação do construtor:

```dart
import 'package:meta/meta.dart';

class C {
  @literal
  const C();
}

void f() => const C();
```

[meta-literal]: https://pub.dev/documentation/meta/latest/meta/literal-constant.html
