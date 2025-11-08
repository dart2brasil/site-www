---
ia-translate: true
title: must_be_a_subtype
description: "Detalhes sobre o diagnóstico must_be_a_subtype produzido pelo analisador Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_The type '{0}' must be a subtype of '{1}' for '{2}'._

## Descrição

O analisador produz este diagnóstico em dois casos:
- Numa invocação de `Pointer.fromFunction` ou um construtor
  `NativeCallable` onde o argumento de tipo
  (explícito ou inferido) não é um supertipo do tipo da
  função passada como primeiro argumento do método.
- Numa invocação de `DynamicLibrary.lookupFunction` onde o primeiro argumento de tipo
  não é um supertipo do segundo argumento de tipo.

Para mais informações sobre FFI, veja [C interop usando dart:ffi][ffi].

## Exemplo

O código a seguir produz este diagnóstico porque o tipo da
função `f` (`String Function(int)`) não é um subtipo do argumento de tipo
`T` (`Int8 Function(Int8)`):

```dart
import 'dart:ffi';

typedef T = Int8 Function(Int8);

double f(double i) => i;

void g() {
  Pointer.fromFunction<T>([!f!], 5.0);
}
```

## Soluções comuns

Se a função estiver correta, então altere o argumento de tipo para corresponder:

```dart
import 'dart:ffi';

typedef T = Float Function(Float);

double f(double i) => i;

void g() {
  Pointer.fromFunction<T>(f, 5.0);
}
```

Se o argumento de tipo estiver correto, então altere a função para corresponder:

```dart
import 'dart:ffi';

typedef T = Int8 Function(Int8);

int f(int i) => i;

void g() {
  Pointer.fromFunction<T>(f, 5);
}
```

[ffi]: /interop/c-interop
