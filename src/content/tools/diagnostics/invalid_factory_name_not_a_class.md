---
ia-translate: true
title: invalid_factory_name_not_a_class
description: >-
  Detalhes sobre o diagnóstico invalid_factory_name_not_a_class
  produzido pelo analisador do Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_O nome de um construtor factory deve ser o mesmo que o nome da classe imediatamente envolvente._

## Description

O analisador produz este diagnóstico quando o nome de um construtor factory
não é o mesmo que o nome da classe envolvente.

## Example

O código a seguir produz este diagnóstico porque o nome do construtor
factory (`A`) não é o mesmo que a classe envolvente (`C`):

```dart
class A {}

class C {
  factory [!A!]() => throw 0;
}
```

## Common fixes

Se o factory retorna uma instância da classe envolvente, e você pretende que
seja um construtor factory sem nome, renomeie o factory:

```dart
class A {}

class C {
  factory C() => throw 0;
}
```

Se o factory retorna uma instância da classe envolvente, e você pretende que
seja um construtor factory nomeado, prefixe o nome do construtor factory com
o nome da classe envolvente:

```dart
class A {}

class C {
  factory C.a() => throw 0;
}
```

Se o factory retorna uma instância de uma classe diferente, mova o factory
para essa classe:

```dart
class A {
  factory A() => throw 0;
}

class C {}
```

Se o factory retorna uma instância de uma classe diferente, mas você não
pode modificar essa classe ou não quer mover o factory, converta-o em um
método estático:

```dart
class A {}

class C {
  static A a() => throw 0;
}
```
