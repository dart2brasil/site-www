---
ia-translate: true
title: undefined_identifier
description: >-
  Detalhes sobre o diagnóstico undefined_identifier
  produzido pelo analisador Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_Nome indefinido '{0}'._

## Descrição

O analisador produz este diagnóstico quando encontra um identificador que
não está definido ou não está visível no escopo em que está sendo
referenciado.

## Exemplo

O código a seguir produz este diagnóstico porque o nome `rihgt` não está
definido:

```dart
int min(int left, int right) => left <= [!rihgt!] ? left : right;
```

## Correções comuns

Se o identificador não está definido, então defina-o ou substitua-o por
um identificador que esteja definido. O exemplo acima pode ser corrigido
corrigindo a ortografia da variável:

```dart
int min(int left, int right) => left <= right ? left : right;
```

Se o identificador está definido mas não está visível, então você provavelmente precisa
adicionar um import ou reorganizar seu código para tornar o identificador visível.
