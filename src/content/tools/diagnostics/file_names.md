---
ia-translate: true
title: file_names
description: "Detalhes sobre o diagnóstico file_names produzido pelo analisador do Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/file_names"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_O nome do arquivo '{0}' não é um identificador lower\_case\_with\_underscores._

## Description

O analisador produz este diagnóstico quando o nome de um arquivo `.dart`
não usa lower_case_with_underscores.

## Example

Um arquivo chamado `SliderMenu.dart` produz este diagnóstico porque o nome do arquivo
usa a convenção UpperCamelCase.

## Common fixes

Renomeie o arquivo para usar a convenção lower_case_with_underscores, como
`slider_menu.dart`.
