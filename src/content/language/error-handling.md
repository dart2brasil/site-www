---
ia-translate: true
title: Tratamento de erros
description: Aprenda sobre como lidar com erros e exceções em Dart.
prevpage:
  url: /language/branches
  title: Desvios
nextpage:
  url: /language/classes
  title: Classes
---

## Exceções {:#exceptions}

Seu código Dart pode lançar e capturar exceções. Exceções são erros
indicando que algo inesperado aconteceu. Se a exceção não for
capturada, o [isolado][isolate] que lançou a exceção é suspenso,
e tipicamente o isolado e seu programa são encerrados.

Em contraste com Java, todas as exceções de Dart são exceções não verificadas.
Métodos não declaram quais exceções eles podem lançar, e você não é
obrigado a capturar nenhuma exceção.

Dart fornece os tipos [`Exception`][`Exception`] e [`Error`][`Error`],
assim como inúmeros subtipos predefinidos. Você pode, claro,
definir suas próprias exceções. No entanto, programas Dart podem lançar qualquer
objeto não nulo — não apenas objetos Exception e Error — como uma exceção.

### Lançar {:#throw}

Aqui está um exemplo de lançar, ou *levantar*, uma exceção:

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
implementam [`Error`][`Error`] ou [`Exception`][`Exception`].
:::

Como lançar uma exceção é uma expressão, você pode lançar exceções
em declarações =\>, assim como em qualquer outro lugar que permita expressões:

<?code-excerpt "misc/lib/language_tour/exceptions.dart (throw-is-an-expression)"?>
```dart
void distanceTo(Point other) => throw UnimplementedError();
```

### Capturar {:#catch}

Capturar, ou pegar, uma exceção impede que a exceção se
propague (a menos que você relance a exceção).
Capturar uma exceção lhe dá a chance de lidar com ela:

<?code-excerpt "misc/lib/language_tour/exceptions.dart (try)"?>
```dart
try {
  breedMoreLlamas();
} on OutOfLlamasException {
  buyMoreLlamas();
}
```

Para lidar com código que pode lançar mais de um tipo de exceção, você pode
especificar múltiplas cláusulas catch. A primeira cláusula catch que corresponde ao
tipo do objeto lançado lida com a exceção. Se a cláusula catch não
especificar um tipo, essa cláusula pode lidar com qualquer tipo de objeto lançado:

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
Use `on` quando você precisar especificar o tipo da exceção. Use `catch` quando
seu manipulador de exceção precisar do objeto exceção.

Você pode especificar um ou dois parâmetros para `catch()`.
O primeiro é a exceção que foi lançada,
e o segundo é o stack trace (uma objeto [`StackTrace`][`StackTrace`]).

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

Para lidar parcialmente com uma exceção,
enquanto permite que ela se propague,
use a palavra-chave `rethrow` (relançar).

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

### Finally {:#finally}

Para garantir que algum código seja executado, seja ou não uma exceção lançada, use
uma cláusula `finally`. Se nenhuma cláusula `catch` corresponder à exceção, a
exceção é propagada depois que a cláusula `finally` é executada:

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
[documentação da biblioteca principal sobre exceções](/libraries/dart-core#exceptions).

## Assert {:#assert}

Durante o desenvolvimento, use uma declaração assert
— `assert(<condição>, <mensagemOpcional>);` — para
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

Para anexar uma mensagem a uma declaração,
adicione uma string como o segundo argumento para `assert`
(opcionalmente com uma [vírgula à direita][vírgula à direita]):

<?code-excerpt "misc/test/language_tour/control_flow_test.dart (assert-with-message)"?>
```dart
assert(urlString.startsWith('https'),
    'URL ($urlString) should start with "https".');
```

O primeiro argumento para `assert` pode ser qualquer expressão que
se resolve para um valor booleano. Se o valor da expressão
for verdadeiro, a declaração tem sucesso e a execução
continua. Se for falso, a declaração falha e uma exceção (um
[`AssertionError`][`AssertionError`]) é lançada.

Quando exatamente as declarações funcionam?
Isso depende das ferramentas e do framework que você está usando:

* Flutter habilita declarações no [modo de depuração.][Flutter debug mode]
* Ferramentas apenas para desenvolvimento, como [`webdev serve`][`webdev serve`],
  normalmente habilitam declarações por padrão.
* Algumas ferramentas, como [`dart run`][`dart run`] e [`dart compile js`][`dart compile js`],
  suportam declarações por meio de um flag de linha de comando: `--enable-asserts`.

Em código de produção, as declarações são ignoradas, e
os argumentos para `assert` não são avaliados.

[vírgula à direita]: /language/collections#trailing-comma
[`AssertionError`]: {{site.dart-api}}/dart-core/AssertionError-class.html
[Flutter debug mode]: {{site.flutter-docs}}/testing/debugging#debug-mode-assertions
[`webdev serve`]: /tools/webdev#serve
[`dart run`]: /tools/dart-run
[`dart compile js`]: /tools/dart-compile#js

[isolate]: /language/concurrency#isolates
[`Error`]: {{site.dart-api}}/dart-core/Error-class.html
[`Exception`]: {{site.dart-api}}/dart-core/Exception-class.html
[`StackTrace`]: {{site.dart-api}}/dart-core/StackTrace-class.html
