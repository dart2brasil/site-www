---
ia-translate: true
title: always_use_package_imports
description: "Detalhes sobre o diagnóstico always_use_package_imports produzido pelo analisador do Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/always_use_package_imports"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_Use 'package:' imports for files in the 'lib' directory._

## Description

O analisador produz este diagnóstico quando um `import` em uma biblioteca dentro
do diretório `lib` usa um caminho relativo para importar outra biblioteca dentro
do diretório `lib` do mesmo pacote.

## Example

Dado que um arquivo chamado `a.dart` e o código abaixo estão ambos dentro do
diretório `lib` do mesmo pacote, o código a seguir produz este
diagnóstico porque uma URI relativa é usada para importar `a.dart`:

```dart
import [!'a.dart'!];
```

## Common fixes

Use um import de pacote:

```dart
import 'package:p/a.dart';
```
