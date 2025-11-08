---
ia-translate: true
title: unnecessary_library_name
description: >-
  Detalhes sobre o diagnóstico unnecessary_library_name
  produzido pelo analisador Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/unnecessary_library_name"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_Nomes de biblioteca não são necessários._

## Description

O analisador produz este diagnóstico quando uma diretiva `library` especifica
um nome.

## Example

O código a seguir produz este diagnóstico porque a diretiva `library`
inclui um nome:

```dart
library [!some.name!];

class C {}
```

## Common fixes

Remova o nome da diretiva `library`:

```dart
library;

class C {}
```

Se a biblioteca tiver alguma parte, então qualquer declaração `part of` que use
o nome da biblioteca deve ser atualizada para usar a URI da biblioteca.
