---
ia-translate: true
title: dart create
description: Ferramenta de linha de comando para criar projetos Dart.
toc: false
---

O comando `dart create` cria um projeto Dart,
usando um dos vários templates (modelos) suportados.
A mesma funcionalidade está disponível em IDEs.

{% render 'tools/dart-tool-note.md' %}

Quando você executa `dart create`, ele primeiro cria um diretório com os arquivos do projeto.
Em seguida, ele obtém as dependências do pacote (a menos que você especifique a flag `--no-pub`).

Aqui está um exemplo de como usar `dart create` para criar um diretório chamado `my_cli`
que contém um aplicativo de console simples (o template padrão):

```console
$ dart create my_cli
```

Para usar um template diferente, como `web`, adicione um argumento de template:

```console
$ dart create -t web my_web_app
```

A tabela a seguir mostra os templates que você pode usar:

| Template       | Descrição                                                                                                 |
|----------------|-----------------------------------------------------------------------------------------------------------|
| `cli`          | Um aplicativo de linha de comando com análise básica de argumentos usando [`package:args`]({{site.pub-pkg}}/args). |
| `console`      | Um aplicativo de linha de comando.                                                                         |
| `package`      | Um pacote contendo bibliotecas Dart compartilhadas.                                                        |
| `server-shelf` | Um servidor construído usando [shelf][].                                                                  |
| `web`          | Um aplicativo web construído usando bibliotecas Dart (core).                                                  |

{:.table .table-striped .nowrap}

[shelf]: {{site.pub-pkg}}/shelf

Esses templates resultam em uma estrutura de arquivos que segue as
[convenções de layout de pacote](/tools/pub/package-layout).

Se o diretório especificado já existir, `dart create` falha.
Você pode forçar a geração do projeto com a flag `--force`:

```console
$ dart create --force <DIRETÓRIO>
```

Para mais informações sobre as opções de linha de comando, use a flag `--help`:

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
