---
ia-translate: true
title: equal_elements_in_set
description: "Detalhes sobre o diagnóstico equal_elements_in_set produzido pelo analisador Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_Dois elementos em um literal de set não devem ser equal._

## Description

O analisador produz este diagnóstico quando um elemento em um set não constant é
o mesmo que um elemento anterior no mesmo set. Se dois elementos são
iguais, então o segundo valor é ignorado, o que torna ter ambos os elementos
inútil e provavelmente sinaliza um bug.

## Example

O código a seguir produz este diagnóstico porque o elemento `1` aparece
duas vezes:

```dart
const a = 1;
const b = 1;
var s = <int>{a, [!b!]};
```

## Common fixes

Se ambos os elementos devem ser incluídos no set, então altere um dos
elementos:

```dart
const a = 1;
const b = 2;
var s = <int>{a, b};
```

Se apenas um dos elementos é necessário, então remova aquele que não é
necessário:

```dart
const a = 1;
var s = <int>{a};
```

Note que literais de set preservam a ordem de seus elementos, então a escolha
de qual elemento remover pode afetar a ordem em que os elementos são
retornados por um iterador.
