---
ia-translate: true
title: no_annotation_constructor_arguments
description: >-
  Detalhes sobre o diagnóstico no_annotation_constructor_arguments
  produzido pelo analisador do Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_Annotation creation must have arguments._

## Description

O analisador produz este diagnóstico quando uma annotation consiste em um
único identificador, mas esse identificador é o nome de uma classe em vez de uma
variável. Para criar uma instância da classe, o identificador deve ser
seguido por uma lista de argumentos.

## Example

O código a seguir produz este diagnóstico porque `C` é uma classe, e uma
classe não pode ser usada como annotation sem invocar um construtor `const`
da classe:

```dart
class C {
  const C();
}

[!@C!]
var x;
```

## Common fixes

Adicione a lista de argumentos faltante:

```dart
class C {
  const C();
}

@C()
var x;
```
