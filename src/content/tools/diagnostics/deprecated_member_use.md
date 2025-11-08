---
ia-translate: true
title: deprecated_member_use
description: >-
  Detalhes sobre o diagnóstico deprecated_member_use
  produzido pelo analisador Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_'{0}' está deprecated e não deve ser usado._

_'{0}' está deprecated e não deve ser usado. {1}_

## Description

O analisador produz este diagnóstico quando um membro de biblioteca ou classe
deprecated é usado em um pacote diferente.

## Example

Se o método `m` na classe `C` é anotado com `@deprecated`, então
o código a seguir produz este diagnóstico:

```dart
void f(C c) {
  c.[!m!]();
}
```

## Common fixes

A documentação para declarações anotadas com `@deprecated`
deve indicar qual código usar no lugar do código deprecated.
