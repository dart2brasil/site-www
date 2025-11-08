---
title: await_of_incompatible_type
description: "Detalhes sobre o diagnóstico await_of_incompatible_type produzido pelo analisador Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_A expressão 'await' não pode ser usada para uma expressão com um extension type que não é um subtipo de 'Future'._

## Description

O analisador produz este diagnóstico quando o type da expressão em
uma expressão `await` é um extension type, e o extension type não é uma
subclasse de `Future`.

## Example

O código a seguir produz este diagnóstico porque o extension type `E`
não é uma subclasse de `Future`:

```dart
extension type E(int i) {}

void f(E e) async {
  [!await!] e;
}
```

## Common fixes

Se o extension type está definido corretamente, então remova o `await`:

```dart
extension type E(int i) {}

void f(E e) {
  e;
}
```

Se o extension type deve ser aguardável (awaitable), então adicione `Future` (ou um
subtipo de `Future`) à cláusula `implements` (adicionando uma cláusula `implements`
caso ainda não exista), e faça o tipo de representação
corresponder:

```dart
extension type E(Future<int> i) implements Future<int> {}

void f(E e) async {
  await e;
}
```
