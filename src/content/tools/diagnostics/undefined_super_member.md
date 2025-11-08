---
ia-translate: true
title: undefined_super_member
description: >-
  Detalhes sobre o diagnóstico undefined_super_member
  produzido pelo analisador Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_(Anteriormente conhecido como `undefined_super_method`)_

_O getter '{0}' não está definido em uma superclasse de '{1}'._

_O método '{0}' não está definido em uma superclasse de '{1}'._

_O operador '{0}' não está definido em uma superclasse de '{1}'._

_O setter '{0}' não está definido em uma superclasse de '{1}'._

## Descrição

O analisador produz este diagnóstico quando um membro herdado (método,
getter, setter ou operador) é referenciado usando `super`, mas não há
membro com esse nome na cadeia de superclasses.

## Exemplos

O código a seguir produz este diagnóstico porque `Object` não define
um método chamado `n`:

```dart
class C {
  void m() {
    super.[!n!]();
  }
}
```

O código a seguir produz este diagnóstico porque `Object` não define
um getter chamado `g`:

```dart
class C {
  void m() {
    super.[!g!];
  }
}
```

## Correções comuns

Se o membro herdado que você pretende invocar tem um nome diferente, então
faça o nome do membro invocado corresponder ao membro herdado.

Se o membro que você pretende invocar está definido na mesma classe, então
remova o `super.`.

Se o membro não está definido, então adicione o membro a uma das
superclasses ou remova a invocação.
