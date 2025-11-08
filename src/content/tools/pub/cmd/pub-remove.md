---
title: dart pub remove
description: Use dart pub remove to remove a dependency.
ia-translate: true
---

_Remove_ é um dos comandos da [ferramenta pub](/tools/pub/cmd).

```plaintext
$ dart pub remove <package> [options]
```

Este comando remove o pacote especificado do pubspec como uma dependência.

Por exemplo, o seguinte comando é equivalente a
editar `pubspec.yaml` (removendo `http` de `dependencies` ou `dev_dependencies`)
e depois chamar `dart pub get`:

```console
$ dart pub remove http
```

## Opções

Para opções que se aplicam a todos os comandos pub, veja
[Opções globais](/tools/pub/cmd#global-options).

### `--[no-]offline`

{% render 'tools/pub-option-no-offline.md' %}

### `-n, --dry-run`

Relata quais dependências mudariam,
mas não altera nenhuma.

### `--[no-]precompile`

Por padrão, o pub pré-compila executáveis
em dependências imediatas (`--precompile`).
Para evitar a pré-compilação, use `--no-precompile`.

## Em um workspace

Em um [Pub workspace](/tools/pub/workspaces) `dart pub remove` remove
dependências do pacote no diretório atual.

{% render 'pub-problems.md' %}
