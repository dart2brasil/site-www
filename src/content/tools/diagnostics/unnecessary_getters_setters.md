---
title: unnecessary_getters_setters
description: >-
  Details about the unnecessary_getters_setters
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/unnecessary_getters_setters"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_Unnecessary use of getter and setter to wrap a field._

## Descrição

O analisador produz este diagnóstico quando a getter and setter pair
returns and sets the value of a field without any additional processing.

## Exemplo

O código a seguir produz este diagnóstico porque the getter/setter pair
named `c` only expose the field named `_c`:

```dart
class C {
  int? _c;

  int? get [!c!] => _c;

  set c(int? v) => _c = v;
}
```

## Correções comuns

Make the field public and remove the getter and setter:

```dart
class C {
  int? c;
}
```
