---
ia-translate: true
title: shared_deferred_prefix
description: >-
  Detalhes sobre o diagnóstico shared_deferred_prefix
  produzido pelo analisador do Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_O prefixo de um import deferred não pode ser usado em outras diretivas import._

## Description

O analisador produz este diagnóstico quando um prefixo em um import deferred também
é usado como prefixo em outros imports (sejam deferred ou não). O
prefixo em um import deferred não pode ser compartilhado com outros imports porque o
prefixo é usado para carregar a biblioteca importada.

## Example

O código a seguir produz este diagnóstico porque o prefixo `x` é usado
como prefixo para um import deferred e também é usado para outro import:

```dart
import 'dart:math' [!deferred!] as x;
import 'dart:convert' as x;

var y = x.json.encode(x.min(0, 1));
```

## Common fixes

Se você pode usar um nome diferente para o import deferred, então faça isso:

```dart
import 'dart:math' deferred as math;
import 'dart:convert' as x;

var y = x.json.encode(math.min(0, 1));
```

Se você pode usar um nome diferente para os outros imports, então faça isso:

```dart
import 'dart:math' deferred as x;
import 'dart:convert' as convert;

var y = convert.json.encode(x.min(0, 1));
```
