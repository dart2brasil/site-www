---
ia-translate: true
title: variable_pattern_keyword_in_declaration_context
description: "Detalhes sobre o diagnóstico variable_pattern_keyword_in_declaration_context produzido pelo analisador Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_Padrões de variable em contexto de declaração não podem especificar a keyword 'var' ou 'final'._

## Descrição

O analisador produz este diagnóstico quando um padrão de variable é usado
dentro de um contexto de declaração.

## Exemplo

O código a seguir produz este diagnóstico porque os padrões de variable
no padrão de registro estão em um contexto de declaração:

```dart
void f((int, int) r) {
  var ([!var!] x, y) = r;
  print(x + y);
}
```

## Correções comuns

Remova a keyword `var` ou `final` dentro do padrão de variable:

```dart
void f((int, int) r) {
  var (x, y) = r;
  print(x + y);
}
```
