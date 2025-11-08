---
ia-translate: true
title: instantiate_abstract_class
description: "Detalhes sobre o diagnóstico instantiate_abstract_class produzido pelo analisador Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_Classes abstract não podem ser instanciadas._

## Description

O analisador produz este diagnóstico quando encontra uma invocação de construtor
e o construtor é declarado em uma classe abstract. Mesmo
que você não possa criar uma instância de uma classe abstract, classes abstract
podem declarar construtores que podem ser invocados por subclasses.

## Example

O código a seguir produz este diagnóstico porque `C` é uma classe
abstract:

```dart
abstract class C {}

var c = new [!C!]();
```

## Common fixes

Se há uma subclasse concreta da classe abstract que pode ser usada, então
crie uma instância da subclasse concreta.
