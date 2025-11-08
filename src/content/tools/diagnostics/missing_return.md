---
title: missing_return
description: "Detalhes sobre o diagnóstico missing_return produzido pelo analisador Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_Esta função tem um tipo de retorno '{0}', mas não termina com uma instrução return._

## Description

Qualquer função ou method que não termina com um return explícito ou um
throw retorna implicitamente `null`. Esse raramente é o comportamento desejado. O
analisador produz este diagnóstico quando encontra um return implícito.

## Example

O código a seguir produz este diagnóstico porque `f` não termina com um
return:

```dart
int [!f!](int x) {
  if (x < 0) {
    return 0;
  }
}
```

## Common fixes

Adicione uma instrução `return` que torna o valor de retorno explícito, mesmo se
`null` é o valor apropriado.
