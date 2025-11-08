---
ia-translate: true
title: undefined_enum_constant
description: "Detalhes sobre o diagnóstico undefined_enum_constant produzido pelo analisador Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_Não há constante chamada '{0}' em '{1}'._

## Descrição

O analisador produz este diagnóstico quando encontra um identificador
que parece ser o nome de um valor enum, e o nome não está
definido ou não está visível no escopo em que está sendo referenciado.

## Exemplo

O código a seguir produz este diagnóstico porque `E` não define uma
constante chamada `c`:

```dart
enum E {a, b}

var e = E.[!c!];
```

## Correções comuns

Se a constante deve ser definida, então adicione-a à declaração do
enum:

```dart
enum E {a, b, c}

var e = E.c;
```

Se a constante não deve ser definida, então altere o nome para o nome de
uma constante existente:

```dart
enum E {a, b}

var e = E.b;
```
