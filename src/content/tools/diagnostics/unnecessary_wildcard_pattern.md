---
title: unnecessary_wildcard_pattern
description: >-
  Details about the unnecessary_wildcard_pattern
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_Unnecessary wildcard pattern._

## Descrição

O analisador produz este diagnóstico quando a wildcard pattern is used in
either an and (`&&`) pattern or an or (`||`) pattern.

## Exemplo

O código a seguir produz este diagnóstico porque the wildcard pattern
(`_`) will always succeed, making it's use in an and pattern unnecessary:

```dart
void f(Object? x) {
  if (x case [!_!] && 0) {}
}
```

## Correções comuns

Remove the use of the wildcard pattern:

```dart
void f(Object? x) {
  if (x case 0) {}
}
```
