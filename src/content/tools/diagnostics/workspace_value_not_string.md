---
ia-translate: true
title: workspace_value_not_string
description: >-
  Detalhes sobre o diagnóstico workspace_value_not_string
  produzido pelo analisador do Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_Entradas de workspace são obrigatórias para serem caminhos de diretórios (strings)._

## Descrição

O analisador produz este diagnóstico quando uma lista `workspace` contém um
valor que não é uma string.

## Exemplo

O código a seguir produz este diagnóstico porque a lista `workspace`
contém um mapa:

```yaml
name: example
workspace:
    - [!image.gif: true!]
```

## Correções comuns

Altere a lista `workspace` para que ela contenha apenas caminhos de diretórios
no estilo POSIX válidos:

```yaml
name: example
workspace:
    - pkg/package_1
    - pkg/package_2
```
