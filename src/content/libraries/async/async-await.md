---
ia-translate: true
title: "Programação assíncrona: futures, async, await"
shortTitle: Futures, async e await
description: Aprenda e pratique a escrita de código assíncrono no DartPad!
---
<?code-excerpt replace="/ *\/\/\s+ignore_for_file:[^\n]+\n//g; /(^|\n) *\/\/\s+ignore:[^\n]+\n/$1/g; /(\n[^\n]+) *\/\/\s+ignore:[^\n]+\n/$1\n/g"?>
<?code-excerpt plaster="none"?>

Este tutorial ensina como escrever código assíncrono usando
futures e as keywords `async` e `await`.
Usando editores DartPad incorporados,
você pode testar seu conhecimento executando códigos de exemplo
e completando exercícios.

Para aproveitar ao máximo este tutorial, você deve ter o seguinte:

* Conhecimento da [sintaxe básica do Dart](/language).
* Alguma experiência escrevendo código assíncrono em outra linguagem.
* Os lints [`discarded_futures`][] e [`unawaited_futures`][] habilitados.

[`discarded_futures`]: /tools/linter-rules/discarded_futures
[`unawaited_futures`]: /tools/linter-rules/unawaited_futures

Este tutorial cobre o seguinte material:

* Como e quando usar as keywords `async` e `await`.
* Como o uso de `async` e `await` afeta a ordem de execução.
* Como lidar com erros de uma chamada assíncrona
  usando expressões `try-catch` em funções `async`.

Tempo estimado para completar este tutorial: 40-60 minutos.

:::note
Esta página usa DartPads incorporados para exibir exemplos e exercícios.
{% render 'dartpads-embedded-troubleshooting.md' %}
:::

Os exercícios neste tutorial têm trechos de código parcialmente completos.
Você pode usar o DartPad para testar seu conhecimento completando o código e
clicando no botão **Run**.
**Não edite o código de teste na função `main` ou abaixo**.

Se você precisar de ajuda, expanda o dropdown **Hint** ou **Solution**
após cada exercício.

## Por que código assíncrono importa

Operações assíncronas permitem que seu programa complete um trabalho
enquanto aguarda a conclusão de outra operação.
Aqui estão algumas operações assíncronas comuns:

* Buscar dados através de uma rede.
* Escrever em um banco de dados.
* Ler dados de um arquivo.

Tais computações assíncronas geralmente fornecem seu resultado como um `Future`
ou, se o resultado tiver múltiplas partes, como um `Stream`.
Essas computações introduzem assincronia em um programa.
Para acomodar essa assincronia inicial,
outras funções Dart simples também precisam se tornar assíncronas.

Para interagir com esses resultados assíncronos,
você pode usar as keywords `async` e `await`.
A maioria das funções assíncronas são apenas funções Dart async
que dependem, possivelmente profundamente,
de uma computação inerentemente assíncrona.

### Exemplo: Uso incorreto de uma função assíncrona

O exemplo a seguir mostra a maneira errada
de usar uma função assíncrona (`fetchUserOrder()`).
Mais tarde você corrigirá o exemplo usando `async` e `await`.
Antes de executar este exemplo, tente identificar o problema --
qual você acha que será a saída?

<?code-excerpt "async_await/bin/get_order_sync_bad.dart" remove="Fetching"?>
```dartpad
// This example shows how *not* to write asynchronous Dart code.

String createOrderMessage() {
  var order = fetchUserOrder();
  return 'Your order is: $order';
}

Future<String> fetchUserOrder() =>
    // Imagine that this function is more complex and slow.
    Future.delayed(const Duration(seconds: 2), () => 'Large Latte');

void main() {
  print(createOrderMessage());
}
```

Aqui está o motivo pelo qual o exemplo falha ao imprimir o valor
que `fetchUserOrder()` eventualmente produz:

* `fetchUserOrder()` é uma função assíncrona que, após um atraso,
  fornece uma string que descreve o pedido do usuário: um "Large Latte".
* Para obter o pedido do usuário, `createOrderMessage()` deve chamar `fetchUserOrder()`
  e aguardar sua conclusão. Como `createOrderMessage()` *não* aguarda
  a conclusão de `fetchUserOrder()`, `createOrderMessage()` falha em
  obter o valor da string que `fetchUserOrder()` eventualmente fornece.
* Em vez disso, `createOrderMessage()` obtém uma representação do trabalho pendente a ser
  feito: um future incompleto.
  Você aprenderá mais sobre futures na próxima seção.
* Como `createOrderMessage()` falha em obter o valor que descreve o pedido do
  usuário, o exemplo falha ao imprimir "Large Latte" no console e, em vez disso,
  imprime "Your order is: Instance of '_Future\<String\>'".

Nas próximas seções você aprenderá sobre futures e sobre trabalhar com futures
(usando `async` e `await`)
para que você seja capaz de escrever o código necessário para fazer `fetchUserOrder()`
imprimir o valor desejado ("Large Latte") no console.

:::secondary Key terms
* **synchronous operation**: Uma operação síncrona bloqueia outras operações
  de executarem até que ela seja concluída.
* **synchronous function**: Uma função síncrona executa apenas operações síncronas.
* **asynchronous operation**: Uma vez iniciada, uma operação assíncrona permite
  que outras operações executem antes de sua conclusão.
* **asynchronous function**: Uma função assíncrona executa pelo menos uma
  operação assíncrona e também pode executar operações _síncronas_.
:::


## O que é um future?

Um future (letra minúscula "f") é uma instância
da classe [Future][] (letra maiúscula "F").
Um future representa o resultado de uma operação assíncrona,
e pode ter dois estados: incompleto ou completo.

:::note
_Uncompleted_ é um termo Dart referindo-se ao estado de um future
antes de ter produzido um valor.
:::

### Uncompleted

Quando você chama uma função assíncrona, ela retorna um future incompleto.
Esse future está aguardando a operação assíncrona da função
terminar ou lançar um erro.

### Completed

Se a operação assíncrona for bem-sucedida,
o future completa com um valor.
Caso contrário, ele completa com um erro.

#### Completing with a value

Um future do tipo `Future<T>` completa com um valor do tipo `T`.
Por exemplo, um future com tipo `Future<String>` produz um valor string.
Se um future não produz um valor utilizável,
então o tipo do future é `Future<void>`.

#### Completing with an error

Se a operação assíncrona executada pela função falhar por qualquer motivo,
o future completa com um erro.

### Exemplo: Introdução aos futures

No exemplo a seguir, `fetchUserOrder()` retorna um future
que completa após imprimir no console.
Como não retorna um valor utilizável,
`fetchUserOrder()` tem o tipo `Future<void>`.
Antes de executar o exemplo,
tente prever qual será impresso primeiro:
"Large Latte" ou "Fetching user order...".

<?code-excerpt "async_await/bin/futures_intro.dart (no-error)"?>
```dartpad
Future<void> fetchUserOrder() {
  // Imagine that this function is fetching user info from another service or database.
  return Future.delayed(const Duration(seconds: 2), () => print('Large Latte'));
}

void main() {
  fetchUserOrder();
  print('Fetching user order...');
}
```

No exemplo anterior,
mesmo que `fetchUserOrder()` execute antes da chamada `print()` na linha 8,
o console mostra a saída da linha 8 ("Fetching user order...")
antes da saída de `fetchUserOrder()` ("Large Latte").
Isso ocorre porque `fetchUserOrder()` atrasa antes de imprimir "Large Latte".

### Exemplo: Completando com um erro

Execute o exemplo a seguir para ver como um future completa com um erro.
Um pouco mais tarde você aprenderá como lidar com o erro.

<?code-excerpt "async_await/bin/futures_intro.dart (error)" replace="/Error//g"?>
```dartpad
Future<void> fetchUserOrder() {
  // Imagine that this function is fetching user info but encounters a bug.
  return Future.delayed(
    const Duration(seconds: 2),
    () => throw Exception('Logout failed: user ID is invalid'),
  );
}

void main() {
  fetchUserOrder();
  print('Fetching user order...');
}
```

Neste exemplo, `fetchUserOrder()` completa
com um erro indicando que o ID do usuário é inválido.

Você aprendeu sobre futures e como eles completam,
mas como você usa os resultados de funções assíncronas?
Na próxima seção você aprenderá como obter resultados
com as keywords `async` e `await`.

:::secondary Quick review
* Uma instância de [Future\<T\>][Future] produz um valor do tipo `T`.
* Se um future não produz um valor utilizável,
  então o tipo do future é `Future<void>`.
* Um future pode estar em um de dois estados: incompleto ou completo.
* Quando você chama uma função que retorna um future,
  a função enfileira o trabalho a ser feito e retorna um future incompleto.
* Quando a operação de um future termina,
  o future completa com um valor ou com um erro.

**Key terms:**

* **Future**: a classe [Future][] do Dart.
* **future**: uma instância da classe `Future` do Dart.
:::

## Trabalhando com futures: async e await

As keywords `async` e `await` fornecem uma maneira declarativa
de definir funções assíncronas e usar seus resultados.
Lembre-se destas duas diretrizes básicas ao usar `async` e `await`:

* __Para definir uma função async, adicione `async` antes do corpo da função:__
* __A keyword `await` funciona apenas em funções `async`.__

Aqui está um exemplo que converte `main()`
de uma função síncrona para assíncrona.

Primeiro, adicione a keyword `async` antes do corpo da função:

<?code-excerpt "async_await/bin/get_order_sync_bad.dart (main-sig)" replace="/main\(\)/$& async/g; /async/[!$&!]/g; /$/ ··· }/g"?>
```dart
void main() [!async!] { ··· }
```

Se a função tem um tipo de retorno declarado,
então atualize o tipo para ser `Future<T>`,
onde `T` é o tipo do valor que a função retorna.
Se a função não retorna explicitamente um valor,
então o tipo de retorno é `Future<void>`:

<?code-excerpt "async_await/bin/get_order.dart (main-sig)" replace="/Future<\w+\W/[!$&!]/g;  /$/ ··· }/g"?>
```dart
[!Future<void>!] main() async { ··· }
```

Agora que você tem uma função `async`,
você pode usar a keyword `await` para aguardar a conclusão de um future:

<?code-excerpt "async_await/bin/get_order.dart (print-order)" replace="/await/[!$&!]/g"?>
```dart
print([!await!] createOrderMessage());
```

Como mostram os dois exemplos a seguir, as keywords `async` e `await`
resultam em código assíncrono que se parece muito com código síncrono.
As únicas diferenças estão destacadas no exemplo assíncrono,
que—se sua janela for larga o suficiente—está
à direita do exemplo síncrono.

#### Exemplo: funções síncronas

<?code-excerpt "async_await/bin/get_order_sync_bad.dart (no-warning)" replace="/(\s+\/\/ )(Imagine.*? is )(.*)/$1$2$1$3/g"?>
```dart
String createOrderMessage() {
  var order = fetchUserOrder();
  return 'Your order is: $order';
}

Future<String> fetchUserOrder() =>
    // Imagine that this function is
    // more complex and slow.
    Future.delayed(const Duration(seconds: 2), () => 'Large Latte');

void main() {
  print('Fetching user order...');
  print(createOrderMessage());
}
```

```plaintext
Fetching user order...
Your order is: Instance of 'Future<String>'
```

Como mostrado nos dois exemplos a seguir,
ele opera como código síncrono.

#### Exemplo: funções assíncronas

<?code-excerpt "async_await/bin/get_order.dart" replace="/(\s+\/\/ )(Imagine.*? is )(.*)/$1$2$1$3/g; /async|await/[!$&!]/g; /(Future<\w+\W)( [^f])/[!$1!]$2/g; /4/2/g"?>
```dart
[!Future<String>!] createOrderMessage() [!async!] {
  var order = [!await!] fetchUserOrder();
  return 'Your order is: $order';
}

Future<String> fetchUserOrder() =>
    // Imagine that this function is
    // more complex and slow.
    Future.delayed(const Duration(seconds: 2), () => 'Large Latte');

[!Future<void>!] main() [!async!] {
  print('Fetching user order...');
  print([!await!] createOrderMessage());
}
```

```plaintext
Fetching user order...
Your order is: Large Latte
```

O exemplo assíncrono é diferente de três maneiras:

* O tipo de retorno de `createOrderMessage()` muda
  de `String` para `Future<String>`.
* A keyword **`async`** aparece antes dos corpos das funções
  `createOrderMessage()` e `main()`.
* A keyword **`await`** aparece antes de chamar as funções assíncronas
  `fetchUserOrder()` e `createOrderMessage()`.

:::secondary Key terms
* **async**: Você pode usar a keyword `async` antes do corpo de uma função para marcá-la como
  assíncrona.
* **async function**:  Uma função `async` é uma função rotulada com a keyword `async`.
* **await**: Você pode usar a keyword `await` para obter o resultado completo de uma
  expressão assíncrona. A keyword `await` funciona apenas dentro de uma função `async`.
:::

### Fluxo de execução com async e await

Uma função `async` executa sincronamente até a primeira keyword `await`.
Isso significa que dentro do corpo de uma função `async`,
todo código síncrono antes da primeira keyword `await` executa imediatamente.

### Exemplo: Execução dentro de funções async

Execute o exemplo a seguir para ver como a execução procede
dentro do corpo de uma função `async`.
Qual você acha que será a saída?

<?code-excerpt "async_await/bin/async_example.dart" remove="/\/\/ print/"?>
```dartpad
Future<void> printOrderMessage() async {
  print('Awaiting user order...');
  var order = await fetchUserOrder();
  print('Your order is: $order');
}

Future<String> fetchUserOrder() {
  // Imagine that this function is more complex and slow.
  return Future.delayed(const Duration(seconds: 4), () => 'Large Latte');
}

void main() async {
  countSeconds(4);
  await printOrderMessage();
}

// You can ignore this function - it's here to visualize delay time in this example.
void countSeconds(int s) {
  for (var i = 1; i <= s; i++) {
    Future.delayed(Duration(seconds: i), () => print(i));
  }
}
```

Após executar o código no exemplo anterior, tente inverter as linhas 2 e 3:

<?code-excerpt "async_await/bin/async_example.dart (swap-stmts)" replace="/\/\/ (print)/$1/g"?>
```dart
var order = await fetchUserOrder();
print('Awaiting user order...');
```

Observe que o timing da saída muda, agora que `print('Awaiting user order')`
aparece após a primeira keyword `await` em `printOrderMessage()`.

### Exercício: Pratique usando async e await

O exercício a seguir é um teste unitário falhando
que contém trechos de código parcialmente completos.
Sua tarefa é completar o exercício escrevendo código para fazer os testes passarem.
Você não precisa implementar `main()`.

Para simular operações assíncronas, chame as seguintes funções,
que são fornecidas para você:

| Function           | Type signature                   | Description                                    |
|--------------------|----------------------------------|------------------------------------------------|
| fetchRole()        | `Future<String> fetchRole()`     | Gets a short description of the user's role.   |
| fetchLoginAmount() | `Future<int> fetchLoginAmount()` | Gets the number of times a user has logged in. |

{:.table .table-striped}

#### Part 1: `reportUserRole()`

Adicione código à função `reportUserRole()` para que ela faça o seguinte:

* Retorna um future que completa com a seguinte
  string: `"User role: <user role>"`
  * Nota: Você deve usar o valor real retornado por `fetchRole()`;
    copiar e colar o valor de retorno de exemplo não fará o teste passar.
  * Valor de retorno de exemplo: `"User role: tester"`
* Obtém a role do usuário chamando a função fornecida `fetchRole()`.

#### Part 2: `reportLogins()`

Implemente uma função `async` `reportLogins()` para que ela faça o seguinte:

* Retorna a string `"Total number of logins: <# of logins>"`.
  * Nota: Você deve usar o valor real retornado por `fetchLoginAmount()`;
    copiar e colar o valor de retorno de exemplo não fará o teste passar.
  * Valor de retorno de exemplo de `reportLogins()`: `"Total number of logins: 57"`
* Obtém o número de logins chamando a função fornecida `fetchLoginAmount()`.

```dartpad theme="dark"
// Part 1
// Call the provided async function fetchRole()
// to return the user role.
Future<String> reportUserRole() async {
  // TODO: Implement the reportUserRole function here.
}

// Part 2
// TODO: Implement the reportLogins function here.
// Call the provided async function fetchLoginAmount()
// to return the number of times that the user has logged in.
reportLogins() {}

// The following functions those provided to you to simulate
// asynchronous operations that could take a while.

Future<String> fetchRole() => Future.delayed(_halfSecond, () => _role);
Future<int> fetchLoginAmount() => Future.delayed(_halfSecond, () => _logins);

// The following code is used to test and provide feedback on your solution.
// There is no need to read or modify it.

void main() async {
  print('Testing...');
  List<String> messages = [];
  const passed = 'PASSED';
  const testFailedMessage = 'Test failed for the function:';
  const typoMessage = 'Test failed! Check for typos in your return value';
  try {
    messages
      ..add(_makeReadable(
          testLabel: 'Part 1',
          testResult: await _asyncEquals(
            expected: 'User role: administrator',
            actual: await reportUserRole(),
            typoKeyword: _role,
          ),
          readableErrors: {
            typoMessage: typoMessage,
            'null':
                'Test failed! Did you forget to implement or return from reportUserRole?',
            'User role: Instance of \'Future<String>\'':
                '$testFailedMessage reportUserRole. Did you use the await keyword?',
            'User role: Instance of \'_Future<String>\'':
                '$testFailedMessage reportUserRole. Did you use the await keyword?',
            'User role:':
                '$testFailedMessage reportUserRole. Did you return a user role?',
            'User role: ':
                '$testFailedMessage reportUserRole. Did you return a user role?',
            'User role: tester':
                '$testFailedMessage reportUserRole. Did you invoke fetchRole to fetch the user\'s role?',
          }))
      ..add(_makeReadable(
          testLabel: 'Part 2',
          testResult: await _asyncEquals(
            expected: 'Total number of logins: 42',
            actual: await reportLogins(),
            typoKeyword: _logins.toString(),
          ),
          readableErrors: {
            typoMessage: typoMessage,
            'null':
                'Test failed! Did you forget to implement or return from reportLogins?',
            'Total number of logins: Instance of \'Future<int>\'':
                '$testFailedMessage reportLogins. Did you use the await keyword?',
            'Total number of logins: Instance of \'_Future<int>\'':
                '$testFailedMessage reportLogins. Did you use the await keyword?',
            'Total number of logins: ':
                '$testFailedMessage reportLogins. Did you return the number of logins?',
            'Total number of logins:':
                '$testFailedMessage reportLogins. Did you return the number of logins?',
            'Total number of logins: 57':
                '$testFailedMessage reportLogins. Did you invoke fetchLoginAmount to fetch the number of user logins?',
          }))
      ..removeWhere((m) => m.contains(passed))
      ..toList();

    if (messages.isEmpty) {
      print('Success. All tests passed!');
    } else {
      messages.forEach(print);
    }
  } on UnimplementedError {
    print(
        'Test failed! Did you forget to implement or return from reportUserRole?');
  } catch (e) {
    print('Tried to run solution, but received an exception: $e');
  }
}

const _role = 'administrator';
const _logins = 42;
const _halfSecond = Duration(milliseconds: 500);

// Test helpers.
String _makeReadable({
  required String testResult,
  required Map<String, String> readableErrors,
  required String testLabel,
}) {
  if (readableErrors.containsKey(testResult)) {
    var readable = readableErrors[testResult];
    return '$testLabel $readable';
  } else {
    return '$testLabel $testResult';
  }
}

// Assertions used in tests.
Future<String> _asyncEquals({
  required String expected,
  required dynamic actual,
  required String typoKeyword,
}) async {
  var strActual = actual is String ? actual : actual.toString();
  try {
    if (expected == actual) {
      return 'PASSED';
    } else if (strActual.contains(typoKeyword)) {
      return 'Test failed! Check for typos in your return value';
    } else {
      return strActual;
    }
  } catch (e) {
    return e.toString();
  }
}
```

<details>
  <summary title="Expand for a hint on the async-await exercise.">Hint</summary>

  Did you remember to add the `async` keyword to the `reportUserRole` function?

  Did you remember to use the `await` keyword before invoking `fetchRole()`?

  Remember: `reportUserRole` needs to return a `Future`.

</details>

<details>
  <summary title="Expand for the solution of the async-await exercise.">Solution</summary>

  ```dart
  Future<String> reportUserRole() async {
    final username = await fetchRole();
    return 'User role: $username';
  }

  Future<String> reportLogins() async {
    final logins = await fetchLoginAmount();
    return 'Total number of logins: $logins';
  }
  ```

</details>

## Lidando com erros

Para lidar com erros em uma função `async`, use try-catch:

<?code-excerpt "async_await/bin/try_catch.dart (try-catch)" remove="print(order)"?>
```dart
try {
  print('Awaiting user order...');
  var order = await fetchUserOrder();
} catch (err) {
  print('Caught error: $err');
}
```

Dentro de uma função `async`, você pode escrever
[cláusulas try-catch](/language/error-handling#catch)
da mesma maneira que faria em código síncrono.

### Exemplo: async e await com try-catch

Execute o exemplo a seguir para ver como lidar com um erro
de uma função assíncrona.
Qual você acha que será a saída?

<?code-excerpt "async_await/bin/try_catch.dart"?>
```dartpad
Future<void> printOrderMessage() async {
  try {
    print('Awaiting user order...');
    var order = await fetchUserOrder();
    print(order);
  } catch (err) {
    print('Caught error: $err');
  }
}

Future<String> fetchUserOrder() {
  // Imagine that this function is more complex.
  var str = Future.delayed(
    const Duration(seconds: 4),
    () => throw 'Cannot locate user order',
  );
  return str;
}

void main() async {
  await printOrderMessage();
}
```

### Exercício: Pratique lidando com erros

O exercício a seguir fornece prática lidando com erros com código assíncrono,
usando a abordagem descrita na seção anterior. Para simular operações assíncronas, seu código chamará a seguinte função, que é fornecida para você:

| Function           | Type signature                      | Description                                                      |
|--------------------|-------------------------------------|------------------------------------------------------------------|
| fetchNewUsername() | `Future<String> fetchNewUsername()` | Returns the new username that you can use to replace an old one. |

{:.table .table-striped}

Use `async` e `await` para implementar uma função assíncrona `changeUsername()`
que faça o seguinte:

* Chama a função assíncrona fornecida `fetchNewUsername()`
  e retorna seu resultado.
  * Valor de retorno de exemplo de `changeUsername()`: `"jane_smith_92"`
* Captura qualquer erro que ocorrer e retorna o valor string do erro.
  * Você pode usar o método
    [toString()]({{site.dart-api}}/dart-core/ArgumentError/toString.html)
    para transformar em string tanto
    [Exceptions]({{site.dart-api}}/dart-core/Exception-class.html)
    quanto
    [Errors.]({{site.dart-api}}/dart-core/Error-class.html)

```dartpad theme="dark"
// TODO: Implement changeUsername here.
changeUsername() {}

// The following function is provided to you to simulate
// an asynchronous operation that could take a while and
// potentially throw an exception.

Future<String> fetchNewUsername() =>
    Future.delayed(const Duration(milliseconds: 500), () => throw UserError());

class UserError implements Exception {
  @override
  String toString() => 'New username is invalid';
}

// The following code is used to test and provide feedback on your solution.
// There is no need to read or modify it.

void main() async {
  final List<String> messages = [];
  const typoMessage = 'Test failed! Check for typos in your return value';

  print('Testing...');
  try {
    messages
      ..add(_makeReadable(
          testLabel: '',
          testResult: await _asyncDidCatchException(changeUsername),
          readableErrors: {
            typoMessage: typoMessage,
            _noCatch:
                'Did you remember to call fetchNewUsername within a try/catch block?',
          }))
      ..add(_makeReadable(
          testLabel: '',
          testResult: await _asyncErrorEquals(changeUsername),
          readableErrors: {
            typoMessage: typoMessage,
            _noCatch:
                'Did you remember to call fetchNewUsername within a try/catch block?',
          }))
      ..removeWhere((m) => m.contains(_passed))
      ..toList();

    if (messages.isEmpty) {
      print('Success. All tests passed!');
    } else {
      messages.forEach(print);
    }
  } catch (e) {
    print('Tried to run solution, but received an exception: $e');
  }
}

// Test helpers.
String _makeReadable({
  required String testResult,
  required Map<String, String> readableErrors,
  required String testLabel,
}) {
  if (readableErrors.containsKey(testResult)) {
    final readable = readableErrors[testResult];
    return '$testLabel $readable';
  } else {
    return '$testLabel $testResult';
  }
}

Future<String> _asyncErrorEquals(Function fn) async {
  final result = await fn();
  if (result == UserError().toString()) {
    return _passed;
  } else {
    return 'Test failed! Did you stringify and return the caught error?';
  }
}

Future<String> _asyncDidCatchException(Function fn) async {
  var caught = true;
  try {
    await fn();
  } on UserError catch (_) {
    caught = false;
  }

  if (caught == false) {
    return _noCatch;
  } else {
    return _passed;
  }
}

const _passed = 'PASSED';
const _noCatch = 'NO_CATCH';
```

<details>
  <summary title="Expand for a hint on the error-handling exercise.">Hint</summary>

  Implement `changeUsername` to return the string from `fetchNewUsername` or,
  if that fails, the string value of any error that occurs.

  Remember: You can use a [try-catch statement](/language/error-handling#catch)
  to catch and handle errors.

</details>

<details>
  <summary title="Expand for the solution of the error-handling exercise.">Solution</summary>

  ```dart
  Future<String> changeUsername() async {
    try {
      return await fetchNewUsername();
    } catch (err) {
      return err.toString();
    }
  }
  ```

</details>

## Exercício: Juntando tudo

É hora de praticar o que você aprendeu em um exercício final.
Para simular operações assíncronas, este exercício fornece as funções assíncronas `fetchUsername()` e `logoutUser()`:

| Function        | Type signature                   | Description                                                                   |
|-----------------|----------------------------------|-------------------------------------------------------------------------------|
| fetchUsername() | `Future<String> fetchUsername()` | Returns the name associated with the current user.                            |
| logoutUser()    | `Future<String> logoutUser()`    | Performs logout of current user and returns the username that was logged out. |

{:.table .table-striped}

Escreva o seguinte:

####  Part 1: `addHello()`

* Escreva uma função `addHello()` que recebe um único argumento `String`.
* `addHello()` retorna seu argumento `String` precedido por `'Hello '`.<br>
  Exemplo: `addHello('Jon')` retorna `'Hello Jon'`.

####  Part 2: `greetUser()`

* Escreva uma função `greetUser()` que não recebe argumentos.
* Para obter o username, `greetUser()` chama a função assíncrona
  fornecida `fetchUsername()`.
* `greetUser()` cria uma saudação para o usuário chamando `addHello()`,
  passando o username, e retornando o resultado.<br>
  Exemplo: Se `fetchUsername()` retorna `'Jenny'`, então
  `greetUser()` retorna `'Hello Jenny'`.

####  Part 3: `sayGoodbye()`

* Escreva uma função `sayGoodbye()` que faça o seguinte:
  * Não recebe argumentos.
  * Captura quaisquer erros.
  * Chama a função assíncrona fornecida `logoutUser()`.
* Se `logoutUser()` falhar, `sayGoodbye()` retorna qualquer string que você gostar.
* Se `logoutUser()` tiver sucesso, `sayGoodbye()` retorna a string
  `'<result> Thanks, see you next time'`, onde `<result>` é
  o valor da string retornado ao chamar `logoutUser()`.

```dartpad theme="dark"
// Part 1
addHello(String user) {}

// Part 2
// Call the provided async function fetchUsername()
// to return the username.
greetUser() {}

// Part 3
// Call the provided async function logoutUser()
// to log out the user.
sayGoodbye() {}

// The following functions are provided to you to use in your solutions.

Future<String> fetchUsername() => Future.delayed(_halfSecond, () => 'Jean');

Future<String> logoutUser() => Future.delayed(_halfSecond, _failOnce);

// The following code is used to test and provide feedback on your solution.
// There is no need to read or modify it.

void main() async {
  const didNotImplement =
      'Test failed! Did you forget to implement or return from';

  final List<String> messages = [];

  print('Testing...');
  try {
    messages
      ..add(_makeReadable(
          testLabel: 'Part 1',
          testResult: await _asyncEquals(
              expected: 'Hello Jerry',
              actual: addHello('Jerry'),
              typoKeyword: 'Jerry'),
          readableErrors: {
            _typoMessage: _typoMessage,
            'null': '$didNotImplement addHello?',
            'Hello Instance of \'Future<String>\'':
                'Looks like you forgot to use the \'await\' keyword!',
            'Hello Instance of \'_Future<String>\'':
                'Looks like you forgot to use the \'await\' keyword!',
          }))
      ..add(_makeReadable(
          testLabel: 'Part 2',
          testResult: await _asyncEquals(
              expected: 'Hello Jean',
              actual: await greetUser(),
              typoKeyword: 'Jean'),
          readableErrors: {
            _typoMessage: _typoMessage,
            'null': '$didNotImplement greetUser?',
            'HelloJean':
                'Looks like you forgot the space between \'Hello\' and \'Jean\'',
            'Hello Instance of \'Future<String>\'':
                'Looks like you forgot to use the \'await\' keyword!',
            'Hello Instance of \'_Future<String>\'':
                'Looks like you forgot to use the \'await\' keyword!',
            '{Closure: (String) => dynamic from Function \'addHello\': static.(await fetchUsername())}':
                'Did you place the \'\$\' character correctly?',
            '{Closure \'addHello\'(await fetchUsername())}':
                'Did you place the \'\$\' character correctly?',
          }))
      ..add(_makeReadable(
          testLabel: 'Part 3',
          testResult: await _asyncDidCatchException(sayGoodbye),
          readableErrors: {
            _typoMessage:
                '$_typoMessage. Did you add the text \'Thanks, see you next time\'?',
            'null': '$didNotImplement sayGoodbye?',
            _noCatch:
                'Did you remember to call logoutUser within a try/catch block?',
            'Instance of \'Future<String>\' Thanks, see you next time':
                'Did you remember to use the \'await\' keyword in the sayGoodbye function?',
            'Instance of \'_Future<String>\' Thanks, see you next time':
                'Did you remember to use the \'await\' keyword in the sayGoodbye function?',
          }))
      ..add(_makeReadable(
          testLabel: 'Part 3',
          testResult: await _asyncEquals(
              expected: 'Success! Thanks, see you next time',
              actual: await sayGoodbye(),
              typoKeyword: 'Success'),
          readableErrors: {
            _typoMessage:
                '$_typoMessage. Did you add the text \'Thanks, see you next time\'?',
            'null': '$didNotImplement sayGoodbye?',
            _noCatch:
                'Did you remember to call logoutUser within a try/catch block?',
            'Instance of \'Future<String>\' Thanks, see you next time':
                'Did you remember to use the \'await\' keyword in the sayGoodbye function?',
            'Instance of \'_Future<String>\' Thanks, see you next time':
                'Did you remember to use the \'await\' keyword in the sayGoodbye function?',
            'Instance of \'_Exception\'':
                'CAUGHT Did you remember to return a string?',
          }))
      ..removeWhere((m) => m.contains(_passed))
      ..toList();

    if (messages.isEmpty) {
      print('Success. All tests passed!');
    } else {
      messages.forEach(print);
    }
  } catch (e) {
    print('Tried to run solution, but received an exception: $e');
  }
}

// Test helpers.
String _makeReadable({
  required String testResult,
  required Map<String, String> readableErrors,
  required String testLabel,
}) {
  String? readable;
  if (readableErrors.containsKey(testResult)) {
    readable = readableErrors[testResult];
    return '$testLabel $readable';
  } else if ((testResult != _passed) && (testResult.length < 18)) {
    readable = _typoMessage;
    return '$testLabel $readable';
  } else {
    return '$testLabel $testResult';
  }
}

Future<String> _asyncEquals({
  required String expected,
  required dynamic actual,
  required String typoKeyword,
}) async {
  final strActual = actual is String ? actual : actual.toString();
  try {
    if (expected == actual) {
      return _passed;
    } else if (strActual.contains(typoKeyword)) {
      return _typoMessage;
    } else {
      return strActual;
    }
  } catch (e) {
    return e.toString();
  }
}

Future<String> _asyncDidCatchException(Function fn) async {
  var caught = true;
  try {
    await fn();
  } on Exception catch (_) {
    caught = false;
  }

  if (caught == true) {
    return _passed;
  } else {
    return _noCatch;
  }
}

const _typoMessage = 'Test failed! Check for typos in your return value';
const _passed = 'PASSED';
const _noCatch = 'NO_CATCH';
const _halfSecond = Duration(milliseconds: 500);

String _failOnce() {
  if (_logoutSucceeds) {
    return 'Success!';
  } else {
    _logoutSucceeds = true;
    throw Exception('Logout failed');
  }
}

bool _logoutSucceeds = false;
```

<details>
  <summary title="Expand for a hint on the 'Putting it all together' exercise.">Hint</summary>

  The `greetUser` and `sayGoodbye` functions should be asynchronous,
  while `addHello` should be a normal, synchronous function.

  Remember: You can use a [try-catch statement](/language/error-handling#catch)
  to catch and handle errors.

</details>

<details>
  <summary title="Expand for the solution of the 'Putting it all together' exercise.">Solution</summary>

  ```dart
  String addHello(String user) => 'Hello $user';

  Future<String> greetUser() async {
    final username = await fetchUsername();
    return addHello(username);
  }

  Future<String> sayGoodbye() async {
    try {
      final result = await logoutUser();
      return '$result Thanks, see you next time';
    } catch (e) {
      return 'Failed to logout user: $e';
    }
  }
  ```

</details>

## Quais lints funcionam para futures?

Para capturar erros comuns que surgem ao trabalhar com async e futures,
[habilite](/tools/analysis#individual-rules) os seguintes lints:

* [`discarded_futures`][]
* [`unawaited_futures`][]

[`discarded_futures`]: /tools/linter-rules/discarded_futures
[`unawaited_futures`]: /tools/linter-rules/unawaited_futures

## O que vem a seguir?

Parabéns, você terminou o tutorial! Se você quiser aprender mais, aqui
estão algumas sugestões de para onde ir em seguida:

- Brinque com o [DartPad]({{site.dartpad}}).
- Experimente outro [tutorial](/tutorials).
- Aprenda mais sobre futures e código assíncrono no Dart:
  - [Tutorial de Streams](/libraries/async/using-streams):
    Aprenda como trabalhar com uma sequência de eventos assíncronos.
  - [Concorrência no Dart](/language/concurrency):
    Entenda e aprenda como implementar concorrência no Dart.
  - [Programação assíncrona](/language/async):
    Mergulhe no suporte da linguagem e biblioteca do Dart para codificação assíncrona.
  - [Vídeos Dart do Google][Dart videos]:
    Assista um ou mais dos vídeos sobre codificação assíncrona.
- Obtenha o [Dart SDK](/get-dart)!

[Dart videos]: {{site.yt.playlist}}PLjxrf2q8roU0Net_g1NT5_vOO3s_FR02J
[Future]: {{site.dart-api}}/dart-async/Future-class.html
[style guide]: /effective-dart/style
[documentation guide]: /effective-dart/documentation
[usage guide]: /effective-dart/usage
[design guide]: /effective-dart/design
