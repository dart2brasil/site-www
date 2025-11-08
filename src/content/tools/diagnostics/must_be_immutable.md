---
ia-translate: true
title: must_be_immutable
description: "Detalhes sobre o diagnóstico must_be_immutable produzido pelo analisador Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_This class (or a class that this class inherits from) is marked as '@immutable', but one or more of its instance fields aren't final: {0}_

## Descrição

O analisador produz este diagnóstico quando uma classe imutável define um ou
mais campos de instância que não são final. Uma classe é imutável se for
marcada como imutável usando a anotação
[`immutable`][meta-immutable] ou se for uma subclasse de uma classe imutável.

## Exemplo

O código a seguir produz este diagnóstico porque o campo `x` não é
final:

```dart
import 'package:meta/meta.dart';

@immutable
class [!C!] {
  int x;

  C(this.x);
}
```

## Soluções comuns

Se as instâncias da classe devem ser imutáveis, então adicione a palavra-chave `final`
a todas as declarações de campo não-final:

```dart
import 'package:meta/meta.dart';

@immutable
class C {
  final int x;

  C(this.x);
}
```

Se as instâncias da classe devem ser mutáveis, então remova a
anotação ou escolha uma superclasse diferente se a anotação for
herdada:

```dart
class C {
  int x;

  C(this.x);
}
```

[meta-immutable]: https://pub.dev/documentation/meta/latest/meta/immutable-constant.html
