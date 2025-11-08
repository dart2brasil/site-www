---
title: dartaotruntime
description: Command-line tool for running AOT-compiled snapshots of Dart code.
showToc: false
---

Com Dart, você pode criar aplicações Dart pré-compiladas chamadas *snapshots AOT*.

## Criar um app snapshot AOT {:#create-aot-snapshot-app}

Para produzir snapshots AOT, use o subcomando `aot-snapshot` do
comando [`dart compile`][dart compile].

## Executar um app snapshot AOT {:#run-aot-snapshot-app}

Para executar programas AOT, use o comando `dartaotruntime`.
Esta ferramenta suporta Windows, macOS e Linux.

:::note
Para executar use o comando `dartaotruntime`,
adicione o caminho para seu diretório Dart `bin` à sua variável de ambiente `PATH`.
:::

[dart compile]: /tools/dart-compile

## Revisar um exemplo {:#review-an-example}

Eis um exemplo de como criar e executar um snapshot AOT:

```console
$ dart compile aot-snapshot bin/myapp.dart
```

```console
Gerado: /Users/me/simpleapp/bin/myapp.aot
```

```console
$ dartaotruntime bin/simpleapp.aot
```

## Aprender mais opções {:#learn-more-options}

Para aprender mais sobre as opções de linha de comando, use a flag `--help`:

```console
$ dartaotruntime --help
