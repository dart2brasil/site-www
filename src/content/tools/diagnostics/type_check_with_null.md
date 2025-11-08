---
ia-translate: true
title: type_check_with_null
description: >-
  Detalhes sobre o diagnóstico type_check_with_null
  produzido pelo analisador Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_Testes para não-null devem ser feitos com '!= null'._

_Testes para null devem ser feitos com '== null'._

## Descrição

O analisador produz este diagnóstico quando há uma verificação de tipo (usando o
operador `as`) onde o tipo é `Null`. Há apenas um valor cujo tipo
é `Null`, então o código é mais legível e mais performático quando ele
testa `null` explicitamente.

## Exemplos

O código a seguir produz este diagnóstico porque o código está testando para
ver se o valor de `s` é `null` usando uma verificação de tipo:

```dart
void f(String? s) {
  if ([!s is Null!]) {
    return;
  }
  print(s);
}
```

O código a seguir produz este diagnóstico porque o código está testando para
ver se o valor de `s` é algo diferente de `null` usando uma verificação
de tipo:

```dart
void f(String? s) {
  if ([!s is! Null!]) {
    print(s);
  }
}
```

## Correções comuns

Substitua a verificação de tipo pela comparação equivalente com `null`:

```dart
void f(String? s) {
  if (s == null) {
    return;
  }
  print(s);
}
```
