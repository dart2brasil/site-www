---
ia-translate: true
title: invalid_reference_to_this
description: >-
  Detalhes sobre o diagnóstico invalid_reference_to_this
  produzido pelo analisador do Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_Referência inválida à expressão 'this'._

## Description

O analisador produz este diagnóstico quando `this` é usado fora de um
método de instância ou de um construtor generativo. A palavra reservada `this`
só é definida no contexto de um método de instância, um construtor
generativo ou o inicializador de uma declaração de campo de instância late.

## Example

O código a seguir produz este diagnóstico porque `v` é uma variável
de nível superior:

```dart
C f() => [!this!];

class C {}
```

## Common fixes

Use uma variável do tipo apropriado no lugar de `this`, declarando-a se
necessário:

```dart
C f(C c) => c;

class C {}
```
