---
ia-translate: true
title: implements_super_class
description: >-
  Detalhes sobre o diagnóstico implements_super_class
  produzido pelo analisador Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_'{0}' não pode ser usada tanto na cláusula 'extends' quanto na 'implements'._

_'{0}' não pode ser usada tanto na cláusula 'extends' quanto na 'with'._

## Description

O analisador produz este diagnóstico quando uma classe é listada na
cláusula `extends` de uma declaração de classe e também na
cláusula `implements` ou `with` da mesma declaração.

## Example

O código a seguir produz este diagnóstico porque a classe `A` é usada
tanto na cláusula `extends` quanto na `implements` para a classe `B`:

```dart
class A {}

class B extends A implements [!A!] {}
```

O código a seguir produz este diagnóstico porque a classe `A` é usada
tanto na cláusula `extends` quanto na `with` para a classe `B`:

```dart
mixin class A {}

class B extends A with [!A!] {}
```

## Common fixes

Se você quer herdar a implementação da classe, então remova a
classe da cláusula `implements`:

```dart
class A {}

class B extends A {}
```

Se você não quer herdar a implementação da classe, então remova
a cláusula `extends`:

```dart
class A {}

class B implements A {}
```
