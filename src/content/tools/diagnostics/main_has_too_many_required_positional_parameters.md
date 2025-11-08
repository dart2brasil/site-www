---
title: main_has_too_many_required_positional_parameters
description: "Detalhes sobre o diagnóstico main_has_too_many_required_positional_parameters produzido pelo analisador Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_A função 'main' não pode ter mais de dois positional parameters required._

## Description

O analisador produz este diagnóstico quando uma função chamada `main` tem mais
de dois positional parameters required.

## Example

O código a seguir produz este diagnóstico porque a função `main` tem
três positional parameters required:

```dart
void [!main!](List<String> args, int x, int y) {}
```

## Common fixes

Se a função é um ponto de entrada e os parameters extras não são usados,
então remova-os:

```dart
void main(List<String> args, int x) {}
```

Se a função é um ponto de entrada, mas os parameters extras usados são para
quando a função não está sendo usada como ponto de entrada, então torne os parameters
extras opcionais:

```dart
void main(List<String> args, int x, [int y = 0]) {}
```

Se a função não é um ponto de entrada, então altere o nome da função:

```dart
void f(List<String> args, int x, int y) {}
```
