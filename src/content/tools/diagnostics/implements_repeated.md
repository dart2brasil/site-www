---
title: implements_repeated
description: >-
  Details about the implements_repeated
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_'{0}' can only be implemented once._

## Descrição

O analisador produz este diagnóstico quando a single class is specified more
than once in an `implements` clause.

## Exemplo

O código a seguir produz este diagnóstico porque `A` is in the list
twice:

```dart
class A {}
class B implements A, [!A!] {}
```

## Correções comuns

Remove all except one occurrence of the class name:

```dart
class A {}
class B implements A {}
```
