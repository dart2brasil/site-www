---
ia-translate: true
title: Crie um aplicativo web com Dart
description: Comece a escrever aplicativos web em Dart.
---

Esta página descreve os passos para começar a desenvolver aplicativos **exclusivamente web** com Dart.
Se você deseja escrever um aplicativo **multiplataforma**, então
[experimente o Flutter.]({{site.flutter}}/web)

Antes de começar, certifique-se de que você está confortável com o básico do Dart
lendo a [Introdução ao Dart](/language).
Então siga os passos abaixo para criar um pequeno aplicativo web com Dart.

## 1. Instale o Dart {:#install-dart}

{% include 'get-sdk.md' %}

## 2. Obtenha ferramentas de CLI ou uma IDE (ou ambos) {:#tools}

<i class="material-symbols">terminal</i>
Se você gosta de usar a linha de comando, instale o pacote [`webdev`][]:

```console
$ dart pub global activate webdev
```

<i class="material-symbols">web</i>
Embora usar uma IDE seja opcional, nós recomendamos fortemente usar uma.
Para uma lista de IDEs disponíveis, veja a
[visão geral de editores & debuggers][].

[visão geral de editores & debuggers]: /tools#editors

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
usando o template chamado **Aplicativo Web Básico**.

O template do aplicativo web importa [`package:web`][], a solução de interoperação (interoperabilidade) web poderosa e concisa do Dart,
construída para a web moderna. Para aprender mais sobre isso, confira a
[visão geral de interoperação web](/interop/js-interop/package-web).

[`dart create`]: /tools/dart-create
[`package:web`]: {{site.pub-pkg}}/web

## 4. Execute o aplicativo {:#run}

<i class="material-symbols">terminal</i>
Para executar o aplicativo a partir da linha de comando,
use [`webdev`][] para construir e servir o aplicativo:

```console
$ cd quickstart
$ webdev serve
```

<i class="material-symbols">web</i>
Ou execute o aplicativo a partir da sua IDE.

Para visualizar o seu aplicativo, use o navegador Chrome
para visitar a URL do aplicativo — por exemplo,
[`localhost:8080`](http://localhost:8080).

Se você usa uma IDE ou a linha de comando,
[`webdev serve`][] constrói e serve seu aplicativo
usando o compilador JavaScript de desenvolvimento.
A inicialização é mais lenta na primeira vez que o
compilador de desenvolvimento constrói e serve seu aplicativo.
Depois disso, os assets (recursos) são armazenados em cache no disco e as construções incrementais são muito mais rápidas.

Uma vez que seu aplicativo foi compilado, o navegador deve exibir
"Your Dart app is running." (Seu aplicativo Dart está sendo executado.)

![Aplicativo básico lançado](/assets/img/bare-bones-web-app.png){:width="500"}

[`webdev serve`]: /tools/webdev#serve

## 5. Adicione código personalizado ao aplicativo {:#add-code}

Vamos personalizar o aplicativo que você acabou de criar.

1. Copie a função `thingsTodo()` do seguinte trecho
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

5. A ferramenta `webdev` reconstrói seu aplicativo automaticamente.
   Atualize a janela do navegador do aplicativo.
   Agora seu aplicativo Dart simples tem uma lista de tarefas!
   Ele deve parecer algo assim:<br>
   ![Executando o aplicativo revisado](/assets/img/bare-bones-todo.png){:width="500"}

6. Opcionalmente, melhore a formatação editando `web/styles.css`,
   então recarregue o aplicativo para verificar suas alterações.

   ```css
   #output {
     padding: 20px;
     [!text-align: left;!]
   }
   ```


## 6. Use o Dart DevTools para inspecionar o aplicativo {:#devtools}

Use o Dart DevTools para definir breakpoints (pontos de interrupção), ver valores e tipos,
e percorrer o código Dart do seu aplicativo.
Para detalhes de configuração e um passo a passo, veja
[Depurando Aplicativos Web Dart][].

[Depurando Aplicativos Web Dart]: /web/debugging

## 7. Construa e implante seu aplicativo web {:#deploy}

Para executar seu aplicativo web fora do seu ambiente de desenvolvimento,
você precisará construí-lo e implantá-lo.
Para aprender mais sobre a implantação de aplicativos web Dart,
confira [Implantação Web][].

[Implantação Web]: /web/deployment

## E agora? {:#what-next}

Confira estes recursos:

* Linguagem, bibliotecas e convenções Dart
  * [Tour pela linguagem](/language)
  * [Caminhada pela biblioteca principal](/libraries)
  * [Dart Eficaz](/effective-dart)
* Desenvolvimento Web
  * [Interoperabilidade com JavaScript](/interop/js-interop)
  * [Bibliotecas e pacotes Web](/web/libraries)
  * [Visão geral de `package:web`](/interop/js-interop/package-web)
  * [Introdução ao DOM][]
* [Tutoriais](/tutorials) Dart

Se você ficar travado, encontre ajuda em [Comunidade e suporte.](/community)

[Introdução ao DOM]: https://developer.mozilla.org/docs/Web/API/Document_Object_Model/Introduction

[`webdev`]: /tools/webdev