---
ia-translate: true
title: unqualified_reference_to_static_member_of_extended_type
description: "Detalhes sobre o diagnóstico unqualified_reference_to_static_member_of_extended_type produzido pelo analisador do Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_Membros static do tipo estendido ou de uma de suas superclasses devem ser qualificados pelo nome do tipo definidor._

## Descrição

O analisador produz este diagnóstico quando um nome indefinido é encontrado, e
o nome é o mesmo de um membro static do tipo estendido ou de uma de suas
superclasses.

## Exemplo

O código a seguir produz este diagnóstico porque `m` é um membro static
do tipo estendido `C`:

```dart
class C {
  static void m() {}
}

extension E on C {
  void f() {
    [!m!]();
  }
}
```

## Correções comuns

Se você está tentando referenciar um membro static declarado fora da
extension, então adicione o nome da classe ou extension antes da referência
ao membro:

```dart
class C {
  static void m() {}
}

extension E on C {
  void f() {
    C.m();
  }
}
```

Se você está referenciando um membro que ainda não foi declarado, adicione uma declaração:

```dart
class C {
  static void m() {}
}

extension E on C {
  void f() {
    m();
  }

  void m() {}
}
```
