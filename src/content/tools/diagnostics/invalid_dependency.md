---
ia-translate: true
title: invalid_dependency
description: "Detalhes sobre o diagnóstico invalid_dependency produzido pelo analisador do Dart."
underscore_breaker_titles: true
bodyClass: highlight-diagnostics
---

_Pacotes publicáveis não podem ter dependências '{0}'._

## Description

O analisador produz este diagnóstico quando um pacote publicável inclui um
pacote na lista `dependencies` de seu arquivo `pubspec.yaml` que não é uma
dependência hospedada no pub.

Para saber mais sobre os diferentes tipos de fontes de dependências,
confira [Package dependencies](https://dart.dev/tools/pub/dependencies).

## Example

O código a seguir produz este diagnóstico porque a dependência no pacote
`transmogrify` não é uma dependência hospedada no pub.

```yaml
name: example
dependencies:
  transmogrify:
    [!path!]: ../transmogrify
```

## Common fixes

Se você deseja publicar o pacote no `pub.dev`, altere a dependência para um
pacote hospedado que está publicado no `pub.dev`.

Se o pacote não pretende ser publicado no `pub.dev`, adicione uma entrada
`publish_to: none` ao seu arquivo `pubspec.yaml` para marcá-lo como não
destinado a ser publicado:

```yaml
name: example
publish_to: none
dependencies:
  transmogrify:
    path: ../transmogrify
```
