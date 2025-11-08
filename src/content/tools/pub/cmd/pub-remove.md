---
ia-translate: true
title: dart pub remove
description: "Use dart pub remove para remover uma dependência."
---

_Remove_ (remover) é um dos comandos da [ferramenta pub](/tools/pub/cmd).

```plaintext
$ dart pub remove <pacote> [opções]
```

Este comando remove o pacote especificado do `pubspec` como uma dependência.

Por exemplo, o seguinte comando é equivalente a
editar `pubspec.yaml` (removendo `http` de `dependencies` ou `dev_dependencies`)
e então chamar `dart pub get`:

```console
$ dart pub remove http
```

## Opções {:#options}

Para opções que se aplicam a todos os comandos do pub, veja
[Opções globais](/tools/pub/cmd#global-options).

### `--[no-]offline` {:#no-offline}

{% render 'tools/pub-option-no-offline.md' %}

### `-n, --dry-run` {:#n-dry-run}

Reporta quais dependências seriam alteradas,
mas não altera nenhuma.

### `--[no-]precompile` {:#no-precompile}

Por padrão, o pub pré-compila executáveis
em dependências imediatas (`--precompile`).
Para prevenir a pré-compilação, use `--no-precompile`.

## Em um workspace {:#in-a-workspace}

Em um [Pub workspace](/tools/pub/workspaces) `dart pub remove` remove
dependências do pacote no diretório atual.

{% render 'pub-problems.md' %}