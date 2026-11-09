---
ia-translate: true
title: "Programação assíncrona no Dart: Streams"
description: "Este artigo aborda um dos fundamentos da programação reativa: streams, que são objetos do tipo Stream."
publishDate: 2020-02-11
author: kwalrath
image: images/1Q2-Ac9rjIDSuXzbrQqGkVA.webp
category: deep-dive
layout: blog
---


***Nota**: Você pode querer conferir uma [versão deste artigo em que o código foi atualizado para ser null safe](/blog/dart-asynchronous-programming-streams). (O vídeo não mudou.)*

<DashImage src="images/17v26fZu7zzY0QSBQAwj42Q.webp" alt="Tela de um app Flutter intitulada Streams are awesome mostrando o estado de espera antes de os dados do stream chegarem." caption="Um app Flutter simples que exibe dados de um stream" />


Este artigo aborda um dos fundamentos da programação reativa: streams, que são objetos do tipo [`Stream`](https://api.dart.dev/stable/dart-async/Stream-class.html).

Se você leu o [artigo anterior sobre futures](/blog/dart-asynchronous-programming-futures), talvez se lembre de que **cada future representa um único valor** (seja um erro ou um dado) que ele entrega **de forma assíncrona**. Streams funcionam de maneira semelhante, mas, em vez de uma única coisa, **um stream pode entregar zero ou mais valores e erros** ao **longo do tempo.**
> Este artigo é o terceiro baseado na série de vídeos *Flutter in Focus* *Asynchronous Programming in Dart*. O primeiro artigo, [Isolates e event loops](/blog/dart-asynchronous-programming-isolates-and-event-loops), cobriu os fundamentos do suporte do Dart a trabalho em segundo plano. O segundo, [Futures](/blog/dart-asynchronous-programming-futures), discutiu a classe `Future`.
> Se você prefere aprender assistindo ou ouvindo, tudo o que está neste artigo é coberto no vídeo a seguir.

<YoutubeEmbed id="nQBpOIHE4eE" title="Dart Streams - Flutter in Focus" fullwidth="true"/>


Se você pensar na forma como um único valor se relaciona com um [iterador](https://dart.dev/codelabs/iterables) do mesmo tipo, é assim que um future se relaciona com um stream.

<DashImage src="images/1q9cqGB5uXOX3tNw07SoJnQ.webp" alt="Tabela comparando int, Future de int, Iterator de int e Stream de int pela quantidade de valores e pelo momento da entrega." />


Assim como com futures, o essencial é decidir de antemão: “Eis o que fazer quando um dado estiver pronto, quando houver um erro e quando o stream terminar.”

*Também*, assim como com futures, o event loop do Dart continua comandando tudo.

<DashImage src="images/0UVy8BLEUm4CifwDE.webp" alt="Três eventos de stream na fila se aproximando de uma engrenagem com setas circulares que representam o event loop do Dart." caption="Streams funcionam com o event loop do Dart." />


Se você estiver usando o método [`openRead()`](https://api.dart.dev/stable/dart-io/File/openRead.html) da classe `File` para ler dados de um arquivo, por exemplo, esse método retorna um stream.

Pedaços de dados são lidos do disco e chegam ao event loop. Uma biblioteca do Dart olha para eles e diz: “Ah, tem alguém esperando por isso”, adiciona o dado ao stream, e ele sai no código do seu app.

Quando outro pedaço de dado chega, ele entra, e sai. Streams baseados em timer, streams de dados vindos de um socket de rede — eles também funcionam com o event loop, usando eventos de relógio e de rede.

## Escutando streams {:#listening-to-streams}

Vamos falar sobre como trabalhar com os dados fornecidos por um stream. Suponha que você tenha uma classe que lhe dá um stream que emite um novo inteiro por segundo: 1, 2, 3, 4, 5…

Você pode usar o método [`listen()`](https://api.dart.dev/stable/dart-async/Stream/listen.html) para se inscrever no stream. O único parâmetro obrigatório é uma função.

```dart
final myStream = NumberCreator().stream;

final subscription = myStream.listen(
  (data) => print('Data: $data'),
);
```

Toda vez que um novo valor é emitido pelo stream, a função é chamada e imprime o valor:

```
Data: 1
Data: 2
Data: 3
Data: 4
...
```


É assim que `listen()` funciona.
> **Importante:** Por padrão, os streams são configurados para assinatura única. Eles guardam seus valores até que alguém se inscreva, e permitem apenas um listener durante toda a sua vida. Se você tentar escutar um stream duas vezes, receberá uma exceção.
> Felizmente, o Dart também oferece streams de broadcast. Você pode usar o método [`asBroadcastStream()`](https://api.dart.dev/stable/dart-async/Stream/asBroadcastStream.html) para transformar um stream de assinatura única em um de broadcast. Streams de broadcast funcionam da mesma forma que os de assinatura única, mas podem ter vários listeners, e, se ninguém estiver escutando quando um dado estiver pronto, esse dado é descartado.

```dart
final myStream = NumberCreator().stream.asBroadcastStream();

final subscription = myStream.listen(
  (data) => print('Data: $data'),
);

final subscription2 = myStream.listen(
  (data) => print('Data again: $data'),
);
```

Voltemos à primeira chamada de `listen()`, porque há mais algumas coisas para falar sobre ela.

Como mencionamos antes, streams podem produzir erros, assim como os futures. Adicionando uma função `onError` à chamada de `listen()`, você pode capturar e tratar qualquer erro.

Também existe a propriedade `cancelOnError`, que é verdadeira por padrão, mas pode ser definida como falsa para manter a assinatura ativa mesmo depois de um erro.

E você pode adicionar uma função `onDone` para executar algum código quando o stream terminar de enviar dados, como quando um arquivo foi totalmente lido.

Com todos esses quatro parâmetros combinados — `onError`, `onDone`, `cancelOnError` e o parâmetro obrigatório (`onData`) —, você pode estar preparado de antemão para o que quer que aconteça.

```dart
final subscription = myStream.listen(
  (data) {
    print('Data: $data');
  },
  onError: (err) {
    print('Error!');
  },
  cancelOnError: false,
  onDone: () {
    print('Done!');
  },
);
```
> **Dica:** O pequeno objeto de assinatura que `listen()` retorna tem alguns métodos úteis próprios. Ele é uma [*`StreamSubscription`*](https://api.dart.dev/stable/dart-async/StreamSubscription-class.html), e você pode usá-lo para pausar, retomar e até cancelar o fluxo de dados.

```dart
final subscription = myStream.listen(...);

subscription.pause();
subscription.resume();
subscription.cancel();
```

## Usando e manipulando streams {:#using-and-manipulating-streams}

Agora que você sabe usar `listen()` para se inscrever em um stream e receber eventos de dados, podemos falar sobre o que torna os streams realmente interessantes: manipulá-los. Depois que você tem dados em um stream, muitas operações ficam fluidas e elegantes.

Voltando ao stream de números de antes, podemos usar um método chamado [`map()`](https://api.dart.dev/stable/dart-async/Stream/map.html) para pegar cada valor do stream e convertê-lo na hora em outra coisa. Dê ao `map()` uma função para fazer a conversão, e ele retorna um novo stream, tipado para corresponder ao valor de retorno da função. Em vez de um stream de ints, agora você tem um stream de strings. Você pode encadear uma chamada de `listen()` no final, passar a função `print()` para ela, e agora você está imprimindo strings diretamente do stream, de forma assíncrona, à medida que chegam.

```dart
NumberCreator().stream
    .map((i) => 'String $i')
    .listen(print);
/*
OUTPUT: 
String 1
String 2
String 3
String 4
*/
```

Há uma infinidade de métodos que você pode encadear dessa forma. Se você quer imprimir apenas os números pares, por exemplo, pode usar [`where()`](https://api.dart.dev/stable/dart-async/Stream/where.html) para filtrar o stream. Dê a ele uma função de teste que retorne um booleano para cada elemento, e ele retorna um novo stream que inclui apenas os valores que passam no teste.

```dart
NumberCreator().stream
    .where((i) => i % 2 == 0)
    .map((i) => 'String $i')
    .listen(print);
/*
OUTPUT:
String 2
String 4
String 6
String 8
*/
```

O método [`distinct()`](https://api.dart.dev/stable/dart-async/Stream/distinct.html) é outro bom exemplo. Se você tem um app que usa uma store Redux, essa store emite novos objetos de estado do app em um stream `onChange`. Você pode usar `map()` para converter esse stream de objetos de estado em um stream de view models para uma parte do app. Depois, pode usar o método `distinct()` para obter um stream que filtra valores idênticos consecutivos (caso a store emita uma mudança que não afeta o subconjunto de dados do view model). Então, você pode escutar e atualizar a UI sempre que receber um novo view model.

```dart
myReduxStore.onChange
    .map((s) => MyViewModel(s))
    .distinct()
    .listen( /* update UI */ );
```

Há um monte de métodos adicionais integrados ao Dart que você pode usar para moldar e modificar seus streams. Além disso, quando estiver pronto para coisas ainda mais avançadas, existe o [pacote async](https://pub.dev/packages/async), mantido pela equipe do Dart e disponível no [pub.dev](https://pub.dev). Ele tem classes que podem mesclar dois streams, armazenar resultados em cache e realizar outros tipos de mágica baseada em streams.

<DashImage src="images/1WTHZRJjgF4qQvSDvY0Z9ow.webp" alt="Página do pub.dev do async 2.4.0 mostrando classes utilitárias para computações assíncronas." caption="Experimente o pacote async para mais mágica com streams." />


Para ainda mais magia com streams, dê uma olhada no [pacote stream_transform](https://pub.dev/packages/stream_transform).

## Criando streams {:#creating-streams}

Um tópico avançado merece uma menção aqui: como criar seus próprios streams. Assim como com futures, na maior parte do tempo você vai trabalhar com streams criados para você por bibliotecas de rede, bibliotecas de arquivos, gerenciamento de estado e assim por diante. Mas você também pode criar os seus, usando um [`StreamController`](https://api.dart.dev/stable/dart-async/StreamController-class.html).

Voltemos ao `NumberCreator` que temos usado até agora. Aqui está o código real dele:

```dart
class NumberCreator {
  NumberCreator() {
    Timer.periodic(Duration(seconds: 1), (t) {
      _controller.sink.add(_count);
      _count++;
    });
  }

  var _count = 1;
  final _controller = StreamController<int>();
  Stream<int> get stream => _controller.stream;
}

```

Como você pode ver, ele mantém uma contagem corrente e usa um timer para incrementar essa contagem a cada segundo. A parte interessante, porém, é o stream controller.

Um `StreamController` cria um stream novinho do zero e lhe dá acesso às duas pontas dele. Há a ponta do stream em si, por onde os dados chegam. (Temos usado essa ponta ao longo de todo este artigo.)

```
Stream<int> get stream => _controller.stream;
```


Depois, há a ponta do sink, por onde novos dados são adicionados ao stream:

```
_controller.sink.add(_count);
```


O `NumberCreator` aqui usa as duas. Quando o timer dispara, ele adiciona a contagem mais recente ao sink do controller, e então expõe o stream do controller por meio de uma propriedade pública, para que outros objetos possam se inscrever nele.

## Construindo widgets Flutter com streams {:#building-flutter-widgets-using-streams}

Agora que cobrimos criar, manipular e escutar streams, vamos falar sobre como usá-los para construir widgets no Flutter.

Se você assistiu ao vídeo anterior sobre futures, talvez se lembre do [`FutureBuilder`](https://api.flutter.dev/flutter/widgets/FutureBuilder-class.html). Você lhe dá um future e um método builder, e ele constrói widgets com base no estado do future.

Para streams, existe um widget semelhante chamado [`StreamBuilder`](https://api.flutter.dev/flutter/widgets/StreamBuilder-class.html). Dê a ele um stream e um método builder, e ele vai reconstruir seus filhos sempre que o stream emitir um novo valor.

```dart
StreamBuilder<String>(
  stream: NumberCreator().stream.map((i) => 'String $i'),
  builder: (context, snapshot) {
    /* Build widgets! */
  }
)
```

O parâmetro snapshot é um [`AsyncSnapshot`](https://api.flutter.dev/flutter/widgets/AsyncSnapshot-class.html), assim como no `FutureBuilder`. Você pode verificar a propriedade `connectionState` para ver se o stream ainda não enviou nenhum dado ou se já terminou por completo. Você pode usar a propriedade `hasError` para ver se o valor mais recente é um erro. E, claro, você pode tratar os valores de dados.

```dart
StreamBuilder<String>(
  stream: NumberCreator().stream.map((i) => 'String $i'),
  builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return Text('No data yet.');
    } else if (snapshot.connectionState == ConnectionState.done) {
      return Text('Done!');
    }
  }
)
```

O principal é garantir que o seu builder saiba lidar com todos os estados possíveis do stream. Quando você tiver isso, ele consegue reagir a tudo o que o stream fizer.

## Resumo {:#summary}

Este artigo falou sobre o que os streams representam, como você obtém valores de um stream, formas de manipular esses valores e como o `StreamBuilder` ajuda a usar valores de stream em um app Flutter.

Você pode saber mais sobre streams na documentação do Dart e do Flutter:

* No [dart.dev](https://dart.dev), veja o [tutorial de streams](https://dart.dev/tutorials/language/streams), o [tutorial de app de linha de comando](https://dart.dev/tutorials/server/cmdline) e a [seção de streams](https://dart.dev/guides/libraries/library-tour#stream) do tour pelas bibliotecas.

* No [flutter.dev](https://flutter.dev), veja [Trabalhe com WebSockets](https://flutter.dev/docs/cookbook/networking/web-sockets), que apresenta um exemplo que usa `StreamBuilder`.

Ou siga para o próximo vídeo da série *Asynchronous Programming in Dart*. Ele fala sobre `async` e `await`, duas palavras-chave que o Dart oferece para ajudar você a manter seu código assíncrono enxuto e fácil de ler.

<YoutubeEmbed id="SmTCmDMi4BY" title="Async/Await - Flutter in Focus" fullwidth="true"/>


*Muito obrigado a Andrew Brogdon, que criou o vídeo no qual este artigo é baseado.*

<DashImage src="images/1Q2-Ac9rjIDSuXzbrQqGkVA.webp" alt="Tela de um app Flutter intitulada Streams are awesome mostrando Done depois que o stream termina." />
