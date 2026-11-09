---
ia-translate: true
title: "Gerenciamento de isolates melhor com Isolate.run()"
description: "O Dart 2.19 apresenta uma nova função que torna a implementação de concorrência tão simples quanto uma única linha de código."
publishDate: 2023-01-24
author: mbelanger
image: images/0Bt-V4nlGjNKquFhK.webp
category: deep-dive
layout: blog
---


<DashImage src="images/0Bt-V4nlGjNKquFhK.webp" alt="A benchmark test showcasing the speed of the new Isolate.run() function." caption="A benchmark test showcasing the speed of the new Isolate.run() function" />


Todo código Dart roda em isolates. Se você vai implementar múltiplos isolates para habilitar [concorrência](https://dart.dev/guides/language/concurrency) nos seus programas Dart, fica a seu critério. *Como* você pode implementar múltiplos isolates é responsabilidade nossa, da equipe do Dart, e no Dart 2.19 fizemos uma grande melhoria nesse processo, que estamos animados para compartilhar. Conheça o `Isolate.run()`!

O `run()` pega toda a complexidade de configurar e gerenciar isolates e a abstrai completamente em uma única chamada de função. Já era possível usar isolates com alguns poucos primitivos há um bom tempo. Mas, mesmo com [as melhorias de performance recentes](/blog/announcing-dart-2-15#fast-concurrency-with-worker-isolates) para isolates, o processo era, na melhor das hipóteses, tedioso e, na pior, propenso a erros.

Para entender bem o quanto o `run()` é uma melhoria, este artigo detalha o método anterior de construir essa funcionalidade peça por peça, a partir de primitivos de baixo nível. Depois, vamos contrastar isso com o uso do `Isolate.run()` e mostrar como ele funciona por dentro. Mesmo que você nunca tenha usado isolates antes, temos certeza de que o `run()` vai deixar você animado para experimentá-los!

### Isolates {:#isolates}

Isolates são um conceito bastante direto. Um [isolate](/blog/dart-asynchronous-programming-isolates-and-event-loops) é, essencialmente, uma única thread de execução no Dart. Eles permitem executar partes do seu código em paralelo. Você pode iniciar novas execuções paralelas (quantas quiser) e dizer o que elas devem fazer, direto do `main` (a thread principal, ou [main isolate](https://dart.dev/guides/language/concurrency#the-main-isolate)). Isolates não compartilham memória; em vez disso, eles trocam mensagens para se comunicar. Assim, você não precisa se preocupar com problemas típicos de multithreading, como race conditions, mutexes e locks.

<DashImage src="images/0eCogwJXZtpbg5Hbq.webp" alt="A diagram illustrating how isolates communicate through message passing without sharing memory." />


Parece ótimo! Mas como você os usa? Antes do `Isolate.run()`, é aí que as coisas ficavam complicadas.

A [API de isolates](https://api.dart.dev/stable/dart-isolate/Isolate-class.html) é composta por primitivos de baixo nível que oferecem uma ampla gama de funcionalidades. Uma granularidade assim é ótima quando você precisa personalizar o comportamento dos seus isolates. Mas ela não é tão boa quando é necessário usar isolates *de forma geral*. Principalmente porque quase todos os casos de uso de isolates exigem as mesmas configurações básicas de setup e gerenciamento. Isso basicamente significava expor todos os detalhes de implementação para você, usuário do Dart, resolver por conta própria.

Vamos dar uma olhada em uma configuração típica de isolate para entender melhor o processo tedioso que o `Isolate.run()` resolve.

### Usando isolates (antes) {:#using-isolates-before}

Você pode pensar no [`Isolate.spawn()`](https://api.dart.dev/stable/dart-isolate/Isolate/spawn.html) como o antigo ponto de partida para isolates. A função compute do Flutter foi construída sobre o `spawn()`. Ele recebe um método para invocar como argumento `entrypoint`, mais quaisquer argumentos para esse método e outras configurações do próprio isolate. No passado, esse `entrypoint` só podia ser um método de nível superior (top-level) ou estático.

`Isolate.spawn(_readAndParseJson, filename);`

Isolate criado, tudo pronto! Brincadeira. Nem perto disso.

Chamar `spawn` não retorna nada com que você possa trabalhar de fato. Ele só retorna um objeto isolate, que simplesmente confirma que o isolate foi iniciado.

O isolate principal e o isolate criado pelo `spawn()` não conseguem se comunicar diretamente, além dos argumentos iniciais passados na criação. Na prática, mesmo que você não precise de nenhum resultado de computação de volta do isolate criado, ainda vai querer alguma verificação de que a computação teve sucesso, então sempre vai querer receber uma mensagem de volta.

Para habilitar a comunicação, você precisa configurar portas. Você cria um objeto `ReceivePort` antes de chamar o spawn. O membro `sendPort` do objeto `ReceivePort` vai para o isolate criado como outro argumento do `spawn`.

```dart
void main() async {
 final resultPort = ReceivePort();
 final jsonData = await Isolate.spawn(_readAndParseJson, [resultPort.sendPort, filename]);
}

```

Isso significa que a função que você passa para o `spawn` precisa estar *especificamente* configurada para fazer algo com esse `sendPort`. Em outras palavras, você não pode simplesmente reaproveitar funções existentes com isolates. Então, em vez de passar ao `spawn` uma função comum que apenas lê e faz o parse de um arquivo JSON, você criaria algo como:

```dart
Future<void> _readAndParseJson(List<dynamic> args) async {
  SendPort responsePort = args[0];
  String fileName = args[1];

  final fileData = await File(filename).readAsString();
  final result = jsonDecode(fileData);
// ...
}

```

Sua função especial, amigável a isolates, de decodificação JSON pode simplesmente “`return result`” e pronto, certo? Não exatamente. O resultado precisa ser enviado pela `responsePort`. É assim que isolates se comunicam por meio de portas. Você pode usar outro primitivo, [`Isolate.exit()`](https://api.dart.dev/stable/dart-isolate/Isolate/exit.html), para retornar o resultado de forma eficiente e fechar o isolate criado ao mesmo tempo:

`Isolate.exit(responsePort, result);`

O `exit()` *transfere* a memória que contém a mensagem do isolate criado para o isolate principal (em vez de copiá-la) e fecha o isolate com segurança.

Vamos juntar tudo isso. Como `result`, neste exemplo, é um JSON já processado, você provavelmente vai querer desestruturá-lo um pouco para realmente usá-lo. Para deixar o código limpo, em vez de colocar aquelas três linhas que criam o `receivePort` e o isolate, e aguardam a resposta, diretamente no `main()`, devemos colocá-las em sua própria função.

```dart
void main() async {
  final jsonData = await _spawnAndReceive(filename);
  print('Received JSON with ${jsonData.length} keys');
}

// Spawns an isolate and waits for the first message
Future<Map<String, dynamic>> _spawnAndReceive(String filename) async {
  final resultPort = ReceivePort();
  await Isolate.spawn(_readAndParseJson, [resultPort.sendPort, filename]);
  
  return (await resultPort.first) as Map<String, dynamic>;
}

// The entrypoint that runs on the spawned isolate.
void _readAndParseJson(List<dynamic> args) async {
  SendPort responsePort = args[0];
  String fileName = args[1];
  
  final fileData = await File(filename).readAsString();
  final result = jsonDecode(fileData) as Map<String, dynamic>;
  
  Isolate.exit(responsePort, result);
}

```

O que está sendo feito é relativamente simples. É a exposição dos detalhes de implementação que faz tudo *parecer* complicado, como as portas para troca de mensagens e a necessidade de uma função dedicada só para lidar com as portas, algo que, de resto, seria independente de isolates.

### Tratamento de erros {:#error-handling}

O exemplo até aqui *ainda* não é realmente uma implementação “completa”, pronta para produção. Você estaria prestando um desserviço a si mesmo se deixasse de fora qualquer tipo de tratamento de erros, mas ele costuma ser esquecido como mais uma etapa em um processo que já é bastante substancial. Sem nenhum tratamento de erros, se um erro assíncrono não capturado derrubasse o seu isolate, por exemplo, você não saberia o que causou o erro, nem seria alertado de que *algo aconteceu*.

Cobrir todas as possibilidades de tratamento de erros para isolates seria extenso, mas, em geral, envolveria algumas adições a mais no código.

No mínimo, você poderia adicionar os parâmetros `errorsAreFatal`, `onExit` e `onError` à chamada de spawn:

```dart
  await Isolate.spawn(_readAndParseJson, [resultPort.sendPort, filename],
          onError: resultPort.sendPort,
          onExit: resultPort.sendPort,
          errorsAreFatal: true
  );

```

Isso garante que `resultPort` receba uma mensagem mesmo se o isolate criado terminar sem enviar um resultado, ou se tiver algum erro não capturado. Tornar os erros fatais significa que erros não capturados encerram o isolate como medida de precaução, para garantir que ele termine de qualquer forma.

O argumento `onExit` faz com que o isolate envie `null` para a porta ao sair. O argumento `onError` faz com que um erro não capturado envie uma lista de duas strings para a porta (o `toString` do erro e do stack trace).

Reutilizar a porta de resultados permite evitar criar mais portas, então você só precisa procurar mensagens em um único lugar. Mas isso também significa que você precisa distinguir as mensagens de `onExit` e `onError` do valor do resultado. Aqui, presumimos que o JSON deve ser um `Map`, então não pode ser uma lista nem `null`. Caso contrário, você também teria que envolver o resultado em algo reconhecível. Você precisaria criar um protocolo de mensagens (trivial) por cima das mensagens da porta.

Além desse mínimo, você poderia então verificar a `response` em busca de erros específicos. Um desses casos seria verificar se o `resultPort` é `null`, o que significa que o isolate terminou sem enviar resultados:

```dart
  final response = await resultPort.first;
  if (response == null) {
    // Isolate exited. Throw some error, for example:
    throw RemoteError("Isolate terminated without result"); 
  }

```

Outro seria verificar se o resultado é uma lista, o que significa que ocorreu um erro não capturado:

```dart
  if (response is List<dynamic>) {
    // Uncaught error, list of two strings.
    var remoteError = RemoteError(response[0], response[1]);
    await Future.error(remoteError); // Rethrow.
  }

```

Por fim, trate um resultado de fato:

```dart
// Otherwise it's a result value, which is a map.
return message as Map<String, dynamic>;

```

Em qualquer caso, você vai querer colocar o `spawn` em um bloco `try` para verificar se o envio do `entrypoint` para o novo isolate falhou. Se falhou, a porta de resultados não vai receber nenhuma mensagem e precisa ser fechada:

```dart
  try {
    await Isolate.spawn( ... ); 
  } on Object {
    resultPort.close();
    rethrow;
  }

```

Fornecer um tratamento de erros mínimo garante que a porta de resultados sempre seja fechada e que `_spawnAndReceive` sempre termine, não importa como o isolate criado saia. Você também poderia tornar as coisas *mais agradáveis*, por exemplo, capturando e enviando erros e stack traces de volta como objetos de verdade, e não apenas como strings, como faz o handler `onError`.

O tratamento de erros, obviamente, introduz muita variação e, com ela, a sobrecarga mental de decidir como abordá-lo e o que levar em conta. É compreensível que ele costume ficar de fora da configuração primitiva de isolates.

### Usando isolates (depois) {:#using-isolates-after}

O `Isolate.run()` configura todas as partes da implementação de isolates com os primitivos que você antes precisava usar por conta própria, em uma única chamada de função:

```dart
void main() async {
  final jsonData = await Isolate.run(_readAndParseJson);
  print('Received JSON with ${jsonData.length} keys');
}

```

Sem portas, sem spawn separado, sem saída ou tratamento de erros, e sem estrutura de retorno especial. Talvez a melhor parte: o `entrypoint` que você passa para o `run` pode ser qualquer função existente:

```dart
Future<Map<String, dynamic>> _readAndParseJson() async {
  final fileData = await File(filename).readAsString();
  return jsonDecode(fileData);
}

```

Este exemplo mostra uma função *assíncrona*, mas o `run` poderia executar com a mesma facilidade uma função *síncrona*. A própria função `run` sempre retorna de forma assíncrona, e isso é o que importa.

O `entrypoint` também pode ser uma *expressão de função*, escrita diretamente em linha onde você chama o `run`. Isolates, e quaisquer APIs de nível mais alto construídas sobre eles, não ficam mais limitados a executar apenas funções estáticas ou de nível superior.

```dart
  final jsonData = await Isolate.run(() async {
    final fileData = await File(filename).readAsString();
    final jsonData = jsonDecode(fileData) as Map<String, dynamic>;
    return jsonData;
  });
```

O parâmetro de mensagem adicional não é mais necessário, e você pode evitar empacotar e desempacotar argumentos em estruturas de dados como listas.

Você não precisa pensar muito em tratamento de erros. A função `run` combina a captura, o tratamento e a comunicação entre isolates de erros locais e remotos, e expõe o resultado como um único erro normal (assíncrono) que você pode capturar em um `try`/`catch` padrão. Você pode esquecer os isolates e tratar a chamada como uma função normal.

```dart
  try {
    await Isolate.run(_readAndParseJson);
  } on FormatException catch (e, s) {
    print(e.message); 
  }

```

O `Isolate.run()` possibilita um código muito mais limpo e ergonômico. A função `compute` do Flutter até mudou para usar `run` em vez de `spawn`!

### Por dentro do Isolate.run() {:#inside-isolate-run}

Dê uma olhada na [implementação de `run`](https://api.dart.dev/dev/3.0.0-125.0.dev/dart-isolate/Isolate/run.html#implementation:~:text=isolate%20for%20debugging.-,Implementation,-%40Since(%222.19) em si. Ela explora todas as APIs de isolates de baixo nível (que antes seriam sua responsabilidade implementar) para construir uma configuração de isolate “perfeita” e abrangente. Ela recebe o método a ser executado, `computation`, e configura todas as portas e seus retornos para garantir a troca eficiente de mensagens entre isolates.

```dart
static Future<R> run<R>(FutureOr<R> computation(), {String? debugName}) {
    var result = Completer<R>();
    var resultPort = RawReceivePort();
    // ...
    result.complete;    // or result.completeError for error handling blocks
    // ...

```

Há tratamento de erros *completo* para todos os casos potenciais. A função `run` verifica se um isolate morre antes de terminar a computação. Se a computação lançar um erro, o isolate termina e lança o mesmo erro para o isolate principal.

```dart
// ...
    resultPort.handler = (response) {
      resultPort.close();
      if (response == null) {
        // onExit handler message, isolate terminated without sending result.
        result.completeError(
            RemoteError("Computation ended without result", ""),
            StackTrace.empty);
        return;
      }
// ...

```

Se ocorrer um erro assíncrono não capturado, o isolate termina e reporta o erro de forma assíncrona para o isolate principal. Se o isolate principal terminar primeiro, o isolate criado termina e trata a situação como um erro assíncrono não capturado.

```dart
// ...
void _run() async {
    R result;
    try {
      var potentiallyAsyncResult = computation();
      if (potentiallyAsyncResult is Future<R>) {
        result = await potentiallyAsyncResult;
      } else {
        result = potentiallyAsyncResult;
      }
    } catch (e, s) {
      // If sending fails, the error becomes an uncaught error.
      Isolate.exit(resultPort, _list2(e, s));
    }
    Isolate.exit(resultPort, _list1(result));
  }

```

Por fim, o `run` sempre usa `exit` para encerrar com segurança. Isso significa que os dados são transferidos de isolate para isolate de forma eficiente, sem serem de fato copiados.

### Resumo {:#summary}

A função `run` é ideal para iniciar uma computação e aguardar os resultados. Os primitivos continuam disponíveis se você quiser montar sua própria configuração de isolate para algo que o `run` não cobre, como um [isolate de longa duração](https://github.com/dart-lang/samples/blob/master/isolates/bin/long_running_isolate.dart) que pode enviar e receber mensagens várias vezes. Mas, na maioria dos casos, substituir o `spawn` e todas as suas configurações de suporte por uma única instrução `run` deve ser preferido a qualquer outra configuração.

Se você nunca tinha experimentado gerenciar isolates antes do `run`, seria difícil acreditar que toda essa funcionalidade antes precisava ser implementada pelo usuário! O `Isolate.run()`, disponível no Dart 2.19 e no Flutter 3.7, torna o código muito mais ergonômico e os isolates muito mais fáceis de usar. O que você vai fazer com todo o tempo que o `run` economiza?
