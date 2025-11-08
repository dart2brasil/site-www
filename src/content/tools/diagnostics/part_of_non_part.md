---
ia-translate: true
title: part_of_non_part
description: "Detalhes sobre o diagnóstico part_of_non_part produzido pelo analisador do Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_A parte incluída '{0}' deve ter uma diretiva part-of._

## Description

O analisador produz este diagnóstico quando uma diretiva part é encontrada e
o arquivo referenciado não possui uma diretiva part-of.

## Example

Dado um arquivo `a.dart` contendo:

```dart
class A {}
```

O código a seguir produz este diagnóstico porque `a.dart` não
contém uma diretiva part-of:

```dart
part [!'a.dart'!];
```

## Common fixes

Se o arquivo referenciado deve ser parte de outra biblioteca, então
adicione uma diretiva part-of ao arquivo:

```dart
part of 'test.dart';

class A {}
```

Se o arquivo referenciado deve ser uma biblioteca, então substitua a diretiva part
por uma diretiva import:

```dart
import 'a.dart';
```
