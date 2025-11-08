---
ia-translate: true
title: Criando streams no Dart
shortTitle: Criando streams
description: Um stream é uma sequência de resultados; aprenda como criar os seus próprios.
original-date: 2013-04-08
date: 2021-05-16
---

<style>
.comment {color:red;}
</style>

_Escrito por Lasse Nielsen <br>
Abril de 2013 (atualizado em Maio de 2021)_

A biblioteca dart:async contém dois tipos
que são importantes para muitas APIs do Dart:
[Stream]({{site.dart-api}}/dart-async/Stream-class.html) e
[Future.]({{site.dart-api}}/dart-async/Future-class.html)
Onde um Future representa o resultado de uma única computação,
um stream é uma _sequência_ de resultados.
Você escuta um stream para ser notificado dos resultados
(tanto dados quanto erros)
e do encerramento do stream.
Você também pode pausar enquanto escuta ou parar de escutar o stream
antes que ele esteja completo.

Mas este artigo não é sobre _usar_ streams.
É sobre criar seus próprios streams.
Você pode criar streams de algumas maneiras:

* Transformando streams existentes.
* Criando um stream do zero usando uma função `async*`.
* Criando um stream usando um `StreamController`.

Este artigo mostra o código para cada abordagem
e dá dicas para ajudá-lo a implementar seu stream corretamente.

Para ajuda sobre como usar streams, veja
[Programação Assíncrona: Streams](/libraries/async/using-streams).


## Transformando um stream existente

O caso comum para criar streams é que você já tem um stream,
e você quer criar um novo stream baseado nos eventos do stream original.
Por exemplo, você pode ter um stream de bytes que
você quer converter para um stream de strings decodificando a entrada com UTF-8.
A abordagem mais geral é criar um novo stream que
aguarda eventos no stream original e então
produz novos eventos. Exemplo:

<?code-excerpt "misc/lib/articles/creating-streams/line_stream_generator.dart (split-into-lines)"?>
```dart
/// Splits a stream of consecutive strings into lines.
///
/// The input string is provided in smaller chunks through
/// the `source` stream.
Stream<String> lines(Stream<String> source) async* {
  // Stores any partial line from the previous chunk.
  var partial = '';
  // Wait until a new chunk is available, then process it.
  await for (final chunk in source) {
    var lines = chunk.split('\n');
    lines[0] = partial + lines[0]; // Prepend partial line.
    partial = lines.removeLast(); // Remove new partial line.
    for (final line in lines) {
      yield line; // Add lines to output stream.
    }
  }
  // Add final partial line to output stream, if any.
  if (partial.isNotEmpty) yield partial;
}
```

Para muitas transformações comuns,
você pode usar métodos transformadores fornecidos por `Stream`
como `map()`, `where()`, `expand()` e `take()`.

Por exemplo, assuma que você tem um stream, `counterStream`,
que emite um contador crescente a cada segundo.
Veja como ele pode ser implementado:

<?code-excerpt "misc/lib/articles/creating-streams/stream_controller.dart (basic-usage)"?>
```dart
var counterStream = Stream<int>.periodic(
  const Duration(seconds: 1),
  (x) => x,
).take(15);
```

Para ver rapidamente os eventos, você pode usar código como este:

<?code-excerpt "misc/lib/articles/creating-streams/stream_controller.dart (basic-for-each)"?>
```dart
counterStream.forEach(print); // Print an integer every second, 15 times.
```

Para transformar os eventos do stream, você pode invocar um método transformador
como `map()` no stream antes de escutá-lo.
O método retorna um novo stream.

<?code-excerpt "misc/lib/articles/creating-streams/stream_controller.dart (use-map)"?>
```dart
// Double the integer in each event.
var doubleCounterStream = counterStream.map((int x) => x * 2);
doubleCounterStream.forEach(print);
```

Em vez de `map()`, você poderia usar qualquer outro método transformador,
como os seguintes:

<?code-excerpt "misc/lib/articles/creating-streams/stream_controller.dart (use-where)"?>
```dart
.where((int x) => x.isEven) // Retain only even integer events.
.expand((var x) => [x, x]) // Duplicate each event.
.take(5) // Stop after the first five events.
```

Frequentemente, um método transformador é tudo que você precisa.
No entanto, se você precisar de ainda mais controle sobre a transformação,
você pode especificar um
[StreamTransformer]({{site.dart-api}}/dart-async/StreamTransformer-class.html)
com o método `transform()` de `Stream`.
As bibliotecas da plataforma fornecem stream transformers para muitas tarefas comuns.
Por exemplo, o código a seguir usa os transformers `utf8.decoder` e `LineSplitter`
fornecidos pela biblioteca dart:convert.

<?code-excerpt "misc/lib/articles/creating-streams/stream_controller.dart (use-transform)"?>
```dart
Stream<List<int>> content = File('someFile.txt').openRead();
List<String> lines = await content
    .transform(utf8.decoder)
    .transform(const LineSplitter())
    .toList();
```


## Criando um stream do zero

Uma maneira de criar um novo stream é com
uma função geradora assíncrona (`async*`).
O stream é criado quando a função é chamada,
e o corpo da função começa a executar quando o stream é escutado.
Quando a função retorna, o stream fecha.
Até que a função retorne, ela pode emitir eventos no stream
usando declarações `yield` ou `yield*`.

Aqui está um exemplo primitivo que emite números em intervalos regulares:

<?code-excerpt "misc/lib/articles/creating-streams/stream_controller.dart (async-generator)" replace="/timedCounterGenerator/timedCounter/g"?>
```dart
Stream<int> timedCounter(Duration interval, [int? maxCount]) async* {
  int i = 0;
  while (true) {
    await Future.delayed(interval);
    yield i++;
    if (i == maxCount) break;
  }
}
```

{% comment %}
[PENDING: show code that uses it, so we have some context for
the mention of StreamSubscription?]
{% endcomment %}

Esta função retorna um `Stream`.
Quando esse stream é escutado, o corpo começa a executar.
Ele repetidamente atrasa pelo intervalo solicitado e então produz o próximo número.
Se o parâmetro `maxCount` for omitido, não há condição de parada no loop,
então o stream produz números cada vez maiores para sempre -
ou até que o listener cancele sua subscription.

Quando o listener cancela
(invocando `cancel()` no objeto `StreamSubscription`
retornado pelo método `listen()`),
então da próxima vez que o corpo alcançar uma declaração `yield`,
o `yield` age como uma declaração `return`.
Qualquer bloco `finally` envolvente é executado,
e a função sai.
Se a função tentar produzir um valor antes de sair,
isso falha e age como um return.

Quando a função finalmente sai, o future retornado pelo
método `cancel()` completa.
Se a função sai com um erro, o future completa com esse erro;
caso contrário, ele completa com `null`.

Outro exemplo mais útil é uma função que converte
uma sequência de futures para um stream:

<?code-excerpt "misc/lib/articles/creating-streams/stream_controller.dart (stream-from-futures)"?>
```dart
Stream<T> streamFromFutures<T>(Iterable<Future<T>> futures) async* {
  for (final future in futures) {
    var result = await future;
    yield result;
  }
}
```

Esta função pede ao iterable `futures` um novo future,
aguarda por esse future, emite o valor resultante e então faz loop.
Se um future completa com um erro, então o stream completa com esse erro.

É raro ter uma função `async*` construindo um stream do nada.
Ela precisa obter seus dados de algum lugar,
e na maioria das vezes esse lugar é outro stream.
Em alguns casos, como a sequência de futures acima,
os dados vêm de outras fontes de eventos assíncronos.
Em muitos casos, no entanto, uma função `async*` é muito simplista para
facilmente lidar com múltiplas fontes de dados.
É aí que a classe `StreamController` entra.


## Usando um StreamController

Se os eventos do seu stream vêm de diferentes partes do seu programa,
e não apenas de um stream ou futures que podem ser percorridos por uma função `async`,
então use um
[StreamController]({{site.dart-api}}/dart-async/StreamController-class.html)
para criar e popular o stream.

Um `StreamController` te dá um novo stream
e uma maneira de adicionar eventos ao stream a qualquer momento, e de qualquer lugar.
O stream tem toda a lógica necessária para lidar com listeners e pausas.
Você retorna o stream e mantém o controller para si mesmo.

O exemplo a seguir
(de [stream_controller_bad.dart][])
mostra um uso básico, embora defeituoso, de `StreamController`
para implementar a função `timedCounter()` dos exemplos anteriores.
Este código cria um stream para retornar,
e então alimenta dados nele baseado em eventos de timer,
que não são futures nem eventos de stream.

[stream_controller_bad.dart]: {{site.repo.this}}/blob/main/examples/misc/lib/articles/creating-streams/stream_controller_bad.dart

<?code-excerpt "misc/lib/articles/creating-streams/stream_controller_bad.dart (flawed-stream)"?>
```dart tag=bad
// NOTE: This implementation is FLAWED!
// It starts before it has subscribers, and it doesn't implement pause.
Stream<int> timedCounter(Duration interval, [int? maxCount]) {
  var controller = StreamController<int>();
  int counter = 0;
  void tick(Timer timer) {
    counter++;
    controller.add(counter); // Ask stream to send counter values as event.
    if (maxCount != null && counter >= maxCount) {
      timer.cancel();
      controller.close(); // Ask stream to shut down and tell listeners.
    }
  }

  Timer.periodic(interval, tick); // BAD: Starts before it has subscribers.
  return controller.stream;
}
```

Como antes, você pode usar o stream retornado por `timedCounter()` assim:
{% comment %}
**[PENDING: Did we show this before?]**
{% endcomment %}

<?code-excerpt "misc/lib/articles/creating-streams/stream_controller_bad.dart (using-stream)"?>
```dart
var counterStream = timedCounter(const Duration(seconds: 1), 15);
counterStream.listen(print); // Print an integer every second, 15 times.
```

Esta implementação de `timedCounter()` tem
alguns problemas:

* Ela começa a produzir eventos antes de ter subscribers.
* Ela continua produzindo eventos mesmo se o subscriber solicitar uma pausa.

Como mostram as próximas seções,
você pode corrigir ambos esses problemas especificando
callbacks como `onListen` e `onPause`
ao criar o `StreamController`.


### Esperando por uma subscription

Como regra, streams devem esperar por subscribers antes de iniciar seu trabalho.
Uma função `async*` faz isso automaticamente,
mas ao usar um `StreamController`,
você está no controle total e pode adicionar eventos mesmo quando não deveria.
Quando um stream não tem subscriber,
seu `StreamController` armazena eventos em buffer,
o que pode levar a um vazamento de memória
se o stream nunca obtiver um subscriber.

Tente mudar o código que usa o stream para o seguinte:

<?code-excerpt "misc/lib/articles/creating-streams/stream_controller_bad.dart (pre-subscribe-problem)"?>
```dart
void listenAfterDelay() async {
  var counterStream = timedCounter(const Duration(seconds: 1), 15);
  await Future.delayed(const Duration(seconds: 5));

  // After 5 seconds, add a listener.
  await for (final n in counterStream) {
    print(n); // Print an integer every second, 15 times.
  }
}
```

Quando este código executa,
nada é impresso pelos primeiros 5 segundos,
embora o stream esteja fazendo trabalho.
Então o listener é adicionado,
e os primeiros 5 eventos são impressos de uma vez,
já que foram armazenados em buffer pelo `StreamController`.

Para ser notificado de subscriptions, especifique um
argumento `onListen` quando você criar o `StreamController`.
O callback `onListen` é chamado
quando o stream obtém seu primeiro subscriber.
Se você especificar um callback `onCancel`,
ele é chamado quando o controller perde seu último subscriber.
No exemplo anterior,
`Timer.periodic()`
deve mover para um handler `onListen`,
como mostrado na próxima seção.


### Respeitando o estado de pausa

Evite produzir eventos quando o listener solicitou uma pausa.
Uma função `async*` pausa automaticamente em uma declaração `yield`
enquanto a subscription do stream está pausada.
Um `StreamController`, por outro lado, armazena eventos em buffer durante a pausa.
Se o código que fornece os eventos não respeita a pausa,
o tamanho do buffer pode crescer indefinidamente.
Além disso, se o listener parar de escutar logo após pausar,
então o trabalho gasto criando o buffer é desperdiçado.

Para ver o que acontece sem suporte a pausa,
tente mudar o código que usa o stream para o seguinte:

<?code-excerpt "misc/lib/articles/creating-streams/stream_controller_bad.dart (pause-problem)"?>
```dart
void listenWithPause() {
  var counterStream = timedCounter(const Duration(seconds: 1), 15);
  late StreamSubscription<int> subscription;

  subscription = counterStream.listen((int counter) {
    print(counter); // Print an integer every second.
    if (counter == 5) {
      // After 5 ticks, pause for five seconds, then resume.
      subscription.pause(Future.delayed(const Duration(seconds: 5)));
    }
  });
}
```

Quando os cinco segundos de pausa terminam,
os eventos disparados durante esse tempo são todos recebidos de uma vez.
Isso acontece porque a fonte do stream não respeita pausas
e continua adicionando eventos ao stream.
Então o stream armazena os eventos em buffer,
e então esvazia seu buffer quando o stream fica despausado.

A seguinte versão de `timedCounter()`
(de [stream_controller.dart][])
implementa pausa usando os
callbacks `onListen`, `onPause`, `onResume` e `onCancel`
no `StreamController`.

[stream_controller.dart]: {{site.repo.this}}/blob/main/examples/misc/lib/articles/creating-streams/stream_controller.dart

<?code-excerpt "misc/lib/articles/creating-streams/stream_controller.dart (better-stream)"?>
```dart
Stream<int> timedCounter(Duration interval, [int? maxCount]) {
  late StreamController<int> controller;
  Timer? timer;
  int counter = 0;

  void tick(_) {
    counter++;
    controller.add(counter); // Ask stream to send counter values as event.
    if (counter == maxCount) {
      timer?.cancel();
      controller.close(); // Ask stream to shut down and tell listeners.
    }
  }

  void startTimer() {
    timer = Timer.periodic(interval, tick);
  }

  void stopTimer() {
    timer?.cancel();
    timer = null;
  }

  controller = StreamController<int>(
    onListen: startTimer,
    onPause: stopTimer,
    onResume: startTimer,
    onCancel: stopTimer,
  );

  return controller.stream;
}
```

Execute este código com a função `listenWithPause()` acima.
Você verá que ele para de contar enquanto pausado,
e retoma bem depois.

Você deve usar todos os listeners—`onListen`,
`onCancel`, `onPause` e `onResume`—para ser
notificado de mudanças no estado de pausa.
A razão é que se os
estados de subscription e pausa mudarem ao mesmo tempo,
apenas o callback `onListen` ou `onCancel` é chamado.


## Dicas finais

Ao criar um stream sem usar uma função async*,
mantenha essas dicas em mente:

* Tenha cuidado ao usar um controller síncrono—por exemplo,
  um criado usando `StreamController(sync: true)`.
  Quando você envia um evento em um controller síncrono não pausado
  (por exemplo, usando os métodos `add()`, `addError()` ou `close()` definidos por
  [EventSink]({{site.dart-api}}/dart-async/EventSink-class.html)),
  o evento é enviado imediatamente para todos os listeners no stream.
  Listeners de `Stream` nunca devem ser chamados até que
  o código que adicionou o listener tenha retornado completamente,
  e usar um controller síncrono no momento errado pode
  quebrar essa promessa e causar falha em código bom.
  Evite usar controllers síncronos.

* Se você usar `StreamController`,
  o callback `onListen` é chamado antes
  que a chamada `listen` retorne o `StreamSubscription`.
  Não deixe o callback `onListen` depender
  de que a subscription já exista.
  Por exemplo, no código a seguir,
  um evento `onListen` dispara
  (e `handler` é chamado)
  antes que a variável `subscription`
  tenha um valor válido.

  <?code-excerpt "misc/lib/articles/creating-streams/stream_controller.dart (stream-listen-hint)"?>
  ```dart
  subscription = stream.listen(handler);
  ```

* Os callbacks `onListen`, `onPause`, `onResume` e `onCan`
  definidos por `StreamController` são
  chamados pelo stream quando o estado do listener do stream muda,
  mas nunca durante o disparo de um evento
  ou durante a chamada de outro handler de mudança de estado.
  Nesses casos, o callback de mudança de estado é atrasado até que
  o callback anterior esteja completo.

* Não tente implementar a interface `Stream` você mesmo.
  É fácil errar a interação entre eventos, callbacks,
  e adicionar e remover listeners de maneiras sutis.
  Sempre use um stream existente, possivelmente de um `StreamController`,
  para implementar a chamada `listen` de um novo stream.

* Embora seja possível criar classes que estendem `Stream` com
  mais funcionalidade estendendo a classe `Stream` e
  implementando o método `listen` e a funcionalidade extra em cima,
  isso geralmente não é recomendado porque
  introduz um novo tipo que os usuários precisam considerar.
  Em vez de uma classe que _é_ um `Stream` (e mais),
  você pode frequentemente fazer uma classe que _tem_ um `Stream` (e mais).

{% comment %}
The tests for this article are at /src/tests/site/articles/creating-streams.
{% endcomment %}
