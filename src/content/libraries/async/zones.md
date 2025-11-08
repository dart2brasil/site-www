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

## Extensões dinâmicas assíncronas

Este artigo discute APIs relacionadas a zones na biblioteca [dart:async][],
com foco nas funções de nível superior [`runZoned()`][]
e [`runZonedGuarded()`][].
Revise as técnicas cobertas em
[Futures e Tratamento de Erros](/libraries/async/futures-error-handling)
antes de ler este artigo.

[dart:async]: ({{site.dart-api}}/dart-async/dart-async-library.html)
[`runZoned()`]: ({{site.dart-api}}/dart-async/runZoned.html)
[`runZonedGuarded()`]: ({{site.dart-api}}/dart-async/runZonedGuarded.html)

Zones tornam as seguintes tarefas possíveis:

* **Proteger seu aplicativo de sair devido a
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
  permite que o aplicativo continue rodando apesar de erros não capturados (mas não fatais)
  no código assíncrono do servidor.

* **Associar dados**—conhecidos como
  <em>valores locais de zone</em>—**com zones individuais**.

* **Substituir um conjunto limitado de métodos**,
  como `print()` e `scheduleMicrotask()`,
  dentro de parte ou todo o código.

* **Executar uma operação cada vez que
  o código entra ou sai de uma zone**.
  Tais operações podem incluir
  iniciar ou parar um timer,
  ou salvar um stack trace.

Você pode ter encontrado algo similar a zones em outras linguagens.
_Domains_ no Node.js foram uma inspiração para zones do Dart.
_Thread-local storage_ do Java
também tem algumas similaridades.
O mais próximo de todos é o port JavaScript de zones do Dart por Brian Ford,
[zone.js](https://github.com/btford/zone.js/), que ele descreve em
[este vídeo]({{site.yt.watch}}?v=3IqtmUscE_U).


## Básicos de zone

Uma _zone_ representa a extensão dinâmica assíncrona de uma chamada.
É a computação que é executada como parte de uma chamada e, transitivamente,
os callbacks assíncronos que foram registrados por esse código.

Por exemplo,
no exemplo do servidor HTTP,
`bind()`, `then()`, e o callback de `then()`
todos executam na mesma zone—a zone
que foi criada usando `runZoned()`.

No próximo exemplo,
o código executa em 3 zones diferentes:
<span class="zone1">zone #1</span> (a zone raiz),
<span class="zone2">zone #2</span>, e
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
bem como em qual zone o código executa.

![illustration of program execution](/assets/img/articles/zones/trace.png)

Cada chamada a `runZoned()` cria uma nova zone
e executa código nessa zone.
Quando esse código agenda uma tarefa—como
chamar baz()—essa
tarefa executa na zone onde foi agendada.
Por exemplo, a chamada a qux() (última linha de main())
executa em
<span class="zone1">zone #1</span> (a zone raiz)
mesmo que esteja anexada a um future que executa em
<span class="zone2">zone #2</span>.

Zones filhas não substituem completamente sua zone pai.
Em vez disso, novas zones são aninhadas dentro de sua zone envolvente.
Por exemplo,
<span class="zone2">zone #2</span> contém
<span class="zone3">zone #3</span>, e
<span class="zone1">zone #1</span> (a zone raiz)
contém tanto
<span class="zone2">zone #2</span> quanto
<span class="zone3">zone #3</span>.

Todo código Dart executa na zone raiz.
O código pode executar em outras zones filhas aninhadas também,
mas no mínimo sempre roda na zone raiz.


## Lidando com erros não capturados

Zones são capazes de capturar e lidar com erros não capturados.

_Erros não capturados_ frequentemente ocorrem devido a código usando `throw`
para lançar uma exceção sem um `catch`
correspondente para lidar com ela.
Erros não capturados também podem surgir em funções `async`
quando um Future completa com um resultado de erro,
mas está faltando um `await` correspondente para lidar com o erro.

Um erro não capturado reporta à zone atual que falhou em capturá-lo.
Por padrão, zones irão crashar o programa em resposta a erros não capturados.
Você pode instalar seu próprio _handler de erro não capturado_ personalizado para uma nova zone
para interceptar e lidar com erros não capturados da maneira que preferir.

Para introduzir uma nova zone com um handler de erro não capturado,
use o método `runZoneGuarded`. Seu callback `onError` se torna o
handler de erro não capturado de uma nova zone. Este callback lida com qualquer
erro síncrono que a chamada lança.

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
(através de `Timer.run()`) que lança uma exceção.
Normalmente esta exceção seria um erro não tratado e alcançaria o nível superior
(que, no executável Dart standalone, mataria o processo em execução).
No entanto, com o handler de erro zoned,
o erro é passado para o handler de erro e não desliga o programa.

Uma diferença notável entre try-catch e handlers de erro zoned é
que zones continuam a executar após erros não capturados ocorrerem.
Se outros callbacks assíncronos forem agendados dentro da zone,
eles ainda executam.
Como consequência, um handler de erro zoned pode
ser invocado múltiplas vezes.

Qualquer zone com um handler de erro não capturado é chamada de _error zone_.
Uma error zone pode lidar com erros que se originam
em um descendente dessa zone.
Uma regra simples determina onde
erros são tratados em uma sequência de transformações de future
(usando `then()` ou `catchError()`):
Erros em cadeias de Future nunca cruzam os limites de error zones.

Se um erro alcança o limite de uma error zone,
ele é tratado como erro não tratado naquele ponto.

:::note API note
Lidar com erros não capturados não *requer* zones.
A API de isolate [`Isolate.run()`][] também lida
com escutar erros não capturados.
:::

[`Isolate.run()`]: {{site.dart-api}}/dev/dart-isolate/Isolate/run.html

### Exemplo: Erros não podem cruzar para error zones

No exemplo a seguir,
o erro lançado pela primeira linha
não pode cruzar para uma error zone.

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

Aqui está a saída que você vê se executar o exemplo:

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
você verá esta saída:

```plaintext
Outside of zones
Inside non-error zone
[!Inside error zone (not called)!]
Uncaught Error: 499
Unhandled exception:
499
...stack trace...
```

Note como remover a zone ou error zone faz com que
o erro se propague mais longe.

O stack trace aparece porque o erro acontece fora de uma error zone.
Se você adicionar uma error zone em volta de todo o snippet de código,
então você pode evitar o stack trace.


### Exemplo: Erros não podem sair de error zones

Como o código anterior mostra,
erros não podem cruzar para error zones.
Similarmente, erros não podem cruzar _para fora_ de error zones.
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
o erro assíncrono não pode sair da error zone.
O handler de erro zoned encontrado em `runZonedGuarded()`
lida com o erro.
Como resultado, *zoneFuture nunca completa* — nem
com um valor, nem com um erro.

## Usando zones com streams

A regra para zones e streams
é mais simples que para futures:

:::note
Transformações e outros callbacks executam na zone
onde o stream é escutado.
:::

Esta regra segue da diretriz de que
streams não devem ter efeito colateral até serem escutados.
Uma situação similar em código síncrono é o comportamento de Iterables,
que não são avaliados até você pedir por valores.

### Exemplo: Usando um stream com `runZonedGuarded()`

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
o callback está associado à zone de escuta,
não à zone onde `map()` é chamado.


## Armazenando valores locais de zone

Se você já quis usar uma variável estática
mas não pôde porque
múltiplas computações concorrentes interferiam umas com as outras,
considere usar um valor local de zone.
Você pode adicionar um valor local de zone para ajudar com debugging.
Outro caso de uso é lidar com uma requisição HTTP:
você poderia ter o ID do usuário
e seu token de autorização em valores locais de zone.

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
Qualquer objeto pode ser usado como chave, desde que tenha
implementações compatíveis de `operator ==` e `hashCode`.
Tipicamente, uma chave é um literal symbol:
<code>#<em>identifier</em></code>.

Você não pode mudar o objeto para o qual uma chave mapeia,
mas você pode manipular o objeto.
Por exemplo, o código a seguir
adiciona um item a uma lista local de zone:

<!-- value1_1.dart -->
```dart
runZoned(() {
  Zone.current[#key].add(499);
  print(Zone.current[#key]); // [499]
}, zoneValues: { #key: [] });
```

Uma zone herda valores locais de zone de sua zone pai,
então adicionar zones aninhadas não descarta acidentalmente valores existentes.
Zones aninhadas podem, no entanto, sombrear valores pai.

:::important
Tente usar objetos únicos para chaves,
para que sejam menos propensos a conflitar com outras bibliotecas.
:::


### Exemplo: Usando um valor local de zone para logs de debug

Digamos que você tenha dois arquivos, foo.txt e bar.txt,
e queira imprimir todas as suas linhas.
O programa pode ser assim:

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
mas vamos assumir que você agora quer saber
de qual arquivo cada linha vem,
e que você não pode apenas adicionar um argumento de filename para `splitLinesStream()`.
Com valores locais de zone você pode adicionar o filename à string retornada
(novas linhas são destacadas):

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

Note que o novo código não modifica as assinaturas de função ou
passa o filename de `splitLines()` para `splitLinesStream()`.
Em vez disso, ele usa valores locais de zone para implementar
uma funcionalidade similar a uma variável estática
que funciona em contextos assíncronos.


## Substituindo funcionalidade

Use o argumento `zoneSpecification` de `runZoned()`
para substituir funcionalidade que é gerenciada por zones.
O valor do argumento é um
objeto [ZoneSpecification]({{site.dart-api}}/dart-async/ZoneSpecification-class.html),
com o qual você pode substituir qualquer uma das seguintes funcionalidades:

* Forking de zones filhas
* Registrando e executando callbacks na zone
* Agendando microtasks e timers
* Lidando com erros assíncronos não capturados
  (`runZonedGuarded()` é um atalho para isso)
* Imprimindo

### Exemplo: Substituindo print

Como um exemplo simples de substituição de funcionalidade,
aqui está uma maneira de silenciar todos os prints dentro de uma zone:

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

Dentro da zone bifurcada,
a função `print()` é substituída pelo interceptor print especificado,
que simplesmente descarta a mensagem.
Substituir print é possível porque `print()`
(como `scheduleMicrotask()` e os construtores Timer)
usa a zone atual (`Zone.current`) para fazer seu trabalho.


### Argumentos para interceptors e delegates

Como o exemplo de print mostra,
um interceptor adiciona três argumentos
aos definidos no método correspondente da classe Zone.
Por exemplo, o método `print()` de Zone tem um argumento:
`print(String line)`.
A versão interceptor de `print()`,
conforme definida por ZoneSpecification,
tem quatro argumentos:
`print(Zone self, ZoneDelegate parent, Zone zone, String line)`.

Os três argumentos de interceptor sempre aparecem na mesma ordem,
antes de quaisquer outros argumentos.

`self`
: A zone que está lidando com o callback.

`parent`
: Um ZoneDelegate representando a zone pai.
  Use-o para encaminhar operações para o pai.

`zone`
: A zone onde a operação se originou.
  Algumas operações precisam saber em qual zone a operação foi invocada.
  Por exemplo, `zone.fork(specification)` deve
  criar uma nova zone como filha de `zone`.
  Como outro exemplo,
  mesmo quando você delega `scheduleMicrotask()` para outra zone,
  a `zone` original deve ser a que executa a microtask.


Quando um interceptor delega um método ao pai,
a versão pai (ZoneDelegate) do método
tem apenas um argumento adicional:
`zone`, a zone de onde a chamada original se originou.
Por exemplo,
a assinatura do método `print()` em um ZoneDelegate é
`print(Zone zone, String line)`.

Aqui está um exemplo dos argumentos
para outro método interceptável, `scheduleMicrotask()`:

| **Onde definido** | **Assinatura do método** |
| Zone              | `void scheduleMicrotask(void f())` |
| ZoneSpecification&nbsp; | `void scheduleMicrotask(Zone self, ZoneDelegate parent, Zone zone, void f())` |
| ZoneDelegate      | `void scheduleMicrotask(Zone zone, void f())` |


### Exemplo: Delegando para a zone pai

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


### Exemplo: Executando código ao entrar e sair de uma zone

Digamos que você queira saber quanto tempo algum código assíncrono
gasta executando.
Você pode fazer isso colocando o código em uma zone,
iniciando um timer toda vez que a zone é entrada,
e parando o timer sempre que a zone é deixada.

Fornecer parâmetros `run*` para a ZoneSpecification
permite que você especifique o código que a zone executa.

:::note API note
No futuro, zones podem fornecer uma alternativa mais simples
para o caso comum de intercalar código de zone:
uma API onEnter/onLeave.
Veja [issue 17532]({{site.repo.dart.sdk}}/issues/17532)
para detalhes.
:::

Os parâmetros `run*`—`run`, `runUnary` e `runBinary`—especificam
código para executar toda vez que a zone é solicitada a executar código.
Esses parâmetros funcionam para callbacks de zero argumentos, um argumento
e dois argumentos, respectivamente.
O parâmetro `run` também funciona para o código síncrono inicial
que executa logo após chamar `runZoned()`.

Aqui está um exemplo de código de profiling usando `run*`:

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

Neste código,
cada substituição `run*` apenas inicia o timer do usuário,
executa a função especificada,
e então para o timer do usuário.


### Exemplo: Lidando com callbacks

Forneça parâmetros `register*Callback` para a ZoneSpecification
para envolver ou mudar código de callback—o código
que é executado assincronamente na zone.
Como os parâmetros `run*`,
os parâmetros `register*Callback` têm três formas:
`registerCallback` (para callbacks sem argumentos),
`registerUnaryCallback` (um argumento), e
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

Vá em frente e execute o exemplo.
Você verá um stack trace "last stack" (`lastStackTrace`)
que inclui `foo()`,
já que `foo()` foi chamado sincronamente.
O próximo stack trace (`stackTrace`)
é do contexto assíncrono,
que sabe sobre `bar()` mas não `foo()`.


### Implementando callbacks assíncronos

Mesmo se você estiver implementando uma API assíncrona,
você pode não ter que lidar com zones de forma alguma.
Por exemplo, embora você possa esperar que a biblioteca dart:io
mantenha rastreamento das zones atuais,
ela depende do tratamento de zone das classes dart:async
como Future e Stream.

Se você lidar com zones explicitamente,
então você precisa registrar todos os callbacks assíncronos
e garantir que cada callback seja invocado na zone
onde foi registrado.
Os métodos auxiliares `bind*Callback` de Zone
tornam essa tarefa mais fácil.
Eles são atalhos para `register*Callback` e `run*`,
garantindo que cada callback seja registrado e execute nessa Zone.

Se você precisar de mais controle do que `bind*Callback` te dá,
então você precisa usar `register*Callback` e `run*`.
Você também pode querer usar os métodos `run*Guarded` de Zone,
que envolvem a chamada em um try-catch
e invocam o `uncaughtErrorHandler`
se um erro ocorrer.


## Resumo

Zones são boas para proteger seu código de
exceções não capturadas em código assíncrono,
mas elas podem fazer muito mais.
Você pode associar dados com zones,
e você pode substituir funcionalidade central como
imprimir e agendamento de tarefas.
Zones habilitam melhor debugging e fornecem hooks
que você pode usar para funcionalidade como profiling.


### Mais recursos

Documentação de API relacionada a Zone
: Leia os docs para
  [runZoned()]({{site.dart-api}}/dart-async/runZoned.html),
  [runZonedGuarded()]({{site.dart-api}}/dart-async/runZonedGuarded.html),
  [Zone]({{site.dart-api}}/dart-async/Zone-class.html),
  [ZoneDelegate]({{site.dart-api}}/dart-async/ZoneDelegate-class.html), e
  [ZoneSpecification]({{site.dart-api}}/dart-async/ZoneSpecification-class.html).

stack_trace
: Com a [classe Chain]({{site.pub-api}}/stack_trace/latest/stack_trace/Chain-class.html)
  da biblioteca stack_trace
  você pode obter melhores stack traces para código executado assincronamente.
  Veja o [pacote stack_trace]({{site.pub-pkg}}/stack_trace)
  no site pub.dev para mais informações.


### Mais exemplos

Aqui estão alguns exemplos mais complexos de uso de zones.

O exemplo task_interceptor
: A zone de brinquedo em
  [task_interceptor.dart](https://github.com/dart-archive/www.dartlang.org/blob/master/src/tests/site/articles/zones/task_interceptor.dart)
  intercepta `scheduleMicrotask`, `createTimer` e `createPeriodicTimer`
  para simular o comportamento das primitivas Dart
  sem ceder para o event loop.

O código-fonte para o pacote stack_trace
: O [pacote stack_trace]({{site.pub-pkg}}/stack_trace)
  usa zones para formar cadeias de stack traces
  para debugging de código assíncrono.
  Funcionalidades de Zone usadas incluem tratamento de erros, valores locais de zone e callbacks.
  Você pode encontrar o código-fonte stack_trace no
  [projeto GitHub stack_trace]({{site.repo.dart.org}}/stack_trace).

O código-fonte para dart:async
: Essas duas bibliotecas SDK implementam APIs com callbacks assíncronos,
  e assim elas lidam com zones.
  Você pode navegar ou baixar seu código-fonte sob o
  [diretório sdk/lib]({{site.repo.dart.sdk}}/tree/main/sdk/lib)
  do
  [projeto GitHub Dart]({{site.repo.dart.sdk}}).


_Agradecimentos a Anders Johnsen e Lasse Reichstein Nielsen
por suas revisões deste artigo._
