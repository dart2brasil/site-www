---
ia-translate: true
title: type_test_with_undefined_name
description: >-
  Detalhes sobre o diagnóstico type_test_with_undefined_name
  produzido pelo analisador Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_O nome '{0}' não está definido, então não pode ser usado em uma expressão 'is'._

## Descrição

O analisador produz este diagnóstico quando o nome após `is` em uma
expressão de teste de tipo não está definido.

## Exemplo

O código a seguir produz este diagnóstico porque o nome `Srting` não está
definido:

```dart
void f(Object o) {
  if (o is [!Srting!]) {
    // ...
  }
}
```

## Correções comuns

Substitua o nome pelo nome de um tipo:

```dart
void f(Object o) {
  if (o is String) {
    // ...
  }
}
```
