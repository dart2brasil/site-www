---
ia-translate: true
title: Organizando código Dart com pacotes e bibliotecas
shortTitle: Pacotes e bibliotecas
description: >-
  Aprenda como organizar seu código Dart em bibliotecas e pacotes reutilizáveis.
sitemap: false
noindex: true
layout: learn
prevpage:
  url: /get-started/async
  title: Introdução a async e HTTP
nextpage:
  url: /get-started
  title: Dart orientado a objetos
---

{% render 'fwe-wip-warning.md', site: site %}

Neste capítulo, você avançará da sintaxe básica do Dart para construir aplicações de linha de
comando "do jeito Dart", abraçando as melhores práticas. Você aprenderá a refatorar
seu código em componentes reutilizáveis criando um pacote dedicado para lidar com
argumentos de linha de comando. Este passo prepara você para construir um aplicativo de linha de
comando mais avançado em capítulos futuros, que integrará pacotes especializados
para lógica da Wikipedia e um framework robusto de `command_runner`. Este
capítulo ajuda você a entender bibliotecas Dart, declarações export, e como
estruturar seu projeto para melhor organização e manutenibilidade.

:::secondary O que você aprenderá

* Criar novos pacotes Dart usando `dart create -t package`.
* Estruturar seu projeto para incluir pacotes locais.
* Adicionar pacotes locais como dependências usando a opção `path` no `pubspec.yaml`.
* Usar declarações `export` para tornar declarações de biblioteca disponíveis para outros
  pacotes.
* Importar e usar classes do seu novo pacote no seu aplicativo `dartpedia`.
* Reconhecer os benefícios de separar código em pacotes.

:::

## Pré-requisitos

* Conclusão do Capítulo 3, que cobriu programação assíncrona e requisições
  HTTP.

## Tarefas

Neste capítulo, você refatorará o aplicativo CLI `dartpedia` existente
extraindo a lógica de análise de argumentos de linha de comando em um pacote separado
chamado `command_runner`. Isso melhorará a estrutura do seu projeto, tornando-o
mais modular e manutenível.

:::note
Existe uma classe `command_runner` que faz parte do
[pacote `args`]({{site.pub-pkg}}/args) oficialmente mantido. Para este tutorial estamos
construindo nossa própria classe `command_runner`, mas em um projeto real você provavelmente
usaria a classe de `args`.
:::

### Tarefa 1: Criar o pacote command_runner

Primeiro, crie um novo pacote Dart para abrigar a lógica de análise de argumentos
de linha de comando.

1.  Navegue até o diretório raiz do seu projeto (`/dartpedia`).

1.  Execute o seguinte comando no seu terminal:

    ```bash
    dart create -t package command_runner
    ```

    Este comando cria um novo diretório chamado `command_runner` com a estrutura básica
    de um pacote Dart. Você deve ver agora uma nova pasta
    `command_runner` na raiz do seu projeto, ao lado de `cli`.

### Tarefa 2: Implementar a classe CommandRunner

Agora que você criou o pacote `command_runner`, adicione uma
classe de espaço reservado que eventualmente lidará com a lógica de análise de argumentos
de linha de comando.

1.  Abra o arquivo `command_runner/lib/command_runner.dart`. Remova qualquer código
    de espaço reservado existente e adicione o seguinte:

    ```dart
    /// A simple command runner to handle command-line arguments.
    ///
    /// More extensive documentation for this library goes here.
    library;

    export 'src/command_runner_base.dart';
    // TODO: Export any other libraries intended for clients of this package.
    ```

    Destaques do código anterior:

    * `library;` declara este arquivo como uma biblioteca, que ajuda a definir os
      limites e a interface pública de uma unidade reutilizável de código Dart.
    * `export 'src/command_runner_base.dart';` é uma linha crucial que torna
      declarações de `command_runner_base.dart` disponíveis para outros pacotes
      que importam o pacote `command_runner`. Sem esta declaração `export`,
      as classes e funções dentro de `command_runner_base.dart` seriam
      privadas ao pacote `command_runner`, e você não seria capaz de usá-las
      no seu aplicativo `dartpedia`.

1.  Abra o arquivo `command_runner/lib/src/command_runner_base.dart`.

1.  Remova qualquer código de espaço reservado existente e adicione a seguinte classe
    `CommandRunner` a `command_runner/lib/src/command_runner_base.dart`:

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
      método `run` atualmente apenas imprime os argumentos que recebe. Em capítulos
      posteriores, você expandirá esta classe para lidar com análise complexa de comandos.
    * `Future<void>` é um tipo de retorno que indica que este método pode executar
      operações assíncronas, mas não retorna um valor.

### Tarefa 3: Adicionar `command_runner` como uma dependência

Agora que você criou o pacote `command_runner` e adicionou uma classe
`CommandRunner` de espaço reservado, você precisa dizer ao seu aplicativo `cli` que ele depende
de `command_runner`. Como o pacote `command_runner` está localizado localmente
dentro do seu projeto, use a opção de dependência `path`.

1.  Abra o arquivo `cli/pubspec.yaml`.

1.  Localize a seção `dependencies`. Adicione as seguintes linhas:

    :::note
    Certifique-se de abrir o arquivo correto `/dartpedia/cli/pubspec.yaml`. Quando você
    criou o pacote `command_runner`, ele também veio com um
    arquivo `/dartpedia/command_runner/pubspec.yaml`.
    :::

    ```yaml
    dependencies:
      http: ^1.3.0 # Keep your existing http dependency
      command_runner:
        path: ../command_runner # Points to your local command_runner package
    ```

    Esta seção diz ao aplicativo `cli` para depender do
    pacote `command_runner`, e especifica que o pacote está localizado no
    diretório `../command_runner` (relativo ao diretório `cli`).

2.  Execute `dart pub get` no diretório `/dartpedia/cli` do seu terminal para
    buscar a nova dependência.

### Tarefa 4: Importar e usar o pacote `command_runner`

Agora que você adicionou `command_runner` como uma dependência, você pode importá-lo no
seu aplicativo `cli` e substituir sua lógica existente de tratamento de argumentos com
a nova classe `CommandRunner`. Esta etapa também corrige o comportamento de saída do programa
discutido no final do Capítulo 3.

1.  Abra o arquivo `cli/bin/cli.dart`.

1.  Adicione a seguinte declaração import no topo do arquivo, junto com
    seus outros imports:

    ```dart
    import 'package:command_runner/command_runner.dart';
    ```

    Esta declaração importa o pacote `command_runner`, tornando a classe `CommandRunner`
    disponível para uso.

1.  **Refatorar a função `main` e remover a lógica antiga:**
    Atualmente, sua função `main` do Capítulo 3 lida diretamente com comandos
    como `version`, `help` e `wikipedia`, e então chama `searchWikipedia`.
    Você agora substituirá toda essa lógica personalizada de tratamento de comandos com uma única
    chamada para a nova classe `CommandRunner`.

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

    **Agora, substitua todo o conteúdo de `cli/bin/cli.dart` (exceto o import `http`) pela seguinte versão atualizada:**

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
      o problema de programa não saindo limpo do Capítulo 3.
      Observe que `main` agora é declarada `async`. Isso é essencial porque
      `runner.run()` retorna um `Future`, e `main` deve `await` sua conclusão
      para garantir que o programa aguarde todas as tarefas assíncronas terminarem antes de sair.
    * `var runner = CommandRunner();` cria uma instância da
      classe `CommandRunner` do seu novo pacote `command_runner`.
    * `await runner.run(arguments);` chama o método `run` na
      instância `CommandRunner`, passando os argumentos de linha de comando.

    Funções Removidas:

    As funções `printUsage`, `searchWikipedia` e
    `getWikipediaArticle` agora estão completamente removidas de
    `cli/bin/cli.dart`. Sua lógica será redesenhada e movida para o
    pacote `command_runner` em capítulos futuros, como parte da construção do
    framework completo de linha de comando.

### Tarefa 5: Executar o aplicativo

Agora que você refatorou o código e atualizou o aplicativo `cli` para usar o
pacote `command_runner`, execute o aplicativo para verificar que tudo
está funcionando corretamente nesta etapa.

1.  Abra seu terminal e navegue até o diretório `cli`.

1.  Execute o comando `wikipedia`:

    ```bash
    dart run bin/cli.dart wikipedia Computer_programming
    ```

1.  Certifique-se de que o aplicativo agora executa sem erros e imprime os argumentos
    no console, demonstrando que o controle foi transferido com sucesso
    para o seu novo pacote `command_runner`.

    ```bash
    CommandRunner received arguments: [wikipedia, Computer_programming]
    ```

    :::important
    **Nota importante sobre funcionalidade:**
    Você notará que a funcionalidade de busca de artigo (do Capítulo 3) não está
    mais ativa. Isso é esperado! Neste capítulo, você refatorou a
    estrutura do projeto movendo a responsabilidade de tratamento de comandos. Os próximos
    capítulos focarão em reconstruir e melhorar essa lógica central do aplicativo
    dentro do pacote `command_runner`.
    :::

## Revisão

Neste capítulo, você aprendeu sobre:

* Criar pacotes Dart usando `dart create -t package`.
* Usar declarações `export` para tornar declarações de uma biblioteca disponíveis em
  outra.
* Adicionar pacotes locais como dependências usando a opção `path` no
  `pubspec.yaml`.
* Importar pacotes no seu código Dart usando declarações `import`.
* Refatorar código para melhorar organização e manutenibilidade, incluindo tornar
  `main` `async` para corretamente `await` operações assíncronas.

## Quiz

**Questão 1:** Qual é o propósito da declaração `export` em uma biblioteca Dart?

* A) Ocultar declarações de outras bibliotecas.
* B) Tornar declarações disponíveis para outras bibliotecas.
* C) Especificar a versão do Dart SDK requerida pela biblioteca.
* D) Definir o ponto de entrada da biblioteca.

**Questão 2:** Como você adiciona um pacote local como uma dependência no
`pubspec.yaml`?

* A) Especificando o nome do pacote e versão.
* B) Especificando o nome do pacote e o caminho para o pacote.
* C) Usando a opção `git` e especificando a URL do repositório Git.
* D) Usando a opção `hosted` e especificando a URL do servidor de pacotes.

## Próxima lição

No próximo capítulo, você mergulhará em conceitos de programação orientada a objetos (OOP)
no Dart. Você aprenderá como criar classes, definir relações de herança,
e construir um framework mais robusto de análise de argumentos de linha de comando usando princípios
OOP dentro do seu novo pacote `command_runner`.
