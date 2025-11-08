---
ia-translate: true
title: async_for_in_wrong_context
description: >-
  Detalhes sobre o diagnóstico async_for_in_wrong_context
  produzido pelo analisador do Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_O loop async for-in só pode ser usado em uma função async._

## Description

O analisador produz este diagnóstico quando um loop async for-in é encontrado em
uma função ou método cujo corpo não está marcado como `async` ou
`async*`.

## Example

O código a seguir produz este diagnóstico porque o corpo de `f` não está
marcado como `async` ou `async*`, mas `f` contém um loop async
for-in:

```dart
void f(list) {
  [!await!] for (var e in list) {
    print(e);
  }
}
```

## Common fixes

Se a função deve retornar um `Future`, então marque o corpo com `async`:

```dart
Future<void> f(list) async {
  await for (var e in list) {
    print(e);
  }
}
```

Se a função deve retornar um `Stream` de valores, então marque o corpo com
`async*`:

```dart
Stream<void> f(list) async* {
  await for (var e in list) {
    print(e);
  }
}
```

Se a função deve ser síncrona, então remova o `await` antes do
loop:

```dart
void f(list) {
  for (var e in list) {
    print(e);
  }
}
```
