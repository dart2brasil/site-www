---
ia-translate: true
title: subtype_of_deferred_class
description: "Detalhes sobre o diagnóstico subtype_of_deferred_class produzido pelo analisador Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_Classes e mixins não podem implementar classes deferred._

_Classes não podem estender classes deferred._

_Classes não podem misturar classes deferred._

## Description

O analisador produz este diagnóstico quando um tipo (classe ou mixin) é um
subtipo de uma classe de uma biblioteca sendo importada usando um import deferred.
Os supertipos de um tipo devem ser compilados ao mesmo tempo que o tipo, e
classes de bibliotecas deferred não são compiladas até que a biblioteca seja
carregada.

Para mais informações, consulte
[Lazily loading a library](https://dart.dev/language/libraries#lazily-loading-a-library).

## Example

Dado um arquivo `a.dart` que define a classe `A`:

```dart
class A {}
```

O código a seguir produz este diagnóstico porque a superclasse de `B`
é declarada em uma biblioteca deferred:

```dart
import 'a.dart' deferred as a;

class B extends [!a.A!] {}
```

## Common fixes

Se você precisa criar um subtipo de um tipo da biblioteca deferred, então
remova a keyword `deferred`:

```dart
import 'a.dart' as a;

class B extends a.A {}
```
