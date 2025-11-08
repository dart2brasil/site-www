---
ia-translate: true
title: pattern_never_matches_value_type
description: >-
  Detalhes sobre o diagnóstico pattern_never_matches_value_type
  produzido pelo analisador do Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_O tipo do valor correspondente '{0}' nunca pode corresponder ao tipo requerido '{1}'._

## Description

O analisador produz este diagnóstico quando o tipo do objeto não pode ser
correspondido pelo padrão.

## Example

O código a seguir produz este diagnóstico porque um `double` é correspondido
por um padrão `int`, o que nunca pode ter sucesso:

```dart
void f(String? s) {
  if (s case [!int!] _) {}
}
```

## Common fixes

Se um dos tipos está errado, então altere um ou ambos para que a correspondência de padrão
possa ter sucesso:

```dart
void f(String? s) {
  if (s case String _) {}
}
```

Se os tipos estão corretos, então remova a correspondência de padrão:

```dart
void f(double x) {}
```
