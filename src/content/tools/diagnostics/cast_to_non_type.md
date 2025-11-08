---
ia-translate: true
title: cast_to_non_type
description: "Detalhes sobre o diagnóstico cast_to_non_type produzido pelo analisador do Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_O nome '{0}' não é um type, então não pode ser usado em uma expressão 'as'._

## Description

O analisador produz este diagnóstico quando o nome que segue o `as` em uma
expressão de cast é definido como algo diferente de um type.

## Example

O código a seguir produz este diagnóstico porque `x` é uma variável, não
um type:

```dart
num x = 0;
int y = x as [!x!];
```

## Common fixes

Substitua o nome pelo nome de um type:

```dart
num x = 0;
int y = x as int;
```
