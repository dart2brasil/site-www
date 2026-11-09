---
ia-translate: true
title: dart pub remove
description: Use dart pub remove para remover uma dependência.
---

_Remove_ é um dos comandos da [ferramenta pub](/tools/pub/cmd).

```plaintext
$ dart pub remove <package> [options]
```

Este comando remove o pacote especificado do pubspec como dependência.

Por exemplo, o comando a seguir é equivalente a
editar o `pubspec.yaml` (removendo `http` de `dependencies` ou `dev_dependencies`)
e depois chamar `dart pub get`:

```console
$ dart pub remove http
```

## Opções {:#options}

Para opções que se aplicam a todos os comandos do pub, veja
[Opções globais](/tools/pub/cmd#global-options).

### `--[no-]offline`

{% render 'tools/pub-option-no-offline.md' %}

### `-n, --dry-run`

Informa quais dependências mudariam,
mas não altera nenhuma delas.

### `--[no-]precompile`

Por padrão, o pub pré-compila os executáveis
das dependências imediatas (`--precompile`).
Para evitar a pré-compilação, use `--no-precompile`.

### `--[no-]example`

Por padrão, depois de remover as dependências especificadas,
o pub também recupera as dependências do
[diretório `example/`][example-dir] do pacote (`--example`).
Para pular a recuperação das dependências de exemplo, use `--no-example`.

[example-dir]: /tools/pub/package-layout#examples

## Em um workspace {:#in-a-workspace}

Em um [workspace do pub](/tools/pub/workspaces), `dart pub remove` remove
dependências do pacote no diretório atual.

{% render 'pub-problems.md' %}
