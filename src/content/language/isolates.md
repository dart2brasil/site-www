---
title: Isolates
description: Informações sobre como escrever isolates em Dart.
shortTitle: Isolates
ia-translate: true
lastVerified: 2024-01-04
prevpage:
  url: /language/async
  title: Asynchronous support
nextpage:
  url: /null-safety
  title: Sound null safety
---

<?code-excerpt path-base="concurrency"?>

Esta página discute alguns exemplos que usam a API `Isolate` para implementar
isolates.

Você deve usar isolates sempre que sua aplicação estiver lidando com computações que
são grandes o suficiente para bloquear temporariamente outras computações.
O exemplo mais comum é em aplicações [Flutter][], quando você
precisa realizar grandes computações que de outra forma poderiam causar
que a UI se torne não responsiva.

Não há regras sobre quando você _deve_ usar isolates,
mas aqui estão algumas situações adicionais onde eles podem ser úteis:

- Analisar e decodificar blobs JSON excepcionalmente grandes.
- Processar e comprimir fotos, áudio e vídeo.
- Converter arquivos de áudio e vídeo.
- Realizar buscas e filtragens complexas em listas grandes ou dentro
  de sistemas de arquivos.
- Realizar I/O, como comunicar-se com um banco de dados.
- Lidar com um grande volume de requisições de rede.

[Flutter]: {{site.flutter-docs}}/perf/isolates

## Implementando um worker isolate simples

Estes exemplos implementam um isolate principal
que gera um worker isolate simples.
[`Isolate.run()`][] simplifica os passos por trás da
configuração e gerenciamento de worker isolates:

1. Gera (inicia e cria) um isolate.
2. Executa uma função no isolate gerado.
3. Captura o resultado.
4. Retorna o resultado para o isolate principal.
5. Termina o isolate uma vez que o trabalho está completo.
6. Verifica, captura e lança exceções e erros de volta ao isolate principal.

[`Isolate.run()`]: {{site.dart-api}}/dart-isolate/Isolate/run.html

:::flutter-note
Se você está usando Flutter, você pode usar a [função `compute` do Flutter][]
em vez de `Isolate.run()`.
:::

[função `compute` do Flutter]: {{site.flutter-api}}/flutter/foundation/compute.html

### Executando um método existente em um novo isolate

1. Chame `run()` para gerar um novo isolate (um [background worker][]),
   diretamente no [main isolate][] enquanto `main()` aguarda o resultado:

<?code-excerpt "lib/simple_worker_isolate.dart (main)"?>
```dart
const String filename = 'with_keys.json';

void main() async {
  // Read some data.
  final jsonData = await Isolate.run(_readAndParseJson);

  // Use that data.
  print('Number of JSON keys: ${jsonData.length}');
}
```

2. Passe ao worker isolate a função que você quer que ele execute
   como seu primeiro argumento. Neste exemplo, é a função existente `_readAndParseJson()`:

<?code-excerpt "lib/simple_worker_isolate.dart (spawned)"?>
```dart
Future<Map<String, dynamic>> _readAndParseJson() async {
  final fileData = await File(filename).readAsString();
  final jsonData = jsonDecode(fileData) as Map<String, dynamic>;
  return jsonData;
}
```

3. `Isolate.run()` pega o resultado que `_readAndParseJson()` retorna
   e envia o valor de volta ao isolate principal,
   encerrando o worker isolate.

4. O worker isolate *transfere* a memória que contém o resultado
   para o isolate principal. Ele *não copia* os dados.
   O worker isolate realiza uma passagem de verificação para garantir
   que os objetos podem ser transferidos.

`_readAndParseJson()` é uma função
assíncrona existente que poderia facilmente
executar diretamente no isolate principal.
Usar `Isolate.run()` para executá-la em vez disso habilita concorrência.
O worker isolate abstrai completamente as computações
de `_readAndParseJson()`. Ele pode completar sem bloquear o isolate principal.

O resultado de `Isolate.run()` é sempre uma Future,
porque o código no isolate principal continua a executar.
Se a computação que o worker isolate executa
é síncrona ou assíncrona não impacta o
isolate principal, porque está executando de forma concorrente de qualquer maneira.

Para o programa completo, confira a amostra [send_and_receive.dart][].

[send_and_receive.dart]: {{site.repo.dart.samples}}/blob/main/isolates/bin/send_and_receive.dart
[background worker]: /language/concurrency#background-workers
[main isolate]: /language/concurrency#the-main-isolate

### Enviando closures com isolates

Você também pode criar um worker isolate simples com `run()` usando um
literal de função, ou closure, diretamente no isolate principal.

<?code-excerpt "lib/simple_isolate_closure.dart (worker)"?>
```dart
const String filename = 'with_keys.json';

void main() async {
  // Read some data.
  final jsonData = await Isolate.run(() async {
    final fileData = await File(filename).readAsString();
    final jsonData = jsonDecode(fileData) as Map<String, dynamic>;
    return jsonData;
  });

  // Use that data.
  print('Number of JSON keys: ${jsonData.length}');
}
```

Este exemplo realiza o mesmo que o anterior.
Um novo isolate é gerado, computa algo e envia de volta o resultado.

No entanto, agora o isolate envia uma [closure][].
Closures são menos limitadas do que funções nomeadas típicas,
tanto em como elas funcionam quanto em como são escritas no código.
Neste exemplo, `Isolate.run()` executa o que parece ser código local,
de forma concorrente. Nesse sentido, você pode imaginar `run()` funcionar como um
operador de fluxo de controle para "executar em paralelo".

[closure]: /language/functions#anonymous-functions

## Enviando múltiplas mensagens entre isolates com ports

Isolates de curta duração são convenientes de usar,
mas exigem sobrecarga de desempenho para gerar novos isolates
e copiar objetos de um isolate para outro.
Se seu código depende de executar repetidamente a mesma computação
usando `Isolate.run`, você pode melhorar o desempenho criando
isolates de longa duração que não saem imediatamente.

Para fazer isso, você pode usar algumas das APIs de isolate de baixo nível que
`Isolate.run` abstrai:

* [`Isolate.spawn()`][] e [`Isolate.exit()`][]
* [`ReceivePort`][] e [`SendPort`][]
* [Método `SendPort.send()`][]


Esta seção revisa os passos necessários para estabelecer
comunicação bidirecional entre um isolate recém-gerado
e o [main isolate][].
O primeiro exemplo, [Ports básicos](#basic-ports-example), introduz o processo
em um alto nível. O segundo exemplo, [Ports robustos](#robust-ports-example),
gradualmente adiciona funcionalidade mais prática e do mundo real ao primeiro.

[`Isolate.exit()`]: {{site.dart-api}}/dart-isolate/Isolate/exit.html
[`Isolate.spawn()`]: {{site.dart-api}}/dart-isolate/Isolate/spawn.html
[`ReceivePort`]: {{site.dart-api}}/dart-isolate/ReceivePort-class.html
[`SendPort`]: {{site.dart-api}}/dart-isolate/SendPort-class.html
[Método `SendPort.send()`]: {{site.dart-api}}/dart-isolate/SendPort/send.html
[main isolate]: /language/concurrency#isolates


### `ReceivePort` e `SendPort`

Configurar comunicação de longa duração entre isolates requer
duas classes (além de `Isolate`): `ReceivePort` e `SendPort`.
Esses ports são a única maneira de isolates se comunicarem uns com os outros.

Um `ReceivePort` é um objeto que manipula mensagens que são enviadas de outros
isolates. Essas mensagens são enviadas via um `SendPort`.

:::note
Um objeto `SendPort` está associado a exatamente um `ReceivePort`,
mas um único `ReceivePort` pode ter muitos `SendPorts`.
Quando você cria um `ReceivePort`, ele cria um `SendPort` para si mesmo.
Você pode criar `SendPorts` adicionais que
podem enviar mensagens para um `ReceivePort` existente.
:::

Ports se comportam de forma similar a objetos [`Stream`][]
(na verdade, receive ports implementam `Stream`!)
Você pode pensar em um `SendPort` e `ReceivePort` como
o `StreamController` e listeners de Stream, respectivamente.
Um `SendPort` é como um `StreamController` porque você "adiciona" mensagens a eles
com o [método `SendPort.send()`][], e essas mensagens são manipuladas por um listener,
neste caso o `ReceivePort`. O `ReceivePort` então manipula as mensagens que
recebe passando-as como argumentos para um callback que você fornece.

#### Configurando ports

Um isolate recém-gerado só tem as informações que recebe através da
chamada `Isolate.spawn`. Se você precisa que o isolate principal continue a comunicar-se
com um isolate gerado após sua criação inicial, você deve configurar um
canal de comunicação onde o isolate gerado possa enviar mensagens ao
isolate principal. Isolates só podem se comunicar via passagem de mensagens.
Eles não podem "ver" dentro da memória uns dos outros,
que é de onde vem o nome "isolate".

Para configurar essa comunicação bidirecional, primeiro crie um [`ReceivePort`][]
no isolate principal, então passe seu [`SendPort`][] como argumento ao
novo isolate ao gerá-lo com `Isolate.spawn`.
O novo isolate então cria seu próprio `ReceivePort`, e envia _seu_ `SendPort`
de volta no `SendPort` que foi passado pelo isolate principal.
O isolate principal recebe este `SendPort`, e
agora ambos os lados têm um canal aberto para enviar e receber mensagens.

:::note
Os diagramas nesta seção são de alto nível e destinados a transmitir o
_conceito_ de usar ports para isolates. A implementação real requer
um pouco mais de código, que você encontrará
[mais adiante nesta página](#basic-ports-example).
:::

![A figure showing events being fed, one by one, into the event loop](/assets/img/language/concurrency/ports-setup.png){:.diagram-wrap}

1. Crie um `ReceivePort` no isolate principal. O `SendPort` é criado
   automaticamente como uma propriedade no `ReceivePort`.
2. Gere o worker isolate com `Isolate.spawn()`
3. Passe uma referência a `ReceivePort.sendPort` como a primeira mensagem ao
   worker isolate.
4. Crie outro novo `ReceivePort` no worker isolate.
5. Passe uma referência ao `ReceivePort.sendPort` do worker isolate como a
   primeira mensagem _de volta_ ao isolate principal.

Junto com criar os ports e configurar comunicação, você também precisará
dizer aos ports o que fazer quando eles receberem mensagens. Isso é feito usando
o método `listen` em cada respectivo `ReceivePort`.

![A figure showing events being fed, one by one, into the event loop](/assets/img/language/concurrency/ports-passing-messages.png){:.diagram-wrap}

1. Envie uma mensagem via a referência do isolate principal ao `SendPort` do worker isolate.
2. Receba e manipule a mensagem via um listener no `ReceivePort` do worker isolate.
   Isto é onde a computação que você quer mover do
   isolate principal é executada.
3. Envie uma mensagem de retorno via a referência do worker isolate ao
   `SendPort` do isolate principal.
4. Receba a mensagem via um listener no `ReceivePort` do isolate principal.

### Exemplo de ports básicos

Este exemplo demonstra como você pode configurar um worker isolate de longa duração
com comunicação bidirecional entre ele e o isolate principal.
O código usa o exemplo de enviar texto JSON para um novo isolate,
onde o JSON será analisado e decodificado,
antes de ser enviado de volta ao isolate principal.

:::warning
Este exemplo é destinado a ensinar o _mínimo necessário_ para
gerar um novo isolate que pode enviar e receber múltiplas mensagens ao longo do tempo.

Ele não cobre pedaços importantes de funcionalidade que são esperados
em software de produção, como tratamento de erros, encerramento de ports,
e sequenciamento de mensagens.

O [exemplo de Ports robustos][] na próxima seção cobre esta funcionalidade e
discute alguns dos problemas que podem surgir sem ela.
:::

[exemplo de Ports robustos]: #robust-ports-example

#### Passo 1: Definir a classe worker

Primeiro, crie uma classe para seu worker isolate em segundo plano.
Esta classe contém toda a funcionalidade que você precisa para:

- Gerar um isolate.
- Enviar mensagens para esse isolate.
- Fazer o isolate decodificar algum JSON.
- Enviar o JSON decodificado de volta ao isolate principal.

A classe expõe dois métodos públicos: um que gera o worker
isolate, e um que manipula o envio de mensagens para esse worker isolate.

As seções restantes neste exemplo mostrarão como
preencher os métodos da classe, um por um.

<?code-excerpt "lib/basic_ports_example/start.dart (worker)"?>
```dart
class Worker {
  Future<void> spawn() async {
    // TODO: Add functionality to spawn a worker isolate.
  }

  void _handleResponsesFromIsolate(dynamic message) {
    // TODO: Handle messages sent back from the worker isolate.
  }

  static void _startRemoteIsolate(SendPort port) {
    // TODO: Define code that should be executed on the worker isolate.
  }

  Future<void> parseJson(String message) async {
    // TODO: Define a public method that can
    // be used to send messages to the worker isolate.
  }
}
```

#### Passo 2: Gerar um worker isolate

O método `Worker.spawn` é onde você agrupará o código para criar o
worker isolate e garantir que ele possa receber e enviar mensagens.

- Primeiro, crie um `ReceivePort`. Isso permite que o isolate principal receba
  mensagens enviadas do worker isolate recém-gerado.
- Em seguida, adicione um listener ao receive port para manipular mensagens que o worker isolate
  enviará de volta. O callback passado ao
  listener, `_handleResponsesFromIsolate`, será coberto
  no [passo 4](#step-4-handle-messages-on-the-main-isolate).
- Finalmente, gere o worker isolate com `Isolate.spawn`. Ele espera dois
  argumentos: uma função a ser executada no worker isolate
  (coberta no [passo 3](#step-3-execute-code-on-the-worker-isolate)),
  e a propriedade `sendPort` do receive port.

<?code-excerpt "lib/basic_ports_example/complete.dart (spawn)"?>
```dart
Future<void> spawn() async {
  final receivePort = ReceivePort();
  receivePort.listen(_handleResponsesFromIsolate);
  await Isolate.spawn(_startRemoteIsolate, receivePort.sendPort);
}
```

O argumento `receivePort.sendPort` será passado ao
callback (`_startRemoteIsolate`) como um argumento quando for chamado no
worker isolate. Este é o primeiro passo para garantir que o worker isolate tenha uma
maneira de enviar mensagens de volta ao isolate principal.

#### Passo 3: Executar código no worker isolate

Neste passo, você define o método `_startRemoteIsolate` que é enviado ao
worker isolate para ser executado quando ele é gerado. Este método é como o método "main"
para o worker isolate.

- Primeiro, crie outro novo `ReceivePort`. Este port recebe
  mensagens futuras do isolate principal.
- Em seguida, envie o `SendPort` desse port de volta ao isolate principal.
- Finalmente, adicione um listener ao novo `ReceivePort`. Este listener manipula
  mensagens que o isolate principal envia ao worker isolate.

<?code-excerpt "lib/basic_ports_example/complete.dart (start-remote-isolate)"?>
```dart
static void _startRemoteIsolate(SendPort port) {
  final receivePort = ReceivePort();
  port.send(receivePort.sendPort);

  receivePort.listen((dynamic message) async {
    if (message is String) {
      final transformed = jsonDecode(message);
      port.send(transformed);
    }
  });
}
```

O listener no `ReceivePort` do worker decodifica o JSON passado do isolate principal,
e então envia o JSON decodificado de volta ao isolate principal.

Este listener é o ponto de entrada para mensagens enviadas do isolate principal ao
worker isolate. **Esta é a única chance que você tem de dizer ao worker isolate que código
executar no futuro.**

#### Passo 4: Manipular mensagens no isolate principal

Finalmente, você precisa dizer ao isolate principal como manipular mensagens enviadas do
worker isolate de volta ao isolate principal. Para fazer isso, você precisa preencher
o método `_handleResponsesFromIsolate`. Lembre-se que este método é passado ao
método `receivePort.listen`, conforme descrito
no [passo 2](#step-2-spawn-a-worker-isolate):

<?code-excerpt "lib/basic_ports_example/complete.dart (spawn)"?>
```dart
Future<void> spawn() async {
  final receivePort = ReceivePort();
  receivePort.listen(_handleResponsesFromIsolate);
  await Isolate.spawn(_startRemoteIsolate, receivePort.sendPort);
}
```

Lembre-se também que você enviou um `SendPort` de volta ao isolate principal
no [passo 3](#step-3-execute-code-on-the-worker-isolate). Este método manipula o
recebimento desse `SendPort`, bem como o recebimento de mensagens futuras (que serão
JSON decodificado).

- Primeiro, verifique se a mensagem é um `SendPort`. Se for, atribua esse port à
  propriedade `_sendPort` da classe para que possa ser usado para enviar mensagens depois.
- Em seguida, verifique se a mensagem é do tipo `Map<String, dynamic>`, o tipo esperado
  de JSON decodificado. Se for, manipule essa mensagem com sua
  lógica específica da aplicação. Neste exemplo, a mensagem é impressa.

<?code-excerpt "lib/basic_ports_example/complete.dart (handle-responses)"?>
```dart
void _handleResponsesFromIsolate(dynamic message) {
  if (message is SendPort) {
    _sendPort = message;
    _isolateReady.complete();
  } else if (message is Map<String, dynamic>) {
    print(message);
  }
}
```

#### Passo 5: Adicionar um completer para garantir que seu isolate esteja configurado

Para completar a classe, defina um método público chamado `parseJson`, que é
responsável por enviar mensagens ao worker isolate. Ele também precisa garantir
que mensagens possam ser enviadas antes do isolate estar totalmente configurado.
Para lidar com isso, use um [`Completer`][].

- Primeiro, adicione uma propriedade de nível de classe chamada `Completer` e nomeie-a
  `_isolateReady`.
- Em seguida, adicione uma chamada a `complete()` no completer no
  método `_handleResponsesFromIsolate` (criado no [passo 4](#step-4-handle-messages-on-the-main-isolate)) se a mensagem for
  um `SendPort`.
- Finalmente, no método `parseJson`, adicione `await _isolateReady.future` antes
  de adicionar `_sendPort.send`. Isso garante que nenhuma mensagem possa ser enviada ao
  worker isolate até que ele seja gerado _e_ tenha enviado seu `SendPort` de volta ao
  isolate principal.

<?code-excerpt "lib/basic_ports_example/complete.dart (parse-json)"?>
```dart
Future<void> parseJson(String message) async {
  await _isolateReady.future;
  _sendPort.send(message);
}
```

#### Exemplo completo

<details>
  <summary>Expanda para ver o exemplo completo</summary>

  <?code-excerpt "lib/basic_ports_example/complete.dart"?>
  ```dart
  import 'dart:async';
  import 'dart:convert';
  import 'dart:isolate';

  void main() async {
    final worker = Worker();
    await worker.spawn();
    await worker.parseJson('{"key":"value"}');
  }

  class Worker {
    late SendPort _sendPort;
    final Completer<void> _isolateReady = Completer.sync();

    Future<void> spawn() async {
      final receivePort = ReceivePort();
      receivePort.listen(_handleResponsesFromIsolate);
      await Isolate.spawn(_startRemoteIsolate, receivePort.sendPort);
    }

    void _handleResponsesFromIsolate(dynamic message) {
      if (message is SendPort) {
        _sendPort = message;
        _isolateReady.complete();
      } else if (message is Map<String, dynamic>) {
        print(message);
      }
    }

    static void _startRemoteIsolate(SendPort port) {
      final receivePort = ReceivePort();
      port.send(receivePort.sendPort);

      receivePort.listen((dynamic message) async {
        if (message is String) {
          final transformed = jsonDecode(message);
          port.send(transformed);
        }
      });
    }

    Future<void> parseJson(String message) async {
      await _isolateReady.future;
      _sendPort.send(message);
    }

  }
  ```

</details>

### Exemplo de ports robustos

O [exemplo anterior][] explicou os blocos de construção básicos necessários para configurar um
isolate de longa duração com comunicação bidirecional. Como mencionado, esse exemplo carece
de alguns recursos importantes, como tratamento de erros, a capacidade de fechar os
ports quando eles não estão mais em uso, e inconsistências em torno da ordenação de mensagens
em algumas situações.

Este exemplo expande as informações do primeiro exemplo criando um
worker isolate de longa duração que tem esses recursos adicionais e mais, e
segue melhores padrões de design. Embora este código tenha semelhanças com o primeiro
exemplo, não é uma extensão desse exemplo.

:::note
Este exemplo assume que você já está familiarizado com
estabelecer comunicação entre isolates com `Isolate.spawn` e ports,
que foi coberto no [exemplo anterior][].
:::

#### Passo 1: Definir a classe worker

Primeiro, crie uma classe para seu worker isolate em segundo plano. Esta classe contém
toda a funcionalidade que você precisa para:

- Gerar um isolate.
- Enviar mensagens para esse isolate.
- Fazer o isolate decodificar algum JSON.
- Enviar o JSON decodificado de volta ao isolate principal.

A classe expõe três métodos públicos: um que cria o worker
isolate, um que manipula o envio de mensagens para esse worker isolate, e um
que pode encerrar os ports quando eles não estão mais em uso.

<?code-excerpt "lib/robust_ports_example/start.dart (worker)"?>
```dart
class Worker {
  final SendPort _commands;
  final ReceivePort _responses;

  Future<Object?> parseJson(String message) async {
    // TODO: Ensure the port is still open.
    _commands.send(message);
  }

  static Future<Worker> spawn() async {
    // TODO: Add functionality to create a new Worker object with a
    //  connection to a spawned isolate.
    throw UnimplementedError();
  }

  Worker._(this._responses, this._commands) {
    // TODO: Initialize main isolate receive port listener.
  }

  void _handleResponsesFromIsolate(dynamic message) {
    // TODO: Handle messages sent back from the worker isolate.
  }

  static void _handleCommandsToIsolate(ReceivePort rp, SendPort sp) async {
    // TODO: Handle messages sent back from the worker isolate.
  }

  static void _startRemoteIsolate(SendPort sp) {
    // TODO: Initialize worker isolate's ports.
  }
}
```

:::note
Neste exemplo, instâncias de `SendPort` e `ReceivePort`
seguem uma convenção de nomenclatura de melhores práticas, em que são nomeados em relação ao
isolate principal. As mensagens enviadas através do `SendPort` do isolate principal
ao worker isolate são chamadas de _commands_, e as mensagens enviadas de volta ao
isolate principal são chamadas de _responses_.
:::

#### Passo 2: Criar um `RawReceivePort` no método `Worker.spawn`

Antes de gerar um isolate, você precisa criar um [`RawReceivePort`][], que é
um `ReceivePort` de nível mais baixo. Usar `RawReceivePort` é um padrão preferido
porque permite que você separe sua lógica de inicialização de isolate da lógica que
manipula a passagem de mensagens no isolate.

No método `Worker.spawn`:

- Primeiro, crie o `RawReceivePort`. Este `ReceivePort` é apenas responsável por
  receber a mensagem inicial do worker isolate, que será
  um `SendPort`.
- Em seguida, crie um `Completer` que indicará quando o isolate está pronto para
  receber mensagens. Quando isso completar, retornará um record com
  um `ReceivePort` e um `SendPort`.
- Em seguida, defina a propriedade `RawReceivePort.handler`. Esta propriedade é
  uma `Function?` que se comporta como `ReceivePort.listener`. A função é chamada
  quando uma mensagem é recebida por este port.
- Dentro da função handler, chame `connection.complete()`. Este método espera
  um [record][] com um `ReceivePort` e um `SendPort` como argumento.
  O `SendPort` é a mensagem inicial enviada do worker isolate, que será
  atribuído no próximo passo à `SendPort` de nível de classe chamada `_commands`.
- Então, crie um novo `ReceivePort` com
  o construtor `ReceivePort.fromRawReceivePort`, e passe o
  `initPort`.

<?code-excerpt "lib/robust_ports_example/spawn_1.dart (worker-spawn)" plaster="none"?>
```dart
class Worker {
  final SendPort _commands;
  final ReceivePort _responses;

  static Future<Worker> spawn() async {
    // Create a receive port and add its initial message handler.
    final initPort = RawReceivePort();
    final connection = Completer<(ReceivePort, SendPort)>.sync();
    initPort.handler = (initialMessage) {
      final commandPort = initialMessage as SendPort;
      connection.complete((
        ReceivePort.fromRawReceivePort(initPort),
        commandPort,
      ));
    };
  }
}
```

Ao criar um `RawReceivePort` primeiro, e depois um `ReceivePort`, você será capaz
de adicionar um novo callback a `ReceivePort.listen` mais tarde. Por outro lado, se você fosse
criar um `ReceivePort` diretamente, você só poderia adicionar
um `listener`, porque `ReceivePort` implementa [`Stream`][], em vez
de [`BroadcastStream`][].

Efetivamente, isso permite que você separe sua lógica de inicialização de isolate da
lógica que manipula o recebimento de mensagens após a configuração de comunicação estar
completa. Este benefício se tornará mais óbvio conforme a lógica nos outros
métodos crescer.

#### Passo 3: Gerar um worker isolate com `Isolate.spawn`

Este passo continua a preencher o método `Worker.spawn`. Você adicionará o código
necessário para gerar um isolate e retornar uma instância de `Worker` desta classe.
Neste exemplo, a chamada a `Isolate.spawn` é envolvida em
um [bloco `try`/`catch`][], que garante que, se o isolate falhar ao iniciar,
o `initPort` será fechado, e o objeto `Worker` não será criado.

- Primeiro, tente gerar um worker isolate em um bloco `try`/`catch`. Se gerar
  um worker isolate falhar, feche o receive port que foi criado no
  passo anterior. O método passado a `Isolate.spawn` será coberto em um passo
  posterior.
- Em seguida, aguarde o `connection.future`, e desestruture o send port e
  receive port do record que ele retorna.
- Finalmente, retorne uma instância de `Worker` chamando seu construtor privado,
  e passando os ports desse completer.

<?code-excerpt "lib/robust_ports_example/spawn_2.dart (worker-spawn)" plaster="none"?>
```dart
class Worker {
  final SendPort _commands;
  final ReceivePort _responses;

  static Future<Worker> spawn() async {
    // Create a receive port and add its initial message handler.
    final initPort = RawReceivePort();
    final connection = Completer<(ReceivePort, SendPort)>.sync();
    initPort.handler = (initialMessage) {
      final commandPort = initialMessage as SendPort;
      connection.complete((
        ReceivePort.fromRawReceivePort(initPort),
        commandPort,
      ));
    };
    // Spawn the isolate.
    try {
      await Isolate.spawn(_startRemoteIsolate, (initPort.sendPort));
    } on Object {
      initPort.close();
      rethrow;
    }

    final (ReceivePort receivePort, SendPort sendPort) =
        await connection.future;

    return Worker._(receivePort, sendPort);
  }
}
```

Note que neste exemplo (comparado ao [exemplo anterior][]), `Worker.spawn`
atua como um construtor estático assíncrono para esta classe e é a única maneira de
criar uma instância de `Worker`. Isso simplifica a API, tornando o código que
cria uma instância de `Worker` mais limpo.

#### Passo 4: Completar o processo de configuração do isolate

Neste passo, você completará o processo básico de configuração do isolate. Isso se correlaciona
quase inteiramente ao [exemplo anterior][], e não há novos conceitos.
Há uma pequena mudança em que o código é dividido em mais métodos, que
é uma prática de design que
o prepara para adicionar mais funcionalidade através do restante deste exemplo.
Para uma explicação detalhada do processo básico de configuração de um isolate, veja
o [exemplo de ports básicos](#basic-ports-example).

Primeiro, crie o construtor privado que é retornado do método `Worker.spawn`.
No corpo do construtor, adicione um listener ao receive port usado pelo
isolate principal, e passe um método ainda não definido a esse listener
chamado `_handleResponsesFromIsolate`.

<?code-excerpt "lib/robust_ports_example/step_4.dart (constructor)" plaster="none"?>
```dart
class Worker {
  final SendPort _commands;
  final ReceivePort _responses;

  Worker._(this._responses, this._commands) {
    _responses.listen(_handleResponsesFromIsolate);
  }
}
```

Em seguida, adicione o código a `_startRemoteIsolate` que é responsável por inicializar
os ports no worker
isolate. [Lembre-se](#step-3-spawn-a-worker-isolate-with-isolate-spawn) que este
método foi passado a `Isolate.spawn` no método `Worker.spawn`, e ele receberá
o `SendPort` do isolate principal como um argumento.

- Crie um novo `ReceivePort`.
- Envie o `SendPort` desse port de volta ao isolate principal.
- Chame um novo método chamado `_handleCommandsToIsolate`, e passe tanto o
  novo `ReceivePort` quanto o `SendPort` do isolate principal como argumentos.

<?code-excerpt "lib/robust_ports_example/step_4.dart (start-isolate)"?>
```dart
static void _startRemoteIsolate(SendPort sendPort) {
  final receivePort = ReceivePort();
  sendPort.send(receivePort.sendPort);
  _handleCommandsToIsolate(receivePort, sendPort);
}
```

Em seguida, adicione o método `_handleCommandsToIsolate`, que é responsável por
receber mensagens do isolate principal, decodificar json no worker isolate,
e enviar o json decodificado de volta como uma resposta.

- Primeiro, declare um listener no `ReceivePort` do worker isolate.
- Dentro do callback adicionado ao listener, tente decodificar o JSON passado
  do isolate principal dentro de um [bloco `try`/`catch`][]. Se a decodificação for
  bem-sucedida, envie o JSON decodificado de volta ao isolate principal.
- Se houver um erro, envie de volta um [`RemoteError`][].

<?code-excerpt "lib/robust_ports_example/step_4.dart (handle-commands)"?>
```dart
static void _handleCommandsToIsolate(
  ReceivePort receivePort,
  SendPort sendPort,
) {
  receivePort.listen((message) {
    try {
      final jsonData = jsonDecode(message as String);
      sendPort.send(jsonData);
    } catch (e) {
      sendPort.send(RemoteError(e.toString(), ''));
    }
  });
}
```

Em seguida, adicione o código para o método `_handleResponsesFromIsolate`.

- Primeiro, verifique se a mensagem é um `RemoteError`, caso em que você
  deve `throw` esse erro.
- Caso contrário, imprima a mensagem. Em passos futuros, você atualizará este código para
  retornar mensagens em vez de imprimi-las.

<?code-excerpt "lib/robust_ports_example/step_4.dart (handle-response)"?>
```dart
void _handleResponsesFromIsolate(dynamic message) {
  if (message is RemoteError) {
    throw message;
  } else {
    print(message);
  }
}
```

Finalmente, adicione o método `parseJson`, que é um método público que permite
código externo enviar JSON ao worker isolate para ser decodificado.

<?code-excerpt "lib/robust_ports_example/step_4.dart (parse-json)"?>
```dart
Future<Object?> parseJson(String message) async {
  _commands.send(message);
}
```

Você atualizará este método no próximo passo.

#### Passo 5: Manipular múltiplas mensagens ao mesmo tempo

Atualmente, se você enviar mensagens rapidamente ao worker isolate, o isolate
enviará a resposta json decodificada _na ordem em que elas completam_, em vez de
na ordem em que são enviadas. Você não tem maneira de determinar qual resposta
corresponde a qual mensagem.

Neste passo, você corrigirá este problema dando a cada mensagem um id, e
usando objetos `Completer` para garantir que quando código externo chama `parseJson` a
resposta que é retornada ao chamador é a resposta correta.

Primeiro, adicione duas propriedades de nível de classe a `Worker`:

- `Map<int, Completer<Object?>> _activeRequests`
- `int _idCounter`

<?code-excerpt "lib/robust_ports_example/step_5_add_completers.dart (vars)"?>
```dart
class Worker {
  final SendPort _commands;
  final ReceivePort _responses;
  final Map<int, Completer<Object?>> _activeRequests = {};
  int _idCounter = 0;
  // ···
}
```

O mapa `_activeRequests` associa uma mensagem enviada ao worker isolate
com um `Completer`. As chaves usadas em `_activeRequests` são tiradas
de `_idCounter`, que será incrementado conforme mais mensagens são enviadas.

Em seguida, atualize o método `parseJson` para criar completers antes de enviar
mensagens ao worker isolate.

- Primeiro crie um `Completer`.
- Em seguida, incremente `_idCounter`, para que cada `Completer` seja associado a um
  número único.
- Adicione uma entrada ao mapa `_activeRequests` em que a chave é o
  número atual de `_idCounter`, e o completer é o valor.
- Envie a mensagem ao worker isolate, junto com o id. Como você só pode
  enviar um valor através do `SendPort`, envolva o id e a mensagem em um
  [record][].
- Finalmente, retorne a future do completer, que eventualmente conterá a
  resposta do worker isolate.

<?code-excerpt "lib/robust_ports_example/step_5_add_completers.dart (parse-json)"?>
```dart
Future<Object?> parseJson(String message) async {
  final completer = Completer<Object?>.sync();
  final id = _idCounter++;
  _activeRequests[id] = completer;
  _commands.send((id, message));
  return await completer.future;
}
```

Você também precisa atualizar `_handleResponsesFromIsolate`
e `_handleCommandsToIsolate` para manipular este sistema.

Em `_handleCommandsToIsolate`, você precisa considerar que a `message` seja um
record com dois valores, em vez de apenas o texto json. Faça isso desestruturando
os valores de `message`.

Então, após decodificar o json, atualize a chamada a `sendPort.send` para passar tanto
o id quanto o json decodificado de volta ao isolate principal, novamente usando um record.

<?code-excerpt "lib/robust_ports_example/step_5_add_completers.dart (handle-commands)"?>
```dart
static void _handleCommandsToIsolate(
  ReceivePort receivePort,
  SendPort sendPort,
) {
  receivePort.listen((message) {
    final (int id, String jsonText) = message as (int, String); // New
    try {
      final jsonData = jsonDecode(jsonText);
      sendPort.send((id, jsonData)); // Updated
    } catch (e) {
      sendPort.send((id, RemoteError(e.toString(), '')));
    }
  });
}
```

Finalmente, atualize o `_handleResponsesFromIsolate`.

- Primeiro, desestruture o id e a resposta do argumento message novamente.
- Então, remova o completer que corresponde a esta requisição do
  mapa `_activeRequests`.
- Por último, em vez de lançar um erro ou imprimir o json decodificado, complete
  o completer, passando a resposta. Quando isso completar, a resposta será
  retornada ao código que chamou `parseJson` no isolate principal.

<?code-excerpt "lib/robust_ports_example/step_5_add_completers.dart (handle-response)"?>
```dart
void _handleResponsesFromIsolate(dynamic message) {
  final (int id, Object? response) = message as (int, Object?); // New
  final completer = _activeRequests.remove(id)!; // New

  if (response is RemoteError) {
    completer.completeError(response); // Updated
  } else {
    completer.complete(response); // Updated
  }
}
```

#### Passo 6: Adicionar funcionalidade para fechar os ports

Quando o isolate não estiver mais sendo usado pelo seu código, você deve fechar os
ports no isolate principal e no worker isolate.

- Primeiro, adicione um booleano de nível de classe que rastreia se os ports estão fechados.
- Então, adicione o método `Worker.close`. Dentro deste método:
  - Atualize `_closed` para ser true.
  - Envie uma mensagem final ao worker isolate.
    Esta mensagem é uma `String` que lê "shutdown",
    mas poderia ser qualquer objeto que você desejar.
    Você a usará no próximo trecho de código.
- Finalmente, verifique se `_activeRequests` está vazio. Se estiver, feche o
  `ReceivePort` do isolate principal chamado `_responses`.

<?code-excerpt "lib/robust_ports_example/step_6_close_ports.dart (close)"?>
```dart
class Worker {
  bool _closed = false;
  // ···
  void close() {
    if (!_closed) {
      _closed = true;
      _commands.send('shutdown');
      if (_activeRequests.isEmpty) _responses.close();
      print('--- port closed --- ');
    }
  }
}
```

- Em seguida, você precisa manipular a mensagem "shutdown" no worker isolate. Adicione o
  seguinte código ao método `_handleCommandsToIsolate`. Este código verificará se
  a mensagem é uma `String` que lê "shutdown". Se for, fechará o
  `ReceivePort` do worker isolate, e retornará.

<?code-excerpt "lib/robust_ports_example/step_6_close_ports.dart (handle-commands)"?>
```dart
static void _handleCommandsToIsolate(
  ReceivePort receivePort,
  SendPort sendPort,
) {
  receivePort.listen((message) {
    // New if-block.
    if (message == 'shutdown') {
      receivePort.close();
      return;
    }
    final (int id, String jsonText) = message as (int, String);
    try {
      final jsonData = jsonDecode(jsonText);
      sendPort.send((id, jsonData));
    } catch (e) {
      sendPort.send((id, RemoteError(e.toString(), '')));
    }
  });
}
```

- Finalmente, você deve adicionar código para verificar se os ports estão fechados antes de tentar
  enviar mensagens. Adicione uma linha no método `Worker.parseJson`.

<?code-excerpt "lib/robust_ports_example/step_6_close_ports.dart (parse-json)"?>
```dart
Future<Object?> parseJson(String message) async {
  if (_closed) throw StateError('Closed'); // New
  final completer = Completer<Object?>.sync();
  final id = _idCounter++;
  _activeRequests[id] = completer;
  _commands.send((id, message));
  return await completer.future;
}
```

#### Exemplo completo

<details>
  <summary>Expanda aqui para ver o exemplo completo</summary>

<?code-excerpt "lib/robust_ports_example/complete.dart"?>
```dart
import 'dart:async';
import 'dart:convert';
import 'dart:isolate';

void main() async {
  final worker = await Worker.spawn();
  print(await worker.parseJson('{"key":"value"}'));
  print(await worker.parseJson('"banana"'));
  print(await worker.parseJson('[true, false, null, 1, "string"]'));
  print(
    await Future.wait([worker.parseJson('"yes"'), worker.parseJson('"no"')]),
  );
  worker.close();
}

class Worker {
  final SendPort _commands;
  final ReceivePort _responses;
  final Map<int, Completer<Object?>> _activeRequests = {};
  int _idCounter = 0;
  bool _closed = false;

  Future<Object?> parseJson(String message) async {
    if (_closed) throw StateError('Closed');
    final completer = Completer<Object?>.sync();
    final id = _idCounter++;
    _activeRequests[id] = completer;
    _commands.send((id, message));
    return await completer.future;
  }

  static Future<Worker> spawn() async {
    // Create a receive port and add its initial message handler.
    final initPort = RawReceivePort();
    final connection = Completer<(ReceivePort, SendPort)>.sync();
    initPort.handler = (initialMessage) {
      final commandPort = initialMessage as SendPort;
      connection.complete((
        ReceivePort.fromRawReceivePort(initPort),
        commandPort,
      ));
    };

    // Spawn the isolate.
    try {
      await Isolate.spawn(_startRemoteIsolate, (initPort.sendPort));
    } on Object {
      initPort.close();
      rethrow;
    }

    final (ReceivePort receivePort, SendPort sendPort) =
        await connection.future;

    return Worker._(receivePort, sendPort);
  }

  Worker._(this._responses, this._commands) {
    _responses.listen(_handleResponsesFromIsolate);
  }

  void _handleResponsesFromIsolate(dynamic message) {
    final (int id, Object? response) = message as (int, Object?);
    final completer = _activeRequests.remove(id)!;

    if (response is RemoteError) {
      completer.completeError(response);
    } else {
      completer.complete(response);
    }

    if (_closed && _activeRequests.isEmpty) _responses.close();
  }

  static void _handleCommandsToIsolate(
    ReceivePort receivePort,
    SendPort sendPort,
  ) {
    receivePort.listen((message) {
      if (message == 'shutdown') {
        receivePort.close();
        return;
      }
      final (int id, String jsonText) = message as (int, String);
      try {
        final jsonData = jsonDecode(jsonText);
        sendPort.send((id, jsonData));
      } catch (e) {
        sendPort.send((id, RemoteError(e.toString(), '')));
      }
    });
  }

  static void _startRemoteIsolate(SendPort sendPort) {
    final receivePort = ReceivePort();
    sendPort.send(receivePort.sendPort);
    _handleCommandsToIsolate(receivePort, sendPort);
  }

  void close() {
    if (!_closed) {
      _closed = true;
      _commands.send('shutdown');
      if (_activeRequests.isEmpty) _responses.close();
      print('--- port closed --- ');
    }
  }
}
```

</details>

[`Isolate.exit()`]: {{site.dart-api}}/dart-isolate/Isolate/exit.html
[`Isolate.spawn()`]: {{site.dart-api}}/dart-isolate/Isolate/spawn.html
[`ReceivePort`]: {{site.dart-api}}/dart-isolate/ReceivePort-class.html
[`SendPort`]: {{site.dart-api}}/dart-isolate/SendPort-class.html
[Método `SendPort.send()`]: {{site.dart-api}}/dart-isolate/SendPort/send.html
[main isolate]: /language/concurrency#isolates
[`Stream`]: {{site.dart-api}}/dart-async/Stream-class.html
[`BroadcastStream`]: {{site.dart-api}}/dart-async/BroadcastStream-class.html
[`Completer`]: {{site.dart-api}}/dart-async/Completer-class.html
[`RawReceivePort`]: {{site.dart-api}}/dart-isolate/RawReceivePort-class.html
[record]: /language/records
[exemplo anterior]: #basic-ports-example
[bloco `try`/`catch`]: /language/error-handling#catch
[`RemoteError`]: {{site.dart-api}}/dart-isolate/RemoteError-class.html
