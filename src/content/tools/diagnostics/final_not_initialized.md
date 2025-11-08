---
title: final_not_initialized
description: >-
  Details about the final_not_initialized
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_The final variable '{0}' must be initialized._

## Descrição

O analisador produz este diagnóstico quando a final field or variable isn't
initialized.

## Exemplo

O código a seguir produz este diagnóstico porque `x` não tem uma
initializer:

```dart
final [!x!];
```

## Correções comuns

For variables and static fields, you can add an initializer:

```dart
final x = 0;
```

For instance fields, you can add an initializer as shown in the previous
example, or you can initialize the field in every constructor. You can
initialize the field by using an initializing formal parameter:

```dart
class C {
  final int x;
  C(this.x);
}
```

You can also initialize the field by using an initializer in the
constructor:

```dart
class C {
  final int x;
  C(int y) : x = y * 2;
}
```
