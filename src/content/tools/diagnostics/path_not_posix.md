---
ia-translate: true
title: path_not_posix
description: >-
  Detalhes sobre o diagnóstico path_not_posix
  produzido pelo analisador do Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_O caminho '{0}' não é um caminho no estilo POSIX._

## Descrição

O analisador produz este diagnóstico quando uma dependência tem uma chave `path`
cujo valor é uma string, mas não é um caminho no estilo POSIX.

## Exemplo

O código a seguir produz este diagnóstico porque o caminho que segue a
chave `path` é um caminho Windows:

```yaml
name: example
dependencies:
  local_package:
    path: [!E:\local_package!]
```

## Correções comuns

Converta o caminho para um caminho POSIX.
