---
ia-translate: true
title: Isolados
description: Informações sobre como escrever isolados em Dart.
short-title: Isolados
lastVerified: 2024-01-04
prevpage:
  url: /language/async
  title: Suporte assíncrono
nextpage:
  url: /null-safety
  title: Segurança Nula Robusta
---

<?code-excerpt path-base="concurrency"?>

<style>
  article img {
    padding: 15px 0;
  }
</style>

Esta página discute alguns exemplos que usam a API `Isolate` para implementar
isolados.

Você deve usar isolados sempre que seu aplicativo estiver lidando com
computações grandes o suficiente para bloquear temporariamente outras computações.
O exemplo mais comum é em aplicativos [Flutter][Flutter], quando você
precisa realizar grandes computações que poderiam, de outra forma, fazer
a UI ficar sem resposta.

Não há regras sobre quando você _deve_ usar isolados,
mas aqui estão mais algumas situações em que eles podem ser úteis:

- Análise e decodificação de blobs JSON excepcionalmente grandes.
- Processamento e compressão de fotos, áudio e vídeo.
- Conversão de arquivos de áudio e vídeo.
- Realização de buscas e filtragens complexas em listas grandes ou dentro de
  sistemas de arquivos.
- Realização de I/O, como comunicação com um banco de dados.
- Lidar com um grande volume de requisições de rede.

[Flutter]: {{site.flutter-docs}}/perf/isolates

## Implementando um isolado de trabalho simples

Estes exemplos implementam um isolado principal
que gera um isolado de trabalho simples.
[`Isolate.run()`][`Isolate.run()`] simplifica as etapas por trás
da configuração e gerenciamento de isolados de trabalho:

1. Gera (inicia e cria) um isolado.
2. Executa uma função no isolado gerado.
3. Captura o resultado.
4. Retorna o resultado para o isolado principal.
5. Termina o isolado assim que o trabalho é concluído.
6. Verifica, captura e lança exceções e erros de volta para o isolado principal.

[`Isolate.run()`]: {{site.dart-api}}/dart-isolate/Isolate/run.html

:::flutter-note
Se você estiver usando o Flutter, você pode usar a [função `compute` do Flutter][função `compute` do Flutter]
em vez de `Isolate.run()`.
:::

[função `compute` do Flutter]: {{site.flutter-api}}/flutter/foundation/compute.html

### Executando um método existente em um novo isolado

1. Chame `run()` para gerar um novo isolado (um [trabalhador em segundo plano][trabalhador em segundo plano]),
   diretamente no [isolado principal][isolado principal] enquanto `main()` aguarda o resultado:

<?code-excerpt "lib/simple_worker_isolate.dart (main)"?>
```dart
const String filename = 'with_keys.json';

void main() async {
  // Lê alguns dados.
  final jsonData = await Isolate.run(_readAndParseJson);

  // Usa esses dados.
  print('Número de chaves JSON: ${jsonData.length}');
}
```

2. Passe para o isolado de trabalho a função que você deseja que ele execute
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
   e envia o valor de volta para o isolado principal,
   desligando o isolado de trabalho.

4. O isolado de trabalho *transfere* a memória que contém o resultado
   para o isolado principal. Ele *não copia* os dados.
   O isolado de trabalho executa uma passagem de verificação para garantir
   que os objetos possam ser transferidos.

`_readAndParseJson()` é uma função assíncrona existente,
que poderia facilmente
ser executada diretamente no isolado principal.
Usar `Isolate.run()` para executá-la em vez disso permite a concorrência.
O isolado de trabalho abstrai completamente as computações
de `_readAndParseJson()`. Ele pode ser concluído sem bloquear o isolado principal.

O resultado de `Isolate.run()` é sempre um Future,
porque o código no isolado principal continua a ser executado.
Se a computação que o isolado de trabalho executa
é síncrona ou assíncrona não afeta o
isolado principal, porque ele está sendo executado simultaneamente de qualquer maneira.

Para o programa completo, confira a amostra [send_and_receive.dart][send_and_receive.dart].

[send_and_receive.dart]: {{site.repo.dart.org}}/samples/blob/main/isolates/bin/send_and_receive.dart
[trabalhador em segundo plano]: /language/concurrency#background-workers
[isolado principal]: /language/concurrency#the-main-isolate

### Enviando closures com isolados

Você também pode criar um isolado de trabalho simples com `run()` usando uma
função literal, ou closure, diretamente no isolado principal.

<?code-excerpt "lib/simple_isolate_closure.dart (worker)"?>
```dart
const String filename = 'with_keys.json';

void main() async {
  // Lê alguns dados.
  final jsonData = await Isolate.run(() async {
    final fileData = await File(filename).readAsString();
    final jsonData = jsonDecode(fileData) as Map<String, dynamic>;
    return jsonData;
  });

  // Usa esses dados.
  print('Número de chaves JSON: ${jsonData.length}');
}
```

Este exemplo realiza o mesmo que o anterior.
Um novo isolado é gerado, computa algo e envia de volta o resultado.

No entanto, agora o isolado envia um [closure][closure].
Closures são menos limitados do que funções nomeadas típicas,
tanto em como elas funcionam quanto em como são escritas no código.
Neste exemplo, `Isolate.run()` executa o que parece um código local,
concorrentemente. Nesse sentido, você pode imaginar que `run()` funcione como um
operador de fluxo de controle para "executar em paralelo".

[closure]: /language/functions#anonymous-functions

## Enviando múltiplas mensagens entre isolados com portas

Isolados de curta duração são convenientes de usar,
mas exigem uma sobrecarga de desempenho para gerar novos isolados
e para copiar objetos de um isolado para outro.
Se o seu código depende da execução repetida da mesma computação
usando `Isolate.run`, você pode melhorar o desempenho criando
isolados de longa duração que não são encerrados imediatamente.

Para fazer isso, você pode usar algumas das APIs de baixo nível do isolado que
`Isolate.run` abstrai:

* [`Isolate.spawn()`][`Isolate.spawn()`] e [`Isolate.exit()`][`Isolate.exit()`]
* [`ReceivePort`][`ReceivePort`] e [`SendPort`][`SendPort`]
* [Método `SendPort.send()`][`SendPort.send()` método]

Esta seção aborda as etapas necessárias para estabelecer
comunicação bidirecional entre um isolado recém-gerado
e o [isolado principal][isolado principal].
O primeiro exemplo, [Portas básicas](#basic-ports-example), introduz o processo
em alto nível. O segundo exemplo, [Portas robustas](#robust-ports-example),
adiciona gradualmente funcionalidades mais práticas do mundo real ao primeiro.

[`Isolate.exit()`]: {{site.dart-api}}/dart-isolate/Isolate/exit.html
[`Isolate.spawn()`]: {{site.dart-api}}/dart-isolate/Isolate/spawn.html
[`ReceivePort`]: {{site.dart-api}}/dart-isolate/ReceivePort-class.html
[`SendPort`]: {{site.dart-api}}/dart-isolate/SendPort-class.html
[`SendPort.send()` método]: {{site.dart-api}}/dart-isolate/SendPort/send.html
[isolado principal]: /language/concurrency#isolates

### `ReceivePort` e `SendPort`

Configurar uma comunicação de longa duração entre isolados requer
duas classes (além de `Isolate`): `ReceivePort` e `SendPort`.
Essas portas são a única maneira pela qual os isolados podem se comunicar entre si.

Um `ReceivePort` é um objeto que lida com mensagens que são enviadas de outros
isolados. Essas mensagens são enviadas por meio de um `SendPort`.

:::note
Um objeto `SendPort` está associado a exatamente um `ReceivePort`,
mas um único `ReceivePort` pode ter vários `SendPorts`.
Quando você cria um `ReceivePort`, ele cria um `SendPort` para si mesmo.
Você pode criar `SendPorts` adicionais que
podem enviar mensagens para um `ReceivePort` existente.
:::

As portas se comportam de forma semelhante aos objetos [`Stream`][`Stream`]
(na verdade, as portas de recebimento implementam `Stream`!)
Você pode pensar em um `SendPort` e `ReceivePort` como
`StreamController` do Stream e listeners, respectivamente.
Um `SendPort` é como um `StreamController` porque você "adiciona" mensagens a eles
com o [método `SendPort.send()`][`SendPort.send()` método], e essas mensagens são tratadas por um listener,
neste caso o `ReceivePort`. O `ReceivePort` então lida com as mensagens que
recebe passando-as como argumentos para um callback que você fornece.

#### Configurando as portas

Um isolado recém-gerado só tem as informações que recebe por meio da
chamada `Isolate.spawn`. Se você precisar que o isolado principal continue a se comunicar
com um isolado gerado após sua criação inicial, você deve configurar um
canal de comunicação onde o isolado gerado possa enviar mensagens para o
isolado principal. Os isolados só podem se comunicar através da passagem de mensagens.
Eles não podem "ver" dentro da memória um do outro,
que é de onde vem o nome "isolado".

Para configurar esta comunicação bidirecional, primeiro crie um [`ReceivePort`][`ReceivePort`]
no isolado principal, então passe seu [`SendPort`][`SendPort`] como um argumento para o
novo isolado ao gerá-lo com `Isolate.spawn`.
O novo isolado então cria seu próprio `ReceivePort` e envia _seu_ `SendPort`
de volta no `SendPort` que foi passado pelo isolado principal.
O isolado principal recebe este `SendPort`, e
agora ambos os lados têm um canal aberto para enviar e receber mensagens.

:::note
Os diagramas nesta seção são de alto nível e pretendem transmitir o
_conceito_ de usar portas para isolados. A implementação real requer
um pouco mais de código, que você encontrará
[mais adiante nesta página](#basic-ports-example).
:::

![Uma figura mostrando eventos sendo alimentados, um por um, no loop de eventos](/assets/img/language/concurrency/ports-setup.png)

1. Crie um `ReceivePort` no isolado principal. O `SendPort` é criado
   automaticamente como uma propriedade no `ReceivePort`.
2. Gere o isolado de trabalho com `Isolate.spawn()`
3. Passe uma referência para `ReceivePort.sendPort` como a primeira mensagem para o
   isolado de trabalho.
4. Crie outro novo `ReceivePort` no isolado de trabalho.
5. Passe uma referência para o `ReceivePort.sendPort` do isolado de trabalho como o
   primeira mensagem _de volta_ para o isolado principal.

Juntamente com a criação das portas e a configuração da comunicação, você também precisará
dizer às portas o que fazer quando receberem mensagens. Isso é feito usando
o método `listen` em cada `ReceivePort` respectivo.

![Uma figura mostrando eventos sendo alimentados, um por um, no loop de eventos](/assets/img/language/concurrency/ports-passing-messages.png)

1. Envie uma mensagem através da referência do isolado principal para o isolado de trabalho
   `SendPort`.
2. Receba e trate a mensagem através de um listener no isolado de trabalho
   `ReceivePort`. É aqui que a computação que você deseja remover do
   isolado principal é executada.
3. Envie uma mensagem de retorno através da referência do isolado de trabalho para o principal
   `SendPort` do isolado.
4. Receba a mensagem através de um listener no isolado principal
   `ReceivePort`.

### Exemplo de portas básicas

Este exemplo demonstra como você pode configurar um isolado de trabalho de longa duração
com comunicação bidirecional entre ele e o isolado principal.
O código usa o exemplo de envio de texto JSON para um novo isolado,
onde o JSON será analisado e decodificado,
antes de ser enviado de volta para o isolado principal.

:::warning
Este exemplo tem como objetivo ensinar o _mínimo_ necessário para
gerar um novo isolado que pode enviar e receber várias mensagens ao longo do tempo.

Ele não cobre partes importantes da funcionalidade que são esperadas
em software de produção, como tratamento de erros, desligamento de portas,
e sequenciamento de mensagens.

O [Exemplo de portas robustas][Exemplo de portas robustas] na próxima seção aborda esta funcionalidade e
discute alguns dos problemas que podem surgir sem ela.
:::

[Exemplo de portas robustas]: #robust-ports-example

#### Etapa 1: Defina a classe worker

Primeiro, crie uma classe para o seu isolado de trabalho em segundo plano.
Esta classe contém toda a funcionalidade que você precisa para:

- Gerar um isolado.
- Enviar mensagens para esse isolado.
- Fazer com que o isolado decodifique algum JSON.
- Enviar o JSON decodificado de volta para o isolado principal.

A classe expõe dois métodos públicos: um que gera o worker
isolado e um que lida com o envio de mensagens para aquele isolado worker.

As seções restantes deste exemplo mostrarão
como preencher os métodos da classe, um por um.

<?code-excerpt "lib/basic_ports_example/start.dart (worker)"?>
```dart
class Worker {
  Future<void> spawn() async {
    // TODO: Adicionar funcionalidade para gerar um isolado de trabalho.
  }

  void _handleResponsesFromIsolate(dynamic message) {
    // TODO: Lidar com mensagens enviadas de volta do isolado de trabalho.
  }

  static void _startRemoteIsolate(SendPort port) {
    // TODO: Definir o código que deve ser executado no isolado de trabalho.
  }

  Future<void> parseJson(String message) async {
    // TODO: Definir um método público que possa
    // ser usado para enviar mensagens para o isolado de trabalho.
  }
}
```

#### Etapa 2: Gere um isolado de trabalho

O método `Worker.spawn` é onde você agrupará o código para criar o
isolado de trabalho e garantir que ele possa receber e enviar mensagens.

- Primeiro, crie um `ReceivePort`. Isso permite que o isolado principal receba
  mensagens enviadas do isolado de trabalho recém-gerado.
- Em seguida, adicione um listener à porta de recebimento para lidar com as mensagens que o isolado de trabalho
  enviará de volta. O callback passado para o
  listener, `_handleResponsesFromIsolate`, será abordado
  na [etapa 4](#step-4-handle-messages-on-the-main-isolate).
- Finalmente, gere o isolado de trabalho com `Isolate.spawn`. Ele espera dois
  argumentos: uma função a ser executada no isolado de trabalho
  (abordada na [etapa 3](#step-3-execute-code-on-the-worker-isolate)),
  e a propriedade `sendPort` da porta de recebimento.

<?code-excerpt "lib/basic_ports_example/complete.dart (spawn)"?>
```dart
Future<void> spawn() async {
  final receivePort = ReceivePort();
  receivePort.listen(_handleResponsesFromIsolate);
  await Isolate.spawn(_startRemoteIsolate, receivePort.sendPort);
}
```

O argumento `receivePort.sendPort` será passado para o
callback (`_startRemoteIsolate`) como um argumento quando for chamado no
isolado de trabalho. Este é o primeiro passo para garantir que o isolado de trabalho tenha um
maneira de enviar mensagens de volta para o isolado principal.

#### Etapa 3: Execute o código no isolado de trabalho

Nesta etapa, você define o método `_startRemoteIsolate` que é enviado para o
isolado de trabalho para ser executado quando ele é gerado. Este método é como o "main"
método para o isolado de trabalho.

- Primeiro, crie outro novo `ReceivePort`. Esta porta recebe
  futuras mensagens do isolado principal.
- Em seguida, envie o `SendPort` dessa porta de volta para o isolado principal.
- Finalmente, adicione um listener ao novo `ReceivePort`. Este listener lida com
  mensagens que o isolado principal envia para o isolado de trabalho.

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

O listener no `ReceivePort` do trabalhador decodifica o JSON passado do principal
isolado e, em seguida, envia o JSON decodificado de volta para o isolado principal.

Este listener é o ponto de entrada para mensagens enviadas do isolado principal para o
isolado de trabalho. **Esta é a única chance que você tem de dizer ao isolado de trabalho qual código
executar no futuro.**

#### Etapa 4: Lidar com mensagens no isolado principal

Finalmente, você precisa dizer ao isolado principal como lidar com as mensagens enviadas do
isolado de trabalho de volta para o isolado principal. Para fazer isso, você precisa preencher
o método `_handleResponsesFromIsolate`. Lembre-se de que este método é passado para
o método `receivePort.listen`, conforme descrito
na [etapa 2](#step-2-spawn-a-worker-isolate):

<?code-excerpt "lib/basic_ports_example/complete.dart (spawn)"?>
```dart
Future<void> spawn() async {
  final receivePort = ReceivePort();
  receivePort.listen(_handleResponsesFromIsolate);
  await Isolate.spawn(_startRemoteIsolate, receivePort.sendPort);
}
```

Lembre-se também de que você enviou um `SendPort` de volta para o isolado principal
na [etapa 3](#step-3-execute-code-on-the-worker-isolate). Este método lida com o
recebimento desse `SendPort`, bem como com o tratamento de mensagens futuras (que serão
JSON decodificado).

- Primeiro, verifique se a mensagem é um `SendPort`. Se for, atribua essa porta para a
  propriedade `_sendPort` da classe para que ela possa ser usada para enviar mensagens posteriormente.
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

#### Etapa 5: Adicione um completer para garantir que seu isolado esteja configurado

Para completar a classe, defina um método público chamado `parseJson`, que é
responsável por enviar mensagens para o isolado de trabalho. Também precisa garantir
que as mensagens podem ser enviadas antes que o isolado seja totalmente configurado.
Para lidar com isso, use um [`Completer`][`Completer`].

- Primeiro, adicione uma propriedade de nível de classe chamada `Completer` e nomeie
  ele `_isolateReady`.
- Em seguida, adicione uma chamada para `complete()` no completer em
  o método `_handleResponsesFromIsolate` (criado na [etapa 4](#step-4-handle-messages-on-the-main-isolate)) se a mensagem for
  um `SendPort`.
- Finalmente, no método `parseJson`, adicione `await _isolateReady.future` antes de
  adicionar `_sendPort.send`. Isso garante que nenhuma mensagem possa ser enviada para o
  isolado de trabalho até que ele seja gerado _e_ tenha enviado seu `SendPort` de volta para o
  isolado principal.

<?code-excerpt "lib/basic_ports_example/complete.dart (parse-json)"?>
```dart
Future<void> parseJson(String message) async {
  await _isolateReady.future;
  _sendPort.send(message);
}
```

#### Exemplo completo

<details>
  <summary>Expandir para ver o exemplo completo</summary>

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
### Exemplo de portas robustas

O [exemplo anterior][previous example] explicou os blocos de construção básicos necessários para configurar um isolate de longa duração com comunicação bidirecional. Como mencionado, esse exemplo carece de alguns recursos importantes, como tratamento de erros, a capacidade de fechar as portas quando elas não estão mais em uso e inconsistências em relação à ordem das mensagens em algumas situações.

Este exemplo expande as informações do primeiro exemplo, criando um isolate de worker de longa duração que possui esses recursos adicionais e mais, e segue melhores padrões de design. Embora este código tenha semelhanças com o primeiro exemplo, ele não é uma extensão desse exemplo.

:::note
Este exemplo pressupõe que você já esteja familiarizado com o estabelecimento de comunicação entre isolates com `Isolate.spawn` e portas, o que foi abordado no [exemplo anterior][previous example].
:::

#### Passo 1: Defina a classe worker

Primeiro, crie uma classe para seu isolate worker em background. Esta classe contém todas as funcionalidades que você precisa para:

- Iniciar um isolate.
- Enviar mensagens para esse isolate.
- Fazer o isolate decodificar algum JSON.
- Enviar o JSON decodificado de volta para o isolate principal.

A classe expõe três métodos públicos: um que cria o isolate worker, um que lida com o envio de mensagens para esse isolate worker e um que pode desligar as portas quando elas não estão mais em uso.

<?code-excerpt "lib/robust_ports_example/start.dart (worker)"?>
```dart
class Worker {
  final SendPort _commands;
  final ReceivePort _responses;

  Future<Object?> parseJson(String message) async {
    // TODO: Garanta que a porta ainda esteja aberta.
    _commands.send(message);
  }

  static Future<Worker> spawn() async {
    // TODO: Adicione funcionalidade para criar um novo objeto Worker com uma
    // conexão com um isolate iniciado.
    throw UnimplementedError();
  }

  Worker._(this._responses, this._commands) {
    // TODO: Inicialize o listener da porta de recebimento do isolate principal.
  }

  void _handleResponsesFromIsolate(dynamic message) {
    // TODO: Lide com mensagens enviadas de volta do isolate worker.
  }

  static void _handleCommandsToIsolate(ReceivePort rp, SendPort sp) async {
    // TODO: Lide com mensagens enviadas de volta do isolate worker.
  }

  static void _startRemoteIsolate(SendPort sp) {
    // TODO: Inicialize as portas do isolate worker.
  }
}
```

:::note
Neste exemplo, as instâncias `SendPort` e `ReceivePort`
seguem uma convenção de nomenclatura de melhor prática, na qual são nomeadas em relação
ao isolate principal. As mensagens enviadas através do `SendPort` do isolate principal
para o isolate worker são chamadas de _comandos_, e as mensagens enviadas de volta para o
isolate principal são chamadas de _respostas_.
:::

#### Passo 2: Crie um `RawReceivePort` no método `Worker.spawn`

Antes de iniciar um isolate, você precisa criar um [`RawReceivePort`][`RawReceivePort`], que é
um `ReceivePort` de nível inferior. Usar `RawReceivePort` é um padrão preferido
porque permite separar sua lógica de inicialização do isolate da lógica que
lida com a passagem de mensagens no isolate.

No método `Worker.spawn`:

- Primeiro, crie o `RawReceivePort`. Este `ReceivePort` é responsável apenas por
  receber a mensagem inicial do isolate worker, que será
  um `SendPort`.
- Em seguida, crie um `Completer` que indicará quando o isolate estiver pronto para
  receber mensagens. Quando isso for concluído, ele retornará um registro com
  um `ReceivePort` e um `SendPort`.
- Em seguida, defina a propriedade `RawReceivePort.handler`. Esta propriedade é
  uma `Function?` que se comporta como `ReceivePort.listener`. A função é chamada
  quando uma mensagem é recebida por esta porta.
- Dentro da função handler, chame `connection.complete()`. Este método espera
  um [registro][record] com um `ReceivePort` e um `SendPort` como argumento.
  O `SendPort` é a mensagem inicial enviada do isolate worker, que será
  atribuída na próxima etapa ao `SendPort` de nível de classe denominado `_commands`.
- Em seguida, crie um novo `ReceivePort` com
  o construtor `ReceivePort.fromRawReceivePort` e passe o
  `initPort`.

<?code-excerpt "lib/robust_ports_example/spawn_1.dart (worker-spawn)"?>
```dart
class Worker {
  final SendPort _commands;
  final ReceivePort _responses;

  static Future<Worker> spawn() async {
    // Crie uma porta de recebimento e adicione seu manipulador de mensagem inicial.
    final initPort = RawReceivePort();
    final connection = Completer<(ReceivePort, SendPort)>.sync();
    initPort.handler = (initialMessage) {
      final commandPort = initialMessage as SendPort;
      connection.complete((
        ReceivePort.fromRawReceivePort(initPort),
        commandPort,
      ));
    };
// ···
  }
```

Ao criar um `RawReceivePort` primeiro e, em seguida, um `ReceivePort`, você poderá
adicionar um novo callback a `ReceivePort.listen` posteriormente. Por outro lado, se você
fosse criar um `ReceivePort` imediatamente, você só poderia adicionar um
`listener`, porque `ReceivePort` implementa [`Stream`][`Stream`], em vez de
[`BroadcastStream`][`BroadcastStream`].

Efetivamente, isso permite que você separe sua lógica de inicialização do isolate da
lógica que lida com o recebimento de mensagens após a configuração da comunicação
estar completa. Este benefício se tornará mais óbvio à medida que a lógica nos outros
métodos crescer.

#### Passo 3: Inicie um isolate worker com `Isolate.spawn`

Esta etapa continua a preencher o método `Worker.spawn`. Você adicionará o código
necessário para iniciar um isolate e retornar uma instância de `Worker` desta classe.
Neste exemplo, a chamada para `Isolate.spawn` é encapsulada em
um bloco [`try`/`catch`][`try`/`catch` block], o que garante que, se o isolate não conseguir iniciar,
o `initPort` será fechado e o objeto `Worker` não será criado.

- Primeiro, tente iniciar um isolate worker em um bloco `try`/`catch`. Se o início
  de um isolate worker falhar, feche a porta de recebimento que foi criada no
  passo anterior. O método passado para `Isolate.spawn` será abordado em um passo
  posterior.
- Em seguida, aguarde o `connection.future` e desestruture a porta de envio e
  a porta de recebimento do registro que ele retorna.
- Finalmente, retorne uma instância de `Worker` chamando seu construtor privado
  e passando as portas daquele completer.

<?code-excerpt "lib/robust_ports_example/spawn_2.dart (worker-spawn)"?>
```dart
class Worker {
  final SendPort _commands;
  final ReceivePort _responses;

  static Future<Worker> spawn() async {
    // Crie uma porta de recebimento e adicione seu manipulador de mensagem inicial
    final initPort = RawReceivePort();
    final connection = Completer<(ReceivePort, SendPort)>.sync();
    initPort.handler = (initialMessage) {
      final commandPort = initialMessage as SendPort;
      connection.complete((
        ReceivePort.fromRawReceivePort(initPort),
        commandPort,
      ));
    };
    // Inicie o isolate.
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
```

Observe que neste exemplo (em comparação com o [exemplo anterior][previous example]), `Worker.spawn`
atua como um construtor estático assíncrono para esta classe e é a única maneira de
criar uma instância de `Worker`. Isso simplifica a API, tornando o código que
cria uma instância de `Worker` mais limpo.

#### Passo 4: Conclua o processo de configuração do isolate

Nesta etapa, você concluirá o processo básico de configuração do isolate. Isso se correlaciona
quase inteiramente ao [exemplo anterior][previous example], e não há novos conceitos.
Há uma pequena mudança no fato de que o código é dividido em mais métodos, o que
é uma prática de design que
prepara você para adicionar mais funcionalidades ao longo do restante deste exemplo.
Para um passo a passo detalhado do processo básico de configuração de um isolate, veja
o [exemplo de portas básicas](#basic-ports-example).

Primeiro, crie o construtor privado que é retornado do método `Worker.spawn`.
No corpo do construtor, adicione um listener à porta de recebimento usada pelo
isolate principal e passe um método ainda não definido para aquele listener
chamado `_handleResponsesFromIsolate`.

<?code-excerpt "lib/robust_ports_example/step_4.dart (constructor)"?>
```dart
class Worker {
  final SendPort _commands;
  final ReceivePort _responses;
// ···
  Worker._(this._responses, this._commands) {
    _responses.listen(_handleResponsesFromIsolate);
  }
```

Em seguida, adicione o código a `_startRemoteIsolate` que é responsável por inicializar
as portas no isolate worker.
[Lembre-se](#step-3-spawn-a-worker-isolate-with-isolate-spawn) que este
método foi passado para `Isolate.spawn` no método `Worker.spawn`, e ele
será passado o `SendPort` do isolate principal como um argumento.

- Crie um novo `ReceivePort`.
- Envie o `SendPort` dessa porta de volta para o isolate principal.
- Chame um novo método chamado `_handleCommandsToIsolate` e passe tanto o
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
receber mensagens do isolate principal, decodificar json no isolate worker e
enviar o json decodificado de volta como uma resposta.

- Primeiro, declare um listener no `ReceivePort` do isolate worker.
- Dentro do callback adicionado ao listener, tente decodificar o JSON passado
  do isolate principal dentro de um bloco [`try`/`catch`][`try`/`catch` block]. Se a decodificação
  for bem-sucedida, envie o JSON decodificado de volta para o isolate principal.
- Se houver um erro, envie de volta um [`RemoteError`][`RemoteError`].

<?code-excerpt "lib/robust_ports_example/step_4.dart (handle-commands)"?>
```dart
static void _handleCommandsToIsolate(
    ReceivePort receivePort, SendPort sendPort) {
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
- Caso contrário, imprima a mensagem. Nas etapas futuras, você atualizará este código para
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
que código externo envie JSON para o isolate worker para ser decodificado.

<?code-excerpt "lib/robust_ports_example/step_4.dart (parse-json)"?>
```dart
Future<Object?> parseJson(String message) async {
  _commands.send(message);
}
```

Você atualizará este método na próxima etapa.

#### Passo 5: Lide com várias mensagens ao mesmo tempo

Atualmente, se você enviar mensagens rapidamente para o isolate worker, o isolate enviará a resposta json decodificada na _ordem em que elas forem concluídas_, e não na ordem em que foram enviadas. Você não tem como determinar qual resposta corresponde a qual mensagem.

Nesta etapa, você corrigirá esse problema, atribuindo um ID a cada mensagem e
usando objetos `Completer` para garantir que, quando o código externo chamar `parseJson`, a
resposta que for retornada para aquele chamador seja a resposta correta.

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
```

O mapa `_activeRequests` associa uma mensagem enviada para o isolate worker
com um `Completer`. As chaves usadas em `_activeRequests` são obtidas
de `_idCounter`, que será incrementado à medida que mais mensagens forem enviadas.

Em seguida, atualize o método `parseJson` para criar completers antes que ele envie
mensagens para o isolate worker.

- Primeiro, crie um `Completer`.
- Em seguida, incremente `_idCounter`, para que cada `Completer` seja associado a um
  número exclusivo.
- Adicione uma entrada ao mapa `_activeRequests` em que a chave é o número atual
  de `_idCounter` e o completer é o valor.
- Envie a mensagem para o isolate worker, junto com o ID. Como você pode
  enviar apenas um valor através do `SendPort`, encapsule o ID e a mensagem em
  um [registro][record].
- Finalmente, retorne o future do completer, que eventualmente conterá a
  resposta do isolate worker.

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

Em `_handleCommandsToIsolate`, você precisa considerar que `message` é um
registro com dois valores, em vez de apenas o texto json. Faça isso desestruturando
os valores de `message`.

Em seguida, após decodificar o json, atualize a chamada para `sendPort.send` para passar tanto
o ID quanto o json decodificado de volta para o isolate principal, novamente usando um registro.

<?code-excerpt "lib/robust_ports_example/step_5_add_completers.dart (handle-commands)"?>
```dart
static void _handleCommandsToIsolate(
    ReceivePort receivePort, SendPort sendPort) {
  receivePort.listen((message) {
    final (int id, String jsonText) = message as (int, String); // Novo
    try {
      final jsonData = jsonDecode(jsonText);
      sendPort.send((id, jsonData)); // Atualizado
    } catch (e) {
      sendPort.send((id, RemoteError(e.toString(), '')));
    }
  });
}
```

Finalmente, atualize o `_handleResponsesFromIsolate`.

- Primeiro, desestruture o ID e a resposta do argumento message novamente.
- Em seguida, remova o completer que corresponde a esta solicitação do
  mapa `_activeRequests`.
- Por último, em vez de lançar um erro ou imprimir o json decodificado, conclua
  o completer, passando a resposta. Quando isso for concluído, a resposta será
  retornada ao código que chamou `parseJson` no isolate principal.

<?code-excerpt "lib/robust_ports_example/step_5_add_completers.dart (handle-response)"?>
```dart
void _handleResponsesFromIsolate(dynamic message) {
  final (int id, Object? response) = message as (int, Object?); // Novo
  final completer = _activeRequests.remove(id)!; // Novo

  if (response is RemoteError) {
    completer.completeError(response); // Atualizado
  } else {
    completer.complete(response); // Atualizado
  }
}
```

#### Passo 6: Adicione funcionalidade para fechar as portas

Quando o isolate não estiver mais sendo usado pelo seu código, você deverá fechar as
portas no isolate principal e no isolate worker.

- Primeiro, adicione um booleano de nível de classe que rastreie se as portas estão fechadas.
- Em seguida, adicione o método `Worker.close`. Dentro deste método:
  - Atualize `_closed` para ser verdadeiro.
  - Envie uma mensagem final para o isolate worker.
    Esta mensagem é uma `String` que diz "shutdown",
    mas pode ser qualquer objeto que você quiser.
    Você o usará no próximo trecho de código.
- Finalmente, verifique se `_activeRequests` está vazio. Se estiver, feche o
  `ReceivePort` do isolate principal denominado `_responses`.

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
      print('--- porta fechada --- ');
    }
  }
```

- Em seguida, você precisa lidar com a mensagem "shutdown" no isolate worker. Adicione o
  seguinte código ao método `_handleCommandsToIsolate`. Este código verificará se
  a mensagem é uma `String` que diz "shutdown". Se for, ele fechará o
  `ReceivePort` do isolate worker e retornará.

<?code-excerpt "lib/robust_ports_example/step_6_close_ports.dart (handle-commands)"?>
```dart
static void _handleCommandsToIsolate(
  ReceivePort receivePort,
  SendPort sendPort,
) {
  receivePort.listen((message) {
    // Novo bloco if.
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

- Finalmente, você deve adicionar código para verificar se as portas estão fechadas antes de tentar
  enviar mensagens. Adicione uma linha no método `Worker.parseJson`.

<?code-excerpt "lib/robust_ports_example/step_6_close_ports.dart (parse-json)"?>
```dart
Future<Object?> parseJson(String message) async {
  if (_closed) throw StateError('Closed'); // Novo
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
      await Future.wait([worker.parseJson('"yes"'), worker.parseJson('"no"')]));
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
    // Crie uma porta de recebimento e adicione seu manipulador de mensagem inicial
    final initPort = RawReceivePort();
    final connection = Completer<(ReceivePort, SendPort)>.sync();
    initPort.handler = (initialMessage) {
      final commandPort = initialMessage as SendPort;
      connection.complete((
        ReceivePort.fromRawReceivePort(initPort),
        commandPort,
      ));
    };

    // Inicie o isolate.
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
      print('--- porta fechada --- ');
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
