---
ia-translate: true
title: multiple_super_initializers
description: >-
  Detalhes sobre o diagnóstico multiple_super_initializers
  produzido pelo analisador do Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_Um construtor pode ter no máximo um inicializador 'super'._

## Description

O analisador produz este diagnóstico quando a lista de inicializadores de um
construtor contém mais de uma invocação de um construtor da
superclasse. A lista de inicializadores é obrigada a ter exatamente uma tal chamada,
que pode ser explícita ou implícita.

## Example

O código a seguir produz este diagnóstico porque a lista de inicializadores
do construtor de `B` invoca tanto o construtor `one` quanto o
construtor `two` da superclasse `A`:

```dart
class A {
  int? x;
  String? s;
  A.one(this.x);
  A.two(this.s);
}

class B extends A {
  B() : super.one(0), [!super.two('')!];
}
```

## Common fixes

Se um dos construtores super inicializará a instância completamente, então
remova o outro:

```dart
class A {
  int? x;
  String? s;
  A.one(this.x);
  A.two(this.s);
}

class B extends A {
  B() : super.one(0);
}
```

Se a inicialização alcançada por um dos construtores super pode ser
realizada no corpo do construtor, então remova sua invocação super
e realize a inicialização no corpo:

```dart
class A {
  int? x;
  String? s;
  A.one(this.x);
  A.two(this.s);
}

class B extends A {
  B() : super.one(0) {
    s = '';
  }
}
```

Se a inicialização só pode ser realizada em um construtor na
superclasse, então adicione um novo construtor ou modifique um dos construtores existentes
para que haja um construtor que permita toda a
inicialização necessária ocorrer em uma única chamada:

```dart
class A {
  int? x;
  String? s;
  A.one(this.x);
  A.two(this.s);
  A.three(this.x, this.s);
}

class B extends A {
  B() : super.three(0, '');
}
```
