---
ia-translate: true
title: equal_keys_in_map_pattern
description: >-
  Detalhes sobre o diagnóstico equal_keys_in_map_pattern
  produzido pelo analisador Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_Duas chaves em um map pattern não podem ser equal._

## Description

O analisador produz este diagnóstico quando um map pattern contém mais
de uma chave com o mesmo nome. A mesma chave não pode ser correspondida duas vezes.

## Example

O código a seguir produz este diagnóstico porque a chave `'a'` aparece
duas vezes:

```dart
void f(Map<String, int> x) {
  if (x case {'a': 1, [!'a'!]: 2}) {}
}
```

## Common fixes

Se você está tentando corresponder duas chaves diferentes, então altere uma das chaves
no pattern:

```dart
void f(Map<String, int> x) {
  if (x case {'a': 1, 'b': 2}) {}
}
```

Se você está tentando corresponder a mesma chave, mas permitir que qualquer um de múltiplos
patterns corresponda, use um logical-or pattern:

```dart
void f(Map<String, int> x) {
  if (x case {'a': 1 || 2}) {}
}
```
