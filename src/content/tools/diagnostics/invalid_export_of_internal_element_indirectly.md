---
ia-translate: true
title: invalid_export_of_internal_element_indirectly
description: >-
  Detalhes sobre o diagnóstico invalid_export_of_internal_element_indirectly
  produzido pelo analisador do Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_O membro '{0}' não pode ser exportado como parte da API pública de um pacote, mas é exportado indiretamente como parte da assinatura de '{1}'._

## Description

O analisador produz este diagnóstico quando uma [public library][] exporta
uma função de nível superior com um tipo de retorno ou pelo menos um tipo
de parâmetro que é marcado com a annotation [`internal`][meta-internal].

## Example

Dado um arquivo `a.dart` no diretório `src` que contém o seguinte:

```dart
import 'package:meta/meta.dart';

@internal
typedef IntFunction = int Function();

int f(IntFunction g) => g();
```

O código a seguir produz este diagnóstico porque a função `f` tem um
parâmetro do tipo `IntFunction`, e `IntFunction` é destinado apenas para
uso interno:

```dart
[!export 'src/a.dart' show f;!]
```

## Common fixes

Se a função deve ser pública, torne todos os tipos na assinatura da função
tipos públicos.

Se a função não precisa ser exportada, pare de exportá-la, removendo-a da
cláusula `show`, adicionando-a à cláusula `hide`, ou removendo o export.

[meta-internal]: https://pub.dev/documentation/meta/latest/meta/internal-constant.html
[public library]: /resources/glossary#public-library
