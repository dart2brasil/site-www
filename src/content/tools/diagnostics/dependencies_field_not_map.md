---
ia-translate: true
title: dependencies_field_not_map
description: >-
  Detalhes sobre o diagnóstico dependencies_field_not_map
  produzido pelo analisador do Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_O valor do campo '{0}' é esperado ser um map._

## Description

O analisador produz este diagnóstico quando o valor da chave
`dependencies` ou `dev_dependencies` não é um map.

## Example

O código a seguir produz este diagnóstico porque o valor da
chave `dependencies` de nível superior é uma lista:

```yaml
name: example
dependencies:
  [!- meta!]
```

## Common fixes

Use um map como o valor da chave `dependencies`:

```yaml
name: example
dependencies:
  meta: ^1.0.2
```
