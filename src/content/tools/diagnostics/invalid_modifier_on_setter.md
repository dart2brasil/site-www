---
ia-translate: true
title: invalid_modifier_on_setter
description: >-
  Detalhes sobre o diagnóstico invalid_modifier_on_setter
  produzido pelo analisador do Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_Setters não podem usar 'async', 'async*' ou 'sync*'._

## Description

O analisador produz este diagnóstico quando o corpo de um setter é prefixado
por um dos seguintes modificadores: `async`, `async*` ou `sync*`. Corpos de
setters devem ser síncronos.

## Example

O código a seguir produz este diagnóstico porque o corpo do setter `x` está
marcado como `async`:

```dart
class C {
  set x(int i) [!async!] {}
}
```

## Common fixes

Se o setter pode ser síncrono, remova o modificador:

```dart
class C {
  set x(int i) {}
}
```

Se o setter não pode ser síncrono, use um método para definir o valor:

```dart
class C {
  void x(int i) async {}
}
```
