---
title: dart pub deps
description: Use dart pub deps to print a dependency graph for a package.
ia-translate: true
---

_Deps_ é um dos comandos da [ferramenta pub](/tools/pub/cmd).

```plaintext
$ dart pub deps [--style=<style>] [--[no-]dev] [--executables]
```

Este comando imprime o grafo de dependências para um pacote.
O grafo inclui tanto as
[dependências imediatas](/resources/glossary#immediate-dependency)
que o pacote usa (conforme especificado no pubspec), quanto as
[dependências transitivas](/resources/glossary#transitive-dependency)
trazidas pelas dependências imediatas.

As informações de dependência são impressas como uma árvore por padrão.

Por exemplo, o pubspec do exemplo markdown_converter especifica
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

## Opções

Para opções que se aplicam a todos os comandos pub, veja
[Opções globais](/tools/pub/cmd#global-options).

### `--style=<style>` ou `-s <style>`

O estilo especificado determina o formato de saída:

`tree`
: Imprime informações de dependência como uma árvore. Este é o
  formato padrão.

`list`
: Imprime informações de dependência como uma lista.

`compact`
: Imprime informações de dependência como uma lista compacta.

### `--[no-]dev`

Por padrão, imprime todas as dependências,
incluindo dependências de desenvolvimento (`--dev`).
Para remover dependências de desenvolvimento, use `--no-dev`.

### `--executables`

Imprime todos os executáveis disponíveis.

### `--json`

Gera saída no formato JSON.


{% render 'pub-problems.md' %}

## Em um workspace

Em um [Pub workspace](/tools/pub/workspaces) `dart pub deps` listará
dependências para todos os pacotes no workspace, um pacote de workspace por vez.
