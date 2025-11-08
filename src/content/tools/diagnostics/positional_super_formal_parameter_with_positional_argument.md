---
ia-translate: true
title: positional_super_formal_parameter_with_positional_argument
description: >-
  Detalhes sobre o diagnóstico positional_super_formal_parameter_with_positional_argument
  produzido pelo analisador do Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_Parâmetros super posicionais não podem ser usados quando a invocação do construtor super tem um argumento posicional._

## Description

O analisador produz este diagnóstico quando alguns, mas não todos, dos
parâmetros posicionais fornecidos ao construtor da superclasse estão
usando um parâmetro super.

Parâmetros super posicionais são associados com parâmetros posicionais no
construtor super pelo seu índice. Ou seja, o primeiro parâmetro super
é associado com o primeiro parâmetro posicional no construtor
super, o segundo com o segundo, e assim por diante. O mesmo é verdade para
argumentos posicionais. Ter ambos parâmetros super posicionais e
argumentos posicionais significa que há dois valores associados com o
mesmo parâmetro no construtor da superclasse, e portanto não é permitido.

## Example

O código a seguir produz este diagnóstico porque o construtor
`B.new` está usando um parâmetro super para passar um dos parâmetros posicionais
obrigatórios para o construtor super em `A`, mas está explicitamente passando o
outro na invocação do construtor super:

```dart
class A {
  A(int x, int y);
}

class B extends A {
  B(int x, super.[!y!]) : super(x);
}
```

## Common fixes

Se todos os parâmetros posicionais podem ser parâmetros super, então converta os
parâmetros posicionais normais para serem parâmetros super:

```dart
class A {
  A(int x, int y);
}

class B extends A {
  B(super.x, super.y);
}
```

Se alguns parâmetros posicionais não podem ser parâmetros super, então converta os
parâmetros super para serem parâmetros normais:

```dart
class A {
  A(int x, int y);
}

class B extends A {
  B(int x, int y) : super(x, y);
}
```
