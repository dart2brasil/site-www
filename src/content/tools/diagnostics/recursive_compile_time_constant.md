---
ia-translate: true
title: recursive_compile_time_constant
description: >-
  Detalhes sobre o diagnóstico recursive_compile_time_constant
  produzido pelo analisador Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_A expressão constante em tempo de compilação depende de si mesma._

## Description

O analisador produz este diagnóstico quando o valor de uma constante
em tempo de compilação é definido em termos de si mesma, direta ou indiretamente,
criando um loop infinito.

## Example

O código a seguir produz este diagnóstico duas vezes porque ambas as
constantes são definidas em termos uma da outra:

```dart
const [!secondsPerHour!] = minutesPerHour * 60;
const [!minutesPerHour!] = secondsPerHour / 60;
```

## Common fixes

Quebre o ciclo encontrando uma maneira alternativa de definir pelo menos uma das
constantes:

```dart
const secondsPerHour = minutesPerHour * 60;
const minutesPerHour = 60;
```
