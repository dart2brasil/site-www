---
ia-translate: true
title: path_does_not_exist
description: "Detalhes sobre o diagnóstico path_does_not_exist produzido pelo analisador do Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_O caminho '{0}' não existe._

## Descrição

O analisador produz este diagnóstico quando uma dependência tem uma chave `path`
referenciando um diretório que não existe.

## Exemplo

Assumindo que o diretório `doesNotExist` não existe, o seguinte
código produz este diagnóstico porque está listado como o caminho de um pacote:

```yaml
name: example
dependencies:
  local_package:
    path: [!doesNotExist!]
```

## Correções comuns

Se o caminho estiver correto, então crie um diretório nesse caminho.

Se o caminho não estiver correto, então altere o caminho para corresponder ao caminho para a
raiz do pacote.
