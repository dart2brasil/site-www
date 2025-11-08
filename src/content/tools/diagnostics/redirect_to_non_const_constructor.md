---
ia-translate: true
title: redirect_to_non_const_constructor
description: "Detalhes sobre o diagnóstico redirect_to_non_const_constructor produzido pelo analisador Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_Um construtor redirecionador constante não pode redirecionar para um construtor não-constante._

## Descrição

O analisador produz este diagnóstico quando um construtor marcado como `const`
redireciona para um construtor que não é marcado como `const`.

## Exemplo

O código a seguir produz este diagnóstico porque o construtor `C.a`
é marcado como `const` mas redireciona para o construtor `C.b`, que não é:

```dart
class C {
  const C.a() : this.[!b!]();
  C.b();
}
```

## Correções comuns

Se o construtor não-constante pode ser marcado como `const`, então marque-o como
`const`:

```dart
class C {
  const C.a() : this.b();
  const C.b();
}
```

Se o construtor não-constante não pode ser marcado como `const`, então
remova o redirecionamento ou remova `const` do construtor redirecionador:

```dart
class C {
  C.a() : this.b();
  C.b();
}
```
