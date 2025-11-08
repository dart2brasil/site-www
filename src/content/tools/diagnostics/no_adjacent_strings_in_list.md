---
ia-translate: true
title: no_adjacent_strings_in_list
description: >-
  Detalhes sobre o diagnóstico no_adjacent_strings_in_list
  produzido pelo analisador do Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/no_adjacent_strings_in_list"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_Don't use adjacent strings in a list literal._

## Description

O analisador produz este diagnóstico quando duas strings literais estão
adjacentes em um literal de lista. Strings adjacentes em Dart são concatenadas
para formar uma única string, mas a intenção pode ser que cada string
seja um elemento separado na lista.

## Example

O código a seguir produz este diagnóstico porque as strings `'a'` e
`'b'` estão adjacentes:

```dart
List<String> list = [[!'a' 'b'!], 'c'];
```

## Common fixes

Se as duas strings são destinadas a ser elementos separados da lista, então
adicione uma vírgula entre elas:

```dart
List<String> list = ['a', 'b', 'c'];
```

Se as duas strings são destinadas a ser uma única string concatenada, então
mescle manualmente as strings:

```dart
List<String> list = ['ab', 'c'];
```

Ou use o operador `+` para concatenar as strings:

```dart
List<String> list = ['a' + 'b', 'c'];
```
