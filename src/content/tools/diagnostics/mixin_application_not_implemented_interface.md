---
title: mixin_application_not_implemented_interface
description: >-
  Detalhes sobre o diagnóstico mixin_application_not_implemented_interface
  produzido pelo analisador Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_'{0}' não pode ser misturado em '{1}' porque '{1}' não implementa '{2}'._

## Description

O analisador produz este diagnóstico quando um mixin que tem um constraint de
superclasse é usado em uma [application de mixin][mixin application] com uma superclasse que
não implementa o constraint required.

## Example

O código a seguir produz este diagnóstico porque o mixin `M` requer
que a classe à qual é aplicado seja uma subclasse de `A`, mas `Object`
não é uma subclasse de `A`:

```dart
class A {}

mixin M on A {}

class X = Object with [!M!];
```

## Common fixes

Se você precisa usar o mixin, então altere a superclasse para ser a
mesma ou uma subclasse do constraint de superclasse:

```dart
class A {}

mixin M on A {}

class X = A with M;
```

[mixin application]: /resources/glossary#mixin-application
