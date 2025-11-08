---
ia-translate: true
title: type_literal_in_constant_pattern
description: >-
  Detalhes sobre o diagnóstico type_literal_in_constant_pattern
  produzido pelo analisador Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/type_literal_in_constant_pattern"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_Use 'TypeName \_' em vez de um literal de tipo._

## Descrição

O analisador produz este diagnóstico quando um literal de tipo aparece como um
padrão.

## Exemplo

O código a seguir produz este diagnóstico porque um literal de tipo é usado
como um padrão constante:

```dart
void f(Object? x) {
  if (x case [!num!]) {
    // ...
  }
}
```

## Correções comuns

Se o literal de tipo se destina a corresponder a um objeto do tipo fornecido, então
use um padrão de variável:

```dart
void f(Object? x) {
  if (x case num _) {
    // ...
  }
}
```

Ou um padrão de objeto:

```dart
void f(Object? x) {
  if (x case num()) {
    // ...
  }
}
```

Se o literal de tipo se destina a corresponder ao literal de tipo, então escreva-o
como um padrão constante:

```dart
void f(Object? x) {
  if (x case const (num)) {
    // ...
  }
}
```
