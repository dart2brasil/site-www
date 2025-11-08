---
ia-translate: true
title: redirect_to_non_class
description: "Detalhes sobre o diagnóstico redirect_to_non_class produzido pelo analisador Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_O nome '{0}' não é um tipo e não pode ser usado em um construtor redirecionado._

## Description

Uma forma de implementar um factory constructor é redirecionar para outro
construtor referenciando o nome do construtor. O analisador
produz este diagnóstico quando o redirecionamento é para algo diferente de um
construtor.

## Example

O código a seguir produz este diagnóstico porque `f` é uma função:

```dart
C f() => throw 0;

class C {
  factory C() = [!f!];
}
```

## Common fixes

Se o construtor não está definido, então defina-o ou substitua-o por
um construtor que está definido.

Se o construtor está definido mas a classe que o define não está visível,
então você provavelmente precisa adicionar um import.

Se você está tentando retornar o valor retornado por uma função, então reescreva
o construtor para retornar o valor do corpo do construtor:

```dart
C f() => throw 0;

class C {
  factory C() => f();
}
```
