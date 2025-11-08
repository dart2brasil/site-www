---
ia-translate: true
title: non_constant_case_expression_from_deferred_library
description: "Detalhes sobre o diagnóstico non_constant_case_expression_from_deferred_library produzido pelo analisador do Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_Constant values from a deferred library can't be used as a case expression._

## Description

O analisador produz este diagnóstico quando a expressão em uma cláusula case
referencia uma constante de uma biblioteca que é importada usando um
import deferred. Para que comandos switch sejam compilados eficientemente, as
constantes referenciadas em cláusulas case precisam estar disponíveis em tempo de compilação,
e constantes de bibliotecas deferred não estão disponíveis em tempo de compilação.

Para mais informações, consulte
[Lazily loading a library](https://dart.dev/language/libraries#lazily-loading-a-library).

## Example

Dado um arquivo `a.dart` que define a constante `zero`:

```dart
const zero = 0;
```

O código a seguir produz este diagnóstico porque a biblioteca `a.dart` é
importada usando um import `deferred`, e a constante `a.zero`, declarada na
biblioteca importada, é usada em uma cláusula case:

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
