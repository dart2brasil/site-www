---
ia-translate: true
title: non_final_field_in_enum
description: >-
  Detalhes sobre o diagnóstico non_final_field_in_enum
  produzido pelo analisador do Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_Enums só podem declarar campos final._

## Description

O analisador produz este diagnóstico quando um campo de instância em um enum
não está marcado como `final`.

## Example

O código a seguir produz este diagnóstico porque o campo `f` não é um
campo final:

```dart
enum E {
  c;

  int [!f!] = 0;
}
```

## Common fixes

Se o campo deve ser definido para o enum, então marque o campo como sendo
`final`:

```dart
enum E {
  c;

  final int f = 0;
}
```

Se o campo pode ser removido, então remova-o:

```dart
enum E {
  c
}
```
