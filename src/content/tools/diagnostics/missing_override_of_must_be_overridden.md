---
title: missing_override_of_must_be_overridden
description: >-
  Detalhes sobre o diagnóstico missing_override_of_must_be_overridden
  produzido pelo analisador Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_Implementação concreta missing de '{0}'._

_Implementações concretas missing de '{0}' e '{1}'._

_Implementações concretas missing de '{0}', '{1}' e {2} mais._

## Description

O analisador produz este diagnóstico quando um member de instância que tem a
anotação `@mustBeOverridden` não é sobrescrito em uma subclasse.

## Example

O código a seguir produz este diagnóstico porque a classe `B` não tem
um override do method herdado `A.m` quando `A.m` está anotado
com `@mustBeOverridden`:

```dart
import 'package:meta/meta.dart';

class A {
  @mustBeOverridden
  void m() {}
}

class [!B!] extends A {}
```

## Common fixes

Se a anotação é apropriada para o member, então sobrescreva o member
na subclasse:

```dart
import 'package:meta/meta.dart';

class A {
  @mustBeOverridden
  void m() {}
}

class B extends A {
  @override
  void m() {}
}
```

Se a anotação não é apropriada para o member, então remova a
anotação:

```dart
class A {
  void m() {}
}

class B extends A {}
```
