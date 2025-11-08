---
ia-translate: true
title: must_be_a_native_function_type
description: "Detalhes sobre o diagnóstico must_be_a_native_function_type produzido pelo analisador Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_The type '{0}' given to '{1}' must be a valid 'dart:ffi' native function type._

## Descrição

O analisador produz este diagnóstico quando uma invocação de
`Pointer.fromFunction`, `DynamicLibrary.lookupFunction`,
ou um construtor `NativeCallable`, tem um argumento de tipo
(explícito ou inferido) que não é um tipo de função nativa.

Para mais informações sobre FFI, veja [C interop usando dart:ffi][ffi].

## Exemplo

O código a seguir produz este diagnóstico porque o tipo `T` pode ser
qualquer subclasse de `Function`, mas o argumento de tipo para `fromFunction`
é necessário que seja um tipo de função nativa:

```dart
import 'dart:ffi';

int f(int i) => i * 2;

class C<T extends Function> {
  void g() {
    Pointer.fromFunction<[!T!]>(f, 0);
  }
}
```

## Soluções comuns

Use um tipo de função nativa como o argumento de tipo para a invocação:

```dart
import 'dart:ffi';

int f(int i) => i * 2;

class C<T extends Function> {
  void g() {
    Pointer.fromFunction<Int32 Function(Int32)>(f, 0);
  }
}
```

[ffi]: /interop/c-interop
