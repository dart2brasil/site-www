---
ia-translate: true
title: field_initializer_not_assignable
description: >-
  Detalhes sobre o diagnóstico field_initializer_not_assignable
  produzido pelo analisador Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_O tipo de inicializador '{0}' não pode ser atribuído ao tipo de campo '{1}' em um construtor const._

_O tipo de inicializador '{0}' não pode ser atribuído ao tipo de campo '{1}'._

## Descrição

O analisador produz este diagnóstico quando a lista de inicializadores de um
construtor inicializa um campo com um valor que não é atribuível ao
campo.

## Exemplo

O código a seguir produz este diagnóstico porque `0` tem o tipo `int`,
e um `int` não pode ser atribuído a um campo de tipo `String`:

```dart
class C {
  String s;

  C() : s = [!0!];
}
```

## Correções comuns

Se o tipo do campo estiver correto, altere o valor atribuído a ele
para que o valor tenha um tipo válido:

```dart
class C {
  String s;

  C() : s = '0';
}
```

Se o tipo do valor estiver correto, altere o tipo do campo para
permitir a atribuição:

```dart
class C {
  int s;

  C() : s = 0;
}
```
