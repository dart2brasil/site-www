---
title: mixin_inherits_from_not_object
description: "Detalhes sobre o diagnóstico mixin_inherits_from_not_object produzido pelo analisador Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_A classe '{0}' não pode ser usada como um mixin porque estende uma classe diferente de 'Object'._

## Description

O analisador produz este diagnóstico quando uma classe que estende uma classe
diferente de `Object` é usada como um mixin.

## Example

O código a seguir produz este diagnóstico porque a classe `B`, que
estende `A`, está sendo usada como um mixin por `C`:

```dart
//@dart=2.19
class A {}

class B extends A {}

class C with [!B!] {}
```

## Common fixes

Se a classe sendo usada como um mixin pode ser alterada para estender `Object`, então
altere-a:

```dart
//@dart=2.19
class A {}

class B {}

class C with B {}
```

Se a classe sendo usada como um mixin não pode ser alterada e a classe que está
usando-a estende `Object`, então estenda a classe sendo usada como um mixin:

```dart
class A {}

class B extends A {}

class C extends B {}
```

Se a classe não estende `Object` ou se você quer poder misturar
o comportamento de `B` em outros lugares, então crie um mixin real:

```dart
class A {}

mixin M on A {}

class B extends A with M {}

class C extends A with M {}
```
