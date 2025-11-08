---
ia-translate: true
title: import_of_legacy_library_into_null_safe
description: "Detalhes sobre o diagnóstico import_of_legacy_library_into_null_safe produzido pelo analisador do Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_A biblioteca '{0}' é legada e não deve ser importada em uma biblioteca null safe._

## Description

O analisador produz este diagnóstico quando uma biblioteca que é null safe
importa uma biblioteca que não é null safe.

## Example

Dado um arquivo `a.dart` que contém o seguinte:

```dart
// @dart = 2.9

class A {}
```

O código a seguir produz este diagnóstico porque uma biblioteca que é null
safe está importando uma biblioteca que não é null safe:

```dart
import [!'a.dart'!];

A? f() => null;
```

## Common fixes

Se você pode migrar a biblioteca importada para ser null safe, migre-a e
atualize ou remova a versão da linguagem da biblioteca migrada.

Se você não pode migrar a biblioteca importada, então a biblioteca que está
importando precisa ter uma versão da linguagem anterior à 2.12, quando null
safety foi habilitado por padrão.
