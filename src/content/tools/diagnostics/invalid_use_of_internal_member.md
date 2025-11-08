---
ia-translate: true
title: invalid_use_of_internal_member
description: "Detalhes sobre o diagnóstico invalid_use_of_internal_member produzido pelo analisador do Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_O membro '{0}' só pode ser usado dentro de seu pacote._

## Description

O analisador produz este diagnóstico quando uma referência a uma declaração
que está anotada com a anotação [`internal`][meta-internal] é encontrada
fora do pacote que contém a declaração.

## Example

Dado um pacote `p` que define uma biblioteca contendo uma declaração marcada
com a anotação [`internal`][meta-internal]:

```dart
import 'package:meta/meta.dart';

@internal
class C {}
```

O código a seguir produz este diagnóstico porque está referenciando a
classe `C`, que não é destinada a ser usada fora do pacote `p`:

```dart
import 'package:p/src/p.dart';

void f([!C!] c) {}
```

## Common fixes

Remova a referência à declaração internal.

[meta-internal]: https://pub.dev/documentation/meta/latest/meta/internal-constant.html
