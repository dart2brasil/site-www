---
ia-translate: true
title: "Programação assíncrona: futures, async, await"
description: Aprenda e pratique a escrita de código assíncrono no DartPad!
js: [{url: '/assets/js/inject_dartpad.js', defer: true}]
---
<?code-excerpt replace="/ *\/\/\s+ignore_for_file:[^\n]+\n//g; /(^|\n) *\/\/\s+ignore:[^\n]+\n/$1/g; /(\n[^\n]+) *\/\/\s+ignore:[^\n]+\n/$1\n/g"?>
<?code-excerpt plaster="none"?>

Este tutorial ensina como escrever código assíncrono usando
futures (futuros) e as palavras-chave `async` e `await`.
Usando editores DartPad incorporados,
você pode testar seu conhecimento executando código de exemplo
e completando exercícios.

Para aproveitar ao máximo este tutorial, você deve ter o seguinte:

* Conhecimento da [sintaxe básica do Dart](/language).
* Alguma experiência na escrita de código assíncrono em outra linguagem.
* Os lints [`discarded_futures`][] e [`unawaited_futures`][] habilitados.

[`discarded_futures`]: /tools/linter-rules/discarded_futures
[`unawaited_futures`]: /tools/linter-rules/unawaited_futures

Este tutorial cobre o seguinte material:

* Como e quando usar as palavras-chave `async` e `await`.
* Como o uso de `async` e `await` afeta a ordem de execução.
* Como tratar erros de uma chamada assíncrona
  usando expressões `try-catch` em funções `async`.

Tempo estimado para completar este tutorial: 40-60 minutos.

:::note
Esta página usa DartPads incorporados para exibir exemplos e exercícios.
{% render 'dartpads-embedded-troubleshooting.md' %}
:::

Os exercícios neste tutorial têm snippets (trechos) de código parcialmente concluídos.
Você pode usar o DartPad para testar seu conhecimento completando o código e
clicando no botão **Run** (Executar).
**Não edite o código de teste na função `main` ou abaixo**.

Se precisar de ajuda, expanda o dropdown **Hint** (Dica) ou **Solution** (Solução)
após cada exercício.

## Por que o código assíncrono é importante {:#why-asynchronous-code-matters}

Operações assíncronas permitem que seu programa conclua o trabalho
enquanto espera que outra operação termine.
Aqui estão algumas operações assíncronas comuns:

* Buscar dados através de uma rede.
* Escrever em um banco de dados.
* Ler dados de um arquivo.

Tais computações assíncronas geralmente fornecem seu resultado como um `Future`
ou, se o resultado tiver várias partes, como um `Stream`.
Essas computações introduzem assincronia em um programa.
Para acomodar essa assincronia inicial,
outras funções Dart simples também precisam se tornar assíncronas.

Para interagir com esses resultados assíncronos,
você pode usar as palavras-chave `async` e `await`.
A maioria das funções assíncronas são apenas funções Dart async
que dependem, possivelmente em profundidade,
de uma computação inerentemente assíncrona.

### Exemplo: Usando incorretamente uma função assíncrona {:#example-incorrectly-using-an-asynchronous-function}

O exemplo a seguir mostra a maneira errada
de usar uma função assíncrona (`fetchUserOrder()`).
Mais tarde, você corrigirá o exemplo usando `async` e `await`.
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
    Future.delayed(
      const Duration(seconds: 2),
      () => 'Large Latte',
    );

void main() {
  print(createOrderMessage());
}
```

Aqui está o porquê do exemplo não conseguir imprimir o valor
que `fetchUserOrder()` eventualmente produz:

* `fetchUserOrder()` é uma função assíncrona que, após um atraso,
  fornece uma string que descreve o pedido do usuário: um "Large Latte".
* Para obter o pedido do usuário, `createOrderMessage()` deve chamar `fetchUserOrder()`
  e esperar que ela termine. Como `createOrderMessage()` *não* espera
  que `fetchUserOrder()` termine, `createOrderMessage()` não consegue
  obter o valor da string que `fetchUserOrder()` eventualmente fornece.
* Em vez disso, `createOrderMessage()` obtém uma representação do trabalho pendente a ser
  feito: um future (futuro) não concluído.
  Você aprenderá mais sobre futures na próxima seção.
* Como `createOrderMessage()` não consegue obter o valor que descreve o pedido do usuário,
  o exemplo não consegue imprimir "Large Latte" no console e, em vez disso,
  imprime "Seu pedido é: Instance of '_Future\<String\>'".

Nas próximas seções, você aprenderá sobre futures e sobre como trabalhar com futures
(usando `async` e `await`)
para que você possa escrever o código necessário para fazer `fetchUserOrder()`
imprimir o valor desejado ("Large Latte") no console.

:::secondary Key terms
* **operação síncrona**: Uma operação síncrona impede que outras operações
  sejam executadas até que ela seja concluída.
* **função síncrona**: Uma função síncrona executa apenas
  operações síncronas.
* **operação assíncrona**: Uma vez iniciada, uma operação assíncrona permite
  que outras operações sejam executadasantes que ela seja concluída.
* **função assíncrona**: Uma função assíncrona executa pelo menos uma
  operação assíncrona e também pode executar operações _síncronas_.
:::


## O que é um future? {:#what-is-a-future}

Um future (futuro) (com "f" minúsculo) é uma instância
da classe [Future][] (com "F" maiúsculo).
Um future representa o resultado de uma operação assíncrona,
e pode ter dois estados: não concluído ou concluído.

:::note
_Não concluído_ é um termo Dart que se refere ao estado de um future
antes que ele tenha produzido um valor.
:::

### Não concluído {:#uncompleted}

Quando você chama uma função assíncrona, ela retorna um future não concluído.
Esse future está esperando que a operação assíncrona da função
termine ou lance um erro.

### Concluído {:#completed}

Se a operação assíncrona for bem-sucedida,
o future é concluído com um valor.
Caso contrário, ele é concluído com um erro.

#### Concluindo com um valor {:#completing-with-a-value}

Um future do tipo `Future<T>` é concluído com um valor do tipo `T`.
Por exemplo, um future com o tipo `Future<String>` produz um valor de string.
Se um future não produzir um valor utilizável,
então o tipo do future é `Future<void>`.

#### Concluindo com um erro {:#completing-with-an-error}

Se a operação assíncrona realizada pela função falhar por qualquer motivo,
o future é concluído com um erro.

### Exemplo: Introduzindo futures {:#example-introducing-futures}

No exemplo a seguir, `fetchUserOrder()` retorna um future
que é concluído após imprimir no console.
Como ele não retorna um valor utilizável,
`fetchUserOrder()` tem o tipo `Future<void>`.
Antes de executar o exemplo,
tente prever qual será impresso primeiro:
"Large Latte" ou "Buscando pedido do usuário...".

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
mesmo que `fetchUserOrder()` seja executado antes da chamada de `print()` na linha 8,
o console mostra a saída da linha 8 ("Buscando pedido do usuário...")
antes da saída de `fetchUserOrder()` ("Large Latte").
Isso ocorre porque `fetchUserOrder()` atrasa antes de imprimir "Large Latte".

### Exemplo: Concluindo com um erro {:#example-completing-with-an-error}

Execute o exemplo a seguir para ver como um future é concluído com um erro.
Um pouco mais adiante, você aprenderá como lidar com o erro.

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

Neste exemplo, `fetchUserOrder()` é concluído
com um erro indicando que o ID do usuário é inválido.

Você aprendeu sobre futures e como eles são concluídos,
mas como você usa os resultados de funções assíncronas?
Na próxima seção, você aprenderá como obter resultados
com as palavras-chave `async` e `await`.

:::secondary Quick review
* Uma instância de [Future\<T\>][Future] produz um valor do tipo `T`.
* Se um future não produzir um valor utilizável,
  então o tipo do future é `Future<void>`.
* Um future pode estar em um de dois estados: não concluído ou concluído.
* Quando você chama uma função que retorna um future,
  a função enfileira o trabalho a ser feito e retorna um future não concluído.
* Quando a operação de um future termina,
  o future é concluído com um valor ou com um erro.

**Termos principais:**

* **Future**: a classe [Future][] do Dart.
* **future**: uma instância da classe `Future` do Dart.
:::

## Trabalhando com futures: async e await {:#working-with-futures-async-and-await}

As palavras-chave `async` e `await` fornecem uma maneira declarativa
de definir funções assíncronas e usar seus resultados.
Lembre-se destas duas diretrizes básicas ao usar `async` e `await`:

* __Para definir uma função async, adicione `async` antes do corpo da função:__
* __A palavra-chave `await` funciona apenas em funções `async`.__

Aqui está um exemplo que converte `main()`
de uma função síncrona para assíncrona.

Primeiro, adicione a palavra-chave `async` antes do corpo da função:

<?code-excerpt "async_await/bin/get_order_sync_bad.dart (main-sig)" replace="/main\(\)/$& async/g; /async/[!$&!]/g; /$/ ··· }/g"?>
```dart
void main() [!async!] { ··· }
```

Se a função tiver um tipo de retorno declarado,
atualize o tipo para ser `Future<T>`,
onde `T` é o tipo do valor que a função retorna.
Se a função não retornar explicitamente um valor,
então o tipo de retorno é `Future<void>`:

<?code-excerpt "async_await/bin/get_order.dart (main-sig)" replace="/Future<\w+\W/[!$&!]/g;  /$/ ··· }/g"?>
```dart
[!Future<void>!] main() async { ··· }
```

Agora que você tem uma função `async`,
você pode usar a palavra-chave `await` para esperar que um future seja concluído:

<?code-excerpt "async_await/bin/get_order.dart (print-order)" replace="/await/[!$&!]/g"?>
```dart
print([!await!] createOrderMessage());
```

Como mostram os dois exemplos a seguir, as palavras-chave `async` e `await`
resultam em código assíncrono que se parece muito com código síncrono.
As únicas diferenças são destacadas no exemplo assíncrono,
que—se sua janela for larga o suficiente—está
à direita do exemplo síncrono.

#### Exemplo: funções síncronas {:#example-synchronous-functions}

<?code-excerpt "async_await/bin/get_order_sync_bad.dart (no-warning)" replace="/(\s+\/\/ )(Imagine.*? is )(.*)/$1$2$1$3/g"?>
```dart
String createOrderMessage() {
  var order = fetchUserOrder();
  return 'Your order is: $order';
}

Future<String> fetchUserOrder() =>
    // Imagine that this function is
    // more complex and slow.
    Future.delayed(
      const Duration(seconds: 2),
      () => 'Large Latte',
    );

void main() {
  print('Fetching user order...');
  print(createOrderMessage());
}
```

```plaintext
Buscando pedido do usuário...
Seu pedido é: Instance of 'Future<String>'
```

Como mostrado nos dois exemplos a seguir,
ele opera como código síncrono.

#### Exemplo: funções assíncronas {:#example-asynchronous-functions}

<?code-excerpt "async_await/bin/get_order.dart" replace="/(\s+\/\/ )(Imagine.*? is )(.*)/$1$2$1$3/g; /async|await/[!$&!]/g; /(Future<\w+\W)( [^f])/[!$1!]$2/g; /4/2/g"?>
```dart
[!Future<String>!] createOrderMessage() [!async!] {
  var order = [!await!] fetchUserOrder();
  return 'Your order is: $order';
}

Future<String> fetchUserOrder() =>
    // Imagine that this function is
    // more complex and slow.
    Future.delayed(
      const Duration(seconds: 2),
      () => 'Large Latte',
    );

[!Future<void>!] main() [!async!] {
  print('Fetching user order...');
  print([!await!] createOrderMessage());
}
```

```plaintext
Buscando pedido do usuário...
Seu pedido é: Large Latte
```

O exemplo assíncrono é diferente de três maneiras:

* O tipo de retorno para `createOrderMessage()` muda
  de `String` para `Future<String>`.
* A palavra-chave **`async`** aparece antes dos corpos das funções para
  `createOrderMessage()` e `main()`.
* A palavra-chave **`await`** aparece antes de chamar as funções assíncronas
  `fetchUserOrder()` e `createOrderMessage()`.

:::secondary Key terms
* **async**: Você pode usar a palavra-chave `async` antes do corpo de uma função para marcá-la como
  assíncrona.
* **função async**: Uma função `async` é uma função rotulada com a
  palavra-chave `async`.
* **await**: Você pode usar a palavra-chave `await` para obter o resultado concluído de uma
  expressão assíncrona. A palavra-chave `await` funciona apenas dentro de uma função `async`.
:::

### Fluxo de execução com async e await {:#execution-flow-with-async-and-await}

Uma função `async` é executada de forma síncrona até a primeira palavra-chave `await`.
Isso significa que, dentro de um corpo de função `async`,
todo o código síncrono antes da primeira palavra-chave `await` é executado imediatamente.

### Exemplo: Execução dentro de funções async {:#example-execution-within-async-functions}

Execute o exemplo a seguir para ver como a execução prossegue
dentro de um corpo de função `async`.
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

Depois de executar o código no exemplo anterior, tente inverter as linhas 2 e 3:

<?code-excerpt "async_await/bin/async_example.dart (swap-stmts)" replace="/\/\/ (print)/$1/g"?>
```dart
var order = await fetchUserOrder();
print('Awaiting user order...');
```

Observe que o tempo da saída muda, agora que `print('Aguardando pedido do usuário')`
aparece depois da primeira palavra-chave `await` em `printOrderMessage()`.

### Exercício: Pratique o uso de async e await {:#exercise-practice-using-async-and-await}

O exercício a seguir é um teste de unidade com falha
que contém snippets de código parcialmente concluídos.
Sua tarefa é completar o exercício escrevendo código para fazer os testes passarem.
Você não precisa implementar `main()`.

Para simular operações assíncronas, chame as seguintes funções,
que são fornecidas para você:

| Função             | Assinatura de tipo                  | Descrição                                   |
|---------------------|-------------------------------------|---------------------------------------------|
| fetchRole()        | `Future<String> fetchRole()`        | Obtém uma pequena descrição da função do usuário. |
| fetchLoginAmount() | `Future<int> fetchLoginAmount()`   | Obtém o número de vezes que um usuário fez login. |

{:.table .table-striped}

#### Parte 1: `reportUserRole()` {:#part-1-reportuserrole}

Adicione código à função `reportUserRole()` para que ela faça o seguinte:

* Retorna um future que é concluído com a seguinte
  string: `"Função do usuário: <função do usuário>"`
  * Observação: Você deve usar o valor real retornado por `fetchRole()`;
    copiar e colar o valor de retorno do exemplo não fará o teste passar.
  * Exemplo de valor de retorno: `"Função do usuário: tester"`
* Obtém a função do usuário chamando a função fornecida `fetchRole()`.

#### Parte 2: `reportLogins()` {:#part-2-reportlogins}

Implemente uma função `async` `reportLogins()` para que ela faça o seguinte:

* Retorna a string `"Número total de logins: <# de logins>"`.
  * Observação: Você deve usar o valor real retornado por `fetchLoginAmount()`;
    copiar e colar o valor de retorno do exemplo não fará o teste passar.
  * Exemplo de valor de retorno de `reportLogins()`: `"Número total de logins: 57"`
* Obtém o número de logins chamando a função fornecida `fetchLoginAmount()`.

```dartpad theme="dark"
// Parte 1
// Chame a função assíncrona fornecida fetchRole()
// para retornar a função do usuário.
Future<String> reportUserRole() async {
  // TODO: Implemente a função reportUserRole aqui.
}

// Parte 2
// TODO: Implemente a função reportLogins aqui.
// Chame a função assíncrona fornecida fetchLoginAmount()
// para retornar o número de vezes que o usuário fez login.
reportLogins() {}

// As seguintes funções são fornecidas para simular
// operações assíncronas que podem levar um tempo.

Future<String> fetchRole() => Future.delayed(_halfSecond, () => _role);
Future<int> fetchLoginAmount() => Future.delayed(_halfSecond, () => _logins);

// O código a seguir é usado para testar e fornecer feedback sobre sua solução.
// Não há necessidade de ler ou modificar isso.

void main() async {
  print('Testando...');
  List<String> messages = [];
  const passed = 'APROVADO';
  const testFailedMessage = 'Teste falhou para a função:';
  const typoMessage = 'Teste falhou! Verifique se há erros de digitação no seu valor de retorno';
  try {
    messages
      ..add(_makeReadable(
          testLabel: 'Parte 1',
          testResult: await _asyncEquals(
            expected: 'Função do usuário: administrator',
            actual: await reportUserRole(),
            typoKeyword: _role,
          ),
          readableErrors: {
            typoMessage: typoMessage,
            'null':
                'Teste falhou! Você esqueceu de implementar ou retornar de reportUserRole?',
            'Função do usuário: Instance of \'Future<String>\'':
                '$testFailedMessage reportUserRole. Você usou a palavra-chave await?',
            'Função do usuário: Instance of \'_Future<String>\'':
                '$testFailedMessage reportUserRole. Você usou a palavra-chave await?',
            'Função do usuário:':
                '$testFailedMessage reportUserRole. Você retornou uma função de usuário?',
            'Função do usuário: ':
                '$testFailedMessage reportUserRole. Você retornou uma função de usuário?',
            'Função do usuário: tester':
                '$testFailedMessage reportUserRole. Você invocou fetchRole para buscar a função do usuário?',
          }))
      ..add(_makeReadable(
          testLabel: 'Parte 2',
          testResult: await _asyncEquals(
            expected: 'Número total de logins: 42',
            actual: await reportLogins(),
            typoKeyword: _logins.toString(),
          ),
          readableErrors: {
            typoMessage: typoMessage,
            'null':
                'Teste falhou! Você esqueceu de implementar ou retornar de reportLogins?',
            'Número total de logins: Instance of \'Future<int>\'':
                '$testFailedMessage reportLogins. Você usou a palavra-chave await?',
            'Número total de logins: Instance of \'_Future<int>\'':
                '$testFailedMessage reportLogins. Você usou a palavra-chave await?',
            'Número total de logins: ':
                '$testFailedMessage reportLogins. Você retornou o número de logins?',
             'Número total de logins:':
                '$testFailedMessage reportLogins. Você retornou o número de logins?',
            'Número total de logins: 57':
                '$testFailedMessage reportLogins. Você invocou fetchLoginAmount para buscar o número de logins do usuário?',
          }))
      ..removeWhere((m) => m.contains(passed))
      ..toList();

    if (messages.isEmpty) {
      print('Sucesso. Todos os testes passaram!');
    } else {
      messages.forEach(print);
    }
  } on UnimplementedError {
    print(
        'Teste falhou! Você esqueceu de implementar ou retornar de reportUserRole?');
  } catch (e) {
    print('Tentou executar a solução, mas recebeu uma exceção: $e');
  }
}

const _role = 'administrator';
const _logins = 42;
const _halfSecond = Duration(milliseconds: 500);

// Auxiliares de teste.
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

// Asserções usadas em testes.
Future<String> _asyncEquals({
  required String expected,
  required dynamic actual,
  required String typoKeyword,
}) async {
  var strActual = actual is String ? actual : actual.toString();
  try {
    if (expected == actual) {
      return 'APROVADO';
    } else if (strActual.contains(typoKeyword)) {
      return 'Teste falhou! Verifique se há erros de digitação no seu valor de retorno';
    } else {
      return strActual;
    }
  } catch (e) {
    return e.toString();
  }
}
```

<details>
  <summary title="Expandir para uma dica sobre o exercício async-await.">Dica</summary>

  Você se lembrou de adicionar a palavra-chave `async` à função `reportUserRole`?

  Você se lembrou de usar a palavra-chave `await` antes de invocar `fetchRole()`?

  Lembre-se: `reportUserRole` precisa retornar um `Future`.

</details>

<details>
  <summary title="Expandir para a solução do exercício async-await.">Solução</summary>

  ```dart
  Future<String> reportUserRole() async {
    final username = await fetchRole();
    return 'Função do usuário: $username';
  }
  
  Future<String> reportLogins() async {
    final logins = await fetchLoginAmount();
    return 'Número total de logins: $logins';
  }
  ```

</details>

## Tratamento de erros {:#handling-errors}

Para tratar erros em uma função `async`, use try-catch:

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
da mesma forma que faria em código síncrono.

### Exemplo: async e await com try-catch {:#example-async-and-await-with-try-catch}

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
      () => throw 'Cannot locate user order');
  return str;
}

void main() async {
  await printOrderMessage();
}
```

### Exercício: Pratique o tratamento de erros {:#exercise-practice-handling-errors}

O exercício a seguir oferece prática no tratamento de erros com código assíncrono,
usando a abordagem descrita na seção anterior. Para simular operações assíncronas,
seu código chamará a seguinte função, que é fornecida para você:

| Função           | Assinatura do tipo               | Descrição                                                               |
|--------------------|---------------------------------|------------------------------------------------------------------------|
| fetchNewUsername() | `Future<String> fetchNewUsername()` | Retorna o novo nome de usuário que você pode usar para substituir um antigo. |

{:.table .table-striped}

Use `async` e `await` para implementar uma função assíncrona `changeUsername()`
que faça o seguinte:

* Chama a função assíncrona fornecida `fetchNewUsername()`
  e retorna seu resultado.
  * Exemplo de valor de retorno de `changeUsername()`: `"jane_smith_92"`
* Captura qualquer erro que ocorra e retorna o valor string do erro.
  * Você pode usar o método
    [toString()]({{site.dart-api}}/dart-core/ArgumentError/toString.html)
    para transformar em string tanto
    [Exceptions]({{site.dart-api}}/dart-core/Exception-class.html)
    quanto
    [Errors.]({{site.dart-api}}/dart-core/Error-class.html) (Erros).

```dartpad theme="dark"
// TODO: Implemente changeUsername aqui.
changeUsername() {}

// A função a seguir é fornecida para você simular
// uma operação assíncrona que pode levar um tempo e
// potencialmente lançar uma exceção.

Future<String> fetchNewUsername() =>
    Future.delayed(const Duration(milliseconds: 500), () => throw UserError());

class UserError implements Exception {
  @override
  String toString() => 'Novo nome de usuário é inválido';
}

// O código a seguir é usado para testar e fornecer feedback sobre sua solução.
// Não é necessário ler ou modificar.

void main() async {
  final List<String> messages = [];
  const typoMessage = 'Teste falhou! Verifique se há erros de digitação em seu valor de retorno';

  print('Testando...');
  try {
    messages
      ..add(_makeReadable(
          testLabel: '',
          testResult: await _asyncDidCatchException(changeUsername),
          readableErrors: {
            typoMessage: typoMessage,
            _noCatch:
                'Você se lembrou de chamar fetchNewUsername dentro de um bloco try/catch?',
          }))
      ..add(_makeReadable(
          testLabel: '',
          testResult: await _asyncErrorEquals(changeUsername),
          readableErrors: {
            typoMessage: typoMessage,
            _noCatch:
                'Você se lembrou de chamar fetchNewUsername dentro de um bloco try/catch?',
          }))
      ..removeWhere((m) => m.contains(_passed))
      ..toList();

    if (messages.isEmpty) {
      print('Sucesso. Todos os testes passaram!');
    } else {
      messages.forEach(print);
    }
  } catch (e) {
    print('Tentei executar a solução, mas recebi uma exceção: $e');
  }
}

// Auxiliares de teste.
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
    return 'Teste falhou! Você transformou em string e retornou o erro capturado?';
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

const _passed = 'PASSOU';
const _noCatch = 'NAO_CAPTUROU';
```

<details>
  <summary title="Expandir para uma dica sobre o exercício de tratamento de erros.">Dica</summary>

  Implemente `changeUsername` para retornar a string de `fetchNewUsername` ou,
  se isso falhar, o valor string de qualquer erro que ocorra.
  
  Lembre-se: Você pode usar uma [declaração try-catch](/language/error-handling#catch)
  para capturar e tratar erros.

</details>

<details>
  <summary title="Expandir para a solução do exercício de tratamento de erros.">Solução</summary>

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

## Exercício: Juntando tudo {:#exercise-putting-it-all-together}

É hora de praticar o que você aprendeu em um exercício final.
Para simular operações assíncronas, este exercício fornece as funções
assíncronas `fetchUsername()` e `logoutUser()`:

| Função        | Assinatura do tipo         | Descrição                                                                |
|-----------------|-----------------------------|-------------------------------------------------------------------------|
| fetchUsername() | `Future<String> fetchUsername()` | Retorna o nome associado ao usuário atual.                             |
| logoutUser()    | `Future<String> logoutUser()`    | Realiza o logout do usuário atual e retorna o nome de usuário que foi desconectado. |

{:.table .table-striped}

Escreva o seguinte:

#### Parte 1: `addHello()` {:#part-1-addhello}

* Escreva uma função `addHello()` que receba um único argumento `String`.
* `addHello()` retorna seu argumento `String` precedido por `'Olá '`.<br>
  Exemplo: `addHello('Jon')` retorna `'Olá Jon'`.

#### Parte 2: `greetUser()` {:#part-2-greetuser}

* Escreva uma função `greetUser()` que não receba argumentos.
* Para obter o nome de usuário, `greetUser()` chama a função assíncrona
  fornecida `fetchUsername()`.
* `greetUser()` cria uma saudação para o usuário chamando `addHello()`,
  passando-lhe o nome de usuário e retornando o resultado.<br>
  Exemplo: Se `fetchUsername()` retornar `'Jenny'`, então
  `greetUser()` retorna `'Olá Jenny'`.

#### Parte 3: `sayGoodbye()` {:#part-3-saygoodbye}

* Escreva uma função `sayGoodbye()` que faça o seguinte:
  * Não recebe argumentos.
  * Captura quaisquer erros.
  * Chama a função assíncrona fornecida `logoutUser()`.
* Se `logoutUser()` falhar, `sayGoodbye()` retorna qualquer string que você quiser.
* Se `logoutUser()` for bem-sucedida, `sayGoodbye()` retorna a string
  `'<resultado> Obrigado, até a próxima'`, onde `<resultado>` é
  o valor string retornado pela chamada de `logoutUser()`.

```dartpad theme="dark"
// Parte 1
addHello(String user) {}

// Parte 2
// Chame a função assíncrona fornecida fetchUsername()
// para retornar o nome de usuário.
greetUser() {}

// Parte 3
// Chame a função assíncrona fornecida logoutUser()
// para desconectar o usuário.
sayGoodbye() {}

// As seguintes funções são fornecidas para você usar em suas soluções.

Future<String> fetchUsername() => Future.delayed(_halfSecond, () => 'Jean');

Future<String> logoutUser() => Future.delayed(_halfSecond, _failOnce);

// O código a seguir é usado para testar e fornecer feedback sobre sua solução.
// Não é necessário ler ou modificar.

void main() async {
  const didNotImplement =
      'Teste falhou! Você esqueceu de implementar ou retornar de';

  final List<String> messages = [];

  print('Testando...');
  try {
    messages
      ..add(_makeReadable(
          testLabel: 'Parte 1',
          testResult: await _asyncEquals(
              expected: 'Olá Jerry',
              actual: addHello('Jerry'),
              typoKeyword: 'Jerry'),
          readableErrors: {
            _typoMessage: _typoMessage,
            'null': '$didNotImplement addHello?',
            'Olá Instance of \'Future<String>\'':
                'Parece que você esqueceu de usar a palavra-chave \'await\'!',
            'Olá Instance of \'_Future<String>\'':
                'Parece que você esqueceu de usar a palavra-chave \'await\'!',
          }))
      ..add(_makeReadable(
          testLabel: 'Parte 2',
          testResult: await _asyncEquals(
              expected: 'Olá Jean',
              actual: await greetUser(),
              typoKeyword: 'Jean'),
          readableErrors: {
            _typoMessage: _typoMessage,
            'null': '$didNotImplement greetUser?',
            'OláJean':
                'Parece que você esqueceu do espaço entre \'Olá\' e \'Jean\'',
            'Olá Instance of \'Future<String>\'':
                'Parece que você esqueceu de usar a palavra-chave \'await\'!',
            'Olá Instance of \'_Future<String>\'':
                'Parece que você esqueceu de usar a palavra-chave \'await\'!',
            '{Closure: (String) => dynamic from Function \'addHello\': static.(await fetchUsername())}':
                'Você colocou o caractere \'\$\' corretamente?',
            '{Closure \'addHello\'(await fetchUsername())}':
                'Você colocou o caractere \'\$\' corretamente?',
          }))
      ..add(_makeReadable(
          testLabel: 'Parte 3',
          testResult: await _asyncDidCatchException(sayGoodbye),
          readableErrors: {
            _typoMessage:
                '$_typoMessage. Você adicionou o texto \'Obrigado, até a próxima\'?',
            'null': '$didNotImplement sayGoodbye?',
            _noCatch:
                'Você se lembrou de chamar logoutUser dentro de um bloco try/catch?',
            'Instance of \'Future<String>\' Obrigado, até a próxima':
                'Você se lembrou de usar a palavra-chave \'await\' na função sayGoodbye?',
            'Instance of \'_Future<String>\' Obrigado, até a próxima':
                'Você se lembrou de usar a palavra-chave \'await\' na função sayGoodbye?',
          }))
      ..add(_makeReadable(
          testLabel: 'Parte 3',
          testResult: await _asyncEquals(
              expected: 'Sucesso! Obrigado, até a próxima',
              actual: await sayGoodbye(),
              typoKeyword: 'Sucesso'),
          readableErrors: {
            _typoMessage:
                '$_typoMessage. Você adicionou o texto \'Obrigado, até a próxima\'?',
            'null': '$didNotImplement sayGoodbye?',
            _noCatch:
                'Você se lembrou de chamar logoutUser dentro de um bloco try/catch?',
            'Instance of \'Future<String>\' Obrigado, até a próxima':
                'Você se lembrou de usar a palavra-chave \'await\' na função sayGoodbye?',
            'Instance of \'_Future<String>\' Obrigado, até a próxima':
                'Você se lembrou de usar a palavra-chave \'await\' na função sayGoodbye?',
            'Instance of \'_Exception\'':
                'CAPTURADO Você se lembrou de retornar uma string?',
          }))
      ..removeWhere((m) => m.contains(_passed))
      ..toList();

    if (messages.isEmpty) {
      print('Sucesso. Todos os testes passaram!');
    } else {
      messages.forEach(print);
    }
  } catch (e) {
    print('Tentei executar a solução, mas recebi uma exceção: $e');
  }
}

// Auxiliares de teste.
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

const _typoMessage = 'Teste falhou! Verifique se há erros de digitação em seu valor de retorno';
const _passed = 'PASSOU';
const _noCatch = 'NAO_CAPTUROU';
const _halfSecond = Duration(milliseconds: 500);

String _failOnce() {
  if (_logoutSucceeds) {
    return 'Sucesso!';
  } else {
    _logoutSucceeds = true;
    throw Exception('Logout falhou');
  }
}

bool _logoutSucceeds = false;
```

<details>
  <summary title="Expandir para uma dica sobre o exercício 'Juntando tudo'.">Dica</summary>

  As funções `greetUser` e `sayGoodbye` devem ser assíncronas,
  enquanto `addHello` deve ser uma função normal e síncrona.

  Lembre-se: Você pode usar uma [declaração try-catch](/language/error-handling#catch)
  para capturar e tratar erros.

</details>

<details>
  <summary title="Expandir para a solução do exercício 'Juntando tudo'.">Solução</summary>

  ```dart
  String addHello(String user) => 'Olá $user';
  
  Future<String> greetUser() async {
    final username = await fetchUsername();
    return addHello(username);
  }
  
  Future<String> sayGoodbye() async {
    try {
      final result = await logoutUser();
      return '$result Obrigado, até a próxima';
    } catch (e) {
      return 'Falha ao desconectar o usuário: $e';
    }
  }
  ```

</details>

## Quais lints funcionam para futures? {:#which-lints-work-for-futures}

Para detectar erros comuns que surgem ao trabalhar com async e futures (futuros),
[ative](/tools/analysis#individual-rules) os seguintes lints (analisadores de código):

* [`discarded_futures`][]
* [`unawaited_futures`][]

[`discarded_futures`]: /tools/linter-rules/discarded_futures
[`unawaited_futures`]: /tools/linter-rules/unawaited_futures

## Qual o próximo passo? {:#what-s-next}

Parabéns, você concluiu o tutorial! Se você quiser aprender mais, aqui
estão algumas sugestões de para onde ir em seguida:

- Brinque com o [DartPad]({{site.dartpad}}).
- Experimente outro [tutorial](/tutorials).
- Aprenda mais sobre futures e código assíncrono em Dart:
  - [Tutorial de Streams](/libraries/async/using-streams):
    Aprenda como trabalhar com uma sequência de eventos assíncronos.
  - [Concorrência em Dart](/language/concurrency):
    Entenda e aprenda como implementar a concorrência em Dart.
  - [Suporte a assincronia](/language/async):
    Mergulhe no suporte da linguagem e biblioteca Dart para codificação assíncrona.
  - [Vídeos do Dart do Google][Dart videos]:
    Assista a um ou mais dos vídeos sobre codificação assíncrona.
- Obtenha o [SDK do Dart](/get-dart)!

[Dart videos]: {{site.yt.playlist}}PLjxrf2q8roU0Net_g1NT5_vOO3s_FR02J
[Future]: {{site.dart-api}}/dart-async/Future-class.html
[style guide]: /effective-dart/style (guia de estilo)
[documentation guide]: /effective-dart/documentation (guia de documentação)
[usage guide]: /effective-dart/usage (guia de uso)
[design guide]: /effective-dart/design (guia de design)
