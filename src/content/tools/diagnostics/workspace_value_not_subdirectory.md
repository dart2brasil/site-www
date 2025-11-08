---
ia-translate: true
title: workspace_value_not_subdirectory
description: "Detalhes sobre o diagnóstico workspace_value_not_subdirectory produzido pelo analisador do Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_Valores de workspace devem ser um caminho relativo de um subdiretório de '{0}'._

## Descrição

O analisador produz este diagnóstico quando uma lista `workspace` contém um
valor que não é um subdiretório do diretório que contém o arquivo `pubspec.yaml`.

## Exemplo

O código a seguir produz este diagnóstico porque o valor na lista `workspace` não é um
caminho relativo de um subdiretório do diretório que contém o arquivo 'pubspec.yaml':

```yaml
name: example
workspace:
    - /home/my_package
```

## Correções comuns

Altere a lista `workspace` para que ela contenha apenas caminhos de subdiretórios.

```yaml
name: example
workspace:
    - pkg/package_1
    - pkg/package_2
```
