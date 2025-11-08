---
ia-translate: true
title: null_argument_to_non_null_type
description: >-
  Detalhes sobre o diagnóstico null_argument_to_non_null_type
  produzido pelo analisador do Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_'{0}' shouldn't be called with a 'null' argument for the non-nullable type argument '{1}'._

## Description

O analisador produz este diagnóstico quando `null` é passado para o
construtor `Future.value` ou para o método `Completer.complete` quando o argumento de tipo
usado para criar a instância era non-nullable. Embora o sistema de
tipos não possa expressar essa restrição, passar `null` resulta em uma
exceção em tempo de execução.

## Example

O código a seguir produz este diagnóstico porque `null` está sendo passado
para o construtor `Future.value` embora o argumento de tipo seja o
tipo non-nullable `String`:

```dart
Future<String> f() {
  return Future.value([!null!]);
}
```

## Common fixes

Passe um valor non-null:

```dart
Future<String> f() {
  return Future.value('');
}
```
