---
ia-translate: true
title: Adicione interatividade ao seu app
shortTitle: Interatividade
description: >-
  Adicione comandos simples à sua aplicação CLI.
  Aprenda os fundamentos da sintaxe do Dart, incluindo
  controle de fluxo, coleções, variáveis, funções e muito mais.
layout: learn
---

Neste capítulo, você vai praticar a sintaxe do Dart na prática.
Você vai aprender a ler a entrada do usuário, exibir informações de uso e
criar uma interação básica pela linha de comando.

<SummaryCard>
title: O que você vai realizar
items:
  - title: Criar manipuladores de comandos com instruções if
    icon: account_tree
  - title: Trabalhar com listas e variáveis
    icon: data_array
  - title: Lidar com nulabilidade no seu código
    icon: help_outline
  - title: Definir e chamar funções
    icon: function
  - title: Ler e tratar a entrada do usuário
    icon: keyboard
</SummaryCard>

## Pré-requisitos {:#prerequisites}

Antes de começar este capítulo, certifique-se de:

- Ter concluído o Capítulo 1 e ter um ambiente de desenvolvimento Dart funcionando.
- Ter familiaridade com conceitos básicos de programação
  (variáveis, tipos de dados, controle de fluxo).

## Tarefas {:#tasks}

Adicione algumas funcionalidades básicas à sua aplicação de linha de comando **Dartpedia** e
depois explore a sintaxe do Dart para isso.

### Tarefa 1: Implemente os comandos version e help {:#task-1-implement-version-and-help-commands}

1.  **Implemente o comando `version` em `cli/bin/cli.dart`:**
    Adicione a lógica para tratar um comando `version`,
    que exibe a versão atual da CLI.
    Use uma instrução `if` para verificar se o primeiro argumento fornecido é `version`.
    Você também vai precisar de uma constante `version`.

    Primeiro, acima da sua função `main`,
    declare uma variável `const` para a versão.
    O valor de uma variável `const` nunca pode ser alterado depois de definido:

    ```dart title="cli/bin/cli.dart"
    const version = '0.0.1'; // Add this line
    ```

    Em seguida, modifique sua função `main` para verificar o argumento `version`:

    ```dart title="cli/bin/cli.dart"
    void main(List<String> arguments) {
      if (arguments.isEmpty) {
        print('Hello, Dart!');
      } else if (arguments.first == 'version') {
        print('Dartpedia CLI version $version');
      }
    }
    ```
    A sintaxe `$version` é chamada de interpolação de strings.
    Ela permite incorporar o valor da variável diretamente em
    uma string, prefixando o nome da variável com o sinal `$`.

1.  **Teste o comando `version`:**
    Execute sua aplicação com o argumento version:

    ```bash
    dart bin/cli.dart version
    ```

    Agora você deve ver:

    ```bash
    Dartpedia CLI version 0.0.1
    ```

    Se você executar seu app sem argumentos, ainda verá "Hello, Dart!".

1.  **Adicione uma função `printUsage`:**
    Para deixar a saída mais amigável,
    crie uma função separada para exibir as informações de uso.
    Coloque essa função fora e abaixo da sua função `main`.

    ```dart title="cli/bin/cli.dart"
    void printUsage() { // Add this new function
      print(
        "The following commands are valid: 'help', 'version', 'search <ARTICLE-TITLE>'"
      );
    }
    ```

    `search` é o comando que, no futuro, vai pesquisar na Wikipedia.

1.  **Implemente o comando `help` e refine o `main`:**
    Agora, integre o comando `help` usando uma instrução `else if`,
    e simplifique o comportamento padrão para chamar a função `printUsage`.

    Modifique sua função `main` para que fique assim:

    ```dart title="cli/bin/cli.dart"
    void main(List<String> arguments) {
      if (arguments.isEmpty || arguments.first == 'help') {
        printUsage(); // Change this from 'Hello, Dart!'
      } else if (arguments.first == 'version') {
        print('Dartpedia CLI version $version');
      } else {
        printUsage(); // Catch-all for any unrecognized command.
      }
    }
    ```

1.  **Entenda a estrutura `if/else` e as variáveis:**
    Agora que você implementou o controle de fluxo na função `main`,
    revise o código adicionado para isso.

    - `arguments.isEmpty` verifica se nenhum argumento de linha de comando foi fornecido.
    - `arguments.first` acessa o primeiro argumento,
      que você está usando como comando.
    - `version` é declarada como `const`.
      Isso significa que o valor é conhecido em tempo de compilação, e
      você não pode alterá-lo durante a execução.
    - `arguments` é uma variável comum (não constante), porque
      seu conteúdo pode mudar em tempo de execução, de acordo com a entrada do usuário.

    Execute sua aplicação com o argumento help.
    Você deve ver as informações de uso impressas:

    ```bash
    dart bin/cli.dart help
    ```

    Também tente executá-la sem nenhum argumento:

    ```bash
    dart bin/cli.dart
    ```

    Repare que ela continua exibindo as informações de uso.
    Por enquanto, qualquer comando que você ainda não definiu
    também vai imprimir as informações de uso. Esse é o comportamento esperado por enquanto.

### Tarefa 2: Implemente o comando search {:#task-2-implement-the-search-command}

Em seguida, implemente um comando `search` básico que recebe o título de um artigo como entrada.
Ao construir essa funcionalidade, você vai trabalhar com
manipulação de `List`, verificações de nulabilidade e interpolação de strings.

1.  **Integre o comando `search` ao `main`:**
    Primeiro, modifique a função `main` em `cli/bin/cli.dart` para
    incluir um ramo `else if` que trate o comando `search`.
    Por enquanto, apenas imprima uma mensagem provisória.

    ```dart title="cli/bin/cli.dart"
    void main(List<String> arguments) {
      if (arguments.isEmpty || arguments.first == 'help') {
        printUsage();
      } else if (arguments.first == 'version') {
        print('Dartpedia CLI version $version');
      } else if (arguments.first == 'search') {
        // Add this new block:
        print('Search command recognized!');
      } else {
        printUsage();
      }
    }
    ```

1.  **Teste o novo comando:**
    Execute sua aplicação com o comando `search`:

    ```bash
    dart bin/cli.dart search
    ```

    Você deve ver:

    ```bash
    Search command recognized!
    ```

1.  **Defina a função `searchWikipedia`:**
    O comando `search` vai, no futuro, executar a lógica principal da aplicação
    chamando uma função chamada `searchWikipedia`.
    Por enquanto, faça `searchWikipedia` imprimir os
    argumentos recebidos com o comando `search`.
    Coloque essa nova função abaixo de `main`.

    ```dart title="cli/bin/cli.dart"
    // ... (your existing main function)

    void searchWikipedia(List<String>? arguments) { // Add this new function and add ? to arguments type
      print('searchWikipedia received arguments: $arguments');
    }

    // ... (your existing printUsage() function)
    ```

    Destaques do código anterior:

    -  `List<String>? arguments` significa que a própria lista `arguments`
       pode ser `null`.

       :::note
       O Dart impõe o [*sound null safety*][sound null safety], o que significa que você
       precisa declarar explicitamente quando uma variável pode ser nula.
       Qualquer variável que não esteja marcada como anulável é
       _garantida_ como nunca nula, inclusive em produção.

       O objetivo do null safety não é
       impedir que você use null no seu código, porque
       representar a ausência de um valor pode ser útil.
       A ideia é obrigar você a considerar a nulabilidade e,
       por isso, ter mais cuidado com ela.
       Junto com o analyzer, isso ajuda a evitar
       um dos erros de tempo de execução mais comuns da programação:
       os erros de ponteiro nulo.
       :::

1.  **Chame a função `searchWikipedia` a partir da função `main`:**
    Agora, modifique o bloco do comando `search` no `main` para
    chamar `searchWikipedia` e passar os argumentos que
    vêm depois do próprio comando `search`.
    Use `arguments.sublist(1)` para obter todos os argumentos
    a partir do segundo. Se nenhum argumento for fornecido após `search`,
    passe `null` para `searchWikipedia`.

    ```dart title="cli/bin/cli.dart"
    void main(List<String> arguments) {
      if (arguments.isEmpty || arguments.first == 'help') {
        printUsage();
      } else if (arguments.first == 'version') {
        print('Dartpedia CLI version $version');
      } else if (arguments.first == 'search') {
        // Add this new block:
        final inputArgs = arguments.length > 1 ? arguments.sublist(1) : null;
        searchWikipedia(inputArgs);
      } else {
        printUsage();
      }
    }
    ```

    Destaques do código anterior:

    - Variáveis `final` só podem ser definidas uma vez e são usadas quando
      você não pretende mais alterar a variável no código.
    - `arguments.sublist(1)` cria uma nova lista com todos os elementos da
      lista `arguments` _depois_ do primeiro elemento (que era `search`).
    - `arguments.length > 1 ? ... : null;` é um operador condicional (ternário).
      Ele garante que, se nenhum argumento for fornecido após o comando `search`,
      `inputArgs` se torne `null`, o que corresponde ao comportamento do código de exemplo
      para o parâmetro `arguments` de `searchWikipedia`, do tipo `List<String>?`.

1.  **Teste o `searchWikipedia` com argumentos:**
    Usando a linha de comando, execute a aplicação com um título de artigo de teste:

    ```bash
    dart bin/cli.dart search Dart Programming
    ```

    Você deve ver:

    ```bash
    searchWikipedia received arguments: [Dart, Programming]
    ```

    Em seguida, execute o mesmo comando sem os argumentos extras:

    ```bash
    dart bin/cli.dart search
    ```

    Você deve ver:

    ```bash
    searchWikipedia received arguments: null
    ```

1.  **Trate o título de artigo ausente e
    a entrada do usuário com o comando `stdin`:**
    É mais amigável pedir ao usuário que informe o título se ele não o fornecer
    na linha de comando.
    Use `stdin.readLineSync()` para isso.

    Primeiro, adicione o import necessário no topo do arquivo `cli/bin/cli.dart`:

    ```dart title="cli/bin/cli.dart"
    import 'dart:io'; // Add this line at the top
    ```

    `dart:io` é uma biblioteca principal do Dart SDK e
    oferece APIs para lidar com arquivos, diretórios, sockets, clientes e
    servidores HTTP, entre outros recursos.

    Agora, atualize sua função `searchWikipedia` abaixo de `main`.

    ```dart title="cli/bin/cli.dart"
    // ... (your existing main function)

    void searchWikipedia(List<String>? arguments) {
      final String articleTitle;

      // If the user didn't pass in arguments, request an article title.
      if (arguments == null || arguments.isEmpty) {
        print('Please provide an article title.');
        // Await input and provide a default empty string if the input is null.
        articleTitle = stdin.readLineSync() ?? '';
      } else {
        // Otherwise, join the arguments into a single string.
        articleTitle = arguments.join(' ');
      }

      print('Current article title: $articleTitle');
    }

    // ... (your existing printUsage() function)
    ```

    Este bloco de código introduz alguns conceitos importantes:

    - Ele declara a variável `final String articleTitle`.
      Isso permite que a análise estática detecte que
      `articleTitle` será uma `String` e não será nula.
    - Em seguida, uma instrução `if/else` verifica se os argumentos de linha de comando
      para a busca foram fornecidos.
    - Se os argumentos estiverem ausentes, ele pede a entrada ao usuário,
      lê o texto com `stdin.readLineSync()` e
      trata com segurança os casos em que nenhuma entrada é informada.
    - Se os argumentos _estiverem_ presentes, ele usa `arguments.join(' ')` para
      combiná-los em uma única string de busca.

    Destaques do código anterior:

    - `stdin.readLineSync() ?? ''` lê a entrada do usuário.
      Embora `stdin.readLineSync()` possa retornar null,
      o operador de coalescência nula (`??`) fornece
      uma string vazia (`''`) como alternativa caso a entrada seja null.
      Essa é uma forma concisa de garantir que a variável seja uma string não nula.
    - `arguments.join(' ')` concatena todos os elementos da lista `arguments`
      em uma única string, usando um espaço como separador.
      Por exemplo, `['Dart', 'Programming']` se torna `"Dart Programming"`.
      Isso é essencial para tratar entradas de linha de comando com várias palavras
      como uma única frase de busca.
    - A análise estática do Dart consegue detectar que `articleTitle` é
      garantidamente inicializada quando a instrução print é executada.
      Não importa por qual caminho o corpo da função seja percorrido,
      a variável é não anulável.

1.  **Finalize o `searchWikipedia` para imprimir resultados de busca simulados:**
    Atualize o `searchWikipedia` para exibir mensagens que
    deem a impressão de que o programa encontrou algo.
    Isso ajuda você a ver o que o programa final vai fazer, sem
    precisar construir tudo agora.

    Quando você executa o comando `search`, o `main` passa os argumentos após
    `search` para `searchWikipedia`, que então imprime essas mensagens usando
    a consulta da linha de comando ou a entrada solicitada.

    Seu arquivo `cli/bin/cli.dart` completo agora deve ficar assim:

    ```dart title="cli/bin/cli.dart" highlightLines=31-33
    import 'dart:io';

    const version = '0.0.1';

    void main(List<String> arguments) {
      if (arguments.isEmpty || arguments.first == 'help') {
        printUsage();
      } else if (arguments.first == 'version') {
        print('Dartpedia CLI version $version');
      } else if (arguments.first == 'search') {
        final inputArgs = arguments.length > 1 ? arguments.sublist(1) : null;
        searchWikipedia(inputArgs);
      } else {
        printUsage();
      }
    }

    void searchWikipedia(List<String>? arguments) {
      final String articleTitle;

      // If the user didn't pass in arguments, request an article title.
      if (arguments == null || arguments.isEmpty) {
        print('Please provide an article title.');
        // Await input and provide a default empty string if the input is null.
        articleTitle = stdin.readLineSync() ?? '';
      } else {
        // Otherwise, join the arguments into a single string.
        articleTitle = arguments.join(' ');
      }

      print('Looking up articles about "$articleTitle". Please wait.');
      print('Here ya go!');
      print('(Pretend this is an article about "$articleTitle")');
    }

    void printUsage() {
      print(
        "The following commands are valid: 'help', 'version', 'search <ARTICLE-TITLE>'",
      );
    }
    ```

1.  **Execução final de teste com os dois cenários:**

    Agora que a simulação de artigo está configurada,
    teste a função `searchWikipedia` de algumas maneiras diferentes:

    ```bash
    dart bin/cli.dart search Dart Programming
    ```

    Você deve ver:

    ```bash
    Looking up articles about "Dart Programming". Please wait.
    Here ya go!
    (Pretend this is an article about "Dart Programming")
    ```

    Em seguida, execute o comando `search` sem argumentos extras
    (digite "Flutter Framework" quando for solicitado):

    ```bash
    dart bin/cli.dart search
    ```

    ```bash
    Please provide an article title.
    Flutter Framework
    Looking up articles about "Flutter Framework". Please wait.
    Here ya go!
    (Pretend this is an article about "Flutter Framework")
    ```

    Agora você construiu com sucesso o comando `search` básico com
    tratamento de entrada do usuário, tratando corretamente entradas de linha de comando
    com várias palavras como uma única frase de busca na saída.

[sound null safety]: /null-safety

## Revisão {:#review}

<SummaryCard>
title: O que você realizou
subtitle: Veja um resumo do que você construiu e aprendeu nesta lição.
completed: true
items:
  - title: Criou manipuladores de comandos com instruções if e else
    icon: account_tree
    details: >-
      Você usou instruções `if` e `else` para direcionar comandos diferentes,
      como `help`, `version` e `search`.
      Esse padrão de controle de fluxo é fundamental para
      construir aplicações CLI interativas que respondem à entrada do usuário.
  - title: Trabalhou com listas e variáveis
    icon: data_array
    details: >-
      Você aprendeu a declarar variáveis com `final` e `const` e
      trabalhou com listas usando `.isEmpty`, `.first`, `.sublist()` e `.join()`.
      Você também usou interpolação de strings (`$variable`) para
      incorporar valores em literais de string.
  - title: Lidou com nulabilidade no seu código
    icon: help_outline
    details: >-
      Você adotou o sound null safety do Dart usando tipos anuláveis (`?`),
      verificações de null e o operador de coalescência nula (`??`) para
      fornecer valores padrão quando expressões podem ser `null`.
  - title: Definiu e chamou funções
    icon: function
    details: >-
      Você criou as funções `printUsage()` e `searchWikipedia()` para
      organizar seu código em unidades reutilizáveis.
      Separar a lógica reutilizável em funções ajuda a manter a função `main`
      limpa e facilita a leitura e a manutenção do código.
  - title: Leu e tratou a entrada do usuário
    icon: keyboard
    details: >-
      Você usou `stdin.readLineSync()` de `dart:io` para
      ler a entrada do terminal.
      Isso permite prompts interativos
      como alternativa ou complemento aos argumentos de linha de comando.
</SummaryCard>

## Quiz {:#quiz}

<Quiz title="Confira seu entendimento" id="interactivity" />

## Próxima lição {:#next-lesson}

No próximo capítulo, você vai mergulhar na
programação assíncrona e aprender como
buscar dados da API da Wikipedia usando o pacote `http`.
Isso vai permitir que sua aplicação
obtenha dados reais e os exiba para o usuário.
