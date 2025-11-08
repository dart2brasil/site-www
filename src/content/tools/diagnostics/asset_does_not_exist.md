---
ia-translate: true
title: asset_does_not_exist
description: "Detalhes sobre o diagnóstico asset_does_not_exist produzido pelo analisador Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_The asset file '{0}' doesn't exist._

## Description

O analisador produz este diagnóstico quando uma lista de assets contém um valor
referenciando um arquivo que não existe.

## Example

Assumindo que o arquivo `doesNotExist.gif` não existe, o código a seguir
produz este diagnóstico porque ele está listado como um asset:

```yaml
name: example
flutter:
  assets:
    - [!doesNotExist.gif!]
```

## Common fixes

Se o caminho está correto, então crie um arquivo nesse caminho.

Se o caminho não está correto, então altere o caminho para corresponder ao caminho do
arquivo contendo o asset.
