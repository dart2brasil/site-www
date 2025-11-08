---
ia-translate: true
title: unused_result
description: >-
  Detalhes sobre o diagnóstico unused_result
  produzido pelo analisador Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_'{0}' deve ser usado. {1}._

_O valor de '{0}' deve ser usado._

## Descrição

O analisador produz este diagnóstico quando uma função anotada com
[`useResult`][meta-useResult] é invocada, e o valor retornado por essa
função não é usado. O valor é considerado usado se um membro do
valor é invocado, se o valor é passado para outra função, ou se o
valor é atribuído a uma variável ou campo.

## Exemplo

O código a seguir produz este diagnóstico porque a invocação de
`c.a()` não é usada, mesmo que o método `a` esteja anotado com
[`useResult`][meta-useResult]:

```dart
import 'package:meta/meta.dart';

class C {
  @useResult
  int a() => 0;

  int b() => 0;
}

void f(C c) {
  c.[!a!]();
}
```

## Correções comuns

Se você pretendia invocar a função anotada, então use o valor que
foi retornado:

```dart
import 'package:meta/meta.dart';

class C {
  @useResult
  int a() => 0;

  int b() => 0;
}

void f(C c) {
  print(c.a());
}
```

Se você pretendia invocar uma função diferente, então corrija o nome da
função sendo invocada:

```dart
import 'package:meta/meta.dart';

class C {
  @useResult
  int a() => 0;

  int b() => 0;
}

void f(C c) {
  c.b();
}
```

[meta-useResult]: https://pub.dev/documentation/meta/latest/meta/useResult-constant.html
