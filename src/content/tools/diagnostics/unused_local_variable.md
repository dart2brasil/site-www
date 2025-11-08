---
title: unused_local_variable
description: >-
  Details about the unused_local_variable
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_The value of the local variable '{0}' isn't used._

## Descrição

O analisador produz este diagnóstico quando a local variable is declared but
never read, even if it's written in one or more places.

## Exemplo

O código a seguir produz este diagnóstico porque the value of `count` is
never read:

```dart
void main() {
  int [!count!] = 0;
}
```

## Correções comuns

If the variable isn't needed, then remove it.

If the variable was intended to be used, then add the missing code.
