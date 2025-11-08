---
ia-translate: true
title: undefined_enum_constructor
description: >-
  Detalhes sobre o diagnóstico undefined_enum_constructor
  produzido pelo analisador Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_O enum não possui um construtor chamado '{0}'._

_O enum não possui um construtor sem nome._

## Descrição

O analisador produz este diagnóstico quando o construtor invocado para
inicializar um valor enum não existe.

## Exemplos

O código a seguir produz este diagnóstico porque o valor enum `c`
está sendo inicializado pelo construtor sem nome, mas não há nenhum
construtor sem nome definido em `E`:

```dart
enum E {
  [!c!]();

  const E.x();
}
```

O código a seguir produz este diagnóstico porque o valor enum `c` está
sendo inicializado pelo construtor chamado `x`, mas não há nenhum construtor
chamado `x` definido em `E`:

```dart
enum E {
  c.[!x!]();

  const E.y();
}
```

## Correções comuns

Se o valor enum está sendo inicializado pelo construtor sem nome e um
dos construtores nomeados deveria ter sido usado, então adicione o nome do
construtor:

```dart
enum E {
  c.x();

  const E.x();
}
```

Se o valor enum está sendo inicializado pelo construtor sem nome e nenhum
dos construtores nomeados é apropriado, então defina o construtor
sem nome:

```dart
enum E {
  c();

  const E();
}
```

Se o valor enum está sendo inicializado por um construtor nomeado e um dos
construtores existentes deveria ter sido usado, então altere o nome do
construtor sendo invocado (ou remova-o se o construtor sem nome
deveria ser usado):

```dart
enum E {
  c.y();

  const E();
  const E.y();
}
```

Se o valor enum está sendo inicializado por um construtor nomeado e nenhum dos
construtores existentes deveria ter sido usado, então defina um construtor
com o nome que foi usado:

```dart
enum E {
  c.x();

  const E.x();
}
```
