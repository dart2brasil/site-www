---
ia-translate: true
title: dart create
description: Ferramenta de linha de comando para criar projetos Dart.
showToc: false
---

Este guia descreve como usar o comando `dart create` para
criar um projeto Dart.

## Visão geral

O comando `dart create` cria um projeto Dart,
usando um dos vários templates suportados.
A mesma funcionalidade está disponível em IDEs.

{% render 'tools/dart-tool-note.md' %}

Quando você executa `dart create`, ele primeiro cria um diretório com os
arquivos do projeto. Em seguida, obtém as dependências do pacote
(a menos que você especifique a flag `--no-pub`).

## Criar um projeto Dart básico

Para criar um projeto Dart básico, siga o comando `dart create`
com o nome do seu projeto. No exemplo a seguir,
um diretório chamado `my_cli` que contém um
aplicativo de console simples (o template padrão) é criado:

```console
$ dart create my_cli
```

## Especificar um template

Para usar um template diferente, use a flag `-t` (ou `--template`)
seguida do nome do template:

```console
$ dart create -t web my_web_app
```

A flag `-t` permite que você especifique qual tipo de projeto Dart
você deseja criar. Se você não especificar um template, `dart create`
usa o template `console` por padrão.

## Templates disponíveis

A tabela a seguir mostra os templates que você pode usar com a
flag `-t`:

| Template       | Descrição                                                                                           |
|----------------|-----------------------------------------------------------------------------------------------------|
| `cli`          | Uma aplicação de linha de comando com análise básica de argumentos usando [`package:args`]({{site.pub-pkg}}/args). |
| `console`      | Uma aplicação de linha de comando (template padrão).                                                       |
| `package`      | Um pacote contendo bibliotecas Dart compartilhadas.                                                           |
| `server-shelf` | Um servidor construído usando [shelf][].                                                                       |
| `web`          | Um aplicativo web construído usando bibliotecas principais do Dart.                                                            |

{:.table .table-striped .nowrap}

[shelf]: {{site.pub-pkg}}/shelf

Esses templates resultam em uma estrutura de arquivos que segue
[convenções de layout de pacote](/tools/pub/package-layout).

## Opções adicionais

Adicionalmente, você pode realizar as seguintes ações com
o comando `dart create`.

### Forçar criação de projeto

Se o diretório especificado já existir, `dart create` falha.
Você pode forçar a geração do projeto com a flag `--force`:

```console
$ dart create --force <DIRECTORY>
```

### Obter ajuda

Para mais informações sobre opções de linha de comando, use a flag `--help`:

```console
$ dart create --help
```

{% comment %}
```
Create a new Dart project.

Usage: dart create [arguments] <directory>
-h, --help                       Print this usage information.
-t, --template                   The project template to use.

          [console] (default)    A command-line application.
          [package]              A package containing shared Dart libraries.
          [server-shelf]         A server app using `package:shelf`
          [web]                  A web app that uses only core Dart libraries.

    --[no-]pub                   Whether to run 'pub get' after the project has been created.
                                 (defaults to on)
    --force                      Force project generation, even if the target directory already exists.
```

{% endcomment %}
