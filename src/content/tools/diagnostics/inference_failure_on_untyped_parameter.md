---
title: inference_failure_on_untyped_parameter
description: >-
  Details about the inference_failure_on_untyped_parameter
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_The type of {0} can't be inferred; a type must be explicitly provided._

## Descrição

O analisador produz este diagnóstico quando:
- the language option `strict-inference` is enabled in the analysis options file,
- the declaration of a formal parameter has no type, and
- the type of the parameter can't be inferred.

The type of a method's parameter can be inferred if it overrides an
inherited method.

## Exemplo

Given an analysis options file containing the following:

```yaml
analyzer:
  language:
    strict-inference: true
```

O código a seguir produz este diagnóstico porque the formal parameter
`p` não tem uma explicit type and the type can't be inferred:

```dart
void f([!p!]) => print(p);
```

## Correções comuns

Adicione uma explicit type:

```dart
void f(int p) => print(p);
```
