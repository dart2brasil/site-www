---
ia-translate: true
title: tearoff_of_generative_constructor_of_abstract_class
description: "Detalhes sobre o diagnóstico tearoff_of_generative_constructor_of_abstract_class produzido pelo analisador Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_Um generative constructor de uma classe abstract não pode ter tearoff._

## Description

O analisador produz este diagnóstico quando um generative constructor de uma
classe abstract está tendo tearoff. Isso não é permitido porque não é válido
criar uma instância de uma classe abstract, o que significa que não há
nenhum uso válido para o construtor com tearoff.

## Example

O código a seguir produz este diagnóstico porque o construtor `C.new`
está tendo tearoff e a classe `C` é uma classe abstract:

```dart
abstract class C {
  C();
}

void f() {
  [!C.new!];
}
```

## Common fixes

Faça tearoff do construtor de uma classe concreta.
