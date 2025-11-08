---
ia-translate: true
title: Torne seu programa CLI interativo
shortTitle: Adicionar comandos
description: "Adicione comandos simples à sua aplicação CLI. Aprenda os fundamentos da sintaxe Dart incluindo controle de fluxo, coleções, variáveis, funções e mais."
sitemap: false
noindex: true
layout: learn
prevpage:
  url: /get-started/hello-world
  title: Build your first app
nextpage:
  url: /get-started/async
  title: Intro to async and HTTP
---

{% render 'fwe-wip-warning.md', site: site %}

Neste capítulo, você terá prática hands-on com a sintaxe Dart. Você aprenderá como
ler entrada do usuário, imprimir informações de uso e criar uma interação básica de linha de comando.

:::secondary O que você aprenderá

* Implementar controle de fluxo básico com instruções `if/else`.
* Trabalhar com coleções, especificamente objetos `List`, e executar operações comuns
  como verificar se uma lista está vazia.
* Declarar e usar variáveis com `const` e `late String?`.
* Lidar com nullability com verificações de null.
* Definir e chamar funções.
* Usar interpolação de string para texto dinâmico.
* Ler entrada do usuário da linha de comando usando o comando `stdin`.

:::

## Pré-requisitos

Antes de começar este capítulo, certifique-se de que você:

* Completou o Capítulo 1 e tem um ambiente de desenvolvimento Dart funcionando.
* Está familiarizado com conceitos básicos de programação (variáveis, tipos de dados, controle
  de fluxo).

## Tarefas

Adicione algumas funcionalidades básicas à sua aplicação de linha de comando **Dartpedia** e então
explore a sintaxe Dart para isso.

### Tarefa 1: Implementar comandos version e help

1.  **Implemente o comando `version` em `cli/bin/cli.dart`:** Adicione lógica para
    manipular um comando `version`, que imprime a versão atual do CLI.
    Use uma instrução `if` para verificar se o primeiro
    argumento fornecido é `version`. Você também precisará de uma constante `version`.

    Primeiro, acima da sua função `main`, declare uma variável `const` para a
    versão. O valor de uma variável `const` nunca pode ser alterado depois de ser
    definido:

    ```dart
    const version = '0.0.1'; // Add this line
    ```

    Em seguida, modifique sua função `main` para verificar o argumento `version`:

    ```dart
    void main(List<String> arguments) {
      if (arguments.isEmpty) {
        print('Hello, Dart!');
      } else if (arguments.first == 'version') {
        print('Dartpedia CLI version $version');
      }
    }
    ```
    A sintaxe `$version` é chamada de interpolação de string. Ela permite que você incorpore o valor da variável diretamente em uma string prefixando o nome da variável com um sinal `$`.

1.  **Teste o comando `version`:** Execute sua aplicação com o argumento
    version:

    ```bash
    dart bin/cli.dart version
    ```

    Você deve ver agora:

    ```bash
    Dartpedia CLI version 0.0.1
    ```

    Se você executar seu aplicativo sem argumentos, ainda verá "Hello, Dart!".

1.  **Adicione uma função `printUsage`:** Para tornar a saída mais amigável ao usuário,
    crie uma função separada para exibir informações de uso. Coloque esta função
    fora e abaixo da sua função `main`.

    ```dart
    void printUsage() { // Add this new function
      print(
        "The following commands are valid: 'help', 'version', 'search <ARTICLE-TITLE>'"
      );
    }
    ```

    `search` é o comando que eventualmente buscará da Wikipedia.

1.  **Implemente o comando `help` e refine `main`:** Agora, integre o
    comando `help` usando uma instrução `else if`, e limpe o comportamento padrão
    para chamar a função `printUsage`.

    Modifique sua função `main` para ficar assim:

    ```dart
    void main(List<String> arguments) {
      if (arguments.isEmpty || arguments.first == 'help') {
        printUsage(); // Change this from 'Hello, Dart!'
      } else if (arguments.first == 'version') {
        print('Dartpedia CLI version $version');
      } else {
        printUsage(); // Catch all for any unrecognized command.
      }
    }
    ```

1.  **Entenda a estrutura `if/else` e as variáveis:** Agora que
    você implementou o controle de fluxo na função `main`, revise o
    código que foi adicionado para isso.

    * `arguments.isEmpty` verifica se nenhum argumento de linha de comando foi
        fornecido.
    * `arguments.first` acessa o primeiro argumento, que você está usando como
        nosso comando.
    * `version` é declarado como `const`. Isso significa que seu
        valor é conhecido em tempo de compilação e você não pode alterá-lo durante a execução.
    * `arguments` é uma variável regular (não constante)
        porque seu conteúdo pode mudar durante a execução com base na entrada do usuário.

    Execute sua aplicação com o argumento help. Você deve ver as
    informações de uso impressas:

    ```bash
    dart bin/cli.dart help
    ```

    Além disso, tente executar sem nenhum argumento:

    ```bash
    dart bin/cli.dart
    ```

    Observe que continua a exibir informações de uso.
    Neste ponto, qualquer comando que você não definiu também
    imprimirá informações de uso. Este é o comportamento esperado por enquanto.

### Tarefa 2: Implementar o comando search

A seguir, implemente um comando básico `search` que recebe um título de artigo como
entrada. Ao construir esta funcionalidade, você trabalhará com manipulação de `List`,
verificações de null e interpolação de string.

1.  **Integre o comando `search` em `main`:** Primeiro, modifique a função `main`
    em `cli/bin/cli.dart` para incluir um ramo `else if` que manipula
    o comando `search`. Por enquanto, apenas imprima uma mensagem de placeholder.

    ```dart
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

1.  **Teste o novo comando:** Execute sua aplicação com o comando `search`:

    ```bash
    dart bin/cli.dart search
    ```

    Você deve ver:

    ```bash
    Search command recognized!
    ```

1.  **Defina a função `searchWikipedia`:** O comando `search`
    eventualmente executará a lógica principal da sua aplicação chamando
    uma função chamada `searchWikipedia`. Por enquanto, faça com que
    `searchWikipedia` imprima os argumentos passados para ela com o
    comando `search`. Coloque esta nova função abaixo de `main`.

    ```dart
    // ... (your existing main function)

    void searchWikipedia(List<String>? arguments) { // Add this new function and add ? to arguments type
      print('searchWikipedia received arguments: $arguments');
    }

    // ... (your existing printUsage() function)
    ```

    Destaques do código anterior:

    * `List<String>? arguments` significa que a própria lista `arguments`
       pode ser `null`.

       :::note
       Dart aplica [sound null safety][], o que significa que você
       tem que declarar explicitamente quando uma variável pode ser null. Qualquer
       variável que não está marcada como nullable é *garantida* de nunca
       ser null, mesmo em produção. O propósito de null-safety não é
       impedir você de usar null no seu código, porque
       representar a ausência de um valor pode ser valioso. Em vez disso,
       é forçar você a considerar nullability e, portanto, ser mais
       cuidadoso sobre isso. Junto com o analyzer, isso ajuda a prevenir
       um dos crashes em tempo de execução mais comuns em programação:
       erros de null-pointer.
       :::

1.  **Chame a função `searchWikipedia` da função `main`:**
    Agora, modifique o bloco do comando `search` em `main` para chamar
    `searchWikipedia` e passar a ela quaisquer argumentos que vêm após o
    próprio comando `search`. Use `arguments.sublist(1)` para obter todos os
    argumentos a partir do segundo. Se nenhum argumento for
    fornecido após `search`, passe `null` para `searchWikipedia`.

    ```dart
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

    * Variáveis `final` só podem ser definidas uma vez e são usadas quando você nunca pretende alterar a variável novamente no código.
    * `arguments.sublist(1)` cria uma nova lista
        contendo todos os elementos da lista `arguments` *após* o primeiro
        elemento (que era `search`).
    * `arguments.length > 1 ? ... : null;`
        é um operador condicional (ternário). Ele garante que se nenhum argumento
        for fornecido após o comando `search`, `inputArgs` se torna `null`, correspondendo ao
        comportamento do código de exemplo para o parâmetro `arguments` de `searchWikipedia` do tipo `List<String>?`.

1.  **Teste `searchWikipedia` com argumentos:** Usando a linha de comando, execute a aplicação com um título de artigo
    de teste:

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

1.  **Manipule o título do artigo ausente e entrada do usuário com o comando `stdin`:** É mais
    amigável ao usuário solicitar ao usuário se ele não fornecer um título de artigo na
    linha de comando. Use `stdin.readLineSync()` para isso.

    Primeiro, adicione o import necessário no topo do seu arquivo `cli/bin/cli.dart`:

    ```dart
    import 'dart:io'; // Add this line at the top
    ```

    `dart:io` é uma biblioteca principal no SDK do Dart e fornece APIs para
    lidar com arquivos, diretórios, sockets e
    clientes e servidores HTTP, e mais.

    Agora, atualize sua função `searchWikipedia`.

    ```dart
    void searchWikipedia(List<String>? arguments) {
      final String articleTitle;

      // If the user didn't pass in arguments, request an article title.
      if (arguments == null || arguments.isEmpty) {
        print('Please provide an article title.');
        // Await input and provide a default empty string if the input is null.
        articleTitle = stdin.readLineSync() ?? '';
      } else {
        // Otherwise, join the arguments into the CLI into a single string
        articleTitle = arguments.join(' ');
      }

      print('Current article title: $articleTitle');
    }
    ```

    Este bloco de código anterior introduz alguns
    conceitos-chave:

    * Ele declara uma variável `final String articleTitle`. Isso permite que a análise estática detecte que `articleTitle` será uma `String` e não será null.
    * Uma instrução `if/else` então verifica se argumentos de linha de comando para a
        busca foram fornecidos.
    * Se os argumentos estiverem ausentes, ele solicita ao usuário, lê a entrada usando
        `stdin.readLineSync()` e manipula com segurança casos em que nenhuma entrada é fornecida.
    * Se os argumentos *estão* presentes, ele usa `arguments.join(' ')` para combinar
        eles em uma única string de busca.

    Destaques do código anterior:

    * `stdin.readLineSync() ?? ''` lê a entrada do usuário. Enquanto `stdin.readLineSync()` pode retornar null, o operador de coalescência nula (`??`) fornece uma string vazia padrão (`''`). Esta é uma maneira concisa de garantir que a variável seja uma String não-nula.
    * `arguments.join(' ')`: concatena todos os elementos da lista `arguments`
      em uma única string, usando um espaço como separador. Por exemplo,
      `['Dart', 'Programming']` se torna `"Dart Programming"`. Isso é crucial
      para tratar entradas de linha de comando com várias palavras como uma única frase de busca.
    * A análise estática Dart pode detectar que `articleTitle` tem a garantia de ser inicializado quando a instrução print é executada. Não importa qual caminho seja percorrido através deste corpo de função, a variável é não-nulável.

1.  **Finalize `searchWikipedia` para imprimir resultados de busca simulados:** Atualize `searchWikipedia` para exibir
    mensagens que parecem que nosso programa encontrou algo. Isso nos ajuda a ver o que
    nosso programa finalizado fará sem realmente construir tudo agora.
    Você só verá essas mensagens se incluir uma consulta de busca quando executar
    o programa.

    Por exemplo: `dart bin/cli.dart search Dart Programming`.

    ```dart
    void searchWikipedia(List<String>? arguments) {
      final String articleTitle;

      // If the user didn't pass in arguments, request an article title.
      if (arguments == null || arguments.isEmpty) {
        print('Please provide an article title.');
        // Await input and provide a default empty string if the input is null.
        articleTitle = stdin.readLineSync() ?? '';
      } else {
        // Otherwise, join the arguments into the CLI into a single string
        articleTitle = arguments.join(' ');
      }

      print('Looking up articles about "$articleTitle". Please wait.');
      print('Here ya go!');
      print('(Pretend this is an article about "$articleTitle")');
    }
    ```

1.  **Execução de Teste Final com ambos os cenários:**

    Agora que a simulação do artigo está configurada, teste a função `searchWikipedia` de
    algumas maneiras diferentes:

    ```bash
    dart bin/cli.dart search Dart Programming
    ```

    Você deve ver:

    ```bash
    Looking up articles about "Dart Programming". Please wait.
    Here ya go!
    (Pretend this is an article about "Dart Programming")
    ```

    Execute sem argumentos (digite "Flutter Framework" quando solicitado):

    ```bash
    dart bin/cli.dart search
    ```

    ```bash
    Please provide an article title.
    Flutter Framework
    ```

    Você agora construiu com sucesso o comando básico `search` com manipulação de entrada do usuário,
    tratando corretamente entradas de linha de comando com várias palavras como uma única
    frase de busca na saída.

## Revisão

Neste capítulo, você aprendeu:

* **Controle de fluxo:** Usar instruções `if/else` para controlar o fluxo de execução
    do seu programa.
* **Variáveis e Constantes:** Declarar variáveis com `var`, `const` e `final String`.
* **Listas:** Criar e manipular listas usando `.isEmpty`, `.first`,
    `.sublist` e `.join()`.
* **Null Safety:** Entender nullability (`?`) e usar verificações de null. Manipular valores potencialmente null com o operador de coalescência nula (`??`) para fornecer valores padrão.
* **Funções:** Definir e chamar funções.
* **Interpolação de string:** Incorporar variáveis em strings usando `$`.
* **Entrada/Saída:** Ler entrada do usuário do console usando `stdin.readLineSync()`.

## Quiz

**Questão 1:** Qual keyword é usada para declarar uma variável constante em Dart cujo valor é conhecido em tempo de compilação?
* A) `var`
* B) `final`
* C) `const`
* D) `static`

**Questão 2:** Qual é o propósito principal de `stdin.readLineSync()` em uma aplicação CLI?
* A) Imprimir saída para o console.
* B) Ler uma única linha de entrada de texto do usuário.
* C) Executar um comando.
* D) Verificar se um arquivo existe.

## Próxima lição

No próximo capítulo, você mergulhará na programação assíncrona e aprenderá como
buscar dados da API da Wikipedia usando o pacote `http`. Isso permitirá que sua
aplicação recupere dados reais e os exiba ao usuário.

[sound null safety]: https://dart.dev/null-safety