---
ia-translate: true
title: duplicate_ignore
description: >-
  Detalhes sobre o diagnóstico duplicate_ignore
  produzido pelo analisador Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_O diagnóstico '{0}' não precisa ser ignorado aqui porque já está sendo ignorado._

## Description

O analisador produz este diagnóstico quando um nome de diagnóstico aparece em um
comentário `ignore`, mas o diagnóstico já está sendo ignorado, seja
porque já está incluído no mesmo comentário `ignore` ou porque
aparece em um comentário `ignore-in-file`.

## Examples

O código a seguir produz este diagnóstico porque o diagnóstico nomeado
`unused_local_variable` já está sendo ignorado para todo o arquivo, então não
precisa ser ignorado em uma linha específica:

```dart
// ignore_for_file: unused_local_variable
void f() {
  // ignore: [!unused_local_variable!]
  var x = 0;
}
```

O código a seguir produz este diagnóstico porque o diagnóstico nomeado
`unused_local_variable` está sendo ignorado duas vezes na mesma linha:

```dart
void f() {
  // ignore: unused_local_variable, [!unused_local_variable!]
  var x = 0;
}
```

## Common fixes

Remova o comentário ignore, ou remova o nome do diagnóstico desnecessário se o
comentário ignore estiver ignorando mais de um diagnóstico:

```dart
// ignore_for_file: unused_local_variable
void f() {
  var x = 0;
}
```
