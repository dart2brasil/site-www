---
ia-translate: true
title: prefer_initializing_formals
description: "Detalhes sobre o diagnóstico prefer_initializing_formals produzido pelo analisador Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/prefer_initializing_formals"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_Use um parâmetro formal inicializador para atribuir um parâmetro a um campo._

## Description

O analisador produz este diagnóstico quando um parâmetro de construtor é usado
para inicializar um campo sem modificação.

## Example

O código a seguir produz este diagnóstico porque o parâmetro `c` é
usado apenas para definir o campo `c`:

```dart
class C {
  int c;

  C(int c) : [!this.c = c!];
}
```

## Common fixes

Use um parâmetro formal inicializador para inicializar o campo:

```dart
class C {
  int c;

  C(this.c);
}
```
