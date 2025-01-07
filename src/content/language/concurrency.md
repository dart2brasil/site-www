---
ia-translate: true
title: Concorrência em Dart
description: >-
  Use isolates para habilitar a execução de código paralelo em múltiplos núcleos de processador.
short-title: Concorrência
lastVerified: 2023-12-14
prevpage:
  url: /language/modifier-reference
  title: Referência de modificadores de classe
nextpage:
  url: /language/async
  title: Async
---

<?code-excerpt path-base="concurrency"?>

<style>
  article img {
    padding: 15px 0;
  }
</style>

Esta página contém uma visão geral conceitual de como a programação concorrente
funciona em Dart. Ela explica o loop de eventos, os recursos da linguagem
async e os isolates de alto nível. Para exemplos de código mais práticos de
como usar concorrência em Dart, leia a página de
[Suporte a Assincronia](/language/async) e a página de [Isolates](/language/isolates).

A programação concorrente em Dart se refere tanto a APIs assíncronas, como
`Future` e `Stream`, quanto a *isolates*, que permitem mover processos para
núcleos separados.

Todo código Dart é executado em isolates, começando no isolate principal
padrão e, opcionalmente, expandindo para quaisquer isolates subsequentes que
você crie explicitamente. Quando você gera um novo isolate, ele tem sua própria
memória isolada e seu próprio loop de eventos. O loop de eventos é o que torna
a programação assíncrona e concorrente possível em Dart.

## Loop de Eventos {:#event-loop}

O modelo de tempo de execução do Dart é baseado em um loop de eventos. O loop
de eventos é responsável por executar o código do seu programa, coletar e
processar eventos e muito mais.

À medida que seu aplicativo é executado, todos os eventos são adicionados a uma
fila, chamada de *fila de eventos*. Os eventos podem ser qualquer coisa, desde
solicitações para repintar a interface do usuário, toques e pressionamentos de
teclas do usuário, até E/S do disco. Como seu aplicativo não pode prever em que
ordem os eventos acontecerão, o loop de eventos processa os eventos na ordem
em que são enfileirados, um de cada vez.

![Uma figura mostrando eventos sendo alimentados, um por um, no loop de
eventos](/assets/img/language/concurrency/event-loop.png)

A forma como o loop de eventos funciona se assemelha a este código:

```dart
while (eventQueue.waitForEvent()) {
  eventQueue.processNextEvent();
}
```

Este exemplo de loop de eventos é síncrono e é executado em uma única thread
(linha de execução). No entanto, a maioria dos aplicativos Dart precisa fazer
mais de uma coisa ao mesmo tempo. Por exemplo, um aplicativo cliente pode
precisar executar uma requisição HTTP, enquanto também escuta o usuário tocar
em um botão. Para lidar com isso, o Dart oferece muitas APIs async, como
[Futures, Streams e async-await](/language/async). Essas APIs são construídas em
torno deste loop de eventos.

Por exemplo, considere fazer uma requisição de rede:

```dart
http.get('https://example.com').then((response) {
  if (response.statusCode == 200) {
    print('Sucesso!');
  }
}
```

Quando este código atinge o loop de eventos, ele chama imediatamente a
primeira cláusula, `http.get`, e retorna um `Future`. Ele também diz ao loop
de eventos para manter o callback (chamada de retorno) na cláusula `then()` até
que a requisição HTTP seja resolvida. Quando isso acontecer, ele deve executar
esse callback, passando o resultado da requisição como um argumento.

![Figura mostrando eventos async sendo adicionadosa um loop de eventos e
mantendo um callback para executar mais
tarde.](/assets/img/language/concurrency/async-event-loop.png)

Este mesmo modelo é geralmente como o loop de eventos lida com todos os outros
eventos assíncronos em Dart, como objetos [`Stream`][`Stream`].

[`Stream`]: {{site.dart-api}}/dart-async/Stream-class.html

## Programação Assíncrona {:#asynchronous-programming}

Esta seção resume os diferentes tipos e sintaxes da programação assíncrona em
Dart. Se você já está familiarizado com `Future`, `Stream` e async-await, pode
pular para a [seção de isolates][seção de isolates].

[seção de isolates]: #isolates

### Futures {:#futures}

Um `Future` representa o resultado de uma operação assíncrona que acabará
sendo concluída com um valor ou um erro.

Neste código de exemplo, o tipo de retorno de `Future<String>` representa uma
promessa de eventualmente fornecer um valor `String` (ou erro).

<?code-excerpt "lib/future_syntax.dart (read-async)"?>
```dart
Future<String> _readFileAsync(String filename) {
  final file = File(filename);

  // .readAsString() retorna um Future.
  // .then() registra um callback para ser executado quando `readAsString` for resolvido.
  return file.readAsString().then((contents) {
    return contents.trim();
  });
}
```

### A sintaxe async-await {:#the-async-await-syntax}

As palavras-chave `async` e `await` fornecem uma forma declarativa de definir
funções assíncronas e usar seus resultados.

Aqui está um exemplo de algum código síncrono que bloqueia enquanto aguarda
E/S de arquivo:

<?code-excerpt "lib/sync_number_of_keys.dart (blocking)"?>
```dart
const String filename = 'with_keys.json';

void main() {
  // Lê alguns dados.
  final fileData = _readFileSync();
  final jsonData = jsonDecode(fileData);

  // Usa esses dados.
  print('Número de chaves JSON: ${jsonData.length}');
}

String _readFileSync() {
  final file = File(filename);
  final contents = file.readAsStringSync();
  return contents.trim();
}
```

Aqui está um código semelhante, mas com alterações (destacadas) para torná-lo
assíncrono:

<?code-excerpt "lib/async_number_of_keys.dart (non-blocking)" replace="/async|await|readAsString\(\)/[!$&!]/g; /Future<\w+\W/[!$&!]/g;"?>
```dart
const String filename = 'with_keys.json';

void main() [!async!] {
  // Lê alguns dados.
  final fileData = [!await!] _readFileAsync();
  final jsonData = jsonDecode(fileData);

  // Usa esses dados.
  print('Número de chaves JSON: ${jsonData.length}');
}

[!Future<String>!] _readFileAsync() [!async!] {
  final file = File(filename);
  final contents = [!await!] file.[!readAsString()!];
  return contents.trim();
}
```

A função `main()` usa a palavra-chave `await` em frente a `_readFileAsync()`
para permitir que outro código Dart (como manipuladores de eventos) use a CPU
enquanto o código nativo (E/S de arquivo) é executado. Usar `await` também tem
o efeito de converter o `Future<String>` retornado por `_readFileAsync()` em
uma `String`. Como resultado, a variável `contents` tem o tipo implícito `String`.

:::note
A palavra-chave `await` funciona apenas em funções que têm `async` antes do
corpo da função.
:::

Como a figura a seguir mostra, o código Dart pausa enquanto `readAsString()`
executa código não-Dart, seja no tempo de execução do Dart ou no sistema
operacional. Uma vez que `readAsString()` retorna um valor, a execução do código Dart é retomada.

![Figura semelhante a um fluxograma mostrando o código do aplicativo sendo
executado do início ao fim, aguardando E/S nativa no meio](/assets/img/language/concurrency/basics-await.png)

### Streams {:#streams}

Dart também suporta código assíncrono na forma de streams. Streams fornecem
valores no futuro e repetidamente ao longo do tempo. Uma promessa de fornecer
uma série de valores `int` ao longo do tempo tem o tipo `Stream<int>`.

No exemplo a seguir, o stream criado com `Stream.periodic` emite repetidamente
um novo valor `int` a cada segundo.

<?code-excerpt "lib/stream_syntax.dart"?>
```dart
Stream<int> stream = Stream.periodic(const Duration(seconds: 1), (i) => i * i);
```

#### await-for e yield {:#await-for-and-yield}

Await-for é um tipo de loop for que executa cada iteração subsequente do loop
à medida que novos valores são fornecidos. Em outras palavras, ele é usado
para "percorrer" streams. Neste exemplo, um novo valor será emitido da função
`sumStream` à medida que novos valores são emitidos do stream que é fornecido
como um argumento. A palavra-chave `yield` é usada em vez de `return` em
funções que retornam streams de valores.

<?code-excerpt "lib/await_for_syntax.dart"?>
```dart
Stream<int> sumStream(Stream<int> stream) async* {
  var sum = 0;
  await for (final value in stream) {
    yield sum += value;
  }
}
```

Se você quiser saber mais sobre como usar `async`, `await`, `Stream`s e
`Future`s, consulte o [tutorial de programação assíncrona][tutorial de programação assíncrona].

[tutorial de programação assíncrona]: /libraries/async/async-await

## Isolates {:#isolates}

O Dart suporta concorrência por meio de isolates, além das
[APIs assíncronas](#asynchronous-programming). A maioria dos dispositivos
modernos tem CPUs multi-core. Para aproveitar vários núcleos, os desenvolvedores
às vezes usam threads (linhas de execução) de memória compartilhada em execução
simultânea. No entanto, a concorrência de estado compartilhado é [propensa a erros](https://en.wikipedia.org/wiki/Race_condition#In_software)
e pode levar a um código complicado.

Em vez de threads, todo código Dart é executado dentro de isolates. Usando
isolates, seu código Dart pode executar várias tarefas independentes ao mesmo
tempo, usando núcleos de processador adicionais, se estiverem disponíveis.
Isolates são como threads ou processos, mas cada isolate tem sua própria
memória e uma única thread executando um loop de eventos.

Cada isolate tem seus próprios campos globais, garantindo que nenhum dos estados
em um isolate seja acessível de qualquer outro isolate. Isolates só podem se
comunicar uns com os outros por meio de passagem de mensagens. Nenhum estado
compartilhado entre isolates significa que complexidades de concorrência como
[mutexes ou locks](https://en.wikipedia.org/wiki/Lock_(computer_science)) e
[disputas de dados](https://en.wikipedia.org/wiki/Race_condition#Data_race) não
ocorrerão em Dart. Dito isso, os isolates não impedem as condições de disputa
por completo. Para mais informações sobre este modelo de concorrência, leia
sobre o [modelo de Ator](https://en.wikipedia.org/wiki/Actor_model).

:::note Observação sobre a Plataforma
Apenas a [plataforma Dart Nativa][plataforma Dart Native] implementa isolates. Para saber mais sobre
a plataforma Dart Web, consulte a
seção [Concorrência na web](#concurrency-on-the-web).
:::

[plataforma Dart Native]: /overview#platform

### O isolate principal {:#the-main-isolate}

Na maioria dos casos, você não precisa pensar em isolates. Os programas Dart são
executados no isolate principal por padrão. É a thread onde um programa começa
a ser executado e executado, como mostrado na figura a seguir:

![Uma figura mostrando um isolate principal, que executa `main()`, responde a
eventos e depois sai](/assets/img/language/concurrency/basics-main-isolate.png)

Mesmo programas de isolate único podem ser executados sem problemas. Antes de
continuar para a próxima linha de código, esses aplicativos usam
[async-await][async-await] para aguardar a conclusão de operações assíncronas. Um
aplicativo bem-comportado começa rapidamente, chegando ao loop de eventos o
mais rápido possível. O aplicativo então responde a cada evento enfileirado
prontamente, usando operações assíncronas conforme necessário.

[async-await]: /libraries/async/async-await

### O ciclo de vida do isolate {:#the-isolate-life-cycle}

Como a figura a seguir mostra,
cada isolate começa executando algum código Dart,
como a função `main()`.
Este código Dart pode registrar alguns ouvintes de
eventos — para responder à entrada do usuário ou E/S de arquivo, por exemplo.
Quando a função inicial do isolate retorna, o isolate permanece se precisar
lidar com eventos. Depois de lidar com os eventos, o isolate sai.

![Uma figura mais geral mostrando que qualquer isolate executa algum código,
opcionalmente responde a eventos e depois sai](/assets/img/language/concurrency/basics-isolate.png)

### Tratamento de eventos {:#event-handling}

Em um aplicativo cliente, a fila de eventos do isolate principal pode conter
solicitações de repintura e notificações de toques e outros eventos da UI
(interface do usuário). Por exemplo, a figura a seguir mostra um evento de
repintura, seguido por um evento de toque, seguido por dois eventos de
repintura. O loop de eventos pega os eventos da fila na ordem FIFO (first in,
first out - primeiro a entrar, primeiro a sair).

![Uma figura mostrando eventos sendo alimentados, um por um, no loop de
eventos](/assets/img/language/concurrency/event-loop.png)

O tratamento de eventos acontece no isolate principal depois que `main()` sai.
Na figura a seguir, depois que `main()` sai, o isolate principal trata o
primeiro evento de repintura. Depois disso, o isolate principal lida com o
evento de toque, seguido por um evento de repintura.

Se uma operação síncrona levar muito tempo de processamento, o aplicativo pode
deixar de responder. Na figura a seguir, o código de tratamento de toque leva
muito tempo, então os eventos subsequentes são tratados muito tarde. O
aplicativo pode parecer travar e qualquer animação que ele execute pode ser
instável.

![Uma figura mostrando um manipulador de toque com um tempo de execução muito longo](/assets/img/language/concurrency/event-jank.png)

Em aplicativos cliente, o resultado de uma operação síncrona muito longa é
muitas vezes [animação de UI instável (não suave)][jank]. Pior ainda, a UI pode
se tornar completamente não responsiva.

[jank]: {{site.flutter-docs}}/perf/rendering-performance

### Workers em segundo plano {:#background-workers}

Se a UI do seu aplicativo se tornar não responsiva devido a uma computação
demorada — [analisando um arquivo JSON grande][json], por exemplo — considere
descarregar essa computação para um isolate worker, geralmente chamado de
_worker em segundo plano._ Um caso comum, mostrado na figura a seguir, é gerar
um isolate worker simples que executa uma computação e depois sai. O isolate
worker retorna seu resultado em uma mensagem quando sai.

[json]: {{site.flutter-docs}}/cookbook/networking/background-parsing

![Uma figura mostrando um isolate principal e um isolate worker
simples](/assets/img/language/concurrency/isolate-bg-worker.png)

Um isolate worker pode executar E/S (leitura e gravação de arquivos, por
exemplo), definir temporizadores e muito mais. Ele tem sua própria memória e
não compartilha nenhum estado com o isolate principal. O isolate worker pode
bloquear sem afetar outros isolates.

### Usando isolates {:#using-isolates}

Existem duas maneiras de trabalhar com isolates em Dart, dependendo do caso de
uso:

* Use [`Isolate.run()`][`Isolate.run()`] para executar uma única computação em uma thread
  separada.
* Use [`Isolate.spawn()`][`Isolate.spawn()`] para criar um isolate que irá lidar com várias
  mensagens ao longo do tempo, ou um worker em segundo plano. Para mais
  informações sobre como trabalhar com isolates de longa duração, leia a página
  [Isolates](/language/isolates).

Na maioria dos casos, `Isolate.run` é a API recomendada para executar
processos em segundo plano.

#### `Isolate.run()` {:#isolate-run}

O método estático `Isolate.run()` requer um argumento: um callback que será
executado no isolate recém-gerado.

<?code-excerpt "lib/isolate_run_syntax.dart (slow)"?>
```dart
int slowFib(int n) => n <= 1 ? 1 : slowFib(n - 1) + slowFib(n - 2);

// Computa sem bloquear o isolate atual.
void fib40() async {
  var result = await Isolate.run(() => slowFib(40));
  print('Fib(40) = $result');
}
```

### Desempenho e grupos de isolates {:#performance-and-isolate-groups}

Quando um isolate chama [`Isolate.spawn()`][`Isolate.spawn()`], os dois isolates têm o mesmo
código executável e estão no mesmo _grupo de isolates_. Grupos de isolates
permitem otimizações de desempenho, como o compartilhamento de código; um novo
isolate executa imediatamente o código pertencente ao grupo de isolates. Além
disso, `Isolate.exit()` funciona apenas quando os isolates estão no mesmo
grupo de isolates.

Em alguns casos especiais, você pode precisar usar
[`Isolate.spawnUri()`][`Isolate.spawnUri()`], que configura o novo isolate com uma cópia do
código que está no URI especificado. No entanto, `spawnUri()` é muito mais
lento do que `spawn()` e o novo isolate não está no grupo de isolates de seu
gerador. Outra consequência de desempenho é que a passagem de mensagens é mais
lenta quando os isolates estão em grupos diferentes.

[`Isolate.spawnUri()`]: {{site.dart-api}}/dart-isolate/Isolate/spawnUri.html

### Limitações dos isolates {:#limitations-of-isolates}

#### Isolates não são threads {:#isolates-arent-threads}

Se você está vindo para Dart de uma linguagem com multithreading (múltiplas
linhas de execução), seria razoável esperar que os isolates se comportassem
como threads, mas esse não é o caso. Cada isolate tem seu próprio estado,
garantindo que nenhum dos estados em um isolate seja acessível de qualquer
outro isolate. Portanto, os isolates são limitados pelo seu acesso à sua
própria memória.

Por exemplo, se você tiver um aplicativo com uma variável global mutável, essa
variável será uma variável separada em seu isolate gerado. Se você alterar
essa variável no isolate gerado, ela permanecerá intacta no isolate principal.
É assim que os isolates devem funcionar e é importante ter isso em mente ao
considerar o uso de isolates.

#### Tipos de mensagens {:#message-types}

As mensagens enviadas via [`SendPort`][`SendPort`] podem ser quase qualquer tipo de
objeto Dart, mas há algumas exceções:

- Objetos com recursos nativos, como [`Socket`][`Socket`].
- [`ReceivePort`][`ReceivePort`]
- [`DynamicLibrary`][`DynamicLibrary`]
- [`Finalizable`][`Finalizable`]
- [`Finalizer`][`Finalizer`]
- [`NativeFinalizer`][`NativeFinalizer`]
- [`Pointer`][`Pointer`]
- [`UserTag`][`UserTag`]
- Instâncias de classes marcadas com `@pragma('vm:isolate-unsendable')`

Além dessas exceções, qualquer objeto pode ser enviado. Consulte a
documentação de [`SendPort.send`][`SendPort.send`] para mais informações.

Observe que `Isolate.spawn()` e `Isolate.exit()` abstraem sobre objetos
`SendPort`, portanto, estão sujeitos às mesmas limitações.

[`SendPort.send`]: {{site.dart-api}}/dart-isolate/SendPort/send.html
[`Socket`]: {{site.dart-api}}/dart-io/Socket-class.html
[`DynamicLibrary`]: {{site.dart-api}}/dart-ffi/DynamicLibrary-class.html
[`Finalizable`]: {{site.dart-api}}/dart-ffi/Finalizable-class.html
[`Finalizer`]: {{site.dart-api}}/dart-core/Finalizer-class.html
[`NativeFinalizer`]: {{site.dart-api}}/dart-ffi/NativeFinalizer-class.html
[`Pointer`]: {{site.dart-api}}/dart-ffi/Pointer-class.html
[`UserTag`]: {{site.dart-api}}/dart-developer/UserTag-class.html

#### Comunicação síncrona de bloqueio entre isolates {:#synchronous-blocking-communication-between-isolates}

Há um limite para o número de isolates que podem ser executados em paralelo.
Esse limite não afeta a comunicação *assíncrona* padrão entre isolates por meio
de mensagens em Dart. Você pode ter centenas de isolates sendo executados
simultaneamente e progredindo. Os isolates são agendados na CPU em esquema
round-robin (rodízio) e cedem um ao outro com frequência.

Isolates só podem se comunicar *sincronamente* fora do Dart puro, usando código
C via [FFI] para fazê-lo. Tentar comunicação síncrona entre isolates por
bloqueio síncrono em chamadas FFI pode resultar em deadlock (impasse) se o
número de isolates estiver acima do limite, a menos que cuidados especiais sejam
tomados. O limite não é codificado para um número específico, ele é calculado
com base no tamanho do heap da VM Dart disponível para o aplicativo Dart.

Para evitar esta situação, o código C que executa o bloqueio síncrono precisa
sair do isolate atual antes de executar a operação de bloqueio e entrar
novamente antes de retornar ao Dart da chamada FFI. Leia sobre
[`Dart_EnterIsolate`] e [`Dart_ExitIsolate`] para saber mais.

[FFI]: /interop/c-interop
[`Dart_EnterIsolate`]: {{site.repo.dart.sdk}}/blob/c9a8bbd8d6024e419b5e5f26b5131285eb19cc93/runtime/include/dart_api.h#L1254
[`Dart_ExitIsolate`]: {{site.repo.dart.sdk}}/blob/c9a8bbd8d6024e419b5e5f26b5131285eb19cc93/runtime/include/dart_api.h#L1455

<a id="web"></a>
## Concorrência na web {:#concurrency-on-the-web}

Todos os aplicativos Dart podem usar `async-await`, `Future` e `Stream` para
computações não bloqueadoras e intercaladas. A [plataforma Dart web][plataforma Dart web], no
entanto, não suporta isolates. Aplicativos web Dart podem usar [web workers][web workers]
para executar scripts em threads de fundo semelhantes a isolates. A
funcionalidade e os recursos dos web workers diferem um pouco dos isolates.

Por exemplo, quando os web workers enviam dados entre threads, eles copiam os
dados de um lado para o outro. A cópia de dados pode ser muito lenta, no
entanto, especialmente para mensagens grandes. Os isolates fazem o mesmo, mas
também fornecem APIs que podem _transferir_ de forma mais eficiente a memória
que contém a mensagem.

A criação de web workers e isolates também difere. Você só pode criar web
workers declarando um ponto de entrada de programa separado e compilando-o
separadamente. Iniciar um web worker é semelhante a usar `Isolate.spawnUri`
para iniciar um isolate. Você também pode iniciar um isolate com
`Isolate.spawn`, que requer menos recursos porque [reutiliza parte do mesmo
código e dados](#performance-and-isolate-groups) que o isolate de
geração. Web workers não têm uma API equivalente.

[plataforma Dart web]: /overview#platform
[web workers]: https://developer.mozilla.org/docs/Web/API/Web_Workers_API/Using_web_workers

## Recursos adicionais {:#additional-resources}

- Se você estiver usando muitos isolates,
  considere o [`IsolateNameServer`][`IsolateNameServer`]
  no Flutter ou o [`package:isolate_name_server`][`package:isolate_name_server`] que fornece funcionalidade
  semelhante para aplicativos Dart que não são Flutter.
- Leia mais sobre o [modelo Ator][modelo Ator], no qual os isolates de Dart são baseados.
- Documentação adicional sobre as APIs de `Isolate`:
    - [`Isolate.exit()`][`Isolate.exit()`]
    - [`Isolate.spawn()`][`Isolate.spawn()`]
    - [`ReceivePort`][`ReceivePort`]
    - [`SendPort`][`SendPort`]

[`IsolateNameServer`]: {{site.flutter-api}}/flutter/dart-ui/IsolateNameServer-class.html
[`package:isolate_name_server`]: {{site.pub-pkg}}/isolate_name_server
[modelo Ator]: https://en.wikipedia.org/wiki/Actor_model
[`Isolate.run()`]: {{site.dart-api}}/dart-isolate/Isolate/run.html
[`Isolate.exit()`]: {{site.dart-api}}/dart-isolate/Isolate/exit.html
[`Isolate.spawn()`]: {{site.dart-api}}/dart-isolate/Isolate/spawn.html
[`ReceivePort`]: {{site.dart-api}}/dart-isolate/ReceivePort-class.html
[`SendPort`]: {{site.dart-api}}/dart-isolate/SendPort-class.html
