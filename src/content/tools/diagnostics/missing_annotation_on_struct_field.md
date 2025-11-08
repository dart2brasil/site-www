---
title: missing_annotation_on_struct_field
description: >-
  Detalhes sobre o diagnóstico missing_annotation_on_struct_field
  produzido pelo analisador Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_Campos do tipo '{0}' em uma subclasse de '{1}' devem ter uma anotação indicando o tipo nativo._

## Description

O analisador produz este diagnóstico quando um campo em uma subclasse de
`Struct` ou `Union` cujo tipo requer uma anotação não tem uma.
Os tipos Dart `int`, `double` e `Array` são usados para representar múltiplos
tipos C, e a anotação especifica qual dos tipos C compatíveis o
campo representa.

Para mais informações sobre FFI, consulte [Interoperabilidade C usando dart:ffi][ffi].

## Example

O código a seguir produz este diagnóstico porque o campo `x` não tem
uma anotação indicando a largura subjacente do valor inteiro:

```dart
import 'dart:ffi';

final class C extends Struct {
  external [!int!] x;
}
```

## Common fixes

Adicione uma anotação apropriada ao campo:

```dart
import 'dart:ffi';

final class C extends Struct {
  @Int64()
  external int x;
}
```

[ffi]: /interop/c-interop
