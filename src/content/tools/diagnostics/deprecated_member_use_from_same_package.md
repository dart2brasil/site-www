---
ia-translate: true
title: deprecated_member_use_from_same_package
description: "Detalhes sobre o diagnóstico deprecated_member_use_from_same_package produzido pelo analisador Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_'{0}' está deprecated e não deve ser usado._

_'{0}' está deprecated e não deve ser usado. {1}_

## Description

O analisador produz este diagnóstico quando um membro de biblioteca ou
classe deprecated é usado no mesmo pacote em que está declarado.

## Example

O código a seguir produz este diagnóstico porque `x` está deprecated:

```dart
@deprecated
var x = 0;
var y = [!x!];
```

## Common fixes

A correção depende do que foi deprecated e qual é o substituto. A
documentação para declarações deprecated deve indicar qual código usar
no lugar do código deprecated.
