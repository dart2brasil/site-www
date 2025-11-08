---
title: secure_pubspec_urls
description: >-
  Details about the secure_pubspec_urls
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
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

_The '{0}' protocol shouldn't be used because it isn't secure._

## Descrição

O analisador produz este diagnóstico quando a URL in a `pubspec.yaml` file is
using a non-secure scheme, such as `http`.

## Exemplo

O código a seguir produz este diagnóstico porque the `pubspec.yaml` file
contains an `http` URL:

```yaml
dependencies:
  example: any
    repository: [!http://github.com/dart-lang/example!]
```

## Correções comuns

Change the scheme of the URL to use a secure scheme, such as `https`:

```yaml
dependencies:
  example: any
    repository: https://github.com/dart-lang/example
```
