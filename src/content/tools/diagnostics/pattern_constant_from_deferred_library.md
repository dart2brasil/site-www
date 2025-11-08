---
ia-translate: true
title: pattern_constant_from_deferred_library
description: >-
  Detalhes sobre o diagnóstico pattern_constant_from_deferred_library
  produzido pelo analisador do Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_Valores constantes de uma biblioteca deferred não podem ser usados em padrões._

## Description

O analisador produz este diagnóstico quando um padrão contém um valor
declarado em uma biblioteca diferente, e essa biblioteca é importada usando um
import deferred. Constantes são avaliadas em tempo de compilação, mas valores de
bibliotecas deferred não estão disponíveis em tempo de compilação.

Para mais informações, confira
[Lazily loading a library](https://dart.dev/language/libraries#lazily-loading-a-library).

## Example

Dado um arquivo `a.dart` que define a constante `zero`:

```dart
const zero = 0;
```

O código a seguir produz este diagnóstico porque o padrão constante
`a.zero` é importado usando um import deferred:

```dart
import 'a.dart' deferred as a;

void f(int x) {
  switch (x) {
    case a.[!zero!]:
      // ...
      break;
  }
}
```

## Common fixes

Se você precisa referenciar a constante da biblioteca importada, então
remova a keyword `deferred`:

```dart
import 'a.dart' as a;

void f(int x) {
  switch (x) {
    case a.zero:
      // ...
      break;
  }
}
```

Se você precisa referenciar a constante da biblioteca importada e também
precisa que a biblioteca importada seja deferred, então reescreva o comando switch
como uma sequência de comandos `if`:

```dart
import 'a.dart' deferred as a;

void f(int x) {
  if (x == a.zero) {
    // ...
  }
}
```

Se você não precisa referenciar a constante, então substitua a expressão
case:

```dart
void f(int x) {
  switch (x) {
    case 0:
      // ...
      break;
  }
}
```
