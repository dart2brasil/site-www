---
ia-translate: true
title: import_deferred_library_with_load_function
description: "Detalhes sobre o diagnóstico import_deferred_library_with_load_function produzido pelo analisador do Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_A biblioteca importada define uma função de nível superior chamada 'loadLibrary' que é ocultada ao adiar esta biblioteca._

## Description

O analisador produz este diagnóstico quando uma biblioteca que declara uma
função chamada `loadLibrary` é importada usando um import deferred. Um
import deferred introduz uma função implícita chamada `loadLibrary`. Esta
função é usada para carregar o conteúdo da biblioteca deferred, e a função
implícita oculta a declaração explícita na biblioteca deferred.

Para mais informações, confira
[Lazily loading a library](https://dart.dev/language/libraries#lazily-loading-a-library).

## Example

Dado um arquivo `a.dart` que define uma função chamada `loadLibrary`:

```dart
void loadLibrary(Library library) {}

class Library {}
```

O código a seguir produz este diagnóstico porque a declaração implícita de
`a.loadLibrary` está ocultando a declaração explícita de `loadLibrary` em
`a.dart`:

```dart
[!import 'a.dart' deferred as a;!]

void f() {
  a.Library();
}
```

## Common fixes

Se a biblioteca importada não precisa ser deferred, remova a keyword
`deferred`:

```dart
import 'a.dart' as a;

void f() {
  a.Library();
}
```

Se a biblioteca importada precisa ser deferred e você precisa referenciar a
função importada, renomeie a função na biblioteca importada:

```dart
void populateLibrary(Library library) {}

class Library {}
```

Se a biblioteca importada precisa ser deferred e você não precisa
referenciar a função importada, adicione uma cláusula `hide`:

```dart
import 'a.dart' deferred as a hide loadLibrary;

void f() {
  a.Library();
}
```
