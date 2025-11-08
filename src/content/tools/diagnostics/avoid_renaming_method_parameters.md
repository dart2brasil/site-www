---
ia-translate: true
title: avoid_renaming_method_parameters
description: >-
  Detalhes sobre o diagnóstico avoid_renaming_method_parameters
  produzido pelo analisador do Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/avoid_renaming_method_parameters"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_O nome do parâmetro '{0}' não corresponde ao nome '{1}' no método sobrescrito._

## Description

O analisador produz este diagnóstico quando um método que sobrescreve um
método de uma superclasse altera os nomes dos parâmetros.

## Example

O código a seguir produz este diagnóstico porque o parâmetro do
método `m` em `B` é nomeado `b`, que é diferente do nome do
parâmetro do método sobrescrito em `A`:

```dart
class A {
  void m(int a) {}
}

class B extends A {
  @override
  void m(int [!b!]) {}
}
```

## Common fixes

Renomeie um dos parâmetros para que sejam os mesmos:

```dart
class A {
  void m(int a) {}
}

class B extends A {
  @override
  void m(int a) {}
}
```
