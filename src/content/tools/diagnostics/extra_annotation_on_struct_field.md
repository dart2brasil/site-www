---
ia-translate: true
title: extra_annotation_on_struct_field
description: "Detalhes sobre o diagnóstico extra_annotation_on_struct_field produzido pelo analisador do Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_Campos em uma classe struct devem ter exatamente uma anotação indicando o tipo nativo._

## Descrição

O analisador produz este diagnóstico quando um campo em uma subclasse de
`Struct` tem mais de uma anotação descrevendo o tipo nativo do
campo.

Para mais informações sobre FFI, veja [Interoperabilidade C usando dart:ffi][ffi].

## Exemplo

O código a seguir produz este diagnóstico porque o campo `x` tem duas
anotações descrevendo o tipo nativo do campo:

```dart
import 'dart:ffi';

final class C extends Struct {
  @Int32()
  [!@Int16()!]
  external int x;
}
```

## Correções comuns

Remova todas as anotações exceto uma:

```dart
import 'dart:ffi';
final class C extends Struct {
  @Int32()
  external int x;
}
```

[ffi]: /interop/c-interop
