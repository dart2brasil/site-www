---
ia-translate: true
title: invalid_override_of_non_virtual_member
description: "Detalhes sobre o diagnóstico invalid_override_of_non_virtual_member produzido pelo analisador do Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_O membro '{0}' é declarado como non-virtual em '{1}' e não pode sofrer override em subclasses._

## Description

O analisador produz este diagnóstico quando um membro de uma classe, mixin ou
enum faz override de um membro que possui a anotação `@nonVirtual`.

## Example

O código a seguir produz este diagnóstico porque o método `m` em `B`
faz override do método `m` em `A`, e o método `m` em `A` está anotado
com a anotação `@nonVirtual`:

```dart
import 'package:meta/meta.dart';

class A {
  @nonVirtual
  void m() {}
}

class B extends A {
  @override
  void [!m!]() {}
}
```

## Common fixes

Se a anotação no método da superclasse está correta (o método
na superclasse não deve sofrer override), então remova ou renomeie
o método que faz override:

```dart
import 'package:meta/meta.dart';

class A {
  @nonVirtual
  void m() {}
}

class B extends A {}
```

Se o método na superclasse deve permitir override, então remova
a anotação `@nonVirtual`:

```dart
class A {
  void m() {}
}

class B extends A {
  @override
  void m() {}
}
```
