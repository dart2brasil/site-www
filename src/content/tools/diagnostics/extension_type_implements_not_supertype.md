---
ia-translate: true
title: extension_type_implements_not_supertype
description: >-
  Detalhes sobre o diagnóstico extension_type_implements_not_supertype
  produzido pelo analisador Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_'{0}' não é um supertipo de '{1}', o tipo de representação._

## Descrição

O analisador produz este diagnóstico quando um extension type implementa um
tipo que não é um supertipo do tipo de representação.

## Exemplo

O código a seguir produz este diagnóstico porque o extension type `A`
implementa `String`, mas `String` não é um supertipo do tipo de representação
`int`:

```dart
extension type A(int i) implements [!String!] {}
```

## Correções comuns

Se o tipo de representação está correto, então remova ou substitua o tipo na
cláusula implements:

```dart
extension type A(int i) {}
```

Se o tipo de representação não está correto, então substitua-o pelo tipo
correto:

```dart
extension type A(String s) implements String {}
```
