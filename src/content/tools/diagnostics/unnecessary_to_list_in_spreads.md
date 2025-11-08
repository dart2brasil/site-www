---
ia-translate: true
title: unnecessary_to_list_in_spreads
description: >-
  Detalhes sobre o diagnóstico unnecessary_to_list_in_spreads
  produzido pelo analisador Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/unnecessary_to_list_in_spreads"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_Uso desnecessário de 'toList' em um spread._

## Description

O analisador produz este diagnóstico quando `toList` é usado para converter um
`Iterable` em uma `List` logo antes de um operador spread ser aplicado à
lista. O operador spread pode ser aplicado a qualquer `Iterable`, então a
conversão não é necessária.

## Example

O código a seguir produz este diagnóstico porque `toList` é invocado no
resultado de `map`, que é um `Iterable` ao qual o operador spread poderia
ser aplicado diretamente:

```dart
List<String> toLowercase(List<String> strings) {
  return [
    ...strings.map((String s) => s.toLowerCase()).[!toList!](),
  ];
}
```

## Common fixes

Remova a invocação de `toList`:

```dart
List<String> toLowercase(List<String> strings) {
  return [
    ...strings.map((String s) => s.toLowerCase()),
  ];
}
```
