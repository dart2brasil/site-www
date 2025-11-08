---
title: inference_failure_on_uninitialized_variable
description: >-
  Details about the inference_failure_on_uninitialized_variable
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_The type of {0} can't be inferred without either a type or initializer._

## Descrição

O analisador produz este diagnóstico quando:
- the language option `strict-inference` is enabled in the analysis options file,
- the declaration of a variable has no type, and
- the type of the variable can't be inferred.

## Exemplo

Given an analysis options file containing the following:

```yaml
analyzer:
  language:
    strict-inference: true
```

O código a seguir produz este diagnóstico porque the variable `s`
não tem uma explicit type and the type can't be inferred because
there's no initializer:

```dart
var [!s!];
```

## Correções comuns

Adicione uma explicit type:

```dart
String? s;
```
