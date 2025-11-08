---
ia-translate: true
title: Introdução a async e HTTP
shortTitle: Async e HTTP
description: >-
  Aprenda sobre programação assíncrona em Dart e como fazer requisições HTTP.
sitemap: false
noindex: true
layout: learn
prevpage:
  url: /get-started/add-commands
  title: Torne seu programa interativo
nextpage:
  url: /get-started/packages-libs
  title: Pacotes e bibliotecas
---

{% render 'fwe-wip-warning.md', site: site %}

Neste capítulo, você explorará programação assíncrona em Dart, permitindo que seus
aplicativos executem múltiplas tarefas simultaneamente. Você aprenderá como buscar
dados da internet usando o pacote `http`, para recuperar um resumo de artigo
da Wikipedia.

:::secondary O que você aprenderá

* Entender programação assíncrona, `Future`s, `async` e `await`.
* Aprender sobre o pacote `http` e declarações import.
* Implementar a função `getWikipediaArticle` passo a passo, incluindo `http.Client`.
* Entender como a função lógica principal torna-se `async` para lidar com `await`.
* Executar o aplicativo para ver a busca de dados HTTP em ação.

:::

## Pré-requisitos

* Conclusão do Capítulo 2, que cobriu sintaxe básica Dart e interação
  de linha de comando. Você deve ter um projeto `dartpedia` configurado.
* Familiaridade com o conceito de APIs ([Application Programming Interfaces][]) como uma
  forma de recuperar dados.

## Tarefas

Neste capítulo, você modificará o aplicativo CLI `dartpedia` existente para
buscar e exibir um **[resumo de artigo][article summary]** usando o pacote `http` e
técnicas de programação assíncrona.

### Tarefa 1: Adicionar a dependência http

Antes de poder fazer requisições HTTP, você precisa adicionar o pacote `http` como uma
dependência ao seu projeto.

1.  Abra o arquivo `dartpedia/pubspec.yaml` dentro do seu projeto. Este arquivo é
    chamado de **pubspec**, e ele gerencia os metadados do seu projeto Dart,
    dependências (como o pacote `http`), e assets.
1.  Localize a seção `dependencies`.
1.  Adicione `http: ^1.3.0` (ou a versão estável mais recente) em `dependencies`. O
    símbolo `^` permite que versões compatíveis sejam usadas.

    ```yaml
    dependencies:
      http: ^1.3.0
    ```

1.  Salve o arquivo `pubspec.yaml`.
1.  Execute `dart pub get` no seu terminal a partir do diretório `dartpedia/cli`. Este
    comando busca a dependência recém-adicionada e a torna disponível para
    uso no seu projeto.

    Você deve ver uma saída semelhante a esta:

    ```bash
    Resolving dependencies...
    Downloading packages...
    + http 1.4.0
      lints 5.1.1 (6.0.0 available)
    Changed 1 dependency!
    1 package has newer versions incompatible with dependency constraints.
    Try `dart pub outdated` for more information.
    ```

### Tarefa 2: Importar o pacote http

Agora que você adicionou o pacote `http`, você precisa importá-lo no
seu arquivo Dart para usar suas funcionalidades.

1.  Abra o arquivo `dartpedia/bin/cli.dart`.
1.  Adicione a seguinte declaração `import` no topo do arquivo, junto com o
    import `dart:io` existente:

    ```dart
    import 'dart:io';
    import 'package:http/http.dart' as http; // Add this line
    ```

    Esta linha importa o pacote `http` e dá a ele o alias `http`. Depois
    que você fizer isso, pode se referir a classes e funções dentro do pacote `http`
    usando `http.` (por exemplo, `http.Client`, `http.get`). A parte `as
    http` é uma convenção padrão para evitar conflitos de nomenclatura se outra
    biblioteca importada também tiver uma classe ou função com nome semelhante.

### Tarefa 3: Implementar a função `getWikipediaArticle`

Agora crie uma nova função chamada `getWikipediaArticle` que lida com
a busca de dados de uma API externa. Esta função será `async` porque
requisições de rede são operações assíncronas.

1.  **Definir a assinatura da função:**
    Abaixo da sua função `main` (e função `printUsage`), adicione a seguinte
    assinatura de função.

    ```dart
    // ... (your existing printUsage() function)

    Future<String> getWikipediaArticle(String articleTitle) async {
      //You'll add more code here soon
    }
    ```

    Destaques do código anterior:

    * O tipo de retorno `Future<String>` indica que esta função
    eventualmente produzirá um resultado `String`, mas não imediatamente, porque é uma operação assíncrona.
    * A keyword `async` marca a função como assíncrona, permitindo que você
    use `await` dentro dela.

1.  **Construir a URL da API e `http.Client`:**
    Dentro da sua nova função `getWikipediaArticle`, crie uma instância `http.Client()`
    e um objeto `Uri`. O `Uri` representa o endpoint da
    API da Wikipedia que você chamará para obter um resumo de artigo.

    Adicione estas linhas dentro da função `getWikipediaArticle`:

    ```dart
    Future<String> getWikipediaArticle(String articleTitle) async {
      final client = http.Client(); // Create an HTTP client
      final url = Uri.https(
        'en.wikipedia.org', // Wikipedia API domain
        '/api/rest_v1/page/summary/$articleTitle', // API path for article summary
      );
      // ...
    }
    ```

2.  **Fazer a requisição HTTP e lidar com a resposta:**
    Agora, use o cliente `http` para fazer uma requisição `GET` HTTP para a URL que você acabou de construir. A keyword `await` pausa a execução de
    `getWikipediaArticle` até que a chamada `client.get(url)` seja concluída e retorne
    um objeto `http.Response`.

    Após a requisição ser concluída, verifique o `response.statusCode` para garantir que a
    requisição foi bem-sucedida (um código de status `200` significa OK). Se bem-sucedida,
    retorne o `response.body`, que contém os dados buscados (neste caso,
    JSON bruto). Se a requisição falhar, retorne uma mensagem de erro informativa.

    Adicione estas linhas após a construção do `Uri` dentro de `getWikipediaArticle`:

    ```dart
    Future<String> getWikipediaArticle(String articleTitle) async {
      final client = http.Client();
      final url = Uri.https(
        'en.wikipedia.org',
        '/api/rest_v1/page/summary/$articleTitle',
      );
      final response = await client.get(url); // Make the HTTP request

      if (response.statusCode == 200) {
        return response.body; // Return the response body if successful
      }

      // Return an error message if the request failed
      return 'Error: Failed to fetch article "$articleTitle". Status code: ${response.statusCode}';
    }
    ```

### Tarefa 4: Integrar a chamada da API em searchWikipedia

Você integrará a chamada da API em `searchWikipedia`. Esta função abrigará
a lógica central para lidar com o comando `wikipedia`.

1.  **Atualizar `searchWikipedia` para usar `async`:**
    Localize sua função `searchWikipedia` e atualize sua assinatura para ser
    `async` pois ela agora executará operações assíncronas.

    Sua função `searchWikipedia` deve agora parecer com isso (parte inicial):

    ```dart
    // ... (your existing main function)

    void searchWikipedia(List<String>? arguments) async { // Added 'async'
      late String? articleTitle;

      // If the user didn't pass in arguments, request an article title.
      if (arguments == null || arguments.isEmpty) {
        print('Please provide an article title.');
        articleTitle = stdin.readLineSync(); // Await input from the user
        // You'll add error handling for null input here in a moment
      } else {
        // Otherwise, join the arguments into the CLI into a single string
        articleTitle = arguments.join(' ');
      }

      print('Looking up articles about "$articleTitle". Please wait.');
      print('Here ya go!');
      print('(Pretend this is an article about "$articleTitle")');
    }

    // ... (your existing printUsage() function)
    ```

    Destaques do código anterior:

    * `void searchWikipedia(List<String>? arguments) async`: A função agora é
    `async`. Isso é essencial porque ela chamará `getWikipediaArticle`,
    que é uma função `async` por si só e precisará `await` seu resultado.

1.  **Adicionar verificações de `null` e string vazia para entrada do usuário:**
    Dentro de `searchWikipedia`, refine o bloco `if` que lida com o caso onde
    nenhum argumento é fornecido. Se `stdin.readLineSync()` retornar `null` (por
    exemplo, se o usuário pressionar Ctrl+D/Ctrl+Z) ou uma string vazia, imprima uma
    mensagem e saia da função.

    ```dart
    void searchWikipedia(List<String>? arguments) async {
      late String? articleTitle;

      if (arguments == null || arguments.isEmpty) {
        print('Please provide an article title.');
        final inputFromStdin = stdin.readLineSync(); // Read input
        if (inputFromStdin == null || inputFromStdin.isEmpty) {
          print('No article title provided. Exiting.');
          return; // Exit the function if no valid input
        }
        articleTitle = inputFromStdin;
      } else {
        articleTitle = arguments.join(' ');
      }

      print('Looking up articles about "$articleTitle". Please wait.');
      print('Here ya go!');
      print('(Pretend this is an article about "$articleTitle")');
    }
    ```

1.  **Chamar `getWikipediaArticle` e imprimir o resultado:**
    Agora, modifique a função `searchWikipedia` para chamar sua nova
    função `getWikipediaArticle` e imprimir o resultado. Substitua as
    declarações `print` de espaço reservado anteriores pela chamada real da API.

    ```dart
    // ... (beginning of searchWikipedia function, after determining articleTitle)

    void searchWikipedia(List<String>? arguments) async {
      late String? articleTitle;
      if (arguments == null || arguments.isEmpty) {
        print('Please provide an article title.');
        final inputFromStdin = stdin.readLineSync();
        if (inputFromStdin == null || inputFromStdin.isEmpty) {
          print('No article title provided. Exiting.');
          return;
        }
        articleTitle = inputFromStdin;
      } else {
        articleTitle = arguments.join(' ');
      }

      print('Looking up articles about "$articleTitle". Please wait.');

      // Call the API and await the result
      var articleContent = await getWikipediaArticle(articleTitle);
      print(articleContent); // Print the full article response (raw JSON for now)
    }
    ```

    Destaques do código anterior:

    * `await getWikipediaArticle(articleTitle)`: Como `getWikipediaArticle`
    é uma função `async`, você precisa `await` seu resultado. Isso pausa a
    função `searchWikipedia` até que o `Future<String>` retornado por
    `getWikipediaArticle` resolva em uma `String` contendo o conteúdo do artigo.
    * `print(articleContent)`: Imprime o resumo do artigo buscado como uma string JSON
    bruta no console.

### Tarefa 5: Atualizar main para chamar searchWikipedia

Finalmente, atualize sua função `main` para chamar a nova função `searchWikipedia`
quando o comando `wikipedia` for usado.

1.  Localize o bloco `else if` na sua função `main` que atualmente lida com
    o comando `search`. Altere o nome do comando de `search` para `wikipedia`
    e atualize a chamada da função.

    No código de exemplo, `main` *não* faz `await` da chamada para `searchWikipedia`,
    significando que `main` em si não precisa ser marcada como `async`.

    Sua função `main` deve agora parecer com isto:

    ```dart
    // ... (existing const version declaration and printUsage function)

    void main(List<String> arguments) {
      if (arguments.isEmpty || arguments.first == 'help') {
        printUsage();
      } else if (arguments.first == 'version') {
        print('Dartpedia CLI version $version');
      } else if (arguments.first == 'wikipedia') { // Changed to 'wikipedia'
        // Pass all arguments *after* 'wikipedia' to searchWikipedia
        final inputArgs = arguments.length > 1 ? arguments.sublist(1) : null;
        searchWikipedia(inputArgs); // Call searchWikipedia (no 'await' needed here for main)
      } else {
        printUsage(); // Catch all for any unrecognized command.
      }
    }
    ```

    * `arguments.sublist(1)`: Isso extrai todos os elementos da lista `arguments`
    começando do segundo elemento (índice 1). Isso efetivamente remove
    o próprio comando `wikipedia`, então `searchWikipedia` apenas recebe os
    argumentos reais do título do artigo.
    * `searchWikipedia(inputArgs)`: Isso chama `searchWikipedia` diretamente. Como
    `main` não precisa fazer nada depois que `searchWikipedia` termina, você
    não precisa `await` dela de `main` (e portanto `main` não precisa
    ser `async`).

### Tarefa 6: Executar o aplicativo

Agora que você implementou a requisição `http` e a integrou no seu
aplicativo, teste-o.

1.  Abra seu terminal e execute o seguinte comando:

    ```dart
    dart run bin/cli.dart wikipedia "Dart_(programming_language)"
    ```

1.  Verifique se o aplicativo buscou o resumo do artigo "Dart"
    da API da Wikipedia e imprimiu a resposta JSON bruta no
    console. Você pode ver algo como:

    ```bash
    Looking up articles about "Dart_(programming_language)". Please wait.
    {
      "type": "standard",
      "title": "Dart (programming language)",
      "displaytitle": "<span class=\"mw-page-title-main\">Dart (programming language)</span>",
      "namespace": {
          "id": 0,
          "text": ""
        }

      // ... (rest of the JSON output will be present but truncated here)

    }
    ```
1.  Em seguida, tente executar sem argumentos (digite ou cole "Flutter_(software)"
    quando solicitado):

    ```bash
    dart run bin/cli.dart wikipedia
    ```

    ```bash
    Please provide an article title.
    Flutter_(software)
    Looking up articles about "Flutter_(software)". Please wait.
    {
      "type": "standard",
      "title": "Flutter (software)",
      "displaytitle": "<span class=\"mw-page-title-main\">Flutter (software)</span>",
      "namespace": {
          "id": 0,
          "text": ""
      }

    // ... (rest of the JSON output will be present but truncated here)

    }
    ```
    Você agora implementou com sucesso o comando básico `wikipedia` que
    busca dados reais de uma API externa!

## Revisão

Neste capítulo, você aprendeu sobre:

* **Programação assíncrona:** Entender `Future`s, `async` e `await`
para operações que levam tempo, como requisições de rede.
* **Pacotes externos:** Como adicionar dependências usando `pubspec.yaml` e importá-las
no seus arquivos Dart.
* **Requisições HTTP:** Fazer chamadas de rede usando a biblioteca `package:http`.
* **Interação com API:** Buscar dados de uma API pública (Wikipedia) e lidar com
sua resposta.
* **Organização de código:** Refatorar lógica em uma função `searchWikipedia`
dedicada para melhor estrutura.

## Quiz

**Questão 1:** Qual keyword é usada para marcar uma função como assíncrona em Dart?
* A) `sync`
* B) `async`
* C) `future`
* D) `thread`

**Questão 2:** O que a keyword `await` faz?
* A) Cancela a execução de uma função assíncrona.
* B) Declara um novo objeto `Future`.
* C) Pausa a execução da função `async` atual até que um `Future`
    seja concluído.
* D) Cria uma nova thread.

**Questão 3:** Qual pacote é usado neste guia para fazer requisições HTTP?
* A) `dart:io`
* B) `dart:html`
* C) `package:http`
* D) `package:async`

## Próxima lição

No próximo capítulo, você focará em organizar nosso código em
bibliotecas e pacotes reutilizáveis. Você refatorará nosso aplicativo para melhorar sua
estrutura e manutenibilidade criando um pacote separado para
lidar com argumentos de linha de comando.

[Application Programming Interfaces]: https://www.postman.com/what-is-an-api/
[article summary]: http://en.wikipedia.org/api/rest_v1/#/Page%20content/get_page_summary__title_
