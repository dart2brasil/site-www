---
ia-translate: true
title: Crie seu primeiro aplicativo
shortTitle: Seu primeiro aplicativo
description: >-
  Crie, execute e faça sua primeira alteração em um programa de linha de comando Dart.
layout: learn
---

<YoutubeEmbed id="ulg4bjQQJi0" title="O que é Dart?" fullWidth="true"></YoutubeEmbed>

Bem-vindo ao Dart! Neste capítulo, você vai
garantir que sua configuração está completa e depois
criar seu primeiro programa Dart.
Este capítulo começa simples, mas avança rápido!

<SummaryCard>
title: O que você vai realizar
items:
  - title: Verificar a instalação do Dart SDK
    icon: check_circle
  - title: Criar um projeto CLI com dart create
    icon: terminal
  - title: Executar e modificar seu primeiro programa
    icon: play_arrow
</SummaryCard>

## Pré-requisitos {:#prerequisites}

Antes de começar este capítulo, certifique-se de:

- [Ter instalado o Dart SDK](/get-dart).
- Ter lido a [visão geral do Dart](/overview) (se você é novo no Dart).

## Tarefas {:#tasks}

Crie o clássico Hello World em Dart para começar seu projeto.

### Tarefa 1: Confirme sua configuração do Dart

Primeiro, certifique-se de que o Dart está pronto para uso no seu sistema seguindo estes passos.

1.  Abra um terminal (ou prompt de comando).

1.  Execute o seguinte comando para verificar a versão do seu Dart SDK:

    ```bash
    dart --version
    ```

1.  Verifique se você vê uma saída parecida com esta
    (os números da versão podem ser diferentes):

    ```bash
    Dart SDK version: 3.9.2 (stable) (Wed Aug 27 03:49:40 2025 -0700) on "linux_x64"
    ```

    Se você vir um erro como "command not found", consulte o
    [guia de instalação do Dart][Dart installation guide] para configurar seu ambiente.

[Dart installation guide]: /get-dart

### Tarefa 2: Crie um novo projeto Dart

Agora, crie seu primeiro aplicativo de linha de comando em Dart.

1.  No mesmo terminal,
    crie um diretório chamado `dartpedia` para guardar seu projeto.
    Depois, entre nesse diretório.

    ```bash
    mkdir dartpedia
    cd dartpedia
    ```

1.  Execute o seguinte comando:

    ```bash
    dart create cli
    ```

    O comando `dart create` gera um projeto Dart básico chamado
    "cli" (de Command Line Interface, ou interface de linha de comando).
    Ele cria os arquivos e diretórios essenciais de que você precisa.

1.  Você deve ver uma saída parecida com esta, confirmando a criação do projeto:

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
    Seus detalhes serão abordados em capítulos futuros.
    :::

### Tarefa 3: Execute seu primeiro programa Dart

Agora, execute seu programa para testá-lo.

1.  No terminal, entre no diretório do seu novo projeto:

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

Agora, modifique o código que gera `Hello world: 42!`.

1.  Em um editor de código, abra o arquivo `bin/cli.dart`.

    O diretório `bin/` é onde fica o seu código executável.
    `cli.dart` é o ponto de entrada da sua aplicação.

    Dentro dele, você verá a função `main`.
    Todo programa Dart começa a executar a partir da sua função `main`.

    :::note
    Se você vem do Flutter ou da extensão Flutter para o VS Code,
    pode estar acostumado a usar `lib/main.dart` como ponto de entrada.
    Em aplicativos CLI padrão do Dart,
    os pontos de entrada executáveis ficam no diretório `bin/`.
    :::

1.  Verifique se o seu `bin/cli.dart` se parece com isto:

    ```dart title="bin/cli.dart"
    import 'package:cli/cli.dart' as cli;

    void main(List<String> arguments) {
      print('Hello world: ${cli.calculate()}!');
    }
    ```

1.  Simplifique a saída por enquanto.
    Apague a primeira linha (você não precisa desta instrução import) e
    altere a instrução `print` para exibir uma saudação simples:

    ```dart title="bin/cli.dart" highlightLines=1,4
    import 'package:cli/cli.dart' as cli; // Delete this entire line

    void main(List<String> arguments) {
      print('Hello, Dart!'); // Change this line
    }
    ```

1.  Salve seu arquivo. Depois, no terminal, execute o programa novamente:

    ```bash
    dart run
    ```

1.  Verifique se você vê o seguinte:

    ```bash
    Building package executable...
    Built cli:cli.
    Hello, Dart!
    ```

    Você modificou e executou novamente seu primeiro programa Dart com sucesso!

## Revisão {:#review}

<SummaryCard>
title: O que você realizou
subtitle: Veja um resumo do que você construiu e aprendeu nesta lição.
completed: true
items:
  - title: Verificou a instalação do Dart SDK
    icon: check_circle
    details: >-
      Você executou `dart --version` para confirmar que o Dart está instalado
      corretamente e acessível pelo terminal.
  - title: Criou seu primeiro projeto CLI
    icon: terminal
    details: >-
      Você usou `dart create` para gerar um novo aplicativo de linha de comando.
      Esse comando monta um projeto básico com
      arquivos essenciais como `pubspec.yaml`.
      Ele também gera um arquivo `bin/cli.dart` com uma função `main`
      que atua como ponto de entrada do seu programa.
  - title: Executou e modificou seu programa
    icon: play_arrow
    details: >-
      Você executou seu app com `dart run` e viu a saída "Hello world".
      Depois, modificou a função `main` para imprimir uma saudação personalizada,
      experimentando na prática o ciclo de editar e executar do Dart.
</SummaryCard>

## Quiz {:#quiz}

Aqui vai um quiz rápido para fixar o que você aprendeu.

:::note
Você vai encontrar esses quizzes ao longo deste tutorial.
Fique à vontade para pulá-los se quiser.
:::

<Quiz title="Confira seu entendimento" id="first-app" />

## Próxima lição {:#next-lesson}

Na próxima lição, você vai aprender como
fazer seu programa responder a comandos específicos,
apresentando argumentos de linha de comando e a keyword `const`.
