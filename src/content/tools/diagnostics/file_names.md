---
title: file_names
description: >-
  Details about the file_names
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
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

_The file name '{0}' isn't a lower\_case\_with\_underscores identifier._

## Descrição

O analisador produz este diagnóstico quando the name of a `.dart` file
doesn't use lower_case_with_underscores.

## Exemplo

A file named `SliderMenu.dart` produces this diagnostic because the file
name uses the UpperCamelCase convention.

## Correções comuns

Rename the file to use the lower_case_with_underscores convention, such as
`slider_menu.dart`.
