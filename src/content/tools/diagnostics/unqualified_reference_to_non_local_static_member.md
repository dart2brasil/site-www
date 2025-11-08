---
ia-translate: true
title: unqualified_reference_to_non_local_static_member
description: >-
  Detalhes sobre o diagnóstico unqualified_reference_to_non_local_static_member
  produzido pelo analisador do Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_Membros static de supertipos devem ser qualificados pelo nome do tipo definidor._

## Descrição

O analisador produz este diagnóstico quando código em uma classe referencia um
membro static em uma superclasse sem prefixar o nome do membro com o
nome da superclasse. Membros static só podem ser referenciados sem um
prefixo na classe na qual são declarados.

## Exemplo

O código a seguir produz este diagnóstico porque o campo static `x` é
referenciado no getter `g` sem prefixá-lo com o nome da
classe definidora:

```dart
class A {
  static int x = 3;
}

class B extends A {
  int get g => [!x!];
}
```

## Correções comuns

Prefixe o nome do membro static com o nome da classe declarante:

```dart
class A {
  static int x = 3;
}

class B extends A {
  int get g => A.x;
}
```
