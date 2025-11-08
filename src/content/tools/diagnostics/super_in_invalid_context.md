---
ia-translate: true
title: super_in_invalid_context
description: >-
  Detalhes sobre o diagnóstico super_in_invalid_context
  produzido pelo analisador Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_Contexto inválido para invocação de 'super'._

## Descrição

O analisador produz este diagnóstico quando a keyword `super` é usada
fora de um método de instância.

## Exemplo

O código a seguir produz este diagnóstico porque `super` é usado em uma
função de nível superior:

```dart
void f() {
  [!super!].f();
}
```

## Correções comuns

Reescreva o código para não usar `super`.
