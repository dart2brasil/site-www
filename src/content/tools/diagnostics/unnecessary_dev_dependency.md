---
ia-translate: true
title: unnecessary_dev_dependency
description: "Detalhes sobre o diagnóstico unnecessary_dev_dependency produzido pelo analisador Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_A dependência dev em {0} é desnecessária porque também existe uma dependência normal nesse pacote._

## Description

O analisador produz este diagnóstico quando há uma entrada em
`dev_dependencies` para um pacote que também está listado em `dependencies`.
Os pacotes em `dependencies` estão disponíveis para todo o código no
pacote, então não há necessidade de também listá-los em `dev_dependencies`.

## Example

O código a seguir produz este diagnóstico porque o pacote `meta` está
listado tanto em `dependencies` quanto em `dev_dependencies`:

```yaml
name: example
dependencies:
  meta: ^1.0.2
dev_dependencies:
  [!meta!]: ^1.0.2
```

## Common fixes

Remova a entrada em `dev_dependencies` (e a chave `dev_dependencies`
se esse for o único pacote listado lá):

```yaml
name: example
dependencies:
  meta: ^1.0.2
```
