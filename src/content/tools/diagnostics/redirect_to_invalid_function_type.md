---
ia-translate: true
title: redirect_to_invalid_function_type
description: >-
  Detalhes sobre o diagnóstico redirect_to_invalid_function_type
  produzido pelo analisador Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_O construtor redirecionado '{0}' tem parâmetros incompatíveis com '{1}'._

## Descrição

O analisador produz este diagnóstico quando um factory constructor tenta
redirecionar para outro construtor, mas os dois têm
parâmetros incompatíveis. Os parâmetros são compatíveis se todos os parâmetros do
construtor redirecionador podem ser passados para o outro construtor e se o
outro construtor não requer parâmetros que não estejam declarados pelo
construtor redirecionador.

## Exemplos

O código a seguir produz este diagnóstico porque o construtor para `A`
não declara um parâmetro que o construtor para `B` requer:

```dart
abstract class A {
  factory A() = [!B!];
}

class B implements A {
  B(int x);
  B.zero();
}
```

O código a seguir produz este diagnóstico porque o construtor para `A`
declara um parâmetro nomeado (`y`) que o construtor para `B` não
permite:

```dart
abstract class A {
  factory A(int x, {int y}) = [!B!];
}

class B implements A {
  B(int x);
}
```

## Correções comuns

Se houver um construtor diferente que seja compatível com o
construtor redirecionador, redirecione para esse construtor:

```dart
abstract class A {
  factory A() = B.zero;
}

class B implements A {
  B(int x);
  B.zero();
}
```

Caso contrário, atualize o construtor redirecionador para ser compatível:

```dart
abstract class A {
  factory A(int x) = B;
}

class B implements A {
  B(int x);
}
```
