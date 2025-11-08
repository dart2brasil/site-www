---
ia-translate: true
title: rethrow_outside_catch
description: >-
  Detalhes sobre o diagnóstico rethrow_outside_catch
  produzido pelo analisador do Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_Um rethrow deve estar dentro de uma cláusula catch._

## Description

O analisador produz este diagnóstico quando uma instrução `rethrow` está fora
de uma cláusula `catch`. A instrução `rethrow` é usada para lançar uma exceção
capturada novamente, mas não há exceção capturada fora de uma cláusula `catch`.

## Example

O código a seguir produz este diagnóstico porque a instrução `rethrow`
está fora de uma cláusula `catch`:

```dart
void f() {
  [!rethrow!];
}
```

## Common fixes

Se você está tentando relançar uma exceção, então envolva a instrução `rethrow`
em uma cláusula `catch`:

```dart
void f() {
  try {
    // ...
  } catch (exception) {
    rethrow;
  }
}
```

Se você está tentando lançar uma nova exceção, então substitua a instrução `rethrow`
por uma expressão `throw`:

```dart
void f() {
  throw UnsupportedError('Not yet implemented');
}
```
