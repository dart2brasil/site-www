---
ia-translate: true
title: extension_type_implements_representation_not_supertype
description: "Detalhes sobre o diagnóstico extension_type_implements_representation_not_supertype produzido pelo analisador Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_'{0}', o tipo de representação de '{1}', não é um supertipo de '{2}', o tipo de representação de '{3}'._

## Descrição

O analisador produz este diagnóstico quando um extension type implementa
outro extension type, e o tipo de representação do extension type implementado
não é um subtipo do tipo de representação do extension type que implementa.

## Exemplo

O código a seguir produz este diagnóstico porque o extension type `B`
implementa `A`, mas o tipo de representação de `A` (`num`) não é um
subtipo do tipo de representação de `B` (`String`):

```dart
extension type A(num i) {}

extension type B(String s) implements [!A!] {}
```

## Correções comuns

Altere os tipos de representação dos dois extension types para que
o tipo de representação do tipo implementado seja um supertipo do
tipo de representação do tipo que implementa:

```dart
extension type A(num i) {}

extension type B(int n) implements A {}
```

Ou remova o tipo implementado da cláusula implements:

```dart
extension type A(num i) {}

extension type B(String s) {}
```
