---
ia-translate: true
title: subtype_of_sealed_class
description: "Detalhes sobre o diagnóstico subtype_of_sealed_class produzido pelo analisador Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_A classe '{0}' não deve ser estendida, misturada ou implementada porque é sealed._

## Description

O analisador produz este diagnóstico quando uma classe sealed (uma que
tem a anotação [`sealed`][meta-sealed] ou herda ou mistura uma
classe sealed) é referenciada em uma cláusula `extends`, `implements`, ou
`with` de uma declaração de classe ou mixin se a declaração não está no
mesmo pacote que a classe sealed.

## Example

Dada uma biblioteca em um pacote diferente do pacote sendo analisado que
contém o seguinte:

```dart
import 'package:meta/meta.dart';

class A {}

@sealed
class B {}
```

O código a seguir produz este diagnóstico porque `C`, que não está no
mesmo pacote que `B`, está estendendo a classe sealed `B`:

```dart
import 'package:a/a.dart';

[!class C extends B {}!]
```

## Common fixes

Se a classe não precisa ser um subtipo da classe sealed, então mude
a declaração para que não seja:

```dart
import 'package:a/a.dart';

class B extends A {}
```

Se a classe precisa ser um subtipo da classe sealed, então mude
a classe sealed para que não seja mais sealed ou mova a subclasse para
o mesmo pacote que a classe sealed.

[meta-sealed]: https://pub.dev/documentation/meta/latest/meta/sealed-constant.html
