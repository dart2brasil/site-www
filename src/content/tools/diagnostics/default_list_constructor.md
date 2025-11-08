---
title: default_list_constructor
description: >-
  Details about the default_list_constructor
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_The default 'List' constructor isn't available when null safety is enabled._

## Descrição

O analisador produz este diagnóstico quando it finds a use of the default
constructor for the class `List` in code that has opted in to null safety.

## Exemplo

Assuming the following code is opted in to null safety, it produces this
diagnostic because it uses the default `List` construtor:

```dart
var l = [!List<int>!]();
```

## Correções comuns

If no initial size is provided, then convert the code to use a list
literal:

```dart
var l = <int>[];
```

If an initial size needs to be provided and there is a single reasonable
initial value for the elements, then use `List.filled`:

```dart
var l = List.filled(3, 0);
```

If an initial size needs to be provided but each element needs to be
computed, then use `List.generate`:

```dart
var l = List.generate(3, (i) => i);
```
