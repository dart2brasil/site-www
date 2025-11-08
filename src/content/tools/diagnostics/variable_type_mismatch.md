---
ia-translate: true
title: variable_type_mismatch
description: >-
  Detalhes sobre o diagnóstico variable_type_mismatch
  produzido pelo analisador Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_Um valor de tipo '{0}' não pode ser atribuído a uma variável const de tipo '{1}'._

## Descrição

O analisador produz este diagnóstico quando a avaliação de uma expressão
constante resultaria em uma `CastException`.

## Exemplo

O código a seguir produz este diagnóstico porque o valor de `x` é um
`int`, que não pode ser atribuído a `y` porque um `int` não é uma `String`:

```dart
const dynamic x = 0;
const String y = [!x!];
```

## Correções comuns

Se a declaração da constante está correta, então mude o valor sendo
atribuído para ser do tipo correto:

```dart
const dynamic x = 0;
const String y = '$x';
```

Se o valor atribuído está correto, então mude a declaração para ter o
tipo correto:

```dart
const int x = 0;
const int y = x;
```
