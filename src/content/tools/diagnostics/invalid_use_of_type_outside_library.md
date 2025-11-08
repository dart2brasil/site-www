---
ia-translate: true
title: invalid_use_of_type_outside_library
description: "Detalhes sobre o diagnóstico invalid_use_of_type_outside_library produzido pelo analisador do Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_A classe '{0}' não pode ser estendida fora de sua biblioteca porque é uma classe final._

_A classe '{0}' não pode ser estendida fora de sua biblioteca porque é uma classe interface._

_A classe '{0}' não pode ser estendida, implementada ou misturada fora de sua biblioteca porque é uma classe sealed._

_A classe '{0}' não pode ser implementada fora de sua biblioteca porque é uma classe base._

_A classe '{0}' não pode ser implementada fora de sua biblioteca porque é uma classe final._

_A classe '{0}' não pode ser usada como uma restrição de superclasse de mixin fora de sua biblioteca porque é uma classe final._

_O mixin '{0}' não pode ser implementado fora de sua biblioteca porque é um mixin base._

## Description

O analisador produz este diagnóstico quando uma cláusula `extends`, `implements`,
`with` ou `on` usa uma classe ou mixin de uma forma que não é permitida
considerando os modificadores na declaração dessa classe ou mixin.

A mensagem especifica como a declaração está sendo usada e por que não é
permitida.

## Example

Dado um arquivo `a.dart` que define uma classe base `A`:

```dart
base class A {}
```

O código a seguir produz este diagnóstico porque a classe `B`
implementa a classe `A`, mas o modificador `base` impede que `A` seja
implementada fora da biblioteca onde foi definida:

```dart
import 'a.dart';

final class B implements [!A!] {}
```

## Common fixes

O uso deste tipo é restrito fora de sua biblioteca declarante. Se um
tipo diferente e irrestrito está disponível e pode fornecer funcionalidade
similar, então substitua o tipo:

```dart
class B implements C {}
class C {}
```

Se não há um tipo diferente que seria apropriado, então remova o
tipo, e possivelmente a cláusula inteira:

```dart
class B {}
```
