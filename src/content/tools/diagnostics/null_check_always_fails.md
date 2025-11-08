---
ia-translate: true
title: null_check_always_fails
description: "Detalhes sobre o diagnóstico null_check_always_fails produzido pelo analisador do Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_This null-check will always throw an exception because the expression will always evaluate to 'null'._

## Description

O analisador produz este diagnóstico quando o operador de verificação null (`!`)
é usado em uma expressão cujo valor só pode ser `null`. Nesse caso
o operador sempre lança uma exceção, o que provavelmente não é o comportamento
pretendido.

## Example

O código a seguir produz este diagnóstico porque a função `g` sempre
retornará `null`, o que significa que a verificação null em `f` sempre
lançará uma exceção:

```dart
void f() {
  [!g()!!];
}

Null g() => null;
```

## Common fixes

Se você pretende sempre lançar uma exceção, então substitua a verificação null
por uma expressão `throw` explícita para tornar a intenção mais clara:

```dart
void f() {
  g();
  throw TypeError();
}

Null g() => null;
```
