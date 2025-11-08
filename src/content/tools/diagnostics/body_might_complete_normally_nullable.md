---
title: body_might_complete_normally_nullable
description: >-
  Detalhes sobre o diagnóstico body_might_complete_normally_nullable
  produzido pelo analisador Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_Esta função tem um tipo de retorno anulável de '{0}', mas termina sem retornar um valor._

## Description

O analisador produz este diagnóstico quando um método ou função pode
retornar implicitamente `null` ao chegar ao final. Embora este seja código Dart
válido, é melhor que o retorno de `null` seja explícito.

## Example

O código a seguir produz este diagnóstico porque a função `f`
retorna implicitamente `null`:

```dart
String? [!f!]() {}
```

## Common fixes

Se o retorno de `null` é intencional, então torne-o explícito:

```dart
String? f() {
  return null;
}
```

Se a função deve retornar um valor não-nulo nesse caminho, então adicione
a instrução return que está faltando:

```dart
String? f() {
  return '';
}
```
