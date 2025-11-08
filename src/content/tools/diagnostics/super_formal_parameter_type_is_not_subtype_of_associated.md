---
ia-translate: true
title: super_formal_parameter_type_is_not_subtype_of_associated
description: >-
  Detalhes sobre o diagnóstico super_formal_parameter_type_is_not_subtype_of_associated
  produzido pelo analisador Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_O type '{0}' deste parâmetro não é um subtipo do type '{1}' do parâmetro do construtor super associado._

## Descrição

O analisador produz este diagnóstico quando o tipo de um parâmetro super
não é um subtipo do parâmetro correspondente do construtor super.

## Exemplo

O código a seguir produz este diagnóstico porque o tipo do parâmetro
super `x` no construtor de `B` não é um subtipo do parâmetro
`x` no construtor de `A`:

```dart
class A {
  A(num x);
}

class B extends A {
  B(String super.[!x!]);
}
```

## Correções comuns

Se o tipo do parâmetro super puder ser o mesmo que o parâmetro do
construtor super, então remova a anotação de tipo do parâmetro
super (se o tipo for implícito, ele é inferido do tipo no
construtor super):

```dart
class A {
  A(num x);
}

class B extends A {
  B(super.x);
}
```

Se o tipo do parâmetro super puder ser um subtipo do tipo do
parâmetro correspondente, então altere o tipo do parâmetro super:

```dart
class A {
  A(num x);
}

class B extends A {
  B(int super.x);
}
```

Se o tipo do parâmetro super não puder ser alterado, então use um
parâmetro normal em vez de um parâmetro super:

```dart
class A {
  A(num x);
}

class B extends A {
  B(String x) : super(x.length);
}
```
