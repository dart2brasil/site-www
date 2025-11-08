---
title: duplicate_definition
description: >-
  Details about the duplicate_definition
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_The name '{0}' is already defined._

## Descrição

O analisador produz este diagnóstico quando a name is declared, and there is
a previous declaration with the same name in the same scope.

## Exemplo

O código a seguir produz este diagnóstico porque the name `x` is
declared twice:

```dart
int x = 0;
int [!x!] = 1;
```

## Correções comuns

Choose a different name for one of the declarations.

```dart
int x = 0;
int y = 1;
```
