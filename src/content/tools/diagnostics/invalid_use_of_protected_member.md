---
ia-translate: true
title: invalid_use_of_protected_member
description: "Detalhes sobre o diagnóstico invalid_use_of_protected_member produzido pelo analisador do Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_O membro '{0}' só pode ser usado dentro de membros de instância de subclasses de '{1}'._

## Description

O analisador produz este diagnóstico quando um getter, setter, campo ou
método que foi anotado com `@protected` é referenciado em qualquer lugar
que não seja na biblioteca em que foi declarado ou em uma subclasse da
classe em que foi declarado.

## Example

Dado um arquivo `a.dart` que contém o seguinte:

```dart
import 'package:meta/meta.dart';

class A {
  @protected
  void a() {}
}
```

O código a seguir produz este diagnóstico porque o método `a` está
sendo invocado em código que não está em uma subclasse de `A`:

```dart
import 'a.dart';

void b(A a) {
  a.[!a!]();
}
```

## Common fixes

Se é razoável que o membro seja marcado como `@protected`, então
remova a referência ao membro protegido, substituindo-o por algum
código equivalente.

Se não é razoável que o membro seja marcado como `@protected`, e
você tem a habilidade de fazê-lo, remova a anotação.
