---
ia-translate: true
title: extension_declares_abstract_member
description: "Detalhes sobre o diagnóstico extension_declares_abstract_member produzido pelo analisador Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_Extensions não podem declarar membros abstratos._

## Descrição

O analisador produz este diagnóstico quando uma declaração abstrata é
declarada em uma extension. Extensions podem declarar apenas membros concretos.

## Exemplo

O código a seguir produz este diagnóstico porque o método `a` não
possui um corpo:

```dart
extension E on String {
  int [!a!]();
}
```

## Correções comuns

Forneça uma implementação para o membro ou remova-o.
