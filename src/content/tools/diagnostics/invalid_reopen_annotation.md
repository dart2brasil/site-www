---
ia-translate: true
title: invalid_reopen_annotation
description: >-
  Detalhes sobre o diagnóstico invalid_reopen_annotation
  produzido pelo analisador do Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_A anotação '@reopen' só pode ser aplicada a uma classe que abre capacidades que o supertipo intencionalmente não permite._

## Description

O analisador produz este diagnóstico quando uma anotação `@reopen` foi
colocada em uma classe ou mixin que não remove restrições colocadas na
superclasse.

## Example

O código a seguir produz este diagnóstico porque a classe `B` está
anotada com `@reopen` mesmo que ela não expanda a capacidade de `A`
de ter subclasses:

```dart
import 'package:meta/meta.dart';

sealed class A {}

@[!reopen!]
class B extends A {}
```

## Common fixes

Se a superclasse deve ser restrita de uma forma que a subclasse
modificaria, então modifique a superclasse para refletir essas restrições:

```dart
import 'package:meta/meta.dart';

interface class A {}

@reopen
class B extends A {}
```

Se a superclasse está correta, então remova a anotação:

```dart
sealed class A {}

class B extends A {}
```
