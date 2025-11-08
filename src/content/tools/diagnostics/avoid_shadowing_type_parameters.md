---
ia-translate: true
title: avoid_shadowing_type_parameters
description: "Detalhes sobre o diagnóstico avoid_shadowing_type_parameters produzido pelo analisador do Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/avoid_shadowing_type_parameters"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_O parâmetro de tipo '{0}' oculta um parâmetro de tipo da {1} envolvente._

## Description

O analisador produz este diagnóstico quando um parâmetro de tipo oculta um parâmetro
de tipo de uma declaração envolvente.

Ocultar um parâmetro de tipo com um parâmetro de tipo diferente pode levar a
bugs sutis que são difíceis de depurar.

## Example

O código a seguir produz este diagnóstico porque o parâmetro de tipo `T`
definido pelo método `m` oculta o parâmetro de tipo `T` definido pela
classe `C`:

```dart
class C<T> {
  void m<[!T!]>() {}
}
```

## Common fixes

Renomeie um dos parâmetros de tipo:

```dart
class C<T> {
  void m<S>() {}
}
```
