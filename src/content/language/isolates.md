---
ia-translate: true
title: Isolates
description: Information on writing isolates in Dart.
shortTitle: Isolates
lastVerified: 2024-01-04
prevpage:
  url: /language/async
  title: Suporte assíncrono
nextpage:
  url: /null-safety
  title: Sound null safety
---

<?code-excerpt path-base="concurrency"?>

This page discusses some examples that use the `Isolate` API to implement 
isolates.

Você deve usar isolates sempre que seu aplicativo estiver lidando com computações
que são grandes o suficiente para bloquear temporariamente outras computações.
O exemplo mais comum é em aplicativos [Flutter][Flutter], quando você
precisa realizar grandes computações que, de outra forma, podem fazer com que a
UI fique sem resposta.

Não há regras sobre quando você _deve_ usar isolates,
mas aqui estão algumas situações adicionais onde eles podem ser úteis:

- Analisando e decodificando blobs JSON excepcionalmente grandes.
- Processando e comprimindo fotos, áudio e vídeo.
- Convertendo arquivos de áudio e vídeo.
- Realizando buscas complexas e filtragem em grandes listas ou dentro de
  sistemas de arquivos.
- Realizando I/O, como comunicação com um banco de dados.
- Lidando com um grande volume de requisições de rede.

[Flutter]: {{site.flutter-docs}}/perf/isolates

## Implementando um isolate de trabalho simples {:#implementing-a-simple-worker-isolate}

Estes exemplos implementam um isolate principal
que gera um isolate de trabalho simples.
[`Isolate.run()`][`Isolate.run()`] simplifica as etapas por trás
da configuração e gerenciamento de isolates de trabalho:

1. Gera (inicia e cria) um isolate.
2. Executa uma função no isolate gerado.
3. Captura o resultado.
4. Retorna o resultado para o isolate principal.
5. Encerra o isolate assim que o trabalho é concluído.
6. Verifica, captura e lança exceções e erros de volta para o isolate principal.

[`Isolate.run()`]: {{site.dart-api}}/dart-isolate/Isolate/run.html

:::flutter-note
Se você estiver usando o Flutter, você pode usar a [função `compute` do Flutter][função `compute` do Flutter]
em vez de `Isolate.run()`.
:::

[função `compute` do Flutter]: {{site.flutter-api}}/flutter/foundation/compute.html

### Executando um método existente em um novo isolate {:#running-an-existing-method-in-a-new-isolate}

1. Chame `run()` para gerar um novo isolate (um [worker em background][worker em background]),
   diretamente no [isolate principal][isolate principal] enquanto `main()` aguarda o resultado:

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

2. Passe para o isolate de trabalho a função que você deseja que ele execute
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
   e envia o valor de volta para o isolate principal,
   desligando o isolate de trabalho.

4. O isolate de trabalho *transfere* a memória que contém o resultado
   para o isolate principal. Ele *não copia* os dados.
   O isolate de trabalho realiza uma passagem de verificação para garantir
   que os objetos possam ser transferidos.

`_readAndParseJson()` é uma função assíncrona existente,
que poderia ser facilmente
executada diretamente no isolate principal.
Usar `Isolate.run()` para executá-la permite a simultaneidade.
O isolate de trabalho abstrai completamente as computações
de `_readAndParseJson()`. Ele pode ser concluído sem bloquear o isolate principal.

O resultado de `Isolate.run()` é sempre um Future,
porque o código no isolate principal continua a ser executado.
Se a computação que o isolate de trabalho executa
é síncrona ou assíncrona, isso não impacta o
isolate principal, porque ele está sendo executado simultaneamente de qualquer maneira.

Para o programa completo, consulte o exemplo [send_and_receive.dart][send_and_receive.dart].

[send_and_receive.dart]: {{site.repo.dart.samples}}/blob/main/isolates/bin/send_and_receive.dart
[background worker]: /language/concurrency#background-workers
[main isolate]: /language/concurrency#the-main-isolate

### Enviando closures com isolates {:#sending-closures-with-isolates}

Você também pode criar um isolate de trabalho simples com `run()` usando uma
função literal, ou closure, diretamente no isolate principal.

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
Um novo isolate é gerado, computa algo e envia o resultado de volta.

No entanto, agora o isolate envia uma [closure][closure].
Closures são menos limitadas do que as funções nomeadas típicas,
tanto em como elas funcionam quanto em como são escritas no código.
Neste exemplo, `Isolate.run()` executa o que parece ser código local,
concorrentemente. Nesse sentido, você pode imaginar `run()` funcionando como um
operador de fluxo de controle para "executar em paralelo".

[closure]: /language/functions#anonymous-functions

## Enviando múltiplas mensagens entre isolates com ports {:#sending-multiple-messages-between-isolates-with-ports}

Isolates de curta duração são convenientes de usar,
mas exigem sobrecarga de desempenho para gerar novos isolates
e para copiar objetos de um isolate para outro.
Se seu código depende da execução repetida da mesma computação
usando `Isolate.run`, você pode melhorar o desempenho criando
isolates de longa duração que não saem imediatamente.

Para fazer isso, você pode usar algumas das APIs de baixo nível de isolate que
`Isolate.run` abstrai:

* [`Isolate.spawn()`][`Isolate.spawn()`] e [`Isolate.exit()`][`Isolate.exit()`]
* [`ReceivePort`][`ReceivePort`] e [`SendPort`][`SendPort`]
* [`Método SendPort.send()`][`Método SendPort.send()`]


Esta seção aborda as etapas necessárias para estabelecer
uma comunicação bidirecional entre um isolate recém-gerado
e o [isolate principal][isolate principal].
O primeiro exemplo, [Ports básicos](#basic-ports-example), introduz o processo
em um nível alto. O segundo exemplo, [Ports robustos](#robust-ports-example),
adiciona gradualmente mais funcionalidades práticas e do mundo real ao primeiro.

[`Isolate.exit()`]: {{site.dart-api}}/dart-isolate/Isolate/exit.html
[`Isolate.spawn()`]: {{site.dart-api}}/dart-isolate/Isolate/spawn.html
[`ReceivePort`]: {{site.dart-api}}/dart-isolate/ReceivePort-class.html
[`SendPort`]: {{site.dart-api}}/dart-isolate/SendPort-class.html
[`Método SendPort.send()`]: {{site.dart-api}}/dart-isolate/SendPort/send.html
[isolate principal]: /language/concurrency#isolates


### `ReceivePort` e `SendPort` {:#receiveport-and-sendport}

Configurar comunicação de longa duração entre isolates requer
duas classes (além de `Isolate`): `ReceivePort` e `SendPort`.
Esses ports são a única maneira pela qual os isolates podem se comunicar entre si.

Um `ReceivePort` é um objeto que lida com mensagens que são enviadas de outros
isolates. Essas mensagens são enviadas por meio de um `SendPort`.

:::note
Um objeto `SendPort` está associado a exatamente um `ReceivePort`,
mas um único `ReceivePort` pode ter muitos `SendPort`.
Quando você cria um `ReceivePort`, ele cria um `SendPort` para si mesmo.
Você pode criar `SendPort` adicionais que
podem enviar mensagens para um `ReceivePort` existente.
:::

Ports se comportam de maneira semelhante a objetos [`Stream`][`Stream`]
(na verdade, os receive ports implementam `Stream`!)
Você pode pensar em um `SendPort` e um `ReceivePort` como
`StreamController` e ouvintes de Stream, respectivamente.
Um `SendPort` é como um `StreamController` porque você "adiciona" mensagens a eles
com o [`Método SendPort.send()`][`Método SendPort.send()`], e essas mensagens são tratadas por um ouvinte,
neste caso o `ReceivePort`. O `ReceivePort` então lida com as mensagens que
recebe, passando-as como argumentos para um callback que você fornece.

#### Configurando ports {:#setting-up-ports}

Um isolate recém-gerado só tem as informações que recebe através da
chamada `Isolate.spawn`. Se você precisa que o isolate principal continue a se comunicar
com um isolate gerado após sua criação inicial, você deve configurar um
canal de comunicação onde o isolate gerado pode enviar mensagens para o
isolate principal. Isolates só podem se comunicar através da passagem de mensagens.
Eles não podem "ver" dentro da memória um do outro,
que é de onde vem o nome "isolate".

Para configurar essa comunicação bidirecional, primeiro crie um [`ReceivePort`][`ReceivePort`]
no isolate principal, depois passe seu [`SendPort`][`SendPort`] como argumento para o
novo isolate ao gerá-lo com `Isolate.spawn`.
O novo isolate então cria seu próprio `ReceivePort` e envia _seu_ `SendPort`
de volta no `SendPort` que foi passado pelo isolate principal.
O isolate principal recebe este `SendPort` e
agora ambos os lados têm um canal aberto para enviar e receber mensagens.

:::note
The diagrams in this section are high-level and intended to convey the 
_concept_ of using ports for isolates. Actual implementation requires 
a bit more code, which you will find 
[later on this page](#basic-ports-example).
:::

![A figure showing events being fed, one by one, into the event loop](/assets/img/language/concurrency/ports-setup.png){:.diagram-wrap}

1. Crie um `ReceivePort` no isolate principal. O `SendPort` é criado
   automaticamente como uma propriedade no `ReceivePort`.
2. Gere o isolate de trabalho com `Isolate.spawn()`
3. Passe uma referência para `ReceivePort.sendPort` como a primeira mensagem para o
   isolate de trabalho.
4. Crie outro novo `ReceivePort` no isolate de trabalho.
5. Passe uma referência para `ReceivePort.sendPort` do isolate de trabalho como a
   primeira mensagem _de volta_ para o isolate principal.

Juntamente com a criação dos ports e configuração da comunicação, você também precisará
dizer aos ports o que fazer quando receberem mensagens. Isso é feito usando
o método `listen` em cada `ReceivePort` respectivo.

![A figure showing events being fed, one by one, into the event loop](/assets/img/language/concurrency/ports-passing-messages.png){:.diagram-wrap}

1. Envie uma mensagem através da referência do isolate principal para o isolate de trabalho
   `SendPort`.
2. Receba e lide com a mensagem através de um listener no isolate de trabalho
   `ReceivePort`. É aqui que a computação que você deseja remover do
   isolate principal é executada.
3. Envie uma mensagem de retorno através da referência do isolate de trabalho para o
   isolate principal `SendPort`.
4. Receba a mensagem através de um listener no isolate principal `ReceivePort`.

### Exemplo de ports básicos {:#basic-ports-example}

Este exemplo demonstra como você pode configurar um isolate de trabalho de longa duração
com comunicação bidirecional entre ele e o isolate principal.
O código usa o exemplo de envio de texto JSON para um novo isolate,
onde o JSON será analisado e decodificado,
antes de ser enviado de volta para o isolate principal.

:::warning
Este exemplo tem como objetivo ensinar o _mínimo necessário_ para
gerar um novo isolate que pode enviar e receber múltiplas mensagens ao longo do tempo.

Ele não cobre partes importantes da funcionalidade que são esperadas
em software de produção, como tratamento de erros, desligamento de ports,
e sequenciamento de mensagens.

O [Exemplo de ports robustos][exemplo de ports robustos] na próxima seção cobre essa funcionalidade e
discute alguns dos problemas que podem surgir sem ela.
:::

[exemplo de ports robustos]: #robust-ports-example

#### Passo 1: Defina a classe worker

Primeiro, crie uma classe para o seu isolate de worker em background.
Esta classe contém toda a funcionalidade que você precisa para:

- Gerar um isolate.
- Enviar mensagens para esse isolate.
- Fazer com que o isolate decodifique algum JSON.
- Enviar o JSON decodificado de volta para o isolate principal.

A classe expõe dois métodos públicos: um que gera o worker
isolate e um que lida com o envio de mensagens para esse worker isolate.

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

#### Passo 2: Gere um worker isolate {:#step-2-spawn-a-worker-isolate}

O método `Worker.spawn` é onde você irá agrupar o código para criar o
worker isolate e garantir que ele possa receber e enviar mensagens.

- Primeiro, crie um `ReceivePort`. Isso permite que o isolate principal receba
  mensagens enviadas do worker isolate recém-gerado.
- Em seguida, adicione um listener ao receive port para lidar com as mensagens que o worker isolate
  enviará de volta. O callback passado para o
  listener, `_handleResponsesFromIsolate`, será abordado
  em [passo 4](#step-4-handle-messages-on-the-main-isolate).
- Finalmente, gere o worker isolate com `Isolate.spawn`. Ele espera dois
  argumentos: uma função a ser executada no worker isolate
  (abordada em [passo 3](#step-3-execute-code-on-the-worker-isolate)),
  e a propriedade `sendPort` do receive port.

<?code-excerpt "lib/basic_ports_example/complete.dart (spawn)"?>
```dart
Future<void> spawn() async {
  final receivePort = ReceivePort();
  receivePort.listen(_handleResponsesFromIsolate);
  await Isolate.spawn(_startRemoteIsolate, receivePort.sendPort);
}
```

O argumento `receivePort.sendPort` será passado para o
callback (`_startRemoteIsolate`) como um argumento quando ele for chamado no
worker isolate. Este é o primeiro passo para garantir que o worker isolate tenha uma
maneira de enviar mensagens de volta para o isolate principal.

#### Passo 3: Execute código no worker isolate {:#step-3-execute-code-on-the-worker-isolate}

Neste passo, você define o método `_startRemoteIsolate` que é enviado para o
worker isolate para ser executado quando ele for gerado. Este método é como o método "main"
para o worker isolate.

- Primeiro, crie outro novo `ReceivePort`. Este port recebe
  mensagens futuras do isolate principal.
- Em seguida, envie o `SendPort` desse port de volta para o isolate principal.
- Finalmente, adicione um listener ao novo `ReceivePort`. Este listener lida com
  mensagens que o isolate principal envia para o worker isolate.

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

O listener no `ReceivePort` do worker decodifica o JSON passado do principal
isolate e, em seguida, envia o JSON decodificado de volta para o isolate principal.

Este listener é o ponto de entrada para mensagens enviadas do isolate principal para o
worker isolate. **Esta é a única chance que você tem de dizer ao worker isolate qual código
executar no futuro.**

#### Passo 4: Lide com mensagens no isolate principal {:#step-4-handle-messages-on-the-main-isolate}

Finalmente, você precisa dizer ao isolate principal como lidar com as mensagens enviadas do
worker isolate de volta para o isolate principal. Para fazer isso, você precisa preencher
o método `_handleResponsesFromIsolate`. Lembre-se de que este método é passado para
o método `receivePort.listen`, conforme descrito
no [passo 2](#step-2-spawn-a-worker-isolate):

<?code-excerpt "lib/basic_ports_example/complete.dart (spawn)"?>
```dart
Future<void> spawn() async {
  final receivePort = ReceivePort();
  receivePort.listen(_handleResponsesFromIsolate);
  await Isolate.spawn(_startRemoteIsolate, receivePort.sendPort);
}
```

Lembre-se também de que você enviou um `SendPort` de volta para o isolate principal
no [passo 3](#step-3-execute-code-on-the-worker-isolate). Este método lida com o
recebimento desse `SendPort`, bem como com o tratamento de mensagens futuras (que serão
JSON decodificado).

- Primeiro, verifique se a mensagem é um `SendPort`. Se for, atribua esse port à
  propriedade `_sendPort` da classe para que ele possa ser usado para enviar mensagens posteriormente.
- Em seguida, verifique se a mensagem é do tipo `Map<String, dynamic>`, o esperado
  tipo de JSON decodificado. Se for, lide com essa mensagem com seu
  lógica específica do aplicativo. Neste exemplo, a mensagem é impressa.

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

#### Passo 5: Adicione um completer para garantir que seu isolate esteja configurado {:#step-5-add-a-completer-to-ensure-your-isolate-is-set-up}

Para completar a classe, defina um método público chamado `parseJson`, que é
responsável por enviar mensagens para o worker isolate. Ele também precisa garantir
que as mensagens podem ser enviadas antes que o isolate esteja totalmente configurado.
Para lidar com isso, use um [`Completer`][`Completer`].

- Primeiro, adicione uma propriedade no nível da classe chamada `Completer` e nomeie-a
  de `_isolateReady`.
- Em seguida, adicione uma chamada para `complete()` no completer em
  o método `_handleResponsesFromIsolate` (criado em [passo 4](#step-4-handle-messages-on-the-main-isolate)) se a mensagem for
  um `SendPort`.
- Finalmente, no método `parseJson`, adicione `await _isolateReady.future` antes
  adicionando `_sendPort.send`. Isso garante que nenhuma mensagem possa ser enviada para o
  worker isolate até que ele seja gerado _e_ tenha enviado seu `SendPort` de volta para o
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

### Exemplo de Portas Robustas {:#robust-ports-example}

O [exemplo anterior][previous example] explicou os blocos de construção básicos necessários para
configurar um _isolate_ de longa duração com comunicação bidirecional. Como
mencionado, esse exemplo carece de alguns recursos importantes, como tratamento
de erros, a capacidade de fechar as portas quando não estão mais em uso e
inconsistências em relação à ordem das mensagens em algumas situações.

Este exemplo expande as informações do primeiro exemplo, criando um _isolate_
de trabalho de longa duração que possui esses recursos adicionais e mais,
e segue melhores _design patterns_ (padrões de projeto). Embora este código
tenha semelhanças com o primeiro exemplo, não é uma extensão desse exemplo.

:::note
Este exemplo pressupõe que você já esteja familiarizado com o estabelecimento
de comunicação entre _isolates_ com `Isolate.spawn` e portas, o que foi
abordado no [exemplo anterior][previous example].
:::

#### Etapa 1: Definir a classe _worker_

Primeiro, crie uma classe para o seu _isolate_ de trabalho em segundo plano.
Esta classe contém toda a funcionalidade necessária para:

- Criar um _isolate_.
- Enviar mensagens para esse _isolate_.
- Fazer com que o _isolate_ decodifique algum JSON.
- Enviar o JSON decodificado de volta para o _isolate_ principal.

A classe expõe três métodos públicos: um que cria o _isolate_ de trabalho, um
que lida com o envio de mensagens para esse _isolate_ de trabalho e um que pode
desligar as portas quando não estiverem mais em uso.

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
Neste exemplo, instâncias de `SendPort` (porta de envio) e `ReceivePort`
(porta de recebimento) seguem uma convenção de nomenclatura de melhor prática,
na qual são nomeadas em relação ao _isolate_ principal. As mensagens enviadas
através do `SendPort` do _isolate_ principal para o _isolate_ de trabalho são
chamadas de _commands_ (comandos), e as mensagens enviadas de volta para o
_isolate_ principal são chamadas de _responses_ (respostas).
:::

#### Etapa 2: Criar um `RawReceivePort` no método `Worker.spawn` {:#step-2-create-a-rawreceiveport-in-the-worker-spawn-method}

Antes de criar um _isolate_, você precisa criar um [`RawReceivePort`][`RawReceivePort`], que é
um `ReceivePort` de nível inferior. Usar `RawReceivePort` é um padrão preferido
porque permite separar a lógica de inicialização do seu _isolate_ da lógica
que lida com a passagem de mensagens no _isolate_.

No método `Worker.spawn`:

- Primeiro, crie o `RawReceivePort`. Este `ReceivePort` é responsável apenas
  por receber a mensagem inicial do _isolate_ de trabalho, que
  será um `SendPort`.
- Em seguida, crie um `Completer` que indicará quando o _isolate_ estiver
  pronto para receber mensagens. Quando isso for concluído, ele retornará um
  registro com um `ReceivePort` e um `SendPort`.
- Em seguida, defina a propriedade `RawReceivePort.handler`. Essa propriedade
  é uma `Function?` que se comporta como `ReceivePort.listener`. A função é
  chamada quando uma mensagem é recebida por esta porta.
- Dentro da função _handler_, chame `connection.complete()`. Este método
  espera um [registro][record] com um `ReceivePort` e um `SendPort` como argumento.
  O `SendPort` é a mensagem inicial enviada do _isolate_ de trabalho, que será
  atribuída na próxima etapa ao `SendPort` de nível de classe denominado `_commands`.
- Em seguida, crie um novo `ReceivePort` com o construtor
  `ReceivePort.fromRawReceivePort` e
  passe o `initPort`.

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

Ao criar primeiro um `RawReceivePort` e depois um `ReceivePort`,
você poderá adicionar um novo _callback_ a `ReceivePort.listen` posteriormente.
Por outro lado, se você criasse um `ReceivePort` imediatamente, só seria
possível adicionar um `listener`, porque `ReceivePort` implementa [`Stream`][`Stream`],
em vez de [`BroadcastStream`][`BroadcastStream`].

Efetivamente, isso permite que você separe a lógica de inicialização do
seu _isolate_ da lógica que lida com o recebimento de mensagens após a
conclusão da configuração da comunicação. Esse benefício se tornará mais
óbvio à medida que a lógica nos outros métodos crescer.

#### Etapa 3: Criar um _isolate_ de trabalho com `Isolate.spawn` {:#step-3-spawn-a-worker-isolate-with-isolate-spawn}

Esta etapa continua a preencher o método `Worker.spawn`. Você adicionará o
código necessário para criar um _isolate_ e retornar uma instância de `Worker`
desta classe. Neste exemplo, a chamada para `Isolate.spawn` é encapsulada em
um bloco [`try`/`catch`][`try`/`catch` block], o que garante que, se o _isolate_ não for iniciado,
o `initPort` será fechado e o objeto `Worker` não será criado.

- Primeiro, tente criar um _isolate_ de trabalho em um bloco `try`/`catch`.
  Se a criação de um _isolate_ de trabalho falhar, feche a porta de recebimento
  que foi criada na etapa anterior. O método passado para `Isolate.spawn` será
  abordado em uma etapa posterior.
- Em seguida, aguarde o `connection.future` e desestruture a porta de envio e
  a porta de recebimento do registro que ele retorna.
- Finalmente, retorne uma instância de `Worker` chamando seu construtor privado
  e passando as portas desse _completer_.

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

Observe que, neste exemplo (em comparação com o [exemplo anterior][previous example]),
`Worker.spawn` atua como um construtor estático assíncrono para esta classe
e é a única maneira de criar uma instância de `Worker`. Isso simplifica a API,
tornando o código que cria uma instância de `Worker` mais limpo.

#### Etapa 4: Concluir o processo de configuração do _isolate_ {:#step-4-complete-the-isolate-setup-process}

Nesta etapa, você concluirá o processo básico de configuração do _isolate_.
Isso se correlaciona quase inteiramente com o [exemplo anterior][previous example], e não há
novos conceitos. Há uma ligeira mudança no fato de o código ser dividido em
mais métodos, o que é uma prática de _design_ que o prepara para adicionar mais
funcionalidades durante o restante deste exemplo.
Para um passo a passo detalhado do processo básico de configuração de um
_isolate_, consulte o [exemplo básico de portas](#basic-ports-example).

Primeiro, crie o construtor privado que é retornado do método `Worker.spawn`.
No corpo do construtor, adicione um _listener_ à porta de recebimento usada
pelo _isolate_ principal e passe um método ainda não definido para esse
_listener_ chamado `_handleResponsesFromIsolate`.

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

Em seguida, adicione o código a `_startRemoteIsolate` que é responsável por
inicializar as portas no _isolate_ de trabalho.
[Lembre-se](#step-3-spawn-a-worker-isolate-with-isolate-spawn) que este método
foi passado para `Isolate.spawn` no método `Worker.spawn`, e ele
receberá o `SendPort` do _isolate_ principal como um argumento.

- Crie um novo `ReceivePort`.
- Envie o `SendPort` dessa porta de volta para o _isolate_ principal.
- Chame um novo método chamado `_handleCommandsToIsolate` e passe
  o novo `ReceivePort` e o `SendPort` do _isolate_ principal como argumentos.

<?code-excerpt "lib/robust_ports_example/step_4.dart (start-isolate)"?>
```dart
static void _startRemoteIsolate(SendPort sendPort) {
  final receivePort = ReceivePort();
  sendPort.send(receivePort.sendPort);
  _handleCommandsToIsolate(receivePort, sendPort);
}
```

Em seguida, adicione o método `_handleCommandsToIsolate`, que é responsável
por receber mensagens do _isolate_ principal, decodificar JSON no _isolate_
de trabalho e enviar o JSON decodificado de volta como resposta.

- Primeiro, declare um _listener_ no `ReceivePort` do _isolate_ de trabalho.
- Dentro do _callback_ adicionado ao _listener_, tente decodificar o JSON
  passado do _isolate_ principal dentro de um bloco [`try`/`catch`][`try`/`catch` block]. Se a
  decodificação for bem-sucedida, envie o JSON decodificado de volta para o _isolate_ principal.
- Se houver um erro, envie um [`RemoteError`][`RemoteError`] de volta.

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
  deve `throw` (lançar) esse erro.
- Caso contrário, imprima a mensagem. Em etapas futuras, você atualizará este
  código para retornar mensagens em vez de imprimi-las.

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
que um código externo envie JSON para o _isolate_ de trabalho para ser decodificado.

<?code-excerpt "lib/robust_ports_example/step_4.dart (parse-json)"?>
```dart
Future<Object?> parseJson(String message) async {
  _commands.send(message);
}
```

Você atualizará este método na próxima etapa.

#### Etapa 5: Lidar com várias mensagens ao mesmo tempo {:#step-5-handle-multiple-messages-at-the-same-time}

Atualmente, se você enviar mensagens rapidamente para o _isolate_ de trabalho,
o _isolate_ enviará a resposta JSON decodificada _na ordem em que elas forem
concluídas_, e não na ordem em que forem enviadas. Você não tem como
determinar qual resposta corresponde a qual mensagem.

Nesta etapa, você corrigirá esse problema dando a cada mensagem um ID e usando
objetos `Completer` para garantir que, quando um código externo chamar
`parseJson`, a resposta retornada a esse chamador seja a resposta correta.

Primeiro, adicione duas propriedades de nível de classe ao `Worker`:

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

O mapa `_activeRequests` associa uma mensagem enviada ao _isolate_ de trabalho
com um `Completer`. As chaves usadas em `_activeRequests` são obtidas de
`_idCounter`, que será incrementado à medida que mais mensagens forem enviadas.

Em seguida, atualize o método `parseJson` para criar _completers_ antes de
enviar mensagens para o _isolate_ de trabalho.

- Primeiro, crie um `Completer`.
- Em seguida, incremente `_idCounter`, para que cada `Completer` seja associado
  a um número exclusivo.
- Adicione uma entrada ao mapa `_activeRequests` no qual a chave é o
  número atual de `_idCounter` e o _completer_ é o valor.
- Envie a mensagem para o _isolate_ de trabalho, junto com o ID.
  Como você só pode enviar um valor através do `SendPort`, encapsule o ID
  e a mensagem em um [registro][record].
- Finalmente, retorne o futuro do _completer_, que acabará contendo a
  resposta do _isolate_ de trabalho.

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
e `_handleCommandsToIsolate` para lidar com este sistema.

Em `_handleCommandsToIsolate`, você precisa levar em consideração que a
`message` é um registro com dois valores, e não apenas o texto JSON.
Faça isso desestruturando os valores da `message`.

Em seguida, depois de decodificar o JSON, atualize a chamada para `sendPort.send`
para passar o ID e o JSON decodificado de volta para o _isolate_ principal, novamente usando um registro.

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

- Primeiro, desestruture o ID e a resposta do argumento da mensagem novamente.
- Em seguida, remova o _completer_ que corresponde a esta solicitação
  do mapa `_activeRequests`.
- Por fim, em vez de lançar um erro ou imprimir o JSON decodificado, conclua 
  o _completer_, passando a resposta. Quando isso for concluído, a resposta 
  será retornada ao código que chamou `parseJson` no _isolate_ principal.

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

#### Etapa 6: Adicionar funcionalidade para fechar as portas {:#step-6-add-functionality-to-close-the-ports}

Quando o _isolate_ não estiver mais sendo usado pelo seu código, você deverá
fechar as portas no _isolate_ principal e no _isolate_ de trabalho.

- Primeiro, adicione um booleano de nível de classe que rastreie se as portas estão fechadas.
- Em seguida, adicione o método `Worker.close`. Dentro deste método:
  - Atualize `_closed` para `true`.
  - Envie uma mensagem final para o _isolate_ de trabalho.
    Esta mensagem é uma `String` que diz "shutdown" (desligar),
    mas poderia ser qualquer objeto que você quiser.
    Você a usará no próximo trecho de código.
- Finalmente, verifique se `_activeRequests` está vazio. Se estiver,
  feche o `ReceivePort` do _isolate_ principal chamado `_responses`.

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

- Em seguida, você precisa lidar com a mensagem "shutdown" no _isolate_ de
  trabalho. Adicione o seguinte código ao método `_handleCommandsToIsolate`.
  Este código verificará se a mensagem é uma `String` que diz "shutdown".
  Se for, ele fechará o `ReceivePort` do _isolate_ de trabalho e retornará.

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

- Finalmente, você deve adicionar código para verificar se as portas estão
fechadas antes de tentar enviar mensagens. Adicione uma linha no método `Worker.parseJson`.

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
[`SendPort.send()` method]: {{site.dart-api}}/dart-isolate/SendPort/send.html
[main isolate]: /language/concurrency#isolates
[`Stream`]: {{site.dart-api}}/dart-async/Stream-class.html
[`BroadcastStream`]: {{site.dart-api}}/dart-async/BroadcastStream-class.html
[`Completer`]: {{site.dart-api}}/dart-async/Completer-class.html
[`RawReceivePort`]: {{site.dart-api}}/dart-isolate/RawReceivePort-class.html
[record]: /language/records
[previous example]: #basic-ports-example
[`try`/`catch` block]: /language/error-handling#catch
[`RemoteError`]: {{site.dart-api}}/dart-isolate/RemoteError-class.html
