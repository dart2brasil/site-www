---
ia-translate: true
title: type_test_with_non_type
description: >-
  Detalhes sobre o diagnóstico type_test_with_non_type
  produzido pelo analisador Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_O nome '{0}' não é um type e não pode ser usado em uma expressão 'is'._

## Descrição

O analisador produz este diagnóstico quando o lado direito de um teste `is`
ou `is!` não é um tipo.

## Exemplo

O código a seguir produz este diagnóstico porque o lado direito é
um parâmetro, não um tipo:

```dart
typedef B = int Function(int);

void f(Object a, B b) {
  if (a is [!b!]) {
    return;
  }
}
```

## Correções comuns

Se você pretendia usar um teste de tipo, então substitua o lado direito por um
tipo:

```dart
typedef B = int Function(int);

void f(Object a, B b) {
  if (a is B) {
    return;
  }
}
```

Se você pretendia usar um tipo diferente de teste, então altere o teste:

```dart
typedef B = int Function(int);

void f(Object a, B b) {
  if (a == b) {
    return;
  }
}
```
