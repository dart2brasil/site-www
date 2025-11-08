---
title: map_entry_not_in_map
description: "Detalhes sobre o diagnóstico map_entry_not_in_map produzido pelo analisador Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_Entradas de Map podem ser usadas apenas em um literal de map._

## Description

O analisador produz este diagnóstico quando uma entrada de map (um par chave/valor)
é encontrada em um literal de conjunto.

## Example

O código a seguir produz este diagnóstico porque o literal tem uma entrada de map
mesmo sendo um literal de conjunto:

```dart
var collection = <String>{[!'a' : 'b'!]};
```

## Common fixes

Se você pretendia que a coleção fosse um map, então altere o código para
que seja um map. No exemplo anterior, você poderia fazer isso adicionando
outro argumento de tipo:

```dart
var collection = <String, String>{'a' : 'b'};
```

Em outros casos, você pode precisar alterar o tipo explícito de `Set` para
`Map`.

Se você pretendia que a coleção fosse um conjunto, então remova a entrada de map,
possivelmente substituindo os dois pontos por uma vírgula se ambos os valores devem ser
incluídos no conjunto:

```dart
var collection = <String>{'a', 'b'};
```
