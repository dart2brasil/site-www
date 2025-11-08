---
ia-translate: true
title: field_initialized_in_parameter_and_initializer
description: >-
  Detalhes sobre o diagnóstico field_initialized_in_parameter_and_initializer
  produzido pelo analisador Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_Campos não podem ser inicializados tanto na lista de parâmetros quanto nos inicializadores._

## Descrição

O analisador produz este diagnóstico quando um campo é inicializado tanto
na lista de parâmetros quanto na lista de inicializadores de um construtor.

## Exemplo

O código a seguir produz este diagnóstico porque o campo `f` é
inicializado tanto por um parâmetro formal inicializador quanto na
lista de inicializadores:

```dart
class C {
  int f;

  C(this.f) : [!f!] = 0;
}
```

## Correções comuns

Se o campo deve ser inicializado pelo parâmetro, remova a
inicialização na lista de inicializadores:

```dart
class C {
  int f;

  C(this.f);
}
```

Se o campo deve ser inicializado na lista de inicializadores e o
parâmetro não é necessário, remova o parâmetro:

```dart
class C {
  int f;

  C() : f = 0;
}
```

Se o campo deve ser inicializado na lista de inicializadores e o
parâmetro é necessário, torne-o um parâmetro normal:

```dart
class C {
  int f;

  C(int g) : f = g * 2;
}
```
