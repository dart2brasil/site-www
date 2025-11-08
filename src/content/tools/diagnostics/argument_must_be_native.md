---
ia-translate: true
title: argument_must_be_native
description: "Detalhes sobre o diagnóstico argument_must_be_native produzido pelo analisador Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_Argument to 'Native.addressOf' must be annotated with @Native_

## Description

O analisador produz este diagnóstico quando o argument passado para
`Native.addressOf` não está anotado com a annotation `Native`.

## Examples

O código a seguir produz este diagnóstico porque o argument para
`addressOf` é uma string, não um field, e strings não podem ser anotadas:

```dart
import 'dart:ffi';

@Native<Void Function()>()
external void f();

void g() {
  print(Native.addressOf([!'f'!]));
}
```

O código a seguir produz este diagnóstico porque a função `f` está
sendo passada para `addressOf` mas não está anotada como sendo `Native`:

```dart
import 'dart:ffi';

external void f();

void g() {
  print(Native.addressOf<NativeFunction<Void Function()>>([!f!]));
}
```

## Common fixes

Se o argument não é um field nem uma função, então substitua o
argument por um field ou função que esteja anotado com `Native`:

```dart
import 'dart:ffi';

@Native<Void Function()>()
external void f();

void g() {
  print(Native.addressOf<NativeFunction<Void Function()>>(f));
}
```

Se o argument é um field ou uma função, então anote o field
ou função com `Native`:

```dart
import 'dart:ffi';

@Native<Void Function()>()
external void f();

void g() {
  print(Native.addressOf<NativeFunction<Void Function()>>(f));
}
```
