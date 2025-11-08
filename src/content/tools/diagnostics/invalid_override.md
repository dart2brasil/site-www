---
ia-translate: true
title: invalid_override
description: >-
  Detalhes sobre o diagnóstico invalid_override
  produzido pelo analisador do Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_'{0}.{1}' ('{2}') não é um override válido de '{3}.{1}' ('{4}')._

_O setter '{0}.{1}' ('{2}') não é um override válido de '{3}.{1}' ('{4}')._

## Description

O analisador produz este diagnóstico quando um membro de uma classe é
encontrado que sobrescreve um membro de um supertipo e o override não é
válido. Um override é válido se todas essas condições são verdadeiras:
- Permite todos os argumentos permitidos pelo membro sobrescrito.
- Não requer argumentos que não são requeridos pelo membro sobrescrito.
- O tipo de cada parâmetro do membro sobrescrito é atribuível ao parâmetro
  correspondente do override.
- O tipo de retorno do override é atribuível ao tipo de retorno do membro
  sobrescrito.

## Example

O código a seguir produz este diagnóstico porque o tipo do parâmetro `s`
(`String`) não é atribuível ao tipo do parâmetro `i` (`int`):

```dart
class A {
  void m(int i) {}
}

class B extends A {
  void [!m!](String s) {}
}
```

## Common fixes

Se o método inválido é destinado a sobrescrever o método da superclasse,
altere-o para estar em conformidade:

```dart
class A {
  void m(int i) {}
}

class B extends A {
  void m(int i) {}
}
```

Se não é destinado a sobrescrever o método da superclasse, renomeie-o:

```dart
class A {
  void m(int i) {}
}

class B extends A {
  void m2(String s) {}
}
```
