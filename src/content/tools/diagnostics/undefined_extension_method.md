---
ia-translate: true
title: undefined_extension_method
description: "Detalhes sobre o diagnóstico undefined_extension_method produzido pelo analisador Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_O método '{0}' não está definido para a extension '{1}'._

## Descrição

O analisador produz este diagnóstico quando uma sobrescrita de extension é usada para
invocar um método, mas o método não está definido pela extension especificada.
O analisador também produz este diagnóstico quando um método estático é
referenciado mas não está definido pela extension especificada.

## Exemplos

O código a seguir produz este diagnóstico porque a extension `E`
não declara um método de instância chamado `b`:

```dart
extension E on String {
  String a() => 'a';
}

extension F on String {
  String b() => 'b';
}

void f() {
  E('c').[!b!]();
}
```

O código a seguir produz este diagnóstico porque a extension `E`
não declara um método estático chamado `a`:

```dart
extension E on String {}

var x = E.[!a!]();
```

## Correções comuns

Se o nome do método está incorreto, então mude-o para o nome de um
método existente:

```dart
extension E on String {
  String a() => 'a';
}

extension F on String {
  String b() => 'b';
}

void f() {
  E('c').a();
}
```

Se o nome do método está correto, mas o nome da extension está
errado, então mude o nome da extension para o nome correto:

```dart
extension E on String {
  String a() => 'a';
}

extension F on String {
  String b() => 'b';
}

void f() {
  F('c').b();
}
```

Se o nome do método e da extension estão ambos corretos, mas o método
não está definido, então defina o método:

```dart
extension E on String {
  String a() => 'a';
  String b() => 'z';
}

extension F on String {
  String b() => 'b';
}

void f() {
  E('c').b();
}
```
