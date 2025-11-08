---
title: library_annotations
description: "Detalhes sobre o diagnóstico library_annotations produzido pelo analisador Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/library_annotations"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_Esta anotação deve ser anexada a uma diretiva library._

## Descrição

O analisador produz este diagnóstico quando uma anotação que se aplica a
uma library inteira não está associada a uma diretiva `library`.

## Exemplo

O código a seguir produz este diagnóstico porque a anotação `TestOn`,
que se aplica à library inteira, está associada a uma
diretiva `import` em vez de uma diretiva `library`:

```dart
[!@TestOn('browser')!]

import 'package:test/test.dart';

void main() {}
```

## Correções comuns

Associe a anotação a uma diretiva `library`, adicionando uma se
necessário:

```dart
@TestOn('browser')
library;

import 'package:test/test.dart';

void main() {}
```
