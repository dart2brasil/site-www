---
title: abstract_sealed_class
description: >-
  Details about the abstract_sealed_class
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_A 'sealed' class can't be marked 'abstract' because it's already implicitly abstract._

## Descrição

O analisador produz este diagnóstico quando uma classe é declarada usando both
the modifier `abstract` and the modifier `sealed`. Sealed classes are
implicitly abstract, so explicitly using both modifiers is not allowed.

## Exemplo

O código a seguir produz este diagnóstico porque a classe `C` is
declared using both `abstract` and `sealed`:

```dart
abstract [!sealed!] class C {}
```

## Correções comuns

Se a classe deve ser abstrata mas não sealed, remova o modificador `sealed`
modificador:

```dart
abstract class C {}
```

Se a classe deve ser abstrata e sealed, remova o modificador
`abstract` modificador:

```dart
sealed class C {}
```
