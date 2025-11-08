---
ia-translate: true
title: implements_super_class
description: >-
  Detalhes sobre o diagnóstico implements_super_class
  produzido pelo analisador do Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_'{0}' não pode ser usado nas cláusulas 'extends' e 'implements' ao mesmo tempo._

_'{0}' não pode ser usado nas cláusulas 'extends' e 'with' ao mesmo tempo._

## Description

O analisador produz este diagnóstico quando uma classe é listada na
cláusula `extends` de uma declaração de classe e também na cláusula
`implements` ou `with` da mesma declaração.

## Example

O código a seguir produz este diagnóstico porque a classe `A` é usada tanto
na cláusula `extends` quanto na cláusula `implements` para a classe `B`:

```dart
class A {}

class B extends A implements [!A!] {}
```

O código a seguir produz este diagnóstico porque a classe `A` é usada tanto
na cláusula `extends` quanto na cláusula `with` para a classe `B`:

```dart
mixin class A {}

class B extends A with [!A!] {}
```

## Common fixes

Se você deseja herdar a implementação da classe, remova a classe da
cláusula `implements`:

```dart
class A {}

class B extends A {}
```

Se você não deseja herdar a implementação da classe, remova a cláusula
`extends`:

```dart
class A {}

class B implements A {}
```
