---
ia-translate: true
title: recursive_constructor_redirect
description: "Detalhes sobre o diagnóstico recursive_constructor_redirect produzido pelo analisador Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_Construtores não podem redirecionar para si mesmos direta ou indiretamente._

## Description

O analisador produz este diagnóstico quando um construtor redireciona para
si mesmo, direta ou indiretamente, criando um loop infinito.

## Examples

O código a seguir produz este diagnóstico porque os construtores
generativos `C.a` e `C.b` redirecionam um para o outro:

```dart
class C {
  C.a() : [!this.b()!];
  C.b() : [!this.a()!];
}
```

O código a seguir produz este diagnóstico porque os construtores
factory `A` e `B` redirecionam um para o outro:

```dart
abstract class A {
  factory A() = [!B!];
}
class B implements A {
  factory B() = [!A!];
  B.named();
}
```

## Common fixes

No caso de construtores generativos, quebre o ciclo definindo
pelo menos um dos construtores para não redirecionar para outro construtor:

```dart
class C {
  C.a() : this.b();
  C.b();
}
```

No caso de construtores factory, quebre o ciclo definindo pelo menos
um dos construtores factory para fazer uma das seguintes ações:

- Redirecionar para um construtor generativo:

```dart
abstract class A {
  factory A() = B;
}
class B implements A {
  factory B() = B.named;
  B.named();
}
```

- Não redirecionar para outro construtor:

```dart
abstract class A {
  factory A() = B;
}
class B implements A {
  factory B() {
    return B.named();
  }

  B.named();
}
```

- Não ser um construtor factory:

```dart
abstract class A {
  factory A() = B;
}
class B implements A {
  B();
  B.named();
}
```
