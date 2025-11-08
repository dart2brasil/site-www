---
ia-translate: true
title: non_constant_type_argument
description: >-
  Detalhes sobre o diagnóstico non_constant_type_argument
  produzido pelo analisador do Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_Os argumentos de tipo para '{0}' devem ser conhecidos em tempo de compilação, então não podem ser parâmetros de tipo._

## Descrição

O analisador produz este diagnóstico quando os argumentos de tipo para um método
são obrigatórios para serem conhecidos em tempo de compilação, mas um parâmetro de tipo, cujo
valor não pode ser conhecido em tempo de compilação, é usado como argumento de tipo.

Para mais informações sobre FFI, veja [Interoperabilidade C usando dart:ffi][ffi].

## Exemplo

O código a seguir produz este diagnóstico porque o argumento de tipo para
`Pointer.asFunction` deve ser conhecido em tempo de compilação, mas o parâmetro de tipo
`R`, que não é conhecido em tempo de compilação, está sendo usado como argumento de
tipo:

```dart
import 'dart:ffi';

typedef T = int Function(int);

class C<R extends T> {
  void m(Pointer<NativeFunction<T>> p) {
    p.asFunction<[!R!]>();
  }
}
```

## Correções comuns

Remova todos os usos de parâmetros de tipo:

```dart
import 'dart:ffi';

class C {
  void m(Pointer<NativeFunction<Int64 Function(Int64)>> p) {
    p.asFunction<int Function(int)>();
  }
}
```

[ffi]: /interop/c-interop
