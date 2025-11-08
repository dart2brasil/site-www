---
title: missing_dependency
description: "Detalhes sobre o diagnóstico missing_dependency produzido pelo analisador Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
ia-translate: true
---

_Falta uma dependência no pacote importado '{0}'._

## Description

O analisador produz este diagnóstico quando há um pacote que foi
importado no código-fonte mas não está listado como uma dependência do
pacote que está importando.

## Example

O código a seguir produz este diagnóstico porque o pacote `path` não
está listado como uma dependência, enquanto há uma declaração de importação
com o pacote `path` no código-fonte do pacote `example`:

```yaml
name: example
dependencies:
  meta: ^1.0.2
```

## Common fixes

Adicione o pacote missing `path` ao campo `dependencies`:

```yaml
name: example
dependencies:
  meta: ^1.0.2
  path: any
```
