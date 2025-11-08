---
ia-translate: true
title: duplicate_part
description: "Detalhes sobre o diagnóstico duplicate_part produzido pelo analisador Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_A biblioteca já contém uma part com a URI '{0}'._

## Description

O analisador produz este diagnóstico quando um único arquivo é referenciado em
múltiplas diretivas part.

## Example

Dado um arquivo `part.dart` contendo

```dart
part of 'test.dart';
```

O código a seguir produz este diagnóstico porque o arquivo `part.dart` é
incluído múltiplas vezes:

```dart
part 'part.dart';
part [!'part.dart'!];
```

## Common fixes

Remova todas exceto a primeira das diretivas part duplicadas:

```dart
part 'part.dart';
```
