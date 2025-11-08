---
ia-translate: true
title: prefer_relative_imports
description: "Detalhes sobre o diagnóstico prefer_relative_imports produzido pelo analisador Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/prefer_relative_imports"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_Use imports relativos para arquivos no diretório 'lib'._

## Description

O analisador produz este diagnóstico quando um `import` em uma biblioteca dentro
do diretório `lib` usa um URI `package:` para se referir a outra biblioteca no
mesmo pacote.

## Example

O código a seguir produz este diagnóstico porque usa um URI `package:`
quando um URI relativo poderia ter sido usado:

```dart
import 'package:my_package/bar.dart';
```

## Common fixes

Use um URI relativo para importar a biblioteca:

```dart
import 'bar.dart';
```
