---
ia-translate: true
title: prefer_foreach
description: >-
  Detalhes sobre o diagnóstico prefer_foreach
  produzido pelo analisador Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/prefer_foreach"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_Use 'forEach' e um tear-off em vez de um loop 'for' para aplicar uma função a cada elemento._

## Description

O analisador produz este diagnóstico quando um loop `for` é usado para operar
em cada membro de uma coleção e o método `forEach` poderia ser usado
em vez disso.

## Example

O código a seguir produz este diagnóstico porque um loop `for` está sendo
usado para invocar uma única função para cada chave em `m`:

```dart
void f(Map<String, int> m) {
  [!for (final key in m.keys) {!]
    [!print(key);!]
  [!}!]
}
```

## Common fixes

Substitua o loop for por uma invocação de `forEach`:

```dart
void f(Map<String, int> m) {
  m.keys.forEach(print);
}
```
