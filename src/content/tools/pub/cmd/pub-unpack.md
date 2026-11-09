---
ia-translate: true
title: dart pub unpack
description: Baixa um pacote e descompacta seu conteúdo no próprio lugar.
---

:::version-note
O subcomando `unpack` foi introduzido no Dart 3.4.
Para baixar o arquivo de um pacote com um SDK anterior,
acesse a aba **Versions** de um pacote no [site pub.dev]({{site.pub}}).
:::

_Unpack_ é um dos comandos da [ferramenta pub](/tools/pub/cmd).

```plaintext
$ dart pub unpack <package>[:<descriptor>] [--[no-]resolve] [--output=<output directory>] [--[no-]force] [other options]
```

Este comando baixa o `<package>` especificado e
extrai o seu conteúdo para um diretório `<package>-<version>`.

Por exemplo, o comando a seguir baixa e extrai a
versão estável mais recente do `package:http` do [site pub.dev]({{site.pub}}),
para o diretório atual:

```console
$ dart pub unpack http
```

Para mudar a fonte ou a versão do pacote baixado,
adicione um [descritor de pacote][package descriptor] depois do nome do pacote e de dois-pontos.
Por exemplo, o comando a seguir baixa a versão `1.2.0`
do `package:http` do site pub.dev:

```console
$ dart pub unpack http:1.2.0
```

Para saber mais sobre como configurar a fonte da dependência,
consulte a documentação sobre [descritores de pacote][package descriptor].

[package descriptor]: /tools/pub/dependencies#package-descriptors

## Opções {:#options}

Para opções que se aplicam a todos os comandos do pub, veja
[Opções globais](/tools/pub/cmd#global-options).

### `--force` ou `-f` {:#force-option}

Sobrescreve pastas existentes que conflitam
com a pasta do pacote ou com o seu conteúdo durante a extração.

### `--[no-]resolve` {:#resolve-option}

Por padrão, `dart pub get` é executado automaticamente para concluir
a resolução do pacote depois de baixar e descompactar um pacote.
Para desativar a resolução automática,
especifique a flag `--no-resolve`:

```console
$ dart pub unpack http --no-resolve
```

### `--output=<dir>` ou `-o <dir>` {:#output-option}

Por padrão, o pacote é extraído para o diretório atual (`.`).
Para mudar o diretório em que o pacote é extraído,
especifique o diretório de saída desejado com a opção `--output`.

Por exemplo, o comando a seguir descompacta a
versão `1.2.0` do `package:http` no diretório `local_http_copies`.

```console
$ dart pub unpack http:1.2.0 -o local_http_copies
```


{% render 'pub-problems.md' %}
