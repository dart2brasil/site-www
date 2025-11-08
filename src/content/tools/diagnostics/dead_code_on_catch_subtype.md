---
ia-translate: true
title: dead_code_on_catch_subtype
description: >-
  Detalhes sobre o diagnóstico dead_code_on_catch_subtype
  produzido pelo analisador Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_Dead code: Este bloco on-catch não será executado porque '{0}' é um subtipo de '{1}' e, portanto, já terá sido capturado._

## Description

O analisador produz este diagnóstico quando uma cláusula `catch` é encontrada que
não pode ser executada porque está após uma cláusula `catch` que captura
o mesmo tipo ou um supertipo do tipo da cláusula. A primeira cláusula `catch`
que corresponde ao objeto lançado é selecionada, e a cláusula anterior sempre
corresponde a qualquer coisa correspondível pela cláusula destacada, então a
cláusula destacada nunca será selecionada.

## Example

O código a seguir produz este diagnóstico:

```dart
void f() {
  try {
  } on num {
  } [!on int {!]
  [!}!]
}
```

## Common fixes

Se a cláusula deve ser selecionável, então mova a cláusula antes da cláusula
geral:

```dart
void f() {
  try {
  } on int {
  } on num {
  }
}
```

Se a cláusula não precisa ser selecionável, então remova-a:

```dart
void f() {
  try {
  } on num {
  }
}
```
