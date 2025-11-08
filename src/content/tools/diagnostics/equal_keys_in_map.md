---
ia-translate: true
title: equal_keys_in_map
description: "Detalhes sobre o diagnóstico equal_keys_in_map produzido pelo analisador Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_Duas chaves em um literal de map não devem ser equal._

## Description

O analisador produz este diagnóstico quando uma chave em um map não constant é
a mesma que uma chave anterior no mesmo map. Se duas chaves são iguais, então
o segundo valor sobrescreve o primeiro valor, o que torna ter ambos os pares
inútil e provavelmente sinaliza um bug.

## Example

O código a seguir produz este diagnóstico porque as chaves `a` e `b`
têm o mesmo valor:

```dart
const a = 1;
const b = 1;
var m = <int, String>{a: 'a', [!b!]: 'b'};
```

## Common fixes

Se ambas as entradas devem ser incluídas no map, então altere uma das chaves:

```dart
const a = 1;
const b = 2;
var m = <int, String>{a: 'a', b: 'b'};
```

Se apenas uma das entradas é necessária, então remova aquela que não é
necessária:

```dart
const a = 1;
var m = <int, String>{a: 'a'};
```

Note que literais de map preservam a ordem de suas entradas, então a escolha
de qual entrada remover pode afetar a ordem em que as chaves e
valores são retornados por um iterador.
