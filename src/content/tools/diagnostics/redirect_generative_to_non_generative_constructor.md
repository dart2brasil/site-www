---
ia-translate: true
title: redirect_generative_to_non_generative_constructor
description: >-
  Detalhes sobre o diagnóstico redirect_generative_to_non_generative_constructor
  produzido pelo analisador Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_Construtores generativos não podem redirecionar para um factory constructor._

## Descrição

O analisador produz este diagnóstico quando um construtor generativo
redireciona para um factory constructor.

## Exemplo

O código a seguir produz este diagnóstico porque o construtor
generativo `C.a` redireciona para o factory constructor `C.b`:

```dart
class C {
  C.a() : [!this.b()!];
  factory C.b() => C.a();
}
```

## Correções comuns

Se o construtor generativo não precisa redirecionar para outro
construtor, remova o redirecionamento.

```dart
class C {
  C.a();
  factory C.b() => C.a();
}
```

Se o construtor generativo deve redirecionar para outro construtor, faça
com que o outro construtor seja um construtor generativo (não-factory):

```dart
class C {
  C.a() : this.b();
  C.b();
}
```
