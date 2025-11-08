---
ia-translate: true
title: extension_type_constructor_with_super_invocation
description: "Detalhes sobre o diagnóstico extension_type_constructor_with_super_invocation produzido pelo analisador Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_Construtores de extension type não podem incluir inicializadores super._

## Descrição

O analisador produz este diagnóstico quando um construtor em um extension
type inclui uma invocação de um construtor super na lista de inicializadores.
Como extension types não têm uma superclasse, não há
construtor para invocar.

## Exemplo

O código a seguir produz este diagnóstico porque o construtor `E.n`
invoca um construtor super em sua lista de inicializadores:

```dart
extension type E(int i) {
  E.n() : i = 0, [!super!].n();
}
```

## Correções comuns

Remova a invocação do construtor super:

```dart
extension type E(int i) {
  E.n() : i = 0;
}
```
