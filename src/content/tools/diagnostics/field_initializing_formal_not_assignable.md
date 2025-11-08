---
ia-translate: true
title: field_initializing_formal_not_assignable
description: "Detalhes sobre o diagnóstico field_initializing_formal_not_assignable produzido pelo analisador Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_O tipo de parâmetro '{0}' é incompatível com o tipo de campo '{1}'._

## Descrição

O analisador produz este diagnóstico quando o tipo de um
parâmetro formal inicializador não é atribuível ao tipo do campo sendo
inicializado.

## Exemplo

O código a seguir produz este diagnóstico porque o parâmetro formal
inicializador tem o tipo `String`, mas o tipo do campo é
`int`. O parâmetro deve ter um tipo que seja um subtipo do tipo do campo.

```dart
class C {
  int f;

  C([!String this.f!]);
}
```

## Correções comuns

Se o tipo do campo estiver incorreto, altere o tipo do campo para
corresponder ao tipo do parâmetro e considere remover o tipo do
parâmetro:

```dart
class C {
  String f;

  C(this.f);
}
```

Se o tipo do parâmetro estiver incorreto, remova o tipo do
parâmetro:

```dart
class C {
  int f;

  C(this.f);
}
```

Se os tipos do campo e do parâmetro estiverem corretos, use um
inicializador em vez de um parâmetro formal inicializador para converter o
valor do parâmetro em um valor do tipo correto:

```dart
class C {
  int f;

  C(String s) : f = int.parse(s);
}
```
