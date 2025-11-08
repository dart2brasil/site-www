---
title: mixin_application_concrete_super_invoked_member_type
description: "Detalhes sobre o diagnóstico mixin_application_concrete_super_invoked_member_type produzido pelo analisador Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_O member super-invocado '{0}' tem o tipo '{1}', e o member concreto na classe tem o tipo '{2}'._

## Description

O analisador produz este diagnóstico quando um mixin que invoca um method
usando `super` é usado em uma classe onde a implementação concreta desse
method tem uma assinatura diferente da assinatura definida para esse method
pelo tipo `on` do mixin. A razão disso ser um erro é porque a
invocação no mixin pode invocar o method de uma forma que é
incompatível com o method que será realmente executado.

## Example

O código a seguir produz este diagnóstico porque a classe `C` usa o
mixin `M`, o mixin `M` invoca `foo` usando `super`, e a versão abstract
de `foo` declarada em `I` (o tipo `on` do mixin) não tem a
mesma assinatura que a versão concreta de `foo` declarada em `A`:

```dart
class I {
  void foo([int? p]) {}
}

class A {
  void foo(int p) {}
}

abstract class B extends A implements I {
  @override
  void foo([int? p]);
}

mixin M on I {
  void bar() {
    super.foo(42);
  }
}

abstract class C extends B with [!M!] {}
```

## Common fixes

Se a classe não precisa usar o mixin, então remova-o da cláusula `with`:

```dart
class I {
  void foo([int? p]) {}
}

class A {
  void foo(int? p) {}
}

abstract class B extends A implements I {
  @override
  void foo([int? p]);
}

mixin M on I {
  void bar() {
    super.foo(42);
  }
}

abstract class C extends B {}
```

Se a classe precisa usar o mixin, então certifique-se de que há uma
implementação concreta do method que está em conformidade com a assinatura esperada pelo
mixin:

```dart
class I {
  void foo([int? p]) {}
}

class A {
  void foo(int? p) {}
}

abstract class B extends A implements I {
  @override
  void foo([int? p]) {
    super.foo(p);
  }
}

mixin M on I {
  void bar() {
    super.foo(42);
  }
}

abstract class C extends B with M {}
```
