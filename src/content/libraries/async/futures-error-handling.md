---
ia-translate: true
title: Futures e tratamento de erros
description: >-
  Tudo que você queria saber sobre lidar com erros e exceções
  ao escrever código assíncrono. E um pouco mais.
---

A linguagem Dart tem suporte nativo
para [assincronia](/language/async),
tornando o código Dart assíncrono muito mais fácil de ler e escrever.
No entanto, algum código—especialmente código mais antigo—ainda pode usar
[métodos de Future][Future class]
como `then()`, `catchError()` e `whenComplete()`.

Esta página pode ajudá-lo a evitar algumas armadilhas comuns
ao usar esses métodos de Future.

:::warning
Você não precisa desta página se seu código usa
o suporte de assincronia da linguagem:
`async`, `await` e tratamento de erros usando try-catch.
Para mais informações, veja o
[tutorial de programação assíncrona](/libraries/async/async-await).
:::


## A API Future e callbacks

Funções que usam a API Future registram callbacks que lidam
com o valor (ou o erro) que completa um Future. Por exemplo:

<?code-excerpt "futures/lib/simple.dart (then-catch)"?>
```dart
myFunc().then(processValue).catchError(handleError);
```

Os callbacks registrados disparam baseado nas seguintes regras: o
callback de `then()` dispara se ele é invocado em um Future que completa com um valor;
o callback de `catchError()` dispara se ele é invocado em um Future que completa
com um erro.

No exemplo acima, se o Future de `myFunc()` completa com um valor,
o callback de `then()` dispara. Se nenhum novo erro é produzido dentro de `then()`,
o callback de `catchError()` não dispara. Por outro lado, se `myFunc()`
completa com um erro, o callback de `then()` não dispara, e
o callback de `catchError()` dispara.

## Exemplos de uso de then() com catchError()

Invocações encadeadas de `then()` e `catchError()` são um padrão comum ao
lidar com Futures, e podem ser pensadas como o equivalente aproximado de
blocos try-catch.

As próximas seções dão exemplos deste padrão.

### catchError() como um handler de erros abrangente

O exemplo a seguir lida com o lançamento de uma exceção de dentro do
callback de `then()` e demonstra a versatilidade de `catchError()` como um handler de erros:

<?code-excerpt "futures/lib/simple.dart (comprehensive-errors)" replace="/ellipsis\(\);/.../g;"?>
```dart
myFunc()
    .then((value) {
      doSomethingWith(value);
      ...
      throw Exception('Some arbitrary error');
    })
    .catchError(handleError);
```

Se o Future de `myFunc()` completa com um valor, o callback de `then()` dispara. Se
o código dentro do callback de `then()` lança (como faz no exemplo acima),
o Future de `then()` completa com um erro. Esse erro é tratado por
`catchError()`.

Se o Future de `myFunc()` completa com um erro, o Future de `then()` completa
com esse erro. O erro também é tratado por `catchError()`.

Independentemente de o erro ter se originado dentro de `myFunc()` ou dentro de
`then()`, `catchError()` o trata com sucesso.

### Tratamento de erros dentro de then()

Para tratamento de erros mais granular, você pode registrar um segundo callback (`onError`)
dentro de `then()` para lidar com Futures completados com erros. Aqui está
a assinatura de `then()`:

<?code-excerpt "futures/lib/simple.dart (future-then)"?>
```dart
Future<R> then<R>(FutureOr<R> Function(T value) onValue, {Function? onError});
```

Registre o callback onError opcional apenas se você quiser diferenciar
entre um erro encaminhado _para_ `then()`, e um erro gerado _dentro_
de `then()`:

<?code-excerpt "futures/lib/simple.dart (throws-then-catch)"?>
```dart
asyncErrorFunction()
    .then(
      successCallback,
      onError: (e) {
        handleError(e); // Original error.
        anotherAsyncErrorFunction(); // Oops, new error.
      },
    )
    .catchError(handleError); // Error from within then() handled.
```

No exemplo acima, o erro do Future de `asyncErrorFunction()` é tratado com o
callback `onError`; `anotherAsyncErrorFunction()` faz com que o Future de `then()` complete
com um erro; esse erro é tratado por `catchError()`.

Em geral, implementar duas estratégias diferentes de tratamento de erros não é
recomendado: registre um segundo callback apenas se houver uma razão convincente
para capturar o erro dentro de `then()`.

### Erros no meio de uma cadeia longa

É comum ter uma sucessão de chamadas `then()`, e capturar erros
gerados de qualquer parte da cadeia usando `catchError()`:

<?code-excerpt "futures/lib/long_chain.dart"?>
```dart
Future<String> one() => Future.value('from one');
Future<String> two() => Future.error('error from two');
Future<String> three() => Future.value('from three');
Future<String> four() => Future.value('from four');

void main() {
  one() // Future completes with "from one".
      .then((_) => two()) // Future completes with two()'s error.
      .then((_) => three()) // Future completes with two()'s error.
      .then((_) => four()) // Future completes with two()'s error.
      .then((value) => value.length) // Future completes with two()'s error.
      .catchError((e) {
        print('Got error: $e'); // Finally, callback fires.
        return 42; // Future completes with 42.
      })
      .then((value) {
        print('The value is $value');
      });
}

// Output of this program:
//   Got error: error from two
//   The value is 42
```

No código acima, o Future de `one()` completa com um valor, mas o Future de `two()`
completa com um erro. Quando `then()` é invocado em um Future que
completa com um erro, o callback de `then()` não dispara. Em vez disso,
o Future de `then()` completa com o erro de seu receptor. No nosso exemplo,
isso significa que após `two()` ser chamado, o Future retornado por cada
`then()` subsequente completa com o erro de `two()`. Esse erro é finalmente
tratado dentro de `catchError()`.

### Lidando com erros específicos

E se quisermos capturar um erro específico? Ou capturar mais de um erro?

`catchError()` aceita um argumento nomeado opcional, `test`, que
nos permite consultar o tipo de erro lançado.

<?code-excerpt "futures/lib/simple.dart (future-catch-error)"?>
```dart
Future<T> catchError(Function onError, {bool Function(Object error)? test});
```

Considere `handleAuthResponse(params)`, uma função que autentica um usuário
com base nos parâmetros fornecidos, e redireciona o usuário para uma URL apropriada.
Dado o fluxo de trabalho complexo, `handleAuthResponse()` pode gerar vários
erros e exceções, e você deve tratá-los de forma diferente. Veja como
você pode usar `test` para fazer isso:

<?code-excerpt "futures/lib/simple.dart (auth-response)" replace="/ellipsis\(\)/.../g;"?>
```dart
void main() {
  handleAuthResponse(const {'username': 'dash', 'age': 3})
      .then((_) => ...)
      .catchError(handleFormatException, test: (e) => e is FormatException)
      .catchError(
        handleAuthorizationException,
        test: (e) => e is AuthorizationException,
      );
}
```

## Try-catch-finally assíncrono usando whenComplete()

Se `then().catchError()` espelha um try-catch, `whenComplete()` é o
equivalente de 'finally'. O callback registrado dentro de `whenComplete()` é
chamado quando o receptor de `whenComplete()` completa, seja com um
valor ou com um erro:

<?code-excerpt "futures/lib/simple.dart (connect-server)"?>
```dart
final server = connectToServer();
server
    .post(myUrl, fields: const {'name': 'Dash', 'profession': 'mascot'})
    .then(handleResponse)
    .catchError(handleError)
    .whenComplete(server.close);
```

Queremos chamar `server.close` independentemente de `server.post()` produzir
uma resposta válida, ou um erro. Garantimos que isso aconteça colocando-o dentro
de `whenComplete()`.

### Completando o Future retornado por whenComplete()

Se nenhum erro é emitido de dentro de `whenComplete()`, seu Future completa
da mesma maneira que o Future em que `whenComplete()` é invocado. Isso é
mais fácil de entender através de exemplos.

No código abaixo, o Future de `then()` completa com um erro, então
o Future de `whenComplete()` também completa com esse erro.

<?code-excerpt "futures/lib/when_complete.dart (with-error)" replace="/withErrorMain/main/g; "?>
```dart
void main() {
  asyncErrorFunction()
      // Future completes with an error:
      .then((_) => print("Won't reach here"))
      // Future completes with the same error:
      .whenComplete(() => print('Reaches here'))
      // Future completes with the same error:
      .then((_) => print("Won't reach here"))
      // Error is handled here:
      .catchError(handleError);
}
```

No código abaixo, o Future de `then()` completa com um erro, que agora é
tratado por `catchError()`.  Como o Future de `catchError()` completa com
`someObject`, o Future de `whenComplete()` completa com esse mesmo objeto.

<?code-excerpt "futures/lib/when_complete.dart (with-object)" replace="/ellipsis\(\)/.../g; /withObjectMain/main/g; "?>
```dart
void main() {
  asyncErrorFunction()
      // Future completes with an error:
      .then((_) => ...)
      .catchError((e) {
        handleError(e);
        printErrorMessage();
        return someObject; // Future completes with someObject
      })
      .whenComplete(() => print('Done!')); // Future completes with someObject
}
```

### Erros originados dentro de whenComplete()

Se o callback de `whenComplete()` lança um erro, então o Future de
`whenComplete()` completa com esse erro:

<?code-excerpt "futures/lib/when_complete.dart (when-complete-error)" replace="/whenCompleteError/main/g; "?>
```dart
void main() {
  asyncErrorFunction()
      // Future completes with a value:
      .catchError(handleError)
      // Future completes with an error:
      .whenComplete(() => throw Exception('New error'))
      // Error is handled:
      .catchError(handleError);
}
```


## Problema potencial: falha ao registrar handlers de erro cedo

É crucial que handlers de erro sejam instalados antes de um Future completar:
isso evita cenários onde um Future completa com um erro, o
handler de erro ainda não está anexado, e o erro acidentalmente se propaga. Considere
este código:

<?code-excerpt "futures/lib/early_error_handlers.dart (bad)" replace="/ellipsis\(\)/.../g; /mainBad/main/g;"?>
```dart
void main() {
  Future<Object> future = asyncErrorFunction();

  // BAD: Too late to handle asyncErrorFunction() exception.
  Future.delayed(const Duration(milliseconds: 500), () {
    future.then(...).catchError(...);
  });
}
```

No código acima, `catchError()` não é registrado até meio segundo após
`asyncErrorFunction()` ser chamada, e o erro fica sem tratamento.

O problema desaparece se `asyncErrorFunction()` for chamada dentro do
callback `Future.delayed()`:

<?code-excerpt "futures/lib/early_error_handlers.dart (good)" replace="/ellipsis\(\)/.../g; /mainGood/main/g;"?>
```dart
void main() {
  Future.delayed(const Duration(milliseconds: 500), () {
    asyncErrorFunction()
        .then(...)
        .catchError(...); // We get here.
  });
}
```

## Problema potencial: misturando acidentalmente erros síncronos e assíncronos

Funções que retornam Futures devem quase sempre emitir seus erros no
futuro. Como não queremos que o chamador de tais funções tenha que
implementar múltiplos cenários de tratamento de erros, queremos prevenir que qualquer
erro síncrono vaze para fora. Considere este código:

<?code-excerpt "futures/bin/mixing_errors_problematic.dart (parse)"?>
```dart
Future<int> parseAndRead(Map<String, dynamic> data) {
  final filename = obtainFilename(data); // Could throw.
  final file = File(filename);
  return file.readAsString().then((contents) {
    return parseFileData(contents); // Could throw.
  });
}
```

Duas funções nesse código podem potencialmente lançar sincronamente:
`obtainFilename()` e `parseFileData()`. Como `parseFileData()` executa
dentro de um callback `then()`, seu erro não vaza para fora da função.
Em vez disso, o Future de `then()` completa com o erro de `parseFileData()`, o erro
eventualmente completa o Future de `parseAndRead()`, e o erro pode ser
tratado com sucesso por `catchError()`.

Mas `obtainFilename()` não é chamado dentro de um callback `then()`; se _ele_
lançar, um erro síncrono se propaga:

<?code-excerpt "futures/bin/mixing_errors_problematic.dart (main)"?>
```dart
void main() {
  parseAndRead(data).catchError((e) {
    print('Inside catchError');
    print(e);
    return -1;
  });
}

// Program Output:
//   Unhandled exception:
//   <error from obtainFilename>
//   ...
```

Como usar `catchError()` não captura o erro, um cliente de
`parseAndRead()` implementaria uma estratégia separada de tratamento de erros para este
erro.

### Solução: Usando Future.sync() para envolver seu código

Um padrão comum para garantir que nenhum erro síncrono seja acidentalmente
lançado de uma função é envolver o corpo da função dentro de um novo callback `Future.sync()`:

<?code-excerpt "futures/bin/mixing_errors_solution.dart (parse)"?>
```dart
Future<int> parseAndRead(Map<String, dynamic> data) {
  return Future.sync(() {
    final filename = obtainFilename(data); // Could throw.
    final file = File(filename);
    return file.readAsString().then((contents) {
      return parseFileData(contents); // Could throw.
    });
  });
}
```

Se o callback retorna um valor que não é Future, o Future de `Future.sync()` completa
com esse valor. Se o callback lança (como faz no exemplo
acima), o Future completa com um erro. Se o callback em si retorna um
Future, o valor ou o erro desse Future completa o Future de `Future.sync()`.

Com o código envolvido dentro de `Future.sync()`, `catchError()` pode lidar com todos os erros:

<?code-excerpt "futures/bin/mixing_errors_solution.dart (main)"?>
```dart
void main() {
  parseAndRead(data).catchError((e) {
    print('Inside catchError');
    print(e);
    return -1;
  });
}

// Program Output:
//   Inside catchError
//   <error from obtainFilename>
```

`Future.sync()` torna seu código resiliente contra exceções não capturadas. Se sua
função tem muito código embutido nela, as chances são de que você poderia estar fazendo
algo perigoso sem perceber:

<?code-excerpt "futures/bin/mixing_errors_problematic.dart (fragile)" replace="/ellipsis\(\);/.../g;"?>
```dart
Future fragileFunc() {
  return Future.sync(() {
    final x = someFunc(); // Unexpectedly throws in some rare cases.
    var y = 10 / x; // x should not equal 0.
    ...
  });
}
```

`Future.sync()` não apenas permite que você trate erros que você sabe que podem ocorrer, mas
também previne que erros *acidentalmente* vazem para fora de sua função.


## Mais informações

Veja a [referência da API Future][Future class]
para mais informações sobre Futures.

[Future class]: {{site.dart-api}}/dart-async/Future-class.html
