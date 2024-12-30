---
ia-translate: true
title: Funções
description: Tudo sobre funções em Dart.
js: [{url: '/assets/js/inject_dartpad.js', defer: true}]
prevpage:
  url: /language/pattern-types
  title: Tipos de padrão
nextpage:
  url: /language/loops
  title: Loops
---

Dart é uma linguagem verdadeiramente orientada a objetos, então até mesmo funções são objetos
e possuem um tipo, [Function.][Function API reference]
Isso significa que funções podem ser atribuídas a variáveis ou passadas como argumentos
para outras funções. Você também pode chamar uma instância de uma classe Dart como se
fosse uma função. Para detalhes, veja [Objetos invocáveis][Callable objects].

Aqui está um exemplo de implementação de uma função:

<?code-excerpt "misc/lib/language_tour/functions.dart (function)"?>
```dart
bool isNoble(int atomicNumber) {
  return _nobleGases[atomicNumber] != null;
}
```

Embora o Effective Dart recomende
[anotações de tipo para APIs públicas][type annotations for public APIs],
a função ainda funciona se você omitir os tipos:

<?code-excerpt "misc/lib/language_tour/functions.dart (function-omitting-types)"?>
```dart
isNoble(atomicNumber) {
  return _nobleGases[atomicNumber] != null;
}
```

Para funções que contêm apenas uma expressão, você pode usar uma sintaxe abreviada:

<?code-excerpt "misc/lib/language_tour/functions.dart (function-shorthand)"?>
```dart
bool isNoble(int atomicNumber) => _nobleGases[atomicNumber] != null;
```

A sintaxe <code>=> <em>expr</em></code> é um atalho para
<code>{ return <em>expr</em>; }</code>. A notação `=>`
é às vezes referida como sintaxe _arrow_.

:::note
Apenas _expressões_ podem aparecer entre a seta (`=>`) e o ponto e vírgula (`;`).
Expressões avaliam para valores.
Isso significa que você não pode escrever uma declaração onde Dart espera um valor.
Por exemplo, você pode usar uma [expressão condicional][conditional expression], mas não uma [declaração if][if statement].
No exemplo anterior,
`_nobleGases[atomicNumber] != null;` retorna um valor booleano.
A função então retorna um valor booleano que
indica se o `atomicNumber` está dentro do intervalo dos gases nobres.
:::

## Parâmetros

Uma função pode ter qualquer número de parâmetros *posicionais obrigatórios*. Estes podem ser
seguidos por parâmetros *nomeados* ou por parâmetros *posicionais opcionais*
(mas não ambos).

:::note
Algumas APIs—notavelmente construtores de widgets [Flutter][Flutter]—usam apenas parâmetros nomeados,
mesmo para parâmetros que são obrigatórios. Veja a próxima seção para
detalhes.
:::

Você pode usar [vírgulas à direita][trailing commas] quando passa argumentos para uma função
ou quando define parâmetros de função.

### Parâmetros nomeados

Parâmetros nomeados são opcionais
a menos que eles sejam explicitamente marcados como `required`.

Ao definir uma função, use
<code>{<em>param1</em>, <em>param2</em>, …}</code>
para especificar parâmetros nomeados.
Se você não fornecer um valor padrão
ou marcar um parâmetro nomeado como `required`,
seus tipos devem ser anuláveis
já que o valor padrão será `null`:

<?code-excerpt "misc/lib/language_tour/functions.dart (specify-named-parameters)"?>
```dart
/// Define os flags [bold] e [hidden] ...
void enableFlags({bool? bold, bool? hidden}) {...}
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
O valor especificado deve ser uma constante de tempo de compilação.
Por exemplo:

<?code-excerpt "misc/lib/language_tour/functions.dart (named-parameter-default-values)"?>
```dart
/// Define os flags [bold] e [hidden] ...
void enableFlags({bool bold = false, bool hidden = false}) {...}

// bold será true; hidden será false.
enableFlags(bold: true);
```

Se, em vez disso, você quiser que um parâmetro nomeado seja obrigatório,
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
Um parâmetro marcado como `required` ainda pode ser anulável:

<?code-excerpt "misc/lib/language_tour/functions.dart (required-named-parameters-nullable)" replace="/Widget\?/[!$&!]/g; /ScrollbarTwo/Scrollbar/g;"?>
```dart
const Scrollbar({super.key, required [!Widget?!] child});
```
:::

Você pode querer colocar os argumentos posicionais primeiro,
mas Dart não exige isso.
Dart permite que argumentos nomeados sejam colocados em qualquer lugar da
lista de argumentos quando for adequado para sua API:

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
seus tipos devem ser anuláveis
já que o valor padrão será `null`:

<?code-excerpt "misc/test/language_tour/functions_test.dart (optional-positional-parameters)"?>
```dart
String say(String from, String msg, [String? device]) {
  var result = '$from diz $msg';
  if (device != null) {
    result = '$result com um $device';
  }
  return result;
}
```

Aqui está um exemplo de chamada desta função
sem o parâmetro opcional:

<?code-excerpt "misc/test/language_tour/functions_test.dart (call-without-optional-param)"?>
```dart
assert(say('Bob', 'Olá') == 'Bob diz Olá');
```

E aqui está um exemplo de chamada desta função com o terceiro parâmetro:

<?code-excerpt "misc/test/language_tour/functions_test.dart (call-with-optional-param)"?>
```dart
assert(say('Bob', 'Olá', 'sinal de fumaça') ==
    'Bob diz Olá com um sinal de fumaça');
```

Para definir um valor padrão para um parâmetro posicional opcional além de `null`,
use `=` para especificar um valor padrão.
O valor especificado deve ser uma constante de tempo de compilação.
Por exemplo:

<?code-excerpt "misc/test/language_tour/functions_test.dart (optional-positional-param-default)"?>
```dart
String say(String from, String msg, [String device = 'pombo-correio']) {
  var result = '$from diz $msg com um $device';
  return result;
}

assert(say('Bob', 'Olá') == 'Bob diz Olá com um pombo-correio');
```

<a id="the-main-function" aria-hidden="true"></a>

## A função main() {:#main}

Todo aplicativo deve ter uma função `main()` de nível superior, que serve como
ponto de entrada para o aplicativo. A função `main()` retorna `void` e possui um
parâmetro `List<String>` opcional para argumentos.

Aqui está uma função `main()` simples:

<?code-excerpt "misc/test/samples_test.dart (hello-world)"?>
```dart
void main() {
  print('Olá, Mundo!');
}
```

Aqui está um exemplo da função `main()` para um aplicativo de linha de comando que
recebe argumentos:

<?code-excerpt "misc/test/language_tour/functions_test.dart (main-args)"?>
```dart title="args.dart"
// Execute o aplicativo assim: dart run args.dart 1 test
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

// Passa printElement como um parâmetro.
list.forEach(printElement);
```

Você também pode atribuir uma função a uma variável, como:

<?code-excerpt "misc/test/language_tour/functions_test.dart (function-as-var)"?>
```dart
var loudify = (msg) => '!!! ${msg.toUpperCase()} !!!';
assert(loudify('olá') == '!!! OLÁ !!!');
```

Este exemplo usa uma função anônima.
Mais sobre elas na próxima seção.

## Tipos de função

Você pode especificar o tipo de uma função, que é conhecido como *tipo de função*.
Um tipo de função é obtido a partir de um cabeçalho de declaração de função,
substituindo o nome da função pela palavra-chave `Function`.
Além disso, você pode omitir os nomes dos parâmetros posicionais, mas
os nomes dos parâmetros nomeados não podem ser omitidos. Por exemplo:

<?code-excerpt "misc/lib/language_tour/functions.dart (function-type)"?>
```dart
void greet(String name, {String greeting = 'Olá'}) =>
    print('$greeting $name!');

// Armazena `greet` em uma variável e a chama.
void Function(String, {String greeting}) g = greet;
g('Dash', greeting: 'Como vai você');
```

:::note
Em Dart, funções são objetos de primeira classe,
o que significa que podem ser atribuídas a variáveis,
passadas como argumentos e retornadas de outras funções.

Você pode usar uma declaração [`typedef`][`typedef`] para nomear explicitamente tipos de função,
o que pode ser útil para clareza e reutilização.
:::

[`typedef`]: /language/typedefs

## Funções anônimas

Embora você nomeie a maioria das funções, como `main()` ou `printElement()`,
você também pode criar funções sem nomes.
Essas funções são chamadas de _funções anônimas_, _lambdas_ ou _closures_.

Uma função anônima se assemelha a uma função nomeada, pois tem:

* Zero ou mais parâmetros, separados por vírgulas
* Anotações de tipo opcionais entre parênteses.

O seguinte bloco de código contém o corpo da função:

```dart
([[Type] param1[, ...]]) {
  codeBlock;
}
```

O exemplo a seguir define uma função anônima
com um parâmetro sem tipo, `item`.
A função anônima a passa para a função `map`.
A função `map`, invocada para cada item da lista,
converte cada string em maiúscula.
Então, a função anônima passada para `forEach`,
imprime cada string convertida com seu comprimento.

<?code-excerpt "misc/test/language_tour/functions_test.dart (anonymous-function)"?>
```dart
const list = ['maçãs', 'bananas', 'laranjas'];

var uppercaseList = list.map((item) {
  return item.toUpperCase();
}).toList();
// Converte para lista após o mapeamento

for (var item in uppercaseList) {
  print('$item: ${item.length}');
}
```

Clique em **Executar** para executar o código.

<?code-excerpt "misc/test/language_tour/functions_test.dart (anonymous-function-main)"?>
```dartpad
void main() {
  const list = ['maçãs', 'bananas', 'laranjas'];

  var uppercaseList = list.map((item) {
    return item.toUpperCase();
  }).toList();
  // Converte para lista após o mapeamento

  for (var item in uppercaseList) {
    print('$item: ${item.length}');
  }
}
```

Se a função contém apenas uma única expressão ou declaração de retorno,
você pode encurtá-la usando a notação de seta.
Cole a seguinte linha no DartPad e clique em **Executar**
para verificar se é funcionalmente equivalente.

<?code-excerpt "misc/test/language_tour/functions_test.dart (anon-func)"?>
```dart
var uppercaseList = list.map((item) => item.toUpperCase()).toList();
uppercaseList.forEach((item) => print('$item: ${item.length}'));
```

## Escopo léxico

Dart determina o escopo de variáveis com base no layout de seu código.
Uma linguagem de programação com esse recurso é denominada linguagem com escopo léxico.
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

## Closures léxicas

Um objeto de função que pode acessar variáveis em seu escopo léxico
quando a função está fora desse escopo é chamado de _closure_.

As funções podem fechar sobre variáveis definidas em escopos circundantes. No
exemplo a seguir, `makeAdder()` captura a variável `addBy`. Onde quer que a
função retornada vá, ela se lembra de `addBy`.

<?code-excerpt "misc/test/language_tour/functions_test.dart (function-closure)"?>
```dart
/// Retorna uma função que adiciona [addBy] ao
/// argumento da função.
Function makeAdder(int addBy) {
  return (int i) => addBy + i;
}

void main() {
  // Cria uma função que adiciona 2.
  var add2 = makeAdder(2);

  // Cria uma função que adiciona 4.
  var add4 = makeAdder(4);

  assert(add2(3) == 5);
  assert(add4(3) == 7);
}
```

## Tear-offs

Quando você se refere a uma função, método ou construtor nomeado sem parênteses,
Dart cria um _tear-off_. Este é um closure que recebe os mesmos
parâmetros que a função e invoca a função subjacente quando você a chama.
Se seu código precisa de um closure que invoque uma função nomeada com os mesmos
parâmetros que o closure aceita, não envolva a chamada em uma lambda.
Use um tear-off.

<?code-excerpt "misc/lib/language_tour/tear_offs.dart (variables)" ?>
```dart
var charCodes = [68, 97, 114, 116];
var buffer = StringBuffer();
```

<?code-excerpt "misc/lib/language_tour/tear_offs.dart (good-example)" ?>
```dart tag=good
// Tear-off de função
charCodes.forEach(print);

// Tear-off de método
charCodes.forEach(buffer.write);
```

<?code-excerpt "misc/lib/language_tour/tear_offs.dart (bad-example)" ?>
```dart tag=bad
// Lambda de função
charCodes.forEach((code) {
  print(code);
});

// Lambda de método
charCodes.forEach((code) {
  buffer.write(code);
});
```

## Testando funções para igualdade

Aqui está um exemplo de teste de funções de nível superior, métodos estáticos e
métodos de instância para igualdade:

<?code-excerpt "misc/lib/language_tour/function_equality.dart"?>
```dart
void foo() {} // Uma função de nível superior

class A {
  static void bar() {} // Um método estático
  void baz() {} // Um método de instância
}

void main() {
  Function x;

  // Comparando funções de nível superior.
  x = foo;
  assert(foo == x);

  // Comparando métodos estáticos.
  x = A.bar;
  assert(A.bar == x);

  // Comparando métodos de instância.
  var v = A(); // Instância #1 de A
  var w = A(); // Instância #2 de A
  var y = w;
  x = w.baz;

  // Esses closures se referem à mesma instância (#2),
  // então eles são iguais.
  assert(y.baz == x);

  // Esses closures se referem a instâncias diferentes,
  // então eles são diferentes.
  assert(v.baz != w.baz);
}
```

## Valores de retorno

Todas as funções retornam um valor. Se nenhum valor de retorno for especificado,
a declaração `return null;` é implicitamente anexada ao corpo da função.

<?code-excerpt "misc/test/language_tour/functions_test.dart (implicit-return-null)"?>
```dart
foo() {}

assert(foo() == null);
```

Para retornar múltiplos valores em uma função, agregue os valores em um [registro][record].

```dart
(String, int) foo() {
  return ('algo', 42);
}
```

[record]: /language/records#multiple-returns

## Geradores

Quando você precisa produzir preguiçosamente uma sequência de valores,
considere usar uma _função geradora_.
Dart tem suporte integrado para dois tipos de funções geradoras:

* Gerador **síncrono**: Retorna um objeto [`Iterable`].
* Gerador **assíncrono**: Retorna um objeto [`Stream`].

Para implementar uma função geradora **síncrona**,
marque o corpo da função como `sync*`,
e use declarações `yield` para entregar valores:

<?code-excerpt "misc/test/language_tour/async_test.dart (sync-generator)"?>
```dart
Iterable<int> naturalsTo(int n) sync* {
  int k = 0;
  while (k < n) yield k++;
}
```

Para implementar uma função geradora **assíncrona**,
marque o corpo da função como `async*`,
e use declarações `yield` para entregar valores:

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
ou, mais comumente, de outra linguagem. Em contextos de interop, `external`
introduz informações de tipo para funções ou valores estrangeiros,
tornando-os utilizáveis em Dart. A implementação e o uso são
fortemente específicos da plataforma, então confira os documentos de interop em, por exemplo,
[C][C] ou [JavaScript][JavaScript] para saber mais.

Funções externas podem ser funções de nível superior, [métodos de instância][instance methods],
[getters ou setters][getters or setters], ou [construtores não redirecionadores][non-redirecting constructors].
Uma [variável de instância][instance variable] também pode ser `external`,
o que é equivalente a um getter externo e (se a variável
não é `final`) um setter externo.

[instance methods]: /language/methods#instance-methods
[getters or setters]: /language/methods#getters-and-setters
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
