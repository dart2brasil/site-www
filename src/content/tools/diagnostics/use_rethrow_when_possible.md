---
ia-translate: true
title: use_rethrow_when_possible
description: "Detalhes sobre o diagnóstico use_rethrow_when_possible produzido pelo analisador Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/use_rethrow_when_possible"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_Use 'rethrow' para relançar uma exceção capturada._

## Descrição

O analisador produz este diagnóstico quando uma exceção capturada é lançada
usando uma expressão `throw` em vez de uma declaração `rethrow`.

## Exemplo

O código a seguir produz este diagnóstico porque a exceção capturada
`e` é lançada usando uma expressão `throw`:

```dart
void f() {
  try {
    // ...
  } catch (e) {
    [!throw e!];
  }
}
```

## Correções comuns

Use `rethrow` em vez de `throw`:

```dart
void f() {
  try {
    // ...
  } catch (e) {
    rethrow;
  }
}
```
