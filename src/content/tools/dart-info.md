---
ia-translate: true
title: dart info
description: Ferramenta de linha de comando para exibir informações de diagnóstico das ferramentas Dart.
toc: false
---

O comando `dart info`
exibe informações de diagnóstico sobre as ferramentas `dart` instaladas,
processos Dart em execução,
e informações do projeto se estiver em um diretório com um `pubspec.yaml`.
As informações de saída podem ser usadas para depurar problemas de ferramentas
ou reportar um bug.

{% render 'tools/dart-tool-note.md' %}

:::warning
Se você estiver incluindo a saída de `dart info` em um relatório de bug,
por favor, revise a saída para garantir que ela contenha apenas
detalhes que você se sinta confortável em postar publicamente.
:::

Para exibir informações gerais relacionadas ao seu sistema
e sua instalação Dart, incluindo processos Dart em execução,
execute `dart info` de qualquer diretório:

```console
$ dart info
```

Por exemplo, no macOS,
a saída é semelhante à seguinte:

```markdown
#### Informações gerais {:#general-info}

- Dart 2.19.2 (stable) (Ter 7 de fev 18:37:17 2023 +0000) em "macos_arm64"
- em macos / Versão 13.1 (Build 22C65)
- locale é en-US

#### Informações do processo {:#process-info}

| Memória |   CPU | Tempo decorrido | Linha de comando                      |
| ------: | ----: | --------------: | -------------------------------------|
|  253 MB | 49.7% |           00:00 | analysis_server.dart.snapshot ... |
|   69 MB | 18.7% |           00:00 | dart analyze                       |
```

Para incluir informações do projeto na saída,
execute `dart info` em um diretório com um arquivo `pubspec.yaml`.
A saída resultante inclui uma seção adicional de **Informações do projeto**:

```plaintext
#### Informações do projeto {:#project-info}

- restrição do sdk (sdk constraint): '>=2.19.2 <3.0.0'
- dependências: path
- dev_dependencies: lints, test
```

Para incluir caminhos de arquivo e dependências de caminho nas informações
de projeto e processo exibidas,
adicione a opção `--no-remove-file-paths`:

```console
$ dart info --no-remove-file-paths
