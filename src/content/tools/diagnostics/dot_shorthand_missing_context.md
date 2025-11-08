---
ia-translate: true
title: dot_shorthand_missing_context
description: "Detalhes sobre o diagnóstico dot_shorthand_missing_context produzido pelo analisador do Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_Um dot shorthand não pode ser usado onde não há tipo de contexto._

## Description

O analisador produz este diagnóstico quando um dot shorthand é usado onde
não há tipo de contexto.

## Example

O código a seguir produz este diagnóstico porque não há tipo de contexto
para a expressão `.a`:

```dart
void f() {
  var e = [!.a!];
  print(e);
}

enum E {a, b}
```

## Common fixes

Se você quer usar um dot shorthand, então adicione um tipo de contexto, que neste
exemplo significa adicionar o tipo explícito `E` à variável local:

```dart
void f() {
  E e = .a;
  print(e);
}

enum E {a, b}
```

Se você não quer adicionar um tipo de contexto, então especifique o nome do
tipo contendo o membro sendo referenciado, que neste caso é `E`:

```dart
void f() {
  var e = E.a;
  print(e);
}

enum E {a, b}
```
