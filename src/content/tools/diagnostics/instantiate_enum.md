---
ia-translate: true
title: instantiate_enum
description: >-
  Detalhes sobre o diagnóstico instantiate_enum
  produzido pelo analisador do Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_Enums não podem ser instanciados._

## Description

O analisador produz este diagnóstico quando um enum é instanciado. É
inválido criar uma instância de um enum invocando um construtor; apenas
as instâncias nomeadas na declaração do enum podem existir.

## Example

O código a seguir produz este diagnóstico porque o enum `E` está sendo
instanciado:

```dart
// @dart = 2.16
enum E {a}

var e = [!E!]();
```

## Common fixes

Se você pretende usar uma instância do enum, então referencie uma das
constantes definidas no enum:

```dart
// @dart = 2.16
enum E {a}

var e = E.a;
```

Se você pretende usar uma instância de uma classe, então use o nome dessa classe no lugar do nome do enum.
