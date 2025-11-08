---
ia-translate: true
title: undefined_extension_setter
description: "Detalhes sobre o diagnóstico undefined_extension_setter produzido pelo analisador Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_O setter '{0}' não está definido para a extension '{1}'._

## Descrição

O analisador produz este diagnóstico quando uma sobrescrita de extension é usada para
invocar um setter, mas o setter não está definido pela extension especificada.
O analisador também produz este diagnóstico quando um setter estático é
referenciado mas não está definido pela extension especificada.

## Exemplos

O código a seguir produz este diagnóstico porque a extension `E`
não declara um setter de instância chamado `b`:

```dart
extension E on String {
  set a(String v) {}
}

extension F on String {
  set b(String v) {}
}

void f() {
  E('c').[!b!] = 'd';
}
```

O código a seguir produz este diagnóstico porque a extension `E`
não declara um setter estático chamado `a`:

```dart
extension E on String {}

void f() {
  E.[!a!] = 3;
}
```

## Correções comuns

Se o nome do setter está incorreto, então mude-o para o nome de um
setter existente:

```dart
extension E on String {
  set a(String v) {}
}

extension F on String {
  set b(String v) {}
}

void f() {
  E('c').a = 'd';
}
```

Se o nome do setter está correto, mas o nome da extension está
errado, então mude o nome da extension para o nome correto:

```dart
extension E on String {
  set a(String v) {}
}

extension F on String {
  set b(String v) {}
}

void f() {
  F('c').b = 'd';
}
```

Se o nome do setter e da extension estão ambos corretos, mas o setter
não está definido, então defina o setter:

```dart
extension E on String {
  set a(String v) {}
  set b(String v) {}
}

extension F on String {
  set b(String v) {}
}

void f() {
  E('c').b = 'd';
}
```
