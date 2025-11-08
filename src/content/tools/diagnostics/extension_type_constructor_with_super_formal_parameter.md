---
ia-translate: true
title: extension_type_constructor_with_super_formal_parameter
description: >-
  Detalhes sobre o diagnóstico extension_type_constructor_with_super_formal_parameter
  produzido pelo analisador Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_Construtores de extension type não podem declarar parâmetros formais super._

## Descrição

O analisador produz este diagnóstico quando um construtor em um extension
type tem um parâmetro super. Parâmetros super não são válidos porque
extension types não têm uma superclasse.

## Exemplo

O código a seguir produz este diagnóstico porque o construtor nomeado
`n` contém um parâmetro super:

```dart
extension type E(int i) {
  E.n(this.i, [!super!].foo);
}
```

## Correções comuns

Se você precisa do parâmetro, substitua o parâmetro super por um parâmetro
normal:

```dart
extension type E(int i) {
  E.n(this.i, String foo);
}
```

Se você não precisa do parâmetro, remova o parâmetro super:

```dart
extension type E(int i) {
  E.n(this.i);
}
```
