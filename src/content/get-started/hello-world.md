---
ia-translate: true
title: Seu primeiro programa Dart
shortTitle: Seu primeiro aplicativo
description: >-
  Crie, execute e faça sua primeira alteração em um programa de linha de comando Dart.
sitemap: false
noindex: true
layout: learn
prevpage:
  url: /get-started
  title: Começar
nextpage:
  url: /get-started/add-commands
  title: Adicione interatividade ao seu aplicativo
---

{% render 'fwe-wip-warning.md', site: site %}

Bem-vindo ao Dart!
Neste capítulo, você garantirá que sua configuração está completa e
então trabalhará criando seu primeiro programa Dart.
Este capítulo começa simples, mas avança rápido!

:::secondary O que você aprenderá

* Confirmar a instalação do Dart SDK.
* Usar `dart create` para gerar um novo projeto de interface de linha de comando (CLI).
* Executar seu programa Dart pelo terminal usando `dart run`.
* Identificar a função `main` como o ponto de entrada do programa.
* Fazer sua primeira alteração de código e ver a saída atualizada.

:::

## Pré-requisitos

Antes de começar este capítulo, certifique-se de:

* [Instalar o Dart SDK](/get-dart).
* Revisar a [visão geral do Dart](/overview) (se você é novo no Dart).

## Tarefas

Crie o clássico Hello World em Dart para começar seu projeto.

### Tarefa 1: Confirme sua configuração do Dart

Primeiro, certifique-se de que o Dart está pronto para uso no seu sistema seguindo estes passos.

1.  Abra um terminal (ou prompt de comando).

2.  Execute o seguinte comando para verificar a versão do seu Dart SDK:

    ```bash
    dart --version
    ```

3.  Certifique-se de ver uma saída semelhante a esta
    (os números de versão podem ser diferentes):

    ```bash
    Dart SDK version: 3.9.2 (stable) (Wed Aug 27 03:49:40 2025 -0700) on "linux_x64"
    ```

    Se você ver um erro como "command not found", consulte o
    [guia de instalação do Dart](/get-dart) para configurar seu ambiente.

### Tarefa 2: Crie um novo projeto Dart

Agora, crie seu primeiro aplicativo de linha de comando Dart.

1.  No mesmo terminal,
    crie um novo diretório chamado `dartpedia` para guardar seu projeto.
    Então mude para esse diretório.

    ```bash
    mkdir dartpedia
    cd dartpedia
    ```

1.  Execute o seguinte comando:

    ```bash
    dart create cli
    ```

    O comando `dart create` gera um projeto básico Dart chamado
    "cli" (para Command Line Interface).
    Ele configura os arquivos e diretórios essenciais que você precisa.

1.  Você deve ver uma saída semelhante a esta, confirmando a criação do projeto:

    ```bash
    Creating cli using template console...

      .gitignore
      analysis_options.yaml
      CHANGELOG.md
      pubspec.yaml
      README.md
      bin/cli.dart
      lib/cli.dart
      test/cli_test.dart

    Running pub get...                     1.2s
      Resolving dependencies...
      Downloading packages...
      Changed 49 dependencies!

    Created project cli in cli! In order to get started, run the following commands:

      cd cli
      dart run
    ```

    :::note
    O comando `dart create` criou vários arquivos.
    Não se preocupe com eles agora.
    Seus detalhes serão cobertos em capítulos futuros.
    :::

### Tarefa 3: Execute seu primeiro programa Dart

Agora, execute seu programa para testá-lo.

1.  No terminal, navegue para o diretório do seu novo projeto:

    ```bash
    cd cli
    ```

1.  Execute o aplicativo padrão:

    ```bash
    dart run
    ```

    Este comando diz ao Dart para executar seu programa.

1.  Você deve ver a seguinte saída:

    ```bash
    Building package executable...
    Built cli:cli.
    Hello world: 42!
    ```

    Parabéns! Você executou com sucesso seu primeiro programa Dart!

### Tarefa 4: Faça sua primeira alteração de código

Agora, modifique o código que gerou `Hello world: 42!`.

1.  Em um editor de código, abra o arquivo `bin/cli.dart`.

    O diretório `bin/` é onde seu código executável fica.
    `cli.dart` é o ponto de entrada do seu aplicativo.

    Dentro, você verá a função `main`.
    Todo programa Dart [começa executando a partir de sua função `main`](/language#hello-world).

1.  Verifique se o seu `bin/cli.dart` se parece com isso:

    ```dart title="bin/cli.dart"
    import 'package:cli/cli.dart' as cli;

    void main(List<String> arguments) {
      print('Hello world: ${cli.calculate()}!');
    }
    ```

1.  Simplifique a saída por enquanto.
    Delete a primeira linha (você não precisa desta declaração import), e altere a
    instrução `print` para exibir uma saudação simples:

    ```dart title="bin/cli.dart" highlightLines=1,4
    import 'package:cli/cli.dart' as cli; // Delete this entire line

    void main(List<String> arguments) {
      print('Hello, Dart!'); // Change this line
    }
    ```

2.  Salve seu arquivo. Então no terminal, execute seu programa novamente:

    ```bash
    dart run
    ```

3.  Verifique se você vê o seguinte:

    ```bash
    Building package executable...
    Built cli:cli.
    Hello, Dart!
    ```

    Você modificou e re-executou com sucesso seu primeiro programa Dart!

## Revisão

Nesta lição, você:

* Verificou a instalação do Dart SDK.
* Usou `dart create` para gerar um novo projeto CLI.
* Executou seu programa Dart pelo terminal usando `dart run`.
* Identificou a função `main` como o
  ponto de entrada do programa dentro de `bin/cli.dart`.
* Fez sua primeira alteração de código e viu a saída atualizada.

## Quiz

Aqui está um quiz rápido para solidificar seu aprendizado.

:::note
Você verá esses quizzes ao longo deste tutorial.
Fique à vontade para pulá-los se quiser.
:::

Qual comando é usado para criar um novo projeto Dart a partir de um template?

* A) `dart new`
* B) `dart build`
* C) `dart create`
* D) `dart init`

## Próxima lição

Na próxima lição, você aprenderá como
fazer seu programa responder a comandos específicos
introduzindo argumentos de linha de comando e a keyword `const`.
