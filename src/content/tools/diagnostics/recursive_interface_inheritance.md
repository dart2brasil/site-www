---
ia-translate: true
title: recursive_interface_inheritance
description: >-
  Detalhes sobre o diagnóstico recursive_interface_inheritance
  produzido pelo analisador Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_'{0}' não pode ser uma superinterface de si mesmo: {1}._

_'{0}' não pode estender a si mesmo._

_'{0}' não pode implementar a si mesmo._

_'{0}' não pode usar a si mesmo como um mixin._

_'{0}' não pode usar a si mesmo como uma restrição de superclasse._

## Description

O analisador produz este diagnóstico quando há uma circularidade na
hierarquia de tipos. Isso acontece quando um tipo, direta ou indiretamente,
é declarado como um subtipo de si mesmo.

## Example

O código a seguir produz este diagnóstico porque a classe `A` é
declarada como um subtipo de `B`, e `B` é um subtipo de `A`:

```dart
class [!A!] extends B {}
class B implements A {}
```

## Common fixes

Altere a hierarquia de tipos para que não haja circularidade.
