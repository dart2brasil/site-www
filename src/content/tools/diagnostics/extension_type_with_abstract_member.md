---
ia-translate: true
title: extension_type_with_abstract_member
description: >-
  Detalhes sobre o diagnóstico extension_type_with_abstract_member
  produzido pelo analisador Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_'{0}' deve ter um corpo de método porque '{1}' é um extension type._

## Descrição

O analisador produz este diagnóstico quando um extension type declara um
membro abstrato. Como referências a membros de extension type são resolvidas
estaticamente, um membro abstrato em um extension type nunca poderia ser
executado.

## Exemplo

O código a seguir produz este diagnóstico porque o método `m` no
extension type `E` é abstrato:

```dart
extension type E(String s) {
  [!void m();!]
}
```

## Correções comuns

Se o membro deve ser executável, então forneça uma implementação
do membro:

```dart
extension type E(String s) {
  void m() {}
}
```

Se o membro não deve ser executável, então remova-o:

```dart
extension type E(String s) {}
```
