---
ia-translate: true
title: not_a_type
description: >-
  Detalhes sobre o diagnóstico not_a_type
  produzido pelo analisador do Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_{0} isn't a type._

## Description

O analisador produz este diagnóstico quando um nome é usado como um tipo mas
está declarado como algo diferente de um tipo.

## Example

O código a seguir produz este diagnóstico porque `f` é uma função:

```dart
f() {}
g([!f!] v) {}
```

## Common fixes

Substitua o nome pelo nome de um tipo.
