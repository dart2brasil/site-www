---
ia-translate: true
title: const_instance_field
description: "Detalhes sobre o diagnóstico const_instance_field produzido pelo analisador do Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_Only static fields can be declared as const._

## Descrição

O analisador produz este diagnóstico quando um field de instância é marcado
como const.

## Exemplo

O código a seguir produz este diagnóstico porque `f` é um field de
instância:

```dart
class C {
  [!const!] int f = 3;
}
```

## Correções comuns

Se o field precisa ser um field de instância, então remova a keyword
`const`, ou substitua por `final`:

```dart
class C {
  final int f = 3;
}
```

Se o field realmente deve ser um field const, então torne-o um field
static:

```dart
class C {
  static const int f = 3;
}
```
