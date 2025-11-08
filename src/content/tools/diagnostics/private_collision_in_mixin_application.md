---
ia-translate: true
title: private_collision_in_mixin_application
description: >-
  Detalhes sobre o diagnóstico private_collision_in_mixin_application
  produzido pelo analisador Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_O nome private '{0}', definido por '{1}', conflita com o mesmo nome definido por '{2}'._

## Description

O analisador produz este diagnóstico quando dois mixins que definem o mesmo
membro private são usados juntos em uma única classe em uma biblioteca diferente
daquela que define os mixins.

## Example

Dado um arquivo `a.dart` contendo o seguinte código:

```dart
mixin A {
  void _foo() {}
}

mixin B {
  void _foo() {}
}
```

O código a seguir produz este diagnóstico porque os mixins `A` e `B`
definem ambos o método `_foo`:

```dart
import 'a.dart';

class C extends Object with A, [!B!] {}
```

## Common fixes

Se você não precisa de ambos os mixins, remova um deles da
cláusula `with`:

```dart
import 'a.dart';

class C extends Object with A, [!B!] {}
```

Se você precisa de ambos os mixins, renomeie o membro conflitante em um
dos dois mixins.
