---
ia-translate: true
title: invalid_reference_to_generative_enum_constructor
description: >-
  Detalhes sobre o diagnóstico invalid_reference_to_generative_enum_constructor
  produzido pelo analisador do Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_Construtores generativos de enum só podem ser usados para criar uma constante de enum._

_Construtores generativos de enum não podem ser separados (torn off)._

## Description

O analisador produz este diagnóstico quando um construtor generativo
definido em um enum é usado em qualquer lugar que não seja para criar uma das constantes
do enum ou como alvo de um redirecionamento de outro construtor no
mesmo enum.

## Example

O código a seguir produz este diagnóstico porque o construtor de
`E` está sendo usado para criar uma instância na função `f`:

```dart
enum E {
  a(0);

  const E(int x);
}

E f() => const [!E!](2);
```

## Common fixes

Se existe um valor de enum com o mesmo valor, ou se você adicionar tal
constante, então referencie a constante diretamente:

```dart
enum E {
  a(0), b(2);

  const E(int x);
}

E f() => E.b;
```

Se você precisa usar uma invocação de construtor, então use um construtor
factory:

```dart
enum E {
  a(0);

  const E(int x);

  factory E.c(int x) => a;
}

E f() => E.c(2);
```
