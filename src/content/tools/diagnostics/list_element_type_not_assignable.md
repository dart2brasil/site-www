---
title: list_element_type_not_assignable
description: >-
  Detalhes sobre o diagnóstico list_element_type_not_assignable
  produzido pelo analisador Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_O tipo do elemento '{0}' não pode ser atribuído ao tipo da list '{1}'._

## Descrição

O analisador produz este diagnóstico quando o tipo de um elemento em um
literal de list não é atribuível ao tipo de elemento da list.

## Exemplo

O código a seguir produz este diagnóstico porque `2.5` é um double, e
a list só pode conter inteiros:

```dart
List<int> x = [1, [!2.5!], 3];
```

## Correções comuns

Se você pretendia adicionar um objeto diferente à list, então substitua o
elemento por uma expressão que calcule o objeto pretendido:

```dart
List<int> x = [1, 2, 3];
```

Se o objeto não deveria estar na list, então remova o elemento:

```dart
List<int> x = [1, 3];
```

Se o objeto sendo calculado está correto, então amplie o tipo de elemento da
list para permitir todos os diferentes tipos de objetos que ela precisa conter:

```dart
List<num> x = [1, 2.5, 3];
```
