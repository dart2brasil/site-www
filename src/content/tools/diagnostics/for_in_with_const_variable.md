---
ia-translate: true
title: for_in_with_const_variable
description: "Detalhes sobre o diagnóstico for_in_with_const_variable produzido pelo analisador Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_Uma variável de loop for-in não pode ser 'const'._

## Descrição

O analisador produz este diagnóstico quando a variável de loop declarada em um
loop for-in é declarada como `const`. A variável não pode ser `const`
porque o valor não pode ser computado em tempo de compilação.

## Exemplo

O código a seguir produz este diagnóstico porque a variável de loop `x`
é declarada como `const`:

```dart
void f() {
  for ([!const!] x in [0, 1, 2]) {
    print(x);
  }
}
```

## Correções comuns

Se houver uma anotação de tipo, então remova o modificador `const` da
declaração.

Se não houver tipo, então substitua o modificador `const` por `final`, `var`,
ou uma anotação de tipo:

```dart
void f() {
  for (final x in [0, 1, 2]) {
    print(x);
  }
}
```
