---
ia-translate: true
title: implements_non_class
description: >-
  Detalhes sobre o diagnóstico implements_non_class
  produzido pelo analisador Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_Classes e mixins só podem implementar outras classes e mixins._

## Description

O analisador produz este diagnóstico quando um nome usado na cláusula `implements`
de uma declaração de classe ou mixin é definido como algo diferente
de uma classe ou mixin.

## Example

O código a seguir produz este diagnóstico porque `x` é uma variável
em vez de uma classe ou mixin:

```dart
var x;
class C implements [!x!] {}
```

## Common fixes

Se o nome é o nome de uma classe ou mixin existente que já está sendo
importado, então adicione um prefixo ao import para que a definição local do
nome não oculte o nome importado.

Se o nome é o nome de uma classe ou mixin existente que não está sendo
importado, então adicione um import, com um prefixo, para a biblioteca na qual está
declarado.

Caso contrário, substitua o nome na cláusula `implements` pelo nome
de uma classe ou mixin existente, ou remova o nome da cláusula `implements`.
