---
ia-translate: true
title: switch_case_completes_normally
description: >-
  Detalhes sobre o diagnóstico switch_case_completes_normally
  produzido pelo analisador Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_O 'case' não deve completar normalmente._

## Descrição

O analisador produz este diagnóstico quando as declarações após um
label `case` em uma instrução `switch` podem cair no próximo `case`
ou label `default`.

## Exemplo

O código a seguir produz este diagnóstico porque o label `case` com
um valor de zero (`0`) cai nas declarações `default`:

```dart
void f(int a) {
  switch (a) {
    [!case!] 0:
      print(0);
    default:
      return;
  }
}
```

## Correções comuns

Altere o fluxo de controle para que o `case` não caia. Existem
várias maneiras de fazer isso, incluindo adicionar um dos
seguintes no final da lista atual de declarações:
- uma declaração `return`,
- uma expressão `throw`,
- uma declaração `break`,
- um `continue`, ou
- uma invocação de uma função ou método cujo tipo de retorno é `Never`.
