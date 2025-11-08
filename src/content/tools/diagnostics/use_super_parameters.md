---
ia-translate: true
title: use_super_parameters
description: "Detalhes sobre o diagnóstico use_super_parameters produzido pelo analisador Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/use_super_parameters"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_Parâmetro '{0}' poderia ser um super parâmetro._

_Parâmetros '{0}' poderiam ser super parâmetros._

## Descrição

O analisador produz este diagnóstico quando um parâmetro de um construtor é
passado para um super construtor sem ser referenciado ou modificado e um
parâmetro `super` não é usado.

## Exemplo

O código a seguir produz este diagnóstico porque os parâmetros do
construtor para `B` são usados apenas como argumentos para o super construtor:

```dart
class A {
  A({int? x, int? y});
}
class B extends A {
  [!B!]({int? x, int? y}) : super(x: x, y: y);
}
```

## Correções comuns

Use um parâmetro `super` para passar os argumentos:

```dart
class A {
  A({int? x, int? y});
}
class B extends A {
  B({super.x, super.y});
}
```
