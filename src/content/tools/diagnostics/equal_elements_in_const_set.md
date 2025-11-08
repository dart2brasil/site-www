---
ia-translate: true
title: equal_elements_in_const_set
description: >-
  Detalhes sobre o diagnóstico equal_elements_in_const_set
  produzido pelo analisador Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_Dois elementos em um literal de set constant não podem ser equal._

## Description

O analisador produz este diagnóstico quando dois elementos em um literal de set
constant têm o mesmo valor. O set pode conter cada valor apenas uma vez,
o que significa que um dos valores é desnecessário.

## Example

O código a seguir produz este diagnóstico porque a string `'a'` é
especificada duas vezes:

```dart
const Set<String> set = {'a', [!'a'!]};
```

## Common fixes

Remova um dos valores duplicados:

```dart
const Set<String> set = {'a'};
```

Note que literais de set preservam a ordem de seus elementos, então a escolha
de qual elemento remover pode afetar a ordem em que os elementos são
retornados por um iterador.
