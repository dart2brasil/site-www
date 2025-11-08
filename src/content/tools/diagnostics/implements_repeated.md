---
ia-translate: true
title: implements_repeated
description: "Detalhes sobre o diagnóstico implements_repeated produzido pelo analisador do Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_'{0}' só pode ser implementado uma vez._

## Description

O analisador produz este diagnóstico quando uma única classe é especificada
mais de uma vez em uma cláusula `implements`.

## Example

O código a seguir produz este diagnóstico porque `A` está na lista duas
vezes:

```dart
class A {}
class B implements A, [!A!] {}
```

## Common fixes

Remova todas as ocorrências exceto uma do nome da classe:

```dart
class A {}
class B implements A {}
```
