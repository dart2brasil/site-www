---
ia-translate: true
title: undefined_extension_getter
description: "Detalhes sobre o diagnóstico undefined_extension_getter produzido pelo analisador Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_O getter '{0}' não está definido para a extension '{1}'._

## Descrição

O analisador produz este diagnóstico quando uma sobrescrita de extension é usada para
invocar um getter, mas o getter não está definido pela extension especificada.
O analisador também produz este diagnóstico quando um getter estático é
referenciado mas não está definido pela extension especificada.

## Exemplos

O código a seguir produz este diagnóstico porque a extension `E`
não declara um getter de instância chamado `b`:

```dart
extension E on String {
  String get a => 'a';
}

extension F on String {
  String get b => 'b';
}

void f() {
  E('c').[!b!];
}
```

O código a seguir produz este diagnóstico porque a extension `E`
não declara um getter estático chamado `a`:

```dart
extension E on String {}

var x = E.[!a!];
```

## Correções comuns

Se o nome do getter está incorreto, então mude-o para o nome de um
getter existente:

```dart
extension E on String {
  String get a => 'a';
}

extension F on String {
  String get b => 'b';
}

void f() {
  E('c').a;
}
```

Se o nome do getter está correto mas o nome da extension está
errado, então mude o nome da extension para o nome correto:

```dart
extension E on String {
  String get a => 'a';
}

extension F on String {
  String get b => 'b';
}

void f() {
  F('c').b;
}
```

Se o nome do getter e da extension estão ambos corretos, mas o getter
não está definido, então defina o getter:

```dart
extension E on String {
  String get a => 'a';
  String get b => 'z';
}

extension F on String {
  String get b => 'b';
}

void f() {
  E('c').b;
}
```
