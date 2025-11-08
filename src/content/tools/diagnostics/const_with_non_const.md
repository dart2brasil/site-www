---
ia-translate: true
title: const_with_non_const
description: "Detalhes sobre o diagnóstico const_with_non_const produzido pelo analisador do Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_The constructor being called isn't a const constructor._

## Descrição

O analisador produz este diagnóstico quando a keyword `const` é usada para
invocar um constructor que não está marcado com `const`.

## Exemplo

O código a seguir produz este diagnóstico porque o constructor em `A`
não é um constructor const:

```dart
class A {
  A();
}

A f() => [!const!] A();
```

## Correções comuns

Se é desejável e possível tornar a classe uma classe constante (tornando
todos os fields da classe, incluindo fields herdados, final),
então adicione a keyword `const` ao constructor:

```dart
class A {
  const A();
}

A f() => const A();
```

Caso contrário, remova a keyword `const`:

```dart
class A {
  A();
}

A f() => A();
```
