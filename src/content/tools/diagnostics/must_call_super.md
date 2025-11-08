---
ia-translate: true
title: must_call_super
description: >-
  Detalhes sobre o diagnóstico must_call_super
  produzido pelo analisador Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_This method overrides a method annotated as '@mustCallSuper' in '{0}', but doesn't invoke the overridden method._

## Descrição

O analisador produz este diagnóstico quando um método que sobrescreve um método
que é anotado como [`mustCallSuper`][meta-mustCallSuper] não invoca
o método sobrescrito conforme necessário.

## Exemplo

O código a seguir produz este diagnóstico porque o método `m` em `B`
não invoca o método sobrescrito `m` em `A`:

```dart
import 'package:meta/meta.dart';

class A {
  @mustCallSuper
  m() {}
}

class B extends A {
  @override
  [!m!]() {}
}
```

## Soluções comuns

Adicione uma invocação do método sobrescrito no método que sobrescreve:

```dart
import 'package:meta/meta.dart';

class A {
  @mustCallSuper
  m() {}
}

class B extends A {
  @override
  m() {
    super.m();
  }
}
```

[meta-mustCallSuper]: https://pub.dev/documentation/meta/latest/meta/mustCallSuper-constant.html
