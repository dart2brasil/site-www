---
ia-translate: true
title: invalid_modifier_on_constructor
description: >-
  Detalhes sobre o diagnóstico invalid_modifier_on_constructor
  produzido pelo analisador do Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_O modificador '{0}' não pode ser aplicado ao corpo de um construtor._

## Description

O analisador produz este diagnóstico quando o corpo de um construtor é
prefixado por um dos seguintes modificadores: `async`, `async*` ou `sync*`.
Corpos de construtores devem ser síncronos.

## Example

O código a seguir produz este diagnóstico porque o corpo do construtor de
`C` está marcado como `async`:

```dart
class C {
  C() [!async!] {}
}
```

## Common fixes

Se o construtor pode ser síncrono, remova o modificador:

```dart
class C {
  C();
}
```

Se o construtor não pode ser síncrono, use um método estático para criar a
instância:

```dart
class C {
  C();
  static Future<C> c() async {
    return C();
  }
}
```
