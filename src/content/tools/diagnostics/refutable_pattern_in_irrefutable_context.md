---
ia-translate: true
title: refutable_pattern_in_irrefutable_context
description: "Detalhes sobre o diagnóstico refutable_pattern_in_irrefutable_context produzido pelo analisador do Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_Refutable patterns não podem ser usados em um contexto irrefutable._

## Description

O analisador produz este diagnóstico quando um [refutable pattern][refutable pattern] é usado
em um contexto onde apenas um [irrefutable pattern][irrefutable pattern] é permitido.

Os refutable patterns que não são permitidos são:
- logical-or
- relational
- null-check
- constant

Os contextos que são verificados são:
- declarações de variáveis baseadas em pattern
- loops for baseados em pattern
- atribuições com um pattern no lado esquerdo

## Example

O código a seguir produz este diagnóstico porque o null-check
pattern, que é um refutable pattern, está em uma declaração de variável
baseada em pattern, que não permite refutable patterns:

```dart
void f(int? x) {
  var ([!_?!]) = x;
}
```

## Common fixes

Reescreva o código para não usar um refutable pattern em um contexto irrefutable.

[irrefutable pattern]: /resources/glossary#irrefutable-pattern
[refutable pattern]: /resources/glossary#refutable-pattern
