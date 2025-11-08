---
ia-translate: true
title: invalid_annotation_constant_value_from_deferred_library
description: "Detalhes sobre o diagnóstico invalid_annotation_constant_value_from_deferred_library produzido pelo analisador do Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_Valores constantes de uma biblioteca deferred não podem ser usados em annotations._

## Description

O analisador produz este diagnóstico quando uma constante definida em uma
biblioteca que é importada como uma biblioteca deferred é referenciada na
lista de argumentos de uma annotation. Annotations são avaliadas em tempo
de compilação, e valores de bibliotecas deferred não estão disponíveis em
tempo de compilação.

Para mais informações, confira
[Lazily loading a library](https://dart.dev/language/libraries#lazily-loading-a-library).

## Example

O código a seguir produz este diagnóstico porque a constante `pi` está
sendo referenciada na lista de argumentos de uma annotation, mesmo que a
biblioteca que a define esteja sendo importada como uma biblioteca
deferred:

```dart
import 'dart:math' deferred as math;

class C {
  const C(double d);
}

@C(math.[!pi!])
void f () {}
```

## Common fixes

Se você precisa referenciar a constante importada, remova a keyword
`deferred`:

```dart
import 'dart:math' as math;

class C {
  const C(double d);
}

@C(math.pi)
void f () {}
```

Se o import precisa ser deferred e há outra constante apropriada, use essa
constante no lugar da constante da biblioteca deferred.
