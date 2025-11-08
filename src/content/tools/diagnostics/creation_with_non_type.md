---
ia-translate: true
title: creation_with_non_type
description: >-
  Detalhes sobre o diagnóstico creation_with_non_type
  produzido pelo analisador do Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_O nome '{0}' não é uma classe._

## Description

O analisador produz este diagnóstico quando uma criação de instância usando
`new` ou `const` especifica um nome que não está definido como uma classe.

## Example

O código a seguir produz este diagnóstico porque `f` é uma função
em vez de uma classe:

```dart
int f() => 0;

void g() {
  new [!f!]();
}
```

## Common fixes

Se uma classe deve ser criada, então substitua o nome inválido pelo nome
de uma classe válida:

```dart
int f() => 0;

void g() {
  new Object();
}
```

Se o nome é o nome de uma função e você quer que essa função seja
invocada, então remova a keyword `new` ou `const`:

```dart
int f() => 0;

void g() {
  f();
}
```
