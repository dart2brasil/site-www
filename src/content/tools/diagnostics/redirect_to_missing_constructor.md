---
ia-translate: true
title: redirect_to_missing_constructor
description: >-
  Detalhes sobre o diagnóstico redirect_to_missing_constructor
  produzido pelo analisador Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_O construtor '{0}' não pôde ser encontrado em '{1}'._

## Descrição

O analisador produz este diagnóstico quando um construtor redireciona para um
construtor que não existe.

## Exemplo

O código a seguir produz este diagnóstico porque o factory
constructor em `A` redireciona para um construtor em `B` que não existe:

```dart
class A {
  factory A() = [!B.name!];
}

class B implements A {
  B();
}
```

## Correções comuns

Se o construtor sendo redirecionado está correto, defina o
construtor:

```dart
class A {
  factory A() = B.name;
}

class B implements A {
  B();
  B.name();
}
```

Se um construtor diferente deveria ser invocado, atualize o redirecionamento:

```dart
class A {
  factory A() = B;
}

class B implements A {
  B();
}
```
