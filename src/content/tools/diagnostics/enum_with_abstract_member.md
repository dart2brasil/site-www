---
ia-translate: true
title: enum_with_abstract_member
description: >-
  Detalhes sobre o diagnóstico enum_with_abstract_member
  produzido pelo analisador Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_'{0}' deve ter um corpo de método porque '{1}' é um enum._

## Descrição

O analisador produz este diagnóstico quando um membro de um enum é encontrado
que não tem uma implementação concreta. Enums não são permitidos para
conter membros abstratos.

## Exemplo

O código a seguir produz este diagnóstico porque `m` é um método abstrato
e `E` é um enum:

```dart
enum E {
  e;

  [!void m();!]
}
```

## Correções comuns

Forneça uma implementação para o membro:

```dart
enum E {
  e;

  void m() {}
}
```
