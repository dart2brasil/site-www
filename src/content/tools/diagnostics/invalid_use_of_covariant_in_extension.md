---
ia-translate: true
title: invalid_use_of_covariant_in_extension
description: >-
  Detalhes sobre o diagnóstico invalid_use_of_covariant_in_extension
  produzido pelo analisador do Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_Não é possível ter o modificador '{0}' em uma extension._

## Description

O analisador produz este diagnóstico quando um membro declarado dentro de uma
extension usa a keyword `covariant` na declaração de um parâmetro.
Extensions não são classes e não possuem subclasses, portanto a keyword não serve
para nenhum propósito.

## Example

O código a seguir produz este diagnóstico porque `i` está marcado como sendo
covariant:

```dart
extension E on String {
  void a([!covariant!] int i) {}
}
```

## Common fixes

Remova a keyword `covariant`:

```dart
extension E on String {
  void a(int i) {}
}
```
