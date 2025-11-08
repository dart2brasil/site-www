---
ia-translate: true
title: invalid_annotation_from_deferred_library
description: "Detalhes sobre o diagnóstico invalid_annotation_from_deferred_library produzido pelo analisador do Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_Valores constantes de uma biblioteca deferred não podem ser usados como annotations._

## Description

O analisador produz este diagnóstico quando uma constante de uma biblioteca
que é importada usando um import deferred é usada como uma annotation.
Annotations são avaliadas em tempo de compilação, e constantes de
bibliotecas deferred não estão disponíveis em tempo de compilação.

Para mais informações, confira
[Lazily loading a library](https://dart.dev/language/libraries#lazily-loading-a-library).

## Example

O código a seguir produz este diagnóstico porque a constante `pi` está
sendo usada como uma annotation quando a biblioteca `dart:math` é importada
como `deferred`:

```dart
import 'dart:math' deferred as math;

@[!math.pi!]
void f() {}
```

## Common fixes

Se você precisa referenciar a constante como uma annotation, remova a
keyword `deferred` do import:

```dart
import 'dart:math' as math;

@math.pi
void f() {}
```

Se você pode usar uma constante diferente como annotation, substitua a
annotation por uma constante diferente:

```dart
@deprecated
void f() {}
```
