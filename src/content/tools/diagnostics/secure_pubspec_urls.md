---
ia-translate: true
title: secure_pubspec_urls
description: "Detalhes sobre o diagnóstico secure_pubspec_urls produzido pelo analisador do Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/secure_pubspec_urls"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>

_O protocolo '{0}' não deve ser usado porque não é seguro._

## Description

O analisador produz este diagnóstico quando uma URL em um arquivo `pubspec.yaml` está
usando um esquema não seguro, como `http`.

## Example

O código a seguir produz este diagnóstico porque o arquivo `pubspec.yaml`
contém uma URL `http`:

```yaml
dependencies:
  example: any
    repository: [!http://github.com/dart-lang/example!]
```

## Common fixes

Altere o esquema da URL para usar um esquema seguro, como `https`:

```yaml
dependencies:
  example: any
    repository: https://github.com/dart-lang/example
```
