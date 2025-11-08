---
ia-translate: true
title: Funções
description: Tudo sobre funções em Dart.
prevpage:
  url: /language/error-handling
  title: Error handling
nextpage:
  url: /language/metadata
  title: Metadata
---

Dart é uma linguagem verdadeiramente orientada a objetos, portanto até as funções são objetos
e têm um tipo, [Function.][Function API reference]
Isso significa que funções podem ser atribuídas a variáveis ou passadas como argumentos
para outras funções. Você também pode chamar uma instância de uma classe Dart como se
fosse uma função. Para detalhes, veja [Objetos chamáveis][Callable objects].

Aqui está um exemplo de implementação de uma função:

<?code-excerpt "misc/lib/language_tour/functions.dart (function)"?>
```dart
bool isNoble(int atomicNumber) {
  return _nobleGases[atomicNumber] != null;
}
```

Embora o Effective Dart recomende
[annotations de tipo para APIs públicas][type annotations for public APIs],
a função ainda funciona se você omitir os tipos:

<?code-excerpt "misc/lib/language_tour/functions.dart (function-omitting-types)"?>
```dart
isNoble(atomicNumber) {
  return _nobleGases[atomicNumber] != null;
}
```

Para funções que contêm apenas uma expressão, você pode usar uma sintaxe
abreviada:

<?code-excerpt "misc/lib/language_tour/functions.dart (function-shorthand)"?>
```dart
bool isNoble(int atomicNumber) => _nobleGases[atomicNumber] != null;
```

A sintaxe <code>=> <em>expr</em></code> é uma abreviação para
<code>{ return <em>expr</em>; }</code>. A notação `=>`
às vezes é chamada de sintaxe _arrow_.

:::note
Apenas _expressões_ podem aparecer entre a seta (`=>`) e o ponto e vírgula (`;`).
Expressões avaliam para valores.
Isso significa que você não pode escrever uma instrução onde Dart espera um valor.
Por exemplo,
você pode usar uma [expressão condicional][conditional expression] mas não uma [instrução if][if statement].
No exemplo anterior,
`_nobleGases[atomicNumber] != null;` retorna um valor booleano.
A função então retorna um valor booleano
que indica se o `atomicNumber` está na faixa de gases nobres.
:::

## Parâmetros

Uma função pode ter qualquer número de parâmetros _posicionais obrigatórios_. Estes podem ser
seguidos por parâmetros _nomeados_ ou por parâmetros _posicionais opcionais_
(mas não ambos).

:::note
Algumas APIs—notavelmente construtores de widget [Flutter][]—usam apenas parâmetros
nomeados, mesmo para parâmetros que são obrigatórios. Veja a próxima seção para
detalhes.
:::

Você pode usar [vírgulas finais][trailing commas] quando passar argumentos para uma função
ou quando definir parâmetros de função.

### Parâmetros nomeados

Parâmetros nomeados são opcionais
a menos que estejam explicitamente marcados como `required`.

Ao definir uma função, use
<code>{<em>param1</em>, <em>param2</em>, …}</code>
para especificar parâmetros nomeados.
Se você não fornecer um valor padrão
ou marcar um parâmetro nomeado como `required`,
seus tipos devem ser nullable
pois seu valor padrão será `null`:

<?code-excerpt "misc/lib/language_tour/functions.dart (specify-named-parameters)"?>
```dart
/// Sets the [bold] and [hidden] flags ...
void enableFlags({bool? bold, bool? hidden}) {
  ...
}
```

Ao chamar uma função,
você pode especificar argumentos nomeados usando
<code><em>paramName</em>: <em>value</em></code>.
Por exemplo:

<?code-excerpt "misc/lib/language_tour/functions.dart (use-named-parameters)"?>
```dart
enableFlags(bold: true, hidden: false);
```

<a id="default-parameters"></a>
Para definir um valor padrão para um parâmetro nomeado além de `null`,
use `=` para especificar um valor padrão.
O valor especificado deve ser uma constante em tempo de compilação.
Por exemplo:

<?code-excerpt "misc/lib/language_tour/functions.dart (named-parameter-default-values)"?>
```dart
/// Sets the [bold] and [hidden] flags ...
void enableFlags({bool bold = false, bool hidden = false}) {
  ...
}

// bold will be true; hidden will be false.
enableFlags(bold: true);
```

Se você preferir que um parâmetro nomeado seja obrigatório,
exigindo que os chamadores forneçam um valor para o parâmetro,
anote-os com `required`:

<?code-excerpt "misc/lib/language_tour/functions.dart (required-named-parameters)" replace="/required/[!$&!]/g"?>
```dart
const Scrollbar({super.key, [!required!] Widget child});
```

Se alguém tentar criar um `Scrollbar`
sem especificar o argumento `child`,
então o analisador reporta um problema.

:::note
Um parâmetro marcado como `required` ainda pode ser nullable:

<?code-excerpt "misc/lib/language_tour/functions.dart (required-named-parameters-nullable)" replace="/Widget\?/[!$&!]/g; /ScrollbarTwo/Scrollbar/g;"?>
```dart
const Scrollbar({super.key, required [!Widget?!] child});
```

:::

Você pode querer colocar argumentos posicionais primeiro,
mas Dart não exige isso.
Dart permite que argumentos nomeados sejam colocados em qualquer lugar na
lista de argumentos quando isso se adequa à sua API:

<?code-excerpt "misc/lib/language_tour/functions.dart (named-arguments-anywhere)"?>
```dart
repeat(times: 2, () {
  ...
});
```

### Parâmetros posicionais opcionais

Envolver um conjunto de parâmetros de função em `[]`
marca-os como parâmetros posicionais opcionais.
Se você não fornecer um valor padrão,
seus tipos devem ser nullable
pois seu valor padrão será `null`:

<?code-excerpt "misc/test/language_tour/functions_test.dart (optional-positional-parameters)"?>
```dart
String say(String from, String msg, [String? device]) {
  var result = '$from says $msg';
  if (device != null) {
    result = '$result with a $device';
  }
  return result;
}
```

Aqui está um exemplo de chamar esta função
sem o parâmetro opcional:

<?code-excerpt "misc/test/language_tour/functions_test.dart (call-without-optional-param)"?>
```dart
assert(say('Bob', 'Howdy') == 'Bob says Howdy');
```

E aqui está um exemplo de chamar esta função com o terceiro parâmetro:

<?code-excerpt "misc/test/language_tour/functions_test.dart (call-with-optional-param)"?>
```dart
assert(
  say('Bob', 'Howdy', 'smoke signal') ==
      'Bob says Howdy with a smoke signal',
);
```

Para definir um valor padrão para um parâmetro posicional opcional além de `null`,
use `=` para especificar um valor padrão.
O valor especificado deve ser uma constante em tempo de compilação.
Por exemplo:

<?code-excerpt "misc/test/language_tour/functions_test.dart (optional-positional-param-default)"?>
```dart
String say(String from, String msg, [String device = 'carrier pigeon']) {
  var result = '$from says $msg with a $device';
  return result;
}

assert(say('Bob', 'Howdy') == 'Bob says Howdy with a carrier pigeon');
```

<a id="the-main-function" aria-hidden="true"></a>

## A função main() {:#main}

Toda aplicação deve ter uma função `main()` de nível superior, que serve como o
ponto de entrada para a aplicação. A função `main()` retorna `void` e tem um
parâmetro opcional `List<String>` para argumentos.

Aqui está uma função `main()` simples:

<?code-excerpt "misc/test/samples_test.dart (hello-world)"?>
```dart
void main() {
  print('Hello, World!');
}
```

Aqui está um exemplo da função `main()` para uma aplicação de linha de comando que
recebe argumentos:

<?code-excerpt "misc/test/language_tour/functions_test.dart (main-args)"?>
```dart title="args.dart"
// Run the app like this: dart run args.dart 1 test
void main(List<String> arguments) {
  print(arguments);

  assert(arguments.length == 2);
  assert(int.parse(arguments[0]) == 1);
  assert(arguments[1] == 'test');
}
```

Você pode usar a [biblioteca args]({{site.pub-pkg}}/args) para
definir e analisar argumentos de linha de comando.

## Funções como objetos de primeira classe

Você pode passar uma função como parâmetro para outra função. Por exemplo:

<?code-excerpt "misc/lib/language_tour/functions.dart (function-as-param)"?>
```dart
void printElement(int element) {
  print(element);
}

var list = [1, 2, 3];

// Pass printElement as a parameter.
list.forEach(printElement);
```

Você também pode atribuir uma função a uma variável, como:

<?code-excerpt "misc/test/language_tour/functions_test.dart (function-as-var)"?>
```dart
var loudify = (msg) => '!!! ${msg.toUpperCase()} !!!';
assert(loudify('hello') == '!!! HELLO !!!');
```

Este exemplo usa uma função anônima.
Mais sobre isso na próxima seção.

## Tipos de função

Você pode especificar o tipo de uma função, que é conhecido como _tipo de função_.
Um tipo de função é obtido de um cabeçalho de declaração de função
substituindo o nome da função pela keyword `Function`.
Além disso, você pode omitir os nomes dos parâmetros posicionais, mas
os nomes dos parâmetros nomeados não podem ser omitidos. Por exemplo:

<?code-excerpt "misc/lib/language_tour/functions.dart (function-type)"?>
```dart
void greet(String name, {String greeting = 'Hello'}) =>
    print('$greeting $name!');

// Store `greet` in a variable and call it.
void Function(String, {String greeting}) g = greet;
g('Dash', greeting: 'Howdy');
```

:::note
Em Dart, funções são objetos de primeira classe,
o que significa que podem ser atribuídas a variáveis,
passadas como argumentos e retornadas de outras funções.

Você pode usar uma declaração [`typedef`][] para nomear explicitamente tipos de função,
o que pode ser útil para clareza e reutilização.
:::

[`typedef`]: /language/typedefs

## Funções anônimas

Embora você nomeie a maioria das funções, como `main()` ou `printElement()`,
você também pode criar funções sem nomes.
Essas funções são chamadas de _funções anônimas_, _lambdas_ ou _closures_.

Uma função anônima se assemelha a uma função nomeada pois tem:

- Zero ou mais parâmetros, separados por vírgula
- Annotations de tipo opcionais entre parênteses.

O seguinte bloco de código contém o corpo da função:

```dart
([[Type] param1[, ...]]) {
  codeBlock;
}
```

O exemplo a seguir define uma função anônima
com um parâmetro sem tipo, `item`.
A função anônima a passa para a função `map`.
A função `map`, invocada para cada item na lista,
converte cada string para maiúsculas.
Então, a função anônima passada para `forEach`,
imprime cada string convertida com seu comprimento.

<?code-excerpt "misc/test/language_tour/functions_test.dart (anonymous-function)"?>
```dart
const list = ['apples', 'bananas', 'oranges'];

var uppercaseList = list.map((item) {
  return item.toUpperCase();
}).toList();
// Convert to list after mapping

for (var item in uppercaseList) {
  print('$item: ${item.length}');
}
```

Clique em **Run** para executar o código.

<?code-excerpt "misc/test/language_tour/functions_test.dart (anonymous-function-main)"?>
```dartpad
void main() {
  const list = ['apples', 'bananas', 'oranges'];

  var uppercaseList = list.map((item) {
    return item.toUpperCase();
  }).toList();
  // Convert to list after mapping

  for (var item in uppercaseList) {
    print('$item: ${item.length}');
  }
}
```

Se a função contém apenas uma única expressão ou instrução return,
você pode encurtá-la usando notação arrow.
Cole a seguinte linha no DartPad e clique em **Run**
para verificar que é funcionalmente equivalente.

<?code-excerpt "misc/test/language_tour/functions_test.dart (anon-func)"?>
```dart
var uppercaseList = list.map((item) => item.toUpperCase()).toList();
uppercaseList.forEach((item) => print('$item: ${item.length}'));
```

## Escopo léxico

Dart determina o escopo das variáveis com base no layout de seu código.
Uma linguagem de programação com esse recurso é chamada de linguagem com escopo léxico.
Você pode "seguir as chaves para fora" para ver se uma variável está no escopo.

**Exemplo:** Uma série de funções aninhadas com variáveis em cada nível de escopo:

<?code-excerpt "misc/test/language_tour/functions_test.dart (nested-functions)"?>
```dart
bool topLevel = true;

void main() {
  var insideMain = true;

  void myFunction() {
    var insideFunction = true;

    void nestedFunction() {
      var insideNestedFunction = true;

      assert(topLevel);
      assert(insideMain);
      assert(insideFunction);
      assert(insideNestedFunction);
    }
  }
}
```

O método `nestedFunction()` pode usar variáveis de todos os níveis,
até o nível superior.

## Closures léxicos

Um objeto de função que pode acessar variáveis em seu escopo léxico
quando a função está fora desse escopo é chamado de _closure_.

Funções podem fechar sobre variáveis definidas em escopos circundantes. No
seguinte exemplo, `makeAdder()` captura a variável `addBy`. Onde quer que a
função retornada vá, ela se lembra de `addBy`.

<?code-excerpt "misc/test/language_tour/functions_test.dart (function-closure)"?>
```dart
/// Returns a function that adds [addBy] to the
/// function's argument.
Function makeAdder(int addBy) {
  return (int i) => addBy + i;
}

void main() {
  // Create a function that adds 2.
  var add2 = makeAdder(2);

  // Create a function that adds 4.
  var add4 = makeAdder(4);

  assert(add2(3) == 5);
  assert(add4(3) == 7);
}
```

## Tear-offs

Quando você se refere a uma função, método ou construtor nomeado sem parênteses,
Dart cria um _tear-off_. Este é um closure que recebe os mesmos
parâmetros que a função e invoca a função subjacente quando você a chama.
Se seu código precisa de um closure que invoca uma função nomeada com os mesmos
parâmetros que o closure aceita, não envolva a chamada em um lambda.
Use um tear-off.

<?code-excerpt "misc/lib/language_tour/tear_offs.dart (variables)" ?>
```dart
var charCodes = [68, 97, 114, 116];
var buffer = StringBuffer();
```

<?code-excerpt "misc/lib/language_tour/tear_offs.dart (good-example)" ?>
```dart tag=good
// Function tear-off
charCodes.forEach(print);

// Method tear-off
charCodes.forEach(buffer.write);
```

<?code-excerpt "misc/lib/language_tour/tear_offs.dart (bad-example)" ?>
```dart tag=bad
// Function lambda
charCodes.forEach((code) {
  print(code);
});

// Method lambda
charCodes.forEach((code) {
  buffer.write(code);
});
```

## Testando funções para igualdade

Aqui está um exemplo de testar funções de nível superior, métodos estáticos e
métodos de instância para igualdade:

<?code-excerpt "misc/lib/language_tour/function_equality.dart"?>
```dart
void foo() {} // A top-level function

class A {
  static void bar() {} // A static method
  void baz() {} // An instance method
}

void main() {
  Function x;

  // Comparing top-level functions.
  x = foo;
  assert(foo == x);

  // Comparing static methods.
  x = A.bar;
  assert(A.bar == x);

  // Comparing instance methods.
  var v = A(); // Instance #1 of A
  var w = A(); // Instance #2 of A
  var y = w;
  x = w.baz;

  // These closures refer to the same instance (#2),
  // so they're equal.
  assert(y.baz == x);

  // These closures refer to different instances,
  // so they're unequal.
  assert(v.baz != w.baz);
}
```

## Valores de retorno

Todas as funções retornam um valor. Se nenhum valor de retorno for especificado, a
instrução `return null;` é implicitamente anexada ao corpo da função.

<?code-excerpt "misc/test/language_tour/functions_test.dart (implicit-return-null)"?>
```dart
foo() {}

assert(foo() == null);
```

Para retornar múltiplos valores em uma função, agregue os valores em um [record][].

```dart
(String, int) foo() {
  return ('something', 42);
}
```

[record]: /language/records#multiple-returns

## Getters e setters

Todo acesso a propriedade (de nível superior, estático ou de instância) é uma invocação
de um getter ou um setter. Uma variável implicitamente cria um getter
e, se for mutável, um setter. É por isso que quando você acessa uma propriedade,
você está realmente chamando uma pequena função em segundo plano. Ler uma
propriedade chama uma função getter, e escrever uma chama uma função setter,
mesmo em casos onde a propriedade é declarada como variável.

No entanto, você também pode declarar getters e setters explicitamente com
as keywords `get` e `set` respectivamente.
Isso permite que o valor de uma propriedade seja computado quando é lido ou escrito.

O propósito de usar getters e setters é criar uma separação clara
entre o cliente (o código que usa a propriedade) e
o provedor (a classe ou biblioteca que a define). O cliente pede ou
define um valor sem precisar saber se esse valor está armazenado em uma
variável simples ou calculado no momento. Isso dá ao provedor
a liberdade de mudar como a propriedade funciona.

Por exemplo, como o valor da propriedade pode não estar armazenado em lugar algum,
ele poderia ser computado cada vez que o getter é chamado. Outro exemplo
é que quando um valor é armazenado em uma variável privada, e o acesso público
é permitido apenas chamando um getter ou um setter.

O exemplo a seguir demonstra isso,
com o getter e setter `secret` fornecendo
acesso indireto à variável privada `_secret` com
suas próprias manipulações nos valores atribuídos e recuperados.

<?code-excerpt "language/lib/functions/getters_setters.dart"?>
```dart highlightLines=3,7-10,14-20,24,33
// Defines a variable `_secret` that is private to the library since
// its identifier starts with an underscore (`_`).
String _secret = 'Hello';

// A public top-level getter that
// provides read access to [_secret].
String get secret {
  print('Getter was used!');
  return _secret.toUpperCase();
}

// A public top-level setter that
// provides write access to [_secret].
set secret(String newMessage) {
  print('Setter was used!');
  if (newMessage.isNotEmpty) {
    _secret = newMessage;
    print('New secret: "$newMessage"');
  }
}

void main() {
  // Reading the value calls the getter.
  print('Current message: $secret');

  /*
  Output:
  Getter was used!
  Current message: HELLO
  */

  // Assigning a value calls the setter.
  secret = 'Dart is fun';

  // Reading it again calls the getter to show the new computed value
  print('New message: $secret');

  /*
  Output:
  Setter was used! New secret: "Dart is fun"
  Getter was used!
  New message: DART IS FUN
  */
}
```

## Geradores

Quando você precisa produzir preguiçosamente uma sequência de valores,
considere usar uma _função geradora_.
Dart tem suporte embutido para dois tipos de funções geradoras:

- Gerador **Síncrono**: Retorna um objeto [`Iterable`].
- Gerador **Assíncrono**: Retorna um objeto [`Stream`].

Para implementar uma função geradora **síncrona**,
marque o corpo da função como `sync*`,
e use instruções `yield` para entregar valores:

<?code-excerpt "misc/test/language_tour/async_test.dart (sync-generator)"?>
```dart
Iterable<int> naturalsTo(int n) sync* {
  int k = 0;
  while (k < n) yield k++;
}
```

Para implementar uma função geradora **assíncrona**,
marque o corpo da função como `async*`,
e use instruções `yield` para entregar valores:

<?code-excerpt "misc/test/language_tour/async_test.dart (async-generator)"?>
```dart
Stream<int> asynchronousNaturalsTo(int n) async* {
  int k = 0;
  while (k < n) yield k++;
}
```

Se seu gerador é recursivo,
você pode melhorar seu desempenho usando `yield*`:

<?code-excerpt "misc/test/language_tour/async_test.dart (recursive-generator)"?>
```dart
Iterable<int> naturalsDownFrom(int n) sync* {
  if (n > 0) {
    yield n;
    yield* naturalsDownFrom(n - 1);
  }
}
```

[`Iterable`]: {{site.dart-api}}/dart-core/Iterable-class.html
[`Stream`]: {{site.dart-api}}/dart-async/Stream-class.html

## Funções externas {:#external}

Uma função externa é uma função cujo corpo é implementado separadamente de sua
declaração. Inclua a keyword `external` antes de uma declaração de função, assim:

```dart
external void someFunc(int i);
```

A implementação de uma função externa pode vir de outra biblioteca Dart,
ou, mais comumente, de outra linguagem. Em contextos de interoperabilidade, `external`
introduz informações de tipo para funções ou valores estrangeiros,
tornando-os utilizáveis em Dart. A implementação e uso são
altamente específicos da plataforma, então confira a documentação de interoperabilidade sobre, por exemplo,
[C][] ou [JavaScript][] para saber mais.

Funções externas podem ser funções de nível superior, [métodos de instância][instance methods],
getters ou setters, ou [construtores não-redirecting][non-redirecting constructors].
Uma [variável de instância][instance variable] também pode ser `external`,
o que é equivalente a um getter externo e (se a variável
não for `final`) um setter externo.

[instance methods]: /language/methods#instance-methods
[non-redirecting constructors]: /language/constructors#redirecting-constructors
[instance variable]: /language/classes#instance-variables
[C]: /interop/c-interop
[JavaScript]: /interop/js-interop
[Function API reference]: {{site.dart-api}}/dart-core/Function-class.html
[Callable objects]: /language/callable-objects
[type annotations for public APIs]: /effective-dart/design#do-type-annotate-fields-and-top-level-variables-if-the-type-isnt-obvious
[if statement]: /language/branches#if
[conditional expression]: /language/operators#conditional-expressions
[Flutter]: {{site.flutter}}
[trailing commas]: /language/collections#lists
