---
ia-translate: true
title: Organize o código Dart com pacotes e bibliotecas
shortTitle: Pacotes e bibliotecas
description: >-
  Aprenda a organizar seu código Dart em bibliotecas e pacotes reutilizáveis.
layout: learn
---

<YoutubeEmbed id="En5lVTdmZIY" title="The Dart platform" fullWidth="true"></YoutubeEmbed>

Neste capítulo, você vai evoluir da sintaxe básica do Dart para
criar aplicações de linha de comando "do jeito Dart", seguindo boas práticas.
Você vai aprender a refatorar seu código em componentes reutilizáveis
criando um pacote dedicado para tratar os argumentos de linha de comando.

Este passo prepara você para construir uma aplicação de linha de comando
mais avançada nos próximos capítulos,
que vão integrar pacotes especializados para a lógica da Wikipédia e
um framework `command_runner` robusto.
Este capítulo ajuda você a entender bibliotecas do Dart, instruções `export` e
como estruturar seu projeto para melhor organização e manutenibilidade.

<SummaryCard>
title: O que você vai realizar
items:
  - title: Crie um pacote Dart reutilizável
    icon: package_2
  - title: Use exports para definir uma API pública
    icon: export_notes
  - title: Adicione dependências de caminho local
    icon: folder_code
</SummaryCard>

## Pré-requisitos {:#prerequisites}

- Conclusão do Capítulo 3, que abordou programação assíncrona e
  requisições HTTP.

## Tarefas {:#tasks}

Neste capítulo, você vai refatorar a aplicação de linha de comando
`dartpedia` existente, extraindo a lógica de análise de argumentos
para um pacote separado chamado `command_runner`.
Isso vai melhorar a estrutura do projeto,
tornando-o mais modular e fácil de manter.

:::note
Existe uma classe `command_runner` que faz parte do pacote
[`args`]({{site.pub-pkg}}/args), mantido oficialmente.
Neste tutorial, estamos construindo nossa própria classe `command_runner`,
mas em um projeto real você provavelmente usaria a classe do pacote `args`.
:::

### Tarefa 1: Crie o pacote command_runner {:#task-1-create-the-command_runner-package}

Primeiro, crie um novo pacote Dart para abrigar
a lógica de análise de argumentos de linha de comando.

1.  Acesse o diretório raiz do seu projeto (`/dartpedia`).

1.  Execute o comando a seguir no seu terminal:

    ```bash
    dart create -t package command_runner
    ```

    Esse comando cria um novo diretório chamado `command_runner` com
    a estrutura básica de um pacote Dart.
    Agora você deve ver uma nova pasta `command_runner` na raiz do projeto,
    ao lado do seu pacote `cli`.

### Tarefa 2: Implemente a classe CommandRunner {:#task-2-implement-the-commandrunner-class}

Agora que você criou o pacote `command_runner`,
adicione uma classe provisória que, no futuro,
vai tratar a lógica de análise de argumentos de linha de comando.

1.  Abra o arquivo `command_runner/lib/command_runner.dart`.
    Remova qualquer código provisório existente e adicione o seguinte:

    ```dart title="command_runner/lib/command_runner.dart"
    /// A simple command runner to handle command-line arguments.
    ///
    /// More extensive documentation for this library goes here.
    library;

    export 'src/command_runner_base.dart';
    // TODO: Export any other libraries intended for clients of this package.
    ```

    Destaques do código anterior:

    - `library;` declara este arquivo como uma biblioteca,
      que define os limites e a interface pública de
      uma unidade reutilizável de código Dart.
    - `export 'src/command_runner_base.dart';` é uma linha crucial que
      torna as declarações de `command_runner_base.dart` disponíveis para
      outros pacotes que importam o pacote `command_runner`.
      Sem essa instrução `export`, as classes e funções
      dentro de `command_runner_base.dart` seriam privadas ao
      pacote `command_runner`, e você não conseguiria
      usá-las na sua aplicação `dartpedia`.

1.  Abra o arquivo `command_runner/lib/src/command_runner_base.dart`.

1.  Remova qualquer código provisório existente e
    adicione a seguinte classe `CommandRunner` em
    `command_runner/lib/src/command_runner_base.dart`:

    ```dart title="command_runner/lib/src/command_runner_base.dart"
    class CommandRunner {
      /// Runs the command-line application logic with the given arguments.
      Future<void> run(List<String> input) async {
        print('CommandRunner received arguments: $input');
      }
    }
    ```

    Destaques do código anterior:

    - `CommandRunner` é uma classe que, por enquanto,
      serve como uma versão simplificada.
      Seu método `run` apenas imprime os argumentos que recebe.
      Nos próximos capítulos, você vai expandir essa classe para
      tratar análises de comandos complexas e configuráveis.
    - `Future<void>` é um tipo de retorno que indica que
      este método pode executar operações assíncronas,
      mas não retorna um valor.

### Tarefa 3: Adicione command_runner como dependência {:#task-3-add-command_runner-as-a-dependency}

Agora que você criou o pacote `command_runner` e
adicionou a classe provisória `CommandRunner`,
precisa informar à sua aplicação `cli` que ela depende do `command_runner`.
Como o pacote `command_runner` está localizado localmente no seu projeto,
você pode usar uma [dependência de caminho][path dependency].

1.  Abra o arquivo `cli/pubspec.yaml`.

    :::note
    Certifique-se de abrir o arquivo correto, `/dartpedia/cli/pubspec.yaml`.
    Ao criar o pacote `command_runner`, ele também veio com um arquivo
    `/dartpedia/command_runner/pubspec.yaml`.
    :::

1.  Como o pacote `cli` é um pacote de aplicação e
    não deve ser publicado no pub.dev,
    adicione `publish_to: none` logo após o campo `name`.
    Isso ajuda a evitar publicações acidentais e
    impede avisos do analisador sobre a adição de dependências de caminho.

    ```yaml title="cli/pubspec.yaml" highlightLines=2
    name: cli
    publish_to: none
    # ...
    ```

1.  Localize a seção `dependencies`. Adicione as linhas a seguir:

    ```yaml title="cli/pubspec.yaml" highlightLines=3-4
    dependencies:
      http: ^1.3.0 # Keep your existing http dependency
      command_runner:
        path: ../command_runner # Points to your local command_runner package
    ```

    Esta seção informa à aplicação `cli` que ela depende do pacote
    `command_runner` e especifica que o pacote está no diretório
    `../command_runner` (relativo ao diretório `cli`).

1.  Execute `dart pub get` no diretório `/dartpedia/cli` do seu terminal
    para baixar a nova dependência.

[path dependency]: /tools/pub/dependencies#path-packages

### Tarefa 4: Importe e use o pacote command_runner {:#task-4-import-and-use-the-command_runner-package}

Agora que você adicionou `command_runner` como dependência,
pode importá-lo na sua aplicação `cli` e
substituir a lógica atual de tratamento de argumentos
pela nova classe `CommandRunner`.

1.  Abra o arquivo `cli/bin/cli.dart`.

1.  Adicione a instrução de importação a seguir no topo do arquivo,
    junto com as outras importações:

    ```dart title="cli/bin/cli.dart"
    import 'package:command_runner/command_runner.dart';
    ```

    Esta instrução importa o pacote `command_runner`,
    tornando a classe `CommandRunner` disponível para uso.

1.  **Refatore a função `main` e remova a lógica antiga:**
    Atualmente, sua função `main` do Capítulo 3 trata diretamente
    comandos como `version`, `help` e `wikipedia`, e depois chama `searchWikipedia`.
    Agora você vai substituir toda essa lógica de tratamento de comandos
    por uma única chamada à nova classe `CommandRunner`.

    **O seu arquivo `cli/bin/cli.dart` (do Capítulo 3) deve estar
    assim neste momento:**

    ```dart title="cli/bin/cli.dart"
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

    **Agora, substitua todo o conteúdo de `cli/bin/cli.dart`
    (exceto a importação de `http`) pela versão atualizada a seguir:**

    ```dart title="cli/bin/cli.dart"
    import 'dart:io';
    import 'package:http/http.dart' as http;
    import 'package:command_runner/command_runner.dart';

    void main(List<String> arguments) async { // main is now async and awaits the runner
      var runner = CommandRunner(); // Create an instance of your new CommandRunner
      await runner.run(arguments); // Call its run method, awaiting its Future<void>
    }
    ```

    Destaques do código anterior:

    - Declarar `main` como `async` permite usar `await`.
      Como `runner.run()` retorna um `Future`,
      aguardá-lo faz com que `main` espere explicitamente a conclusão do runner,
      garantindo uma ordem lógica clara e melhorando a propagação de erros.
    - `var runner = CommandRunner();` cria uma instância da classe
      `CommandRunner` do seu novo pacote `command_runner`.
    - `await runner.run(arguments);` chama o método `run` da instância
      de `CommandRunner`, passando os argumentos de linha de comando.

    Funções removidas:

    - As funções `printUsage`, `searchWikipedia` e `getWikipediaArticle`
      agora foram completamente removidas de `cli/bin/cli.dart`.
      A lógica delas será redesenhada e movida para o pacote `command_runner`
      nos próximos capítulos, como parte da construção do framework
      completo de linha de comando.

### Tarefa 5: Execute a aplicação {:#task-5-run-the-application}

Agora que você refatorou o código e
atualizou a aplicação `cli` para usar o pacote `command_runner`,
execute a aplicação para verificar se tudo está funcionando corretamente nesta etapa.

1.  Abra o terminal e acesse o diretório `cli`.

1.  Execute o comando `wikipedia`:

    ```bash
    dart run bin/cli.dart wikipedia Computer_programming
    ```

1.  Confirme que a aplicação agora executa sem erros e imprime
    os argumentos no console, demonstrando que o controle
    foi transferido com sucesso para o seu novo pacote `command_runner`.

    ```bash
    CommandRunner received arguments: [wikipedia, Computer_programming]
    ```

    :::tip Solução de problemas
    Se o Dart reportar um erro `Method not found: 'CommandRunner'` ao
    executar `cli.dart`, certifique-se de que
    `command_runner/lib/src/command_runner_base.dart` foi atualizado com
    a classe `CommandRunner` da [Tarefa 2][Task 2].
    :::

:::important Observação importante sobre a funcionalidade
Você vai notar que a funcionalidade de busca de artigos (do Capítulo 3)
não está mais ativa. Isso é esperado!
Neste capítulo, você refatorou a estrutura do projeto ao
mover a responsabilidade de tratamento de comandos.
Os próximos capítulos vão se concentrar em reconstruir e
aprimorar essa lógica central dentro do pacote `command_runner`.
:::

[Task 2]: #task-2-implement-the-commandrunner-class

## Revisão {:#review}

<SummaryCard>
title: O que você realizou
subtitle: Aqui está um resumo do que você construiu e aprendeu nesta lição.
completed: true
items:
  - title: Criou um pacote Dart reutilizável
    icon: package_2
    details: >-
      Você usou `dart create -t package command_runner` para criar a estrutura
      de um novo pacote de biblioteca, feito para ser usado em outros pacotes.
      Pacotes de biblioteca são a forma padrão de organizar e compartilhar
      bibliotecas Dart reutilizáveis, tanto dentro de um workspace de projeto
      quanto publicadas no pub.dev.
  - title: Usou exports para definir uma API pública
    icon: export_notes
    details: >-
      Você adicionou instruções `export` no arquivo da biblioteca para expor
      bibliotecas específicas e suas definições aos consumidores.
      Se não forem exportados a partir dos arquivos na raiz `lib`,
      os códigos em `lib/src/` continuam privados ao pacote.
      Isso permite criar cuidadosamente uma API pública para outros,
      mantendo controle total sobre os detalhes de implementação.
  - title: Adicionou dependências de caminho local
    icon: folder_code
    details: >-
      Você configurou o `pubspec.yaml` para depender de um pacote local
      usando uma dependência de caminho.
      Isso possibilita projetos com múltiplos pacotes que podem evoluir juntos
      antes de serem publicados separadamente.
</SummaryCard>

## Quiz {:#quiz}

<Quiz title="Check your understanding" id="packages-libs" />

## Próxima lição {:#next-lesson}

O próximo capítulo aborda os conceitos de programação orientada a objetos (POO) em Dart.
Crie classes, construtores e getters, e
use enums para modelar os argumentos de linha de comando dentro do pacote `command_runner`.
