---
ia-translate: true
title: undefined_method
description: >-
  Detalhes sobre o diagnóstico undefined_method
  produzido pelo analisador Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_O método '{0}' não está definido para o tipo de função '{1}'._

_O método '{0}' não está definido para o tipo '{1}'._

## Descrição

O analisador produz este diagnóstico quando encontra um identificador que
parece ser o nome de um método, mas não está definido ou não está
visível no escopo em que está sendo referenciado.

## Exemplo

O código a seguir produz este diagnóstico porque o identificador
`removeMiddle` não está definido:

```dart
int f(List<int> l) => l.[!removeMiddle!]();
```

## Correções comuns

Se o identificador não está definido, então defina-o ou substitua-o pelo
nome de um método que está definido. O exemplo acima pode ser corrigido
corrigindo a ortografia do método:

```dart
int f(List<int> l) => l.removeLast();
```
