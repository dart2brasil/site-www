---
ia-translate: true
title: sort_pub_dependencies
description: >-
  Detalhes sobre o diagnóstico sort_pub_dependencies
  produzido pelo analisador do Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/sort_pub_dependencies"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_Dependências não estão ordenadas alfabeticamente._

## Descrição

O analisador produz este diagnóstico quando as chaves em um mapa de dependências no
arquivo `pubspec.yaml` não estão ordenadas alfabeticamente. Os mapas de dependências
que são verificados são os mapas `dependencies`, `dev_dependencies` e
`dependency_overrides`.

## Exemplo

O código a seguir produz este diagnóstico porque as entradas no
mapa `dependencies` não estão ordenadas:

```yaml
dependencies:
  path: any
  collection: any
```

## Correções comuns

Ordene as entradas:

```yaml
dependencies:
  collection: any
  path: any
```
