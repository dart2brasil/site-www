---
ia-translate: true
title: prefer_is_not_operator
description: "Detalhes sobre o diagnóstico prefer_is_not_operator produzido pelo analisador Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/prefer_is_not_operator"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_Use o operador 'is!' em vez de negar o valor do operador 'is'._

## Description

O analisador produz este diagnóstico quando o operador prefixo `!` é usado
para negar o resultado de um teste `is`.

## Example

O código a seguir produz este diagnóstico porque o resultado de testar
se `o` é uma `String` é negado usando o operador prefixo `!`:

```dart
String f(Object o) {
  if ([!!(o is String)!]) {
    return o.toString();
  }
  return o;
}
```

## Common fixes

Use o operador `is!` em vez disso:

```dart
String f(Object o) {
  if (o is! String) {
    return o.toString();
  }
  return o;
}
```
