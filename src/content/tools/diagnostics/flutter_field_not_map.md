---
title: flutter_field_not_map
description: >-
  Details about the flutter_field_not_map
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_The value of the 'flutter' field is expected to be a map._

## Descrição

O analisador produz este diagnóstico quando the value of the `flutter` key
isn't a map.

## Exemplo

O código a seguir produz este diagnóstico porque the value of the
top-level `flutter` key is a string:

```yaml
name: example
flutter: [!true!]
```

## Correções comuns

If you need to specify Flutter-specific options, then change the value to
be a map:

```yaml
name: example
flutter:
  uses-material-design: true
```

If you don't need to specify Flutter-specific options, then remove the
`flutter` key:

```yaml
name: example
```
