---
ia-translate: true
title: Concorrência em Dart
description: >-
  Use isolates para habilitar a execução de código paralelo em múltiplos núcleos de processador.
shortTitle: Concurrency
lastVerified: 2023-12-14
prevpage:
  url: /language/modifier-reference
  title: Class modifiers reference
nextpage:
  url: /language/async
  title: Async
---

<?code-excerpt path-base="concurrency"?>

Esta página contém uma visão geral conceitual de como a programação concorrente funciona em
Dart. Ela explica o event-loop, recursos de linguagem assíncronos e isolates de
um nível alto. Para exemplos de código mais práticos do uso de concorrência em Dart,
leia a página [Programação assíncrona](/language/async) e a
página [Isolates](/language/isolates).

Programação concorrente em Dart refere-se tanto a APIs assíncronas, como `Future`
e `Stream`, quanto a *isolates*, que permitem mover processos para núcleos
separados.

Todo código Dart é executado em isolates, começando no isolate main padrão,
e opcionalmente expandindo para quaisquer isolates subsequentes que você
crie explicitamente. Quando você cria um novo isolate,
ele tem sua própria memória isolada e seu próprio event loop.
O event loop é o que torna a programação assíncrona e
concorrente possível em Dart.

## Event Loop

O modelo de runtime do Dart é baseado em um event loop.
O event loop é responsável por executar o código do seu programa,
coletar e processar eventos, e mais.

Conforme sua aplicação é executada, todos os eventos são adicionados a uma fila,
chamada *event queue*.
Eventos podem ser qualquer coisa, desde requisições para repintar a UI,
até toques e teclas do usuário, até I/O do disco.
Como seu aplicativo não pode prever em que ordem os eventos acontecerão,
o event loop processa eventos na ordem em que são enfileirados, um de cada vez.

![A figure showing events being fed, one by one, into the event loop](/assets/img/language/concurrency/event-loop.png){:.diagram-wrap}

A forma como o event loop funciona se assemelha a este código:

```dart
while (eventQueue.waitForEvent()) {
  eventQueue.processNextEvent();
}
```

Este exemplo de event loop é síncrono e é executado em uma única thread.
No entanto, a maioria das aplicações Dart precisa fazer mais de uma coisa de cada vez.
Por exemplo, uma aplicação cliente pode precisar executar uma requisição HTTP,
enquanto também ouve um usuário tocar em um botão.
Para lidar com isso, o Dart oferece muitas APIs assíncronas,
como [Futures, Streams e async-await](/language/async).
Essas APIs são construídas em torno deste event loop.

Por exemplo, considere fazer uma requisição de rede:

```dart
http.get('https://example.com').then((response) {
  if (response.statusCode == 200) {
    print('Success!');
  }
}
```

Quando este código chega ao event loop, ele imediatamente chama a
primeira cláusula, `http.get`, e retorna um `Future`.
Ele também diz ao event loop para manter o callback na cláusula `then()`
até que a requisição HTTP seja resolvida. Quando isso acontecer, ele deve
executar esse callback, passando o resultado da requisição como argumento.

![Figure showing async events being added to an event loop and holding onto a callback to execute later .](/assets/img/language/concurrency/async-event-loop.png){:.diagram-wrap}

Este mesmo modelo é geralmente como o event loop lida com todos os outros
eventos assíncronos em Dart, como objetos [`Stream`][].

[`Stream`]: {{site.dart-api}}/dart-async/Stream-class.html

## Programação assíncrona

Esta seção resume os diferentes tipos e sintaxes de programação assíncrona em Dart.
Se você já está familiarizado com `Future`, `Stream` e async-await,
então você pode pular para a [seção de isolates][isolates section].

[isolates section]: #isolates

### Futures

Um `Future` representa o resultado de uma operação assíncrona que eventualmente
será concluída com um valor ou um erro.

Neste código de exemplo, o tipo de retorno de `Future<String>` representa uma
promessa de eventualmente fornecer um valor `String` (ou erro).

<?code-excerpt "lib/future_syntax.dart (read-async)"?>
```dart
Future<String> _readFileAsync(String filename) {
  final file = File(filename);

  // .readAsString() returns a Future.
  // .then() registers a callback to be executed when `readAsString` resolves.
  return file.readAsString().then((contents) {
    return contents.trim();
  });
}
```

### A sintaxe async-await

As keywords `async` e `await` fornecem uma maneira declarativa de definir
funções assíncronas e usar seus resultados.

Aqui está um exemplo de código síncrono
que bloqueia enquanto espera por I/O de arquivo:

<?code-excerpt "lib/sync_number_of_keys.dart (blocking)"?>
```dart
const String filename = 'with_keys.json';

void main() {
  // Read some data.
  final fileData = _readFileSync();
  final jsonData = jsonDecode(fileData);

  // Use that data.
  print('Number of JSON keys: ${jsonData.length}');
}

String _readFileSync() {
  final file = File(filename);
  final contents = file.readAsStringSync();
  return contents.trim();
}
```

Aqui está um código semelhante, mas com mudanças (destacadas) para torná-lo assíncrono:

<?code-excerpt "lib/async_number_of_keys.dart (non-blocking)" replace="/async|await|readAsString\(\)/[!$&!]/g; /Future<\w+\W/[!$&!]/g;"?>
```dart
const String filename = 'with_keys.json';

void main() [!async!] {
  // Read some data.
  final fileData = [!await!] _readFileAsync();
  final jsonData = jsonDecode(fileData);

  // Use that data.
  print('Number of JSON keys: ${jsonData.length}');
}

[!Future<String>!] _readFileAsync() [!async!] {
  final file = File(filename);
  final contents = [!await!] file.[!readAsString()!];
  return contents.trim();
}
```

A função `main()` usa a keyword `await` na frente de `_readFileAsync()`
para permitir que outro código Dart (como manipuladores de eventos) use a CPU enquanto código nativo
(I/O de arquivo) é executado. Usar `await` também tem o efeito de converter
o `Future<String>` retornado por `_readFileAsync()` em uma `String`. Como
resultado, a variável `contents` tem o tipo implícito `String`.

:::note
A keyword `await` funciona apenas em funções que têm `async` antes do
corpo da função.
:::

Como a figura a seguir mostra, o código Dart pausa enquanto `readAsString()`
executa código não-Dart, tanto no runtime do Dart quanto no sistema operacional.
Uma vez que `readAsString()` retorna um valor, a execução do código Dart é retomada.

![Flowchart-like figure showing app code executing from start to exit, waiting for native I/O in between](/assets/img/language/concurrency/basics-await.png){:.diagram-wrap}

### Streams

O Dart também suporta código assíncrono na forma de streams. Streams
fornecem valores no futuro e repetidamente ao longo do tempo. Uma promessa de fornecer uma
série de valores `int` ao longo do tempo tem o tipo `Stream<int>`.

No exemplo a seguir, o stream criado com `Stream.periodic`
emite repetidamente um novo valor `int` a cada segundo.

<?code-excerpt "lib/stream_syntax.dart"?>
```dart
Stream<int> stream = Stream.periodic(const Duration(seconds: 1), (i) => i * i);
```

#### await-for e yield

Await-for é um tipo de loop for que executa cada iteração subsequente do
loop conforme novos valores são fornecidos. Em outras palavras, é usado para "iterar sobre"
streams. Neste exemplo, um novo valor será emitido da função
`sumStream` conforme novos valores são emitidos do stream fornecido como
argumento. A keyword `yield` é usada em vez de `return` em funções que
retornam streams de valores.

<?code-excerpt "lib/await_for_syntax.dart"?>
```dart
Stream<int> sumStream(Stream<int> stream) async* {
  var sum = 0;
  await for (final value in stream) {
    yield sum += value;
  }
}
```

Se você quiser aprender mais sobre como usar `async`, `await`, `Stream`s e
`Future`s, confira o [tutorial de programação assíncrona][asynchronous programming tutorial].

[asynchronous programming tutorial]: /libraries/async/async-await

## Isolates

O Dart suporta concorrência via isolates, além de [APIs assíncronas](#asynchronous-programming).
A maioria dos dispositivos modernos tem CPUs
multi-core. Para aproveitar múltiplos núcleos, desenvolvedores às vezes usam
threads de memória compartilhada executando concorrentemente. No entanto, concorrência de estado compartilhado é
[propensa a erros](https://en.wikipedia.org/wiki/Race_condition#In_software) e pode
levar a código complicado.

Em vez de threads, todo código Dart é executado dentro de isolates.
Usando isolates, seu código Dart pode executar múltiplas tarefas independentes de uma vez,
usando núcleos de processador adicionais se estiverem disponíveis.
Isolates são como threads ou processos, mas cada isolate tem sua própria memória
e uma única thread executando um event loop.

Cada isolate tem seus próprios campos globais,
garantindo que nenhum estado em um isolate seja acessível
de qualquer outro isolate. Isolates só podem se comunicar uns com os outros via passagem de
mensagens. Nenhum estado compartilhado entre isolates significa que complexidades de concorrência como
[mutexes ou locks](https://en.wikipedia.org/wiki/Lock_(computer_science))
e [data races](https://en.wikipedia.org/wiki/Race_condition#Data_race)
não ocorrerão em Dart. Dito isso, isolates não previnem race conditions
completamente. Para mais informações sobre este modelo de concorrência, leia sobre
o [modelo Actor](https://en.wikipedia.org/wiki/Actor_model).

:::note Platform note
Apenas a [plataforma Dart Native][Dart Native platform] implementa isolates.
Para saber mais sobre a plataforma Dart Web,
veja a seção [Concorrência na web](#concurrency-on-the-web).
:::

[Dart Native platform]: /overview#platform

### O isolate main

Na maioria dos casos, você não precisa pensar sobre isolates de forma alguma. Programas Dart executam
no isolate main por padrão. É a thread onde um programa começa a executar
e executar, como mostrado na figura a seguir:

![A figure showing a main isolate, which runs `main()`, responds to events, and then exits](/assets/img/language/concurrency/basics-main-isolate.png){:.diagram-wrap}

Mesmo programas de isolate único podem executar suavemente. Antes de continuar para a próxima
linha de código, esses aplicativos usam [async-await][async-await] para esperar operações assíncronas
serem concluídas. Um aplicativo bem-comportado inicia rapidamente, chegando ao event loop o mais
rápido possível. O aplicativo então responde a cada evento enfileirado prontamente, usando
operações assíncronas conforme necessário.

[async-await]: /libraries/async/async-await

### O ciclo de vida do isolate

Como mostra a figura a seguir,
cada isolate começa executando algum código Dart,
como a função `main()`.
Este código Dart pode registrar alguns listeners de eventos—para
responder à entrada do usuário ou I/O de arquivo, por exemplo.
Quando a função inicial do isolate retorna,
o isolate permanece se precisar lidar com eventos.
Depois de lidar com os eventos, o isolate sai.

![A more general figure showing that any isolate runs some code, optionally responds to events, and then exits](/assets/img/language/concurrency/basics-isolate.png){:.diagram-wrap}

### Manipulação de eventos

Em um aplicativo cliente, a fila de eventos do isolate main pode conter requisições de repintura
e notificações de toques e outros eventos de UI. Por exemplo, a figura a seguir
mostra um evento de repintura, seguido por um evento de toque, seguido por dois eventos de repintura.
O event loop pega eventos da fila em ordem de primeiro a entrar, primeiro a sair.

![A figure showing events being fed, one by one, into the event loop](/assets/img/language/concurrency/event-loop.png){:.diagram-wrap}

A manipulação de eventos acontece no isolate main após `main()` sair. Na
figura a seguir, após `main()` sair, o isolate main lida com o primeiro
evento de repintura. Depois disso, o isolate main lida com o evento de toque, seguido por um
evento de repintura.

Se uma operação síncrona demorar muito tempo de processamento, o aplicativo pode ficar
sem resposta. Na figura a seguir, o código de manipulação de toque demora muito, então
eventos subsequentes são tratados tarde demais. O aplicativo pode parecer congelar, e qualquer
animação que ele executa pode ficar irregular.

![A figure showing a tap handler with a too-long execution time](/assets/img/language/concurrency/event-jank.png){:.diagram-wrap}

Em aplicativos cliente, o resultado de uma operação síncrona muito longa é frequentemente
[animação de UI irregular (não suave)][jank]. Pior, a UI pode ficar completamente
sem resposta.

[jank]: {{site.flutter-docs}}/perf/rendering-performance

### Background workers

Se a UI do seu aplicativo ficar sem resposta devido a uma computação
demorada—[analisar um arquivo JSON grande][json], por exemplo—considere descarregar
essa computação para um worker isolate, frequentemente chamado de _background worker._
Um caso comum, mostrado na figura a seguir, é criar um worker simples
isolate que executa uma computação e depois sai. O worker isolate retorna
seu resultado em uma mensagem quando sai.

[json]: {{site.flutter-docs}}/cookbook/networking/background-parsing

![A figure showing a main isolate and a simple worker isolate](/assets/img/language/concurrency/isolate-bg-worker.png){:.diagram-wrap}

Um worker isolate pode executar I/O
(ler e escrever arquivos, por exemplo), definir timers e mais. Ele tem sua própria
memória e não compartilha nenhum estado com o isolate main. O worker isolate pode
bloquear sem afetar outros isolates.

### Usando isolates

Há duas maneiras de trabalhar com isolates em Dart, dependendo do caso de uso:

* Use [`Isolate.run()`][] para executar uma única computação em uma thread separada.
* Use [`Isolate.spawn()`][] para criar um isolate que lidará com múltiplas
  mensagens ao longo do tempo, ou um background worker. Para mais informações sobre trabalhar
  com isolates de longa duração, leia a página [Isolates](/language/isolates).

Na maioria dos casos, `Isolate.run` é a API recomendada
para executar processos em background.

#### `Isolate.run()`

O método estático `Isolate.run()` requer um argumento: um callback que será
executado no isolate recém-criado.

<?code-excerpt "lib/isolate_run_syntax.dart (slow)"?>
```dart
int slowFib(int n) => n <= 1 ? 1 : slowFib(n - 1) + slowFib(n - 2);

// Compute without blocking current isolate.
void fib40() async {
  var result = await Isolate.run(() => slowFib(40));
  print('Fib(40) = $result');
}
```

### Performance e grupos de isolate

Quando um isolate chama [`Isolate.spawn()`][], os dois isolates têm o mesmo
código executável e estão no mesmo _grupo de isolate_. Grupos de isolate permitem
otimizações de performance como compartilhamento de código; um novo isolate executa imediatamente
o código de propriedade do grupo de isolate. Além disso, `Isolate.exit()` funciona apenas quando os
isolates estão no mesmo grupo de isolate.

Em alguns casos especiais, você pode precisar usar [`Isolate.spawnUri()`][], que
configura o novo isolate com uma cópia do código que está no URI especificado.
No entanto, `spawnUri()` é muito mais lento que `spawn()`, e o novo isolate não está
no grupo de isolate do seu criador. Outra consequência de performance é que a passagem de
mensagem é mais lenta quando isolates estão em grupos diferentes.

[`Isolate.spawnUri()`]: {{site.dart-api}}/dart-isolate/Isolate/spawnUri.html

### Limitações de isolates

#### Isolates não são threads

Se você está vindo para o Dart de uma linguagem com multithreading, seria razoável
esperar que isolates se comportem como threads, mas esse não é o caso. Cada isolate
tem seu próprio estado, garantindo que nenhum estado em um isolate seja
acessível de qualquer outro isolate. Portanto, isolates são limitados por seu
acesso à sua própria memória.

Por exemplo, se você tem uma aplicação com uma
variável mutável global, essa variável será uma variável
separada no seu isolate criado. Se você mutar essa variável no isolate
criado, ela permanecerá intocada no isolate main. É assim que isolates devem
funcionar, e é importante ter isso em mente quando você está considerando
usar isolates.

#### Tipos de mensagem

Mensagens enviadas via [`SendPort`][]
podem ser quase qualquer tipo de objeto Dart, mas há algumas exceções:

- Objetos com recursos nativos, como [`Socket`][].
- [`ReceivePort`][]
- [`DynamicLibrary`][]
- [`Finalizable`][]
- [`Finalizer`][]
- [`NativeFinalizer`][]
- [`Pointer`][]
- [`UserTag`][]
- Instâncias de classes marcadas com `@pragma('vm:isolate-unsendable')`

Além dessas exceções, qualquer objeto pode ser enviado.
Confira a documentação de [`SendPort.send`][] para mais informações.

Observe que `Isolate.spawn()` e `Isolate.exit()` abstraem sobre objetos `SendPort`,
então estão sujeitos às mesmas limitações.

[`SendPort.send`]: {{site.dart-api}}/dart-isolate/SendPort/send.html
[`Socket`]: {{site.dart-api}}/dart-io/Socket-class.html
[`DynamicLibrary`]: {{site.dart-api}}/dart-ffi/DynamicLibrary-class.html
[`Finalizable`]: {{site.dart-api}}/dart-ffi/Finalizable-class.html
[`Finalizer`]: {{site.dart-api}}/dart-core/Finalizer-class.html
[`NativeFinalizer`]: {{site.dart-api}}/dart-ffi/NativeFinalizer-class.html
[`Pointer`]: {{site.dart-api}}/dart-ffi/Pointer-class.html
[`UserTag`]: {{site.dart-api}}/dart-developer/UserTag-class.html

#### Comunicação síncrona bloqueante entre isolates

Há um limite para o número de isolates que podem executar em paralelo.
Este limite não afeta a comunicação *assíncrona* padrão entre isolates
via mensagens em Dart. Você pode ter centenas de isolates executando concorrentemente
e fazendo progresso. Os isolates são agendados na CPU em rodízio,
e cedem uns aos outros frequentemente.

Isolates só podem se comunicar *sincronamente* fora do Dart puro,
usando código C via [FFI] para fazer isso.
Tentar comunicação síncrona entre isolates
por bloqueio síncrono em chamadas FFI
pode resultar em deadlock se o número de isolates estiver acima do limite,
a menos que cuidado especial seja tomado.
O limite não é codificado para um número específico,
é calculado com base no tamanho do heap da Dart VM disponível para a aplicação Dart.

Para evitar essa situação, o código C executando bloqueio síncrono
precisa sair do isolate atual antes de executar a operação de bloqueio
e reentrar nele antes de retornar ao Dart da chamada FFI.
Leia sobre [`Dart_EnterIsolate`] e [`Dart_ExitIsolate`] para saber mais.

[FFI]: /interop/c-interop
[`Dart_EnterIsolate`]: {{site.repo.dart.sdk}}/blob/c9a8bbd8d6024e419b5e5f26b5131285eb19cc93/runtime/include/dart_api.h#L1254
[`Dart_ExitIsolate`]: {{site.repo.dart.sdk}}/blob/c9a8bbd8d6024e419b5e5f26b5131285eb19cc93/runtime/include/dart_api.h#L1455

<a id="web"></a>
## Concorrência na web

Todos os aplicativos Dart podem usar `async-await`, `Future` e `Stream`
para computações não bloqueantes e intercaladas. A [plataforma Dart web][Dart web platform], no entanto,
não suporta isolates. Aplicativos Dart web podem usar [web workers][] para executar scripts
em threads de background semelhantes a isolates. A funcionalidade e
capacidades dos web workers diferem um pouco dos isolates, no entanto.

Por exemplo, quando web workers enviam dados entre threads, eles copiam os dados
de um lado para o outro. A cópia de dados pode ser muito lenta, especialmente para
mensagens grandes. Isolates fazem o mesmo, mas também fornecem APIs que podem mais eficientemente
_transferir_
a memória que contém a mensagem.

Criar web workers e isolates também difere. Você só pode criar web workers
declarando um ponto de entrada de programa separado e compilando-o separadamente. Iniciar
um web worker é semelhante a usar `Isolate.spawnUri` para iniciar um isolate. Você também pode
iniciar um isolate com `Isolate.spawn`, que requer menos recursos
porque
[reutiliza parte do mesmo código e dados](#performance-and-isolate-groups)
que o isolate criador. Web workers não têm uma API equivalente.

[Dart web platform]: /overview#platform
[web workers]: https://developer.mozilla.org/docs/Web/API/Web_Workers_API/Using_web_workers


## Recursos adicionais

- Se você estiver usando muitos isolates, considere
  o [`IsolateNameServer`][]
  no Flutter, ou
  [`package:isolate_name_server`][] que fornece
  funcionalidade semelhante para aplicações Dart não-Flutter.
- Leia mais sobre o [modelo Actor][Actor model], no qual os isolates do Dart são baseados.
- Documentação adicional sobre APIs `Isolate`:
    - [`Isolate.exit()`][]
    - [`Isolate.spawn()`][]
    - [`ReceivePort`][]
    - [`SendPort`][]

[`IsolateNameServer`]: {{site.flutter-api}}/flutter/dart-ui/IsolateNameServer-class.html
[`package:isolate_name_server`]: {{site.pub-pkg}}/isolate_name_server
[Actor model]: https://en.wikipedia.org/wiki/Actor_model
[`Isolate.run()`]: {{site.dart-api}}/dart-isolate/Isolate/run.html
[`Isolate.exit()`]: {{site.dart-api}}/dart-isolate/Isolate/exit.html
[`Isolate.spawn()`]: {{site.dart-api}}/dart-isolate/Isolate/spawn.html
[`ReceivePort`]: {{site.dart-api}}/dart-isolate/ReceivePort-class.html
[`SendPort`]: {{site.dart-api}}/dart-isolate/SendPort-class.html
