---
ia-translate: true
title: extension_declares_constructor
description: >-
  Detalhes sobre o diagnóstico extension_declares_constructor
  produzido pelo analisador Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_Extensions não podem declarar construtores._

## Descrição

O analisador produz este diagnóstico quando uma declaração de construtor é
encontrada em uma extension. Não é válido definir um construtor porque
extensions não são classes, e não é possível criar uma instância de
uma extension.

## Exemplo

O código a seguir produz este diagnóstico porque há uma declaração de construtor
em `E`:

```dart
extension E on String {
  [!E!]() : super();
}
```

## Correções comuns

Remova o construtor ou substitua-o por um método static.
