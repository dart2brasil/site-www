---
ia-translate: true
title: deprecated_export_use
description: "Detalhes sobre o diagnóstico deprecated_export_use produzido pelo analisador Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_A capacidade de importar '{0}' indiretamente está deprecated._

## Description

O analisador produz este diagnóstico quando uma biblioteca importa um nome de
uma segunda biblioteca, e a segunda biblioteca exporta o nome de uma terceira
biblioteca mas indicou que não exportará a terceira biblioteca no futuro.

## Example

Dada uma biblioteca `a.dart` definindo a classe `A`:

```dart
class A {}
```

E uma segunda biblioteca `b.dart` que exporta `a.dart` mas marcou a
exportação como deprecated:

```dart
import 'a.dart';

@deprecated
export 'a.dart';
```

O código a seguir produz este diagnóstico porque a classe `A` não será
exportada de `b.dart` em alguma versão futura:

```dart
import 'b.dart';

[!A!]? a;
```

## Common fixes

Se o nome está disponível em uma biblioteca diferente que você pode importar,
então substitua a importação existente por uma importação para essa biblioteca (ou adicione
uma importação para a biblioteca que define o nome se você ainda precisar da importação antiga):

```dart
import 'a.dart';

A? a;
```

Se o nome não está disponível, então procure por instruções do autor da biblioteca
ou entre em contato diretamente para descobrir como atualizar seu código.
