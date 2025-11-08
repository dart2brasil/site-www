---
ia-translate: true
title: dart pub cache
description: Use dart pub cache para gerenciar o cache do seu sistema.
---

_Cache_ (cache) é um dos comandos da [ferramenta pub](/tools/pub/cmd).

```plaintext
$ dart pub cache add <pacote> [--version <restrição>] [--all]
$ dart pub cache repair
$ dart pub cache clean
```

The `dart pub cache` command works with the
[system cache](/resources/glossary#pub-system-cache).

## Adicionando um pacote ao cache do sistema {:#adding-a-package-to-the-system-cache}

Você pode adicionar manualmente um pacote ao cache do seu sistema:

```console
$ dart pub cache add <pacote>
```

## Reinstalando todos os pacotes no cache do sistema {:#reinstalling-all-packages-in-the-system-cache}

Você pode realizar uma reinstalação limpa de todos os pacotes no cache do seu sistema:

```console
$ dart pub cache repair
```

Este comando pode ser útil quando os pacotes no seu cache do sistema
são de alguma forma alterados ou quebrados.

Por exemplo, alguns editores facilitam a localização de arquivos de implementação
para pacotes no cache do sistema,
e você pode acidentalmente editar um desses arquivos.

## Limpando o cache global do sistema {:#clearing-the-global-system-cache}

Você pode esvaziar todo o cache do sistema
para recuperar espaço extra em disco ou remover pacotes problemáticos:

```console
$ dart pub cache clean
```

:::version-note
O subcomando `clean` foi introduzido no Dart 2.14.
Para limpar o cache do seu sistema com um SDK mais antigo,
você pode excluir manualmente a pasta [`PUB_CACHE`][].
:::

[`PUB_CACHE`]: /tools/pub/environment-variables

## Opções {:#options}

Para opções que se aplicam a todos os comandos pub, veja
[Opções globais](/tools/pub/cmd#global-options).

### `--all` {:#all}

Use `dart pub cache add --all`
para instalar todas as versões correspondentes de uma biblioteca.

### `--version` _`<restrição>`_ {:#version-constraint}

Use com `dart pub cache add`
para instalar a versão que melhor corresponde à restrição especificada.
Por exemplo:

```console
$ dart pub cache add http --version "0.12.2"
```

Se `--version` for omitido, o pub instala a melhor de todas as versões conhecidas.


{% render 'pub-problems.md' %}