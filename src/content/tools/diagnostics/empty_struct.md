---
ia-translate: true
title: empty_struct
description: >-
  Detalhes sobre o diagnóstico empty_struct
  produzido pelo analisador Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_A classe '{0}' não pode estar empty porque é uma subclasse de '{1}'._

## Description

O analisador produz este diagnóstico quando uma subclasse de `Struct` ou
`Union` não tem nenhum campo. Ter um `Struct` ou `Union` empty
não é suportado.

Para mais informações sobre FFI, consulte [Interoperabilidade C usando dart:ffi][ffi].

## Example

O código a seguir produz este diagnóstico porque a classe `C`, que
estende `Struct`, não declara nenhum campo:

```dart
import 'dart:ffi';

final class [!C!] extends Struct {}
```

## Common fixes

Se a classe deve ser um struct, então declare um ou mais campos:

```dart
import 'dart:ffi';

final class C extends Struct {
  @Int32()
  external int x;
}
```

Se a classe deve ser usada como um argumento de tipo para `Pointer`, então
torne-a uma subclasse de `Opaque`:

```dart
import 'dart:ffi';

final class C extends Opaque {}
```

Se a classe não deve ser um struct, então remova ou altere a
cláusula extends:

```dart
class C {}
```

[ffi]: /interop/c-interop
