---
ia-translate: true
title: extension_type_declares_instance_field
description: "Detalhes sobre o diagnóstico extension_type_declares_instance_field produzido pelo analisador Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_Extension types não podem declarar campos de instância._

## Descrição

O analisador produz este diagnóstico quando há uma declaração de campo no
corpo de uma declaração de extension type.

## Exemplo

O código a seguir produz este diagnóstico porque o extension type `E`
declara um campo chamado `f`:

```dart
extension type E(int i) {
  final int [!f!] = 0;
}
```

## Correções comuns

Se você não precisa do campo, então remova-o ou substitua-o por um getter
e/ou setter:

```dart
extension type E(int i) {
  int get f => 0;
}
```

Se você precisa do campo, então converta o extension type em uma classe:

```dart
class E {
  final int i;

  final int f = 0;

  E(this.i);
}
```
