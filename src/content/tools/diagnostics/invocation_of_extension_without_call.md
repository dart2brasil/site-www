---
ia-translate: true
title: invocation_of_extension_without_call
description: >-
  Detalhes sobre o diagnóstico invocation_of_extension_without_call
  produzido pelo analisador do Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_A extension '{0}' não define um método 'call' então a sobrescrita não pode ser usada em uma invocação._

## Descrição

O analisador produz este diagnóstico quando uma sobrescrita de extension é usada para
invocar uma função mas a extension não declara um método `call`.

## Exemplo

O código a seguir produz este diagnóstico porque a extension `E`
não define um método `call`:

```dart
extension E on String {}

void f() {
  [!E('')!]();
}
```

## Correções comuns

Se a extension deve definir um método `call`, então declare-o:

```dart
extension E on String {
  int call() => 0;
}

void f() {
  E('')();
}
```

Se o tipo estendido define um método `call`, então remova a
sobrescrita de extension.

Se o método `call` não estiver definido, então reescreva o código para que ele
não invoque o método `call`.
