---
ia-translate: true
title: extension_type_representation_type_bottom
description: "Detalhes sobre o diagnóstico extension_type_representation_type_bottom produzido pelo analisador Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_O tipo de representação não pode ser um tipo bottom._

## Descrição

O analisador produz este diagnóstico quando o tipo de representação de um
extension type é o [tipo bottom][bottom type] `Never`. O tipo `Never` não pode ser
o tipo de representação de um extension type porque não há valores
que possam ser estendidos.

## Exemplo

O código a seguir produz este diagnóstico porque o tipo de representação
do extension type `E` é `Never`:

```dart
extension type E([!Never!] n) {}
```

## Correções comuns

Substitua o extension type por um tipo diferente:

```dart
extension type E(String s) {}
```

[bottom type]: /null-safety/understanding-null-safety#top-and-bottom
