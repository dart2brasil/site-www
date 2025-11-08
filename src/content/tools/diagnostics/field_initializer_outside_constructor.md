---
ia-translate: true
title: field_initializer_outside_constructor
description: "Detalhes sobre o diagnóstico field_initializer_outside_constructor produzido pelo analisador Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_Parâmetros formais de campo só podem ser usados em um construtor._

## Descrição

O analisador produz este diagnóstico quando um parâmetro formal
inicializador é usado na lista de parâmetros para qualquer coisa que não seja um
construtor.

## Exemplo

O código a seguir produz este diagnóstico porque o parâmetro formal
inicializador `this.x` está sendo usado no método `m`:

```dart
class A {
  int x = 0;

  m([[!this.x!] = 0]) {}
}
```

## Correções comuns

Substitua o parâmetro formal inicializador por um parâmetro normal e
atribua o campo dentro do corpo do método:

```dart
class A {
  int x = 0;

  m([int x = 0]) {
    this.x = x;
  }
}
```
