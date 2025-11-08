---
title: built_in_identifier_in_declaration
description: >-
  Detalhes sobre o diagnóstico built_in_identifier_in_declaration
  produzido pelo analisador Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_O built-in identifier '{0}' não pode ser usado como nome de prefixo._

_O built-in identifier '{0}' não pode ser usado como nome de type._

_O built-in identifier '{0}' não pode ser usado como nome de parâmetro de type._

_O built-in identifier '{0}' não pode ser usado como nome de typedef._

_O built-in identifier '{0}' não pode ser usado como nome de extension._

_O built-in identifier '{0}' não pode ser usado como nome de extension type._

## Description

O analisador produz este diagnóstico quando o nome usado na declaração
de uma classe, extension, mixin, typedef, parâmetro de type, ou prefixo de importação é
um built-in identifier. Built-in identifiers não podem ser usados para nomear nenhum desses
tipos de declarações.

## Example

O código a seguir produz este diagnóstico porque `mixin` é um built-in
identifier:

```dart
extension [!mixin!] on int {}
```

## Common fixes

Escolha um nome diferente para a declaração.
