---
title: Folha de referência do Dart
breadcrumb: Folha de referência
description: Aprenda (ou reaprenda) interativamente alguns dos recursos únicos do Dart.
maxTocDepth: 2
ia-translate: true
---
<?code-excerpt replace="/ *\/\/\s+ignore_for_file:[^\n]+\n//g; /(^|\n) *\/\/\s+ignore:[^\n]+\n/$1/g; /(\n[^\n]+) *\/\/\s+ignore:[^\n]+\n/$1\n/g"?>

A linguagem Dart foi projetada para ser fácil de aprender para
programadores vindos de outras linguagens,
mas possui alguns recursos únicos.
Este tutorial guia você através dos
mais importantes desses recursos da linguagem.

Os editores incorporados neste tutorial têm trechos de código parcialmente completados.
Você pode usar esses editores para testar seu conhecimento completando o código e
clicando no botão **Run**. Os editores também contêm código de teste completo;
**não edite o código de teste**, mas sinta-se à vontade para estudá-lo para aprender sobre testes.


Se precisar de ajuda, expanda o dropdown **Solution for...** abaixo de cada DartPad
para obter uma explicação e a resposta.

:::note
Esta página usa DartPads incorporados para exibir exemplos executáveis.
{% render 'dartpads-embedded-troubleshooting.md' %}
:::

## Interpolação de strings

Para colocar o valor de uma expressão dentro de uma string, use `${expression}`.
Se a expressão for um identificador, você pode omitir as `{}`.

Aqui estão alguns exemplos de uso de interpolação de strings:

| String                      | Resultado                          |
|-----------------------------|------------------------------------|
| `'${3 + 2}'`                | `'5'`                              |
| `'${"word".toUpperCase()}'` | `'WORD'`                           |
| `'$myObject'`               | O valor de `myObject.toString()`   |

### Exercício

A função a seguir recebe dois inteiros como parâmetros.
Faça com que ela retorne uma string contendo ambos os inteiros separados por um espaço.
Por exemplo, `stringify(2, 3)` deve retornar `'2 3'`.

```dartpad theme="dark"
String stringify(int x, int y) {
  TODO('Return a formatted string here');
}


// Tests your solution (Don't edit!):
void main() {
  assert(stringify(2, 3) == '2 3',
      "Your stringify method returned '${stringify(2, 3)}' instead of '2 3'");
  print('Success!');
}
```

<details>
  <summary>Solução para exemplo de interpolação de strings</summary>

  Tanto `x` quanto `y` são valores simples,
  e a interpolação de strings do Dart cuidará de
  convertê-los em representações de string.
  Tudo que você precisa fazer é usar o operador `$` para
  referenciá-los dentro de aspas simples, com um espaço entre eles:

  ```dart
  String stringify(int x, int y) {
    return '$x $y';
  }
  ```

</details>


## Variáveis anuláveis

Dart impõe null safety sólido.
Isso significa que os valores não podem ser null a menos que você diga que podem ser.
Em outras palavras, os tipos são não anuláveis por padrão.

Por exemplo, considere o seguinte código.
Com null safety, este código retorna um erro.
Uma variável do tipo `int` não pode ter o valor `null`:

<?code-excerpt "misc/bin/cheatsheet/nullable.dart (invalid-null)" replace="/null;/[!null!];/g"?>
```dart
int a = [!null!]; // INVALID.
```

Ao criar uma variável, adicione `?` ao tipo para indicar
que a variável pode ser `null`:

<?code-excerpt "misc/bin/cheatsheet/nullable.dart (valid-null)" replace="/int\?/[!int?!]/g"?>
```dart
[!int?!] a = null; // Válido.
```

Você pode simplificar esse código um pouco porque, em todas as versões do Dart,
`null` é o valor padrão para variáveis não inicializadas:

<?code-excerpt "misc/bin/cheatsheet/nullable.dart (simple-null)"?>
```dart
int? a; // O valor inicial de a é null.
```

Para aprender mais sobre null safety no Dart,
leia o [guia de null safety sólido](/null-safety).

### Exercício

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
      print('Success!');
    } else {
      print('Not quite right, try again!');
    }
  } catch (e) {
    print('Exception: ${e.runtimeType}');
  }
}
```

<details>
  <summary>Solução para exemplo de variáveis anuláveis</summary>

  Declare as duas variáveis como `String` seguido de `?`.
  Em seguida, atribua `'Jane'` a `name`
  e deixe `address` não inicializado:

  ```dart
  String? name = 'Jane';
  String? address;
  ```

</details>

## Operadores null-aware

Dart oferece alguns operadores úteis para lidar com valores que podem ser null. Um deles é o
operador de atribuição `??=`, que atribui um valor a uma variável apenas se essa
variável estiver atualmente null:

<?code-excerpt "misc/test/cheatsheet/null_aware_test.dart (null-aware-operators)"?>
```dart
int? a; // = null
a ??= 3;
print(a); // <-- Prints 3.

a ??= 5;
print(a); // <-- Still prints 3.
```

Outro operador null-aware é `??`,
que retorna a expressão à sua esquerda a menos que
o valor dessa expressão seja null,
caso em que ele avalia e retorna a expressão à sua direita:

<?code-excerpt "misc/test/cheatsheet/null_aware_test.dart (null-aware-operators-2)"?>
```dart
print(1 ?? 3); // <-- Imprime 1.
print(null ?? 12); // <-- Imprime 12.
```

### Exercício

Tente substituir pelos operadores `??=` e `??`
para implementar o comportamento descrito no seguinte trecho.

Ignore todos os erros iniciais no DartPad.

```dartpad theme="dark"
String? foo = 'a string';
String? bar; // = null

// Substitute an operator that makes 'a string' be assigned to baz.
String? baz = foo /* TODO */ bar;

void updateSomeVars() {
  // Substitute an operator that makes 'a string' be assigned to bar.
  bar /* TODO */ 'a string';
}


// Tests your solution (Don't edit!):
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
      print('Success!');
    }
  } catch (e) {
    print('Exception: ${e.runtimeType}.');
  }
}
```

<details>
  <summary>Solução para exemplo de operadores null-aware</summary>

  Tudo que você precisa fazer neste exercício é
  substituir os comentários `TODO` por `??` ou `??=`.
  Leia o texto acima para ter certeza de que entende ambos,
  e então tente:

  ```dart
  // Substitua por um operador que faz 'a string' ser atribuída a baz.
  String? baz = foo ?? bar;

  void updateSomeVars() {
    // Substitua por um operador que faz 'a string' ser atribuída a bar.
    bar ??= 'a string';
  }
  ```

</details>


## Acesso condicional a propriedades

Para proteger o acesso a uma propriedade ou método de um objeto que pode ser null,
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

Você pode encadear múltiplos usos de `?.` em uma única expressão:

<?code-excerpt "misc/test/cheatsheet/null_aware_test.dart (conditional-property-access-multiple)" replace="/result = //g; /;//g;"?>
```dart
myObject?.someProperty?.someMethod()
```

O código anterior retorna null (e nunca chama `someMethod()`) se
`myObject` ou `myObject.someProperty` for null.


### Exercício

A função a seguir recebe uma string anulável como parâmetro.
Tente usar acesso condicional a propriedades para fazê-la
retornar a versão em maiúsculas de `str`, ou `null` se `str` for `null`.

```dartpad theme="dark"
String? upperCaseIt(String? str) {
  // TODO: Try conditionally accessing the `toUpperCase` method here.
}


// Tests your solution (Don't edit!):
void main() {
  try {
    String? one = upperCaseIt(null);
    if (one != null) {
      print('Looks like you\'re not returning null for null inputs.');
    } else {
      print('Success when str is null!');
    }
  } catch (e) {
    print('Tried calling upperCaseIt(null) and got an exception: \n ${e.runtimeType}.');
  }

  try {
    String? two = upperCaseIt('a string');
    if (two == null) {
      print('Looks like you\'re returning null even when str has a value.');
    } else if (two != 'A STRING') {
      print('Tried upperCaseIt(\'a string\'), but didn\'t get \'A STRING\' in response.');
    } else {
      print('Success when str is not null!');
    }
  } catch (e) {
    print('Tried calling upperCaseIt(\'a string\') and got an exception: \n ${e.runtimeType}.');
  }
}
```

<details>
  <summary>Solução para exemplo de acesso condicional a propriedades</summary>

  Se este exercício quisesse que você colocasse condicionalmente uma string em minúsculas,
  você poderia fazer assim: `str?.toLowerCase()`. Use o método equivalente
  para colocar uma string em maiúsculas!

  ```dart
  String? upperCaseIt(String? str) {
    return str?.toUpperCase();
  }
  ```

</details>

## Literais de coleções

Dart tem suporte integrado para listas, maps e sets.
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

Especificar tipos é útil quando você inicializa uma lista com conteúdo de um subtipo,
mas ainda quer que a lista seja `List<BaseType>`:

<?code-excerpt "misc/test/cheatsheet/collections_test.dart (collection-literals-subtypes)"?>
```dart
final aListOfBaseType = <BaseType>[SubType(), SubType()];
```

### Exercício

Tente definir as seguintes variáveis para os valores indicados. Substitua os valores null existentes.

```dartpad theme="dark"
// Assign this a list containing 'a', 'b', and 'c' in that order:
final aListOfStrings = null;

// Assign this a set containing 3, 4, and 5:
final aSetOfInts = null;

// Assign this a map of String to int so that aMapOfStringsToInts['myKey'] returns 12:
final aMapOfStringsToInts = null;

// Assign this an empty List<double>:
final anEmptyListOfDouble = null;

// Assign this an empty Set<String>:
final anEmptySetOfString = null;

// Assign this an empty Map of double to int:
final anEmptyMapOfDoublesToInts = null;


// Tests your solution (Don't edit!):
void main() {
  final errs = <String>[];

  if (aListOfStrings is! List<String>) {
    errs.add('aListOfStrings should have the type List<String>.');
  } else if (aListOfStrings.length != 3) {
    errs.add('aListOfStrings has ${aListOfStrings.length} items in it, \n rather than the expected 3.');
  } else if (aListOfStrings[0] != 'a' || aListOfStrings[1] != 'b' || aListOfStrings[2] != 'c') {
    errs.add('aListOfStrings doesn\'t contain the correct values (\'a\', \'b\', \'c\').');
  }

  if (aSetOfInts is! Set<int>) {
    errs.add('aSetOfInts should have the type Set<int>.');
  } else if (aSetOfInts.length != 3) {
    errs.add('aSetOfInts has ${aSetOfInts.length} items in it, \n rather than the expected 3.');
  } else if (!aSetOfInts.contains(3) || !aSetOfInts.contains(4) || !aSetOfInts.contains(5)) {
    errs.add('aSetOfInts doesn\'t contain the correct values (3, 4, 5).');
  }

  if (aMapOfStringsToInts is! Map<String, int>) {
    errs.add('aMapOfStringsToInts should have the type Map<String, int>.');
  } else if (aMapOfStringsToInts['myKey'] != 12) {
    errs.add('aMapOfStringsToInts doesn\'t contain the correct values (\'myKey\': 12).');
  }

  if (anEmptyListOfDouble is! List<double>) {
    errs.add('anEmptyListOfDouble should have the type List<double>.');
  } else if (anEmptyListOfDouble.isNotEmpty) {
    errs.add('anEmptyListOfDouble should be empty.');
  }

  if (anEmptySetOfString is! Set<String>) {
    errs.add('anEmptySetOfString should have the type Set<String>.');
  } else if (anEmptySetOfString.isNotEmpty) {
    errs.add('anEmptySetOfString should be empty.');
  }

  if (anEmptyMapOfDoublesToInts is! Map<double, int>) {
    errs.add('anEmptyMapOfDoublesToInts should have the type Map<double, int>.');
  } else if (anEmptyMapOfDoublesToInts.isNotEmpty) {
    errs.add('anEmptyMapOfDoublesToInts should be empty.');
  }

  if (errs.isEmpty) {
    print('Success!');
  } else {
    errs.forEach(print);
  }

  // ignore_for_file: unnecessary_type_check
}
```

<details>
  <summary>Solução para exemplo de literais de coleções</summary>

  Adicione um literal de lista, set ou map após cada sinal de igual (`=`).
  Lembre-se de especificar os tipos para as declarações vazias,
  pois eles não podem ser inferidos.

  ```dart
  // Atribua a isso uma lista contendo 'a', 'b' e 'c' nessa ordem:
  final aListOfStrings = ['a', 'b', 'c'];

  // Atribua a isso um set contendo 3, 4 e 5:
  final aSetOfInts = {3, 4, 5};

  // Atribua a isso um map de String para int de forma que aMapOfStringsToInts['myKey'] retorne 12:
  final aMapOfStringsToInts = {'myKey': 12};

  // Atribua a isso uma List<double> vazia:
  final anEmptyListOfDouble = <double>[];

  // Atribua a isso um Set<String> vazio:
  final anEmptySetOfString = <String>{};

  // Atribua a isso um Map vazio de double para int:
  final anEmptyMapOfDoublesToInts = <double, int>{};
  ```

</details>

## Sintaxe arrow

Você pode ter visto o símbolo `=>` em código Dart.
Esta sintaxe arrow é uma forma de definir uma função que executa a
expressão à sua direita e retorna seu valor.

Por exemplo, considere esta chamada ao método `any()` da classe `List`:

<?code-excerpt "misc/test/cheatsheet/arrow_functions_test.dart (has-empty-long)"?>
```dart
bool hasEmpty = aListOfStrings.any((s) {
  return s.isEmpty;
});
```

Aqui está uma forma mais simples de escrever esse código:

<?code-excerpt "misc/test/cheatsheet/arrow_functions_test.dart (has-empty-short)"?>
```dart
bool hasEmpty = aListOfStrings.any((s) => s.isEmpty);
```

### Exercício

Tente completar as seguintes instruções, que usam sintaxe arrow.

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


// Tests your solution (Don't edit!):
void main() {
  final obj = MyClass();
  final errs = <String>[];

  try {
    final product = obj.product;

    if (product != 30) {
      errs.add('The product property returned $product \n instead of the expected value (30).');
    }
  } catch (e) {
    print('Tried to use MyClass.product, but encountered an exception: \n ${e.runtimeType}.');
    return;
  }

  try {
    obj.incrementValue1();

    if (obj.value1 != 3) {
      errs.add('After calling incrementValue, value1 was ${obj.value1} \n instead of the expected value (3).');
    }
  } catch (e) {
    print('Tried to use MyClass.incrementValue1, but encountered an exception: \n ${e.runtimeType}.');
    return;
  }

  try {
    final joined = obj.joinWithCommas(['one', 'two', 'three']);

    if (joined != 'one,two,three') {
      errs.add('Tried calling joinWithCommas([\'one\', \'two\', \'three\']) \n and received $joined instead of the expected value (\'one,two,three\').');
    }
  } catch (e) {
    print('Tried to use MyClass.joinWithCommas, but encountered an exception: \n ${e.runtimeType}.');
    return;
  }

  if (errs.isEmpty) {
    print('Success!');
  } else {
    errs.forEach(print);
  }
}
```

<details>
  <summary>Solução para exemplo de sintaxe arrow</summary>

  Para o produto, você pode usar `*` para multiplicar os três valores juntos.
  Para `incrementValue1`, você pode usar o operador de incremento (`++`).
  Para `joinWithCommas`, use o método `join` encontrado na classe `List`.

  ```dart
  class MyClass {
    int value1 = 2;
    int value2 = 3;
    int value3 = 5;

    // Retorna o produto dos valores acima:
    int get product => value1 * value2 * value3;

    // Adiciona 1 a value1:
    void incrementValue1() => value1++;

    // Retorna uma string contendo cada item na
    // lista, separados por vírgulas (ex: 'a,b,c'):
    String joinWithCommas(List<String> strings) => strings.join(',');
  }
  ```
</details>


## Cascatas

Para executar uma sequência de operações no mesmo objeto, use cascatas (`..`).
Todos nós já vimos uma expressão como esta:

<?code-excerpt "misc/bin/cheatsheet/cascades.dart (no-cascade)" replace="/;//g"?>
```dart
myObject.someMethod()
```

Ela invoca `someMethod()` em `myObject`, e o resultado da
expressão é o valor de retorno de `someMethod()`.

Aqui está a mesma expressão com uma cascata:

<?code-excerpt "misc/bin/cheatsheet/cascades.dart (uses-cascade)" replace="/;//g"?>
```dart
myObject..someMethod()
```

Embora ainda invoque `someMethod()` em `myObject`, o resultado
da expressão **não é** o valor de retorno—é uma referência a `myObject`!

Usando cascatas, você pode encadear operações que
de outra forma exigiriam instruções separadas.
Por exemplo, considere o seguinte código,
que usa o operador de acesso condicional a membro (`?.`)
para ler propriedades de `button` se não for `null`:

<?code-excerpt "misc/bin/cheatsheet/cascades.dart (query-without-cascades)"?>
```dart
final button = web.document.querySelector('#confirm');
button?.textContent = 'Confirm';
button?.classList.add('important');
button?.onClick.listen((e) => web.window.alert('Confirmed!'));
button?.scrollIntoView();
```

Para usar cascatas em vez disso,
você pode começar com a cascata _null-shorting_ (`?..`),
que garante que nenhuma das operações em cascata
seja tentada em um objeto `null`.
Usar cascatas encurta o código
e torna a variável `button` desnecessária:

<?code-excerpt "misc/bin/cheatsheet/cascades.dart (query-with-cascades)"?>
```dart
web.document.querySelector('#confirm')
  ?..textContent = 'Confirm'
  ..classList.add('important')
  ..onClick.listen((e) => web.window.alert('Confirmed!'))
  ..scrollIntoView();
```

### Exercício

Use cascatas para criar uma única instrução que
defina as propriedades `anInt`, `aString` e `aList` de um `BigObject`
para `1`, `'String!'` e `[3.0]` (respectivamente)
e então chame `allDone()`.

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

BigObject fillBigObject(BigObject obj) {
  // Create a single statement that will update and return obj:
  return TODO('obj..');
}


// Tests your solution (Don't edit!):
void main() {
  BigObject obj;

  try {
    obj = fillBigObject(BigObject());
  } catch (e) {
    print('Caught an exception of type ${e.runtimeType} \n while running fillBigObject');
    return;
  }

  final errs = <String>[];

  if (obj.anInt != 1) {
    errs.add(
        'The value of anInt was ${obj.anInt} \n rather than the expected (1).');
  }

  if (obj.aString != 'String!') {
    errs.add(
        'The value of aString was \'${obj.aString}\' \n rather than the expected (\'String!\').');
  }

  if (obj.aList.length != 1) {
    errs.add(
        'The length of aList was ${obj.aList.length} \n rather than the expected value (1).');
  } else {
    if (obj.aList[0] != 3.0) {
      errs.add(
          'The value found in aList was ${obj.aList[0]} \n rather than the expected (3.0).');
    }
  }

  if (!obj._done) {
    errs.add('It looks like allDone() wasn\'t called.');
  }

  if (errs.isEmpty) {
    print('Success!');
  } else {
    errs.forEach(print);
  }
}
```

<details>
  <summary>Solução para exemplo de cascatas</summary>

  A melhor solução para este exercício começa com `obj..` e
  tem quatro operações de atribuição encadeadas juntas.
  Comece com `return obj..anInt = 1`,
  depois adicione outra cascata (`..`) e inicie a próxima atribuição.

  ```dart
  BigObject fillBigObject(BigObject obj) {
    return obj
      ..anInt = 1
      ..aString = 'String!'
      ..aList.add(3)
      ..allDone();
  }
  ```
</details>


## Getters e setters

Você pode definir getters e setters
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

Você também pode usar um getter para definir uma propriedade computada:

<?code-excerpt "misc/lib/cheatsheet/getter_compute.dart"?>
```dart
class MyClass {
  final List<int> _values = [];

  void addValue(int value) {
    _values.add(value);
  }

  // Uma propriedade computada.
  int get count {
    return _values.length;
  }
}
```

### Exercício

Imagine que você tem uma classe de carrinho de compras que mantém uma
`List<double>` privada de preços.
Adicione o seguinte:

* Um getter chamado `total` que retorna a soma dos preços
* Um setter que substitui a lista por uma nova,
  desde que a nova lista não contenha preços negativos
  (caso contrário, o setter deve lançar uma `InvalidPriceException`).

Ignore todos os erros iniciais no DartPad.

```dartpad theme="dark"
class InvalidPriceException {}

class ShoppingCart {
  List<double> _prices = [];

  // TODO: Add a "total" getter here:

  // TODO: Add a "prices" setter here:
}


// Tests your solution (Don't edit!):
void main() {
  var foundException = false;

  try {
    final cart = ShoppingCart();
    cart.prices = [12.0, 12.0, -23.0];
  } on InvalidPriceException {
    foundException = true;
  } catch (e) {
    print('Tried setting a negative price and received a ${e.runtimeType} \n instead of an InvalidPriceException.');
    return;
  }

  if (!foundException) {
    print('Tried setting a negative price \n and didn\'t get an InvalidPriceException.');
    return;
  }

  final secondCart = ShoppingCart();

  try {
    secondCart.prices = [1.0, 2.0, 3.0];
  } catch(e) {
    print('Tried setting prices with a valid list, \n but received an exception: ${e.runtimeType}.');
    return;
  }

  if (secondCart._prices.length != 3) {
    print('Tried setting prices with a list of three values, \n but _prices ended up having length ${secondCart._prices.length}.');
    return;
  }

  if (secondCart._prices[0] != 1.0 || secondCart._prices[1] != 2.0 || secondCart._prices[2] != 3.0) {
    final vals = secondCart._prices.map((p) => p.toString()).join(', ');
    print('Tried setting prices with a list of three values (1, 2, 3), \n but incorrect ones ended up in the price list ($vals) .');
    return;
  }

  var sum = 0.0;

  try {
    sum = secondCart.total;
  } catch (e) {
    print('Tried to get total, but received an exception: ${e.runtimeType}.');
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
  <summary>Solução para exemplo de getters e setters</summary>

  Duas funções são úteis para este exercício.
  Uma é `fold`, que pode reduzir uma lista a um único valor
  (use-a para calcular o total).
  A outra é `any`, que pode verificar cada item em uma lista
  com uma função que você fornece
  (use-a para verificar se há preços negativos no setter `prices`).

  ```dart
  /// O preço total do carrinho de compras.
  double get total => _prices.fold(0, (e, t) => e + t);

  /// Define [prices] para a lista [value] de preços de itens.
  set prices(List<double> value) {
    if (value.any((p) => p < 0)) {
      throw InvalidPriceException();
    }

    _prices = value;
  }
  ```

</details>


## Parâmetros posicionais opcionais

Dart tem dois tipos de parâmetros de função: posicionais e nomeados.
Parâmetros posicionais são o tipo com o qual você provavelmente está familiarizado:

<?code-excerpt "misc/lib/cheatsheet/optional_positional_args.dart (optional-positional-args)"?>
```dart
int sumUp(int a, int b, int c) {
  return a + b + c;
}
  // ···
  int total = sumUp(1, 2, 3);
```

Com Dart, você pode tornar esses parâmetros posicionais opcionais envolvendo-os em colchetes:

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

Parâmetros posicionais opcionais estão sempre no final
da lista de parâmetros de uma função.
Seu valor padrão é null a menos que você forneça outro valor padrão:

<?code-excerpt "misc/lib/cheatsheet/optional_positional_args2.dart (sum-no-impl)"?>
```dart
int sumUpToFive(int a, [int b = 2, int c = 3, int d = 4, int e = 5]) {
  // ···
}

void main() {
  int newTotal = sumUpToFive(1);
  print(newTotal); // <-- imprime 15
}
```

### Exercício

Implemente uma função chamada `joinWithCommas()` que aceita de um a
cinco inteiros e então retorna uma string desses números separados por vírgulas.
Aqui estão alguns exemplos de chamadas de função e valores retornados:

| Chamada de função               | Valor retornado |
|---------------------------------|----------------|
| `joinWithCommas(1)`             | `'1'`          |
| `joinWithCommas(1, 2, 3)`       | `'1,2,3'`      |
| `joinWithCommas(1, 1, 1, 1, 1)` | `'1,1,1,1,1'`  |

<br>

```dartpad theme="dark"
String joinWithCommas(int a, [int? b, int? c, int? d, int? e]) {
  return TODO();
}


// Tests your solution (Don't edit!):
void main() {
  final errs = <String>[];

  try {
    final value = joinWithCommas(1);

    if (value != '1') {
      errs.add('Tried calling joinWithCommas(1) \n and got $value instead of the expected (\'1\').');
    }
  } on UnimplementedError {
    print('Tried to call joinWithCommas but failed. \n Did you implement the method?');
    return;
  } catch (e) {
    print('Tried calling joinWithCommas(1), \n but encountered an exception: ${e.runtimeType}.');
    return;
  }

  try {
    final value = joinWithCommas(1, 2, 3);

    if (value != '1,2,3') {
      errs.add('Tried calling joinWithCommas(1, 2, 3) \n and got $value instead of the expected (\'1,2,3\').');
    }
  } on UnimplementedError {
    print('Tried to call joinWithCommas but failed. \n Did you implement the method?');
    return;
  } catch (e) {
    print('Tried calling joinWithCommas(1, 2 ,3), \n but encountered an exception: ${e.runtimeType}.');
    return;
  }

  try {
    final value = joinWithCommas(1, 2, 3, 4, 5);

    if (value != '1,2,3,4,5') {
      errs.add('Tried calling joinWithCommas(1, 2, 3, 4, 5) \n and got $value instead of the expected (\'1,2,3,4,5\').');
    }
  } on UnimplementedError {
    print('Tried to call joinWithCommas but failed. \n Did you implement the method?');
    return;
  } catch (e) {
    print('Tried calling stringify(1, 2, 3, 4 ,5), \n but encountered an exception: ${e.runtimeType}.');
    return;
  }

  if (errs.isEmpty) {
    print('Success!');
  } else {
    errs.forEach(print);
  }
}
```

<details>
  <summary>Solução para exemplo de parâmetros posicionais</summary>

  Os parâmetros `b`, `c`, `d` e `e` são null se não forem fornecidos pelo
  chamador. A coisa importante, então, é verificar se esses argumentos são `null`
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
## Parâmetros nomeados

Usando uma sintaxe de chaves no final da lista de parâmetros,
você pode definir parâmetros que têm nomes.

Parâmetros nomeados são opcionais
a menos que sejam explicitamente marcados como `required`.

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

Se o tipo de um parâmetro não é anulável,
então você deve fornecer um valor padrão
(como mostrado no código a seguir)
ou marcar o parâmetro como `required`
(como mostrado na
[seção de construtores](#using-this-in-a-constructor)).

<?code-excerpt "misc/test/cheatsheet/arguments_test.dart (defaulted-middle)" replace="/ = ''/[! = ''!]/g;"?>
```dart
void printName(String firstName, String lastName, {String middleName[! = ''!]}) {
  print('$firstName $middleName $lastName');
}
```

Uma função não pode ter parâmetros posicionais opcionais e nomeados ao mesmo tempo.


### Exercício

Adicione um método de instância `copyWith()` à classe `MyDataObject`.
Ele deve receber três parâmetros nomeados e anuláveis:

* `int? newInt`
* `String? newString`
* `double? newDouble`

Seu método `copyWith()` deve retornar um novo `MyDataObject`
baseado na instância atual,
com dados dos parâmetros anteriores (se houver)
copiados nas propriedades do objeto.
Por exemplo, se `newInt` não for null,
então copie seu valor em `anInt`.

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

  // TODO: Add your copyWith method here:
}


// Tests your solution (Don't edit!):
void main() {
  final source = MyDataObject();
  final errs = <String>[];

  try {
    final copy = source.copyWith(newInt: 12, newString: 'New!', newDouble: 3.0);

    if (copy.anInt != 12) {
      errs.add('Called copyWith(newInt: 12, newString: \'New!\', newDouble: 3.0), \n and the new object\'s anInt was ${copy.anInt} rather than the expected value (12).');
    }

    if (copy.aString != 'New!') {
      errs.add('Called copyWith(newInt: 12, newString: \'New!\', newDouble: 3.0), \n and the new object\'s aString was ${copy.aString} rather than the expected value (\'New!\').');
    }

    if (copy.aDouble != 3) {
      errs.add('Called copyWith(newInt: 12, newString: \'New!\', newDouble: 3.0), \n and the new object\'s aDouble was ${copy.aDouble} rather than the expected value (3).');
    }
  } catch (e) {
    print('Called copyWith(newInt: 12, newString: \'New!\', newDouble: 3.0) \n and got an exception: ${e.runtimeType}');
  }

  try {
    final copy = source.copyWith();

    if (copy.anInt != 1) {
      errs.add('Called copyWith(), and the new object\'s anInt was ${copy.anInt} \n rather than the expected value (1).');
    }

    if (copy.aString != 'Old!') {
      errs.add('Called copyWith(), and the new object\'s aString was ${copy.aString} \n rather than the expected value (\'Old!\').');
    }

    if (copy.aDouble != 2) {
      errs.add('Called copyWith(), and the new object\'s aDouble was ${copy.aDouble} \n rather than the expected value (2).');
    }
  } catch (e) {
    print('Called copyWith() and got an exception: ${e.runtimeType}');
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
    print('Success!');
  } else {
    errs.forEach(print);
  }
}
```

<details>
  <summary>Solução para exemplo de parâmetros nomeados</summary>

  O método `copyWith` aparece em muitas classes e bibliotecas.
  O seu deve fazer algumas coisas:
  usar parâmetros nomeados opcionais,
  criar uma nova instância de `MyDataObject`,
  e usar os dados dos parâmetros para preenchê-la
  (ou os dados da instância atual se os parâmetros forem null).
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


## Exceções

Código Dart pode lançar e capturar exceções.
Em contraste com Java, todas as exceções do Dart não são verificadas.
Métodos não declaram quais exceções eles podem lançar e
você não é obrigado a capturar nenhuma exceção.

Dart fornece os tipos `Exception` e `Error`, mas você pode
lançar qualquer objeto não nulo:

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
  // Uma exceção específica
  buyMoreLlamas();
} on Exception catch (e) {
  // Qualquer outra coisa que seja uma exceção
  print('Unknown exception: $e');
} catch (e) {
  // Nenhum tipo especificado, lida com tudo
  print('Something really unknown: $e');
}
```

A palavra-chave `try` funciona como na maioria das outras linguagens.
Use a palavra-chave `on` para filtrar exceções específicas por tipo,
e a palavra-chave `catch` para obter uma referência ao objeto de exceção.

Se você não pode lidar completamente com a exceção, use a palavra-chave `rethrow`
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

Para executar código seja ou não lançada uma exceção,
use `finally`:

<?code-excerpt "misc/test/cheatsheet/exceptions_test.dart (try-catch-finally)"?>
```dart
try {
  breedMoreLlamas();
} catch (e) {
  // ... lidar com exceção ...
} finally {
  // Sempre limpar, mesmo se uma exceção for lançada.
  cleanLlamaStalls();
}
```

### Exercício

Implemente `tryFunction()` abaixo. Ela deve executar um método não confiável e
então fazer o seguinte:

* Se `untrustworthy()` lançar uma `ExceptionWithMessage`,
  chame `logger.logException` com o tipo de exceção e mensagem
  (tente usar `on` e `catch`).
* Se `untrustworthy()` lançar uma `Exception`,
  chame `logger.logException` com o tipo de exceção
  (tente usar `on` para este).
* Se `untrustworthy()` lançar qualquer outro objeto, não capture a exceção.
* Depois de tudo ser capturado e tratado, chame `logger.doneLogging`
  (tente usar `finally`).

```dartpad theme="dark"
typedef VoidFunction = void Function();

class ExceptionWithMessage {
  final String message;
  const ExceptionWithMessage(this.message);
}

// Call logException to log an exception, and doneLogging when finished.
abstract class Logger {
  void logException(Type t, [String? msg]);
  void doneLogging();
}

void tryFunction(VoidFunction untrustworthy, Logger logger) {
  try {
    untrustworthy();
  } // Write your logic here
}

// Tests your solution (Don't edit!):
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
      errs.add('Untrustworthy threw an Exception, but a different type was logged: \n ${logger.lastType}.');
    }

    if (logger.lastMessage != '') {
      errs.add('Untrustworthy threw an Exception with no message, but a message \n was logged anyway: \'${logger.lastMessage}\'.');
    }

    if (!logger.done) {
      errs.add('Untrustworthy threw an Exception, \n and doneLogging() wasn\'t called afterward.');
    }
  } catch (e) {
    print('Untrustworthy threw an exception, and an exception of type \n ${e.runtimeType} was unhandled by tryFunction.');
  }

  logger = MyLogger();

  try {
    tryFunction(() => throw ExceptionWithMessage('Hey!'), logger);

    if (logger.lastType != ExceptionWithMessage) {
      errs.add('Untrustworthy threw an ExceptionWithMessage(\'Hey!\'), but a \n different type was logged: ${logger.lastType}.');
    }

    if (logger.lastMessage != 'Hey!') {
      errs.add('Untrustworthy threw an ExceptionWithMessage(\'Hey!\'), but a \n different message was logged: \'${logger.lastMessage}\'.');
    }

    if (!logger.done) {
      errs.add('Untrustworthy threw an ExceptionWithMessage(\'Hey!\'), \n and doneLogging() wasn\'t called afterward.');
    }
  } catch (e) {
    print('Untrustworthy threw an ExceptionWithMessage(\'Hey!\'), \n and an exception of type ${e.runtimeType} was unhandled by tryFunction.');
  }

  logger = MyLogger();
  bool caughtStringException = false;

  try {
    tryFunction(() => throw 'A String', logger);
  } on String {
    caughtStringException = true;
  }

  if (!caughtStringException) {
    errs.add('Untrustworthy threw a string, and it was incorrectly handled inside tryFunction().');
  }

  logger = MyLogger();

  try {
    tryFunction(() {}, logger);

    if (logger.lastType != null) {
      errs.add('Untrustworthy didn\'t throw an Exception, \n but one was logged anyway: ${logger.lastType}.');
    }

    if (logger.lastMessage != '') {
      errs.add('Untrustworthy didn\'t throw an Exception with no message, \n but a message was logged anyway: \'${logger.lastMessage}\'.');
    }

    if (!logger.done) {
      errs.add('Untrustworthy didn\'t throw an Exception, \n but doneLogging() wasn\'t called afterward.');
    }
  } catch (e) {
    print('Untrustworthy didn\'t throw an exception, \n but an exception of type ${e.runtimeType} was unhandled by tryFunction anyway.');
  }

  if (errs.isEmpty) {
    print('Success!');
  } else {
    errs.forEach(print);
  }
}
```

<details>
  <summary>Solução para exemplo de exceções</summary>

  Este exercício parece complicado, mas é realmente uma grande instrução `try`.
  Chame `untrustworthy` dentro do `try`, e
  então use `on`, `catch` e `finally` para capturar exceções e
  chamar métodos no logger.

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


## Usando `this` em um construtor

Dart fornece um atalho conveniente para atribuir
valores a propriedades em um construtor:
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

Esta técnica funciona para parâmetros nomeados também.
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
porque esses valores `int` não podem ser null.
Se você adicionar valores padrão, pode omitir `required`:

<?code-excerpt "misc/lib/cheatsheet/this_constructor.dart (defaulted)" replace="/olorO/olor/g; /.positional//g; /.named//g;"?>
```dart
MyColor([this.red = 0, this.green = 0, this.blue = 0]);
// ou
MyColor({this.red = 0, this.green = 0, this.blue = 0});
```

### Exercício

Adicione um construtor de uma linha a `MyClass` que usa
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


// Tests your solution (Don't edit!):
void main() {
  final errs = <String>[];

  try {
    final obj = MyClass(1, 'two', 3);

    if (obj.anInt != 1) {
      errs.add('Called MyClass(1, \'two\', 3) and got an object with anInt of ${obj.anInt} \n instead of the expected value (1).');
    }

    if (obj.anInt != 1) {
      errs.add('Called MyClass(1, \'two\', 3) and got an object with aString of \'${obj.aString}\' \n instead of the expected value (\'two\').');
    }

    if (obj.anInt != 1) {
      errs.add('Called MyClass(1, \'two\', 3) and got an object with aDouble of ${obj.aDouble} \n instead of the expected value (3).');
    }
  } catch (e) {
    print('Called MyClass(1, \'two\', 3) and got an exception \n of type ${e.runtimeType}.');
  }

  if (errs.isEmpty) {
    print('Success!');
  } else {
    errs.forEach(print);
  }
}
```

<details>
  <summary>Solução para exemplo de `this`</summary>

  Este exercício tem uma solução de uma linha.
  Declare o construtor com
  `this.anInt`, `this.aString` e `this.aDouble`
  como seus parâmetros nessa ordem.

  ```dart
  MyClass(this.anInt, this.aString, this.aDouble);
  ```

</details>

## Listas de inicialização

Às vezes, ao implementar um construtor,
você precisa fazer alguma configuração antes que o corpo do construtor seja executado.
Por exemplo, campos finais devem ter valores
antes que o corpo do construtor seja executado.
Faça este trabalho em uma lista de inicialização,
que fica entre a assinatura do construtor e seu corpo:

<?code-excerpt "misc/lib/language_tour/classes/point_alt.dart (initializer-list-no-comment)"?>
```dart
Point.fromJson(Map<String, double> json) : x = json['x']!, y = json['y']! {
  print('In Point.fromJson(): ($x, $y)');
}
```

A lista de inicialização também é um lugar conveniente para colocar asserts,
que são executados apenas durante o desenvolvimento:

<?code-excerpt "misc/lib/cheatsheet/initializer_lists.dart (assert)"?>
```dart
NonNegativePoint(this.x, this.y) : assert(x >= 0), assert(y >= 0) {
  print('I just made a NonNegativePoint: ($x, $y)');
}
```

### Exercício

Complete o construtor `FirstTwoLetters` abaixo.
Use uma lista de inicialização para atribuir os dois primeiros caracteres em `word` às
propriedades `letterOne` e `LetterTwo`.
Para crédito extra, adicione um `assert` para capturar palavras com menos de dois caracteres.

Ignore todos os erros iniciais no DartPad.

```dartpad theme="dark"
class FirstTwoLetters {
  final String letterOne;
  final String letterTwo;

  // TODO: Create a constructor with an initializer list here:
  FirstTwoLetters(String word)

}


// Tests your solution (Don't edit!):
void main() {
  final errs = <String>[];

  try {
    final result = FirstTwoLetters('My String');

    if (result.letterOne != 'M') {
      errs.add('Called FirstTwoLetters(\'My String\') and got an object with \n letterOne equal to \'${result.letterOne}\' instead of the expected value (\'M\').');
    }

    if (result.letterTwo != 'y') {
      errs.add('Called FirstTwoLetters(\'My String\') and got an object with \n letterTwo equal to \'${result.letterTwo}\' instead of the expected value (\'y\').');
    }
  } catch (e) {
    errs.add('Called FirstTwoLetters(\'My String\') and got an exception \n of type ${e.runtimeType}.');
  }

  bool caughtException = false;

  try {
    FirstTwoLetters('');
  } catch (e) {
    caughtException = true;
  }

  if (!caughtException) {
    errs.add('Called FirstTwoLetters(\'\') and didn\'t get an exception \n from the failed assertion.');
  }

  if (errs.isEmpty) {
    print('Success!');
  } else {
    errs.forEach(print);
  }
}
```

<details>
  <summary>Solução para exemplo de listas de inicialização</summary>

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

## Construtores nomeados

Para permitir que classes tenham múltiplos construtores,
Dart suporta construtores nomeados:

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

### Exercício

Dê à classe `Color` um construtor nomeado `Color.black`
que defina todas as três propriedades como zero.

Ignore todos os erros iniciais no DartPad.

```dartpad theme="dark"
class Color {
  int red;
  int green;
  int blue;

  Color(this.red, this.green, this.blue);

  // TODO: Create a named constructor called "Color.black" here:
}


// Tests your solution (Don't edit!):
void main() {
  final errs = <String>[];

  try {
    final result = Color.black();

    if (result.red != 0) {
      errs.add('Called Color.black() and got a Color with red equal to \n ${result.red} instead of the expected value (0).');
    }

    if (result.green != 0) {
      errs.add('Called Color.black() and got a Color with green equal to \n ${result.green} instead of the expected value (0).');
    }

    if (result.blue != 0) {
  errs.add('Called Color.black() and got a Color with blue equal to \n ${result.blue} instead of the expected value (0).');
    }
  } catch (e) {
    print('Called Color.black() and got an exception of type \n ${e.runtimeType}.');
    return;
  }

  if (errs.isEmpty) {
    print('Success!');
  } else {
    errs.forEach(print);
  }
}
```

<details>
  <summary>Solução para exemplo de construtores nomeados</summary>

  A declaração do seu construtor deve começar com `Color.black():`.
  Na lista de inicialização (após os dois pontos),
  defina `red`, `green` e `blue` como `0`.

  ```dart
  Color.black() : red = 0, green = 0, blue = 0;
  ```

</details>

## Construtores factory

Dart suporta construtores factory,
que podem retornar subtipos ou até null.
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

### Exercício

Substitua a linha `TODO();` no construtor factory
nomeado `IntegerHolder.fromList` para retornar o seguinte:

* Se a lista tiver **um** valor,
  crie uma instância `IntegerSingle` usando esse valor.
* Se a lista tiver **dois** valores,
  crie uma instância `IntegerDouble` usando os valores em ordem.
* Se a lista tiver **três** valores,
  crie uma instância `IntegerTriple` usando os valores em ordem.
* Caso contrário, lance um `Error`.

Se você tiver sucesso, o console deve exibir `Success!`.

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

// Tests your solution (Don't edit from this point to end of file):
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
    print('Success!');
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
    final String vals = count == 1 ? "value" : "values";
    // Uncomment the next line if you want to see the results realtime
    // print("Testing with ${count} ${vals} using ${obj.runtimeType}.");
    testValues(errs, ex, obj, callTxt);
  } on Error {
    _threw = true;
  } catch (e) {
    switch (count) {
      case (< 1 && > 3):
        if (!_threw) {
          errs.add('Called ${callTxt} and it didn\'t throw an Error.');
        }
      default:
        errs.add('Called $callTxt and received an Error.');
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
  <summary>Solução para exemplo de construtores factory</summary>

  Dentro do construtor factory,
  verifique o comprimento da lista, então crie e retorne um
  `IntegerSingle`, `IntegerDouble` ou `IntegerTriple` conforme apropriado.

  Substitua `TODO();` pelo seguinte bloco de código.

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

## Construtores de redirecionamento

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

  // O construtor principal para esta classe.
  Automobile(this.make, this.model, this.mpg);

  // Delega ao construtor principal.
  Automobile.hybrid(String make, String model) : this(make, model, 60);

  // Delega a um construtor nomeado
  Automobile.fancyHybrid() : this.hybrid('Futurecar', 'Mark 2');
}
```

### Exercício

Lembra da classe `Color` acima? Crie um construtor nomeado chamado
`black`, mas em vez de atribuir manualmente as propriedades, redirecione-o para o
construtor padrão com zeros como argumentos.

Ignore todos os erros iniciais no DartPad.

```dartpad theme="dark"
class Color {
  int red;
  int green;
  int blue;

  Color(this.red, this.green, this.blue);

  // TODO: Create a named constructor called "black" here
  // and redirect it to call the existing constructor
}


// Tests your solution (Don't edit!):
void main() {
  final errs = <String>[];

  try {
    final result = Color.black();

    if (result.red != 0) {
      errs.add('Called Color.black() and got a Color with red equal to \n ${result.red} instead of the expected value (0).');
    }

    if (result.green != 0) {
      errs.add('Called Color.black() and got a Color with green equal to \n ${result.green} instead of the expected value (0).');
    }

    if (result.blue != 0) {
  errs.add('Called Color.black() and got a Color with blue equal to \n ${result.blue} instead of the expected value (0).');
    }
  } catch (e) {
    print('Called Color.black() and got an exception of type ${e.runtimeType}.');
    return;
  }

  if (errs.isEmpty) {
    print('Success!');
  } else {
    errs.forEach(print);
  }
}
```

<details>
  <summary>Solução para exemplo de construtores de redirecionamento</summary>

  Seu construtor deve redirecionar para `this(0, 0, 0)`.

  ```dart
  Color.black() : this(0, 0, 0);
  ```

</details>

## Construtores const

Se sua classe produz objetos que nunca mudam,
você pode tornar esses objetos constantes de tempo de compilação.
Para fazer isso, defina um construtor `const` e
certifique-se de que todas as variáveis de instância sejam final.

<?code-excerpt "misc/lib/cheatsheet/redirecting_constructors.dart (const-constructors)"?>
```dart
class ImmutablePoint {
  static const ImmutablePoint origin = ImmutablePoint(0, 0);

  final int x;
  final int y;

  const ImmutablePoint(this.x, this.y);
}
```

### Exercício

Modifique a classe `Recipe` para que suas instâncias possam ser constantes,
e crie um construtor constante que faça o seguinte:

* Tenha três parâmetros: `ingredients`, `calories`,
  e `milligramsOfSodium` (nessa ordem).
* Use a sintaxe `this.` para atribuir automaticamente os valores dos parâmetros às
  propriedades do objeto com o mesmo nome.
* Seja constante, com a palavra-chave `const` logo antes de
  `Recipe` na declaração do construtor.

Ignore todos os erros iniciais no DartPad.

```dartpad theme="dark"
class Recipe {
  List<String> ingredients;
  int calories;
  double milligramsOfSodium;

  // TODO: Create a const constructor here.

}


// Tests your solution (Don't edit!):
void main() {
  final errs = <String>[];

  try {
    const obj = Recipe(['1 egg', 'Pat of butter', 'Pinch salt'], 120, 200);

    if (obj.ingredients.length != 3) {
      errs.add('Called Recipe([\'1 egg\', \'Pat of butter\', \'Pinch salt\'], 120, 200) \n and got an object with ingredient list of length ${obj.ingredients.length} rather than the expected length (3).');
    }

    if (obj.calories != 120) {
      errs.add('Called Recipe([\'1 egg\', \'Pat of butter\', \'Pinch salt\'], 120, 200) \n and got an object with a calorie value of ${obj.calories} rather than the expected value (120).');
    }

    if (obj.milligramsOfSodium != 200) {
      errs.add('Called Recipe([\'1 egg\', \'Pat of butter\', \'Pinch salt\'], 120, 200) \n and got an object with a milligramsOfSodium value of ${obj.milligramsOfSodium} rather than the expected value (200).');
    }

    try {
      obj.ingredients.add('Sugar to taste');
      errs.add('Tried adding an item to the \'ingredients\' list of a const Recipe and didn\'t get an error due to it being unmodifiable.');
    } on UnsupportedError catch (_) {
      // We expect an `UnsupportedError` due to
      // `ingredients` being a const, unmodifiable list.
    }
  } catch (e) {
    print('Tried calling Recipe([\'1 egg\', \'Pat of butter\', \'Pinch salt\'], 120, 200) \n and received a null.');
  }

  if (errs.isEmpty) {
    print('Success!');
  } else {
    errs.forEach(print);
  }
}
```

<details>
  <summary>Solução para exemplo de construtores const</summary>

  Para tornar o construtor const, você precisará tornar todas as propriedades final.

  ```dart
  class Recipe {
    final List<String> ingredients;
    final int calories;
    final double milligramsOfSodium;

    const Recipe(this.ingredients, this.calories, this.milligramsOfSodium);
  }
  ```

</details>

## Qual é o próximo passo?

Esperamos que você tenha gostado de usar este tutorial para aprender ou testar seu conhecimento de
alguns dos recursos mais interessantes da linguagem Dart.

O que você pode tentar a seguir inclui:

* Experimente [outros tutoriais do Dart](/tutorials).
* Leia o [tour da linguagem Dart](/language).
* Brinque com o [DartPad.]({{site.dartpad}})
* [Obtenha o SDK do Dart](/get-dart).
