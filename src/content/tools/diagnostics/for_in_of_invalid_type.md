---
ia-translate: true
title: for_in_of_invalid_type
description: "Detalhes sobre o diagnóstico for_in_of_invalid_type produzido pelo analisador Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_O tipo '{0}' usado no loop 'for' deve implementar '{1}'._

## Descrição

O analisador produz este diagnóstico quando a expressão seguindo `in` em
um loop for-in tem um tipo que não é uma subclasse de `Iterable`.

## Exemplo

O código a seguir produz este diagnóstico porque `m` é um `Map`, e
`Map` não é uma subclasse de `Iterable`:

```dart
void f(Map<String, String> m) {
  for (String s in [!m!]) {
    print(s);
  }
}
```

## Correções comuns

Substitua a expressão por uma que produza um valor iterável:

```dart
void f(Map<String, String> m) {
  for (String s in m.values) {
    print(s);
  }
}
```
