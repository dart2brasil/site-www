---
title: invalid_dependency
description: >-
  Details about the invalid_dependency
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_Publishable packages can't have '{0}' dependencies._

## Descrição

O analisador produz este diagnóstico quando a publishable package
includes a package in the `dependencies` list of its `pubspec.yaml` file
that isn't a pub-hosted dependency.

To learn more about the different types of dependency sources,
check out [Package dependencies](https://dart.dev/tools/pub/dependencies).

## Exemplo

O código a seguir produz este diagnóstico porque the dependency on
the package `transmogrify` isn't a pub-hosted dependency.

```yaml
name: example
dependencies:
  transmogrify:
    [!path!]: ../transmogrify
```

## Correções comuns

If you want to publish the package to `pub.dev`, then change
the dependency to a hosted package that is published on `pub.dev`.

If the package isn't intended to be published on `pub.dev`, then
add a `publish_to: none` entry to its `pubspec.yaml` file to
mark it as not intended to be published:

```yaml
name: example
publish_to: none
dependencies:
  transmogrify:
    path: ../transmogrify
```
