---
ia-translate: true
title: subtype_of_struct_class
description: >-
  Detalhes sobre o diagnóstico subtype_of_struct_class
  produzido pelo analisador Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_A classe '{0}' não pode estender '{1}' porque '{1}' é um subtipo de 'Struct', 'Union' ou 'AbiSpecificInteger'._

_A classe '{0}' não pode implementar '{1}' porque '{1}' é um subtipo de 'Struct', 'Union' ou 'AbiSpecificInteger'._

_A classe '{0}' não pode misturar '{1}' porque '{1}' é um subtipo de 'Struct', 'Union' ou 'AbiSpecificInteger'._

## Description

O analisador produz este diagnóstico quando uma classe estende, implementa ou
mistura uma classe que estende `Struct` ou `Union`. Classes só podem
estender `Struct` ou `Union` diretamente.

Para mais informações sobre FFI, veja [C interop using dart:ffi][ffi].

## Example

O código a seguir produz este diagnóstico porque a classe `C` estende
`S`, e `S` estende `Struct`:

```dart
import 'dart:ffi';

final class S extends Struct {
  external Pointer f;
}

final class C extends [!S!] {
  external Pointer g;
}
```

## Common fixes

Se você está tentando definir um struct ou union que compartilha alguns campos
declarados por um struct ou union diferente, então estenda `Struct` ou `Union`
diretamente e copie os campos compartilhados:

```dart
import 'dart:ffi';

final class S extends Struct {
  external Pointer f;
}

final class C extends Struct {
  external Pointer f;

  external Pointer g;
}
```

[ffi]: /interop/c-interop
