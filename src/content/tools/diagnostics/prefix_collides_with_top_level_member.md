---
ia-translate: true
title: prefix_collides_with_top_level_member
description: >-
  Detalhes sobre o diagnóstico prefix_collides_with_top_level_member
  produzido pelo analisador do Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_O nome '{0}' já é usado como um prefixo de import e não pode ser usado para nomear um elemento de nível superior._

## Descrição

O analisador produz este diagnóstico quando um nome é usado tanto como prefixo de import
quanto como o nome de uma declaração de nível superior na mesma biblioteca.

## Exemplo

O código a seguir produz este diagnóstico porque `f` é usado tanto como
prefixo de import quanto como nome de uma função:

```dart
import 'dart:math' as f;

int [!f!]() => f.min(0, 1);
```

## Correções comuns

Se você quiser usar o nome para o prefixo de import, então renomeie a
declaração de nível superior:

```dart
import 'dart:math' as f;

int g() => f.min(0, 1);
```

Se você quiser usar o nome para a declaração de nível superior, então renomeie o
prefixo de import:

```dart
import 'dart:math' as math;

int f() => math.min(0, 1);
```
