---
ia-translate: true
title: super_in_extension
description: >-
  Detalhes sobre o diagnóstico super_in_extension
  produzido pelo analisador Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_A keyword 'super' não pode ser usada em uma extension porque uma extension não possui uma superclasse._

## Descrição

O analisador produz este diagnóstico quando um membro declarado dentro de uma
extension usa a keyword `super`. Extensions não são classes e não
possuem superclasses, então a keyword `super` não tem propósito.

## Exemplo

O código a seguir produz este diagnóstico porque `super` não pode ser usado
em uma extension:

```dart
extension E on Object {
  String get displayString => [!super!].toString();
}
```

## Correções comuns

Remova a keyword `super`:

```dart
extension E on Object {
  String get displayString => toString();
}
```
