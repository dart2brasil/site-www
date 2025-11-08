---
ia-translate: true
title: non_constant_default_value_from_deferred_library
description: "Detalhes sobre o diagnóstico non_constant_default_value_from_deferred_library produzido pelo analisador do Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_Constant values from a deferred library can't be used as a default parameter value._

## Description

O analisador produz este diagnóstico quando o valor default de um parâmetro
opcional usa uma constante de uma biblioteca importada usando um import deferred.
Valores default precisam estar disponíveis em tempo de compilação, e constantes de
bibliotecas deferred não estão disponíveis em tempo de compilação.

Para mais informações, consulte
[Lazily loading a library](https://dart.dev/language/libraries#lazily-loading-a-library).

## Example

Dado um arquivo `a.dart` que define a constante `zero`:

```dart
const zero = 0;
```

O código a seguir produz este diagnóstico porque `zero` é declarado em uma
biblioteca importada usando um import deferred:

```dart
import 'a.dart' deferred as a;

void f({int x = a.[!zero!]}) {}
```

## Common fixes

Se você precisa referenciar a constante da biblioteca importada, então
remova a keyword `deferred`:

```dart
import 'a.dart' as a;

void f({int x = a.zero}) {}
```

Se você não precisa referenciar a constante, então substitua o valor
default:

```dart
void f({int x = 0}) {}
```
