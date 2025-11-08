---
ia-translate: true
title: dot_shorthand_undefined_member
description: "Detalhes sobre o diagnóstico dot_shorthand_undefined_member produzido pelo analisador do Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_O getter static '{0}' não está definido para o tipo de contexto '{1}'._

_O método static ou construtor '{0}' não está definido para o tipo de contexto '{1}'._

## Description

O analisador produz este diagnóstico quando um dot shorthand é usado para
referenciar um membro, mas esse membro não existe.

## Example

O código a seguir produz este diagnóstico porque o enum `E` não
define um membro static chamado `c`:

```dart
void f() {
  E e = .[!c!];
  print(e);
}

enum E {a, b}
```

## Common fixes

Se o nome está correto, então defina um membro com esse nome no tipo de
contexto, que neste caso é o enum `E`:

```dart
void f() {
  E e = .c;
  print(e);
}

enum E {a, b, c}
```

Se o nome não está correto, então substitua o nome pelo nome de um
membro existente do tipo de contexto, que neste caso é o enum `E`:

```dart
void f() {
  E e = .b;
  print(e);
}

enum E {a, b}
```
