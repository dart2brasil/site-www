---
ia-translate: true
title: "Funções"
description: "Tudo sobre funções em Dart."
prevpage:
  url: /language/error-handling
  title: Error handling
nextpage:
  url: /language/metadata
  title: Metadata
---

Dart é uma linguagem orientada a objetos de verdade, então até mesmo funções são objetos
e têm um tipo, [Function.][Function API reference]
Isso significa que funções podem ser atribuídas a variáveis ou passadas como argumentos
para outras funções. Você também pode chamar uma instância de uma classe Dart como se
fosse uma função. Para detalhes, veja [Objetos Chamáveis][Objetos Chamáveis].

Aqui está um exemplo de implementação de uma função:

<?code-excerpt "misc/lib/language_tour/functions.dart (function)"?>
```dart
bool isNoble(int atomicNumber) {
  return _nobleGases[atomicNumber] != null;
}
```

Embora o Effective Dart recomende
[anotações de tipo para APIs públicas][anotações de tipo para APIs públicas],
a função ainda funciona se você omitir os tipos:

<?code-excerpt "misc/lib/language_tour/functions.dart (function-omitting-types)"?>
```dart
isNoble(atomicNumber) {
  return _nobleGases[atomicNumber] != null;
}
```

Para funções que contêm apenas uma expressão, você pode usar uma
sintaxe abreviada:

<?code-excerpt "misc/lib/language_tour/functions.dart (function-shorthand)"?>
```dart
bool isNoble(int atomicNumber) => _nobleGases[atomicNumber] != null;
```

A sintaxe <code>=> <em>expr</em></code> é um atalho para
<code>{ return <em>expr</em>; }</code>. A notação `=>`
às vezes é referida como sintaxe _arrow_ (seta).

:::note
Apenas _expressões_ podem aparecer entre a seta (`=>`) e o ponto e vírgula (`;`).
Expressões avaliam para valores.
Isso significa que você não pode escrever uma declaração onde Dart espera um valor.
Por exemplo,
você pode usar uma [expressão condicional][expressão condicional] mas não um [comando if][comando if].
No exemplo anterior,
`_nobleGases[atomicNumber] != null;` retorna um valor booleano.
A função então retorna um valor booleano
que indica se o `atomicNumber` se enquadra na faixa de gases nobres.
:::

## Parâmetros {:#parameters}

A function can have any number of _required positional_ parameters. These can be
followed either by _named_ parameters or by _optional positional_ parameters
(but not both).

:::note
Algumas APIs—notavelmente os construtores de *widgets* do [Flutter][Flutter]—usam
apenas parâmetros nomeados, mesmo para parâmetros que são obrigatórios.
Consulte a próxima seção para obter detalhes.
:::

Você pode usar [vírgulas à direita][vírgulas à direita] quando você passa argumentos para uma função
ou quando você define parâmetros de função.

### Named parameters

Parâmetros nomeados são opcionais
a menos que sejam explicitamente marcados como `required` (obrigatório).

Ao definir uma função, use
<code>{<em>param1</em>, <em>param2</em>, …}</code>
para especificar parâmetros nomeados.
Se você não fornecer um valor padrão
ou marcar um parâmetro nomeado como `required`,
seus tipos devem ser anuláveis
já que seu valor padrão será `null`:

<?code-excerpt "misc/lib/language_tour/functions.dart (specify-named-parameters)"?>
```dart
/// Sets the [bold] and [hidden] flags ...
void enableFlags({bool? bold, bool? hidden}) {
  ...
}
```

When calling a function,
you can specify named arguments using
<code><em>paramName</em>: <em>value</em></code>.
For example:

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

Se você, em vez disso, quiser que um parâmetro nomeado seja obrigatório,
exigindo que os chamadores forneçam um valor para o parâmetro,
anote-os com `required`:

<?code-excerpt "misc/lib/language_tour/functions.dart (required-named-parameters)" replace="/required/[!$&!]/g"?>
```dart
const Scrollbar({super.key, [!required!] Widget child});
```

Se alguém tentar criar um `Scrollbar`
sem especificar o argumento `child`,
então o analisador relata um problema.

:::note
Um parâmetro marcado como `required` ainda pode ser anulável:

<?code-excerpt "misc/lib/language_tour/functions.dart (required-named-parameters-nullable)" replace="/Widget\?/[!$&!]/g; /ScrollbarTwo/Scrollbar/g;"?>
```dart
const Scrollbar({super.key, required [!Widget?!] child});
```

:::

Você pode querer colocar os argumentos posicionais primeiro,
mas Dart não exige isso.
Dart permite que argumentos nomeados sejam colocados em qualquer lugar na
lista de argumentos quando isso for adequado para sua API:

<?code-excerpt "misc/lib/language_tour/functions.dart (named-arguments-anywhere)"?>
```dart
repeat(times: 2, () {
  ...
});
```

### Parâmetros posicionais opcionais {:#optional-positional-parameters}

Envolver um conjunto de parâmetros de função em `[]`
os marca como parâmetros posicionais opcionais.
Se você não fornecer um valor padrão,
seus tipos devem ser anuláveis
já que seu valor padrão será `null`:

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

Aqui está um exemplo de chamada dessa função
sem o parâmetro opcional:

<?code-excerpt "misc/test/language_tour/functions_test.dart (call-without-optional-param)"?>
```dart
assert(say('Bob', 'Howdy') == 'Bob says Howdy');
```

E aqui está um exemplo de chamada dessa função com o terceiro parâmetro:

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

Todo aplicativo deve ter uma função `main()` de nível superior, que serve como ponto de
entrada para o aplicativo. A função `main()` retorna `void` e possui um
parâmetro `List<String>` opcional para argumentos.

Aqui está uma função `main()` simples:

<?code-excerpt "misc/test/samples_test.dart (hello-world)"?>
```dart
void main() {
  print('Hello, World!');
}
```

Aqui está um exemplo da função `main()` para um aplicativo de linha de comando que
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

## Funções como objetos de primeira classe {:#functions-as-first-class-objects}

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

## Tipos de função {:#function-types}

You can specify the type of a function, which is known as a _function type_.
A function type is obtained from a function declaration header by
replacing the function name by the keyword `Function`.
Moreover, you are allowed to omit the names of positional parameters, but
the names of named parameters can't be omitted. For example:

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
o que significa que elas podem ser atribuídas a variáveis,
passadas como argumentos e retornadas de outras funções.

Você pode usar uma declaração [`typedef`][`typedef`] para nomear explicitamente os tipos de função,
o que pode ser útil para clareza e reutilização.
:::

[`typedef`]: /language/typedefs

## Funções anônimas {:#anonymous-functions}

Though you name most functions, such as `main()` or `printElement()`,
you can also create functions without names.
These functions are called _anonymous functions_, _lambdas_, or _closures_.

Uma função anônima se assemelha a uma função nomeada, pois ela possui:

- Zero or more parameters, comma-separated
- Optional type annotations between parentheses.

O seguinte bloco de código contém o corpo da função:

```dart
([[Type] param1[, ...]]) {
  codeBlock;
}
```

O seguinte exemplo define uma função anônima
com um parâmetro sem tipo, `item`.
A função anônima a passa para a função `map`.
A função `map`, invocada para cada item da lista,
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

Clique em **Executar** para executar o código.

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

Se a função contém apenas uma única expressão ou instrução de retorno,
você pode encurtá-la usando a notação de seta.
Cole a seguinte linha no DartPad e clique em **Executar**
para verificar se ela é funcionalmente equivalente.

<?code-excerpt "misc/test/language_tour/functions_test.dart (anon-func)"?>
```dart
var uppercaseList = list.map((item) => item.toUpperCase()).toList();
uppercaseList.forEach((item) => print('$item: ${item.length}'));
```

## Escopo léxico {:#lexical-scope}

Dart determina o escopo das variáveis com base no layout do seu código.
Uma linguagem de programação com este recurso é denominada uma linguagem com escopo léxico.
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

## Closures léxicos {:#lexical-closures}

Um objeto de função que pode acessar variáveis em seu escopo léxico
quando a função está fora desse escopo é chamado de _closure_ (fechamento).

Funções podem fechar sobre variáveis definidas em escopos circundantes. No
exemplo seguinte, `makeAdder()` captura a variável `addBy`. Onde quer que a
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

## Tear-offs {:#tear-offs}

Quando você se refere a uma função, método ou construtor nomeado sem parênteses,
Dart cria um _tear-off_. Este é um *closure* que usa os mesmos
parâmetros da função e invoca a função *underlying* quando você a chama.
Se seu código precisar de um *closure* que invoque uma função nomeada com os mesmos
parâmetros que o *closure* aceita, não envolva a chamada em uma *lambda*.
Use um *tear-off*.

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

## Testando funções quanto à igualdade {:#testing-functions-for-equality}

Aqui está um exemplo de teste de funções de nível superior, métodos estáticos e
métodos de instância quanto à igualdade:

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

## Return values

Todas as funções retornam um valor. Se nenhum valor de retorno for especificado, a
instrução `return null;` é implicitamente anexada ao corpo da função.

<?code-excerpt "misc/test/language_tour/functions_test.dart (implicit-return-null)"?>
```dart
foo() {}

assert(foo() == null);
```

Para retornar vários valores em uma função, agregue os valores em um [registro][record].

```dart
(String, int) foo() {
  return ('algo', 42);
}
```

[record]: /language/records#multiple-returns

## Getters and setters

Every property access (top-level, static, or instance) is an invocation
of a getter or a setter. A variable implicitly creates a getter
and, if it's mutable, a setter. This is why when you access a property,
you're actually calling a small function in the background. Reading a
property calls a getter function, and writing one calls a setter function,
even in cases where the property is declared a variable.

However, you can also declare getters and setters explicitly with
the `get` and `set` keywords respectively.
This allows a property's value to be computed when it's read or written.

The purpose of using getters and setters is to create a clear
separation between the client (the code that uses the property) and
the provider (the class or library that defines it). The client asks for or
sets a value without needing to know if that value is stored in a
simple variable or calculated on the spot. This gives the provider
the freedom to change how the property works.

For example, because the value of the property might not be stored anywhere,
it could be computed each time the getter is called. Another example
is that when a value is stored in a private variable, and public access
is only allowed by calling a getter or a setter.

The following example showcases this,
with the `secret` getter and setter providing
indirect access to the private variable `_secret` with
its own manipulations on the assigned and retrieved values.

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

## Generators

Quando você precisa produzir preguiçosamente uma sequência de valores,
considere usar uma _função geradora_.
Dart tem suporte interno para dois tipos de funções geradoras:

- **Synchronous** generator: Returns an [`Iterable`] object.
- **Asynchronous** generator: Returns a [`Stream`] object.

Para implementar uma função geradora **síncrona**,
marque o corpo da função como `sync*`,
e use as instruções `yield` para entregar os valores:

<?code-excerpt "misc/test/language_tour/async_test.dart (sync-generator)"?>
```dart
Iterable<int> naturalsTo(int n) sync* {
  int k = 0;
  while (k < n) yield k++;
}
```

Para implementar uma função geradora **assíncrona**,
marque o corpo da função como `async*`,
e use as instruções `yield` para entregar os valores:

<?code-excerpt "misc/test/language_tour/async_test.dart (async-generator)"?>
```dart
Stream<int> asynchronousNaturalsTo(int n) async* {
  int k = 0;
  while (k < n) yield k++;
}
```

Se seu gerador for recursivo,
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
declaração. Inclua a palavra-chave `external` antes de uma declaração de função, assim:

```dart
external void someFunc(int i);
```

A implementação de uma função externa pode vir de outra biblioteca Dart,
ou, mais comumente, de outra linguagem. Em contextos de *interop*, `external`
introduz informações de tipo para funções ou valores estrangeiros,
tornando-os utilizáveis em Dart. A implementação e o uso são
altamente específicos da plataforma, então consulte os documentos de *interop* em, por exemplo,
[C][C] ou [JavaScript][JavaScript] para saber mais.

External functions can be top-level functions, [instance methods][],
getters or setters, or [non-redirecting constructors][].
An [instance variable][] can be `external` too,
which is equivalent to an external getter and (if the variable
is not `final`) an external setter.

[instance methods]: /language/methods#instance-methods
[non-redirecting constructors]: /language/constructors#redirecting-constructors
[instance variable]: /language/classes#instance-variables
[C]: /interop/c-interop
[JavaScript]: /interop/js-interop
[Function API reference]: {{site.dart-api}}/dart-core/Function-class.html
[Objetos Chamáveis]: /language/callable-objects
[anotações de tipo para APIs públicas]: /effective-dart/design#do-type-annotate-fields-and-top-level-variables-if-the-type-isnt-obvious
[comando if]: /language/branches#if
[expressão condicional]: /language/operators#conditional-expressions
[Flutter]: {{site.flutter}}
[trailing commas]: /language/collections#lists


