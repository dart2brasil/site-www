---
ia-translate: true
title: field_initializer_factory_constructor
description: >-
  Detalhes sobre o diagnóstico field_initializer_factory_constructor
  produzido pelo analisador Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_Parâmetros formais inicializadores não podem ser usados em construtores factory._

## Descrição

O analisador produz este diagnóstico quando um construtor factory possui um
parâmetro formal inicializador. Construtores factory não podem atribuir valores a
campos porque nenhuma instância é criada; portanto, não há campo para atribuir.

## Exemplo

O código a seguir produz este diagnóstico porque o construtor factory
usa um parâmetro formal inicializador:

```dart
class C {
  int? f;

  factory C([!this.f!]) => throw 0;
}
```

## Correções comuns

Substitua o parâmetro formal inicializador por um parâmetro normal:

```dart
class C {
  int? f;

  factory C(int f) => throw 0;
}
```
