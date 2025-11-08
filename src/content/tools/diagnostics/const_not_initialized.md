---
ia-translate: true
title: const_not_initialized
description: >-
  Detalhes sobre o diagnóstico const_not_initialized
  produzido pelo analisador do Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_The constant '{0}' must be initialized._

## Descrição

O analisador produz este diagnóstico quando uma variável declarada como
constante não tem um inicializador.

## Exemplo

O código a seguir produz este diagnóstico porque `c` não está inicializado:

```dart
const [!c!];
```

## Correções comuns

Adicione um inicializador:

```dart
const c = 'c';
```
