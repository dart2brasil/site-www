---
title: missing_named_pattern_field_name
description: >-
  Detalhes sobre o diagnóstico missing_named_pattern_field_name
  produzido pelo analisador Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_O nome do getter não é especificado explicitamente, e o padrão não é uma variável._

## Description

O analisador produz este diagnóstico quando, dentro de um padrão de objeto, a
especificação de uma propriedade e o padrão usado para corresponder ao valor da propriedade
não tem:

- um nome de getter antes dos dois pontos
- um padrão de variável do qual o nome do getter pode ser inferido

## Example

O código a seguir produz este diagnóstico porque não há nome de getter
antes dos dois pontos e nenhum padrão de variável após os dois pontos no
padrão de objeto (`C(:0)`):

```dart
abstract class C {
  int get f;
}

void f(C c) {
  switch (c) {
    case C([!:0!]):
      break;
  }
}
```

## Common fixes

Se você precisa usar o valor real da propriedade dentro do escopo do padrão,
então adicione um padrão de variável onde o nome da variável é o
mesmo que o nome da propriedade sendo correspondida:

```dart
abstract class C {
  int get f;
}

void f(C c) {
  switch (c) {
    case C(:var f) when f == 0:
      print(f);
  }
}
```

Se você não precisa usar o valor real da propriedade dentro do
escopo do padrão, então adicione o nome da propriedade sendo correspondida antes
dos dois pontos:

```dart
abstract class C {
  int get f;
}

void f(C c) {
  switch (c) {
    case C(f: 0):
      break;
  }
}
```
