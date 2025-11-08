---
ia-translate: true
title: public_member_api_docs
description: "Detalhes sobre o diagnóstico public_member_api_docs produzido pelo analisador do Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/public_member_api_docs"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_Documentação ausente para um membro público._

## Description

O analisador produz este diagnóstico quando a declaração de parte da
API pública de um pacote não possui um comentário de documentação.

## Example

O código a seguir produz este diagnóstico porque a classe `C` não
possui um comentário de documentação:

```dart
class [!C!] {}
```

## Common fixes

Adicione um comentário de documentação.

```dart
/// Documentation comment.
class C {}
```
