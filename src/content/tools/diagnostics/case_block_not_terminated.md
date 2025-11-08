---
ia-translate: true
title: case_block_not_terminated
description: "Detalhes sobre o diagnóstico case_block_not_terminated produzido pelo analisador do Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_A última instrução do 'case' deve ser 'break', 'continue', 'rethrow', 'return' ou 'throw'._

## Descrição

O analisador produz este diagnóstico quando a última instrução em um bloco
`case` não é um dos terminadores obrigatórios: `break`, `continue`,
`rethrow`, `return` ou `throw`.

## Exemplo

O código a seguir produz este diagnóstico porque o bloco `case` termina
com uma atribuição:

```dart
void f(int x) {
  switch (x) {
    [!case!] 0:
      x += 2;
    default:
      x += 1;
  }
}
```

## Correções comuns

Adicione um dos terminadores obrigatórios:

```dart
void f(int x) {
  switch (x) {
    case 0:
      x += 2;
      break;
    default:
      x += 1;
  }
}
```
