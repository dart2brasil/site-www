---
ia-translate: true
title: redirect_to_abstract_class_constructor
description: "Detalhes sobre o diagnóstico redirect_to_abstract_class_constructor produzido pelo analisador Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_O construtor de redirecionamento '{0}' não pode redirecionar para um construtor da classe abstract '{1}'._

## Description

O analisador produz este diagnóstico quando um construtor redireciona para um
construtor em uma classe abstract.

## Example

O código a seguir produz este diagnóstico porque o factory
constructor em `A` redireciona para um construtor em `B`, mas `B` é uma
classe abstract:

```dart
class A {
  factory A() = [!B!];
}

abstract class B implements A {}
```

## Common fixes

Se o código redireciona para o construtor correto, então mude a classe para
que não seja abstract:

```dart
class A {
  factory A() = B;
}

class B implements A {}
```

Caso contrário, mude o factory constructor para que ele redirecione para um
construtor em uma classe concreta, ou tenha uma implementação concreta.
