---
ia-translate: true
title: prefer_typing_uninitialized_variables
description: "Detalhes sobre o diagnóstico prefer_typing_uninitialized_variables produzido pelo analisador Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/prefer_typing_uninitialized_variables"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_Um campo não inicializado deve ter uma anotação de tipo explícita._

_Uma variável não inicializada deve ter uma anotação de tipo explícita._

## Description

O analisador produz este diagnóstico quando uma variável sem um
inicializador não tem uma anotação de tipo explícita.

Sem uma anotação de tipo ou um inicializador, uma variável tem o
tipo `dynamic`, que permite que qualquer valor seja atribuído à variável,
frequentemente causando bugs difíceis de identificar.

## Example

O código a seguir produz este diagnóstico porque a variável `r`
não tem uma anotação de tipo nem um inicializador:

```dart
Object f() {
  var [!r!];
  r = '';
  return r;
}
```

## Common fixes

Se a variável pode ser inicializada, adicione um inicializador:

```dart
Object f() {
  var r = '';
  return r;
}
```

Se a variável não pode ser inicializada, adicione uma anotação de tipo
explícita:

```dart
Object f() {
  String r;
  r = '';
  return r;
}
```
