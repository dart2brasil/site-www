---
ia-translate: true
title: Zones
description: >-
  Gerencie seu código assíncrono: trate erros não capturados,
  substitua comportamentos (como imprimir e agendar tarefas), e mais.
date: 2014-03-03
obsolete: true
---

<style>
.zone1 {
  background-color: rgb(208, 211, 255);
}

.zone2 {
  background-color: rgb(195, 255, 231);
}

.zone3 {
  background-color: rgb(255, 240, 164);
}
</style>

## Extensões dinâmicas assíncronas {:#asynchronous-dynamic-extents}

Este artigo discute as APIs relacionadas a zones na biblioteca [dart:async][],
com foco nas funções de nível superior [`runZoned()`][]
e [`runZonedGuarded()`][].
Revise as técnicas abordadas em
[Futures e tratamento de erros](/libraries/async/futures-error-handling)
antes de ler este artigo.

[dart:async]: {{site.dart-api}}/dart-async/dart-async-library.html
[`runZoned()`]: {{site.dart-api}}/dart-async/runZoned.html
[`runZonedGuarded()`]: {{site.dart-api}}/dart-async/runZonedGuarded.html

Zones tornam possíveis as seguintes tarefas:

* **Impedir que seu app seja encerrado por causa de
  uma exceção não capturada**.
  Por exemplo,
  um servidor HTTP simples
  pode usar o seguinte código assíncrono:

  ```dart
  [!runZonedGuarded(() {!]
    HttpServer.bind('0.0.0.0', port).then((server) {
      server.listen(staticFiles.serveRequest);
    });
  [!},!]
  [!(error, stackTrace) => print('Oh noes! $error $stackTrace'));!]
  ```
  
  Executar o servidor HTTP em uma zone
  permite que o app continue rodando apesar de erros não capturados (mas não fatais)
  no código assíncrono do servidor.

* **Associar dados**—conhecidos como
  <em>valores locais de zone</em>—**a zones individuais**.

* **Substituir um conjunto limitado de métodos**,
  como `print()` e `scheduleMicrotask()`,
  em parte ou em todo o código.

* **Executar uma operação toda vez que
  o código entra ou sai de uma zone**.
  Tais operações podem incluir
  iniciar ou parar um timer,
  ou salvar um stack trace.

Você pode já ter encontrado algo parecido com zones em outras linguagens.
_Domains_ no Node.js foram uma inspiração para as zones do Dart.
O _thread-local storage_ do Java
também tem algumas semelhanças.
Mais próximo de todos está o port JavaScript das zones do Dart feito por Brian Ford,
[zone.js](https://github.com/btford/zone.js/), que ele descreve em
[este vídeo]({{site.yt.watch}}?v=3IqtmUscE_U).


## Noções básicas de zone {:#zone-basics}

Uma _zone_ representa a extensão dinâmica assíncrona de uma chamada.
É a computação executada como parte de uma chamada e, transitivamente,
os callbacks assíncronos registrados por esse código.

Por exemplo,
no exemplo do servidor HTTP,
`bind()`, `then()` e o callback de `then()`
executam todos na mesma zone—a zone
que foi criada usando `runZoned()`.

No próximo exemplo,
o código executa em 3 zones diferentes:
<span class="zone1">zone #1</span> (a zone raiz),
<span class="zone2">zone #2</span> e
<span class="zone3">zone #3</span>.

<!-- ex1.dart -->
<!-- Using pre instead of prettify so we can use background colors -->
<pre>
import 'dart:async';

<span class="zone1">main() {
  foo();
  var future;
  runZoned(() {</span>          // Starts a new child zone (zone #2).
<span class="zone2">    future = new Future(bar).then(baz);
  </span><span class="zone1">});
  future.then(qux);
}</span>

foo() => <em><span class="zone1">...foo</span><span class="zone3">-body...</span></em>  // Executed twice (once each in two zones).
bar() => <em><span class="zone2">...bar-body...</span></em>
baz(x) => <span class="zone2">runZoned(() =></span> <span class="zone3">foo()</span><span class="zone2">);</span> // New child zone (zone #3).
qux(x) => <em><span class="zone1">...qux-body...</span></em>
</pre>

A figura a seguir mostra a ordem de execução do código,
bem como em qual zone cada parte do código executa.

![illustration of program execution](/assets/img/articles/zones/trace.png)

Cada chamada a `runZoned()` cria uma nova zone
e executa código nessa zone.
Quando esse código agenda uma tarefa—como
chamar baz()—essa
tarefa executa na zone onde foi agendada.
Por exemplo, a chamada a qux() (última linha de main())
executa em
<span class="zone1">zone #1</span> (a zone raiz)
mesmo estando anexada a um future que executa em
<span class="zone2">zone #2</span>.

Zones filhas não substituem completamente sua zone pai.
Em vez disso, as novas zones são aninhadas dentro da zone que as envolve.
Por exemplo,
<span class="zone2">zone #2</span> contém
<span class="zone3">zone #3</span>, e
<span class="zone1">zone #1</span> (a zone raiz)
contém tanto
<span class="zone2">zone #2</span> quanto
<span class="zone3">zone #3</span>.

Todo código Dart executa na zone raiz.
O código pode executar também em zones filhas aninhadas,
mas no mínimo sempre roda na zone raiz.


## Tratando erros não capturados {:#handling-uncaught-errors}

Zones são capazes de capturar e tratar erros não capturados.

_Erros não capturados_ frequentemente ocorrem quando o código usa `throw`
para lançar uma exceção sem um `catch`
correspondente para tratá-la.
Erros não capturados também podem surgir em funções `async`
quando um Future completa com um resultado de erro,
mas falta um `await` correspondente para tratar o erro.

Um erro não capturado é reportado à zone atual que falhou em capturá-lo.
Por padrão, as zones encerram o programa em resposta a erros não capturados.
Você pode instalar seu próprio _handler de erro não capturado_ em uma nova zone
para interceptar e tratar erros não capturados do jeito que preferir.

Para introduzir uma nova zone com um handler de erro não capturado,
use o método `runZoneGuarded`. Seu callback `onError` se torna o
handler de erro não capturado de uma nova zone. Esse callback trata qualquer
erro síncrono que a chamada lançar.

<!-- run_zoned1.dart -->
```dart
runZonedGuarded(() {
  Timer.run(() { throw 'Would normally kill the program'; });
}, (error, stackTrace) {
  print('Uncaught error: $error');
});
```

_Outras APIs de zone que facilitam o tratamento de erros não capturados incluem
[`Zone.fork`][], [`Zone.runGuarded`][]
e [`ZoneSpecification.uncaughtErrorHandler`][]._

[`Zone.fork`]:  {{site.dart-api}}/dart-async/Zone/fork.html
[`Zone.runGuarded`]:  {{site.dart-api}}/dart-async/Zone/runGuarded.html
[`ZoneSpecification.uncaughtErrorHandler`]:  {{site.dart-api}}/dart-async/ZoneSpecification/handleUncaughtError.html

O código anterior tem um callback assíncrono
(via `Timer.run()`) que lança uma exceção.
Normalmente essa exceção seria um erro não tratado e chegaria ao nível superior
(que, no executável Dart standalone, encerraria o processo em execução).
No entanto, com o handler de erro da zone,
o erro é passado para o handler e não derruba o programa.

Uma diferença notável entre try-catch e os handlers de erro de zone é
que as zones continuam executando depois que erros não capturados ocorrem.
Se outros callbacks assíncronos forem agendados dentro da zone,
eles ainda executam.
Como consequência, um handler de erro de zone pode
ser invocado várias vezes.

Qualquer zone com um handler de erro não capturado é chamada de _error zone_.
Uma error zone pode tratar erros que se originam
em uma zone descendente dela.
Uma regra simples determina onde
os erros são tratados em uma sequência de transformações de future
(usando `then()` ou `catchError()`):
erros em cadeias de Future nunca cruzam as fronteiras de error zones.

Se um erro alcançar a fronteira de uma error zone,
ele é tratado como erro não tratado naquele ponto.

:::note Nota sobre a API
Tratar erros não capturados não *exige* zones.
A API de isolates [`Isolate.run()`][] também trata
a escuta de erros não capturados.
:::

[`Isolate.run()`]: {{site.dart-api}}/dev/dart-isolate/Isolate/run.html

### Exemplo: erros não podem cruzar para dentro de error zones {:#example-errors-cant-cross-into-error-zones}

No exemplo a seguir,
o erro lançado pela primeira linha
não consegue cruzar para dentro de uma error zone.

<!-- run_zoned2.dart -->
```dart
var f = new Future.error(499);
f = f.whenComplete(() { print('Outside of zones'); });
runZoned(() {
  f = f.whenComplete(() { print('Inside non-error zone'); });
});
runZonedGuarded(() {
  f = f.whenComplete(() { print('Inside error zone (not called)'); });
}, (error) { print(error); });
```

Aqui está a saída que você vê ao executar o exemplo:

```plaintext
Outside of zones
Inside non-error zone
Uncaught Error: 499
Unhandled exception:
499
...stack trace...
```

Se você remover a chamada a `runZoned()` ou
a `runZonedGuarded()`,
verá esta saída:

```plaintext
Outside of zones
Inside non-error zone
[!Inside error zone (not called)!]
Uncaught Error: 499
Unhandled exception:
499
...stack trace...
```

Observe como remover qualquer uma das zones—a zone comum ou a error zone—faz
o erro se propagar mais.

O stack trace aparece porque o erro acontece fora de uma error zone.
Se você adicionar uma error zone em volta de todo o trecho de código,
poderá evitar o stack trace.


### Exemplo: erros não podem sair de error zones {:#example-errors-cant-leave-error-zones}

Como o código anterior mostra,
erros não podem entrar em error zones.
Da mesma forma, erros não podem _sair_ de error zones.
Considere este exemplo:

<!-- run_zoned3.dart -->
```dart
var completer = new Completer();
var future = completer.future.then((x) => x + 1);
var zoneFuture;
runZonedGuarded(() {
  zoneFuture = future.then((y) => throw 'Inside zone');
}, (error) { print('Caught: $error'); });

zoneFuture.catchError((e) { print('Never reached'); });
completer.complete(499);
```

Mesmo que a cadeia de future termine em um `catchError()`,
o erro assíncrono não consegue sair da error zone.
O handler de erro da zone encontrado em `runZonedGuarded()`
trata o erro.
Como resultado, *zoneFuture nunca completa*—nem
com um valor, nem com um erro.

## Usando zones com streams {:#using-zones-with-streams}

A regra para zones e streams
é mais simples do que a dos futures:

:::note
Transformações e outros callbacks executam na zone
em que o stream é escutado.
:::

Essa regra decorre da diretriz de que
streams não devem ter efeitos colaterais até serem escutados.
Uma situação parecida no código síncrono é o comportamento dos Iterables,
que não são avaliados até que você peça os valores.

### Exemplo: usando um stream com `runZonedGuarded()` {:#example-using-a-stream-with-runzonedguarded}

O exemplo a seguir configura um stream com um callback,
e então executa esse stream em uma nova zone com `runZonedGuarded()`:

<!-- stream.dart -->
```dart
var stream = new File('stream.dart').openRead()
    .map((x) => throw 'Callback throws');

runZonedGuarded(() { stream.listen(print); },
         (e) { print('Caught error: $e'); });
```

O handler de erro em `runZonedGuarded()`
captura o erro que o callback lança.
Aqui está a saída:

```plaintext
Caught error: Callback throws
```

Como a saída mostra,
o callback está associado à zone que escuta,
e não à zone em que `map()` é chamado.


## Armazenando valores locais de zone {:#storing-zone-local-values}

Se você já quis usar uma variável estática, mas não pôde porque
várias computações concorrentes interferiam umas nas outras,
considere usar um valor local de zone.
Você pode adicionar um valor local de zone para ajudar na depuração.
Outro caso de uso é lidar com uma requisição HTTP:
você poderia guardar o ID do usuário
e o token de autorização em valores locais de zone.

Use o argumento `zoneValues` de `runZoned()` para
armazenar valores na zone recém-criada:

<!-- value1.dart -->
```dart
runZoned(() {
  print(Zone.current[#key]);
}, zoneValues: { #key: 499 });
```

Para ler valores locais de zone, use o operador de índice da zone e a chave do valor:
<code>[<em>key</em>]</code>.
Qualquer objeto pode ser usado como chave, desde que tenha implementações
compatíveis de `operator ==` e `hashCode`.
Normalmente, uma chave é um symbol literal:
<code>#<em>identificador</em></code>.

Você não pode trocar o objeto ao qual uma chave está mapeada,
mas pode manipular o objeto.
Por exemplo, o código a seguir
adiciona um item a uma lista local de zone:

<!-- value1_1.dart -->
```dart
runZoned(() {
  Zone.current[#key].add(499);
  print(Zone.current[#key]); // [499]
}, zoneValues: { #key: [] });
```

Uma zone herda os valores locais de zone da sua zone pai,
então adicionar zones aninhadas não derruba acidentalmente valores existentes.
Zones aninhadas, porém, podem sobrepor valores do pai.

:::important
Tente usar objetos únicos como chaves,
para que seja menos provável que entrem em conflito com outras bibliotecas.
:::


### Exemplo: usando um valor local de zone para logs de depuração {:#example-using-a-zone-local-value-for-debug-logs}

Suponha que você tenha dois arquivos, foo.txt e bar.txt,
e queira imprimir todas as linhas deles.
O programa poderia ser assim:

<!-- value2.dart -->
```dart
import 'dart:async';
import 'dart:convert';
import 'dart:io';

Future splitLinesStream(stream) {
  return stream
      .transform(ASCII.decoder)
      .transform(const LineSplitter())
      .toList();
}

Future splitLines(filename) {
  return splitLinesStream(new File(filename).openRead());
}
main() {
  Future.forEach(['foo.txt', 'bar.txt'],
                 (file) => splitLines(file)
                     .then((lines) { lines.forEach(print); }));
}
```

Este programa funciona,
mas vamos supor que agora você queira saber
de qual arquivo cada linha vem,
e que não pode simplesmente adicionar um argumento de nome de arquivo a `splitLinesStream()`.
Com valores locais de zone, você pode adicionar o nome do arquivo à string retornada
(as novas linhas estão destacadas):

<!-- value3.dart -->
```dart
import 'dart:async';
import 'dart:convert';
import 'dart:io';

Future splitLinesStream(stream) {
  return stream
      .transform(ASCII.decoder)
      .transform(const LineSplitter())
[!      .map((line) => '${Zone.current[#filename]}: $line')!]
      .toList();
}

Future splitLines(filename) {
[!  return runZoned(() {!]
    return splitLinesStream(new File(filename).openRead());
[!  }, zoneValues: { #filename: filename });!]
}

main() {
  Future.forEach(['foo.txt', 'bar.txt'],
                 (file) => splitLines(file)
                     .then((lines) { lines.forEach(print); }));
}
```

Observe que o novo código não modifica as assinaturas das funções nem
passa o nome do arquivo de `splitLines()` para `splitLinesStream()`.
Em vez disso, ele usa valores locais de zone para implementar
um recurso parecido com uma variável estática,
mas que funciona em contextos assíncronos.


## Sobrescrevendo funcionalidades {:#overriding-functionality}

Use o argumento `zoneSpecification` de `runZoned()`
para sobrescrever funcionalidades gerenciadas pelas zones.
O valor do argumento é um objeto
[ZoneSpecification]({{site.dart-api}}/dart-async/ZoneSpecification-class.html),
com o qual você pode sobrescrever qualquer uma das seguintes funcionalidades:

* Criar zones filhas (fork)
* Registrar e executar callbacks na zone
* Agendar microtasks e timers
* Tratar erros assíncronos não capturados
  (`runZonedGuarded()` é um atalho para isso)
* Impressão (print)

### Exemplo: sobrescrevendo print {:#example-overriding-print}

Como um exemplo simples de sobrescrita de funcionalidade,
veja uma forma de silenciar todos os prints dentro de uma zone:

<!-- specification1.dart -->
```dart
import 'dart:async';

main() {
  runZoned(() {
    print('Will be ignored');
  }, zoneSpecification: new ZoneSpecification(
    print: (self, parent, zone, message) {
      // Ignore message.
    }));
}
```

Dentro da zone filha,
a função `print()` é sobrescrita pelo interceptor de print especificado,
que simplesmente descarta a mensagem.
Sobrescrever o print é possível porque `print()`
(assim como `scheduleMicrotask()` e os construtores de Timer)
usa a zone atual (`Zone.current`) para realizar seu trabalho.


### Argumentos dos interceptores e delegates {:#arguments-to-interceptors-and-delegates}

Como o exemplo de print mostra,
um interceptor adiciona três argumentos
aos definidos no método correspondente da classe Zone.
Por exemplo, o método `print()` de Zone tem um argumento:
`print(String line)`.
A versão interceptadora de `print()`,
definida por ZoneSpecification,
tem quatro argumentos:
`print(Zone self, ZoneDelegate parent, Zone zone, String line)`.

Os três argumentos do interceptor sempre aparecem na mesma ordem,
antes de quaisquer outros argumentos.

`self`
: A zone que está tratando o callback.

`parent`
: Um ZoneDelegate que representa a zone pai.
  Use-o para encaminhar operações ao pai.

`zone`
: A zone de onde a operação se originou.
  Algumas operações precisam saber em qual zone a operação foi invocada.
  Por exemplo, `zone.fork(specification)` precisa
  criar uma nova zone como filha de `zone`.
  Como outro exemplo,
  mesmo quando você delega `scheduleMicrotask()` para outra zone,
  a `zone` original deve ser a que executa a microtask.


Quando um interceptor delega um método para o pai,
a versão do método no pai (ZoneDelegate) tem apenas um argumento adicional:
`zone`, a zone de onde a chamada original se originou.
Por exemplo,
a assinatura do método `print()` em um ZoneDelegate é
`print(Zone zone, String line)`.

Aqui está um exemplo dos argumentos
de outro método interceptável, `scheduleMicrotask()`:

| **Onde é definido** | **Assinatura do método** |
| Zone              | `void scheduleMicrotask(void f())` |
| ZoneSpecification&nbsp; | `void scheduleMicrotask(Zone self, ZoneDelegate parent, Zone zone, void f())` |
| ZoneDelegate      | `void scheduleMicrotask(Zone zone, void f())` |


### Exemplo: delegando para a zone pai {:#example-delegating-to-the-parent-zone}

Aqui está um exemplo que mostra como delegar para a zone pai:

<!-- specification2.dart -->
```dart
import 'dart:async';

main() {
  runZoned(() {
    var currentZone = Zone.current;
    scheduleMicrotask(() {
      print(identical(currentZone, Zone.current));  // prints true.
    });
  }, zoneSpecification: new ZoneSpecification(
    scheduleMicrotask: (self, parent, zone, task) {
      print('scheduleMicrotask has been called inside the zone');
      // The origin `zone` needs to be passed to the parent so that
      // the task can be executed in it.
      parent.scheduleMicrotask(zone, task);
    }));
}
```


### Exemplo: executando código ao entrar e sair de uma zone {:#example-executing-code-when-entering-and-leaving-a-zone}

Suponha que você queira saber quanto tempo algum código assíncrono
gasta executando.
Você pode fazer isso colocando o código em uma zone,
iniciando um timer toda vez que a zone é entrada,
e parando o timer sempre que a zone é deixada.

Fornecer os parâmetros `run*` para o ZoneSpecification
permite especificar o código que a zone executa.

:::note Nota sobre a API
No futuro, as zones podem oferecer uma alternativa mais simples
para o caso comum de envolver código da zone:
uma API onEnter/onLeave.
Veja a [issue 17532]({{site.repo.dart.sdk}}/issues/17532)
para detalhes.
:::

Os parâmetros `run*`—`run`, `runUnary` e `runBinary`—especificam
o código a executar toda vez que a zone é solicitada a executar código.
Esses parâmetros funcionam para callbacks sem argumentos, com um argumento
e com dois argumentos, respectivamente.
O parâmetro `run` também funciona para o código inicial e síncrono
que executa logo após chamar `runZoned()`.

Aqui está um exemplo de profiling de código usando `run*`:

<!-- profile_run.dart -->
```dart
final total = new Stopwatch();
final user = new Stopwatch();

final specification = new ZoneSpecification(
  run: (self, parent, zone, f) {
    user.start();
    try { return parent.run(zone, f); } finally { user.stop(); }
  },
  runUnary: (self, parent, zone, f, arg) {
    user.start();
    try { return parent.runUnary(zone, f, arg); } finally { user.stop(); }
  },
  runBinary: (self, parent, zone, f, arg1, arg2) {
    user.start();
    try {
      return parent.runBinary(zone, f, arg1, arg2);
    } finally {
      user.stop();
    }
  });

runZoned(() {
  total.start();
  // ... Code that runs synchronously...
  // ... Then code that runs asynchronously ...
    .then((...) {
      print(total.elapsedMilliseconds);
      print(user.elapsedMilliseconds);
    });
}, zoneSpecification: specification);
```

Nesse código,
cada sobrescrita de `run*` apenas inicia o timer de usuário,
executa a função especificada,
e então para o timer de usuário.


### Exemplo: tratando callbacks {:#example-handling-callbacks}

Forneça parâmetros `register*Callback` para o ZoneSpecification
para envolver ou alterar o código de callback—o código
que é executado de forma assíncrona na zone.
Assim como os parâmetros `run*`, os parâmetros `register*Callback` têm três formas:
`registerCallback` (para callbacks sem argumentos), 
`registerUnaryCallback` (um argumento) e
`registerBinaryCallback` (dois argumentos).

Aqui está um exemplo que faz a zone
salvar um stack trace
antes que o código desapareça em um contexto assíncrono.

<!-- debug.dart -->
```dart
import 'dart:async';

get currentStackTrace {
  try {
    throw 0;
  } catch(_, st) {
    return st;
  }
}

var lastStackTrace = null;

bar() => throw "in bar";
foo() => new Future(bar);

main() {
  final specification = new ZoneSpecification(
    registerCallback: (self, parent, zone, f) {
      var stackTrace = currentStackTrace;
      return parent.registerCallback(zone, () {
        lastStackTrace = stackTrace;
        return f();
      });
    },
    registerUnaryCallback: (self, parent, zone, f) {
      var stackTrace = currentStackTrace;
      return parent.registerUnaryCallback(zone, (arg) {
        lastStackTrace = stackTrace;
        return f(arg);
      });
    },
    registerBinaryCallback: (self, parent, zone, f) {
      var stackTrace = currentStackTrace;
      return parent.registerBinaryCallback(zone, (arg1, arg2) {
        lastStackTrace = stackTrace;
        return f(arg1, arg2);
      });
    },
    handleUncaughtError: (self, parent, zone, error, stackTrace) {
      if (lastStackTrace != null) print("last stack: $lastStackTrace");
      return parent.handleUncaughtError(zone, error, stackTrace);
    });

  runZoned(() {
    foo();
  }, zoneSpecification: specification);
}
```

Execute o exemplo.
Você verá um stack trace "last stack" (`lastStackTrace`)
que inclui `foo()`,
já que `foo()` foi chamada de forma síncrona.
O próximo stack trace (`stackTrace`)
vem do contexto assíncrono,
que conhece `bar()`, mas não `foo()`.


### Implementando callbacks assíncronos {:#implementing-asynchronous-callbacks}

Mesmo se você estiver implementando uma API assíncrona,
talvez nem precise lidar com zones.
Por exemplo, embora você possa esperar que a biblioteca dart:io
mantenha o controle das zones atuais,
ela, na verdade, depende do tratamento de zones das classes do dart:async,
como Future e Stream.

Se você lidar com zones explicitamente,
então precisa registrar todos os callbacks assíncronos
e garantir que cada callback seja invocado na zone
onde foi registrado.
Os métodos auxiliares `bind*Callback` de Zone
facilitam essa tarefa.
Eles são atalhos para `register*Callback` e `run*`,
garantindo que cada callback seja registrado e execute nessa Zone.

Se você precisar de mais controle do que `bind*Callback` oferece,
então precisa usar `register*Callback` e `run*`.
Você também pode querer usar os métodos `run*Guarded` de Zone,
que envolvem a chamada em um try-catch
e invocam o `uncaughtErrorHandler`
se ocorrer um erro.


## Resumo {:#summary}

Zones são boas para proteger seu código contra
exceções não capturadas em código assíncrono,
mas podem fazer muito mais.
Você pode associar dados a zones,
e pode sobrescrever funcionalidades centrais, como
impressão e agendamento de tarefas.
Zones possibilitam uma depuração melhor e oferecem pontos de extensão
que você pode usar para funcionalidades como profiling.


### Mais recursos {:#more-resources}

Documentação da API de zones
: Leia a documentação de
  [runZoned()]({{site.dart-api}}/dart-async/runZoned.html),
  [runZonedGuarded()]({{site.dart-api}}/dart-async/runZonedGuarded.html),
  [Zone]({{site.dart-api}}/dart-async/Zone-class.html),
  [ZoneDelegate]({{site.dart-api}}/dart-async/ZoneDelegate-class.html) e
  [ZoneSpecification]({{site.dart-api}}/dart-async/ZoneSpecification-class.html).

stack_trace
: Com a [classe Chain]({{site.pub-api}}/stack_trace/latest/stack_trace/Chain-class.html)
  da biblioteca stack_trace
  você pode obter stack traces melhores para código executado de forma assíncrona.
  Veja o [pacote stack_trace]({{site.pub-pkg}}/stack_trace)
  no site pub.dev para mais informações.


### Mais exemplos {:#more-examples}

Aqui estão alguns exemplos mais complexos de uso de zones.

O exemplo task_interceptor
: A zone de brinquedo em
  [task_interceptor.dart](https://github.com/dart-archive/www.dartlang.org/blob/master/src/tests/site/articles/zones/task_interceptor.dart)
  intercepta `scheduleMicrotask`, `createTimer` e `createPeriodicTimer`
  para simular o comportamento das primitivas do Dart
  sem ceder o controle ao event loop.

O código-fonte do pacote stack_trace
: O [pacote stack_trace]({{site.pub-pkg}}/stack_trace)
  usa zones para formar cadeias de stack traces
  para depurar código assíncrono.
  Os recursos de zone usados incluem tratamento de erros, valores locais de zone e callbacks.
  Você pode encontrar o código-fonte do stack_trace no
  [projeto stack_trace no GitHub]({{site.repo.dart.org}}/stack_trace).

O código-fonte do dart:async
: Estas duas bibliotecas do SDK implementam APIs com callbacks assíncronos,
  e por isso lidam com zones.
  Você pode navegar ou baixar o código-fonte delas no
  [diretório sdk/lib]({{site.repo.dart.sdk}}/tree/main/sdk/lib)
  do
  [projeto Dart no GitHub]({{site.repo.dart.sdk}}).


_Agradecimentos a Anders Johnsen e Lasse Reichstein Nielsen
pelas revisões deste artigo._
