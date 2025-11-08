---
ia-translate: true
title: prefer_constructors_over_static_methods
description: >-
  Detalhes sobre o diagnóstico prefer_constructors_over_static_methods
  produzido pelo analisador Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/prefer_constructors_over_static_methods"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_Método static deve ser um construtor._

## Description

O analisador produz este diagnóstico quando um método static retorna uma
instância recém-criada da classe e poderia, portanto, ser um construtor.

## Example

O código a seguir produz este diagnóstico porque o método static
`all` poderia ser um construtor:

```dart
class C {
  final int a, b, c;
  C(this.a, this.b, this.c);
  static C [!all!](int i) => C(i, i, i);
}
```

## Common fixes

Converta o método static para um construtor nomeado:

```dart
class C {
  final int a, b, c;
  C(this.a, this.b, this.c);
  C.all(int i) : a = i, b = i, c = i;
}
```
