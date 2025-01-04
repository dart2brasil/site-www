---
ia-translate: true
title: dart pub deps
description: Use dart pub deps para imprimir um gráfico de dependência para um pacote.
---

_Deps_ é um dos comandos da [ferramenta pub](/tools/pub/cmd).

```plaintext
$ dart pub deps [--style=<style>] [--[no-]dev] [--executables]
```

Este comando imprime o gráfico de dependência para um pacote.
O gráfico inclui tanto as
[dependências imediatas](/tools/pub/glossary#immediate-dependency)
que o pacote usa (conforme especificado no pubspec), bem como as
[dependências transitivas](/tools/pub/glossary#transitive-dependency)
trazidas pelas dependências imediatas.

As informações de dependência são impressas como uma árvore por padrão.

Por exemplo, o pubspec para o exemplo markdown_converter especifica
as seguintes dependências:

```yaml
dependencies:
  barback: ^0.15.2
  markdown: ^0.7.2
```

Aqui está um exemplo da saída de `dart pub deps` para markdown_converter:

```console
$ dart pub deps
markdown_converter 0.0.0
|-- barback 0.15.2+6
|   |-- collection 1.1.2
|   |-- path 1.3.6
|   |-- pool 1.1.0
|   |   '-- stack_trace...
|   |-- source_span 1.2.0
|   |   '-- path...
|   '-- stack_trace 1.4.2
|       '-- path...
'-- markdown 0.7.2
```

## Opções {:#options}

Para opções que se aplicam a todos os comandos pub, consulte
[Opções globais](/tools/pub/cmd#global-options).

### `--style=<style>` ou `-s <style>` {:#style-style-or-s-style}

O estilo especificado determina o formato de saída:

`tree`
: Imprime informações de dependência como uma árvore. Este é o
  formato padrão.

`list`
: Imprime informações de dependência como uma lista.

`compact`
: Imprime informações de dependência como uma lista compacta.

### `--[no-]dev` {:#no-dev}

Por padrão, imprime todas as dependências,
incluindo dependências de desenvolvimento (`--dev`).
Para remover dependências de desenvolvimento, use `--no-dev`.

### `--executables` {:#executables}

Imprime todos os executáveis disponíveis.

### `--json` {:#json}

Gera a saída em formato JSON.


{% render 'pub-problems.md' %}

## Em um workspace {:#in-a-workspace}

Em um [workspace Pub](/tools/pub/workspaces), `dart pub deps` listará
as dependências de todos os pacotes no workspace, um pacote de workspace por vez.