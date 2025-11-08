---
ia-translate: true
title: unnecessary_null_aware_assignments
description: >-
  Detalhes sobre o diagnóstico unnecessary_null_aware_assignments
  produzido pelo analisador Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/unnecessary_null_aware_assignments"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_Atribuição desnecessária de 'null'._

## Description

O analisador produz este diagnóstico quando o lado direito de uma
atribuição null-aware é o literal `null`.

## Example

O código a seguir produz este diagnóstico porque o operador null aware
está sendo usado para atribuir `null` a `s` quando `s` já é `null`:

```dart
void f(String? s) {
  [!s ??= null!];
}
```

## Common fixes

Se um valor não-null deve ser atribuído ao operando do lado esquerdo, então
altere o lado direito:

```dart
void f(String? s) {
  s ??= '';
}
```

Se não houver valor não-null para atribuir ao operando do lado esquerdo, então
remova a atribuição:

```dart
void f(String? s) {
}
```
