---
ia-translate: true
title: conflicting_constructor_and_static_member
description: >-
  Detalhes sobre o diagnóstico conflicting_constructor_and_static_member
  produzido pelo analisador do Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_'{0}' não pode ser usado para nomear tanto um construtor quanto um campo static nesta classe._

_'{0}' não pode ser usado para nomear tanto um construtor quanto um getter static nesta classe._

_'{0}' não pode ser usado para nomear tanto um construtor quanto um método static nesta classe._

_'{0}' não pode ser usado para nomear tanto um construtor quanto um setter static nesta classe._

## Descrição

O analisador produz este diagnóstico quando um construtor nomeado e um
método static ou campo static têm o mesmo nome. Ambos são acessados usando
o nome da classe, então ter o mesmo nome torna a referência
ambígua.

## Exemplos

O código a seguir produz este diagnóstico porque o campo static `foo`
e o construtor nomeado `foo` têm o mesmo nome:

```dart
class C {
  C.[!foo!]();
  static int foo = 0;
}
```

O código a seguir produz este diagnóstico porque o método static `foo`
e o construtor nomeado `foo` têm o mesmo nome:

```dart
class C {
  C.[!foo!]();
  static void foo() {}
}
```

## Correções comuns

Renomeie o membro ou o construtor.
