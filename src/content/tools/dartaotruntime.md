---
ia-translate: true
title: dartaotruntime
description: Ferramenta de linha de comando para executar snapshots AOT-compilados de código Dart.
showToc: false
---

Com Dart, você pode criar aplicações Dart pré-compiladas chamadas *AOT snapshots*.

## Criar aplicação AOT snapshot

Para produzir AOT snapshots, use o subcomando `aot-snapshot` do
[comando `dart compile`][dart compile].

## Executar aplicação AOT snapshot

Para executar programas AOT, use o comando `dartaotruntime`.
Esta ferramenta suporta Windows, macOS e Linux.

:::note
Para executar use o comando `dartaotruntime`,
adicione o caminho para seu diretório `bin` do Dart à sua variável de ambiente `PATH`.
:::

[dart compile]: /tools/dart-compile

## Revisar um exemplo

Aqui está um exemplo de criação e execução de um AOT snapshot:

```console
$ dart compile aot-snapshot bin/myapp.dart
```

```console
Generated: /Users/me/simpleapp/bin/myapp.aot
```

```console
$ dartaotruntime bin/simpleapp.aot
```

## Saiba mais opções

Para saber mais sobre opções de linha de comando, use a flag `--help`:

```console
$ dartaotruntime --help
```
