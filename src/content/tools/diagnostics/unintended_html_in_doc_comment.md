---
ia-translate: true
title: unintended_html_in_doc_comment
description: "Detalhes sobre o diagnóstico unintended_html_in_doc_comment produzido pelo analisador do Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/unintended_html_in_doc_comment"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_Colchetes angulares serão interpretados como HTML._

## Description

O analisador produz este diagnóstico quando um comentário de documentação
contém texto entre colchetes angulares (`<...>`) que não é uma das exceções
permitidas.

Esse texto é interpretado pelo markdown como uma tag HTML, o que raramente
é o que foi pretendido.

Veja a [descrição da regra de lint](https://dart.dev/tools/linter-rules/unintended_html_in_doc_comment)
para a lista de exceções permitidas.

## Example

O código a seguir produz este diagnóstico porque o comentário de
documentação contém o texto `<int>`, que não é uma das exceções
permitidas:

```dart
/// Converts a List[!<int>!] to a comma-separated String.
String f(List<int> l) => '';
```

## Common fixes

Se o texto era para ser parte de um trecho de código, então adicione crases
ao redor do código:

```dart
/// Converts a `List<int>` to a comma-separated String.
String f(List<int> l) => '';
```

Se o texto era para ser parte de um link, então adicione colchetes
ao redor do código:

```dart
/// Converts a [List<int>] to a comma-separated String.
String f(List<int> l) => '';
```

Se o texto era para ser impresso como está, incluindo os colchetes
angulares, então adicione escapes com barra invertida antes dos colchetes angulares:

```dart
/// Converts a List\<int\> to a comma-separated String.
String f(List<int> l) => '';
```
