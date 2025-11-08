---
ia-translate: true
title: throw_in_finally
description: "Detalhes sobre o diagnóstico throw_in_finally produzido pelo analisador Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/throw_in_finally"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_Uso de '{0}' em bloco 'finally'._

## Descrição

O analisador produz este diagnóstico quando uma declaração `throw` é encontrada
dentro de um bloco `finally`.

## Exemplo

O código a seguir produz este diagnóstico porque há uma declaração `throw`
dentro de um bloco `finally`:

```dart
void f() {
  try {
    // ...
  } catch (e) {
    // ...
  } finally {
    [!throw 'error'!];
  }
}
```

## Correções comuns

Reescreva o código para que a declaração `throw` não esteja dentro de um bloco
`finally`:

```dart
void f() {
  try {
    // ...
  } catch (e) {
    // ...
  }
  throw 'error';
}
```
