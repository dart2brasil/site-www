---
ia-translate: true
title: abstract_sealed_class
description: >-
  Detalhes sobre o diagnóstico abstract_sealed_class
  produzido pelo analisador Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_Uma classe 'sealed' não pode ser marcada como 'abstract' porque já é implicitamente abstract._

## Description

O analisador produz este diagnóstico quando uma classe é declarada usando tanto
o modificador `abstract` quanto o modificador `sealed`. Classes sealed são
implicitamente abstract, portanto usar explicitamente ambos os modificadores não é permitido.

## Example

O código a seguir produz este diagnóstico porque a classe `C` é
declarada usando tanto `abstract` quanto `sealed`:

```dart
abstract [!sealed!] class C {}
```

## Common fixes

Se a classe deve ser abstract mas não sealed, então remova o modificador `sealed`:

```dart
abstract class C {}
```

Se a classe deve ser tanto abstract quanto sealed, então remova o
modificador `abstract`:

```dart
sealed class C {}
```
