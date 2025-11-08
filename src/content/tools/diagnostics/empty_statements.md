---
ia-translate: true
title: empty_statements
description: >-
  Detalhes sobre o diagnóstico empty_statements
  produzido pelo analisador Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/empty_statements"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_Statement empty desnecessário._

## Description

O analisador produz este diagnóstico quando um statement empty é encontrado.

## Example

O código a seguir produz este diagnóstico porque o statement
controlado pelo loop `while` é um statement empty:

```dart
void f(bool condition) {
  while (condition)[!;!]
    g();
}

void g() {}
```

## Common fixes

Se não há statements que precisam ser controlados, então remova tanto
o statement empty quanto a estrutura de controle da qual ele faz parte (tomando cuidado
para que qualquer outro código sendo removido não tenha um efeito colateral que precise ser
preservado):

```dart
void f(bool condition) {
  g();
}

void g() {}
```

Se não há statements que precisam ser controlados mas a estrutura
de controle ainda é necessária por outros motivos, então substitua o statement
empty por um bloco para tornar a estrutura do código mais óbvia:

```dart
void f(bool condition) {
  while (condition) {}
  g();
}

void g() {}
```

Se há statements que precisam ser controlados, remova o statement
empty e ajuste o código para que os statements apropriados estejam sendo
controlados, possivelmente adicionando um bloco:

```dart
void f(bool condition) {
  while (condition) {
    g();
  }
}

void g() {}
```
