---
ia-translate: true
title: undefined_getter
description: >-
  Detalhes sobre o diagnóstico undefined_getter
  produzido pelo analisador Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_O getter '{0}' não está definido para o tipo de função '{1}'._

_O getter '{0}' não está definido para o tipo '{1}'._

## Descrição

O analisador produz este diagnóstico quando encontra um identificador que
parece ser o nome de um getter, mas não está definido ou não está
visível no escopo em que está sendo referenciado.

## Exemplo

O código a seguir produz este diagnóstico porque `String` não possui membro
chamado `len`:

```dart
int f(String s) => s.[!len!];
```

## Correções comuns

Se o identificador não está definido, então defina-o ou substitua-o pelo
nome de um getter que está definido. O exemplo acima pode ser corrigido
corrigindo a ortografia do getter:

```dart
int f(String s) => s.length;
```
