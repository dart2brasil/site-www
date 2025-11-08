---
ia-translate: true
title: must_return_void
description: "Detalhes sobre o diagnóstico must_return_void produzido pelo analisador Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_The return type of the function passed to 'NativeCallable.listener' must be 'void' rather than '{0}'._

## Descrição

O analisador produz este diagnóstico quando você passa uma função
que não retorna `void` para o construtor `NativeCallable.listener`.

`NativeCallable.listener` cria um callable nativo que pode ser invocado
de qualquer thread. O código nativo que invoca o callable envia uma mensagem
de volta para o isolate que criou o callable e não aguarda uma
resposta. Portanto, não é possível retornar um resultado do callable.

Para mais informações sobre FFI, veja [C interop usando dart:ffi][ffi].

## Exemplo

O código a seguir produz este diagnóstico porque a função
`f` retorna `int` em vez de `void`.

```dart
import 'dart:ffi';

int f(int i) => i * 2;

void g() {
  NativeCallable<Int32 Function(Int32)>.listener([!f!]);
}
```

## Soluções comuns

Altere o tipo de retorno da função para `void`.

```dart
import 'dart:ffi';

void f(int i) => print(i * 2);

void g() {
  NativeCallable<Void Function(Int32)>.listener(f);
}
```

[ffi]: /interop/c-interop
