---
ia-translate: true
title: const_with_type_parameters
description: "Detalhes sobre o diagnóstico const_with_type_parameters produzido pelo analisador do Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_A constant constructor tearoff can't use a type parameter as a type argument._

_A constant creation can't use a type parameter as a type argument._

_A constant function tearoff can't use a type parameter as a type argument._

## Descrição

O analisador produz este diagnóstico quando um type parameter é usado como
um argumento de tipo em uma invocação `const` de um constructor. Isso não é
permitido porque o valor do type parameter (o tipo real que será usado
em tempo de execução) não pode ser conhecido em tempo de compilação.

## Exemplo

O código a seguir produz este diagnóstico porque o type parameter `T`
está sendo usado como argumento de tipo ao criar uma constante:

```dart
class C<T> {
  const C();
}

C<T> newC<T>() => const C<[!T!]>();
```

## Correções comuns

Se o tipo que será usado para o type parameter pode ser conhecido em
tempo de compilação, então remova o uso do type parameter:

```dart
class C<T> {
  const C();
}

C<int> newC() => const C<int>();
```

Se o tipo que será usado para o type parameter não pode ser conhecido até
o tempo de execução, então remova a keyword `const`:

```dart
class C<T> {
  const C();
}

C<T> newC<T>() => C<T>();
```
