---
ia-translate: true
title: equal_keys_in_const_map
description: >-
  Detalhes sobre o diagnóstico equal_keys_in_const_map
  produzido pelo analisador Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_Duas chaves em um literal de map constant não podem ser equal._

## Description

O analisador produz este diagnóstico quando uma chave em um map constant é a
mesma que uma chave anterior no mesmo map. Se duas chaves são iguais, então o
segundo valor sobrescreveria o primeiro valor, o que torna ter ambos os pares
inútil.

## Example

O código a seguir produz este diagnóstico porque a chave `1` é usada
duas vezes:

```dart
const map = <int, String>{1: 'a', 2: 'b', [!1!]: 'c', 4: 'd'};
```

## Common fixes

Se ambas as entradas devem ser incluídas no map, então altere uma das chaves
para ser diferente:

```dart
const map = <int, String>{1: 'a', 2: 'b', 3: 'c', 4: 'd'};
```

Se apenas uma das entradas é necessária, então remova aquela que não é
necessária:

```dart
const map = <int, String>{1: 'a', 2: 'b', 4: 'd'};
```

Note que literais de map preservam a ordem de suas entradas, então a escolha
de qual entrada remover pode afetar a ordem em que chaves e valores
são retornados por um iterador.
