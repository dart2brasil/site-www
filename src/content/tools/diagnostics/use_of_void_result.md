---
ia-translate: true
title: use_of_void_result
description: "Detalhes sobre o diagnóstico use_of_void_result produzido pelo analisador Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_Esta expressão tem um tipo 'void', então seu valor não pode ser usado._

## Descrição

O analisador produz este diagnóstico quando encontra uma expressão cujo
tipo é `void`, e a expressão é usada em um lugar onde um valor é
esperado, como antes de um acesso a membro ou no lado direito de uma
atribuição.

## Exemplo

O código a seguir produz este diagnóstico porque `f` não produz um
objeto no qual `toString` pode ser invocado:

```dart
void f() {}

void g() {
  [!f()!].toString();
}
```

## Correções comuns

Reescreva o código para que a expressão tenha um valor ou reescreva o
código para que não dependa do valor.
