---
ia-translate: true
title: deferred_import_of_extension
description: "Detalhes sobre o diagnóstico deferred_import_of_extension produzido pelo analisador do Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_Imports de bibliotecas deferred devem ocultar todas as extensions._

## Description

O analisador produz este diagnóstico quando uma biblioteca que é importada usando
um deferred import declara uma extension que está visível na biblioteca
importadora. Extension methods são resolvidos em tempo de compilação, e extensions
de bibliotecas deferred não estão disponíveis em tempo de compilação.

Para mais informações, consulte
[Carregando uma biblioteca de forma lazy](https://dart.dev/language/libraries#lazily-loading-a-library).

## Example

Dado um arquivo `a.dart` que define uma extension nomeada:

```dart
class C {}

extension E on String {
  int get size => length;
}
```

O código a seguir produz este diagnóstico porque a extension nomeada está
visível para a biblioteca:

```dart
import [!'a.dart'!] deferred as a;

void f() {
  a.C();
}
```

## Common fixes

Se a biblioteca deve ser importada como `deferred`, então adicione uma cláusula `show`
listando os nomes sendo referenciados ou adicione uma cláusula `hide` listando
todas as extensions nomeadas. Adicionar uma cláusula `show` ficaria assim:

```dart
import 'a.dart' deferred as a show C;

void f() {
  a.C();
}
```

Adicionar uma cláusula `hide` ficaria assim:

```dart
import 'a.dart' deferred as a hide E;

void f() {
  a.C();
}
```

Com a primeira correção, o benefício é que se novas extensions forem adicionadas à
biblioteca importada, então as extensions não causarão um diagnóstico a ser
gerado.

Se a biblioteca não precisa ser importada como `deferred`, ou se você precisa
fazer uso do extension method declarado nela, então remova a keyword
`deferred`:

```dart
import 'a.dart' as a;

void f() {
  a.C();
}
```
