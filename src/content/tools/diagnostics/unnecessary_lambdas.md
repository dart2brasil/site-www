---
ia-translate: true
title: unnecessary_lambdas
description: >-
  Detalhes sobre o diagnóstico unnecessary_lambdas
  produzido pelo analisador Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/unnecessary_lambdas"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_Closure deveria ser um tearoff._

## Description

O analisador produz este diagnóstico quando uma closure (lambda) poderia ser
substituída por um tear-off.

## Example

O código a seguir produz este diagnóstico porque a closure passada para
`forEach` contém apenas uma invocação da função `print` com o
parâmetro da closure:

```dart
void f(List<String> strings) {
  strings.forEach([!(string) {!]
    [!print(string);!]
  [!}!]);
}
```

## Common fixes

Substitua a closure por um tear-off da função ou método sendo
invocado com a closure:

```dart
void f(List<String> strings) {
  strings.forEach(print);
}
```
