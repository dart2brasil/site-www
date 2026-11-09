---
ia-translate: true
title: Crie um aplicativo web com Dart
description: Comece a escrever aplicações web em Dart.
---

Esta página descreve os passos para começar a desenvolver aplicações **somente web** com Dart.
Se você quiser escrever uma aplicação **multiplataforma**, então
[experimente o Flutter.]({{site.flutter}}/web)

Antes de começar, certifique-se de estar à vontade com os fundamentos do Dart
lendo a [Introdução ao Dart](/language).
Depois, siga os passos abaixo para criar uma pequena aplicação web com Dart.

## 1. Instale o Dart {:#install-dart}

Para desenvolver aplicações Dart, você precisa do Dart SDK.
Para continuar com este guia,
[baixe o Dart SDK][dart-download] ou
[instale o Flutter][flutter-download],
que inclui o Dart SDK completo.

[dart-download]: /get-dart
[flutter-download]: {{site.flutter-docs}}/get-started/install

## 2. Obtenha ferramentas de linha de comando ou uma IDE (ou ambas) {:#tools}

<i class="material-symbols">terminal</i>
Se você prefere usar a linha de comando, instale o pacote [`webdev`][]:

```console
$ dart pub global activate webdev
```

<i class="material-symbols">web</i>
Embora usar uma IDE seja opcional, recomendamos muito usar uma.
Para uma lista de IDEs disponíveis, veja a
[visão geral de editores e depuradores][overview of editors & debuggers].

[overview of editors & debuggers]: /tools#editors

## 3. Crie uma aplicação web {:#create}

<i class="material-symbols">terminal</i>
Para criar uma aplicação web pela linha de comando,
use o comando [`dart create`][] com o template `web`:

```console
$ dart create -t web quickstart
```

<i class="material-symbols">web</i>
Para criar a mesma aplicação web a partir de uma IDE com integração com Dart,
[crie um projeto]({{site.flutter}}/tools/vs-code#creating-a-new-project)
usando o template chamado **Bare-bones Web App**.

O template de aplicação web importa o [`package:web`][], a solução de interoperabilidade
web do Dart, poderosa e concisa, feita para a web moderna. Para saber mais, veja a
[visão geral de interoperabilidade web](/interop/js-interop/package-web).

[`dart create`]: /tools/dart-create
[`package:web`]: {{site.pub-pkg}}/web

## 4. Execute a aplicação {:#run}

<i class="material-symbols">terminal</i>
Para executar a aplicação pela linha de comando,
use o [`webdev`][] para compilar e servir a aplicação:

```console
$ cd quickstart
$ webdev serve
```

<i class="material-symbols">web</i>
Ou execute a aplicação a partir da sua IDE.

Para ver sua aplicação, use o navegador Chrome
e acesse a URL da aplicação, por exemplo,
[`localhost:8080`](http://localhost:8080).

Seja usando uma IDE ou a linha de comando,
o [`webdev serve`][] compila e serve sua aplicação
usando o compilador JavaScript de desenvolvimento.
A inicialização é mais lenta na primeira vez que o
compilador de desenvolvimento compila e serve a aplicação.
Depois disso, os assets ficam em cache no disco e as compilações incrementais são bem mais rápidas.

Quando a aplicação terminar de compilar, o navegador deve exibir
"Your Dart app is running."

![Aplicação bare-bones inicializada](/assets/img/bare-bones-web-app.png){:width="500"}

[`webdev serve`]: /tools/webdev#serve

## 5. Adicione código personalizado à aplicação {:#add-code}

Vamos personalizar a aplicação que você acabou de criar.

1. Copie a função `thingsToDo()` do snippet a seguir
   para o arquivo `web/main.dart`:

   ```dart
   Iterable<String> thingsToDo() sync* {
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

   ```dart highlightLines=3-5
   Iterable<String> thingsToDo() sync* { /* ... */ }

   web.HTMLLIElement newLI(String itemText) =>
       (web.document.createElement('li') as web.HTMLLIElement)
         ..textContent = itemText;

   void main() { /* ... */ }
   ```

3. Na função `main()`, adicione conteúdo ao elemento `output`
   usando `appendChild` e os valores de `thingsToDo()`:

   ```dart highlightLines=9-11
   Iterable<String> thingsToDo() sync* { /* ... */ }

   web.HTMLLIElement newLI(String itemText) =>
       (web.document.createElement('li') as web.HTMLLIElement)
         ..textContent = itemText;

   void main() {
     final output = web.document.querySelector('#output');
     for (final item in thingsToDo()) {
       output?.appendChild(newLI(item));
     }
   }
   ```

4. Salve suas alterações.

5. A ferramenta `webdev` reconstrói a aplicação automaticamente.
   Atualize a janela do navegador.
   Agora sua aplicação Dart simples tem uma lista de tarefas!
   Ela deve ficar parecida com isto:<br>
   ![Aplicação revisada em execução](/assets/img/bare-bones-todo.png){:width="500"}

6. Opcionalmente, melhore a formatação editando `web/styles.css`
   e depois recarregue a aplicação para conferir as alterações.

   ```css highlightLines=3
   #output {
     padding: 20px;
     text-align: left;
   }
   ```


## 6. Use o Dart DevTools para inspecionar a aplicação {:#devtools}

Use o Dart DevTools para definir breakpoints, ver valores e tipos,
e percorrer o código Dart da sua aplicação passo a passo.
Para detalhes de configuração e um passo a passo, veja
[Depurando aplicações web Dart][Debugging Dart Web Apps].

[Debugging Dart Web Apps]: /web/debugging

## 7. Compile e faça o deploy da sua aplicação web {:#deploy}

Para executar sua aplicação web fora do ambiente de desenvolvimento,
você precisará compilá-la e fazer o deploy.
Para saber mais sobre deploy de aplicações web Dart,
veja [Deploy na web][Web deployment].

[Web deployment]: /web/deployment

## O que vem a seguir? {:#what-next}

Confira estes recursos:

* Linguagem Dart, bibliotecas e convenções
  * [Tour pela linguagem](/language)
  * [Passeio pela biblioteca principal](/libraries)
  * [Effective Dart](/effective-dart)
* Desenvolvimento web
  * [Interoperabilidade com JavaScript](/interop/js-interop)
  * [Bibliotecas e pacotes web](/web/libraries)
  * [Visão geral do `package:web`](/interop/js-interop/package-web)
  * [Introduction to the DOM][]

Se você travar, encontre ajuda em [Comunidade e suporte.](/community)

[Introduction to the DOM]: https://developer.mozilla.org/docs/Web/API/Document_Object_Model/Introduction

[`webdev`]: /tools/webdev
