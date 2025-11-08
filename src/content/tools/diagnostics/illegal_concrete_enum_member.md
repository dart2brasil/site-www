---
ia-translate: true
title: illegal_concrete_enum_member
description: "Detalhes sobre o diagnóstico illegal_concrete_enum_member produzido pelo analisador do Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_Um membro de instância concreto chamado '{0}' não pode ser declarado em uma classe que implementa 'Enum'._

_Um membro de instância concreto chamado '{0}' não pode ser herdado de '{1}' em uma classe que implementa 'Enum'._

## Description

O analisador produz este diagnóstico quando uma declaração de enum, uma
classe que implementa `Enum`, ou um mixin com uma restrição de superclasse de
`Enum`, declara ou herda um membro de instância concreto chamado
`index`, `hashCode`, ou `==`.

## Examples

O código a seguir produz este diagnóstico porque o enum `E` declara
um getter de instância chamado `index`:

```dart
enum E {
  v;

  int get [!index!] => 0;
}
```

O código a seguir produz este diagnóstico porque a classe `C`, que
implementa `Enum`, declara um campo de instância chamado `hashCode`:

```dart
abstract class C implements Enum {
  int [!hashCode!] = 0;
}
```

O código a seguir produz este diagnóstico porque a classe `C`, que
implementa `Enum` indiretamente através da classe `A`, declara um
getter de instância chamado `hashCode`:

```dart
abstract class A implements Enum {}

abstract class C implements A {
  int get [!hashCode!] => 0;
}
```

O código a seguir produz este diagnóstico porque o mixin `M`, que
tem `Enum` na cláusula `on`, declara um operador explícito chamado `==`:

```dart
mixin M on Enum {
  bool operator [!==!](Object other) => false;
}
```

## Common fixes

Renomeie o membro conflitante:

```dart
enum E {
  v;

  int get getIndex => 0;
}
```
