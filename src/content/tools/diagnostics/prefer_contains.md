---
ia-translate: true
title: prefer_contains
description: "Detalhes sobre o diagnóstico prefer_contains produzido pelo analisador Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/prefer_contains"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_Sempre 'false' porque 'indexOf' é sempre maior ou igual a -1._

_Sempre 'true' porque 'indexOf' é sempre maior ou igual a -1._

_Uso desnecessário de 'indexOf' para testar contenção._

## Description

O analisador produz este diagnóstico quando o método `indexOf` é usado e
o resultado é apenas comparado com `-1` ou `0` de uma forma onde a semântica
é equivalente a usar `contains`.

## Example

O código a seguir produz este diagnóstico porque a condição na
instrução `if` está verificando se a lista contém a string:

```dart
void f(List<String> l, String s) {
  if ([!l.indexOf(s) < 0!]) {
    // ...
  }
}
```

## Common fixes

Use `contains` em vez disso, negando a condição quando necessário:

```dart
void f(List<String> l, String s) {
  if (l.contains(s)) {
    // ...
  }
}
```
