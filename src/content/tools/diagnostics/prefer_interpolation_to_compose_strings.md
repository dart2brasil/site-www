---
ia-translate: true
title: prefer_interpolation_to_compose_strings
description: "Detalhes sobre o diagnóstico prefer_interpolation_to_compose_strings produzido pelo analisador Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/prefer_interpolation_to_compose_strings"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_Use interpolação para compor strings e valores._

## Description

O analisador produz este diagnóstico quando literais de string e strings
computadas estão sendo concatenadas usando o operador `+`, mas interpolação
de string alcançaria o mesmo resultado.

## Example

O código a seguir produz este diagnóstico porque a String `s` é
concatenada com outras strings usando o operador `+`:

```dart
String f(String s) {
  return [!'(' + s!] + ')';
}
```

## Common fixes

Use interpolação de string:

```dart
String f(List<String> l) {
  return '(${l[0]}, ${l[1]})';
}
```
