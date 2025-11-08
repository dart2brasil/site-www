---
ia-translate: true
title: not_assigned_potentially_non_nullable_local_variable
description: "Detalhes sobre o diagnóstico not_assigned_potentially_non_nullable_local_variable produzido pelo analisador do Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_The non-nullable local variable '{0}' must be assigned before it can be used._

## Description

O analisador produz este diagnóstico quando uma variável local é referenciada
e possui todas estas características:
- Possui um tipo que é [potentially non-nullable][].
- Não possui um inicializador.
- Não está marcada como `late`.
- O analisador não pode provar que a variável local será atribuída antes
  da referência com base na especificação de [definite assignment][].

## Examples

O código a seguir produz este diagnóstico porque `x` não pode ter um valor
de `null`, mas é referenciado antes de um valor ser atribuído a ele:

```dart
String f() {
  int x;
  return [!x!].toString();
}
```

O código a seguir produz este diagnóstico porque a atribuição a `x`
pode não ser executada, então ele pode ter um valor de `null`:

```dart
int g(bool b) {
  int x;
  if (b) {
    x = 1;
  }
  return [!x!] * 2;
}
```

O código a seguir produz este diagnóstico porque o analisador não pode
provar, com base na análise de definite assignment, que `x` não será referenciado
sem ter um valor atribuído a ele:

```dart
int h(bool b) {
  int x;
  if (b) {
    x = 1;
  }
  if (b) {
    return [!x!] * 2;
  }
  return 0;
}
```

## Common fixes

Se `null` é um valor válido, então torne a variável nullable:

```dart
String f() {
  int? x;
  return x!.toString();
}
```

Se `null` não é um valor válido, e há um valor default razoável, então
adicione um inicializador:

```dart
int g(bool b) {
  int x = 2;
  if (b) {
    x = 1;
  }
  return x * 2;
}
```

Caso contrário, garanta que um valor foi atribuído em todos os caminhos de código possíveis
antes do valor ser acessado:

```dart
int g(bool b) {
  int x;
  if (b) {
    x = 1;
  } else {
    x = 2;
  }
  return x * 2;
}
```

Você também pode marcar a variável como `late`, o que remove o diagnóstico, mas
se a variável não for atribuída com um valor antes de ser acessada, então isso
resulta em uma exceção sendo lançada em tempo de execução. Esta abordagem só deve
ser usada se você tiver certeza de que a variável sempre será atribuída, mesmo
que o analisador não possa provar isso com base na análise de definite assignment.

```dart
int h(bool b) {
  late int x;
  if (b) {
    x = 1;
  }
  if (b) {
    return x * 2;
  }
  return 0;
}
```

[definite assignment]: /resources/glossary#definite-assignment
[potentially non-nullable]: /resources/glossary#potentially-non-nullable
