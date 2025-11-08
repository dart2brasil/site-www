---
ia-translate: true
title: unused_local_variable
description: >-
  Detalhes sobre o diagnóstico unused_local_variable
  produzido pelo analisador Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_O valor da variável local '{0}' não é usado._

## Descrição

O analisador produz este diagnóstico quando uma variável local é declarada mas
nunca lida, mesmo que seja escrita em um ou mais lugares.

## Exemplo

O código a seguir produz este diagnóstico porque o valor de `count` nunca é
lido:

```dart
void main() {
  int [!count!] = 0;
}
```

## Correções comuns

Se a variável não é necessária, então remova-a.

Se a variável era para ser usada, então adicione o código faltante.
