---
ia-translate: true
title: dart info
description: Ferramenta de linha de comando para exibir informações de diagnóstico do tooling do Dart.
showToc: false
---

O comando `dart info`
exibe informações de diagnóstico sobre o tooling do `dart` instalado,
processos Dart em execução,
e informações do projeto se estiver em um diretório com um `pubspec.yaml`.
As informações exibidas podem ser usadas para depurar problemas de tooling
ou reportar um bug.

{% render 'tools/dart-tool-note.md' %}

:::warning
Se você estiver incluindo a saída do `dart info` em um bug report,
revise a saída para garantir que ela contenha apenas
detalhes que você se sinta confortável em publicar.
:::

Para exibir informações gerais relacionadas ao seu sistema
e sua instalação do Dart, incluindo processos Dart em execução,
execute `dart info` de qualquer diretório:

```console
$ dart info
```

Por exemplo, no macOS,
a saída é semelhante ao seguinte:

```markdown
#### General info

- Dart 2.19.2 (stable) (Tue Feb 7 18:37:17 2023 +0000) on "macos_arm64"
- on macos / Version 13.1 (Build 22C65)
- locale is en-US

#### Process info

| Memory |   CPU | Elapsed time | Command line                      |
| -----: | ----: | -----------: | ----------------------------------|
| 253 MB | 49.7% |        00:00 | analysis_server.dart.snapshot ... |
|  69 MB | 18.7% |        00:00 | dart analyze                      |
```

Para incluir informações do projeto na saída,
execute `dart info` em um diretório com um arquivo `pubspec.yaml`.
A saída resultante inclui uma seção adicional **Project info**:

```plaintext
#### Project info

- sdk constraint: '>=2.19.2 <3.0.0'
- dependencies: path
- dev_dependencies: lints, test
```

Para incluir caminhos de arquivos e dependências de path nas
informações de projeto e processo exibidas,
adicione a opção `--no-remove-file-paths`:

```console
$ dart info --no-remove-file-paths
```
