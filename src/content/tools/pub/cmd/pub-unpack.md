---
title: dart pub unpack
description: Baixa um pacote e desempacota seu conteúdo no local.
ia-translate: true
---

:::version-note
O subcomando `unpack` foi introduzido no Dart 3.4.
Para baixar o arquivo de um pacote com um SDK anterior,
visite a guia **Versions** de um pacote no [site pub.dev]({{site.pub}}).
:::

_Unpack_ é um dos comandos da [ferramenta pub](/tools/pub/cmd).

```plaintext
$ dart pub unpack <package>[:descriptor] [--[no-]resolve] [--output=<output directory>] [--[no-]force] [other options]
```

Este comando baixa o `<package>` especificado e
extrai seu conteúdo para um diretório `<package>-<version>`.

Por exemplo, o seguinte comando baixa e extrai a
versão estável mais recente de `package:http` do [site pub.dev]({{site.pub}}),
para o diretório atual:

```console
$ dart pub unpack http
```

Para alterar a origem ou versão do pacote baixado,
adicione um descritor de fonte após o nome do pacote e um dois-pontos.
Por exemplo, o seguinte comando baixa a versão `1.2.0`
de `package:http` do site pub.dev:

```console
$ dart pub unpack http:1.2.0
```

O descritor de fonte oferece mais configuração
com a mesma sintaxe de `dart pub add`.
Para saber mais sobre descritores de fonte e sua sintaxe, consulte
a documentação de [descritor de fonte][] para `dart pub add`.

[descritor de fonte]: /tools/pub/cmd/pub-add#source-descriptor

## Opções

Para opções que se aplicam a todos os comandos pub, consulte
[Opções globais](/tools/pub/cmd#global-options).

### `--force` ou `-f` {:#force-option}

Sobrescreva pastas existentes que conflitem
com a pasta do pacote ou seu conteúdo durante a extração.

### `--[no-]resolve` {:#resolve-option}

Por padrão, `dart pub get` é executado automaticamente para completar
a resolução do pacote após baixar e desempacotar um pacote.
Para desabilitar a resolução automática,
especifique o sinalizador `--no-resolve`:

```console
$ dart pub unpack http --no-resolve
```

### `--output=<dir>` ou `-o <dir>` {:#output-option}

Por padrão, extraia o pacote para o diretório atual (`.`).
Para alterar o diretório para o qual o pacote é extraído,
especifique o diretório de saída desejado com a opção `--output`.

Por exemplo, os seguintes comandos desempacotam a
versão `1.2.0` de `package:http` para o diretório `local_http_copies`.

```console
$ dart pub unpack http:1.2.0 -o local_http_copies
```


{% render 'pub-problems.md' %}
