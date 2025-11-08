---
ia-translate: true
title: extension_type_implements_disallowed_type
description: "Detalhes sobre o diagnóstico extension_type_implements_disallowed_type produzido pelo analisador Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_Extension types não podem implementar '{0}'._

## Descrição

O analisador produz este diagnóstico quando um extension type implementa um
tipo que não é permitido implementar.

## Exemplo

O código a seguir produz este diagnóstico porque extension types não podem
implementar o tipo `dynamic`:

```dart
extension type A(int i) implements [!dynamic!] {}
```

## Correções comuns

Remova o tipo não permitido da cláusula implements:

```dart
extension type A(int i) {}
```
