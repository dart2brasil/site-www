---
ia-translate: true
title: multiple_redirecting_constructor_invocations
description: "Detalhes sobre o diagnóstico multiple_redirecting_constructor_invocations produzido pelo analisador do Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_Construtores podem ter apenas um redirecionamento 'this', no máximo._

## Description

O analisador produz este diagnóstico quando um construtor redireciona para mais
de um outro construtor na mesma classe (usando `this`).

## Example

O código a seguir produz este diagnóstico porque o construtor
sem nome em `C` está redirecionando para `this.a` e `this.b`:

```dart
class C {
  C() : this.a(), [!this.b()!];
  C.a();
  C.b();
}
```

## Common fixes

Remova todos, exceto um dos redirecionamentos:

```dart
class C {
  C() : this.a();
  C.a();
  C.b();
}
```
