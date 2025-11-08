---
title: avoid_type_to_string
description: >-
  Details about the avoid_type_to_string
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/avoid_type_to_string"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_Using 'toString' on a 'Type' is not safe in production code._

## Descrição

O analisador produz este diagnóstico quando the method `toString` is
invoked on a value whose static type is `Type`.

## Exemplo

O código a seguir produz este diagnóstico porque the method `toString`
is invoked on the `Type` returned by `runtimeType`:

```dart
bool isC(Object o) => o.runtimeType.[!toString!]() == 'C';

class C {}
```

## Correções comuns

If it's essential that the type is exactly the same, then use an explicit
comparison:

```dart
bool isC(Object o) => o.runtimeType == C;

class C {}
```

If it's alright for instances of subtypes of the type to return `true`,
then use a type check:

```dart
bool isC(Object o) => o is C;

class C {}
```
