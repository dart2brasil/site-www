---
ia-translate: true
title: cast_from_nullable_always_fails
description: "Detalhes sobre o diagnóstico cast_from_nullable_always_fails produzido pelo analisador do Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_Este cast sempre lançará uma exceção porque a variável local nullable '{0}' não foi atribuída._

## Description

O analisador produz este diagnóstico quando uma variável local que tem um
type nullable não foi atribuída e é convertida (cast) para um type não-nullable.
Como a variável não foi atribuída, ela tem o valor padrão de
`null`, fazendo com que o cast lance uma exceção.

## Example

O código a seguir produz este diagnóstico porque a variável `x` é
convertida (cast) para um type não-nullable (`int`) quando se sabe que ela tem o valor
`null`:

```dart
void f() {
  num? x;
  [!x!] as int;
  print(x);
}
```

## Common fixes

Se a variável deve ter um valor antes do cast, então adicione um
inicializador ou uma atribuição:

```dart
void f() {
  num? x = 3;
  x as int;
  print(x);
}
```

Se a variável não deve ser atribuída, então remova o cast:

```dart
void f() {
  num? x;
  print(x);
}
```
