---
ia-translate: true
title: pattern_type_mismatch_in_irrefutable_context
description: "Detalhes sobre o diagnóstico pattern_type_mismatch_in_irrefutable_context produzido pelo analisador do Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_O valor correspondente do tipo '{0}' não é atribuível ao tipo requerido '{1}'._

## Description

O analisador produz este diagnóstico quando o tipo do valor no
lado direito de uma atribuição de padrão ou declaração de padrão não
corresponde ao tipo requerido pelo padrão sendo usado para corresponder a ele.

## Example

O código a seguir produz este diagnóstico porque `x` pode não ser uma
`String` e portanto pode não corresponder ao padrão de objeto:

```dart
void f(Object x) {
  var [!String(length: a)!] = x;
  print(a);
}
```

## Common fixes

Altere o código para que o tipo da expressão no lado direito
corresponda ao tipo requerido pelo padrão:

```dart
void f(String x) {
  var String(length: a) = x;
  print(a);
}
```
