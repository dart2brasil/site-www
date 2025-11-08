---
title: missing_variable_pattern
description: >-
  Detalhes sobre o diagnóstico missing_variable_pattern
  produzido pelo analisador Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_O padrão de variável '{0}' está missing neste ramo do padrão OR lógico._

## Description

O analisador produz este diagnóstico quando um ramo de um padrão
OR lógico não declara uma variável que é declarada no outro ramo do
mesmo padrão.

## Example

O código a seguir produz este diagnóstico porque o lado direito do
padrão OR lógico não declara a variável `a`:

```dart
void f((int, int) r) {
  if (r case (var a, 0) || [!(0, _)!]) {
    print(a);
  }
}
```

## Common fixes

Se a variável precisa ser referenciada nas instruções controladas, então
adicione uma declaração da variável a cada ramo do padrão OR
lógico:

```dart
void f((int, int) r) {
  if (r case (var a, 0) || (0, var a)) {
    print(a);
  }
}
```

Se a variável não precisa ser referenciada nas instruções
controladas, então remova a declaração da variável de cada ramo
do padrão OR lógico:

```dart
void f((int, int) r) {
  if (r case (_, 0) || (0, _)) {
    print('found a zero');
  }
}
```

Se a variável precisa ser referenciada se um ramo do padrão
corresponder mas não quando o outro corresponder, então divida o padrão em duas
partes:

```dart
void f((int, int) r) {
  switch (r) {
    case (var a, 0):
      print(a);
    case (0, _):
      print('found a zero');
  }
}
```
