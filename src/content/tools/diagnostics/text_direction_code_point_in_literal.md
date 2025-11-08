---
ia-translate: true
title: text_direction_code_point_in_literal
description: "Detalhes sobre o diagnóstico text_direction_code_point_in_literal produzido pelo analisador do Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_O ponto de código Unicode 'U+{0}' altera a aparência do texto de como ele é interpretado pelo compilador._

## Descrição

O analisador produz este diagnóstico quando encontra código fonte que
contém pontos de código Unicode de direção de texto. Esses pontos de código fazem com que
o código fonte em uma string literal ou um comentário seja interpretado
e compilado de forma diferente de como aparece nos editores, levando a
possíveis vulnerabilidades de segurança.

## Exemplo

O código a seguir produz este diagnóstico duas vezes porque há
caracteres ocultos no início e no final da string label:

```dart
var label = '[!I!]nteractive text[!'!];
```

## Correções comuns

Se os pontos de código forem destinados a serem incluídos na string literal,
então escape-os:

```dart
var label = '\u202AInteractive text\u202C';
```

Se os pontos de código não forem destinados a serem incluídos na string literal,
então remova-os:

```dart
var label = 'Interactive text';
```
