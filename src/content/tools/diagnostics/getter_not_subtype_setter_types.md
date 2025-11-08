---
ia-translate: true
title: getter_not_subtype_setter_types
description: >-
  Detalhes sobre o diagnóstico getter_not_subtype_setter_types
  produzido pelo analisador do Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_O tipo de retorno do getter '{0}' é '{1}', que não é um subtipo do tipo '{2}' de seu setter '{3}'._

## Description

O analisador produz este diagnóstico quando o tipo de retorno de um getter
não é um subtipo do tipo do parâmetro de um setter com o mesmo nome.

A relação de subtipo é um requisito independentemente de o getter e o setter estarem
na mesma classe ou se um deles está em uma superclasse do outro.

## Example

O código a seguir produz este diagnóstico porque o tipo de retorno do
getter `x` é `num`, o tipo do parâmetro do setter `x` é `int`, e
`num` não é um subtipo de `int`:

```dart
class C {
  num get [!x!] => 0;

  set x(int y) {}
}
```

## Common fixes

Se o tipo do getter estiver correto, então altere o tipo do setter:

```dart
class C {
  num get x => 0;

  set x(num y) {}
}
```

Se o tipo do setter estiver correto, então altere o tipo do getter:

```dart
class C {
  int get x => 0;

  set x(int y) {}
}
```
