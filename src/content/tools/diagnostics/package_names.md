---
ia-translate: true
title: package_names
description: >-
  Detalhes sobre o diagnóstico package_names
  produzido pelo analisador do Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/package_names"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_O nome do pacote '{0}' não é um identificador lower\_case\_with\_underscores._

## Description

O analisador produz este diagnóstico quando o nome de um pacote não
usa a convenção de nomenclatura lower_case_with_underscores.

## Example

O código a seguir produz este diagnóstico porque o nome do
pacote usa a convenção de nomenclatura lowerCamelCase:

```yaml
name: [!somePackage!]
```

## Common fixes

Reescreva o nome do pacote usando a convenção de nomenclatura
lower_case_with_underscores:

```yaml
name: some_package
```
