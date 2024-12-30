---
ia-translate: true
title: Tratamento de erros
description: Saiba mais sobre como lidar com erros e exceções em Dart.
prevpage:
  url: /language/branches
  title: Desvios
nextpage:
  url: /language/classes
  title: Classes
---

## Exceções

Seu código Dart pode lançar e capturar exceções. Exceções são erros
indicando que algo inesperado aconteceu. Se a exceção não for
capturada, o [isolado][isolate] que lançou a exceção é suspenso e,
normalmente, o isolado e seu programa são finalizados.

Ao contrário do Java, todas as exceções do Dart são exceções não
verificadas. Métodos não declaram quais exceções eles podem lançar, e
você não é obrigado a capturar nenhuma exceção.

Dart fornece os tipos [`Exception`][`Exception`] e [`Error`][`Error`],
bem como inúmeros subtipos predefinidos. Você pode, é claro,
definir suas próprias exceções. No entanto, programas Dart podem lançar
qualquer objeto não nulo — não apenas objetos Exception e Error — como uma exceção.

### Lançar

Aqui está um exemplo de lançamento, ou *elevar*, uma exceção:

<?code-excerpt "misc/lib/language_tour/exceptions.dart (throw-FormatException)"?>
```dart
throw FormatException('Esperado pelo menos 1 seção');
```

Você também pode lançar objetos arbitrários:

<?code-excerpt "misc/lib/language_tour/exceptions.dart (out-of-llamas)"?>
```dart
throw 'Sem lhamas!';
```

:::note
Código de qualidade de produção geralmente lança tipos que
implementam [`Error`][`Error`] ou [`Exception`][`Exception`].
:::

Como lançar uma exceção é uma expressão, você pode lançar exceções
em declarações =\>, bem como em qualquer outro lugar que permita expressões:

<?code-excerpt "misc/lib/language_tour/exceptions.dart (throw-is-an-expression)"?>
```dart
void distanceTo(Point other) => throw UnimplementedError();
```

### Capturar

Capturar uma exceção impede que a exceção se propague
(a menos que você relance a exceção).
Capturar uma exceção lhe dá a chance de lidar com ela:

<?code-excerpt "misc/lib/language_tour/exceptions.dart (try)"?>
```dart
try {
  criarMaisLhamas();
} on OutOfLlamasException {
  comprarMaisLhamas();
}
```

Para lidar com código que pode lançar mais de um tipo de exceção, você pode
especificar múltiplas cláusulas catch. A primeira cláusula catch que
corresponde ao tipo do objeto lançado lida com a exceção. Se a cláusula
catch não especificar um tipo, essa cláusula poderá lidar com qualquer
tipo de objeto lançado:

<?code-excerpt "misc/lib/language_tour/exceptions.dart (try-catch)"?>
```dart
try {
  criarMaisLhamas();
} on OutOfLlamasException {
  // Uma exceção específica
  comprarMaisLhamas();
} on Exception catch (e) {
  // Qualquer outra coisa que seja uma exceção
  print('Exceção desconhecida: $e');
} catch (e) {
  // Nenhum tipo especificado, lida com todos
  print('Algo realmente desconhecido: $e');
}
```

Como o código anterior mostra, você pode usar `on` ou `catch` ou ambos.
Use `on` quando precisar especificar o tipo de exceção. Use `catch` quando
seu manipulador de exceção precisar do objeto de exceção.

Você pode especificar um ou dois parâmetros para `catch()`.
O primeiro é a exceção que foi lançada,
e o segundo é o rastreamento de pilha (um objeto [`StackTrace`][`StackTrace`]).

<?code-excerpt "misc/lib/language_tour/exceptions.dart (try-catch-2)" replace="/\(e.*?\)/[!$&!]/g"?>
```dart
try {
  // ···
} on Exception catch [!(e)!] {
  print('Detalhes da exceção:\n $e');
} catch [!(e, s)!] {
  print('Detalhes da exceção:\n $e');
  print('Rastreamento de pilha:\n $s');
}
```

Para lidar parcialmente com uma exceção,
enquanto permite que ela se propague,
use a palavra-chave `rethrow`.

<?code-excerpt "misc/test/language_tour/exceptions_test.dart (rethrow)" replace="/rethrow;/[!$&!]/g"?>
```dart
void misbehave() {
  try {
    dynamic foo = true;
    print(foo++); // Erro de tempo de execução
  } catch (e) {
    print('misbehave() tratou parcialmente ${e.runtimeType}.');
    [!rethrow;!] // Permite que os chamadores vejam a exceção.
  }
}

void main() {
  try {
    misbehave();
  } catch (e) {
    print('main() terminou de tratar ${e.runtimeType}.');
  }
}
```

### Finally

Para garantir que algum código seja executado, independentemente de uma
exceção ser lançada ou não, use uma cláusula `finally`. Se nenhuma cláusula
`catch` corresponder à exceção, a exceção será propagada após a
execução da cláusula `finally`:

<?code-excerpt "misc/lib/language_tour/exceptions.dart (finally)"?>
```dart
try {
  criarMaisLhamas();
} finally {
  // Sempre limpar, mesmo se uma exceção for lançada.
  limparOsCurraisDeLhama();
}
```

A cláusula `finally` é executada após quaisquer cláusulas `catch` correspondentes:

<?code-excerpt "misc/lib/language_tour/exceptions.dart (try-catch-finally)"?>
```dart
try {
  criarMaisLhamas();
} catch (e) {
  print('Erro: $e'); // Lidar com a exceção primeiro.
} finally {
  limparOsCurraisDeLhama(); // Depois, limpar.
}
```

Para saber mais, confira a
[documentação de exceção da biblioteca principal](/libraries/dart-core#exceptions).

## Assert

Durante o desenvolvimento, use uma declaração assert — `assert(<condição>, <mensagemOpcional>);` — para interromper a execução normal se uma condição booleana for falsa.

<?code-excerpt "misc/test/language_tour/control_flow_test.dart (assert)"?>
```dart
// Garante que a variável tenha um valor não nulo.
assert(text != null);

// Garante que o valor seja menor que 100.
assert(number < 100);

// Garante que seja uma URL https.
assert(urlString.startsWith('https'));
```

Para anexar uma mensagem a uma asserção,
adicione uma string como o segundo argumento para `assert`
(opcionalmente com uma [vírgula final][trailing comma]):

<?code-excerpt "misc/test/language_tour/control_flow_test.dart (assert-with-message)"?>
```dart
assert(urlString.startsWith('https'),
    'URL ($urlString) deve começar com "https".');
```

O primeiro argumento para `assert` pode ser qualquer expressão que
resulte em um valor booleano. Se o valor da expressão
for verdadeiro, a asserção é bem-sucedida e a execução
continua. Se for falso, a asserção falha e uma exceção (um
[`AssertionError`][`AssertionError`]) é lançada.

Quando exatamente as asserções funcionam?
Isso depende das ferramentas e estrutura que você está usando:

* O Flutter habilita asserções no [modo de depuração][Flutter debug mode].
* Ferramentas somente para desenvolvimento, como [`webdev serve`][`webdev serve`],
  normalmente habilitam asserções por padrão.
* Algumas ferramentas, como [`dart run`][`dart run`] e [`dart compile js`][`dart compile js`]
  suportam asserções por meio de um sinalizador de linha de comando: `--enable-asserts`.

Em código de produção, as asserções são ignoradas e
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
