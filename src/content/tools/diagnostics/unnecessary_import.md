---
ia-translate: true
title: unnecessary_import
description: "Detalhes sobre o diagnóstico unnecessary_import produzido pelo analisador Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_O import de '{0}' é desnecessário porque todos os elementos usados também são fornecidos pelo import de '{1}'._

## Description

O analisador produz este diagnóstico quando um import não é necessário porque
todos os nomes que são importados e referenciados dentro da biblioteca importadora
também estão visíveis através de outro import.

## Example

Dado um arquivo `a.dart` que contém o seguinte:

```dart
class A {}
```

E, dado um arquivo `b.dart` que contém o seguinte:

```dart
export 'a.dart';

class B {}
```

O código a seguir produz este diagnóstico porque a classe `A`, que é
importada de `a.dart`, também é importada de `b.dart`. Remover o import
de `a.dart` mantém a semântica inalterada:

```dart
import [!'a.dart'!];
import 'b.dart';

void f(A a, B b) {}
```

## Common fixes

Se o import não for necessário, então remova-o.

Se alguns dos nomes importados por este import são destinados a serem usados mas
ainda não são, e se esses nomes não são importados por outros imports, então adicione
as referências ausentes a esses nomes.
