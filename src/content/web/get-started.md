---
ia-translate: true
title: Construa um aplicativo web com Dart
description: Comece a escrever aplicativos web em Dart.
---

Esta página descreve os passos para começar a desenvolver aplicativos **somente web** com Dart.
Se você quiser escrever um aplicativo **multiplataforma**, então
[experimente o Flutter.]({{site.flutter}}/web)

Antes de começar, certifique-se de estar confortável com os fundamentos do Dart
lendo a [Introdução ao Dart](/language).
Em seguida, siga os passos abaixo para criar um pequeno aplicativo web com Dart.

## 1. Instale o Dart {:#install-dart}

Para desenvolver aplicativos Dart, você precisa do Dart SDK.
Para continuar com este guia,
[baixe o Dart SDK][dart-download] ou
[instale o Flutter][flutter-download],
que inclui o Dart SDK completo.

[dart-download]: /get-dart
[flutter-download]: {{site.flutter-docs}}/get-started/install

## 2. Obtenha ferramentas CLI ou uma IDE (ou ambos) {:#tools}

<i class="material-symbols">terminal</i>
Se você gosta de usar a linha de comando, instale o pacote [`webdev`][]:

```console
$ dart pub global activate webdev
```

<i class="material-symbols">web</i>
Embora usar uma IDE seja opcional, nós recomendamos fortemente usar uma.
Para uma lista de IDEs disponíveis, veja a
[visão geral de editores e debuggers][overview of editors & debuggers].

[overview of editors & debuggers]: /tools#editors

## 3. Crie um aplicativo web {:#create}

<i class="material-symbols">terminal</i>
Para criar um aplicativo web a partir da linha de comando,
use o comando [`dart create`][] com o template `web`:

```console
$ dart create -t web quickstart
```

<i class="material-symbols">web</i>
Para criar o mesmo aplicativo web a partir de uma IDE que tenha integração com Dart,
[crie um projeto]({{site.flutter}}/tools/vs-code#creating-a-new-project)
usando o template chamado **Bare-bones Web App**.

O template de aplicativo web importa o [`package:web`][], a solução de interoperabilidade
web do Dart, poderosa e concisa, construída para a web moderna. Para saber mais sobre ele, confira a
[visão geral de interoperabilidade web](/interop/js-interop/package-web).

[`dart create`]: /tools/dart-create
[`package:web`]: {{site.pub-pkg}}/web

## 4. Execute o aplicativo {:#run}

<i class="material-symbols">terminal</i>
Para executar o aplicativo a partir da linha de comando,
use [`webdev`][] para compilar e servir o aplicativo:

```console
$ cd quickstart
$ webdev serve
```

<i class="material-symbols">web</i>
Ou execute o aplicativo a partir da sua IDE.

Para visualizar seu aplicativo, use o navegador Chrome
para visitar a URL do aplicativo—por exemplo,
[`localhost:8080`](http://localhost:8080).

Seja usando uma IDE ou a linha de comando,
[`webdev serve`][] compila e serve seu aplicativo
usando o compilador JavaScript de desenvolvimento.
A inicialização é mais lenta na primeira vez que o
compilador de desenvolvimento compila e serve seu aplicativo.
Depois disso, os assets são armazenados em cache no disco e as compilações incrementais são muito mais rápidas.

Uma vez que seu aplicativo tenha sido compilado, o navegador deve exibir
"Your Dart app is running."

![Launched bare-bones app](/assets/img/bare-bones-web-app.png){:width="500"}

[`webdev serve`]: /tools/webdev#serve

## 5. Adicione código personalizado ao aplicativo {:#add-code}

Vamos personalizar o aplicativo que você acabou de criar.

1. Copie a função `thingsTodo()` do seguinte snippet
   para o arquivo `web/main.dart`:

   ```dart
   Iterable<String> thingsTodo() sync* {
     const actions = ['Walk', 'Wash', 'Feed'];
     const pets = ['cats', 'dogs'];

     for (final action in actions) {
       for (final pet in pets) {
         if (pet != 'cats' || action == 'Feed') {
           yield '$action the $pet';
         }
       }
     }
   }
   ```

2. Adicione a função `newLI()` (como mostrado abaixo).
   Ela cria um novo `LIElement` contendo a `String` especificada.

   ```dart
   Iterable<String> thingsTodo() sync* { /* ... */ }

   [!HTMLLIElement newLI(String itemText) =>!]
     [!(document.createElement('li') as HTMLLIElement)..text = itemText;!]

   void main() { /* ... */ }
   ```

3. Na função `main()`, adicione conteúdo ao elemento `output`
   usando `appendChild` e os valores de `thingsTodo()`:

   ```dart
   Iterable<String> thingsTodo() sync* { /* ... */ }

   HTMLLIElement newLI(String itemText) =>
     (document.createElement('li') as HTMLLIElement)..text = itemText;

   void main() {
    final output = querySelector('#output');
    [!for (final item in thingsTodo()) {!]
      [!output?.appendChild(newLI(item));!]
    [!}!]
   }
   ```

4. Salve suas alterações.

5. A ferramenta `webdev` reconstrói automaticamente seu aplicativo.
   Atualize a janela do navegador do aplicativo.
   Agora seu aplicativo Dart simples tem uma lista de tarefas!
   Deve parecer algo assim:<br>
   ![Running the revised app](/assets/img/bare-bones-todo.png){:width="500"}

6. Opcionalmente, melhore a formatação editando `web/styles.css`,
   depois recarregue o aplicativo para verificar suas alterações.

   ```css
   #output {
     padding: 20px;
     [!text-align: left;!]
   }
   ```


## 6. Use o Dart DevTools para inspecionar o aplicativo {:#devtools}

Use o Dart DevTools para definir breakpoints, visualizar valores e tipos,
e percorrer o código Dart do seu aplicativo passo a passo.
Para detalhes de configuração e um passo a passo, veja
[Debugging Dart Web Apps][].

[Debugging Dart Web Apps]: /web/debugging

## 7. Compile e implante seu aplicativo web {:#deploy}

Para executar seu aplicativo web fora do seu ambiente de desenvolvimento,
você precisará compilá-lo e implantá-lo.
Para saber mais sobre implantação de aplicativos web Dart,
confira [Web deployment][].

[Web deployment]: /web/deployment

## O que vem a seguir?

Confira esses recursos:

* Linguagem, bibliotecas e convenções do Dart
  * [Tour pela linguagem](/language)
  * [Passo a passo da biblioteca principal](/libraries)
  * [Effective Dart](/effective-dart)
* Desenvolvimento web
  * [Interoperabilidade JavaScript](/interop/js-interop)
  * [Bibliotecas e pacotes web](/web/libraries)
  * [Visão geral do `package:web`](/interop/js-interop/package-web)
  * [Introduction to the DOM][]
* [Tutoriais](/tutorials) do Dart

Se você tiver dificuldades, encontre ajuda em [Comunidade e suporte.](/community)

[Introduction to the DOM]: https://developer.mozilla.org/docs/Web/API/Document_Object_Model/Introduction

[`webdev`]: /tools/webdev
