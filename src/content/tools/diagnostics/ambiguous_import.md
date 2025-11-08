---
ia-translate: true
title: ambiguous_import
description: "Detalhes sobre o diagnóstico ambiguous_import produzido pelo analisador Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_O nome '{0}' está definido nas bibliotecas {1}._

## Descrição

O analisador produz este diagnóstico quando um nome é referenciado que está
declarado em duas ou mais bibliotecas importadas.

## Exemplo

Dada uma biblioteca (`a.dart`) que define uma classe (`C` neste exemplo):

```dart
class A {}
class C {}
```

E uma biblioteca (`b.dart`) que define uma classe diferente com o mesmo nome:

```dart
class B {}
class C {}
```

O código a seguir produz este diagnóstico:

```dart
import 'a.dart';
import 'b.dart';

void f([!C!] c1, [!C!] c2) {}
```

## Correções comuns

Se alguma das bibliotecas não é necessária, então remova as diretivas import
para elas:

```dart
import 'a.dart';

void f(C c1, C c2) {}
```

Se o nome ainda está definido por mais de uma biblioteca, então adicione uma cláusula `hide`
às diretivas import para todas exceto uma biblioteca:

```dart
import 'a.dart' hide C;
import 'b.dart';

void f(C c1, C c2) {}
```

Se você deve ser capaz de referenciar mais de um desses tipos, então adicione um
prefixo a cada uma das diretivas import, e qualifique as referências com
o prefixo apropriado:

```dart
import 'a.dart' as a;
import 'b.dart' as b;

void f(a.C c1, b.C c2) {}
```
