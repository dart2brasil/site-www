---
ia-translate: true
title: non_type_in_catch_clause
description: "Detalhes sobre o diagnóstico non_type_in_catch_clause produzido pelo analisador do Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_O nome '{0}' não é um tipo e não pode ser usado em uma cláusula on-catch._

## Description

O analisador produz este diagnóstico quando o identificador após o
`on` em uma cláusula `catch` é definido como algo diferente de um tipo.

## Example

O código a seguir produz este diagnóstico porque `f` é uma função, não
um tipo:

```dart
void f() {
  try {
    // ...
  } on [!f!] {
    // ...
  }
}
```

## Common fixes

Altere o nome para o tipo de objeto que deve ser capturado:

```dart
void f() {
  try {
    // ...
  } on FormatException {
    // ...
  }
}
```
