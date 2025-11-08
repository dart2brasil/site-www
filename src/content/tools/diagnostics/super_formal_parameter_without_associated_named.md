---
ia-translate: true
title: super_formal_parameter_without_associated_named
description: >-
  Detalhes sobre o diagnóstico super_formal_parameter_without_associated_named
  produzido pelo analisador Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_Nenhum parâmetro nomeado do construtor super associado._

## Descrição

O analisador produz este diagnóstico quando há um parâmetro super nomeado
em um construtor e o construtor super invocado implícita ou explicitamente
não possui um parâmetro nomeado com o mesmo nome.

Parâmetros super nomeados são associados por nome com parâmetros nomeados no
construtor super.

## Exemplo

O código a seguir produz este diagnóstico porque o construtor em `A`
não possui um parâmetro chamado `y`:

```dart
class A {
  A({int? x});
}

class B extends A {
  B({super.[!y!]});
}
```

## Correções comuns

Se o parâmetro super deve ser associado a um parâmetro existente
do construtor super, então altere o nome para corresponder ao nome do
parâmetro correspondente:

```dart
class A {
  A({int? x});
}

class B extends A {
  B({super.x});
}
```

Se o parâmetro super deve ser associado a um parâmetro que ainda não
foi adicionado ao construtor super, então adicione-o:

```dart
class A {
  A({int? x, int? y});
}

class B extends A {
  B({super.y});
}
```

Se o parâmetro super não corresponde a um parâmetro nomeado do
construtor super, então altere-o para ser um parâmetro normal:

```dart
class A {
  A({int? x});
}

class B extends A {
  B({int? y});
}
```
