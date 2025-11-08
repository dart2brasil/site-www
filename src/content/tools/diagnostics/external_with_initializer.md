---
ia-translate: true
title: external_with_initializer
description: "Detalhes sobre o diagnóstico external_with_initializer produzido pelo analisador do Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_Campos external não podem ter inicializadores._

_Variáveis external não podem ter inicializadores._

## Description

O analisador produz este diagnóstico quando um campo ou variável marcado com
a keyword `external` tem um inicializador, ou quando um campo external é
inicializado em um construtor.

## Examples

O código a seguir produz este diagnóstico porque o campo external `x`
é atribuído um valor em um inicializador:

```dart
class C {
  external int x;
  C() : [!x!] = 0;
}
```

O código a seguir produz este diagnóstico porque o campo external `x`
tem um inicializador:

```dart
class C {
  external final int [!x!] = 0;
}
```

O código a seguir produz este diagnóstico porque a variável external de nível superior
`x` tem um inicializador:

```dart
external final int [!x!] = 0;
```

## Common fixes

Remova o inicializador:

```dart
class C {
  external final int x;
}
```
