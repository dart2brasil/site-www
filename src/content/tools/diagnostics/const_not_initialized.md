---
title: const_not_initialized
description: >-
  Details about the const_not_initialized
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_The constant '{0}' must be initialized._

## Descrição

O analisador produz este diagnóstico quando a variable that is declared to
be a constant não tem uma initializer.

## Exemplo

O código a seguir produz este diagnóstico porque `c` isn't initialized:

```dart
const [!c!];
```

## Correções comuns

Adicione uma initializer:

```dart
const c = 'c';
```
