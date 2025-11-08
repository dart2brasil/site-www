---
ia-translate: true
title: extension_type_implements_itself
description: >-
  Detalhes sobre o diagnóstico extension_type_implements_itself
  produzido pelo analisador Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_O extension type não pode implementar a si mesmo._

## Descrição

O analisador produz este diagnóstico quando um extension type implementa
a si mesmo, seja diretamente ou indiretamente.

## Exemplo

O código a seguir produz este diagnóstico porque o extension type `A`
implementa a si mesmo diretamente:

```dart
extension type [!A!](int i) implements A {}
```

O código a seguir produz este diagnóstico porque o extension type `A`
implementa a si mesmo indiretamente (através de `B`):

```dart
extension type [!A!](int i) implements B {}

extension type [!B!](int i) implements A {}
```

## Correções comuns

Quebre o ciclo removendo um tipo da cláusula implements de pelo menos
um dos tipos envolvidos no ciclo:

```dart
extension type A(int i) implements B {}

extension type B(int i) {}
```
