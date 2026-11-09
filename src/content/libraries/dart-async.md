---
ia-translate: true
title: dart:async
description: Aprenda sobre os principais recursos da biblioteca dart:async do Dart.
prevpage:
  url: /libraries/dart-core
  title: dart:core
nextpage:
  url: /libraries/dart-math
  title: dart:math
---

<?code-excerpt replace="/ *\/\/\s+ignore_for_file:[^\n]+\n//g; /(^|\n) *\/\/\s+ignore:[^\n]+\n/$1/g; /(\n[^\n]+) *\/\/\s+ignore:[^\n]+\n/$1\n/g"?>
<?code-excerpt plaster="none"?>

A programação assíncrona frequentemente usa funções de callback, mas o Dart
oferece alternativas: os objetos [Future][] e [Stream][]. Um
Future é como uma promessa de um resultado que será fornecido em algum momento no
futuro. Um Stream é uma forma de obter uma sequência de valores, como eventos.
Future, Stream e outros estão na
biblioteca dart:async ([referência da API][dart:async]).

:::note
Você nem sempre precisa usar as APIs de Future ou Stream diretamente.
A linguagem Dart oferece suporte à programação assíncrona com
palavras-chave como `async` e `await`.
Confira o [tutorial de programação assíncrona](/libraries/async/async-await)
para mais detalhes.
:::

A biblioteca dart:async funciona tanto em aplicativos web quanto em aplicativos de linha de comando. Para
usá-la, importe dart:async:

<?code-excerpt "misc/lib/library_tour/async/future.dart (import)"?>
```dart
import 'dart:async';
```

:::tip
Você não precisa importar dart:async para usar as APIs de Future e
Stream, porque dart:core exporta essas classes.
:::

## Future {:#future}

Objetos Future aparecem em toda a biblioteca do Dart, frequentemente como o objeto
retornado por um método assíncrono. Quando um future *completa*, o valor dele
está pronto para uso.


### Usando await {:#using-await}

Antes de usar diretamente a API de Future, considere usar `await`.
Código que usa expressões `await` pode ser mais fácil de entender
do que código que usa a API de Future.

Considere a função a seguir. Ela usa o método `then()` do Future
para executar três funções assíncronas em sequência,
aguardando cada uma completar antes de executar a próxima.

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

Uma função `async` pode capturar exceções de Futures.
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
Funções async retornam Futures. Se você não quer que sua função retorne um
future, use uma solução diferente. Por exemplo, você pode chamar uma função
`async` de dentro da sua função.
:::

Para mais informações sobre o uso de `await` e de outros recursos relacionados da linguagem Dart,
veja o [tutorial de programação assíncrona](/libraries/async/async-await).


### Uso básico {:#basic-usage}

Você pode usar `then()` para agendar código que executa quando o future completa. Por
exemplo, [`Client.read()`][] retorna um Future, já que requisições HTTP
podem levar um tempo. Usar `then()` permite executar algum código quando esse Future
tiver completado e o valor string prometido estiver disponível:

<?code-excerpt "misc/lib/library_tour/async/basic.dart (then)"?>
```dart
httpClient.read(url).then((String result) {
  print(result);
});
```

Use `catchError()` para tratar quaisquer erros ou exceções que um objeto Future
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
Certifique-se de invocar `catchError()` no resultado de `then()`, e não no
resultado do `Future` original. Caso contrário, o
`catchError()` pode tratar apenas erros do cálculo do Future original,
mas não os do handler registrado por `then()`.
:::

[`Client.read()`]: {{site.pub-api}}/http/latest/http/Client/read.html

### Encadeando múltiplos métodos assíncronos {:#chaining-multiple-asynchronous-methods}

O método `then()` retorna um Future, o que oferece uma forma prática de executar
múltiplas funções assíncronas em uma ordem específica.
Se o callback registrado com `then()` retorna um Future,
`then()` retorna um Future que completa
com o mesmo resultado do Future retornado pelo callback.
Se o callback retorna um valor de qualquer outro tipo,
`then()` cria um novo Future que completa com esse valor.

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

Aqui está o mesmo código escrito com await:

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


### Aguardando múltiplos futures {:#waiting-for-multiple-futures}

Às vezes, seu algoritmo precisa invocar várias funções assíncronas e
aguardar que todas completem antes de continuar. Use o método
estático [Future.wait()][] para gerenciar múltiplos Futures e aguardar que completem:

<?code-excerpt "misc/lib/library_tour/async/future.dart (wait)" replace="/elideBody;/\/* ... *\//g"?>
```dart
Future<void> deleteLotsOfFiles() async => /* ... */
Future<void> copyLotsOfFiles() async => /* ... */
Future<void> checksumLotsOfOtherFiles() async => /* ... */

await Future.wait([
  deleteLotsOfFiles(),
  copyLotsOfFiles(),
  checksumLotsOfOtherFiles(),
]);
print('Done with all the long steps!');
```

`Future.wait()` retorna um future que completa assim que todos os futures
fornecidos tiverem completado. Ele completa com os resultados deles,
ou com um erro se qualquer um dos futures fornecidos falhar.

### Tratando erros de múltiplos futures {:#handling-errors-for-multiple-futures}

Você também pode aguardar operações paralelas em:

* Um [iterable][iterable-futures] de futures
* Um [record][record-futures] com futures como campos posicionais

Essas extensões retornam um `Future` com os
valores resultantes de todos os futures fornecidos.
Diferente de `Future.wait`, elas também permitem tratar erros.

Se qualquer future da coleção completar com um erro,
`wait` completa com um [`ParallelWaitError`][].
Isso permite que o chamador trate erros individuais e
descarte resultados bem-sucedidos, se necessário.

Quando você _não_ precisa dos valores de resultado de cada future,
use `wait` em um _iterable_ de futures:

```dart
Future<int> delete() async => ...;
Future<String> copy() async => ...;
Future<bool> errorResult() async => ...;

void main() async {
  try {
    // Wait for each future in a list, returns a list of futures:
    var results = await [delete(), copy(), errorResult()].wait;
  } on ParallelWaitError<List<bool?>, List<AsyncError?>> catch (e) {
    print(e.values[0]);    // Prints successful future
    print(e.values[1]);    // Prints successful future
    print(e.values[2]);    // Prints null when the result is an error

    print(e.errors[0]);    // Prints null when the result is successful
    print(e.errors[1]);    // Prints null when the result is successful
    print(e.errors[2]);    // Prints error
  }
}
```

Quando você _precisa_ dos valores de resultado individuais de cada future,
use `wait` em um _record_ de futures.
Isso traz o benefício adicional de que os futures podem ser de tipos diferentes:

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

## Stream {:#stream}

Objetos Stream aparecem em toda a API do Dart, representando sequências de
dados. Por exemplo, eventos HTML, como cliques em botões, são entregues usando
streams. Você também pode ler um arquivo como um stream.


### Usando um loop for assíncrono {:#using-an-asynchronous-for-loop}

Às vezes, você pode usar um loop for assíncrono (`await for`)
em vez de usar a API de Stream.

Considere a função a seguir.
Ela usa o método `listen()` do Stream
para se inscrever em uma lista de arquivos,
passando uma função literal que pesquisa cada arquivo ou diretório.

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
incluindo um loop for assíncrono (`await for`),
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
Antes de usar `await for`, certifique-se de que ele deixa o código mais claro e de que
você realmente quer aguardar todos os resultados do stream. Por exemplo, você
geralmente **não** deve usar `await for` para listeners de eventos do DOM, porque o
DOM envia streams infinitos de eventos. Se você usar `await for` para registrar dois
listeners de eventos do DOM em sequência, o segundo tipo de evento nunca será tratado.
:::

Para mais informações sobre o uso de `await` e de outros recursos relacionados
da linguagem Dart, veja o
[tutorial de programação assíncrona](/libraries/async/async-await).


### Ouvindo dados do stream {:#listening-for-stream-data}

Para obter cada valor conforme ele chega, use `await for` ou
inscreva-se no stream usando o método `listen()`:

<?code-excerpt "misc/lib/library_tour/async/stream_web.dart (listen)" replace="/listen/[!$&!]/g"?>
```dart
// Add an event handler to a button.
submitButton.onClick.[!listen!]((e) {
  // When the button is clicked, it runs this code.
  submitData();
});
```

Neste exemplo, a propriedade `onClick` é um objeto `Stream` fornecido pelo
botão de envio.

Se você se importa com apenas um evento, pode obtê-lo usando uma propriedade como
`first`, `last` ou `single`. Para testar o evento antes de tratá-lo,
use um método como `firstWhere()`, `lastWhere()` ou `singleWhere()`.
{% comment %}
{PENDING: example}
{% endcomment %}

Se você se importa com um subconjunto de eventos, pode usar métodos como
`skip()`, `skipWhile()`, `take()`, `takeWhile()` e `where()`.
{% comment %}
{PENDING: example}
{% endcomment %}


### Transformando dados do stream {:#transforming-stream-data}

Frequentemente, você precisa alterar o formato dos dados de um stream antes de poder
usá-los. Use o método `transform()` para produzir um stream com um
tipo diferente de dados:

<?code-excerpt "misc/lib/library_tour/async/stream.dart (transform)"?>
```dart
var lines = inputStream
    .transform(utf8.decoder)
    .transform(const LineSplitter());
```

Este exemplo usa dois transformers. Primeiro, ele usa utf8.decoder para
transformar o stream de inteiros em um stream de strings. Depois, usa
um LineSplitter para transformar o stream de strings em um stream de
linhas separadas. Esses transformers são da biblioteca dart:convert (veja a
[seção dart:convert](/libraries/dart-convert)).
{% comment %}
  PENDING: add onDone and onError. (See "Streaming file contents".)
{% endcomment %}


### Tratando erros e conclusão {:#handling-errors-and-completion}

Como você especifica o código de tratamento de erros e de conclusão
depende de usar um loop for assíncrono (`await for`)
ou a API de Stream.

Se você usa um loop for assíncrono,
então use try-catch para tratar erros.
Código que executa após o stream ser fechado
vai depois do loop for assíncrono.

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

Se você usa a API de Stream,
então trate erros registrando um listener `onError`.
Execute código após o stream ser fechado registrando
um listener `onDone`.

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
confira a [documentação do dart:io][dart:io documentation].
Veja também estes artigos e tutoriais:

- [Programação assíncrona: futures, async, await](/libraries/async/async-await)
- [Futures e tratamento de erros](/libraries/async/futures-error-handling)
- [Programação assíncrona: streams](/libraries/async/using-streams)
- [Criando streams em Dart](/libraries/async/creating-streams)
- [Programação assíncrona em Dart: Isolates e event loops](/language/concurrency)


[Future.wait()]: {{site.dart-api}}/dart-async/Future/wait.html
[Future]: {{site.dart-api}}/dart-async/Future-class.html
[`ParallelWaitError`]: {{site.dart-api}}/dart-async/ParallelWaitError-class.html
[Stream]: {{site.dart-api}}/dart-async/Stream-class.html
[dart:async]: {{site.dart-api}}/dart-async/dart-async-library.html
[dart:io documentation]: /libraries/dart-io
