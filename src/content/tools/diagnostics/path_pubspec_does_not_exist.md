---
ia-translate: true
title: path_pubspec_does_not_exist
description: "Detalhes sobre o diagnóstico path_pubspec_does_not_exist produzido pelo analisador do Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_O diretório '{0}' não contém um pubspec._

## Descrição

O analisador produz este diagnóstico quando uma dependência tem uma chave `path`
que referencia um diretório que não contém um arquivo `pubspec.yaml`.

## Exemplo

Assumindo que o diretório `local_package` não contém um arquivo
`pubspec.yaml`, o código a seguir produz este diagnóstico porque está
listado como o caminho de um pacote:

```yaml
name: example
dependencies:
  local_package:
    path: [!local_package!]
```

## Correções comuns

Se o caminho é destinado a ser a raiz de um pacote, então adicione um
arquivo `pubspec.yaml` no diretório:

```yaml
name: local_package
```

Se o caminho estiver errado, então substitua-o pelo caminho correto.
