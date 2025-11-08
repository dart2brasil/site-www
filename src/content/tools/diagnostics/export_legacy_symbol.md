---
ia-translate: true
title: export_legacy_symbol
description: >-
  Detalhes sobre o diagnóstico export_legacy_symbol
  produzido pelo analisador Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_O símbolo '{0}' é definido em uma biblioteca legada, e não pode ser reexportado de uma biblioteca com null safety habilitado._

## Description

O analisador produz este diagnóstico quando uma biblioteca que foi aderida ao
null safety exporta outra biblioteca, e a biblioteca exportada está fora
do null safety.

## Example

Dado uma biblioteca que está fora do null safety:

```dart
// @dart = 2.8
String s;
```

O código a seguir produz este diagnóstico porque está exportando símbolos
de uma biblioteca que não aderiu:

```dart
export [!'optedOut.dart'!];

class C {}
```

## Common fixes

Se você puder fazer isso, migre a biblioteca exportada para que ela não
precise estar fora:

```dart
String? s;
```

Se você não puder migrar a biblioteca, então remova o export:

```dart
class C {}
```

Se a biblioteca exportada (aquela que está fora) ela mesma exporta uma
biblioteca que aderiu, então é válido para sua biblioteca exportar indiretamente os
símbolos da biblioteca que aderiu. Você pode fazer isso adicionando um
combinador hide à diretiva export em sua biblioteca que oculta todos os
nomes declarados na biblioteca que não aderiu.
