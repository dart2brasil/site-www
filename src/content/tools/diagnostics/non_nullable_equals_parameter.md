---
ia-translate: true
title: non_nullable_equals_parameter
description: >-
  Detalhes sobre o diagnóstico non_nullable_equals_parameter
  produzido pelo analisador do Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_O tipo de parâmetro dos operadores '==' deve ser non-nullable._

## Description

O analisador produz este diagnóstico quando uma sobrescrita do operador
`==` tem um parâmetro cujo tipo é nullable. A especificação da linguagem torna
impossível que o argumento do método seja `null`, e o
tipo do parâmetro deve refletir isso.

## Example

O código a seguir produz este diagnóstico porque a implementação do
operador `==` em `C` :

```dart
class C {
  @override
  bool operator [!==!](Object? other) => false;
}
```

## Common fixes

Torne o tipo do parâmetro non-nullable:

```dart
class C {
  @override
  bool operator ==(Object other) => false;
}
```
