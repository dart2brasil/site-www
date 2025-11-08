---
ia-translate: true
title: initializer_for_non_existent_field
description: "Detalhes sobre o diagnóstico initializer_for_non_existent_field produzido pelo analisador do Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_'{0}' não é um campo na classe envolvente._

## Description

O analisador produz este diagnóstico quando um construtor inicializa um
campo que não está declarado na classe que contém o construtor.
Construtores não podem inicializar campos que não estão declarados e campos que
são herdados de superclasses.

## Example

O código a seguir produz este diagnóstico porque o inicializador está
inicializando `x`, mas `x` não é um campo na classe:

```dart
class C {
  int? y;

  C() : [!x = 0!];
}
```

## Common fixes

Se um campo diferente deve ser inicializado, então altere o nome para o
nome do campo:

```dart
class C {
  int? y;

  C() : y = 0;
}
```

Se o campo deve ser declarado, então adicione uma declaração:

```dart
class C {
  int? x;
  int? y;

  C() : x = 0;
}
```
