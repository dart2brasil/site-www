---
ia-translate: true
title: Dart cheatsheet
breadcrumb: Cheatsheet
description: Interactively learn (or relearn) some of Dart's unique features.
maxTocDepth: 2
---
<?code-excerpt replace="/ *\/\/\s+ignore_for_file:[^\n]+\n//g; /(^|\n) *\/\/\s+ignore:[^\n]+\n/$1/g; /(\n[^\n]+) *\/\/\s+ignore:[^\n]+\n/$1\n/g"?>

A linguagem Dart foi projetada para ser fácil de aprender para
programadores que vêm de outras linguagens,
mas tem algumas funcionalidades únicas.
Este tutorial guia você pelas
funcionalidades mais importantes desta linguagem.

Os editores incorporados neste tutorial têm trechos de código parcialmente completos.
Você pode usar esses editores para testar seu conhecimento completando o código e
clicando no botão **Run**. Os editores também contêm código de teste completo;
**não edite o código de teste**, mas sinta-se livre para estudá-lo para aprender sobre testes.

Se precisar de ajuda, expanda o menu suspenso **Solução para...** abaixo de cada DartPad
para uma explicação e a resposta.

:::note
Esta página usa DartPads incorporados para exibir exemplos executáveis.
{% render 'dartpads-embedded-troubleshooting.md' %}
:::

## Interpolação de strings {:#string-interpolation}

Para colocar o valor de uma expressão dentro de uma string, use `${expressão}`.
Se a expressão for um identificador, você pode omitir `{}`.

Aqui estão alguns exemplos de uso da interpolação de strings:

| String                      | Resultado                             |
|-----------------------------|------------------------------------|
| `'${3 + 2}'`                | `'5'`                              |
| `'${"palavra".toUpperCase()}'` | `'PALAVRA'`                           |
| `'$meuObjeto'`               | O valor de `meuObjeto.toString()` |

### Exercise

A função a seguir recebe dois inteiros como parâmetros.
Faça com que ela retorne uma string contendo ambos os inteiros separados por um espaço.
Por exemplo, `stringify(2, 3)` deve retornar `'2 3'`.

```dartpad theme="dark"
String stringify(int x, int y) {
  TODO('Retorne uma string formatada aqui');
}


// Tests your solution (Don't edit!):
void main() {
  assert(stringify(2, 3) == '2 3',
      "Seu método stringify retornou '${stringify(2, 3)}' em vez de '2 3'");
  print('Sucesso!');
}
```

<details>
  <summary>Solução para o exemplo de interpolação de string</summary>

  Tanto `x` quanto `y` são valores simples,
  e a interpolação de string do Dart irá lidar
  com a conversão deles para representações de string.
  Tudo o que você precisa fazer é usar o operador `$` para
  referenciá-los dentro de aspas simples, com um espaço entre eles:

  ```dart
  String stringify(int x, int y) {
    return '$x $y';
  }
  ```

</details>


## Variáveis anuláveis {:#nullable-variables}

Dart impõe segurança nula (null safety) *sound*.
Isso significa que os valores não podem ser nulos, a menos que você diga que podem ser.
Em outras palavras, os tipos são definidos por padrão como não anuláveis.

Por exemplo, considere o seguinte código.
Com segurança nula, este código retorna um erro.
Uma variável do tipo `int` não pode ter o valor `null`:

<?code-excerpt "misc/bin/cheatsheet/nullable.dart (invalid-null)" replace="/null;/[!null!];/g"?>
```dart
int a = [!null!]; // INVALID.
```

Ao criar uma variável, adicione `?` ao tipo para indicar
que a variável pode ser `null`:

<?code-excerpt "misc/bin/cheatsheet/nullable.dart (valid-null)" replace="/int\?/[!int?!]/g"?>
```dart
[!int?!] a = null; // Valid.
```

Você pode simplificar um pouco esse código porque, em todas as versões do Dart,
`null` é o valor padrão para variáveis não inicializadas:

<?code-excerpt "misc/bin/cheatsheet/nullable.dart (simple-null)"?>
```dart
int? a; // The initial value of a is null.
```

Para saber mais sobre segurança nula no Dart,
leia o [guia de segurança nula](/null-safety).

### Exercise

Declare duas variáveis neste DartPad:

* Uma `String` anulável chamada `name` com o valor `'Jane'`.
* Uma `String` anulável chamada `address` com o valor `null`.

Ignore todos os erros iniciais no DartPad.

```dartpad theme="dark"
// TODO: Declare the two variables here


// Tests your solution (Don't edit!):
void main() {
  try {
    if (name == 'Jane' && address == null) {
      // Verify that "name" is nullable.
      name = null;
      print('Sucesso!');
    } else {
      print('Não está totalmente correto, tente novamente!');
    }
  } catch (e) {
    print('Exceção: ${e.runtimeType}');
  }
}
```

<details>
  <summary>Solução para o exemplo de variáveis anuláveis</summary>

  Declare as duas variáveis como `String` seguido por `?`.
  Em seguida, atribua `'Jane'` a `name`
  e deixe `address` não inicializado:

  ```dart
  String? name = 'Jane';
  String? address;
  ```

</details>

## Operadores *null-aware* {:#null-aware-operators}

Dart oferece alguns operadores úteis para lidar com valores que podem ser nulos. Um deles é o
operador de atribuição `??=`, que atribui um valor a uma variável apenas se essa
variável estiver nula no momento:

<?code-excerpt "misc/test/cheatsheet/null_aware_test.dart (null-aware-operators)"?>
```dart
int? a; // = null
a ??= 3;
print(a); // <-- Prints 3.

a ??= 5;
print(a); // <-- Still prints 3.
```

Outro operador *null-aware* é `??`,
que retorna a expressão à sua esquerda, a menos que
o valor dessa expressão seja nulo,
caso em que ele avalia e retorna a expressão à sua direita:

<?code-excerpt "misc/test/cheatsheet/null_aware_test.dart (null-aware-operators-2)"?>
```dart
print(1 ?? 3); // <-- Prints 1.
print(null ?? 12); // <-- Prints 12.
```

### Exercise

Tente substituir os operadores `??=` e `??`
para implementar o comportamento descrito no seguinte trecho.

Ignore todos os erros iniciais no DartPad.

```dartpad theme="dark"
String? foo = 'a string';
String? bar; // = null

// Substitua um operador que faz com que 'uma string' seja atribuída a baz.
String? baz = foo /* TODO */ bar;

void updateSomeVars() {
  // Substitua um operador que faz com que 'uma string' seja atribuída a bar.
  bar /* TODO */ 'uma string';
}


// Testa sua solução (Não edite!):
void main() {
  try {
    updateSomeVars();

    if (foo != 'a string') {
      print('Looks like foo somehow ended up with the wrong value.');
    } else if (bar != 'a string') {
      print('Looks like bar ended up with the wrong value.');
    } else if (baz != 'a string') {
      print('Looks like baz ended up with the wrong value.');
    } else {
      print('Sucesso!');
    }
  } catch (e) {
    print('Exceção: ${e.runtimeType}.');
  }
}
```

<details>
  <summary>Solução para o exemplo de operadores *null-aware*</summary>

  Tudo o que você precisa fazer neste exercício é
  substituir os comentários `TODO` por `??` ou `??=`.
  Leia o texto acima para ter certeza de que você entende ambos,
  e então tente:

  ```dart
  // Substitua um operador que faz com que 'uma string' seja atribuída a baz.
  String? baz = foo ?? bar;

  void updateSomeVars() {
    // Substitua um operador que faz com que 'uma string' seja atribuída a bar.
    bar ??= 'uma string';
  }
  ```

</details>


## Acesso condicional de propriedade {:#conditional-property-access}

Para proteger o acesso a uma propriedade ou método de um objeto que pode ser nulo,
coloque um ponto de interrogação (`?`) antes do ponto (`.`):

<?code-excerpt "misc/test/cheatsheet/null_aware_test.dart (conditional-property-access)" replace="/result = //g; /;//g;"?>
```dart
myObject?.someProperty
```

O código anterior é equivalente ao seguinte:

<?code-excerpt "misc/test/cheatsheet/null_aware_test.dart (conditional-property-access-equivalent)" replace="/result = //g; /;//g;"?>
```dart
(myObject != null) ? myObject.someProperty : null
```

Você pode encadear vários usos de `?.` em uma única expressão:

<?code-excerpt "misc/test/cheatsheet/null_aware_test.dart (conditional-property-access-multiple)" replace="/result = //g; /;//g;"?>
```dart
myObject?.someProperty?.someMethod()
```

The preceding code returns null (and never calls `someMethod()`) if either
`myObject` or `myObject.someProperty` is null.


### Exercise

The following function takes a nullable string as a parameter.
Try using conditional property access to make it
return the uppercase version of `str`, or `null` if `str` is `null`.

```dartpad theme="dark"
String? upperCaseIt(String? str) {
  // TODO: Tente acessar condicionalmente o método `toUpperCase` aqui.
}


// Testa sua solução (Não edite!):
void main() {
  try {
    String? one = upperCaseIt(null);
    if (one != null) {
      print('Parece que você não está retornando nulo para entradas nulas.');
    } else {
      print('Sucesso quando str é nulo!');
    }
  } catch (e) {
    print('Tentei chamar upperCaseIt(null) e obtive uma exceção: \n ${e.runtimeType}.');
  }

  try {
    String? two = upperCaseIt('uma string');
    if (two == null) {
      print('Parece que você está retornando nulo mesmo quando str tem um valor.');
    } else if (two != 'UMA STRING') {
      print('Tentei upperCaseIt(\'uma string\'), mas não obtive \'UMA STRING\' como resposta.');
    } else {
      print('Sucesso quando str não é nulo!');
    }
  } catch (e) {
    print('Tentei chamar upperCaseIt(\'uma string\') e obtive uma exceção: \n ${e.runtimeType}.');
  }
}
```

<details>
  <summary>Solução para o exemplo de acesso condicional de propriedade</summary>

  Se este exercício quisesse que você convertesse condicionalmente uma string para minúsculas,
  você poderia fazer assim: `str?.toLowerCase()`. Use o método equivalente
  para converter uma string para maiúsculas!

  ```dart
  String? upperCaseIt(String? str) {
    return str?.toUpperCase();
  }
  ```

</details>

## Literais de coleção {:#collection-literals}

Dart tem suporte interno para listas, *maps* e *sets*.
Você pode criá-los usando literais:

<?code-excerpt "misc/test/cheatsheet/collections_test.dart (collection-literals-inferred)"?>
```dart
final aListOfStrings = ['one', 'two', 'three'];
final aSetOfStrings = {'one', 'two', 'three'};
final aMapOfStringsToInts = {'one': 1, 'two': 2, 'three': 3};
```

A inferência de tipo do Dart pode atribuir tipos a essas variáveis para você.
Neste caso, os tipos inferidos são `List<String>`,
`Set<String>` e `Map<String, int>`.

Ou você pode especificar o tipo você mesmo:

<?code-excerpt "misc/test/cheatsheet/collections_test.dart (collection-literals-specified)"?>
```dart
final aListOfInts = <int>[];
final aSetOfInts = <int>{};
final aMapOfIntToDouble = <int, double>{};
```

Especificar tipos é útil quando você inicializa uma lista com conteúdos de um subtipo,
mas ainda quer que a lista seja `List<TipoBase>`:

<?code-excerpt "misc/test/cheatsheet/collections_test.dart (collection-literals-subtypes)"?>
```dart
final aListOfBaseType = <BaseType>[SubType(), SubType()];
```

### Exercise

Tente definir as seguintes variáveis para os valores indicados. Substitua os valores nulos existentes.

```dartpad theme="dark"
// Assign this a list containing 'a', 'b', and 'c' in that order:
final aListOfStrings = null;

// Atribua a este um set contendo 3, 4 e 5:
final umSetDeInts = null;

// Atribua a este um map de String para int de modo que umMapDeStringsParaInts['minhaChave'] retorne 12:
final umMapDeStringsParaInts = null;

// Atribua a este um List<double> vazio:
final umaListaVaziaDeDouble = null;

// Atribua a este um Set<String> vazio:
final umSetVazioDeString = null;

// Atribua a este um Map vazio de double para int:
final umMapVazioDeDoublesParaInts = null;


// Testa sua solução (Não edite!):
void main() {
  final errs = <String>[];

  if (aListOfStrings is! List<String>) {
    errs.add('aListOfStrings should have the type List<String>.');
  } else if (aListOfStrings.length != 3) {
    errs.add('aListOfStrings has ${aListOfStrings.length} items in it, \n rather than the expected 3.');
  } else if (aListOfStrings[0] != 'a' || aListOfStrings[1] != 'b' || aListOfStrings[2] != 'c') {
    errs.add('aListOfStrings doesn\'t contain the correct values (\'a\', \'b\', \'c\').');
  }

  if (umSetDeInts is! Set<int>) {
    errs.add('umSetDeInts deve ter o tipo Set<int>.');
  } else if (umSetDeInts.length != 3) {
    errs.add('umSetDeInts tem ${umSetDeInts.length} itens, \n em vez dos 3 esperados.');
  } else if (!umSetDeInts.contains(3) || !umSetDeInts.contains(4) || !umSetDeInts.contains(5)) {
    errs.add('umSetDeInts não contém os valores corretos (3, 4, 5).');
  }

  if (umMapDeStringsParaInts is! Map<String, int>) {
    errs.add('umMapDeStringsParaInts deve ter o tipo Map<String, int>.');
  } else if (umMapDeStringsParaInts['minhaChave'] != 12) {
    errs.add('umMapDeStringsParaInts não contém os valores corretos (\'minhaChave\': 12).');
  }

  if (umaListaVaziaDeDouble is! List<double>) {
    errs.add('umaListaVaziaDeDouble deve ter o tipo List<double>.');
  } else if (umaListaVaziaDeDouble.isNotEmpty) {
    errs.add('umaListaVaziaDeDouble deve estar vazia.');
  }

  if (umSetVazioDeString is! Set<String>) {
    errs.add('umSetVazioDeString deve ter o tipo Set<String>.');
  } else if (umSetVazioDeString.isNotEmpty) {
    errs.add('umSetVazioDeString deve estar vazio.');
  }

  if (umMapVazioDeDoublesParaInts is! Map<double, int>) {
    errs.add('umMapVazioDeDoublesParaInts deve ter o tipo Map<double, int>.');
  } else if (umMapVazioDeDoublesParaInts.isNotEmpty) {
    errs.add('umMapVazioDeDoublesParaInts deve estar vazio.');
  }

  if (errs.isEmpty) {
    print('Sucesso!');
  } else {
    errs.forEach(print);
  }

  // ignore_for_file: unnecessary_type_check
}
```

<details>
  <summary>Solução para o exemplo de literais de coleção</summary>

  Add a list, set, or map literal after each equal sign (`=`).
  Remember to specify the types for the empty declarations,
  since they can't be inferred.

  ```dart
  // Atribua a esta uma lista contendo 'a', 'b' e 'c' nessa ordem:
  final umaListaDeStrings = ['a', 'b', 'c'];

  // Atribua a este um set contendo 3, 4 e 5:
  final umSetDeInts = {3, 4, 5};

  // Atribua a este um map de String para int de modo que umMapDeStringsParaInts['minhaChave'] retorne 12:
  final umMapDeStringsParaInts = {'minhaChave': 12};

  // Atribua a este um List<double> vazio:
  final umaListaVaziaDeDouble = <double>[];

  // Atribua a este um Set<String> vazio:
  final umSetVazioDeString = <String>{};

  // Atribua a este um Map vazio de double para int:
  final umMapVazioDeDoublesParaInts = <double, int>{};
  ```

</details>

## Sintaxe de seta {:#arrow-syntax}

Você pode ter visto o símbolo `=>` no código Dart.
Essa sintaxe de seta é uma forma de definir uma função que executa a
expressão à sua direita e retorna seu valor.

Por exemplo, considere esta chamada para o método `any()`
da classe `List`:

<?code-excerpt "misc/test/cheatsheet/arrow_functions_test.dart (has-empty-long)"?>
```dart
bool hasEmpty = aListOfStrings.any((s) {
  return s.isEmpty;
});
```

Aqui está uma maneira mais simples de escrever esse código:

<?code-excerpt "misc/test/cheatsheet/arrow_functions_test.dart (has-empty-short)"?>
```dart
bool hasEmpty = aListOfStrings.any((s) => s.isEmpty);
```

### Exercise

Tente terminar as declarações a seguir, que usam a sintaxe de seta.

```dartpad theme="dark"
class MyClass {
  int value1 = 2;
  int value2 = 3;
  int value3 = 5;

  // Returns the product of the above values:
  int get product => TODO();

  // Adds 1 to value1:
  void incrementValue1() => TODO();

  // Returns a string containing each item in the
  // list, separated by commas (e.g. 'a,b,c'):
  String joinWithCommas(List<String> strings) => TODO();
}


// Testa sua solução (Não edite!):
void main() {
  final obj = MinhaClasse();
  final errs = <String>[];

  try {
    final product = obj.product;

    if (product != 30) {
      errs.add('The product property returned $product \n instead of the expected value (30).');
    }
  } catch (e) {
    print('Tentei usar MinhaClasse.produto, mas encontrei uma exceção: \n ${e.runtimeType}.');
    return;
  }

  try {
    obj.incrementValue1();

    if (obj.value1 != 3) {
      errs.add('After calling incrementValue, value1 was ${obj.value1} \n instead of the expected value (3).');
    }
  } catch (e) {
    print('Tentei usar MinhaClasse.incrementaValor1, mas encontrei uma exceção: \n ${e.runtimeType}.');
    return;
  }

  try {
    final joined = obj.joinWithCommas(['one', 'two', 'three']);

    if (joined != 'one,two,three') {
      errs.add('Tried calling joinWithCommas([\'one\', \'two\', \'three\']) \n and received $joined instead of the expected value (\'one,two,three\').');
    }
  } catch (e) {
    print('Tentei usar MinhaClasse.uneComVirgulas, mas encontrei uma exceção: \n ${e.runtimeType}.');
    return;
  }

  if (errs.isEmpty) {
    print('Sucesso!');
  } else {
    errs.forEach(print);
  }
}
```

<details>
  <summary>Solução para o exemplo de sintaxe de seta</summary>

  Para o produto, você pode usar `*` para multiplicar os três valores juntos.
  Para `incrementaValor1`, você pode usar o operador de incremento (`++`).
  Para `uneComVirgulas`, use o método `join` encontrado na classe `List`.

  ```dart
  class MinhaClasse {
    int valor1 = 2;
    int valor2 = 3;
    int valor3 = 5;

    // Returns the product of the above values:
    int get product => value1 * value2 * value3;

    // Adds 1 to value1:
    void incrementValue1() => value1++;

    // Returns a string containing each item in the
    // list, separated by commas (e.g. 'a,b,c'):
    String joinWithCommas(List<String> strings) => strings.join(',');
  }
  ```
</details>


## *Cascades* {:#cascades}

Para executar uma sequência de operações no mesmo objeto, use *cascades* (`..`).
Todos nós já vimos uma expressão como esta:

<?code-excerpt "misc/bin/cheatsheet/cascades.dart (no-cascade)" replace="/;//g"?>
```dart
myObject.someMethod()
```

Ele invoca `algumMetodo()` em `meuObjeto`, e o resultado da
expressão é o valor de retorno de `algumMetodo()`.

Aqui está a mesma expressão com um *cascade*:

<?code-excerpt "misc/bin/cheatsheet/cascades.dart (uses-cascade)" replace="/;//g"?>
```dart
myObject..someMethod()
```

Embora ele ainda invoque `algumMetodo()` em `meuObjeto`, o resultado
da expressão **não é** o valor de retorno—é uma referência para `meuObjeto`!

Usando *cascades*, você pode encadear operações que
de outra forma exigiriam declarações separadas.
Por exemplo, considere o seguinte código,
que usa o operador de acesso condicional de membro (`?.`)
para ler as propriedades de `botao` se ele não for `null`:

<?code-excerpt "misc/bin/cheatsheet/cascades.dart (query-without-cascades)"?>
```dart
final button = web.document.querySelector('#confirm');
button?.textContent = 'Confirm';
button?.classList.add('important');
button?.onClick.listen((e) => web.window.alert('Confirmed!'));
button?.scrollIntoView();
```

To instead use cascades,
you can start with the _null-shorting_ cascade (`?..`),
which guarantees that none of the cascade operations
are attempted on a `null` object.
Using cascades shortens the code
and makes the `button` variable unnecessary:

<?code-excerpt "misc/bin/cheatsheet/cascades.dart (query-with-cascades)"?>
```dart
web.document.querySelector('#confirm')
  ?..textContent = 'Confirm'
  ..classList.add('important')
  ..onClick.listen((e) => web.window.alert('Confirmed!'))
  ..scrollIntoView();
```

### Exercise

Use *cascades* para criar uma única declaração que
define as propriedades `umInt`, `umaString` e `umaLista` de um `ObjetoGrande`
para `1`, `'String!'` e `[3.0]` (respectivamente)
e então chama `tudoFeito()`.

```dartpad theme="dark"
class BigObject {
  int anInt = 0;
  String aString = '';
  List<double> aList = [];
  bool _done = false;

  void allDone() {
    _done = true;
  }
}

ObjetoGrande preencheObjetoGrande(ObjetoGrande obj) {
  // Crie uma única declaração que irá atualizar e retornar obj:
  return TODO('obj..');
}


// Testa sua solução (Não edite!):
void main() {
  ObjetoGrande obj;

  try {
    obj = preencheObjetoGrande(ObjetoGrande());
  } catch (e) {
    print('Capturou uma exceção do tipo ${e.runtimeType} \n enquanto executava preencheObjetoGrande');
    return;
  }

  final errs = <String>[];

  if (obj.umInt != 1) {
    errs.add(
        'O valor de umInt era ${obj.umInt} \n em vez do esperado (1).');
  }

  if (obj.umaString != 'String!') {
    errs.add(
        'O valor de umaString era \'${obj.umaString}\' \n em vez do esperado (\'String!\').');
  }

  if (obj.umaLista.length != 1) {
    errs.add(
        'O comprimento de umaLista era ${obj.umaLista.length} \n em vez do valor esperado (1).');
  } else {
    if (obj.umaLista[0] != 3.0) {
      errs.add(
          'O valor encontrado em umaLista era ${obj.umaLista[0]} \n em vez do esperado (3.0).');
    }
  }

  if (!obj._done) {
    errs.add('It looks like allDone() wasn\'t called.');
  }

  if (errs.isEmpty) {
    print('Sucesso!');
  } else {
    errs.forEach(print);
  }
}
```

<details>
  <summary>Solução para o exemplo de *cascades*</summary>

  A melhor solução para este exercício começa com `obj..` e
  tem quatro operações de atribuição encadeadas.
  Comece com `return obj..umInt = 1`,
  em seguida, adicione outro *cascade* (`..`) e inicie a próxima atribuição.

  ```dart
  ObjetoGrande preencheObjetoGrande(ObjetoGrande obj) {
    return obj
      ..umInt = 1
      ..umaString = 'String!'
      ..umaLista.add(3)
      ..tudoFeito();
  }
  ```
</details>


## *Getters* e *setters* {:#getters-and-setters}

Você pode definir *getters* e *setters*
sempre que precisar de mais controle sobre uma propriedade
do que um campo simples permite.

Por exemplo, você pode garantir que o valor de uma propriedade seja válido:

<?code-excerpt "misc/lib/cheatsheet/getters_setters.dart"?>
```dart
class MyClass {
  int _aProperty = 0;

  int get aProperty => _aProperty;

  set aProperty(int value) {
    if (value >= 0) {
      _aProperty = value;
    }
  }
}
```

Você também pode usar um *getter* para definir uma propriedade computada:

<?code-excerpt "misc/lib/cheatsheet/getter_compute.dart"?>
```dart
class MyClass {
  final List<int> _values = [];

  void addValue(int value) {
    _values.add(value);
  }

  // A computed property.
  int get count {
    return _values.length;
  }
}
```

### Exercise

Imagine you have a shopping cart class that keeps a
private `List<double>` of prices.
Add the following:

* Um *getter* chamado `total` que retorna a soma dos preços
* Um *setter* que substitui a lista por uma nova,
  contanto que a nova lista não contenha preços negativos
  (caso em que o *setter* deve lançar uma `InvalidPriceException` (ExceçãoDePreçoInválido)).

Ignore todos os erros iniciais no DartPad.

```dartpad theme="dark"
class InvalidPriceException {}

class ShoppingCart {
  List<double> _prices = [];

  // TODO: Add a "total" getter here:

  // TODO: Adicione um *setter* "precos" aqui:
}


// Testa sua solução (Não edite!):
void main() {
  var foundException = false;

  try {
    final carrinho = CarrinhoDeCompras();
    carrinho.precos = [12.0, 12.0, -23.0];
  } on InvalidPriceException {
    encontrouExcecao = true;
  } catch (e) {
    print('Tentei definir um preço negativo e recebi um ${e.runtimeType} \n em vez de um InvalidPriceException.');
    return;
  }

  if (!foundException) {
    print('Tried setting a negative price \n and didn\'t get an InvalidPriceException.');
    return;
  }

  final secondCart = ShoppingCart();

  try {
    segundoCarrinho.precos = [1.0, 2.0, 3.0];
  } catch(e) {
    print('Tentei definir os preços com uma lista válida, \n mas recebi uma exceção: ${e.runtimeType}.');
    return;
  }

  if (secondCart._prices.length != 3) {
    print('Tried setting prices with a list of three values, \n but _prices ended up having length ${secondCart._prices.length}.');
    return;
  }

  if (segundoCarrinho._precos[0] != 1.0 || segundoCarrinho._precos[1] != 2.0 || segundoCarrinho._precos[2] != 3.0) {
    final vals = segundoCarrinho._precos.map((p) => p.toString()).join(', ');
    print('Tentei definir os preços com uma lista de três valores (1, 2, 3), \n mas valores incorretos acabaram na lista de preços ($vals) .');
    return;
  }

  var sum = 0.0;

  try {
    soma = segundoCarrinho.total;
  } catch (e) {
    print('Tentei obter o total, mas recebi uma exceção: ${e.runtimeType}.');
    return;
  }

  if (sum != 6.0) {
    print('After setting prices to (1, 2, 3), total returned $sum instead of 6.');
    return;
  }

  print('Success!');
}
```

<details>
  <summary>Solução para o exemplo de *getters* e *setters*</summary>

  Two functions are handy for this exercise.
  One is `fold`, which can reduce a list to a single value
  (use it to calculate the total).
  The other is `any`, which can check each item in a list
  with a function you give it
  (use it to check if there are any negative prices in the `prices` setter).

  ```dart
  /// The total price of the shopping cart.
  double get total => _prices.fold(0, (e, t) => e + t);

  /// Set [prices] to the [value] list of item prices.
  set prices(List<double> value) {
    if (value.any((p) => p < 0)) {
      throw InvalidPriceException();
    }

    _prices = value;
  }
  ```

</details>


## Parâmetros posicionais opcionais {:#optional-positional-parameters}

Dart has two kinds of function parameters: positional and named.
Positional parameters are the kind you're likely familiar with:

<?code-excerpt "misc/lib/cheatsheet/optional_positional_args.dart (optional-positional-args)"?>
```dart
int sumUp(int a, int b, int c) {
  return a + b + c;
}
  // ···
  int total = sumUp(1, 2, 3);
```

Com o Dart, você pode tornar esses parâmetros posicionais opcionais, envolvendo-os entre colchetes:

<?code-excerpt "misc/lib/cheatsheet/optional_positional_args.dart (optional-positional-args-2)" replace="/total2/total/g"?>
```dart
int sumUpToFive(int a, [int? b, int? c, int? d, int? e]) {
  int sum = a;
  if (b != null) sum += b;
  if (c != null) sum += c;
  if (d != null) sum += d;
  if (e != null) sum += e;
  return sum;
}
  // ···
  int total = sumUpToFive(1, 2);
  int otherTotal = sumUpToFive(1, 2, 3, 4, 5);
```

Os parâmetros posicionais opcionais são sempre os últimos
na lista de parâmetros de uma função.
Seu valor padrão é nulo, a menos que você forneça outro valor padrão:

<?code-excerpt "misc/lib/cheatsheet/optional_positional_args2.dart (sum-no-impl)"?>
```dart
int sumUpToFive(int a, [int b = 2, int c = 3, int d = 4, int e = 5]) {
  // ···
}

void main() {
  int newTotal = sumUpToFive(1);
  print(newTotal); // <-- prints 15
}
```

### Exercise

Implemente uma função chamada `joinWithCommas()` que aceite de um a
cinco inteiros e, em seguida, retorne uma string desses números separados por vírgulas.
Aqui estão alguns exemplos de chamadas de função e valores retornados:

| Chamada de função                   | Valor retornado |
|---------------------------------|----------------|
| `joinWithCommas(1)`             | `'1'`          |
| `joinWithCommas(1, 2, 3)`       | `'1,2,3'`      |
| `joinWithCommas(1, 1, 1, 1, 1)` | `'1,1,1,1,1'`  |

<br>

```dartpad theme="dark"
String joinWithCommas(int a, [int? b, int? c, int? d, int? e]) {
  return TODO();
}


// Testa sua solução (Não edite!):
void main() {
  final errs = <String>[];

  try {
    final value = joinWithCommas(1);

    if (value != '1') {
      errs.add('Tried calling joinWithCommas(1) \n and got $value instead of the expected (\'1\').');
    }
  } on UnimplementedError {
    print('Tentou chamar joinWithCommas, mas falhou. \n Você implementou o método?');
    return;
  } catch (e) {
    print('Tentou chamar joinWithCommas(1), \n mas encontrou uma exceção: ${e.runtimeType}.');
    return;
  }

  try {
    final value = joinWithCommas(1, 2, 3);

    if (value != '1,2,3') {
      errs.add('Tried calling joinWithCommas(1, 2, 3) \n and got $value instead of the expected (\'1,2,3\').');
    }
  } on UnimplementedError {
    print('Tentou chamar joinWithCommas, mas falhou. \n Você implementou o método?');
    return;
  } catch (e) {
    print('Tentou chamar joinWithCommas(1, 2 ,3), \n mas encontrou uma exceção: ${e.runtimeType}.');
    return;
  }

  try {
    final value = joinWithCommas(1, 2, 3, 4, 5);

    if (value != '1,2,3,4,5') {
      errs.add('Tried calling joinWithCommas(1, 2, 3, 4, 5) \n and got $value instead of the expected (\'1,2,3,4,5\').');
    }
  } on UnimplementedError {
    print('Tentou chamar joinWithCommas, mas falhou. \n Você implementou o método?');
    return;
  } catch (e) {
    print('Tentou chamar stringify(1, 2, 3, 4 ,5), \n mas encontrou uma exceção: ${e.runtimeType}.');
    return;
  }

  if (errs.isEmpty) {
    print('Sucesso!');
  } else {
    errs.forEach(print);
  }
}
```

<details>
  <summary>Solução para o exemplo de parâmetros posicionais</summary>

  Os parâmetros `b`, `c`, `d` e `e` são nulos se não forem fornecidos pelo
  chamador. O importante, então, é verificar se esses argumentos são `null`
  antes de adicioná-los à string final.

  ```dart
  String joinWithCommas(int a, [int? b, int? c, int? d, int? e]) {
    var total = '$a';
    if (b != null) total = '$total,$b';
    if (c != null) total = '$total,$c';
    if (d != null) total = '$total,$d';
    if (e != null) total = '$total,$e';
    return total;
  }
  ```

</details>

<a id="optional-named-parameters"></a>
## Parâmetros nomeados {:#named-parameters}

Usando uma sintaxe de chave no final da lista de parâmetros,
você pode definir parâmetros que possuem nomes.

Parâmetros nomeados são opcionais
a menos que sejam explicitamente marcados como `required` (obrigatório).

<?code-excerpt "misc/lib/cheatsheet/named_parameters.dart"?>
```dart
void printName(String firstName, String lastName, {String? middleName}) {
  print('$firstName ${middleName ?? ''} $lastName');
}

void main() {
  printName('Dash', 'Dartisan');
  printName('John', 'Smith', middleName: 'Who');
  // Named arguments can be placed anywhere in the argument list.
  printName('John', middleName: 'Who', 'Smith');
}
```

Como você pode esperar,
o valor padrão de um parâmetro nomeado anulável é `null`,
mas você pode fornecer um valor padrão personalizado.

Se o tipo de um parâmetro não for anulável,
você deve fornecer um valor padrão
(como mostrado no código a seguir)
ou marcar o parâmetro como `required`
(como mostrado na
[seção do construtor](#using-this-in-a-constructor)).

<?code-excerpt "misc/test/cheatsheet/arguments_test.dart (defaulted-middle)" replace="/ = ''/[! = ''!]/g;"?>
```dart
void printName(String firstName, String lastName, {String middleName[! = ''!]}) {
  print('$firstName $middleName $lastName');
}
```

Uma função não pode ter parâmetros posicionais e nomeados opcionais.


### Exercise

Adicione um método de instância `copyWith()` à classe `MyDataObject`.
Ele deve receber três parâmetros nomeados e anuláveis:

* `int? newInt`
* `String? newString`
* `double? newDouble`

Seu método `copyWith()` deve retornar um novo `MyDataObject`
baseado na instância atual,
com dados dos parâmetros anteriores (se houver)
copiados para as propriedades do objeto.
Por exemplo, se `newInt` não for nulo,
copie seu valor para `anInt`.

Ignore todos os erros iniciais no DartPad.

```dartpad theme="dark"
class MyDataObject {
  final int anInt;
  final String aString;
  final double aDouble;

  MyDataObject({
     this.anInt = 1,
     this.aString = 'Old!',
     this.aDouble = 2.0,
  });

  // TODO: Adicione seu método copyWith aqui:
}


// Testa sua solução (Não edite!):
void main() {
  final source = MyDataObject();
  final errs = <String>[];

  try {
    final copy = source.copyWith(newInt: 12, newString: 'New!', newDouble: 3.0);

    if (copy.anInt != 12) {
      errs.add('Chamou copyWith(newInt: 12, newString: \'New!\', newDouble: 3.0), \n e o anInt do novo objeto foi ${copy.anInt} em vez do valor esperado (12).');
    }

    if (copy.aString != 'New!') {
      errs.add('Chamou copyWith(newInt: 12, newString: \'New!\', newDouble: 3.0), \n e o aString do novo objeto foi ${copy.aString} em vez do valor esperado (\'New!\').');
    }

    if (copy.aDouble != 3) {
      errs.add('Chamou copyWith(newInt: 12, newString: \'New!\', newDouble: 3.0), \n e o aDouble do novo objeto foi ${copy.aDouble} em vez do valor esperado (3).');
    }
  } catch (e) {
    print('Chamou copyWith(newInt: 12, newString: \'New!\', newDouble: 3.0) \n e obteve uma exceção: ${e.runtimeType}');
  }

  try {
    final copy = source.copyWith();

    if (copy.anInt != 1) {
      errs.add('Chamou copyWith(), e o anInt do novo objeto foi ${copy.anInt} \n em vez do valor esperado (1).');
    }

    if (copy.aString != 'Old!') {
      errs.add('Chamou copyWith(), e o aString do novo objeto foi ${copy.aString} \n em vez do valor esperado (\'Old!\').');
    }

    if (copy.aDouble != 2) {
      errs.add('Chamou copyWith(), e o aDouble do novo objeto foi ${copy.aDouble} \n em vez do valor esperado (2).');
    }
  } catch (e) {
    print('Chamou copyWith() e obteve uma exceção: ${e.runtimeType}');
  }

  try {
    final sourceWithoutDefaults = MyDataObject(
      anInt: 520,
      aString: 'Custom!',
      aDouble: 20.25,
    );
    final copy = sourceWithoutDefaults.copyWith();

    if (copy.anInt == 1) {
      errs.add('Called `copyWith()` on an object with a non-default `anInt` value (${sourceWithoutDefaults.anInt}), but the new object\'s `anInt` was the default value of ${copy.anInt}.');
    }

    if (copy.aString == 'Old!') {
      errs.add('Called `copyWith()` on an object with a non-default `aString` value (\'${sourceWithoutDefaults.aString}\'), but the new object\'s `aString` was the default value of \'${copy.aString}\'.');
    }

    if (copy.aDouble == 2.0) {
      errs.add('Called copyWith() on an object with a non-default `aDouble` value (${sourceWithoutDefaults.aDouble}), but the new object\'s `aDouble` was the default value of ${copy.aDouble}.');
    }
  } catch (e) {
    print('Called copyWith() and got an exception: ${e.runtimeType}');
  }

  if (errs.isEmpty) {
    print('Sucesso!');
  } else {
    errs.forEach(print);
  }
}
```

<details>
  <summary>Solução para o exemplo de parâmetros nomeados</summary>

  O método `copyWith` aparece em muitas classes e bibliotecas.
  O seu deve fazer algumas coisas:
  usar parâmetros nomeados opcionais,
  criar uma nova instância de `MyDataObject` e
  usar os dados dos parâmetros para preenchê-la
  (ou os dados da instância atual se os parâmetros forem nulos).
  Esta é uma chance de praticar mais com o operador `??`!

  ```dart
  MyDataObject copyWith({int? newInt, String? newString, double? newDouble}) {
    return MyDataObject(
      anInt: newInt ?? this.anInt,
      aString: newString ?? this.aString,
      aDouble: newDouble ?? this.aDouble,
    );
  }
  ```
</details>


## Exceções {:#exceptions}

O código Dart pode lançar e capturar exceções.
Ao contrário do Java, todas as exceções do Dart são não verificadas.
Os métodos não declaram quais exceções eles podem lançar e
você não é obrigado a capturar nenhuma exceção.

Dart fornece os tipos `Exception` e `Error`, mas você tem
permissão para lançar qualquer objeto não nulo:

<?code-excerpt "misc/test/cheatsheet/exceptions_test.dart (simple-throws)"?>
```dart
throw Exception('Something bad happened.');
throw 'Waaaaaaah!';
```

Use as palavras-chave `try`, `on` e `catch` ao lidar com exceções:

<?code-excerpt "misc/test/cheatsheet/exceptions_test.dart (try-on-catch)"?>
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

A palavra-chave `try` funciona como na maioria das outras linguagens.
Use a palavra-chave `on` para filtrar exceções específicas por tipo,
e a palavra-chave `catch` para obter uma referência ao objeto de exceção.

Se você não puder lidar completamente com a exceção, use a palavra-chave `rethrow`
para propagar a exceção:

<?code-excerpt "misc/test/cheatsheet/exceptions_test.dart (try-catch)"?>
```dart
try {
  breedMoreLlamas();
} catch (e) {
  print('I was just trying to breed llamas!');
  rethrow;
}
```

Para executar o código, independentemente de uma exceção ser lançada ou não,
use `finally`:

<?code-excerpt "misc/test/cheatsheet/exceptions_test.dart (try-catch-finally)"?>
```dart
try {
  breedMoreLlamas();
} catch (e) {
  // ... handle exception ...
} finally {
  // Always clean up, even if an exception is thrown.
  cleanLlamaStalls();
}
```

### Exercise

Implemente `tryFunction()` abaixo. Ele deve executar um método não confiável e
depois fazer o seguinte:

* Se `untrustworthy()` lançar uma `ExceptionWithMessage`,
  chame `logger.logException` com o tipo e a mensagem da exceção
  (tente usar `on` e `catch`).
* Se `untrustworthy()` lançar uma `Exception`,
  chame `logger.logException` com o tipo da exceção
  (tente usar `on` para este).
* Se `untrustworthy()` lançar qualquer outro objeto, não capture a exceção.
* Depois que tudo for capturado e tratado, chame `logger.doneLogging`
  (tente usar `finally`).

```dartpad theme="dark"
typedef VoidFunction = void Function();

class ExceptionWithMessage {
  final String message;
  const ExceptionWithMessage(this.message);
}

// Chame logException para registrar uma exceção e doneLogging quando terminar.
abstract class Logger {
  void logException(Type t, [String? msg]);
  void doneLogging();
}

void tryFunction(VoidFunction untrustworthy, Logger logger) {
  try {
    untrustworthy();
  } // Write your logic here
}

// Testa sua solução (Não edite!):
class MyLogger extends Logger {
  Type? lastType;
  String lastMessage = '';
  bool done = false;

  void logException(Type t, [String? message]) {
    lastType = t;
    lastMessage = message ?? lastMessage;
  }

  void doneLogging() => done = true;
}

void main() {
  final errs = <String>[];
  var logger = MyLogger();

  try {
    tryFunction(() => throw Exception(), logger);

    if ('${logger.lastType}' != 'Exception' && '${logger.lastType}' != '_Exception') {
      errs.add('Untrustworthy lançou uma Exception, mas um tipo diferente foi registrado: \n ${logger.lastType}.');
    }

    if (logger.lastMessage != '') {
      errs.add('Untrustworthy lançou uma Exception sem mensagem, mas uma mensagem \n foi registrada mesmo assim: \'${logger.lastMessage}\'.');
    }

    if (!logger.done) {
      errs.add('Untrustworthy lançou uma Exception, \n e doneLogging() não foi chamado depois.');
    }
  } catch (e) {
    print('Untrustworthy lançou uma exceção, e uma exceção do tipo \n ${e.runtimeType} não foi tratada por tryFunction.');
  }

  logger = MyLogger();

  try {
    tryFunction(() => throw ExceptionWithMessage('Hey!'), logger);

    if (logger.lastType != ExceptionWithMessage) {
      errs.add('Untrustworthy lançou uma ExceptionWithMessage(\'Hey!\'), mas um \n tipo diferente foi registrado: ${logger.lastType}.');
    }

    if (logger.lastMessage != 'Hey!') {
      errs.add('Untrustworthy lançou uma ExceptionWithMessage(\'Hey!\'), mas uma \n mensagem diferente foi registrada: \'${logger.lastMessage}\'.');
    }

    if (!logger.done) {
      errs.add('Untrustworthy lançou uma ExceptionWithMessage(\'Hey!\'), \n e doneLogging() não foi chamado depois.');
    }
  } catch (e) {
    print('Untrustworthy lançou uma ExceptionWithMessage(\'Hey!\'), \n e uma exceção do tipo ${e.runtimeType} não foi tratada por tryFunction.');
  }

  logger = MyLogger();
  bool caughtStringException = false;

  try {
    tryFunction(() => throw 'A String', logger);
  } on String {
    caughtStringException = true;
  }

  if (!caughtStringException) {
    errs.add('Untrustworthy lançou uma string, e foi tratada incorretamente dentro de tryFunction().');
  }

  logger = MyLogger();

  try {
    tryFunction(() {}, logger);

    if (logger.lastType != null) {
      errs.add('Untrustworthy não lançou uma Exception, \n mas uma foi registrada mesmo assim: ${logger.lastType}.');
    }

    if (logger.lastMessage != '') {
      errs.add('Untrustworthy não lançou uma Exception sem mensagem, \n mas uma mensagem foi registrada mesmo assim: \'${logger.lastMessage}\'.');
    }

    if (!logger.done) {
      errs.add('Untrustworthy não lançou uma Exception, \n mas doneLogging() não foi chamado depois.');
    }
  } catch (e) {
    print('Untrustworthy não lançou uma exceção, \n mas uma exceção do tipo ${e.runtimeType} não foi tratada por tryFunction mesmo assim.');
  }

  if (errs.isEmpty) {
    print('Sucesso!');
  } else {
    errs.forEach(print);
  }
}
```

<details>
  <summary>Solução para o exemplo de exceções</summary>

  Este exercício parece complicado, mas é realmente uma grande declaração `try`.
  Chame `untrustworthy` dentro do `try` e
  use `on`, `catch` e `finally` para capturar exceções e
  chamar métodos no logger (registrador).

  ```dart
  void tryFunction(VoidFunction untrustworthy, Logger logger) {
    try {
      untrustworthy();
    } on ExceptionWithMessage catch (e) {
      logger.logException(e.runtimeType, e.message);
    } on Exception {
      logger.logException(Exception);
    } finally {
      logger.doneLogging();
    }
  }
  ```

</details>


## Usando `this` em um construtor {:#using-this-in-a-constructor}

Dart fornece um atalho útil para atribuir
valores às propriedades em um construtor:
use `this.propertyName` ao declarar o construtor:

<?code-excerpt "misc/lib/cheatsheet/this_constructor.dart (required-positional)"?>
```dart
class MyColor {
  int red;
  int green;
  int blue;

  MyColor(this.red, this.green, this.blue);
}

final color = MyColor(80, 80, 128);
```

Essa técnica também funciona para parâmetros nomeados.
Os nomes das propriedades se tornam os nomes dos parâmetros:

<?code-excerpt "misc/lib/cheatsheet/this_constructor.dart (required-named)" replace="/int.*;/\/\/ .../g; /olorRN/olor/g;"?>
```dart
class MyColor {
  // ...

  MyColor({required this.red, required this.green, required this.blue});
}

final color = MyColor(red: 80, green: 80, blue: 80);
```

No código anterior, `red`, `green` e `blue` são marcados como `required`
porque esses valores `int` não podem ser nulos.
Se você adicionar valores padrão, poderá omitir `required`:

<?code-excerpt "misc/lib/cheatsheet/this_constructor.dart (defaulted)" replace="/olorO/olor/g; /.positional//g; /.named//g;"?>
```dart
MyColor([this.red = 0, this.green = 0, this.blue = 0]);
// or
MyColor({this.red = 0, this.green = 0, this.blue = 0});
```

### Exercise

Adicione um construtor de uma linha para `MyClass` que use
a sintaxe `this.` para receber e atribuir valores para
todas as três propriedades da classe.

Ignore todos os erros iniciais no DartPad.

```dartpad theme="dark"
class MyClass {
  final int anInt;
  final String aString;
  final double aDouble;

  // TODO: Create the constructor here.
}


// Testa sua solução (Não edite!):
void main() {
  final errs = <String>[];

  try {
    final obj = MyClass(1, 'two', 3);

    if (obj.anInt != 1) {
      errs.add('Chamou MyClass(1, \'two\', 3) e obteve um objeto com anInt de ${obj.anInt} \n em vez do valor esperado (1).');
    }

    if (obj.anInt != 1) {
      errs.add('Chamou MyClass(1, \'two\', 3) e obteve um objeto com aString de \'${obj.aString}\' \n em vez do valor esperado (\'two\').');
    }

    if (obj.anInt != 1) {
      errs.add('Chamou MyClass(1, \'two\', 3) e obteve um objeto com aDouble de ${obj.aDouble} \n em vez do valor esperado (3).');
    }
  } catch (e) {
    print('Chamou MyClass(1, \'two\', 3) e obteve uma exceção \n do tipo ${e.runtimeType}.');
  }

  if (errs.isEmpty) {
    print('Sucesso!');
  } else {
    errs.forEach(print);
  }
}
```

<details>
  <summary>Solução para o exemplo `this`</summary>

  Este exercício tem uma solução de uma linha.
  Declare o construtor com
  `this.anInt`, `this.aString` e `this.aDouble`
  como seus parâmetros nessa ordem.

  ```dart
  MyClass(this.anInt, this.aString, this.aDouble);
  ```

</details>

## Initializer lists

Às vezes, quando você implementa um construtor,
você precisa fazer alguma configuração antes que o corpo do construtor seja executado.
Por exemplo, campos finais devem ter valores
antes que o corpo do construtor seja executado.
Faça esse trabalho em uma lista de inicializadores,
que fica entre a assinatura do construtor e seu corpo:

<?code-excerpt "misc/lib/language_tour/classes/point_alt.dart (initializer-list-no-comment)"?>
```dart
Point.fromJson(Map<String, double> json) : x = json['x']!, y = json['y']! {
  print('In Point.fromJson(): ($x, $y)');
}
```

A lista de inicializadores também é um lugar útil para colocar asserções (assert),
que são executadas apenas durante o desenvolvimento:

<?code-excerpt "misc/lib/cheatsheet/initializer_lists.dart (assert)"?>
```dart
NonNegativePoint(this.x, this.y) : assert(x >= 0), assert(y >= 0) {
  print('I just made a NonNegativePoint: ($x, $y)');
}
```

### Exercise

Conclua o construtor `FirstTwoLetters` abaixo.
Use uma lista de inicializadores para atribuir os dois primeiros caracteres em `word` às
propriedades `letterOne` e `LetterTwo`.
Para um desafio extra, adicione um `assert` para capturar palavras com menos de dois caracteres.

Ignore todos os erros iniciais no DartPad.

```dartpad theme="dark"
class FirstTwoLetters {
  final String letterOne;
  final String letterTwo;

  // TODO: Crie um construtor com uma lista de inicializadores aqui:
  FirstTwoLetters(String word)

}


// Testa sua solução (Não edite!):
void main() {
  final errs = <String>[];

  try {
    final result = FirstTwoLetters('My String');

    if (result.letterOne != 'M') {
      errs.add('Chamou FirstTwoLetters(\'My String\') e obteve um objeto com \n letterOne igual a \'${result.letterOne}\' em vez do valor esperado (\'M\').');
    }

    if (result.letterTwo != 'y') {
      errs.add('Chamou FirstTwoLetters(\'My String\') e obteve um objeto com \n letterTwo igual a \'${result.letterTwo}\' em vez do valor esperado (\'y\').');
    }
  } catch (e) {
    errs.add('Chamou FirstTwoLetters(\'My String\') e obteve uma exceção \n do tipo ${e.runtimeType}.');
  }

  bool caughtException = false;

  try {
    FirstTwoLetters('');
  } catch (e) {
    caughtException = true;
  }

  if (!caughtException) {
    errs.add('Chamou FirstTwoLetters(\'\') e não obteve uma exceção \n da asserção com falha.');
  }

  if (errs.isEmpty) {
    print('Sucesso!');
  } else {
    errs.forEach(print);
  }
}
```

<details>
  <summary>Solução para o exemplo de listas de inicializadores</summary>

  Duas atribuições precisam acontecer:
  `letterOne` deve receber `word[0]`,
  e `letterTwo` deve receber `word[1]`.

  ```dart
    FirstTwoLetters(String word)
        : assert(word.length >= 2),
          letterOne = word[0],
          letterTwo = word[1];
  ```
</details>

## Construtores nomeados {:#named-constructors}

To allow classes to have multiple constructors,
Dart supports named constructors:

<?code-excerpt "misc/lib/cheatsheet/named_constructor.dart (point-class)"?>
```dart
class Point {
  double x, y;

  Point(this.x, this.y);

  Point.origin() : x = 0, y = 0;
}
```

Para usar um construtor nomeado, invoque-o usando seu nome completo:

<?code-excerpt "misc/test/cheatsheet/constructor_test.dart (origin-point)"?>
```dart
final myPoint = Point.origin();
```

### Exercise

Dê à classe `Color` um construtor chamado `Color.black`
que define todas as três propriedades como zero.

Ignore todos os erros iniciais no DartPad.

```dartpad theme="dark"
class Color {
  int red;
  int green;
  int blue;

  Color(this.red, this.green, this.blue);

  // TODO: Create a named constructor called "Color.black" here:
}


// Testa sua solução (Não edite!):
void main() {
  final errs = <String>[];

  try {
    final result = Color.black();

    if (result.red != 0) {
      errs.add('Chamou Color.black() e obteve uma cor com red igual a \n ${result.red} em vez do valor esperado (0).');
    }

    if (result.green != 0) {
      errs.add('Chamou Color.black() e obteve uma cor com green igual a \n ${result.green} em vez do valor esperado (0).');
    }

    if (result.blue != 0) {
  errs.add('Chamou Color.black() e obteve uma cor com blue igual a \n ${result.blue} em vez do valor esperado (0).');
    }
  } catch (e) {
    print('Chamou Color.black() e obteve uma exceção do tipo \n ${e.runtimeType}.');
    return;
  }

  if (errs.isEmpty) {
    print('Sucesso!');
  } else {
    errs.forEach(print);
  }
}
```

<details>
  <summary>Solução para o exemplo de construtores nomeados</summary>

  The declaration for your constructor should begin with `Color.black():`.
  In the initializer list (after the colon),
  set `red`, `green`, and `blue` to `0`.

  ```dart
  Color.black() : red = 0, green = 0, blue = 0;
  ```

</details>

## Construtores factory {:#factory-constructors}

Dart oferece suporte a construtores factory (fábrica),
que podem retornar subtipos ou até mesmo nulos.
Para criar um construtor factory, use a palavra-chave `factory`:

<?code-excerpt "misc/lib/cheatsheet/factory_constructors.dart"?>
```dart
class Square extends Shape {}

class Circle extends Shape {}

class Shape {
  Shape();

  factory Shape.fromTypeName(String typeName) {
    if (typeName == 'square') return Square();
    if (typeName == 'circle') return Circle();

    throw ArgumentError('Unrecognized $typeName');
  }
}
```

### Exercise

Substitua a linha `TODO();` no construtor factory
chamado `IntegerHolder.fromList` para retornar o seguinte:

* Se a lista tiver **um** valor,
  crie uma instância `IntegerSingle` usando esse valor.
* Se a lista tiver **dois** valores,
  crie uma instância `IntegerDouble` usando os valores em ordem.
* Se a lista tiver **três** valores,
  crie uma instância `IntegerTriple` usando os valores em ordem.
* Caso contrário, lance um `Error`.

Se você for bem-sucedido, o console deverá exibir `Sucesso!`.

```dartpad theme="dark"
class IntegerHolder {
  IntegerHolder();

  // Implement this factory constructor.
  factory IntegerHolder.fromList(List<int> list) {
    TODO();
  }
}

class IntegerSingle extends IntegerHolder {
  final int a;

  IntegerSingle(this.a);
}

class IntegerDouble extends IntegerHolder {
  final int a;
  final int b;

  IntegerDouble(this.a, this.b);
}

class IntegerTriple extends IntegerHolder {
  final int a;
  final int b;
  final int c;

  IntegerTriple(this.a, this.b, this.c);
}

// Testa sua solução (Não edite deste ponto até o final do arquivo):
void main() {
  final errs = <String>[];

  // Run 5 tests to see which values have valid integer holders.
  for (var tests = 0; tests < 5; tests++) {
    if (!testNumberOfArgs(errs, tests)) return;
  }

  // The goal is no errors with values 1 to 3,
  // but have errors with values 0 and 4.
  // The testNumberOfArgs method adds to the errs array if
  // the values 1 to 3 have an error and
  // the values 0 and 4 don't have an error.
  if (errs.isEmpty) {
    print('Sucesso!');
  } else {
    errs.forEach(print);
  }
}

bool testNumberOfArgs(List<String> errs, int count) {
  bool _threw = false;
  final ex = List.generate(count, (index) => index + 1);
  final callTxt = "IntegerHolder.fromList(${ex})";
  try {
    final obj = IntegerHolder.fromList(ex);
    final String vals = count == 1 ? "valor" : "valores";
    // Descomente a próxima linha se quiser ver os resultados em tempo real
    // print("Testando com ${count} ${vals} usando ${obj.runtimeType}.");
    testValues(errs, ex, obj, callTxt);
  } on Error {
    _threw = true;
  } catch (e) {
    switch (count) {
      case (< 1 && > 3):
        if (!_threw) {
          errs.add('Chamou ${callTxt} e não lançou um Error.');
        }
      default:
        errs.add('Chamou $callTxt e recebeu um Error.');
    }
  }
  return true;
}

void testValues(List<String> errs, List<int> expectedValues, IntegerHolder obj,
    String callText) {
  for (var i = 0; i < expectedValues.length; i++) {
    int found;
    if (obj is IntegerSingle) {
      found = obj.a;
    } else if (obj is IntegerDouble) {
      found = i == 0 ? obj.a : obj.b;
    } else if (obj is IntegerTriple) {
      found = i == 0
          ? obj.a
          : i == 1
              ? obj.b
              : obj.c;
    } else {
      throw ArgumentError(
          "This IntegerHolder type (${obj.runtimeType}) is unsupported.");
    }

    if (found != expectedValues[i]) {
      errs.add(
          "Called $callText and got a ${obj.runtimeType} " +
          "with a property at index $i value of $found " +
          "instead of the expected (${expectedValues[i]}).");
    }
  }
}
```

<details>
  <summary>Solução para exemplo de construtores de fábrica</summary>

  Dentro do construtor de fábrica,
  verifique o tamanho da lista, em seguida, crie e retorne um
  `IntegerSingle`, `IntegerDouble` ou `IntegerTriple`, conforme apropriado.

  Substitua `TODO();` com o seguinte bloco de código.

  ```dart
    switch (list.length) {
      case 1:
        return IntegerSingle(list[0]);
      case 2:
        return IntegerDouble(list[0], list[1]);
      case 3:
        return IntegerTriple(list[0], list[1], list[2]);
      default:
        throw ArgumentError("List must between 1 and 3 items. This list was ${list.length} items.");
    }
  ```

</details>

## Redirecionando construtores {:#redirecting-constructors}

Às vezes, o único propósito de um construtor é redirecionar para
outro construtor na mesma classe.
O corpo de um construtor de redirecionamento está vazio,
com a chamada do construtor aparecendo após dois pontos (`:`).

<?code-excerpt "misc/lib/cheatsheet/redirecting_constructors.dart (redirecting-constructors)"?>
```dart
class Automobile {
  String make;
  String model;
  int mpg;

  // The main constructor for this class.
  Automobile(this.make, this.model, this.mpg);

  // Delegates to the main constructor.
  Automobile.hybrid(String make, String model) : this(make, model, 60);

  // Delegates to a named constructor
  Automobile.fancyHybrid() : this.hybrid('Futurecar', 'Mark 2');
}
```

### Exercise

Lembre-se da classe `Color` acima? Crie um construtor nomeado chamado `black`,
mas em vez de atribuir manualmente as propriedades, redirecione-o para o
construtor padrão com zeros como argumentos.

Ignore todos os erros iniciais no DartPad.

```dartpad theme="dark"
class Color {
  int red;
  int green;
  int blue;

  Color(this.red, this.green, this.blue);

  // TODO: Crie um construtor nomeado chamado "black" aqui
  // e redirecione-o para chamar o construtor existente
}


// Testa sua solução (Não edite!):
void main() {
  final errs = <String>[];

  try {
    final result = Color.black();

    if (result.red != 0) {
      errs.add('Chamou Color.black() e obteve um Color com vermelho igual a \n ${result.red} em vez do valor esperado (0).');
    }

    if (result.green != 0) {
      errs.add('Chamou Color.black() e obteve um Color com verde igual a \n ${result.green} em vez do valor esperado (0).');
    }

    if (result.blue != 0) {
  errs.add('Chamou Color.black() e obteve um Color com azul igual a \n ${result.blue} em vez do valor esperado (0).');
    }
  } catch (e) {
    print('Chamou Color.black() e obteve uma exceção do tipo ${e.runtimeType}.');
    return;
  }

  if (errs.isEmpty) {
    print('Sucesso!');
  } else {
    errs.forEach(print);
  }
}
```

<details>
  <summary>Solução para exemplo de redirecionamento de construtores</summary>

  Seu construtor deve redirecionar para `this(0, 0, 0)`.

  ```dart
  Color.black() : this(0, 0, 0);
  ```

</details>

## Construtores Constantes {:#const-constructors}

If your class produces objects that never change,
you can make these objects compile-time constants.
To do this, define a `const` constructor and
make sure that all instance variables are final.

<?code-excerpt "misc/lib/cheatsheet/redirecting_constructors.dart (const-constructors)"?>
```dart
class ImmutablePoint {
  static const ImmutablePoint origin = ImmutablePoint(0, 0);

  final int x;
  final int y;

  const ImmutablePoint(this.x, this.y);
}
```

### Exercise

Modifique a classe `Recipe` para que suas instâncias possam ser constantes,
e crie um construtor constante que faça o seguinte:

* Tenha três parâmetros: `ingredients` (ingredientes), `calories` (calorias)
  e `milligramsOfSodium` (miligramas de sódio) (nessa ordem).
* Use a sintaxe `this.` para atribuir automaticamente os valores dos parâmetros às
  propriedades do objeto com o mesmo nome.
* Seja constante, com a palavra-chave `const` logo antes
  de `Recipe` na declaração do construtor.

Ignore todos os erros iniciais no DartPad.

```dartpad theme="dark"
class Recipe {
  List<String> ingredients;
  int calories;
  double milligramsOfSodium;

  // TODO: Create a const constructor here.

}


// Testa sua solução (Não edite!):
void main() {
  final errs = <String>[];

  try {
    const obj = Recipe(['1 egg', 'Pat of butter', 'Pinch salt'], 120, 200);

    if (obj.ingredients.length != 3) {
      errs.add('Chamou Recipe([\'1 ovo\', \'Um pouco de manteiga\', \'Pitada de sal\'], 120, 200) \n e obteve um objeto com lista de ingredientes de tamanho ${obj.ingredients.length} em vez do tamanho esperado (3).');
    }

    if (obj.calories != 120) {
      errs.add('Chamou Recipe([\'1 ovo\', \'Um pouco de manteiga\', \'Pitada de sal\'], 120, 200) \n e obteve um objeto com um valor de caloria de ${obj.calories} em vez do valor esperado (120).');
    }

    if (obj.milligramsOfSodium != 200) {
      errs.add('Chamou Recipe([\'1 ovo\', \'Um pouco de manteiga\', \'Pitada de sal\'], 120, 200) \n e obteve um objeto com um valor de miligramas de sódio de ${obj.milligramsOfSodium} em vez do valor esperado (200).');
    }

    try {
      obj.ingredients.add('Sugar to taste');
      errs.add('Tried adding an item to the \'ingredients\' list of a const Recipe and didn\'t get an error due to it being unmodifiable.');
    } on UnsupportedError catch (_) {
      // We expect an `UnsupportedError` due to
      // `ingredients` being a const, unmodifiable list.
    }
  } catch (e) {
    print('Tentou chamar Recipe([\'1 ovo\', \'Um pouco de manteiga\', \'Pitada de sal\'], 120, 200) \n e recebeu um nulo.');
  }

  if (errs.isEmpty) {
    print('Sucesso!');
  } else {
    errs.forEach(print);
  }
}
```

<details>
  <summary>Solução para o exemplo de construtores const</summary>

  Para tornar o construtor `const`, você precisará tornar todas as propriedades `final`.

  ```dart
  class Recipe {
    final List<String> ingredients;
    final int calories;
    final double milligramsOfSodium;

    const Recipe(this.ingredients, this.calories, this.milligramsOfSodium);
  }
  ```

</details>

## O que vem a seguir? {:#what-s-next}

Esperamos que você tenha gostado de usar este tutorial para aprender ou testar seu conhecimento sobre
algumas das características mais interessantes da linguagem Dart.

O que você pode experimentar a seguir inclui:

* Experimente [outros tutoriais Dart](/tutorials).
* Leia o [tour pela linguagem Dart](/language).
* Brinque com o [DartPad.]({{site.dartpad}})
* [Obtenha o SDK do Dart](/get-dart).
