---
title: missing_dependency
description: >-
  Details about the missing_dependency
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_Missing a dependency on imported package '{0}'._

## Descrição

O analisador produz este diagnóstico quando there's a package that has been
imported in the source but is not listed as a dependency of the
importing package.

## Exemplo

O código a seguir produz este diagnóstico porque the package `path` is
not listed as a dependency, while there is an import statement
with package `path` in the source code of package `example`:

```yaml
name: example
dependencies:
  meta: ^1.0.2
```

## Correções comuns

Add the missing package `path` to the `dependencies` field:

```yaml
name: example
dependencies:
  meta: ^1.0.2
  path: any
```
