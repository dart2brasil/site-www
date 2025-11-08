---
ia-translate: true
title: const_initialized_with_non_constant_value_from_deferred_library
description: >-
  Detalhes sobre o diagnóstico const_initialized_with_non_constant_value_from_deferred_library
  produzido pelo analisador do Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_Constant values from a deferred library can't be used to initialize a 'const' variable._

## Descrição

O analisador produz este diagnóstico quando uma variável `const` é
inicializada usando uma variável `const` de uma biblioteca que é importada
usando um import deferred. Constantes são avaliadas em tempo de compilação,
e valores de bibliotecas deferred não estão disponíveis em tempo de compilação.

Para mais informações, confira
[Carregamento lento de uma biblioteca](https://dart.dev/language/libraries#lazily-loading-a-library).

## Exemplo

O código a seguir produz este diagnóstico porque a variável `pi` está
sendo inicializada usando a constante `math.pi` da biblioteca
`dart:math`, e `dart:math` é importada como uma biblioteca deferred:

```dart
import 'dart:math' deferred as math;

const pi = math.[!pi!];
```

## Correções comuns

Se você precisa referenciar o valor da constante da biblioteca
importada, então remova a keyword `deferred`:

```dart
import 'dart:math' as math;

const pi = math.pi;
```

Se você não precisa referenciar a constante importada, então remova a
referência:

```dart
const pi = 3.14;
```
