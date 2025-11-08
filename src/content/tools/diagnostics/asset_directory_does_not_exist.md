---
ia-translate: true
title: asset_directory_does_not_exist
description: >-
  Detalhes sobre o diagnóstico asset_directory_does_not_exist
  produzido pelo analisador Dart.
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_The asset directory '{0}' doesn't exist._

## Description

O analisador produz este diagnóstico quando uma lista de assets contém um valor
referenciando um diretório que não existe.

## Example

Assumindo que o diretório `assets` não existe, o código a seguir
produz este diagnóstico porque ele está listado como um diretório contendo
assets:

```yaml
name: example
flutter:
  assets:
    - [!assets/!]
```

## Common fixes

Se o caminho está correto, então crie um diretório nesse caminho.

Se o caminho não está correto, então altere o caminho para corresponder ao caminho do
diretório contendo os assets.
