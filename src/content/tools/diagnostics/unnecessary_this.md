---
ia-translate: true
title: unnecessary_this
description: "Detalhes sobre o diagnóstico unnecessary_this produzido pelo analisador Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/unnecessary_this"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_Qualificador 'this.' desnecessário._

## Description

O analisador produz este diagnóstico quando a keyword `this` é usada para
acessar um membro que não está sombreado.

## Example

O código a seguir produz este diagnóstico porque o uso de `this` para
acessar o campo `_f` não é necessário:

```dart
class C {
  int _f = 2;

  int get f => [!this!]._f;
}
```

## Common fixes

Remova o `this.`:

```dart
class C {
  int _f = 2;

  int get f => _f;
}
```
