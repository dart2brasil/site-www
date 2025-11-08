---
title: mixin_on_sealed_class
description: >-
  Detalhes sobre o diagnóstico mixin_on_sealed_class
  produzido pelo analisador Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_A classe '{0}' não deve ser usada como um constraint de mixin porque é sealed, e qualquer classe misturando este mixin deve ter '{0}' como uma superclasse._

## Description

O analisador produz este diagnóstico quando o constraint de superclasse de um
mixin é uma classe de um pacote diferente que foi marcada como
[`sealed`][meta-sealed]. Classes que são sealed não podem ser estendidas,
implementadas, misturadas ou usadas como um constraint de superclasse.

## Example

Se o pacote `p` define uma classe sealed:

```dart
import 'package:meta/meta.dart';

@sealed
class C {}
```

Então, o código a seguir, quando em um pacote diferente de `p`, produz este
diagnóstico:

```dart
import 'package:p/p.dart';

[!mixin M on C {}!]
```

## Common fixes

Se as classes que usam o mixin não precisam ser subclasses da classe sealed,
então considere adicionar um campo e delegar para a instância encapsulada
da classe sealed.

[meta-sealed]: https://pub.dev/documentation/meta/latest/meta/sealed-constant.html
