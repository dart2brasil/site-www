---
ia-translate: true
title: invalid_internal_annotation
description: >-
  Detalhes sobre o diagnóstico invalid_internal_annotation
  produzido pelo analisador do Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_Apenas elementos públicos na API privada de um pacote podem ser anotados como internos._

## Description

O analisador produz este diagnóstico quando uma declaração é anotada com a
annotation [`internal`][meta-internal] e essa declaração está em uma
[public library][] ou tem um nome privado.

## Example

O código a seguir, quando em uma [public library][], produz este diagnóstico
porque a annotation [`internal`][meta-internal] não pode ser aplicada a
declarações em uma [public library][]:

```dart
import 'package:meta/meta.dart';

@[!internal!]
class C {}
```

O código a seguir, seja em uma biblioteca pública ou interna, produz este
diagnóstico porque a annotation [`internal`][meta-internal] não pode ser
aplicada a declarações com nomes privados:

```dart
import 'package:meta/meta.dart';

@[!internal!]
class _C {}

void f(_C c) {}
```

## Common fixes

Se a declaração tem um nome privado, remova a annotation:

```dart
class _C {}

void f(_C c) {}
```

Se a declaração tem um nome público e é destinada a ser interna ao pacote,
mova a declaração anotada para uma biblioteca interna (em outras palavras,
uma biblioteca dentro do diretório `src`).

Caso contrário, remova o uso da annotation:

```dart
class C {}
```

[meta-internal]: https://pub.dev/documentation/meta/latest/meta/internal-constant.html
[public library]: /resources/glossary#public-library
