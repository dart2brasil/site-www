---
ia-translate: true
title: "Programação assíncrona no Dart: Isolates e event loops"
description: "O Dart, apesar de ser uma linguagem de thread única, oferece suporte a futures, streams, trabalho em segundo plano e todas as outras coisas que você precisa para escrever de forma moderna, assíncrona e (no caso do Flutter) reativa…"
publishDate: 2019-07-25
author: kwalrath
image: images/1t-mHg6JrdkKCs65UvD70-Q.webp
category: deep-dive
layout: blog
---


O Dart, apesar de ser uma linguagem de thread única, oferece suporte a futures, streams, trabalho em segundo plano e todas as outras coisas que você precisa para escrever de forma moderna, assíncrona e (no caso do Flutter) reativa. Este artigo cobre os fundamentos do suporte do Dart a trabalho em segundo plano: *isolates* e *event loops*.

Se você prefere aprender assistindo ou ouvindo, tudo o que está neste artigo é coberto no vídeo a seguir, que faz parte da série de vídeos *Flutter in Focus* *Asynchronous Programming in Dart:*

<YoutubeEmbed id="vl_AaCgudcY" title="Isolates e Event Loops - Flutter in Focus" fullwidth="true"/>


Ainda aqui? Vamos falar sobre isolates.

## Isolates {:#isolates}

Um *isolate* é o lugar onde todo o código Dart é executado. É como um pequeno espaço na máquina, com seu próprio bloco privado de memória e uma única thread executando um event loop.

<DashImage src="images/1xtjhmzoLQEmh7Od1BkroVg.webp" alt="Cartão de um único isolate contendo uma grade de memória acima de setas circulares do event loop." caption="Um isolate tem sua própria memória e uma única thread de execução que roda um event loop." />


Em muitas outras linguagens, como C++, você pode ter várias threads compartilhando a mesma memória e executando qualquer código que quiser. No Dart, porém, cada thread fica em seu próprio isolate, com memória própria, e a thread apenas processa eventos (mais sobre isso daqui a pouco).

Muitos apps em Dart executam todo o seu código em um único isolate, mas você pode ter mais de um se precisar. Se você tiver um cálculo tão enorme que, se fosse executado no isolate principal, poderia fazer você perder frames, pode usar [Isolate.spawn()](https://api.dartlang.org/stable/dart-isolate/Isolate/spawn.html) ou [a função compute() do Flutter](https://flutter.dev/docs/cookbook/networking/background-parsing#4-move-this-work-to-a-separate-isolate). Ambas as funções criam um isolate separado para fazer o processamento pesado, deixando seu isolate principal livre para — digamos — reconstruir e renderizar a árvore de widgets.

<DashImage src="images/1MnJQG2bdbcqmEwu1lSL52Q.webp" alt="Dois cartões de isolate separados, cada um com sua própria grade de memória e setas do event loop." caption="Dois isolates, cada um com sua própria memória e thread de execução." />


O novo isolate ganha seu próprio event loop e sua própria memória, à qual o isolate original — mesmo sendo o pai desse novo — não tem permissão de acessar. Daí vem o nome *isolate*: esses pequenos espaços são mantidos *isolados* uns dos outros.

Na verdade, a única forma de os isolates trabalharem juntos é trocando mensagens. Um isolate envia uma mensagem ao outro, e o isolate receptor processa essa mensagem usando seu event loop.

<DashImage src="images/1kxDfLtL2ySN1yiY1nmcTrA.webp" alt="Dois cartões de isolate com um marcador de mensagem entrando no event loop do segundo isolate." caption="Isolates podem enviar mensagens para outros isolates." />


Essa falta de memória compartilhada pode soar um tanto rígida, principalmente se você vem de uma linguagem como Java ou C++, mas ela traz alguns benefícios importantes para quem programa em Dart.

Por exemplo, a alocação de memória e a coleta de lixo em um isolate não exigem locks. Há apenas uma thread, então, se ela não estiver ocupada, você sabe que a memória não está sendo modificada. Isso funciona bem para apps Flutter, que às vezes precisam montar e desmontar rapidamente um monte de widgets.

## Event loops {:#event-loops}

Agora que você teve uma introdução básica aos isolates, vamos mergulhar no que realmente torna o código assíncrono possível: o *event loop*.

Imagine a vida de um app esticada em uma linha do tempo. O app inicia, o app para e, no meio disso, ocorre um monte de eventos — I/O do disco, toques do usuário na tela… todo tipo de coisa.

Seu app não consegue prever quando esses eventos vão acontecer nem em que ordem, e ele precisa tratar todos com uma única thread que nunca bloqueia. Então, o app executa um event loop. Ele pega o evento mais antigo da sua fila de eventos, processa-o, volta para buscar o próximo, processa-o, e assim por diante, até a fila de eventos estar vazia.

Durante todo o tempo em que o app está rodando — você toca na tela, coisas estão sendo baixadas, um timer dispara —, esse event loop fica girando sem parar, processando esses eventos um de cada vez.

<DashImage src="images/1t-mHg6JrdkKCs65UvD70-Q.webp" alt="Eventos na fila avançando um de cada vez em direção a uma engrenagem com setas circulares do event loop." caption="O event loop processa um evento de cada vez." />


Quando há uma pausa na ação, a thread simplesmente fica ociosa, esperando o próximo evento. Ela pode acionar o coletor de lixo, tomar um café, o que for.

Todas as APIs de alto nível e os recursos de linguagem que o Dart oferece para programação assíncrona — futures, streams, async e await — são construídos sobre e em torno desse loop simples.

Por exemplo, suponha que você tenha um botão que inicia uma requisição de rede, como este:

```dart
RaisedButton(
  child: Text('Click me'),
  onPressed: () {
    final myFuture = http.get('https://example.com');
    myFuture.then((response) {
      if (response.statusCode == 200) {
        print('Success!');
      }
    });
  },
)
```

Quando você executa seu app, o Flutter constrói o botão e o coloca na tela. Então seu app espera.

O event loop do seu app meio que fica ocioso, esperando o próximo evento. Eventos não relacionados ao botão podem chegar e ser tratados, enquanto o botão fica ali, aguardando o usuário tocar nele. Eventualmente, ele toca, e um evento de toque entra na fila.

Esse evento é pego para processamento. O Flutter o analisa, e o sistema de renderização diz: “Essas coordenadas correspondem ao botão elevado”, então o Flutter executa a função onPressed. Esse código inicia uma requisição de rede (que retorna um future) e registra um handler de conclusão para o future usando o método then().

É isso. O loop termina de processar aquele evento de toque, e ele é descartado.

Agora, onPressed é uma propriedade do [RaisedButton](https://api.flutter.dev/flutter/material/RaisedButton-class.html), e o evento de rede usa um callback para um [future](https://api.dart.dev/stable/dart-async/Future-class.html), mas as duas técnicas fazem basicamente a mesma coisa. Ambas são uma forma de dizer ao Flutter: “Ei, mais tarde você pode ver um determinado tipo de evento chegar. Quando isso acontecer, por favor, execute este trecho de código.”

Então, onPressed fica esperando um toque, e o future fica esperando dados da rede, mas, do ponto de vista do Dart, ambos são apenas eventos na fila.

E é assim que a programação assíncrona funciona no Dart. Futures, streams, async e await — essas APIs são apenas formas de você dizer ao event loop do Dart: “Aqui está um código, por favor, execute-o depois.”

Se voltarmos ao exemplo de código, você agora pode ver exatamente como ele está dividido em blocos para eventos específicos. Há a construção inicial (1), o evento de toque (2) e o evento de resposta da rede (3).

```dart
RaisedButton( // (1)
  child: Text('Click me'),
  onPressed: () { // (2)
    final myFuture = http.get('https://example.com');
    myFuture.then((response) { // (3)
      if (response.statusCode == 200) {
        print('Success!');
      }
    });
  },
)
```

Depois que você se acostumar a trabalhar com código assíncrono, vai começar a reconhecer esses padrões em todo lugar. Entender o event loop vai ajudar quando você avançar para as APIs de alto nível.

## Resumo {:#summary}

Demos uma olhada rápida nos isolates, no event loop e na base da programação assíncrona no Dart. Se você está procurando mais detalhes, como o funcionamento da fila de microtasks, veja o artigo desatualizado, arquivado, mas ainda querido [The Event Loop and Dart](https://web.archive.org/web/20170704074724/https://webdev.dartlang.org/articles/performance/event-loop).

Para saber mais sobre assincronia no Dart, confira o próximo artigo desta série, [Programação assíncrona no Dart: Futures](/blog/dart-asynchronous-programming-futures).

*Muito obrigado a Andrew Brogdon, que criou o vídeo no qual este artigo é baseado.*
