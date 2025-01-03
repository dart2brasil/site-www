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
capturada, o [isolado][] que lançou a exceção é suspenso,
e tipicamente o isolado e seu programa são encerrados.

Em contraste com Java, todas as exceções de Dart são exceções não verificadas.
Métodos não declaram quais exceções eles podem lançar, e você não é
obrigado a capturar nenhuma exceção.

Dart fornece os tipos [`Exception`][] e [`Error`][],
assim como inúmeros subtipos predefinidos. Você pode, claro,
definir suas próprias exceções. No entanto, programas Dart podem lançar qualquer
objeto não nulo — não apenas objetos Exception e Error — como uma exceção.

### Lançar {:#throw}

Aqui está um exemplo de lançar, ou *levantar*, uma exceção:

<?code-excerpt "misc/lib/language_tour/exceptions.dart (throw-FormatException)"?>
```dart
throw FormatException('Esperava pelo menos 1 seção');
```

Você também pode lançar objetos arbitrários:

<?code-excerpt "misc/lib/language_tour/exceptions.dart (out-of-llamas)"?>
```dart
throw 'Sem lhamas!';
```

:::note
Código de qualidade de produção geralmente lança tipos que
implementam [`Error`][] ou [`Exception`][].
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
  criarMaisLhamas();
} on OutOfLlamasException {
  comprarMaisLhamas();
}
```

Para lidar com código que pode lançar mais de um tipo de exceção, você pode
especificar múltiplas cláusulas catch. A primeira cláusula catch que corresponde ao
tipo do objeto lançado lida com a exceção. Se a cláusula catch não
especificar um tipo, essa cláusula pode lidar com qualquer tipo de objeto lançado:

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
  // Nenhum tipo especificado, lida com tudo
  print('Algo realmente desconhecido: $e');
}
```

Como o código anterior mostra, você pode usar `on` ou `catch` ou ambos.
Use `on` quando você precisar especificar o tipo da exceção. Use `catch` quando
seu manipulador de exceção precisar do objeto exceção.

Você pode especificar um ou dois parâmetros para `catch()`.
O primeiro é a exceção que foi lançada,
e o segundo é o stack trace (uma objeto [`StackTrace`][]).

<?code-excerpt "misc/lib/language_tour/exceptions.dart (try-catch-2)" replace="/\(e.*?\)/[!$&!]/g"?>
```dart
try {
  // ···
} on Exception catch [!(e)!] {
  print('Detalhes da Exceção:\n $e');
} catch [!(e, s)!] {
  print('Detalhes da Exceção:\n $e');
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
    print(foo++); // Erro de tempo de execução
  } catch (e) {
    print('misbehave() lidou parcialmente com ${e.runtimeType}.');
    [!rethrow;!] // Permite que os chamadores vejam a exceção.
  }
}

void main() {
  try {
    misbehave();
  } catch (e) {
    print('main() terminou de lidar com ${e.runtimeType}.');
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
  criarMaisLhamas();
} finally {
  // Sempre limpe, mesmo que uma exceção seja lançada.
  limparOsEstabulosDeLhama();
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
  limparOsEstabulosDeLhama(); // Então limpe.
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
// Certifique-se de que a variável tenha um valor não nulo.
assert(text != null);

// Certifique-se de que o valor seja menor que 100.
assert(number < 100);

// Certifique-se de que esta seja uma URL https.
assert(urlString.startsWith('https'));
```

Para anexar uma mensagem a uma declaração,
adicione uma string como o segundo argumento para `assert`
(opcionalmente com uma [vírgula à direita][]):

<?code-excerpt "misc/test/language_tour/control_flow_test.dart (assert-with-message)"?>
```dart
assert(urlString.startsWith('https'),
    'URL ($urlString) deve começar com "https".');
```

O primeiro argumento para `assert` pode ser qualquer expressão que
se resolve para um valor booleano. Se o valor da expressão
for verdadeiro, a declaração tem sucesso e a execução
continua. Se for falso, a declaração falha e uma exceção (um
[`AssertionError`][]) é lançada.

Quando exatamente as declarações funcionam?
Isso depende das ferramentas e do framework que você está usando:

* Flutter habilita declarações no [modo de depuração.][Flutter debug mode]
* Ferramentas apenas para desenvolvimento, como [`webdev serve`][],
  normalmente habilitam declarações por padrão.
* Algumas ferramentas, como [`dart run`][] e [`dart compile js`][],
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
