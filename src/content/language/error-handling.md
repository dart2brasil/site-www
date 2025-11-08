---
ia-translate: true
title: Tratamento de erros
description: Aprenda sobre o tratamento de erros e exceções em Dart.
prevpage:
  url: /language/branches
  title: Branches
nextpage:
  url: /language/functions
  title: Functions
---

## Exceptions

Seu código Dart pode lançar e capturar exceções. Exceções são erros
indicando que algo inesperado aconteceu. Se a exceção não for
capturada, o [isolate][] que lançou a exceção é suspenso,
e tipicamente o isolate e seu programa são terminados.

Em contraste com Java, todas as exceções do Dart são exceções não verificadas.
Métodos não declaram quais exceções eles podem lançar, e você não é
obrigado a capturar nenhuma exceção.

Dart fornece os tipos [`Exception`][] e [`Error`][],
assim como vários subtipos predefinidos. Você pode, é claro,
definir suas próprias exceções. No entanto, programas Dart podem lançar qualquer
objeto não-null—não apenas objetos Exception e Error—como uma exceção.

### Throw

Aqui está um exemplo de lançar, ou *raising*, uma exceção:

<?code-excerpt "misc/lib/language_tour/exceptions.dart (throw-FormatException)"?>
```dart
throw FormatException('Expected at least 1 section');
```

Você também pode lançar objetos arbitrários:

<?code-excerpt "misc/lib/language_tour/exceptions.dart (out-of-llamas)"?>
```dart
throw 'Out of llamas!';
```

:::note
Código de qualidade de produção geralmente lança tipos que
implementam [`Error`][] ou [`Exception`][].
:::

Como lançar uma exceção é uma expressão, você pode lançar exceções
em instruções =\>, assim como em qualquer outro lugar que permita expressões:

<?code-excerpt "misc/lib/language_tour/exceptions.dart (throw-is-an-expression)"?>
```dart
void distanceTo(Point other) => throw UnimplementedError();
```


### Catch

Capturar, ou catching, uma exceção impede que a exceção seja
propagada (a menos que você relance a exceção).
Capturar uma exceção lhe dá a chance de tratá-la:

<?code-excerpt "misc/lib/language_tour/exceptions.dart (try)"?>
```dart
try {
  breedMoreLlamas();
} on OutOfLlamasException {
  buyMoreLlamas();
}
```

Para tratar código que pode lançar mais de um tipo de exceção, você pode
especificar múltiplas cláusulas catch. A primeira cláusula catch que corresponde ao
tipo do objeto lançado trata a exceção. Se a cláusula catch não
especifica um tipo, essa cláusula pode tratar qualquer tipo de objeto lançado:

<?code-excerpt "misc/lib/language_tour/exceptions.dart (try-catch)"?>
```dart
try {
  breedMoreLlamas();
} on OutOfLlamasException {
  // A specific exception
  buyMoreLlamas();
} on Exception catch (e) {
  // Anything else that is an exception
  print('Unknown exception: $e');
} catch (e) {
  // No specified type, handles all
  print('Something really unknown: $e');
}
```

Como o código anterior mostra, você pode usar `on` ou `catch` ou ambos.
Use `on` quando você precisa especificar o tipo da exceção. Use `catch` quando
seu tratador de exceção precisa do objeto de exceção.

Você pode especificar um ou dois parâmetros para `catch()`.
O primeiro é a exceção que foi lançada,
e o segundo é o stack trace (um objeto [`StackTrace`][]).

<?code-excerpt "misc/lib/language_tour/exceptions.dart (try-catch-2)" replace="/\(e.*?\)/[!$&!]/g"?>
```dart
try {
  // ···
} on Exception catch [!(e)!] {
  print('Exception details:\n $e');
} catch [!(e, s)!] {
  print('Exception details:\n $e');
  print('Stack trace:\n $s');
}
```

Para tratar parcialmente uma exceção,
enquanto permite que ela seja propagada,
use a keyword `rethrow`.

<?code-excerpt "misc/test/language_tour/exceptions_test.dart (rethrow)" replace="/rethrow;/[!$&!]/g"?>
```dart
void misbehave() {
  try {
    dynamic foo = true;
    print(foo++); // Runtime error
  } catch (e) {
    print('misbehave() partially handled ${e.runtimeType}.');
    [!rethrow;!] // Allow callers to see the exception.
  }
}

void main() {
  try {
    misbehave();
  } catch (e) {
    print('main() finished handling ${e.runtimeType}.');
  }
}
```


### Finally

Para garantir que algum código seja executado independentemente de uma exceção ser lançada ou não, use
uma cláusula `finally`. Se nenhuma cláusula `catch` corresponder à exceção, a
exceção é propagada após a cláusula `finally` ser executada:

<?code-excerpt "misc/lib/language_tour/exceptions.dart (finally)"?>
```dart
try {
  breedMoreLlamas();
} finally {
  // Always clean up, even if an exception is thrown.
  cleanLlamaStalls();
}
```

A cláusula `finally` é executada após quaisquer cláusulas `catch` correspondentes:

<?code-excerpt "misc/lib/language_tour/exceptions.dart (try-catch-finally)"?>
```dart
try {
  breedMoreLlamas();
} catch (e) {
  print('Error: $e'); // Handle the exception first.
} finally {
  cleanLlamaStalls(); // Then clean up.
}
```

Para saber mais, confira a
[documentação de exceções da biblioteca principal](/libraries/dart-core#exceptions).

## Assert

Durante o desenvolvimento, use uma instrução assert
— `assert(<condition>, <optionalMessage>);` —para
interromper a execução normal se uma condição booleana for falsa.

<?code-excerpt "misc/test/language_tour/control_flow_test.dart (assert)"?>
```dart
// Make sure the variable has a non-null value.
assert(text != null);

// Make sure the value is less than 100.
assert(number < 100);

// Make sure this is an https URL.
assert(urlString.startsWith('https'));
```

Para anexar uma mensagem a uma asserção,
adicione uma string como o segundo argumento para `assert`
(opcionalmente com uma [vírgula final][trailing comma]):

<?code-excerpt "misc/test/language_tour/control_flow_test.dart (assert-with-message)"?>
```dart
assert(
  urlString.startsWith('https'),
  'URL ($urlString) should start with "https".',
);
```

O primeiro argumento para `assert` pode ser qualquer expressão que
resolva para um valor booleano. Se o valor da expressão
for true, a asserção é bem-sucedida e a execução
continua. Se for false, a asserção falha e uma exceção (um
[`AssertionError`][]) é lançada.

Quando exatamente as asserções funcionam?
Isso depende das ferramentas e framework que você está usando:

* Flutter habilita asserções no [modo de debug.][Flutter debug mode]
* Ferramentas apenas para desenvolvimento, como [`webdev serve`][],
  tipicamente habilitam asserções por padrão.
* Algumas ferramentas, como [`dart run`][] e [`dart compile js`][],
  suportam asserções através de uma flag de linha de comando: `--enable-asserts`.

Em código de produção, asserções são ignoradas, e
os argumentos para `assert` não são avaliados.

[trailing comma]: /language/collections#trailing-comma
[`AssertionError`]: {{site.dart-api}}/dart-core/AssertionError-class.html
[Flutter debug mode]: {{site.flutter-docs}}/testing/debugging#debug-mode-assertions
[`webdev serve`]: /tools/webdev#serve
[`dart run`]: /tools/dart-run
[`dart compile js`]: /tools/dart-compile#js

[isolate]: /language/concurrency#isolates
[`Error`]: {{site.dart-api}}/dart-core/Error-class.html
[`Exception`]: {{site.dart-api}}/dart-core/Exception-class.html
[`StackTrace`]: {{site.dart-api}}/dart-core/StackTrace-class.html
