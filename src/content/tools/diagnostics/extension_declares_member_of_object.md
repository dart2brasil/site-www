---
ia-translate: true
title: extension_declares_member_of_object
description: "Detalhes sobre o diagnóstico extension_declares_member_of_object produzido pelo analisador Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_Extensions não podem declarar membros com o mesmo nome de um membro declarado por 'Object'._

## Descrição

O analisador produz este diagnóstico quando uma declaração de extension
declara um membro com o mesmo nome de um membro declarado na classe
`Object`. Tal membro nunca pode ser usado porque o membro em `Object` é
sempre encontrado primeiro.

## Exemplo

O código a seguir produz este diagnóstico porque `toString` é definido
por `Object`:

```dart
extension E on String {
  String [!toString!]() => this;
}
```

## Correções comuns

Remova o membro ou renomeie-o para que o nome não entre em conflito com o
membro em `Object`:

```dart
extension E on String {
  String displayString() => this;
}
```
