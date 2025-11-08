---
ia-translate: true
title: referenced_before_declaration
description: "Detalhes sobre o diagnóstico referenced_before_declaration produzido pelo analisador do Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_A variável local '{0}' não pode ser referenciada antes de ser declarada._

## Description

O analisador produz este diagnóstico quando uma variável é referenciada antes
de ser declarada. Em Dart, as variáveis são visíveis em todos os lugares do bloco em
que são declaradas, mas só podem ser referenciadas após serem
declaradas.

O analisador também produz uma mensagem de contexto que indica onde a
declaração está localizada.

## Example

O código a seguir produz este diagnóstico porque `i` é usado antes de ser
declarado:

```dart
void f() {
  print([!i!]);
  int i = 5;
}
```

## Common fixes

Se você pretendia referenciar a variável local, mova a declaração
antes da primeira referência:

```dart
void f() {
  int i = 5;
  print(i);
}
```

Se você pretendia referenciar um nome de um escopo externo, como um
parâmetro, campo de instância ou variável de nível superior, então renomeie a
declaração local para que ela não oculte a variável externa.

```dart
void f(int i) {
  print(i);
  int x = 5;
  print(x);
}
```
