---
ia-translate: true
title: native_field_not_static
description: >-
  Detalhes sobre o diagnóstico native_field_not_static
  produzido pelo analisador do Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_Native fields must be static._

## Description

O analisador produz este diagnóstico quando um campo de instância em uma classe
foi anotado com `@Native`.
Campos native se referem a variáveis globais em C, C++ ou outras linguagens native,
enquanto campos de instância em Dart são específicos para uma instância daquela
classe. Portanto, campos native devem ser static.

Para mais informações sobre FFI, veja [C interop using dart:ffi][ffi].

## Example

O código a seguir produz este diagnóstico porque o campo `f` na
classe `C` é `@Native`, mas não é `static`:

```dart
import 'dart:ffi';

class C {
  @Native<Int>()
  external int [!f!];
}
```

## Common fixes

Torne o campo static:

```dart
import 'dart:ffi';

class C {
  @Native<Int>()
  external static int f;
}
```

Ou mova-o para fora da classe, caso em que nenhum modificador `static` explícito é
necessário:

```dart
import 'dart:ffi';

class C {
}

@Native<Int>()
external int f;
```

Se você pretendia anotar um campo de instância que deveria fazer parte de uma
struct, omita a annotation `@Native`:

```dart
import 'dart:ffi';

final class C extends Struct {
  @Int()
  external int f;
}
```

[ffi]: /interop/c-interop
