---
ia-translate: true
title: unnecessary_question_mark
description: "Detalhes sobre o diagnóstico unnecessary_question_mark produzido pelo analisador Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_O '?' é desnecessário porque '{0}' é nullable sem ele._

## Description

O analisador produz este diagnóstico quando o tipo `dynamic` ou o
tipo `Null` é seguido por um ponto de interrogação. Ambos esses tipos são
inerentemente nullable, então o ponto de interrogação não altera a semântica.

## Example

O código a seguir produz este diagnóstico porque o ponto de interrogação
seguindo `dynamic` não é necessário:

```dart
dynamic[!?!] x;
```

## Common fixes

Remova o ponto de interrogação desnecessário:

```dart
dynamic x;
```
