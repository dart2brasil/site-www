---
ia-translate: true
title: default_value_in_redirecting_factory_constructor
description: "Detalhes sobre o diagnóstico default_value_in_redirecting_factory_constructor produzido pelo analisador Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_Valores default não são permitidos em construtores factory que redirecionam para outro construtor._

## Description

O analisador produz este diagnóstico quando um construtor factory que
redireciona para outro construtor especifica um valor default para um
parâmetro opcional.

## Example

O código a seguir produz este diagnóstico porque o construtor factory
em `A` tem um valor default para o parâmetro opcional `x`:

```dart
class A {
  factory A([int [!x!] = 0]) = B;
}

class B implements A {
  B([int x = 1]) {}
}
```

## Common fixes

Remova o valor default do construtor factory:

```dart
class A {
  factory A([int x]) = B;
}

class B implements A {
  B([int x = 1]) {}
}
```

Note que esta correção pode mudar o valor usado quando o parâmetro opcional
é omitido. Se isso acontecer, e se essa mudança é um problema, então considere
tornar o parâmetro opcional um parâmetro obrigatório no método factory:

```dart
class A {
 factory A(int x) = B;
}

class B implements A {
  B([int x = 1]) {}
}
```
