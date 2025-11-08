---
ia-translate: true
title: tighten_type_of_initializing_formals
description: >-
  Detalhes sobre o diagnóstico tighten_type_of_initializing_formals
  produzido pelo analisador do Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/tighten_type_of_initializing_formals"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_Use uma anotação de tipo em vez de 'assert' para garantir non-nullability._

## Description

O analisador produz este diagnóstico quando um `assert` está sendo usado na
lista de inicialização de um construtor para garantir que apenas um valor
não-`null` está sendo usado para inicializar um campo.

## Example

O código a seguir produz este diagnóstico porque um `assert` está sendo
usado para capturar um erro que poderia ser capturado pelo sistema de tipos:

```dart
class C {
  final String? s;

  C([!this.s!]) : assert(s != null);
}
```

## Common fixes

Remova o `assert` e adicione o tipo non-nullable antes do parâmetro de
inicialização formal:

```dart
class C {
  final String? s;

  C(String this.s);
}
```
