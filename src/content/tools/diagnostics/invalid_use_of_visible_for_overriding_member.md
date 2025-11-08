---
ia-translate: true
title: invalid_use_of_visible_for_overriding_member
description: "Detalhes sobre o diagnóstico invalid_use_of_visible_for_overriding_member produzido pelo analisador do Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_O membro '{0}' só pode ser usado para override._

## Description

O analisador produz este diagnóstico quando um membro de instância que está
anotado com [`visibleForOverriding`][meta-visibleForOverriding] é
referenciado fora da biblioteca em que foi declarado por qualquer razão que não
seja para fazer override dele.

## Example

Dado um arquivo `a.dart` contendo a seguinte declaração:

```dart
import 'package:meta/meta.dart';

class A {
  @visibleForOverriding
  void a() {}
}
```

O código a seguir produz este diagnóstico porque o método `m` está sendo
invocado mesmo que a única razão de ser público seja para permitir que tenha
override:

```dart
import 'a.dart';

class B extends A {
  void b() {
    [!a!]();
  }
}
```

## Common fixes

Remova o uso inválido do membro.

[meta-visibleForOverriding]: https://pub.dev/documentation/meta/latest/meta/visibleForOverriding-constant.html
