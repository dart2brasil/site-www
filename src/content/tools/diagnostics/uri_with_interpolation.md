---
ia-translate: true
title: uri_with_interpolation
description: "Detalhes sobre o diagnóstico uri_with_interpolation produzido pelo analisador Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_URIs não podem usar interpolação de string._

## Descrição

O analisador produz este diagnóstico quando o literal de string em uma
diretiva `import`, `export` ou `part` contém uma interpolação. A
resolução dos URIs nas diretivas deve acontecer antes das declarações
serem compiladas, então expressões não podem ser avaliadas ao determinar os
valores dos URIs.

## Exemplo

O código a seguir produz este diagnóstico porque a string na
diretiva `import` contém uma interpolação:

```dart
import [!'dart:$m'!];

const m = 'math';
```

## Correções comuns

Remova a interpolação do URI:

```dart
import 'dart:math';

var zero = min(0, 0);
```
