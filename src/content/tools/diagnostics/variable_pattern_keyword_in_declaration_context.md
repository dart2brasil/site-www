---
title: variable_pattern_keyword_in_declaration_context
description: >-
  Details about the variable_pattern_keyword_in_declaration_context
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_Variable patterns in declaration context can't specify 'var' or 'final' keyword._

## Descrição

O analisador produz este diagnóstico quando a variable pattern is used
within a declaration context.

## Exemplo

O código a seguir produz este diagnóstico porque the variable patterns
in the record pattern are in a declaration context:

```dart
void f((int, int) r) {
  var ([!var!] x, y) = r;
  print(x + y);
}
```

## Correções comuns

Remove the `var` or `final` keyword(s) within the variable pattern:

```dart
void f((int, int) r) {
  var (x, y) = r;
  print(x + y);
}
```
