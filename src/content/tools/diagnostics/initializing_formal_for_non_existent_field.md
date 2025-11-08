---
ia-translate: true
title: initializing_formal_for_non_existent_field
description: >-
  Detalhes sobre o diagnóstico initializing_formal_for_non_existent_field
  produzido pelo analisador do Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_'{0}' não é um campo na classe envolvente._

## Description

O analisador produz este diagnóstico quando um parâmetro formal
inicializador é encontrado em um construtor em uma classe que não declara o
campo sendo inicializado. Construtores não podem inicializar campos que não estão
declarados e campos que são herdados de superclasses.

## Example

O código a seguir produz este diagnóstico porque o campo `x` não está
definido:

```dart
class C {
  int? y;

  C([!this.x!]);
}
```

## Common fixes

Se o nome do campo estava errado, então altere-o para o nome de um campo
existente:

```dart
class C {
  int? y;

  C(this.y);
}
```

Se o nome do campo está correto mas ainda não foi definido, então declare o
campo:

```dart
class C {
  int? x;
  int? y;

  C(this.x);
}
```

Se o parâmetro é necessário mas não deve inicializar um campo, então converta-o
para um parâmetro normal e use-o:

```dart
class C {
  int y;

  C(int x) : y = x * 2;
}
```

Se o parâmetro não é necessário, então remova-o:

```dart
class C {
  int? y;

  C();
}
```
