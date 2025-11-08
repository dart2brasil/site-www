---
ia-translate: true
title: mismatched_annotation_on_struct_field
description: >-
  Detalhes sobre o diagnóstico mismatched_annotation_on_struct_field
  produzido pelo analisador do Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_A anotação não corresponde ao tipo declarado do campo._

## Description

O analisador produz este diagnóstico quando a anotação em um campo em uma
subclasse de `Struct` ou `Union` não corresponde ao tipo Dart do campo.

Para mais informações sobre FFI, veja [Interoperabilidade C usando dart:ffi][ffi].

## Example

O código a seguir produz este diagnóstico porque a anotação
`Double` não corresponde ao tipo Dart `int`:

```dart
import 'dart:ffi';

final class C extends Struct {
  [!@Double()!]
  external int x;
}
```

## Common fixes

Se o tipo do campo está correto, então altere a anotação para corresponder:

```dart
import 'dart:ffi';

final class C extends Struct {
  @Int32()
  external int x;
}
```

Se a anotação está correta, então altere o tipo do campo para corresponder:

```dart
import 'dart:ffi';

final class C extends Struct {
  @Double()
  external double x;
}
```

[ffi]: /interop/c-interop
