---
ia-translate: true
title: invalid_assignment
description: "Detalhes sobre o diagnóstico invalid_assignment produzido pelo analisador do Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_Um valor do tipo '{0}' não pode ser atribuído a uma variável do tipo '{1}'._

## Description

O analisador produz este diagnóstico quando o tipo estático de uma
expressão que é atribuída a uma variável não é atribuível ao tipo da
variável.

## Example

O código a seguir produz este diagnóstico porque o tipo do inicializador
(`int`) não é atribuível ao tipo da variável (`String`):

```dart
int i = 0;
String s = [!i!];
```

## Common fixes

Se o valor sendo atribuído é sempre atribuível em tempo de execução, mesmo
que os tipos estáticos não reflitam isso, adicione um cast explícito.

Caso contrário, altere o valor sendo atribuído para que ele tenha o tipo
esperado. No exemplo anterior, isso poderia ser:

```dart
int i = 0;
String s = i.toString();
```

Se você não pode alterar o valor, altere o tipo da variável para ser
compatível com o tipo do valor sendo atribuído:

```dart
int i = 0;
int s = i;
```
