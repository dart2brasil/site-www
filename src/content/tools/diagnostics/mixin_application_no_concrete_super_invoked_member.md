---
title: mixin_application_no_concrete_super_invoked_member
description: "Detalhes sobre o diagnóstico mixin_application_no_concrete_super_invoked_member produzido pelo analisador Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_A classe não tem uma implementação concreta do member super-invocado '{0}'._

_A classe não tem uma implementação concreta do setter super-invocado '{0}'._

## Description

O analisador produz este diagnóstico quando uma [application de mixin][mixin application] contém
uma invocação de um member de sua superclasse, e não há member
concreto com esse nome na superclasse da application de mixin.

## Example

O código a seguir produz este diagnóstico porque o mixin `M` contém
a invocação `super.m()`, e a classe `A`, que é a superclasse da
[application de mixin][mixin application] `A+M`, não define uma implementação concreta
de `m`:

```dart
abstract class A {
  void m();
}

mixin M on A {
  void bar() {
    super.m();
  }
}

abstract class B extends A with [!M!] {}
```

## Common fixes

Se você pretendia aplicar o mixin `M` a uma classe diferente, uma que tenha uma
implementação concreta de `m`, então altere a superclasse de `B` para essa
classe:

```dart
abstract class A {
  void m();
}

mixin M on A {
  void bar() {
    super.m();
  }
}

class C implements A {
  void m() {}
}

abstract class B extends C with M {}
```

Se você precisa fazer `B` uma subclasse de `A`, então adicione uma
implementação concreta de `m` em `A`:

```dart
abstract class A {
  void m() {}
}

mixin M on A {
  void bar() {
    super.m();
  }
}

abstract class B extends A with M {}
```

[mixin application]: /resources/glossary#mixin-application
