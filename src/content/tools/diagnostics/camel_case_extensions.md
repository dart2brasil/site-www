---
ia-translate: true
title: camel_case_extensions
description: >-
  Detalhes sobre o diagnóstico camel_case_extensions
  produzido pelo analisador do Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/camel_case_extensions"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_O nome da extension '{0}' não é um identificador UpperCamelCase._

## Description

O analisador produz este diagnóstico quando o nome de uma extension
não usa a convenção de nomenclatura 'UpperCamelCase'.

## Example

O código a seguir produz este diagnóstico porque o nome da
extension não começa com uma letra maiúscula:

```dart
extension [!stringExtension!] on String {}
```

## Common fixes

Se a extension precisa ter um nome (precisa estar visível fora desta
biblioteca), então renomeie a extension para que ela tenha um nome válido:

```dart
extension StringExtension on String {}
```

Se a extension não precisa ter um nome, então remova o nome da
extension:

```dart
extension on String {}
```
