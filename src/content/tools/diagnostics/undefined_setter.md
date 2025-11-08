---
ia-translate: true
title: undefined_setter
description: "Detalhes sobre o diagnóstico undefined_setter produzido pelo analisador Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_O setter '{0}' não está definido para o tipo de função '{1}'._

_O setter '{0}' não está definido para o tipo '{1}'._

## Descrição

O analisador produz este diagnóstico quando encontra um identificador que
parece ser o nome de um setter, mas não está definido ou não está
visível no escopo em que o identificador está sendo referenciado.

## Exemplo

O código a seguir produz este diagnóstico porque não há setter
chamado `z`:

```dart
class C {
  int x = 0;
  void m(int y) {
    this.[!z!] = y;
  }
}
```

## Correções comuns

Se o identificador não está definido, então defina-o ou substitua-o pelo
nome de um setter que está definido. O exemplo acima pode ser corrigido
corrigindo a ortografia do setter:

```dart
class C {
  int x = 0;
  void m(int y) {
    this.x = y;
  }
}
```
