---
title: missing_size_annotation_carray
description: "Detalhes sobre o diagnóstico missing_size_annotation_carray produzido pelo analisador Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_Campos do tipo 'Array' devem ter exatamente uma anotação 'Array'._

## Description

O analisador produz este diagnóstico quando um campo em uma subclasse de
`Struct` ou `Union` tem um tipo `Array` mas não tem uma única
anotação `Array` indicando as dimensões do array.

Para mais informações sobre FFI, consulte [Interoperabilidade C usando dart:ffi][ffi].

## Example

O código a seguir produz este diagnóstico porque o campo `a0` não tem
uma anotação `Array`:

```dart
import 'dart:ffi';

final class C extends Struct {
  external [!Array<Uint8>!] a0;
}
```

## Common fixes

Certifique-se de que há exatamente uma anotação `Array` no campo:

```dart
import 'dart:ffi';

final class C extends Struct {
  @Array(8)
  external Array<Uint8> a0;
}
```

[ffi]: /interop/c-interop
