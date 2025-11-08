---
ia-translate: true
title: avoid_relative_lib_imports
description: >-
  Detalhes sobre o diagnóstico avoid_relative_lib_imports
  produzido pelo analisador do Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/avoid_relative_lib_imports"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_Não é possível usar um caminho relativo para importar uma biblioteca em 'lib'._

## Description

O analisador produz este diagnóstico quando a URI em uma diretiva `import`
tem `lib` no caminho.

## Example

Assumindo que há um arquivo chamado `a.dart` no diretório `lib`:

```dart
class A {}
```

O código a seguir produz este diagnóstico porque o import contém um
caminho que inclui `lib`:

```dart
import [!'../lib/a.dart'!];
```

## Common fixes

Reescreva o import para não incluir `lib` na URI:

```dart
import 'a.dart';
```
