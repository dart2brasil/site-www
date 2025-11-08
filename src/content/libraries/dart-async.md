---
ia-translate: true
title: dart:async
description: Saiba mais sobre os principais recursos na biblioteca dart:async do Dart.
prevpage:
  url: /libraries/dart-core
  title: dart:core
nextpage:
  url: /libraries/dart-math
  title: dart:math
---

<?code-excerpt replace="/ *\/\/\s+ignore_for_file:[^\n]+\n//g; /(^|\n) *\/\/\s+ignore:[^\n]+\n/$1/g; /(\n[^\n]+) *\/\/\s+ignore:[^\n]+\n/$1\n/g"?>
<?code-excerpt plaster="none"?>

A programação assíncrona geralmente usa funções de *callback*, mas o
Dart oferece alternativas: objetos [Future][Future] (Futuro) e [Stream][Stream] (Fluxo). Um
Future é como uma promessa de que um resultado será fornecido em algum momento no
futuro. Um Stream é uma forma de obter uma sequência de valores, como eventos.
Future, Stream e mais estão na biblioteca
dart:async ([referência da API][dart:async]).

:::note
Você nem sempre precisa usar as APIs Future ou Stream diretamente.
A linguagem Dart oferece suporte à codificação assíncrona usando
palavras-chave como `async` e `await`.
Confira o [tutorial de programação assíncrona](/libraries/async/async-await)
para detalhes.
:::

A biblioteca dart:async funciona tanto em aplicativos da web quanto em
aplicativos de linha de comando. Para usá-la, importe dart:async:

<?code-excerpt "misc/lib/library_tour/async/future.dart (import)"?>
```dart
import 'dart:async';
```

:::tip
Você não precisa importar dart:async para usar as APIs Future e
Stream, porque dart:core exporta essas classes.
:::

## Future {:#future}

Objetos Future aparecem em todas as bibliotecas Dart, muitas vezes como o objeto
retornado por um método assíncrono. Quando um future *completa*, seu valor
está pronto para uso.


### Usando await {:#using-await}

Antes de usar diretamente a API Future, considere usar `await` (aguardar) em vez disso.
O código que usa expressões `await` pode ser mais fácil de entender
do que o código que usa a API Future.

Considere a seguinte função. Ela usa o método `then()` (então) do Future
para executar três funções assíncronas em sequência,
esperando que cada uma termine antes de executar a próxima.

<?code-excerpt "misc/lib/library_tour/async/future.dart (run-using-future)"?>
```dart
void runUsingFuture() {
  // ...
  findEntryPoint()
      .then((entryPoint) {
        return runExecutable(entryPoint, args);
      })
      .then(flushThenExit);
}
```

O código equivalente com expressões await
se parece mais com código síncrono:

<?code-excerpt "misc/lib/library_tour/async/future.dart (run-using-async-await)"?>
```dart
Future<void> runUsingAsyncAwait() async {
  // ...
  var entryPoint = await findEntryPoint();
  var exitCode = await runExecutable(entryPoint, args);
  await flushThenExit(exitCode);
}
```

Uma função `async` (assíncrona) pode capturar exceções de Futures.
Por exemplo:

<?code-excerpt "misc/lib/library_tour/async/future.dart (catch)"?>
```dart
var entryPoint = await findEntryPoint();
try {
  var exitCode = await runExecutable(entryPoint, args);
  await flushThenExit(exitCode);
} catch (e) {
  // Handle the error...
}
```

:::important
Funções Async retornam Futures. Se você não quer que sua função retorne um
future, então use uma solução diferente. Por exemplo, você pode chamar uma função `async`
a partir da sua função.
:::

Para obter mais informações sobre como usar `await` e recursos de linguagem Dart relacionados,
consulte o [tutorial de programação assíncrona](/libraries/async/async-await).


### Uso básico {:#basic-usage}

Você pode usar `then()` para agendar código que é executado quando o future completa. Por
exemplo, [`Client.read()`][`Client.read()`] retorna um Future, já que as requisições HTTP
podem demorar um pouco. Usar `then()` permite que você execute algum código quando esse Future
foi concluído e o valor de string prometido está disponível:

<?code-excerpt "misc/lib/library_tour/async/basic.dart (then)"?>
```dart
httpClient.read(url).then((String result) {
  print(result);
});
```

Use `catchError()` (capturarErro) para tratar quaisquer erros ou exceções que um objeto Future
possa lançar.

<?code-excerpt "misc/lib/library_tour/async/basic.dart (catch-error)"?>
```dart
httpClient
    .read(url)
    .then((String result) {
      print(result);
    })
    .catchError((e) {
      // Handle or ignore the error.
    });
```

O padrão `then().catchError()` é a versão assíncrona de
`try`-`catch`.

:::important
Certifique-se de invocar `catchError()` no resultado de `then()`—e não no
resultado do `Future` original. Caso contrário, o
`catchError()` pode lidar com erros apenas do cálculo do Future original,
mas não do manipulador registrado por `then()`.
:::

[`Client.read()`]: {{site.pub-api}}/http/latest/http/Client/read.html

### Encadeando múltiplos métodos assíncronos {:#chaining-multiple-asynchronous-methods}

O método `then()` retorna um Future, fornecendo uma maneira útil de executar
várias funções assíncronas em uma determinada ordem.
Se o *callback* registrado com `then()` retornar um Future,
`then()` retorna um Future que será concluído
com o mesmo resultado do Future retornado pelo *callback*.
Se o *callback* retornar um valor de qualquer outro tipo,
`then()` cria um novo Future que é concluído com o valor.

<?code-excerpt "misc/lib/library_tour/async/future.dart (then-chain)"?>
```dart
Future result = costlyQuery(url);
result
    .then((value) => expensiveWork(value))
    .then((_) => lengthyComputation())
    .then((_) => print('Done!'))
    .catchError((exception) {
      /* Handle exception... */
    });
```

No exemplo anterior, os métodos são executados na seguinte ordem:

1.  `costlyQuery()`
2.  `expensiveWork()`
3.  `lengthyComputation()`

Aqui está o mesmo código escrito usando await:

<?code-excerpt "misc/lib/library_tour/async/future.dart (then-chain-as-await)"?>
```dart
try {
  final value = await costlyQuery(url);
  await expensiveWork(value);
  await lengthyComputation();
  print('Done!');
} catch (e) {
  /* Handle exception... */
}
```


### Esperando por múltiplos futures {:#waiting-for-multiple-futures}

Às vezes, seu algoritmo precisa invocar muitas funções assíncronas e
esperar que todas sejam concluídas antes de continuar. Use o método estático [Future.wait()][Future.wait()]
para gerenciar múltiplos Futures e esperar que eles sejam concluídos:

<?code-excerpt "misc/lib/library_tour/async/future.dart (wait)" replace="/elideBody;/\/* ... *\//g"?>
```dart
Future<void> deleteLotsOfFiles() async =>  ...
Future<void> copyLotsOfFiles() async =>  ...
Future<void> checksumLotsOfOtherFiles() async =>  ...

await Future.wait([
  deleteLotsOfFiles(),
  copyLotsOfFiles(),
  checksumLotsOfOtherFiles(),
]);
print('Done with all the long steps!');
```

`Future.wait()` retorna um future que é concluído quando todos os futures fornecidos
foram concluídos. Ele é concluído com seus resultados,
ou com um erro se algum dos futures fornecidos falhar.

### Tratando erros para múltiplos futures {:#handling-errors-for-multiple-futures}

You can also wait for parallel operations on:

* An [iterable][iterable-futures] of futures
* A [record][record-futures] with futures as positional fields

These extensions return a `Future` with the
resulting values of all provided futures.
Unlike `Future.wait`, they also let you handle errors.

If any future in the collection completes with an error,
`wait` completes with a [`ParallelWaitError`][].
This allows the caller to handle individual errors and
dispose of successful results if necessary.

When you _don't_ need the result values from each future,
use `wait` on an _iterable_ of futures:

```dart
Future<int> delete() async => ...;
Future<String> copy() async => ...;
Future<bool> errorResult() async => ...;

void main() async {
  try {
    // Espera por cada future em uma lista, retorna uma lista de futures:
    var results = await [delete(), copy(), errorResult()].wait;
  } on ParallelWaitError<List<bool?>, List<AsyncError?>> catch (e) {
    print(e.values[0]);    // Prints successful future
    print(e.values[1]);    // Prints successful future
    print(e.values[2]);    // Prints null when the result is an error

    print(e.errors[0]);    // Imprime nulo quando o resultado é bem-sucedido
    print(e.errors[1]);    // Imprime nulo quando o resultado é bem-sucedido
    print(e.errors[2]);    // Imprime erro
  }
}
```

Quando você _precisa_ dos valores de resultado individuais de cada future,
use `wait` em um _registro_ de futures.
Isso fornece o benefício adicional de que os futures podem ser de tipos diferentes:

```dart
Future<int> delete() async => ...;
Future<String> copy() async => ...;
Future<bool> errorResult() async => ...;

void main() async {
  try {
    // Wait for each future in a record.
    // Returns a record of futures that you can destructure.
    final (deleteInt, copyString, errorBool) =
        await (delete(), copy(), errorResult()).wait;

    // Do something with the results...
  } on ParallelWaitError<
    (int?, String?, bool?),
    (AsyncError?, AsyncError?, AsyncError?)
  > catch (e) {
    // ...
  }
}
```

[iterable-futures]: {{site.dart-api}}/dart-async/FutureIterable/wait.html
[record-futures]: {{site.dart-api}}/dart-async/FutureRecord2/wait.html

## Stream

Objetos Stream aparecem em todas as APIs Dart, representando sequências de
dados. Por exemplo, eventos HTML, como cliques de botão, são entregues usando
streams. Você também pode ler um arquivo como um stream.


### Usando um laço *for* assíncrono {:#using-an-asynchronous-for-loop}

Às vezes, você pode usar um laço *for* assíncrono (`await for`)
em vez de usar a API Stream.

Considere a seguinte função.
Ela usa o método `listen()` (escutar) do Stream
para se inscrever em uma lista de arquivos,
passando um *literal* de função que pesquisa cada arquivo ou diretório.

<?code-excerpt "misc/lib/library_tour/async/stream.dart (listen)" replace="/listen/[!$&!]/g"?>
```dart
void main(List<String> arguments) {
  // ...
  FileSystemEntity.isDirectory(searchPath).then((isDir) {
    if (isDir) {
      final startingDir = Directory(searchPath);
      startingDir.list().[!listen!]((entity) {
        if (entity is File) {
          searchFile(entity, searchTerms);
        }
      });
    } else {
      searchFile(File(searchPath), searchTerms);
    }
  });
}
```

O código equivalente com expressões await,
incluindo um laço *for* assíncrono (`await for`),
se parece mais com código síncrono:

<?code-excerpt "misc/lib/library_tour/async/stream.dart (await-for)" replace="/await for/[!$&!]/g"?>
```dart
void main(List<String> arguments) async {
  // ...
  if (await FileSystemEntity.isDirectory(searchPath)) {
    final startingDir = Directory(searchPath);
    [!await for!] (final entity in startingDir.list()) {
      if (entity is File) {
        searchFile(entity, searchTerms);
      }
    }
  } else {
    searchFile(File(searchPath), searchTerms);
  }
}
```

:::important
Antes de usar `await for`, certifique-se de que isso torna o código mais claro e de que
você realmente deseja esperar por todos os resultados do stream. Por exemplo, você
geralmente **não** deve usar `await for` para *listeners* de eventos DOM, porque o
DOM envia streams infinitos de eventos. Se você usar `await for` para registrar dois
*listeners* de eventos DOM em sequência, o segundo tipo de evento nunca será tratado.
:::

Para obter mais informações sobre como usar `await` e recursos de linguagem Dart relacionados,
consulte o
[tutorial de programação assíncrona](/libraries/async/async-await).


### Escutando dados de stream {:#listening-for-stream-data}

Para obter cada valor à medida que ele chega, use `await for` ou
inscreva-se no stream usando o método `listen()`:

<?code-excerpt "misc/lib/library_tour/async/stream_web.dart (listen)" replace="/listen/[!$&!]/g"?>
```dart
// Add an event handler to a button.
submitButton.onClick.[!listen!]((e) {
  // When the button is clicked, it runs this code.
  submitData();
});
```

Neste exemplo, a propriedade `onClick` é um objeto `Stream` fornecido
pelo botão de envio.

Se você se preocupa com apenas um evento, pode obtê-lo usando uma propriedade
como `first`, `last` ou `single`. Para testar o evento antes de tratá-lo,
use um método como `firstWhere()`, `lastWhere()` ou `singleWhere()`.
{% comment %}
{PENDING: example}
{% endcomment %}

Se você se preocupa com um subconjunto de eventos, pode usar métodos como
`skip()`, `skipWhile()`, `take()`, `takeWhile()` e `where()`.
{% comment %}
{PENDING: example}
{% endcomment %}


### Transformando dados de stream {:#transforming-stream-data}

Muitas vezes, você precisa alterar o formato dos dados de um stream antes de
usá-los. Use o método `transform()` para produzir um stream com um
tipo diferente de dados:

<?code-excerpt "misc/lib/library_tour/async/stream.dart (transform)"?>
```dart
var lines = inputStream
    .transform(utf8.decoder)
    .transform(const LineSplitter());
```

Este exemplo usa dois transformadores. Primeiro, ele usa utf8.decoder para
transformar o stream de inteiros em um stream de strings. Em seguida, ele usa
um LineSplitter para transformar o stream de strings em um stream de
linhas separadas. Esses transformadores são da biblioteca dart:convert (consulte a
[seção dart:convert](/libraries/dart-convert)).
{% comment %}
  PENDING: add onDone and onError. (See "Streaming file contents".)
{% endcomment %}


### Tratando erros e conclusão {:#handling-errors-and-completion}

Como você especifica o código de tratamento de erros e conclusão
depende se você usa um laço *for* assíncrono (`await for`)
ou a API Stream.

Se você usa um laço *for* assíncrono,
use try-catch para lidar com erros.
O código que é executado após o fechamento do stream
vai depois do laço *for* assíncrono.

<?code-excerpt "misc/lib/library_tour/async/stream.dart (read-file-await-for)" replace="/try|catch/[!$&!]/g"?>
```dart
Future<void> readFileAwaitFor() async {
  var config = File('config.txt');
  Stream<List<int>> inputStream = config.openRead();

  var lines = inputStream
      .transform(utf8.decoder)
      .transform(const LineSplitter());
  [!try!] {
    await for (final line in lines) {
      print('Got ${line.length} characters from stream');
    }
    print('file is now closed');
  } [!catch!] (e) {
    print(e);
  }
}
```

Se você usar a API Stream,
trate os erros registrando um *listener* `onError`.
Execute o código depois que o stream for fechado registrando
um *listener* `onDone`.

<?code-excerpt "misc/lib/library_tour/async/stream.dart (on-done)" replace="/onDone|onError/[!$&!]/g"?>
```dart
var config = File('config.txt');
Stream<List<int>> inputStream = config.openRead();

inputStream
    .transform(utf8.decoder)
    .transform(const LineSplitter())
    .listen(
      (String line) {
        print('Got ${line.length} characters from stream');
      },
      [!onDone!]: () {
        print('file is now closed');
      },
      [!onError!]: (e) {
        print(e);
      },
    );
```


## Mais informações {:#more-information}

Para alguns exemplos de uso de Future e Stream em aplicativos de linha de comando,
confira a [documentação dart:io][dart:io documentation].
Veja também estes artigos e tutoriais:

- [Programação assíncrona: futures, async, await](/libraries/async/async-await)
- [Futures e tratamento de erros](/libraries/async/futures-error-handling)
- [Programação assíncrona: streams](/libraries/async/using-streams)
- [Criando streams no Dart](/libraries/async/creating-streams)
- [Programação assíncrona em Dart: Isolates e loops de eventos](/language/concurrency)


[Future.wait()]: {{site.dart-api}}/dart-async/Future/wait.html
[Future]: {{site.dart-api}}/dart-async/Future-class.html
[`ParallelWaitError`]: {{site.dart-api}}/dart-async/ParallelWaitError-class.html
[Stream]: {{site.dart-api}}/dart-async/Stream-class.html
[dart:async]: {{site.dart-api}}/dart-async/dart-async-library.html
[dart:io documentation]: /libraries/dart-io
