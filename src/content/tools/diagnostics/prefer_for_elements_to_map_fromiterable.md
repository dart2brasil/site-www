---
ia-translate: true
title: prefer_for_elements_to_map_fromiterable
description: "Detalhes sobre o diagnóstico prefer_for_elements_to_map_fromiterable produzido pelo analisador Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/prefer_for_elements_to_map_fromIterable"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_Use elementos 'for' ao construir mapas a partir de iteráveis._

## Description

O analisador produz este diagnóstico quando `Map.fromIterable` é usado para
construir um mapa que poderia ser construído usando o elemento `for`.

## Example

O código a seguir produz este diagnóstico porque `fromIterable` está
sendo usado para construir um mapa que poderia ser construído usando um elemento `for`:

```dart
void f(Iterable<String> data) {
  [!Map<String, int>.fromIterable(!]
    [!data,!]
    [!key: (element) => element,!]
    [!value: (element) => element.length,!]
  [!)!];
}
```

## Common fixes

Use um elemento `for` para construir o mapa:

```dart
void f(Iterable<String> data) {
  <String, int>{
    for (var element in data)
      element: element.length
  };
}
```
