---
ia-translate: true
title: slash_for_doc_comments
description: >-
  Detalhes sobre o diagnóstico slash_for_doc_comments
  produzido pelo analisador do Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/slash_for_doc_comments"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_Use a forma de fim de linha ('///') para comentários de documentação._

## Descrição

O analisador produz este diagnóstico quando um comentário de documentação usa
o estilo de comentário em bloco (delimitado por `/**` e `*/`).

## Exemplo

O código a seguir produz este diagnóstico porque o comentário de documentação
para `f` usa um estilo de comentário em bloco:

```dart
[!/**!]
 [!* Example.!]
 [!*/!]
void f() {}
```

## Correções comuns

Use um estilo de comentário de fim de linha:

```dart
/// Example.
void f() {}
```
