---
ia-translate: true
title: extension_override_access_to_static_member
description: >-
  Detalhes sobre o diagnóstico extension_override_access_to_static_member
  produzido pelo analisador Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_Um override de extension não pode ser usado para acessar um membro static de uma extension._

## Descrição

O analisador produz este diagnóstico quando um override de extension é o
receptor da invocação de um membro static. Similar aos membros static em
classes, os membros static de uma extension devem ser acessados usando o
nome da extension, não um override de extension.

## Exemplo

O código a seguir produz este diagnóstico porque `m` é static:

```dart
extension E on String {
  static void m() {}
}

void f() {
  E('').[!m!]();
}
```

## Correções comuns

Substitua o override de extension pelo nome da extension:

```dart
extension E on String {
  static void m() {}
}

void f() {
  E.m();
}
```
