---
ia-translate: true
title: subtype_of_ffi_class
description: >-
  Detalhes sobre o diagnóstico subtype_of_ffi_class
  produzido pelo analisador Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_A classe '{0}' não pode estender '{1}'._

_A classe '{0}' não pode implementar '{1}'._

_A classe '{0}' não pode misturar '{1}'._

## Description

O analisador produz este diagnóstico quando uma classe estende qualquer classe FFI
diferente de `Struct` ou `Union`, ou implementa ou mistura qualquer classe FFI.
`Struct` e `Union` são as únicas classes FFI que podem ser subtipos, e
apenas estendendo-as.

Para mais informações sobre FFI, veja [C interop using dart:ffi][ffi].

## Example

O código a seguir produz este diagnóstico porque a classe `C` estende
`Double`:

```dart
import 'dart:ffi';

final class C extends [!Double!] {}
```

## Common fixes

Se a classe deve estender `Struct` ou `Union`, então mude a
declaração da classe:

```dart
import 'dart:ffi';

final class C extends Struct {
  @Int32()
  external int i;
}
```

Se a classe não deve estender `Struct` ou `Union`, então remova quaisquer
referências a classes FFI:

```dart
final class C {}
```

[ffi]: /interop/c-interop
