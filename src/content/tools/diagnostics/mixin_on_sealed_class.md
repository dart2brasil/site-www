---
ia-translate: true
title: mixin_on_sealed_class
description: >-
  Detalhes sobre o diagnóstico mixin_on_sealed_class
  produzido pelo analisador Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_A classe '{0}' não deve ser usada como mixin constraint porque é sealed, e qualquer classe que mistura este mixin deve ter '{0}' como superclasse._

## Description

O analisador produz este diagnóstico quando o superclass constraint de um
mixin é uma classe de um pacote diferente que foi marcada como
[`sealed`][meta-sealed]. Classes que são sealed não podem ser estendidas,
implementadas, misturadas ou usadas como superclass constraint.

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

Se as classes que usam o mixin não precisam ser subclasses da classe
sealed, então considere adicionar um campo e delegar para a instância envolvida
da classe sealed.

[meta-sealed]: https://pub.dev/documentation/meta/latest/meta/sealed-constant.html
