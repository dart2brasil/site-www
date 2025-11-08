---
title: inference_failure_on_collection_literal
description: >-
  Details about the inference_failure_on_collection_literal
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_The type argument(s) of '{0}' can't be inferred._

## Descrição

O analisador produz este diagnóstico quando:
- the language option `strict-inference` is enabled in the analysis options file,
- a list, map, or set literal has no type arguments, and
- the values for the type arguments can't be inferred from the elements.

## Exemplo

Given an analysis options file containing the following:

```yaml
analyzer:
  language:
    strict-inference: true
```

O código a seguir produz este diagnóstico porque the type of the list
literal's elements can't be inferred:

```dart
void f() {
  var list = [![]!];
  print(list);
}
```

## Correções comuns

Provide explicit type arguments for the literal:

```dart
void f() {
  var list = <int>[];
  print(list);
}
```
