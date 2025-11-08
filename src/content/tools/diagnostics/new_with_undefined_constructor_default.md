---
ia-translate: true
title: new_with_undefined_constructor_default
description: >-
  Detalhes sobre o diagnóstico new_with_undefined_constructor_default
  produzido pelo analisador do Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_The class '{0}' doesn't have an unnamed constructor._

## Description

O analisador produz este diagnóstico quando um construtor sem nome é
invocado em uma classe que define construtores nomeados, mas a classe não
possui um construtor sem nome.

## Example

O código a seguir produz este diagnóstico porque `A` não define um
construtor sem nome:

```dart
class A {
  A.a();
}

A f() => [!A!]();
```

## Common fixes

Se um dos construtores nomeados faz o que você precisa, então use-o:

```dart
class A {
  A.a();
}

A f() => A.a();
```

Se nenhum dos construtores nomeados faz o que você precisa, e você pode
adicionar um construtor sem nome, então adicione o construtor:

```dart
class A {
  A();
  A.a();
}

A f() => A();
```
