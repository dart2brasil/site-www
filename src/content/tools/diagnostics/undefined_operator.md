---
ia-translate: true
title: undefined_operator
description: "Detalhes sobre o diagnóstico undefined_operator produzido pelo analisador Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_O operador '{0}' não está definido para o tipo '{1}'._

## Descrição

O analisador produz este diagnóstico quando um operador definível pelo usuário é
invocado em um objeto para o qual o operador não está definido.

## Exemplo

O código a seguir produz este diagnóstico porque a classe `C` não
define o operador `+`:

```dart
class C {}

C f(C c) => c [!+!] 2;
```

## Correções comuns

Se o operador deve ser definido para a classe, então defina-o:

```dart
class C {
  C operator +(int i) => this;
}

C f(C c) => c + 2;
```
