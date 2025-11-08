---
ia-translate: true
title: top_level_cycle
description: >-
  Detalhes sobre o diagnóstico top_level_cycle
  produzido pelo analisador do Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_O tipo de '{0}' não pode ser inferido porque depende de si mesmo através do ciclo: {1}._

## Description

O analisador produz este diagnóstico quando uma variável de nível superior não tem
anotação de tipo e o inicializador da variável se refere à variável, seja
direta ou indiretamente.

## Example

O código a seguir produz este diagnóstico porque as variáveis `x` e
`y` são definidas em termos uma da outra, e nenhuma tem um tipo explícito,
então o tipo da outra não pode ser inferido:

```dart
var x = y;
var y = [!x!];
```

## Common fixes

Se as duas variáveis não precisam se referir uma à outra, então quebre o
ciclo:

```dart
var x = 0;
var y = x;
```

Se as duas variáveis precisam se referir uma à outra, então forneça a pelo menos uma delas
um tipo explícito:

```dart
int x = y;
var y = x;
```

Note, no entanto, que embora este código não produza nenhum diagnóstico, ele
produzirá um estouro de pilha em tempo de execução, a menos que pelo menos uma das
variáveis seja atribuída a um valor que não dependa das outras variáveis
antes que qualquer uma das variáveis no ciclo seja referenciada.
