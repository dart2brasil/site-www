---
ia-translate: true
title: Escreva código assíncrono
shortTitle: Código assíncrono
description: >-
  Aprenda sobre programação assíncrona em Dart e como fazer requisições HTTP.
layout: learn
---

Neste capítulo, você vai explorar a programação assíncrona em Dart,
que permite que seus aplicativos executem várias tarefas de forma concorrente.
Você vai aprender a buscar dados da internet usando o pacote `http`,
para obter um resumo de artigo da Wikipedia.

<SummaryCard>
title: O que você vai realizar
items:
  - title: Escreva código assíncrono com futures e await
    icon: sync
  - title: Instale e use pacotes externos
    icon: package_2
  - title: Busque dados em tempo real da API da Wikipedia
    icon: cloud_download
</SummaryCard>

## Pré-requisitos {:#prerequisites}

- Ter concluído o Capítulo 2, que abordou a
  sintaxe básica do Dart e a interação pela linha de comando.
  Você deve ter um projeto `dartpedia` configurado.
- Estar familiarizado com o conceito de APIs ([Interfaces de Programação de Aplicações][Application Programming Interfaces])
  como uma forma de obter dados.

[Application Programming Interfaces]: https://www.postman.com/what-is-an-api/

## Tarefas {:#tasks}

Neste capítulo, você vai modificar o aplicativo CLI `dartpedia` existente para
buscar e exibir um **[resumo de artigo][article summary]** usando
o pacote `http` e técnicas de programação assíncrona.

[article summary]: http://en.wikipedia.org/api/rest_v1/#/Page%20content/get_page_summary__title_

### Tarefa 1: Adicione a dependência http {:#task-1-add-the-http-dependency}

Antes de fazer requisições HTTP,
você precisa adicionar o pacote `http` como uma
dependência do seu projeto.

1.  Abra o arquivo `dartpedia/cli/pubspec.yaml` dentro do seu projeto.
    Esse arquivo se chama **pubspec** e gerencia os metadados do seu
    projeto Dart, suas dependências (como o pacote `http`) e seus assets.
1.  Localize a seção `dependencies`.
1.  Adicione `http: ^1.4.0` (ou a versão estável mais recente) em `dependencies`.
    O símbolo `^` permite que versões compatíveis sejam usadas.

    ```yaml title="cli/pubspec.yaml"
    dependencies:
      http: ^1.4.0
    ```

1.  Salve o arquivo `pubspec.yaml`.
1.  Execute `dart pub get` no seu terminal, a partir do diretório `dartpedia/cli`.
    Esse comando baixa a dependência recém-adicionada e
    a deixa disponível para uso no seu projeto.

    Você deve ver uma saída parecida com esta:

    ```bash
    Resolving dependencies...
    Downloading packages...
    + http 1.4.0
      lints 5.1.1 (6.0.0 available)
    Changed 1 dependency!
    1 package has newer versions incompatible with dependency constraints.
    Try `dart pub outdated` for more information.
    ```

### Tarefa 2: Importe o pacote http {:#task-2-import-the-http-package}

Agora que você adicionou o pacote `http`,
precisa importá-lo no seu arquivo Dart para usar suas funcionalidades.

1.  Abra o arquivo `cli/bin/cli.dart`.
1.  Adicione a seguinte instrução `import` no topo do arquivo,
    junto com o import existente de `dart:io`:

    ```dart title="cli/bin/cli.dart"
    import 'dart:io';
    import 'package:http/http.dart' as http; // Add this line
    ```

    Essa linha importa o pacote `http` e dá a ele o alias `http`.
    Depois disso, você pode se referir a classes e funções do pacote `http`
    usando `http.` (por exemplo, `http.Client`, `http.get`).
    A parte `as http` é uma convenção comum para evitar conflitos de nome caso
    outra biblioteca importada também tenha uma classe ou função com nome semelhante.

### Tarefa 3: Implemente a função `getWikipediaArticle` {:#task-3-implement-the-getwikipediaarticle-function}

Agora, crie uma nova função chamada `getWikipediaArticle` que
cuida de buscar dados de uma API externa.
Essa função será `async`, porque
requisições de rede são operações assíncronas.

1.  **Defina a assinatura da função:**
    Abaixo da sua função `main` (e da função `printUsage`),
    adicione a seguinte assinatura de função.

    ```dart title="cli/bin/cli.dart"
    // ... (your existing printUsage() function)

    Future<String> getWikipediaArticle(String articleTitle) async {
      //You'll add more code here soon
    }
    ```

    Destaques do código anterior:

    - O tipo de retorno `Future<String>` indica que
      essa função vai, eventualmente, produzir um resultado `String`,
      mas não imediatamente, porque é uma operação assíncrona.
    - A keyword `async` marca a função como assíncrona,
      permitindo que você use `await` dentro dela.

1.  **Construa a URL da API:**
    Dentro da sua nova função `getWikipediaArticle`,
    crie um objeto `Uri`.
    O `Uri` representa o endpoint da API da Wikipedia que
    você vai chamar para obter um resumo do artigo.

    Adicione estas linhas dentro da função `getWikipediaArticle`:

    ```dart title="cli/bin/cli.dart"
    Future<String> getWikipediaArticle(String articleTitle) async {
      final url = Uri.https(
        'en.wikipedia.org', // Wikipedia API domain
        '/api/rest_v1/page/summary/$articleTitle', // API path for article summary
      );
      // ...
    }
    ```

1.  **Faça a requisição HTTP e trate a resposta:**
    Agora, use a função `get` de nível superior do `package:http` para
    fazer uma requisição HTTP `GET` para a URL que você acabou de construir.
    A keyword `await` pausa a execução de `getWikipediaArticle` até que a
    chamada `get` seja concluída e retorne um objeto `http.Response`.

    Depois que a requisição terminar, verifique o `response.statusCode` para
    garantir que ela foi bem-sucedida (um status code `200` significa OK).
    Se tiver sido bem-sucedida, retorne o `response.body`, que
    contém os dados obtidos (neste caso, JSON bruto).
    Se a requisição falhar, retorne uma mensagem de erro informativa.

    Adicione estas linhas depois da construção do `Uri` dentro de `getWikipediaArticle`:

    ```dart title="cli/bin/cli.dart"
    Future<String> getWikipediaArticle(String articleTitle) async {
      final url = Uri.https(
        'en.wikipedia.org',
        '/api/rest_v1/page/summary/$articleTitle',
      );
      final response = await http.get(url); // Make the HTTP request

      if (response.statusCode == 200) {
        return response.body; // Return the response body if successful
      }

      // Return an error message if the request failed
      return 'Error: Failed to fetch article "$articleTitle". Status code: ${response.statusCode}';
    }
    ```

### Tarefa 4: Integre a chamada da API em searchWikipedia {:#task-4-integrate-the-api-call-into-searchwikipedia}

Você vai integrar a chamada da API em `searchWikipedia`.
Essa função vai conter a lógica principal para tratar o comando `wikipedia`.

1.  **Atualize `searchWikipedia` para usar `async`:**
    Localize sua função `searchWikipedia` e
    atualize a assinatura para ser `async`, já que ela agora
    vai executar operações assíncronas.

    Sua função `searchWikipedia` deve ficar assim:

    ```dart title="cli/bin/cli.dart"
    // ... (your existing main function)

    void searchWikipedia(List<String>? arguments) async { // Added 'async'
      final String articleTitle;

      // If the user didn't pass in arguments, request an article title.
      if (arguments == null || arguments.isEmpty) {
        print('Please provide an article title.');
        // Read input and provide a default empty string if the input is null.
        articleTitle = stdin.readLineSync() ?? '';
      } else {
        // Otherwise, join the arguments into a single string.
        articleTitle = arguments.join(' ');
      }

      print('Looking up articles about "$articleTitle". Please wait.');
      print('Here ya go!');
      print('(Pretend this is an article about "$articleTitle")');
    }

    // ... (your existing printUsage() function)
    ```

    Destaques do código anterior:

    - `void searchWikipedia(List<String>? arguments) async`:
      A função agora é `async`.
      Isso é essencial porque ela vai chamar `getWikipediaArticle`, que
      é uma função `async` e precisará de `await` no resultado dela.

1.  **Rejeite entrada `null` ou string vazia:**
    Atualmente, se o usuário executar `dart bin/cli.dart search` e
    pressionar <kbd>Enter</kbd> sem digitar um título,
    `stdin.readLineSync()` retorna uma string vazia.
    Se o usuário pressionar <kbd>Control</kbd>+<kbd>D</kbd> ou
    <kbd>Control</kbd>+<kbd>Z</kbd> para enviar um sinal de fim de arquivo (EOF),
    `stdin.readLineSync()` retorna `null`,
    e `?? ''` usa uma string vazia como fallback.
    Nos dois casos, a CLI faz uma requisição simulada à Wikipedia
    com uma string vazia como título do artigo.

    Substitua o fallback `?? ''` por uma verificação que exibe uma mensagem
    e encerra a função quando nenhuma entrada válida é fornecida.

    ```dart title="cli/bin/cli.dart"
    void searchWikipedia(List<String>? arguments) async {
      final String articleTitle;

      if (arguments == null || arguments.isEmpty) {
        print('Please provide an article title.');
        // Read input without the `?? ''` fallback.
        final inputFromStdin = stdin.readLineSync();
        if (inputFromStdin == null || inputFromStdin.isEmpty) {
          print('No article title provided. Exiting.');
          return; // Exit the function if there's no valid input.
        }
        articleTitle = inputFromStdin;
      } else {
        // Otherwise, join the arguments into a single string.
        articleTitle = arguments.join(' ');
      }

      print('Looking up articles about "$articleTitle". Please wait.');
      print('Here ya go!');
      print('(Pretend this is an article about "$articleTitle")');
    }
    ```

1.  **Chame `getWikipediaArticle` e exiba o resultado:**
    Substitua as duas linhas `print` de placeholder no final de `searchWikipedia`
    por uma chamada a `getWikipediaArticle` e um único `print` do resultado.

    ```dart title="cli/bin/cli.dart"
    void searchWikipedia(List<String>? arguments) async {
      final String articleTitle;

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

      // Call the API and await the result.
      var articleContent = await getWikipediaArticle(articleTitle);
      print(articleContent); // Print the full article response (raw JSON for now)
    }
    ```

    Destaques do código anterior:

    - `await getWikipediaArticle(articleTitle)`:
      Como `getWikipediaArticle` é uma função `async`,
      você precisa usar `await` no resultado dela.
      Isso pausa a função `searchWikipedia` até que o
      `Future<String>` retornado por `getWikipediaArticle` seja resolvido em
      uma `String` com o conteúdo do artigo.
    - `print(articleContent)`:
      Imprime o resumo do artigo obtido como uma string JSON bruta no console.

### Tarefa 5: Atualize o main para chamar searchWikipedia {:#task-5-update-main-to-call-searchwikipedia}

Por fim, atualize sua função `main` para
chamar a nova função `searchWikipedia` quando
o comando `wikipedia` for usado.

1.  Localize o bloco `else if` na sua função `main` que
    atualmente trata o comando `search`.
    Altere o nome do comando de `search` para `wikipedia` e
    atualize a chamada da função.

    No código de exemplo, `main` _não_ usa `await` na chamada a `searchWikipedia`,
    o que significa que `main` em si não precisa ser marcada como `async`.

    Sua função `main` deve ficar assim:

    ```dart title="cli/bin/cli.dart"
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

    - `arguments.sublist(1)`:
      Isso extrai todos os elementos da lista `arguments`,
      começando no segundo elemento (índice 1).
      Assim, o próprio comando `wikipedia` é removido,
      e `searchWikipedia` recebe apenas os argumentos com o título do artigo.
    - `searchWikipedia(inputArgs)`:
      Essa linha chama `searchWikipedia` diretamente.
      Como `main` não precisa
      fazer nada depois que `searchWikipedia` termina,
      você não precisa usar `await` nela a partir de `main`.
      Por isso, `main` não precisa ser `async`.

### Tarefa 6: Execute o aplicativo {:#task-6-run-the-application}

Agora que você implementou a requisição `http` e
a integrou ao seu aplicativo, teste-o.

1.  Abra seu terminal e execute o seguinte comando:

    ```bash
    dart run bin/cli.dart wikipedia "Dart_(programming_language)"
    ```

1.  Verifique se o aplicativo buscou
    o resumo do artigo "Dart" na API da Wikipedia e
    imprimiu o JSON bruto da resposta no console.
    Você pode ver algo como:

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
1.  Em seguida, tente executar sem argumentos.
    Por exemplo, quando solicitado, digite "Flutter_(software)".

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
    Você implementou com sucesso o comando `wikipedia` básico, que
    busca dados reais de uma API externa!

## Revisão {:#review}

<SummaryCard>
title: O que você concluiu
subtitle: Aqui está um resumo do que você construiu e aprendeu nesta lição.
completed: true
items:
  - title: Dominou futures, async e await
    icon: sync
    details: >-
      Você aprendeu que `Future` representa um valor que estará disponível mais tarde.
      A keyword `async` marca funções como assíncronas, e
      `await` pausa a execução até que um `Future` seja concluído.
  - title: Adicionou o pacote http como dependência
    icon: package_2
    details: >-
      Você modificou o `pubspec.yaml` para adicionar o pacote `http`,
      executou `dart pub get` para baixá-lo e o importou com um alias (`as http`).
      Você pode seguir estes passos para adicionar qualquer pacote externo do pub.dev.
  - title: Buscou dados em tempo real da Wikipedia
    icon: cloud_download
    details: >-
      Você criou `getWikipediaArticle()` para
      fazer requisições HTTP GET usando a função `get` do `package:http`, construiu URIs,
      verificou status codes e retornou o corpo da resposta.
      Seu CLI agora busca dados reais da web!
</SummaryCard>

## Quiz {:#quiz}

<Quiz title="Check your understanding" id="async" />

## Próxima lição {:#next-lesson}

No próximo capítulo, você vai focar em
organizar nosso código em bibliotecas e pacotes reutilizáveis.
Você vai refatorar seu aplicativo para
melhorar sua estrutura e manutenibilidade, criando um pacote separado para
lidar com argumentos de linha de comando.
