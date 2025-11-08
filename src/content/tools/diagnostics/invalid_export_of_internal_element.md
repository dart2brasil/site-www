---
ia-translate: true
title: invalid_export_of_internal_element
description: >-
  Detalhes sobre o diagnóstico invalid_export_of_internal_element
  produzido pelo analisador do Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_O membro '{0}' não pode ser exportado como parte da API pública de um pacote._

## Description

O analisador produz este diagnóstico quando uma [public library][] exporta
uma declaração que é marcada com a annotation [`internal`][meta-internal].

## Example

Dado um arquivo `a.dart` no diretório `src` que contém:

```dart
import 'package:meta/meta.dart';

@internal class One {}
```

O código a seguir, quando encontrado em uma [public library][], produz
este diagnóstico porque a diretiva `export` está exportando um nome que é
destinado apenas para uso interno:

```dart
[!export 'src/a.dart';!]
```

## Common fixes

Se o export é necessário, adicione uma cláusula `hide` para ocultar os
nomes internos:

```dart
export 'src/a.dart' hide One;
```

Se o export não é necessário, remova-o.

[meta-internal]: https://pub.dev/documentation/meta/latest/meta/internal-constant.html
[public library]: /resources/glossary#public-library
