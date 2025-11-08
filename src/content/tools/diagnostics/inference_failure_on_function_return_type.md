---
title: inference_failure_on_function_return_type
description: >-
  Details about the inference_failure_on_function_return_type
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_The return type of '{0}' can't be inferred._

## Descrição

O analisador produz este diagnóstico quando:
- the language option `strict-inference` is enabled in the analysis options file,
- the declaration of a method or function has no return type, and
- the return type can't be inferred.

## Exemplo

Given an analysis options file containing the following:

```yaml
analyzer:
  language:
    strict-inference: true
```

O código a seguir produz este diagnóstico porque the method `m` doesn't
have a return type:

```dart
class C {
  [!m!]() => 7;
}
```

## Correções comuns

Add a return type to the method or function:

```dart
class C {
  int m() => 7;
}
```
