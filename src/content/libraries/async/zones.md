---
ia-translate: true
title: Zonas
description: "Gerencie seu código assíncrono: lide com erros não capturados, substitua o comportamento (como impressão e agendamento de tarefas) e muito mais."
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

## Extensões Dinâmicas Assíncronas {:#asynchronous-dynamic-extents}

Este artigo discute APIs relacionadas a zonas na biblioteca [dart:async][],
com foco nas funções de nível superior [`runZoned()`][]
e [`runZonedGuarded()`][].
Revise as técnicas abordadas em
[Futures e Tratamento de Erros](/libraries/async/futures-error-handling)
antes de ler este artigo.

[dart:async]: ({{site.dart-api}}/dart-async/dart-async-library.html)
[`runZoned()`]: ({{site.dart-api}}/dart-async/runZoned.html)
[`runZonedGuarded()`]: ({{site.dart-api}}/dart-async/runZonedGuarded.html)

Zonas tornam as seguintes tarefas possíveis:

*   **Proteger seu aplicativo de sair devido a
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
    [!(error, stackTrace) => print('Oh não! $error $stackTrace'));!]
    ```

    Executar o servidor HTTP em uma zona
    permite que o aplicativo continue em execução apesar de erros
    não capturados (mas não fatais)
    no código assíncrono do servidor.

*   **Associar dados**—conhecidos como
    *valores locais de zona*—**com zonas individuais**.

*   **Substituir um conjunto limitado de métodos**,
    como `print()` e `scheduleMicrotask()`,
    dentro de parte ou todo o código.

*   **Executar uma operação cada vez que
    o código entra ou sai de uma zona**.
    Tais operações podem incluir
    iniciar ou parar um temporizador,
    ou salvar um stack trace (rastreamento de pilha).

Você pode ter encontrado algo semelhante a zonas em outras linguagens.
_Domains_ (domínios) em Node.js foram uma inspiração para as zonas do Dart.
O _armazenamento local de threads_ do Java
também tem algumas semelhanças.
O mais próximo de todos é o port JavaScript de zonas Dart de Brian Ford,
[zone.js](https://github.com/btford/zone.js/), que ele descreve neste
[vídeo]({{site.yt.watch}}?v=3IqtmUscE_U).

## Noções básicas de zona {:#zone-basics}

Uma _zona_ representa a extensão dinâmica assíncrona de uma chamada.
É a computação que é realizada como parte de uma chamada e, transitivamente,
os callbacks assíncronos que foram registrados por esse código.

Por exemplo,
no exemplo do servidor HTTP,
`bind()`, `then()` e o callback de `then()`
executam todos na mesma zona—a zona
que foi criada usando `runZoned()`.

No próximo exemplo,
o código é executado em 3 zonas diferentes:
<span class="zone1">zona #1</span> (a zona raiz),
<span class="zone2">zona #2</span> e
<span class="zone3">zona #3</span>.

<!-- ex1.dart -->
<!-- Usando pre em vez de prettify para que possamos usar cores de fundo -->
<pre>
import 'dart:async';

<span class="zone1">main() {
  foo();
  var future;
  runZoned(() {</span>          // Inicia uma nova zona filha (zona #2).
<span class="zone2">    future = new Future(bar).then(baz);
  </span><span class="zone1">});
  future.then(qux);
}</span>

foo() => <em><span class="zone1">...foo</span><span class="zone3">-body...</span></em>  // Executado duas vezes (uma vez em cada zona).
bar() => <em><span class="zone2">...bar-body...</span></em>
baz(x) => <span class="zone2">runZoned(() =></span> <span class="zone3">foo()</span><span class="zone2">);</span> // Nova zona filha (zona #3).
qux(x) => <em><span class="zone1">...qux-body...</span></em>
</pre>

A figura a seguir mostra a ordem de execução do código,
bem como em qual zona o código é executado.

![ilustração da execução do programa](/assets/img/articles/zones/trace.png)

Cada chamada para `runZoned()` cria uma nova zona
e executa o código nessa zona.
Quando esse código agenda uma tarefa—como
chamar baz()—essa
tarefa é executada na zona onde foi agendada.
Por exemplo, a chamada para qux() (última linha de main())
é executada em
<span class="zone1">zona #1</span> (a zona raiz)
mesmo que esteja anexada a um future que é executado em
<span class="zone2">zona #2</span>.

Zonas filhas não substituem completamente sua zona pai.
Em vez disso, novas zonas são aninhadas dentro de sua zona circundante.
Por exemplo,
<span class="zone2">zona #2</span> contém
<span class="zone3">zona #3</span>, e
<span class="zone1">zona #1</span> (a zona raiz)
contém ambos
<span class="zone2">zona #2</span> e
<span class="zone3">zona #3</span>.

Todo o código Dart é executado na zona raiz.
O código também pode ser executado em outras zonas filhas aninhadas,
mas, no mínimo, sempre é executado na zona raiz.


## Lidando com erros não capturados {:#handling-uncaught-errors}

Zonas são capazes de capturar e lidar com erros não capturados.

_Erros não capturados_ geralmente ocorrem devido ao código usar `throw`
para lançar uma exceção sem uma instrução `catch` acompanhante
para tratá-la.
Erros não capturados também podem surgir em funções `async`
quando um Future é concluído com um resultado de erro,
mas está faltando um `await` correspondente para lidar com o erro.

Um erro não capturado é reportado para a zona atual que não conseguiu capturá-lo.
Por padrão, as zonas irão travar o programa em resposta a erros não capturados.
Você pode instalar seu próprio _tratador de erros não capturados_ personalizado em uma nova zona
para interceptar e lidar com erros não capturados da maneira que preferir.

Para introduzir uma nova zona com um tratador de erros não capturados,
use o método `runZoneGuarded`. Seu callback `onError` se torna o
tratador de erros não capturados de uma nova zona. Este callback lida com quaisquer
erros síncronos que a chamada lança.

<!-- run_zoned1.dart -->
```dart
runZonedGuarded(() {
  Timer.run(() { throw 'Normalmente mataria o programa'; });
}, (error, stackTrace) {
  print('Erro não capturado: $error');
});
```

_Outras APIs de zona que facilitam o tratamento de erros não capturados incluem
[`Zone.fork`][], [`Zone.runGuarded`][]
e [`ZoneSpecification.uncaughtErrorHandler`][]._

[`Zone.fork`]:  {{site.dart-api}}/dart-async/Zone/fork.html
[`Zone.runGuarded`]:  {{site.dart-api}}/dart-async/Zone/runGuarded.html
[`ZoneSpecification.uncaughtErrorHandler`]:  {{site.dart-api}}/dart-async/ZoneSpecification/handleUncaughtError.html

O código anterior tem um callback assíncrono
(através de `Timer.run()`) que lança uma exceção.
Normalmente, essa exceção seria um erro não tratado e atingiria o nível superior
(o que, no executável Dart independente, mataria o processo em execução).
No entanto, com o tratador de erros em zonas,
o erro é passado para o tratador de erros e não desliga o programa.

Uma diferença notável entre try-catch e tratadores de erros em zonas é
que as zonas continuam a ser executadas após a ocorrência de erros não capturados.
Se outros callbacks assíncronos forem agendados dentro da zona,
eles ainda serão executados.
Como consequência, um tratador de erros em zonas pode
ser invocado várias vezes.

Qualquer zona com um tratador de erros não capturados é chamada de _zona de erro_.
Uma zona de erro pode lidar com erros que se originam
em um descendente dessa zona.
Uma regra simples determina onde
os erros são tratados em uma sequência de transformações futuras
(usando `then()` ou `catchError()`):
Erros em cadeias Future nunca cruzam os limites de zonas de erro.

Se um erro atinge um limite de zona de erro,
ele é tratado como erro não tratado naquele ponto.

:::note API note
Lidar com erros não capturados não *requer* zonas.
A API de isolamento [`Isolate.run()`][] também lida com
a escuta de erros não capturados.
:::

[`Isolate.run()`]: {{site.dart-api}}/dev/dart-isolate/Isolate/run.html

### Exemplo: Erros não podem cruzar para zonas de erro {:#example-errors-can-t-cross-into-error-zones}

No exemplo a seguir,
o erro gerado pela primeira linha
não pode cruzar para uma zona de erro.

<!-- run_zoned2.dart -->
```dart
var f = new Future.error(499);
f = f.whenComplete(() { print('Fora das zonas'); });
runZoned(() {
  f = f.whenComplete(() { print('Dentro da zona sem erro'); });
});
runZonedGuarded(() {
  f = f.whenComplete(() { print('Dentro da zona de erro (não chamada)'); });
}, (error) { print(error); });
```

Aqui está a saída que você vê se executar o exemplo:

```plaintext
Fora das zonas
Dentro da zona sem erro
Erro não capturado: 499
Exceção não tratada:
499
...stack trace...
```

Se você remover a chamada para `runZoned()` ou
para `runZonedGuarded()`,
você vê esta saída:

```plaintext
Fora das zonas
Dentro da zona sem erro
[!Dentro da zona de erro (não chamada)!]
Erro não capturado: 499
Exceção não tratada:
499
...stack trace...
```

Observe como a remoção da zona ou da zona de erro faz com que
o erro se propague mais.

O stack trace aparece porque o erro acontece fora de uma zona de erro.
Se você adicionar uma zona de erro em torno de todo o trecho de código,
então você pode evitar o stack trace.


### Exemplo: Erros não podem sair de zonas de erro {:#example-errors-can-t-leave-error-zones}

Como o código anterior mostra,
erros não podem cruzar para zonas de erro.
Da mesma forma, erros não podem cruzar *para fora* de zonas de erro.
Considere este exemplo:

<!-- run_zoned3.dart -->
```dart
var completer = new Completer();
var future = completer.future.then((x) => x + 1);
var zoneFuture;
runZonedGuarded(() {
  zoneFuture = future.then((y) => throw 'Dentro da zona');
}, (error) { print('Capturado: $error'); });

zoneFuture.catchError((e) { print('Nunca alcançado'); });
completer.complete(499);
```

Mesmo que a cadeia future termine em um `catchError()`,
o erro assíncrono não pode sair da zona de erro.
O tratador de erros em zonas encontrado em `runZonedGuarded()`
lida com o erro.
Como resultado, *zoneFuture nunca é concluído* — nem
com um valor, nem com um erro.

## Usando zonas com streams {:#using-zones-with-streams}

A regra para zonas e streams
é mais simples do que para futures:

:::note
Transformações e outros callbacks são executados na zona
onde o stream é escutado.
:::

Essa regra segue da diretriz de que
streams não devem ter efeito colateral até serem escutados.
Uma situação semelhante em código síncrono é o comportamento de Iterables,
que não são avaliados até você pedir por valores.

### Exemplo: Usando um stream com `runZonedGuarded()` {:#example-using-a-stream-with-runzonedguarded}

O exemplo a seguir configura um stream com um callback,
e então executa esse stream em uma nova zona com `runZonedGuarded()`:

<!-- stream.dart -->
```dart
var stream = new File('stream.dart').openRead()
    .map((x) => throw 'Callback lança um erro');

runZonedGuarded(() { stream.listen(print); },
         (e) { print('Erro capturado: $e'); });
```

O tratador de erros em `runZonedGuarded()`
captura o erro que o callback lança.
Aqui está a saída:

```plaintext
Erro capturado: Callback lança um erro
```

Como a saída mostra,
o callback está associado à zona de escuta,
não com a zona onde `map()` é chamado.


## Armazenando valores locais de zona {:#storing-zone-local-values}

Se você já quis usar uma variável estática
mas não conseguiu porque
várias computações em execução simultânea interferiam umas nas outras,
considere usar um valor local de zona.
Você pode adicionar um valor local de zona para ajudar na depuração.
Outro caso de uso é lidar com uma requisição HTTP:
você pode ter o ID do usuário
e seu token de autorização em valores locais de zona.

Use o argumento `zoneValues` para `runZoned()` para
armazenar valores na zona recém-criada:

<!-- value1.dart -->
```dart
runZoned(() {
  print(Zone.current[#key]);
}, zoneValues: { #key: 499 });
```

Para ler valores locais de zona, use o operador de índice da zona e a chave do valor:
<code>[<em>key</em>]</code>.
Qualquer objeto pode ser usado como chave, desde que tenha implementações
`operator ==` e `hashCode` compatíveis.
Normalmente, uma chave é um literal de símbolo:
<code>#<em>identifier</em></code>.

Você não pode alterar o objeto para o qual uma chave mapeia,
mas você pode manipular o objeto.
Por exemplo, o código a seguir
adiciona um item a uma lista local de zona:

<!-- value1_1.dart -->
```dart
runZoned(() {
  Zone.current[#key].add(499);
  print(Zone.current[#key]); // [499]
}, zoneValues: { #key: [] });
```

Uma zona herda valores locais de zona de sua zona pai,
portanto, adicionar zonas aninhadas não descarta acidentalmente valores existentes.
Zonas aninhadas podem, no entanto, sombrear valores pai.

:::important
Tente usar objetos únicos para chaves,
para que seja menos provável que entrem em conflito com outras bibliotecas.
:::


### Exemplo: Usando um valor local de zona para logs de depuração {:#example-using-a-zone-local-value-for-debug-logs}

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
mas vamos supor que agora você queira saber
de qual arquivo cada linha vem,
e que você não pode apenas adicionar um argumento de nome de arquivo para `splitLinesStream()`.
Com valores locais de zona, você pode adicionar o nome do arquivo à string retornada
(as novas linhas são destacadas):

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

Observe que o novo código não modifica as assinaturas de função ou
passa o nome do arquivo de `splitLines()` para `splitLinesStream()`.
Em vez disso, ele usa valores locais de zona para implementar
um recurso semelhante a uma variável estática
que funciona em contextos assíncronos.


## Substituindo a funcionalidade {:#overriding-functionality}

Use o argumento `zoneSpecification` para `runZoned()`
para substituir a funcionalidade que é gerenciada por zonas.
O valor do argumento é um objeto
[ZoneSpecification]({{site.dart-api}}/dart-async/ZoneSpecification-class.html),
com o qual você pode substituir qualquer uma das seguintes funcionalidades:

*   Criar zonas filhas
*   Registrar e executar callbacks na zona
*   Agendamento de microtasks e temporizadores
*   Lidar com erros assíncronos não capturados
    (`runZonedGuarded()` é um atalho para isso)
*   Impressão

### Exemplo: Substituindo a impressão {:#example-overriding-print}

Como um exemplo simples de substituição de funcionalidade,
aqui está uma maneira de silenciar todas as impressões dentro de uma zona:

<!-- specification1.dart -->
```dart
import 'dart:async';

main() {
  runZoned(() {
    print('Será ignorado');
  }, zoneSpecification: new ZoneSpecification(
    print: (self, parent, zone, message) {
      // Ignorar mensagem.
    }));
}
```

Dentro da zona bifurcada,
a função `print()` é substituída pelo interceptador de impressão especificado,
que simplesmente descarta a mensagem.
Substituir a impressão é possível porque `print()`
(como `scheduleMicrotask()` e os construtores Timer)
usa a zona atual (`Zone.current`) para fazer seu trabalho.


### Argumentos para interceptadores e delegados {:#arguments-to-interceptors-and-delegates}

Como o exemplo de impressão mostra,
um interceptador adiciona três argumentos
àqueles definidos no método correspondente da classe Zone.
Por exemplo, o método `print()` de Zone tem um argumento:
`print(String line)`.
A versão interceptadora de `print()`,
como definido por ZoneSpecification,
tem quatro argumentos:
`print(Zone self, ZoneDelegate parent, Zone zone, String line)`.

Os três argumentos do interceptador sempre aparecem na mesma ordem,
antes de quaisquer outros argumentos.

`self`
: A zona que está lidando com o callback.

`parent`
: Um ZoneDelegate representando a zona pai.
  Use-o para encaminhar operações para o pai.

`zone`
: A zona onde a operação se originou.
  Algumas operações precisam saber em qual zona a operação foi invocada.
  Por exemplo, `zone.fork(specification)` deve
  criar uma nova zona como filha de `zone`.
  Como outro exemplo,
  mesmo quando você delega `scheduleMicrotask()` para outra zona,
  a `zone` original deve ser aquela que executa a microtask.


Quando um interceptador delega um método para o pai,
a versão pai (ZoneDelegate) do método
tem apenas um argumento adicional:
`zone`, a zona onde a chamada original se originou.
Por exemplo,
a assinatura do método `print()` em um ZoneDelegate é
`print(Zone zone, String line)`.

Aqui está um exemplo dos argumentos
para outro método interceptável, `scheduleMicrotask()`:

| **Onde definido** | **Assinatura do método** |
| Zone              | `void scheduleMicrotask(void f())` |
| ZoneSpecification&nbsp; | `void scheduleMicrotask(Zone self, ZoneDelegate parent, Zone zone, void f())` |
| ZoneDelegate      | `void scheduleMicrotask(Zone zone, void f())` |


### Exemplo: Delegando para a zona pai {:#example-delegating-to-the-parent-zone}

Aqui está um exemplo que mostra como delegar para a zona pai:

<!-- specification2.dart -->
```dart
import 'dart:async';

main() {
  runZoned(() {
    var currentZone = Zone.current;
    scheduleMicrotask(() {
      print(identical(currentZone, Zone.current));  // imprime true.
    });
  }, zoneSpecification: new ZoneSpecification(
    scheduleMicrotask: (self, parent, zone, task) {
      print('scheduleMicrotask foi chamado dentro da zona');
      // A `zone` de origem precisa ser passada para o pai para que
      // a tarefa possa ser executada nela.
      parent.scheduleMicrotask(zone, task);
    }));
}
```


### Exemplo: Executando código ao entrar e sair de uma zona {:#example-executing-code-when-entering-and-leaving-a-zone}

Digamos que você queira saber quanto tempo algum código assíncrono
gasta executando.
Você pode fazer isso colocando o código em uma zona,
iniciando um temporizador cada vez que a zona é entrada,
e parando o temporizador sempre que a zona é deixada.

Fornecer parâmetros `run*` para ZoneSpecification
permite que você especifique o código que a zona executa.

:::note API note
No futuro, as zonas podem fornecer uma alternativa mais simples
para o caso comum de intercalar código de zona:
uma API onEnter/onLeave.
Veja [issue 17532]({{site.repo.dart.sdk}}/issues/17532)
para detalhes.
:::

Os parâmetros `run*`—`run`, `runUnary` e `runBinary`—especificam
o código a ser executado toda vez que a zona é solicitada a executar o código.
Esses parâmetros funcionam para callbacks de zero argumento, um argumento
e dois argumentos, respectivamente.
O parâmetro `run` também funciona para o código síncrono inicial,
que é executado logo após chamar `runZoned()`.

Aqui está um exemplo de código de perfil usando `run*`:

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
  // ... Código que é executado de forma síncrona...
  // ... Então o código que é executado de forma assíncrona ...
    .then((...) {
      print(total.elapsedMilliseconds);
      print(user.elapsedMilliseconds);
    });
}, zoneSpecification: specification);
```

Neste código,
cada substituição de `run*` apenas inicia o temporizador do usuário,
executa a função especificada
e então para o temporizador do usuário.


### Exemplo: Lidando com callbacks {:#example-handling-callbacks}

Forneça os parâmetros `register*Callback` para ZoneSpecification
para envolver ou alterar o código de callback—o código
que é executado de forma assíncrona na zona.
Como os parâmetros `run*`,
os parâmetros `register*Callback` têm três formas:
`registerCallback` (para callbacks sem argumentos),
`registerUnaryCallback` (um argumento) e
`registerBinaryCallback` (dois argumentos).

Aqui está um exemplo que faz a zona
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

bar() => throw "em bar";
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
      if (lastStackTrace != null) print("última pilha: $lastStackTrace");
      return parent.handleUncaughtError(zone, error, stackTrace);
    });

  runZoned(() {
    foo();
  }, zoneSpecification: specification);
}
```

Vá em frente e execute o exemplo.
Você verá um rastreamento de "última pilha" (`lastStackTrace`)
que inclui `foo()`,
já que `foo()` foi chamado de forma síncrona.
O próximo stack trace (`stackTrace`)
é do contexto assíncrono,
que sabe sobre `bar()` mas não `foo()`.


### Implementando callbacks assíncronos {:#implementing-asynchronous-callbacks}

Mesmo se você estiver implementando uma API assíncrona,
você pode não ter que lidar com zonas.
Por exemplo, embora você possa esperar que a biblioteca dart:io
rastreie as zonas atuais,
ela, em vez disso, confia no tratamento de zonas de classes dart:async
como Future e Stream.

Se você lidar com zonas explicitamente,
então você precisa registrar todos os callbacks assíncronos
e garantir que cada callback seja invocado na zona
onde foi registrado.
Os métodos auxiliares `bind*Callback` de Zone
tornam esta tarefa mais fácil.
Eles são atalhos para `register*Callback` e `run*`,
garantindo que cada callback seja registrado e executado nessa Zona.

Se você precisar de mais controle do que `bind*Callback` oferece,
então você precisa usar `register*Callback` e `run*`.
Você também pode querer usar os métodos `run*Guarded` de Zone,
que envolvem a chamada em um try-catch
e invocam o `uncaughtErrorHandler`
se ocorrer um erro.


## Resumo {:#summary}

Zonas são boas para proteger seu código contra
exceções não capturadas em código assíncrono,
mas elas podem fazer muito mais.
Você pode associar dados a zonas,
e você pode substituir funcionalidades essenciais, como
impressão e agendamento de tarefas.
Zonas permitem uma melhor depuração e fornecem hooks
que você pode usar para funcionalidades como o perfil.


### Mais recursos {:#more-resources}

Documentação da API relacionada a zonas
: Leia a documentação para
  [runZoned()]({{site.dart-api}}/dart-async/runZoned.html),
  [runZonedGuarded()]({{site.dart-api}}/dart-async/runZonedGuarded.html),
  [Zone]({{site.dart-api}}/dart-async/Zone-class.html),
  [ZoneDelegate]({{site.dart-api}}/dart-async/ZoneDelegate-class.html), e
  [ZoneSpecification]({{site.dart-api}}/dart-async/ZoneSpecification-class.html).

stack_trace
: Com a biblioteca stack_trace's
  [Classe Chain]({{site.pub-api}}/stack_trace/latest/stack_trace/Chain-class.html)
  você pode obter melhores stack traces para código executado de forma assíncrona.
  Veja o [pacote stack_trace]({{site.pub-pkg}}/stack_trace)
  no site pub.dev para mais informações.


### Mais exemplos {:#more-examples}

Aqui estão alguns exemplos mais complexos de uso de zonas.

O exemplo task_interceptor
: A zona de brinquedo em
  [task_interceptor.dart](https://github.com/dart-archive/www.dartlang.org/blob/master/src/tests/site/articles/zones/task_interceptor.dart)
  intercepta `scheduleMicrotask`, `createTimer` e `createPeriodicTimer`
  para simular o comportamento dos primitivos Dart
  sem ceder ao loop de eventos.

O código-fonte do pacote stack_trace
: O [pacote stack_trace]({{site.pub-pkg}}/stack_trace)
  usa zonas para formar cadeias de stack traces
  para depurar código assíncrono.
  Os recursos de zona usados incluem tratamento de erros, valores locais de zona e callbacks.
  Você pode encontrar o código-fonte do stack_trace no
  [projeto stack_trace no GitHub]({{site.repo.dart.org}}/stack_trace).

The source code for dart:async
: These two SDK libraries implement APIs featuring asynchronous callbacks,
  and thus they deal with zones.
  You can browse or download their source code under the
  [sdk/lib directory]({{site.repo.dart.sdk}}/tree/main/sdk/lib)
  of the
  [Dart GitHub project]({{site.repo.dart.sdk}}).


_Obrigado a Anders Johnsen e Lasse Reichstein Nielsen
pelas suas revisões deste artigo._
