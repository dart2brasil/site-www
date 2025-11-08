---
ia-translate: true
title: unnecessary_getters_setters
description: >-
  Detalhes sobre o diagnóstico unnecessary_getters_setters
  produzido pelo analisador Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
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

_Uso desnecessário de getter e setter para envolver um campo._

## Description

O analisador produz este diagnóstico quando um par de getter e setter
retorna e define o valor de um campo sem qualquer processamento adicional.

## Example

O código a seguir produz este diagnóstico porque o par getter/setter
chamado `c` apenas expõe o campo chamado `_c`:

```dart
class C {
  int? _c;

  int? get [!c!] => _c;

  set c(int? v) => _c = v;
}
```

## Common fixes

Torne o campo público e remova o getter e setter:

```dart
class C {
  int? c;
}
```
