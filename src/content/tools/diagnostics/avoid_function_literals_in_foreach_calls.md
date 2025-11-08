---
ia-translate: true
title: avoid_function_literals_in_foreach_calls
description: "Detalhes sobre o diagnóstico avoid_function_literals_in_foreach_calls produzido pelo analisador do Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/avoid_function_literals_in_foreach_calls"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_Literais de função não devem ser passados para 'forEach'._

## Description

O analisador produz este diagnóstico quando o argumento para
`Iterable.forEach` é uma closure.

## Example

O código a seguir produz este diagnóstico porque o argumento para a
invocação de `forEach` é uma closure:

```dart
void f(Iterable<String> s) {
  s.[!forEach!]((e) => print(e));
}
```

## Common fixes

Se a closure pode ser substituída por um tear-off, então substitua a closure:

```dart
void f(Iterable<String> s) {
  s.forEach(print);
}
```

Se a closure não pode ser substituída por um tear-off, então use um loop `for` para
iterar sobre os elementos:

```dart
void f(Iterable<String> s) {
  for (var e in s) {
    print(e);
  }
}
```
