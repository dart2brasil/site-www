---
ia-translate: true
title: invalid_annotation
description: "Detalhes sobre o diagnóstico invalid_annotation produzido pelo analisador do Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_Annotation deve ser uma referência a uma variável const ou uma invocação de construtor const._

## Description

O analisador produz este diagnóstico quando uma annotation é encontrada que
está usando algo que não é nem uma variável marcada como `const` nem a
invocação de um construtor `const`.

Getters não podem ser usados como annotations.

## Examples

O código a seguir produz este diagnóstico porque a variável `v` não é uma
variável `const`:

```dart
var v = 0;

[!@v!]
void f() {
}
```

O código a seguir produz este diagnóstico porque `f` não é uma variável:

```dart
[!@f!]
void f() {
}
```

O código a seguir produz este diagnóstico porque `f` não é um construtor:

```dart
[!@f()!]
void f() {
}
```

O código a seguir produz este diagnóstico porque `g` é um getter:

```dart
[!@g!]
int get g => 0;
```

## Common fixes

Se a annotation estiver referenciando uma variável que não é um construtor
`const`, adicione a keyword `const` à declaração da variável:

```dart
const v = 0;

@v
void f() {
}
```

Se a annotation não estiver referenciando uma variável, remova-a:

```dart
int v = 0;

void f() {
}
```
