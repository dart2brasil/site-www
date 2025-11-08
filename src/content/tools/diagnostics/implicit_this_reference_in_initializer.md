---
ia-translate: true
title: implicit_this_reference_in_initializer
description: >-
  Detalhes sobre o diagnóstico implicit_this_reference_in_initializer
  produzido pelo analisador do Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_O membro de instância '{0}' não pode ser acessado em um inicializador._

## Descrição

O analisador produz este diagnóstico quando encontra uma referência a um
membro de instância na lista de inicializadores de um construtor.

## Exemplo

O código a seguir produz este diagnóstico porque `defaultX` é um
membro de instância:

```dart
class C {
  int x;

  C() : x = [!defaultX!];

  int get defaultX => 0;
}
```

## Correções comuns

Se o membro puder ser tornado static, então faça isso:

```dart
class C {
  int x;

  C() : x = defaultX;

  static int get defaultX => 0;
}
```

Se não, então substitua a referência no inicializador por uma
expressão diferente que não use um membro de instância:

```dart
class C {
  int x;

  C() : x = 0;

  int get defaultX => 0;
}
```
