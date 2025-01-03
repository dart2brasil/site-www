---
ia-translate: true
title: Criando streams em Dart
description: Um stream (fluxo) é uma sequência de resultados; aprenda como criar o seu próprio.
original-date: 2013-04-08
date: 2021-05-16
---

<style>
.comment {color:red;}
</style>

_Escrito por Lasse Nielsen <br>
Abril de 2013 (atualizado em Maio de 2021)_

A biblioteca dart:async contém dois tipos
que são importantes para muitas APIs Dart:
[Stream]({{site.dart-api}}/dart-async/Stream-class.html) e
[Future.]({{site.dart-api}}/dart-async/Future-class.html)
Onde um Future representa o resultado de um único cálculo,
um stream é uma _sequência_ de resultados.
Você escuta em um stream para ser notificado dos resultados
(tanto dados quanto erros)
e do encerramento do stream.
Você também pode pausar enquanto escuta ou parar de escutar o stream
antes que ele seja concluído.

Mas este artigo não é sobre _usar_ streams.
É sobre criar seus próprios streams.
Você pode criar streams de algumas maneiras:

* Transformando streams existentes.
* Criando um stream do zero usando uma função `async*`.
* Criando um stream usando um `StreamController`.

Este artigo mostra o código para cada abordagem
e dá dicas para ajudá-lo a implementar seu stream corretamente.

Para obter ajuda sobre como usar streams, veja
[Programação Assíncrona: Streams](/libraries/async/using-streams).


## Transformando um stream existente {:#transforming-an-existing-stream}

O caso comum para criar streams é que você já tem um stream,
e você quer criar um novo stream baseado nos eventos do stream original.
Por exemplo, você pode ter um stream de bytes que
você quer converter em um stream de strings decodificando a entrada em UTF-8.
A abordagem mais geral é criar um novo stream que
espera por eventos no stream original e então
emite novos eventos. Exemplo:

<?code-excerpt "misc/lib/articles/creating-streams/line_stream_generator.dart (split-into-lines)"?>
```dart
/// Divide um stream de strings consecutivas em linhas.
///
/// A string de entrada é fornecida em partes menores através
/// do stream `source`.
Stream<String> lines(Stream<String> source) async* {
  // Armazena qualquer linha parcial do bloco anterior.
  var partial = '';
  // Espera até que um novo bloco esteja disponível, então o processa.
  await for (final chunk in source) {
    var lines = chunk.split('\n');
    lines[0] = partial + lines[0]; // Adiciona a linha parcial.
    partial = lines.removeLast(); // Remove a nova linha parcial.
    for (final line in lines) {
      yield line; // Adiciona linhas ao stream de saída.
    }
  }
  // Adiciona a linha parcial final ao stream de saída, se houver.
  if (partial.isNotEmpty) yield partial;
}
```

Para muitas transformações comuns,
você pode usar métodos de transformação fornecidos por `Stream`
como `map()`, `where()`, `expand()` e `take()`.

Por exemplo, suponha que você tenha um stream, `counterStream`,
que emite um contador crescente a cada segundo.
Veja como ele pode ser implementado:

<?code-excerpt "misc/lib/articles/creating-streams/stream_controller.dart (basic-usage)"?>
```dart
var counterStream =
    Stream<int>.periodic(const Duration(seconds: 1), (x) => x).take(15);
```

Para ver rapidamente os eventos, você pode usar um código como este:

<?code-excerpt "misc/lib/articles/creating-streams/stream_controller.dart (basic-for-each)"?>
```dart
counterStream.forEach(print); // Imprime um inteiro a cada segundo, 15 vezes.
```

Para transformar os eventos do stream, você pode invocar um método de transformação
como `map()` no stream antes de ouvi-lo.
O método retorna um novo stream.

<?code-excerpt "misc/lib/articles/creating-streams/stream_controller.dart (use-map)"?>
```dart
// Dobra o inteiro em cada evento.
var doubleCounterStream = counterStream.map((int x) => x * 2);
doubleCounterStream.forEach(print);
```

Em vez de `map()`, você pode usar qualquer outro método de transformação,
como os seguintes:

<?code-excerpt "misc/lib/articles/creating-streams/stream_controller.dart (use-where)"?>
```dart
.where((int x) => x.isEven) // Retém apenas eventos de inteiros pares.
.expand((var x) => [x, x]) // Duplica cada evento.
.take(5) // Para após os primeiros cinco eventos.
```

Muitas vezes, um método de transformação é tudo o que você precisa.
No entanto, se você precisar de ainda mais controle sobre a transformação,
você pode especificar um
[StreamTransformer]({{site.dart-api}}/dart-async/StreamTransformer-class.html)
com o método `transform()` de `Stream`.
As bibliotecas da plataforma fornecem stream transformers (transformadores de stream) para muitas tarefas comuns.
Por exemplo, o código a seguir usa os transformadores `utf8.decoder` e `LineSplitter`
fornecidos pela biblioteca dart:convert.

<?code-excerpt "misc/lib/articles/creating-streams/stream_controller.dart (use-transform)"?>
```dart
Stream<List<int>> content = File('someFile.txt').openRead();
List<String> lines = await content
    .transform(utf8.decoder)
    .transform(const LineSplitter())
    .toList();
```


## Criando um stream do zero {:#creating-a-stream-from-scratch}

Uma maneira de criar um novo stream é com
uma função geradora assíncrona (`async*`).
O stream é criado quando a função é chamada,
e o corpo da função começa a ser executado quando o stream é escutado.
Quando a função retorna, o stream é fechado.
Até que a função retorne, ela pode emitir eventos no stream usando
as declarações `yield` ou `yield*`.

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

Essa função retorna um `Stream`.
Quando esse stream é escutado, o corpo começa a ser executado.
Ele atrasa repetidamente pelo intervalo solicitado e então emite o próximo número.
Se o parâmetro `maxCount` for omitido, não há condição de parada no loop,
portanto, o stream emite números cada vez maiores para sempre -
ou até que o listener cancele sua assinatura.

Quando o listener cancela
(invocando `cancel()` no objeto `StreamSubscription`
retornado pelo método `listen()`),
então, na próxima vez que o corpo atingir uma declaração `yield`,
o `yield` age como uma declaração `return`.
Qualquer bloco `finally` envolvente é executado,
e a função sai.
Se a função tentar emitir um valor antes de sair,
isso falha e age como um retorno.

Quando a função finalmente sai, o future (promessa) retornado por
o método `cancel()` é concluído.
Se a função sair com um erro, o future é concluído com esse erro;
caso contrário, ele é concluído com `null`.

Outro exemplo mais útil é uma função que converte
uma sequência de futures em um stream:

<?code-excerpt "misc/lib/articles/creating-streams/stream_controller.dart (stream-from-futures)"?>
```dart
Stream<T> streamFromFutures<T>(Iterable<Future<T>> futures) async* {
  for (final future in futures) {
    var result = await future;
    yield result;
  }
}
```

Essa função pergunta ao iterável `futures` por um novo future,
espera por esse future, emite o valor resultante e então faz um loop.
Se um future for concluído com um erro, o stream será concluído com esse erro.

É raro ter uma função `async*` construindo um stream do nada.
Ela precisa obter seus dados de algum lugar,
e na maioria das vezes esse lugar é outro stream.
Em alguns casos, como na sequência de futures acima,
os dados vêm de outras fontes de eventos assíncronos.
Em muitos casos, entretanto, uma função `async*` é muito simplista para
lidar facilmente com múltiplas fontes de dados.
É aí que entra a classe `StreamController`.


## Usando um StreamController {:#using-a-streamcontroller}

Se os eventos do seu stream vêm de diferentes partes do seu programa,
e não apenas de um stream ou futures que podem ser percorridos por uma função `async`,
então use um
[StreamController]({{site.dart-api}}/dart-async/StreamController-class.html)
para criar e popular o stream.

Um `StreamController` fornece um novo stream
e uma maneira de adicionar eventos ao stream em qualquer ponto e de qualquer lugar.
O stream tem toda a lógica necessária para lidar com listeners e pausas.
Você retorna o stream e mantém o controller para si.

O exemplo a seguir
(de [stream_controller_bad.dart][])
mostra um uso básico, embora falho, de `StreamController`
para implementar a função `timedCounter()` dos exemplos anteriores.
Este código cria um stream para retornar,
e então alimenta dados nele com base em eventos de timer,
que não são nem futures nem eventos de stream.

[stream_controller_bad.dart]: {{site.repo.this}}/blob/main/examples/misc/lib/articles/creating-streams/stream_controller_bad.dart

<?code-excerpt "misc/lib/articles/creating-streams/stream_controller_bad.dart (flawed-stream)"?>
```dart tag=bad
// OBSERVAÇÃO: Esta implementação é FALHA!
// Ela começa antes de ter assinantes e não implementa pausa.
Stream<int> timedCounter(Duration interval, [int? maxCount]) {
  var controller = StreamController<int>();
  int counter = 0;
  void tick(Timer timer) {
    counter++;
    controller.add(counter); // Pede ao stream para enviar valores de contador como evento.
    if (maxCount != null && counter >= maxCount) {
      timer.cancel();
      controller.close(); // Pede ao stream para desligar e avisar os listeners.
    }
  }

  Timer.periodic(interval, tick); // RUIM: Começa antes de ter assinantes.
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
counterStream.listen(print); // Imprime um inteiro a cada segundo, 15 vezes.
```

Esta implementação de `timedCounter()` tem
alguns problemas:

* Ela começa a produzir eventos antes de ter assinantes.
* Ela continua produzindo eventos mesmo se o assinante solicitar uma pausa.

Como as próximas seções mostram,
você pode corrigir esses dois problemas especificando
callbacks como `onListen` e `onPause`
ao criar o `StreamController`.


### Esperando por uma assinatura {:#waiting-for-a-subscription}

Como regra, os streams devem esperar por assinantes antes de iniciar seu trabalho.
Uma função `async*` faz isso automaticamente,
mas ao usar um `StreamController`,
você está no controle total e pode adicionar eventos mesmo quando não deveria.
Quando um stream não tem assinante,
seu `StreamController` armazena eventos em buffer,
o que pode levar a um vazamento de memória
se o stream nunca conseguir um assinante.

Tente alterar o código que usa o stream para o seguinte:

<?code-excerpt "misc/lib/articles/creating-streams/stream_controller_bad.dart (pre-subscribe-problem)"?>
```dart
void listenAfterDelay() async {
  var counterStream = timedCounter(const Duration(seconds: 1), 15);
  await Future.delayed(const Duration(seconds: 5));

  // Após 5 segundos, adiciona um listener.
  await for (final n in counterStream) {
    print(n); // Imprime um inteiro a cada segundo, 15 vezes.
  }
}
```

Quando este código é executado,
nada é impresso nos primeiros 5 segundos,
embora o stream esteja fazendo trabalho.
Então o listener é adicionado,
e os primeiros 5 ou mais eventos são impressos todos de uma vez,
já que foram armazenados em buffer pelo `StreamController`.

Para ser notificado de assinaturas, especifique um
argumento `onListen` ao criar o `StreamController`.
O callback `onListen` é chamado
quando o stream recebe seu primeiro assinante.
Se você especificar um callback `onCancel`,
ele é chamado quando o controller perde seu último assinante.
No exemplo anterior,
`Timer.periodic()`
deve mudar para um manipulador `onListen`,
como mostrado na próxima seção.


### Honrando o estado de pausa {:#honoring-the-pause-state}

Evite produzir eventos quando o listener solicitou uma pausa.
Uma função `async*` pausa automaticamente em uma declaração `yield`
enquanto a assinatura do stream está pausada.
Um `StreamController`, por outro lado, armazena eventos em buffer durante a pausa.
Se o código que fornece os eventos não respeitar a pausa,
o tamanho do buffer pode crescer indefinidamente.
Além disso, se o listener parar de escutar logo após a pausa,
o trabalho gasto na criação do buffer é desperdiçado.

Para ver o que acontece sem suporte para pausa,
tente alterar o código que usa o stream para o seguinte:

<?code-excerpt "misc/lib/articles/creating-streams/stream_controller_bad.dart (pause-problem)"?>
```dart
void listenWithPause() {
  var counterStream = timedCounter(const Duration(seconds: 1), 15);
  late StreamSubscription<int> subscription;

  subscription = counterStream.listen((int counter) {
    print(counter); // Imprime um inteiro a cada segundo.
    if (counter == 5) {
      // Após 5 ticks, pausa por cinco segundos e depois continua.
      subscription.pause(Future.delayed(const Duration(seconds: 5)));
    }
  });
}
```

Quando os cinco segundos de pausa terminam,
os eventos disparados durante esse tempo são todos recebidos de uma vez.
Isso acontece porque a fonte do stream não respeita as pausas
e continua adicionando eventos ao stream.
Portanto, o stream armazena os eventos em buffer,
e então esvazia seu buffer quando o stream deixa de ser pausado.

A seguinte versão de `timedCounter()`
(de [stream_controller.dart][])
implementa a pausa usando os callbacks
`onListen`, `onPause`, `onResume` e `onCancel`
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
    controller.add(counter); // Pede ao stream para enviar valores de contador como evento.
    if (counter == maxCount) {
      timer?.cancel();
      controller.close(); // Pede ao stream para desligar e avisar os listeners.
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
      onCancel: stopTimer);

  return controller.stream;
}
```

Execute este código com a função `listenWithPause()` acima.
Você verá que ele para de contar enquanto pausado,
e continua normalmente depois.

Você deve usar todos os listeners - `onListen`,
`onCancel`, `onPause` e `onResume` - para ser
notificado de mudanças no estado de pausa.
A razão é que se o
assinatura e os estados de pausa mudarem ao mesmo tempo,
apenas o callback `onListen` ou `onCancel` é chamado.


## Dicas finais {:#final-hints}

Ao criar um stream sem usar uma função async*,
tenha estas dicas em mente:

* Tenha cuidado ao usar um controller síncrono - por exemplo,
  um criado usando `StreamController(sync: true)`.
  Quando você envia um evento em um controller síncrono não pausado
  (por exemplo, usando os métodos `add()`, `addError()` ou `close()` definidos por
  [EventSink]({{site.dart-api}}/dart-async/EventSink-class.html)),
  o evento é enviado imediatamente para todos os listeners no stream.
  Os listeners de `Stream` nunca devem ser chamados até que
  o código que adicionou o listener tenha retornado totalmente,
  e usar um controller síncrono no momento errado pode
  quebrar essa promessa e fazer com que um código bom falhe.
  Evite usar controllers síncronos.

* Se você usar `StreamController`,
  o callback `onListen` é chamado antes que
  a chamada `listen` retorne o `StreamSubscription`.
  Não deixe o callback `onListen` depender
  da assinatura já existente.
  Por exemplo, no código a seguir,
  um evento `onListen` é disparado
  (e `handler` é chamado)
  antes que a variável `subscription`
  tenha um valor válido.

  <?code-excerpt "misc/lib/articles/creating-streams/stream_controller.dart (stream-listen-hint)"?>
  ```dart
  subscription = stream.listen(handler);
  ```

* Os callbacks `onListen`, `onPause`, `onResume` e `onCancel`
  definidos por `StreamController` são
  chamados pelo stream quando o estado do listener do stream muda,
  mas nunca durante o disparo de um evento
  ou durante a chamada de outro manipulador de mudança de estado.
  Nesses casos, o callback de mudança de estado é atrasado até que
  o callback anterior seja concluído.

* Não tente implementar a interface `Stream` você mesmo.
  É fácil errar sutilmente a interação entre eventos, callbacks,
  e adicionar e remover listeners.
  Sempre use um stream existente, possivelmente de um `StreamController`,
  para implementar a chamada `listen` de um novo stream.

* Embora seja possível criar classes que estendem `Stream` com
  mais funcionalidade estendendo a classe `Stream` e
  implementando o método `listen` e a funcionalidade extra em cima,
  isso geralmente não é recomendado porque
  ele introduz um novo tipo que os usuários precisam considerar.
  Em vez de uma classe que _é_ um `Stream` (e mais),
  você pode muitas vezes fazer uma classe que _tem_ um `Stream` (e mais).

{% comment %}
The tests for this article are at /src/tests/site/articles/creating-streams.
{% endcomment %}
