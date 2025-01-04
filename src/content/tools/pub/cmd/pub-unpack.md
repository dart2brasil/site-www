---
ia-translate: true
title: dart pub unpack
description: Baixa um pacote e descompacta seu conteúdo localmente.
---

:::version-note
O subcomando `unpack` foi introduzido no Dart 3.4.
Para baixar o arquivo de um pacote com um SDK anterior,
visite a aba **Versions** de um pacote no [site pub.dev]({{site.pub}}).
:::

_Unpack_ (Descompactar) é um dos comandos da [ferramenta pub](/tools/pub/cmd).

```plaintext
$ dart pub unpack <pacote>[:descritor] [--[no-]resolve] [--output=<diretório de saída>] [--[no-]force] [outras opções]
```

Este comando baixa o `<pacote>` especificado e
extrai seu conteúdo para um diretório `<pacote>-<versão>`.

Por exemplo, o seguinte comando baixa e extrai a
versão estável mais recente de `package:http` do [site pub.dev]({{site.pub}}),
para o diretório atual:

```console
$ dart pub unpack http
```

Para alterar a fonte ou versão do pacote baixado,
adicione um descritor de fonte após o nome do pacote e dois pontos.
Por exemplo, o seguinte comando baixa a versão `1.2.0`
de `package:http` do site pub.dev:

```console
$ dart pub unpack http:1.2.0
```

O descritor de fonte suporta mais configurações
com a mesma sintaxe de `dart pub add`.
Para saber mais sobre descritores de fonte e sua sintaxe, consulte a
documentação de [descritor de fonte][] para `dart pub add`.

[descritor de fonte]: /tools/pub/cmd/pub-add#source-descriptor

## Opções {:#options}

Para opções que se aplicam a todos os comandos pub, consulte
[Opções globais](/tools/pub/cmd#global-options).

### `--force` ou `-f` {:#force-option}

Sobrescreve pastas existentes que conflitam
com a pasta do pacote ou seu conteúdo durante a extração.

### `--[no-]resolve` {:#resolve-option}

Por padrão, `dart pub get` é executado automaticamente para completar
a resolução de pacotes após baixar e descompactar um pacote.
Para desativar a resolução automática,
especifique a flag `--no-resolve`:

```console
$ dart pub unpack http --no-resolve
```

### `--output=<dir>` ou `-o <dir>` {:#output-option}

Por padrão, extrai o pacote para o diretório atual (`.`).
Para alterar o diretório para o qual o pacote é extraído,
especifique o diretório de saída desejado com a opção `--output`.

Por exemplo, os seguintes comandos descompactam a
versão `1.2.0` de `package:http` para o diretório `local_http_copies`.

```console
$ dart pub unpack http:1.2.0 -o local_http_copies
```


{% render 'pub-problems.md' %}