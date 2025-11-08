---
ia-translate: true
title: duplicate_field_formal_parameter
description: >-
  Detalhes sobre o diagnóstico duplicate_field_formal_parameter
  produzido pelo analisador Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_O campo '{0}' não pode ser inicializado por múltiplos parâmetros no mesmo construtor._

## Description

O analisador produz este diagnóstico quando há mais de um
parâmetro formal inicializador para o mesmo campo na lista de
parâmetros de um construtor. Não é útil atribuir um valor que será imediatamente
sobrescrito.

## Example

O código a seguir produz este diagnóstico porque `this.f` aparece duas vezes
na lista de parâmetros:

```dart
class C {
  int f;

  C(this.f, this.[!f!]) {}
}
```

## Common fixes

Remova um dos parâmetros formais inicializadores:

```dart
class C {
  int f;

  C(this.f) {}
}
```
