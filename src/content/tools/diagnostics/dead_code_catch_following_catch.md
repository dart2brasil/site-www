---
ia-translate: true
title: dead_code_catch_following_catch
description: "Detalhes sobre o diagnóstico dead_code_catch_following_catch produzido pelo analisador Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_Dead code: Cláusulas catch após um 'catch (e)' ou um 'on Object catch (e)' nunca são alcançadas._

## Description

O analisador produz este diagnóstico quando uma cláusula `catch` é encontrada que
não pode ser executada porque está após uma cláusula `catch` da forma
`catch (e)` ou `on Object catch (e)`. A primeira cláusula `catch` que corresponde
ao objeto lançado é selecionada, e ambas as formas corresponderão a qualquer
objeto, então nenhuma cláusula `catch` que as segue será selecionada.

## Example

O código a seguir produz este diagnóstico:

```dart
void f() {
  try {
  } catch (e) {
  } [!on String {!]
  [!}!]
}
```

## Common fixes

Se a cláusula deve ser selecionável, então mova a cláusula antes da cláusula
geral:

```dart
void f() {
  try {
  } on String {
  } catch (e) {
  }
}
```

Se a cláusula não precisa ser selecionável, então remova-a:

```dart
void f() {
  try {
  } catch (e) {
  }
}
```
