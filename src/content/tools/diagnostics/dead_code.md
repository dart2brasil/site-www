---
ia-translate: true
title: dead_code
description: >-
  Detalhes sobre o diagnóstico dead_code
  produzido pelo analisador Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_Dead code._

_Dead code: A variável wildcard atribuída está marcada como late e nunca pode ser referenciada, então este inicializador nunca será avaliado._

## Description

O analisador produz este diagnóstico quando é encontrado código que não será
executado porque a execução nunca alcançará o código.

## Example

O código a seguir produz este diagnóstico porque a invocação de
`print` ocorre após a função ter retornado:

```dart
void f() {
  return;
  [!print('here');!]
}
```

## Common fixes

Se o código não é necessário, então remova-o:

```dart
void f() {
  return;
}
```

Se o código precisa ser executado, então mova o código para um lugar
onde ele será executado:

```dart
void f() {
  print('here');
  return;
}
```

Ou reescreva o código antes dele, para que possa ser alcançado:

```dart
void f({bool skipPrinting = true}) {
  if (skipPrinting) {
    return;
  }
  print('here');
}
```
