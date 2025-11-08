---
ia-translate: true
title: const_initialized_with_non_constant_value
description: >-
  Detalhes sobre o diagnóstico const_initialized_with_non_constant_value
  produzido pelo analisador do Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_Const variables must be initialized with a constant value._

## Descrição

O analisador produz este diagnóstico quando um valor que não é estaticamente
conhecido como constante é atribuído a uma variável declarada como
variável `const`.

## Exemplo

O código a seguir produz este diagnóstico porque `x` não está declarado como
`const`:

```dart
var x = 0;
const y = [!x!];
```

## Correções comuns

Se o valor sendo atribuído pode ser declarado como `const`, então altere a
declaração:

```dart
const x = 0;
const y = x;
```

Se o valor não pode ser declarado como `const`, então remova o modificador
`const` da variável, possivelmente usando `final` em seu lugar:

```dart
var x = 0;
final y = x;
```
