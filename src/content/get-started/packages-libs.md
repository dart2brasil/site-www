---
ia-translate: true
title: Organizando código Dart com packages e libraries
shortTitle: Packages e libraries
description: >-
  Aprenda como organizar seu código Dart em libraries e packages reutilizáveis.
sitemap: false
noindex: true
layout: learn
prevpage:
  url: /get-started/async
  title: Introduction to async and HTTP
nextpage:
  url: /get-started
  title: Object oriented dart
---

{% render 'fwe-wip-warning.md', site: site %}

Neste capítulo, você evoluirá da sintaxe básica do Dart para construir aplicativos de linha de comando
"da maneira Dart", abraçando as melhores práticas. Você aprenderá a refatorar
seu código em componentes reutilizáveis criando um package dedicado para lidar com
argumentos de linha de comando. Este passo o prepara para construir um aplicativo de linha de comando mais avançado
em capítulos futuros, que integrará packages especializados
para lógica da Wikipedia e um framework `command_runner` robusto. Este
capítulo o ajuda a entender libraries Dart, instruções export e como
estruturar seu projeto para melhor organização e manutenibilidade.

:::secondary O que você aprenderá

* Criar novos packages Dart usando `dart create -t package`.
* Estruturar seu projeto para incluir packages locais.
* Adicionar packages locais como dependências usando a opção `path` em `pubspec.yaml`.
* Usar instruções `export` para disponibilizar declarações de library para outros
  packages.
* Importar e usar classes do seu novo package em seu aplicativo `dartpedia`.
* Reconhecer os benefícios de separar código em packages.

:::

## Pré-requisitos

* Conclusão do Capítulo 3, que cobriu programação assíncrona e requisições
  HTTP.

## Tarefas

Neste capítulo, você refatorará o aplicativo CLI `dartpedia` existente
extraindo a lógica de análise de argumentos de linha de comando para um package separado
chamado `command_runner`. Isso melhorará a estrutura do seu projeto, tornando-o
mais modular e sustentável.

:::note
Existe uma classe `command_runner` que faz parte do
[package `args`]({{site.pub-pkg}}/args) oficialmente mantido. Para este tutorial estamos
construindo nossa própria classe `command_runner`, mas em um projeto real você provavelmente
usaria a classe do `args`.
:::

### Tarefa 1: Criar o package command_runner

Primeiro, crie um novo package Dart para abrigar a lógica de análise de argumentos
de linha de comando.

1.  Navegue até o diretório raiz do seu projeto (`/dartpedia`).

1.  Execute o seguinte comando no seu terminal:

    ```bash
    dart create -t package command_runner
    ```

    Este comando cria um novo diretório chamado `command_runner` com a estrutura
    básica de um package Dart. Agora você deve ver uma nova pasta
    `command_runner` na raiz do seu projeto, ao lado de `cli`.

### Tarefa 2: Implementar a classe CommandRunner

Agora que você criou o package `command_runner`, adicione uma
classe placeholder que eventualmente lidará com a lógica de análise de argumentos de linha de comando.

1.  Abra o arquivo `command_runner/lib/command_runner.dart`. Remova qualquer código
    placeholder existente e adicione o seguinte:

    ```dart
    /// A simple command runner to handle command-line arguments.
    ///
    /// More extensive documentation for this library goes here.
    library;

    export 'src/command_runner_base.dart';
    // TODO: Export any other libraries intended for clients of this package.
    ```

    Destaques do código anterior:

    * `library;` declara este arquivo como uma library, o que ajuda a definir os
      limites e a interface pública de uma unidade reutilizável de código Dart.
    * `export 'src/command_runner_base.dart';` é uma linha crucial que torna
      declarações de `command_runner_base.dart` disponíveis para outros packages
      que importam o package `command_runner`. Sem esta instrução `export`,
      as classes e funções dentro de `command_runner_base.dart` seriam
      privadas ao package `command_runner`, e você não seria capaz de usá-las
      em seu aplicativo `dartpedia`.

1.  Abra o arquivo `command_runner/lib/src/command_runner_base.dart`.

1.  Remova qualquer código placeholder existente e adicione a seguinte classe `CommandRunner`
    a `command_runner/lib/src/command_runner_base.dart`:

    ```dart
    class CommandRunner {
      /// Runs the command-line application logic with the given arguments.
      Future<void> run(List<String> input) async {
        print('CommandRunner received arguments: $input');
      }
    }
    ```

    Destaques do código anterior:

    * `CommandRunner` é uma classe que serve como um substituto simplificado por enquanto. Seu
      método `run` atualmente apenas imprime os argumentos que recebe. Em capítulos posteriores,
      você expandirá esta classe para lidar com análise de comandos complexa.
    * `Future<void>` é um tipo de retorno que indica que este método pode realizar
      operações assíncronas, mas não retorna um valor.

### Tarefa 3: Adicionar `command_runner` como uma dependência

Agora que você criou o package `command_runner` e adicionou uma classe
`CommandRunner` placeholder, você precisa informar ao seu aplicativo `cli` que ele depende
de `command_runner`. Como o package `command_runner` está localizado localmente
dentro do seu projeto, use a opção de dependência `path`.

1.  Abra o arquivo `cli/pubspec.yaml`.

1.  Localize a seção `dependencies`. Adicione as seguintes linhas:

    :::note
    Certifique-se de abrir o arquivo `/dartpedia/cli/pubspec.yaml` correto. Quando você
    criou o package `command_runner`, ele também veio com um
    arquivo `/dartpedia/command_runner/pubspec.yaml`.
    :::

    ```yaml
    dependencies:
      http: ^1.3.0 # Keep your existing http dependency
      command_runner:
        path: ../command_runner # Points to your local command_runner package
    ```

    Esta seção informa ao aplicativo `cli` para depender do
    package `command_runner`, e especifica que o package está localizado no
    diretório `../command_runner` (relativo ao diretório `cli`).

2.  Execute `dart pub get` no diretório `/dartpedia/cli` do seu terminal para
    buscar a nova dependência.

### Tarefa 4: Importar e usar o package `command_runner`

Agora que você adicionou `command_runner` como uma dependência, você pode importá-lo em
seu aplicativo `cli` e substituir sua lógica de tratamento de argumentos existente pela
nova classe `CommandRunner`. Este passo também corrige o comportamento de saída do programa
discutido no final do Capítulo 3.

1.  Abra o arquivo `cli/bin/cli.dart`.

1.  Adicione a seguinte instrução import no topo do arquivo, junto com
    suas outras importações:

    ```dart
    import 'package:command_runner/command_runner.dart';
    ```

    Esta instrução importa o package `command_runner`, tornando a classe `CommandRunner`
    disponível para uso.

1.  **Refatore a função `main` e remova a lógica antiga:**
    Atualmente, sua função `main` do Capítulo 3 lida diretamente com comandos
    como `version`, `help` e `wikipedia`, e então chama `searchWikipedia`.
    Você agora substituirá toda essa lógica de tratamento de comandos personalizada por uma única
    chamada à nova classe `CommandRunner`.

    **Seu arquivo `cli/bin/cli.dart` (do Capítulo 3) deve atualmente parecer com
    isto:**

    ```dart
    import 'dart:io';
    import 'package:http/http.dart' as http;
    import 'package:command_runner/command_runner.dart';

    const version = '0.0.1';

    void main(List<String> arguments) {
      if (arguments.isEmpty || arguments.first == 'help') {
        printUsage();
      } else if (arguments.first == 'version') {
        print('Dartpedia CLI version $version');
      } else if (arguments.first == 'wikipedia') {
        final inputArgs = arguments.length > 1 ? arguments.sublist(1) : null;
        searchWikipedia(inputArgs);
      } else {
        printUsage();
      }
    }

    void searchWikipedia(List<String>? arguments) async { /* ... existing logic ... */ }
    void printUsage() { /* ... existing logic ... */ }
    Future<String> getWikipediaArticle(String articleTitle) async { /* ... existing logic ... */ }
    ```

    **Agora, substitua todo o conteúdo de `cli/bin/cli.dart` (exceto pela importação `http`) pela seguinte versão atualizada:**

    ```dart
    import 'dart:io';
    import 'package:http/http.dart' as http;
    import 'package:command_runner/command_runner.dart';

    void main(List<String> arguments) async { // main is now async and awaits the runner
      var runner = CommandRunner(); // Create an instance of your new CommandRunner
      await runner.run(arguments); // Call its run method, awaiting its Future<void>
    }
    ```

    Destaques do código anterior:

    * `void main(List<String> arguments) async` aborda diretamente
      o problema de o programa não sair corretamente do Capítulo 3.
      Observe que `main` agora é declarado `async`. Isso é essencial porque
      `runner.run()` retorna um `Future`, e `main` deve aguardar (`await`) sua conclusão
      para garantir que o programa aguarde todas as tarefas assíncronas terminarem antes de sair.
    * `var runner = CommandRunner();` cria uma instância da
      classe `CommandRunner` do seu novo package `command_runner`.
    * `await runner.run(arguments);` chama o método `run` na instância
      `CommandRunner`, passando os argumentos de linha de comando.

    Funções Removidas:

    As funções `printUsage`, `searchWikipedia` e
    `getWikipediaArticle` agora são completamente removidas de
    `cli/bin/cli.dart`. Sua lógica será redesenhada e movida para o
    package `command_runner` em capítulos futuros, como parte da construção do framework completo
    de linha de comando.

### Tarefa 5: Executar o aplicativo

Agora que você refatorou o código e atualizou o aplicativo `cli` para usar o
package `command_runner`, execute o aplicativo para verificar se tudo
está funcionando corretamente neste estágio.

1.  Abra seu terminal e navegue até o diretório `cli`.

1.  Execute o comando `wikipedia`:

    ```bash
    dart run bin/cli.dart wikipedia Computer_programming
    ```

1.  Certifique-se de que o aplicativo agora seja executado sem erros e imprima os argumentos
    no console, demonstrando que o controle foi transferido com sucesso
    para seu novo package `command_runner`.

    ```bash
    CommandRunner received arguments: [wikipedia, Computer_programming]
    ```

    :::important
    **Nota importante sobre funcionalidade:**
    Você notará que a funcionalidade de busca de artigos (do Capítulo 3) não está
    mais ativa. Isso é esperado! Neste capítulo, você refatorou a
    estrutura do projeto movendo a responsabilidade de tratamento de comandos. Os próximos
    capítulos se concentrarão em reconstruir e aprimorar essa lógica principal do aplicativo
    dentro do package `command_runner`.
    :::

## Revisão

Neste capítulo, você aprendeu sobre:

* Criar packages Dart usando `dart create -t package`.
* Usar instruções `export` para disponibilizar declarações de uma library em
  outra.
* Adicionar packages locais como dependências usando a opção `path` em
  `pubspec.yaml`.
* Importar packages em seu código Dart usando instruções `import`.
* Refatorar código para melhorar a organização e manutenibilidade, incluindo tornar
  `main` `async` para aguardar (`await`) corretamente operações assíncronas.

## Quiz

**Pergunta 1:** Qual é o propósito da instrução `export` em uma library Dart?

* A) Para ocultar declarações de outras libraries.
* B) Para disponibilizar declarações para outras libraries.
* C) Para especificar a versão do Dart SDK exigida pela library.
* D) Para definir o ponto de entrada da library.

**Pergunta 2:** Como você adiciona um package local como uma dependência em
`pubspec.yaml`?

* A) Especificando o nome e a versão do package.
* B) Especificando o nome do package e o caminho para o package.
* C) Usando a opção `git` e especificando a URL do repositório Git.
* D) Usando a opção `hosted` e especificando a URL do servidor de packages.

## Próxima lição

No próximo capítulo, você mergulhará nos conceitos de programação orientada a objetos (OOP)
em Dart. Você aprenderá como criar classes, definir relações de herança,
e construir um framework de análise de argumentos de linha de comando mais robusto usando princípios
de OOP dentro do seu novo package `command_runner`.
