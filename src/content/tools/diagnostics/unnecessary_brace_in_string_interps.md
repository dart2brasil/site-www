---
ia-translate: true
title: unnecessary_brace_in_string_interps
description: "Detalhes sobre o diagnóstico unnecessary_brace_in_string_interps produzido pelo analisador Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/unnecessary_brace_in_string_interps"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_Chaves desnecessárias em uma interpolação de string._

## Description

O analisador produz este diagnóstico quando uma interpolação de string com
chaves é usada para interpolar um identificador simples e não é seguida por
texto alfanumérico.

## Example

O código a seguir produz este diagnóstico porque o elemento de interpolação
`${s}` usa chaves quando elas não são necessárias:

```dart
String f(String s) {
  return '"[!${s}!]"';
}
```

## Common fixes

Remova as chaves desnecessárias:

```dart
String f(String s) {
  return '"$s"';
}
```
