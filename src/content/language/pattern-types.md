---
ia-translate: true
title: Tipos de pattern
description: Referência de tipos de pattern em Dart.
prevpage:
  url: /language/patterns
  title: Patterns
nextpage:
  url: /language/loops
  title: Loops
---

Esta página é uma referência para os diferentes tipos de patterns.
Para uma visão geral de como patterns funcionam, onde você pode usá-los em Dart e casos de uso comuns, visite a página principal de [Patterns][].

#### Precedência de patterns {:#pattern-precedence}

Similar à [precedência de operadores](/language/operators#operator-precedence-example),
a avaliação de patterns segue regras de precedência.
Você pode usar [patterns entre parênteses](#parenthesized) para
avaliar patterns de menor precedência primeiro.

Este documento lista os tipos de pattern em ordem crescente de precedência:

* Patterns [Logical-or](#logical-or) têm menor precedência que [logical-and](#logical-and),
patterns logical-and têm menor precedência que patterns [relational](#relational),
e assim por diante.

* Patterns unários pós-fixados ([cast](#cast), [null-check](#null-check),
e [null-assert](#null-assert)) compartilham o mesmo nível de precedência.

* Os patterns primários restantes compartilham a maior precedência.
Patterns de tipo coleção ([record](#record), [list](#list) e [map](#map))
e patterns [Object](#object) englobam outros
dados, então são avaliados primeiro como patterns externos.

## Logical-or {:#logical-or}

`subpattern1 || subpattern2`

Um pattern logical-or separa subpatterns por `||` e corresponde se qualquer um dos
ramos corresponder. Os ramos são avaliados da esquerda para a direita. Uma vez que um ramo corresponde, os
demais não são avaliados.

<?code-excerpt "language/lib/patterns/pattern_types.dart (logical-or)"?>
```dart
var isPrimary = switch (color) {
  Color.red || Color.yellow || Color.blue => true,
  _ => false,
};
```

Subpatterns em um pattern logical-or podem vincular variáveis, mas os ramos devem
definir o mesmo conjunto de variáveis, porque apenas um ramo será avaliado quando
o pattern corresponder.

## Logical-and {:#logical-and}

`subpattern1 && subpattern2`

Um par de patterns separados por `&&` corresponde apenas se ambos os subpatterns corresponderem. Se o
ramo esquerdo não corresponder, o ramo direito não é avaliado.

Subpatterns em um pattern logical-and podem vincular variáveis, mas as variáveis em
cada subpattern não devem se sobrepor, porque ambas serão vinculadas se o pattern
corresponder:

<?code-excerpt "language/lib/patterns/pattern_types.dart (logical-and)"?>
```dart
switch ((1, 2)) {
  // Error, both subpatterns attempt to bind 'b'.
  case (var a, var b) && (var b, var c): // ...
}
```

## Relational {:#relational}

`== expression`

`< expression`

Patterns relacionais comparam o valor correspondido com uma constante fornecida usando qualquer um dos
operadores de igualdade ou relacionais: `==`, `!=`, `<`, `>`, `<=` e `>=`.

O pattern corresponde quando chamar o operador apropriado no valor correspondido
com a constante como argumento retorna `true`.

Patterns relacionais são úteis para corresponder em intervalos numéricos, especialmente quando
combinados com o [pattern logical-and](#logical-and):

<?code-excerpt "language/lib/patterns/pattern_types.dart (relational)"?>
```dart
String asciiCharType(int char) {
  const space = 32;
  const zero = 48;
  const nine = 57;

  return switch (char) {
    < space => 'control',
    == space => 'space',
    > space && < zero => 'punctuation',
    >= zero && <= nine => 'digit',
    _ => '',
  };
}
```

## Cast {:#cast}

`foo as String`

Um pattern cast permite inserir um [type cast][] no meio da desestruturação,
antes de passar o valor para outro subpattern:

<?code-excerpt "language/lib/patterns/pattern_types.dart (cast)"?>
```dart
(num, Object) record = (1, 's');
var (i as int, s as String) = record;
```

Patterns cast irão [lançar uma exceção][throw] se o valor não tiver o tipo declarado.
Como o [pattern null-assert](#null-assert), isso permite afirmar forçadamente o
tipo esperado de algum valor desestruturado.

## Null-check {:#null-check}

`subpattern?`

Patterns null-check correspondem primeiro se o valor não for null, e então correspondem ao pattern interno
contra esse mesmo valor. Eles permitem vincular uma variável cujo tipo é o
tipo base não-nulo do valor nulo sendo correspondido.

Para tratar valores `null` como falhas de correspondência
sem lançar exceção, use o pattern null-check.

<?code-excerpt "language/lib/patterns/pattern_types.dart (null-check)"?>
```dart
String? maybeString = 'nullable with base type String';
switch (maybeString) {
  case var s?:
  // 's' has type non-nullable String here.
}
```

Para corresponder quando o valor _é_ null, use o [pattern constant](#constant) `null`.

## Null-assert {:#null-assert}

`subpattern!`

Patterns null-assert correspondem primeiro se o objeto não for null, então no valor.
Eles permitem que valores não-nulos fluam, mas [lançam exceção][throw] se o valor correspondido
for null.

Para garantir que valores `null` não sejam silenciosamente tratados como falhas de correspondência,
use um pattern null-assert ao corresponder:

<?code-excerpt "language/lib/patterns/pattern_types.dart (null-assert-match)"?>
```dart
List<String?> row = ['user', null];
switch (row) {
  case ['user', var name!]: // ...
  // 'name' is a non-nullable string here.
}
```

Para eliminar valores `null` de patterns de declaração de variáveis,
use o pattern null-assert:

<?code-excerpt "language/lib/patterns/pattern_types.dart (null-assert-dec)"?>
```dart
(int?, int?) position = (2, 3);

var (x!, y!) = position;
```

Para corresponder quando o valor _é_ null, use o [pattern constant](#constant) `null`.

## Constant {:#constant}

`123, null, 'string', math.pi, SomeClass.constant, const Thing(1, 2), const (1 + 2)`

Patterns constant correspondem quando o valor é igual à constante:

<?code-excerpt "language/lib/patterns/pattern_types.dart (constant)"?>
```dart
switch (number) {
  // Matches if 1 == number.
  case 1: // ...
}
```

Você pode usar literais simples e referências a constantes nomeadas diretamente como patterns constant:

- Literais numéricos (`123`, `45.56`)
- Literais booleanos (`true`)
- Literais de string (`'string'`)
- Constantes nomeadas (`someConstant`, `math.pi`, `double.infinity`)
- Construtores constant (`const Point(0, 0)`)
- Literais de coleção constant (`const []`, `const {1, 2}`)

Expressões constant mais complexas devem estar entre parênteses e prefixadas com
`const` (`const (1 + 2)`):

<?code-excerpt "language/lib/patterns/pattern_types.dart (complex-constant)"?>
```dart
// List or map pattern:
case [a, b]: // ...

// List or map literal:
case const [a, b]: // ...
```

## Variable {:#variable}

`var bar, String str, final int _`

Patterns variable vinculam novas variáveis a valores que foram correspondidos ou desestruturados.
Eles geralmente ocorrem como parte de um [pattern de desestruturação][destructure] para
capturar um valor desestruturado.

As variáveis estão no escopo em uma região de código que só é alcançável quando o
pattern corresponde.

<?code-excerpt "language/lib/patterns/pattern_types.dart (variable)"?>
```dart
switch ((1, 2)) {
  // 'var a' and 'var b' are variable patterns that bind to 1 and 2, respectively.
  case (var a, var b): // ...
  // 'a' and 'b' are in scope in the case body.
}
```

Um pattern variable _tipado_ só corresponde se o valor correspondido tiver o tipo declarado,
e falha caso contrário:

<?code-excerpt "language/lib/patterns/pattern_types.dart (variable-typed)"?>
```dart
switch ((1, 2)) {
  // Does not match.
  case (int a, String b): // ...
}
```

Você pode usar um [pattern wildcard](#wildcard) como um pattern variable.

## Identifier {:#identifier}

`foo, _`

Patterns identifier podem se comportar como um [pattern constant](#constant) ou como um
[pattern variable](#variable), dependendo do contexto onde aparecem:

- Contexto de [declaração][Declaration]: declara uma nova variável com nome identificador:
  `var (a, b) = (1, 2);`
- Contexto de [atribuição][Assignment]: atribui a uma variável existente com nome identificador:
  `(a, b) = (3, 4);`
- Contexto de [correspondência][Matching]: tratado como um pattern constant nomeado (a menos que seu nome seja `_`):
  <?code-excerpt "language/lib/patterns/pattern_types.dart (match-context)"?>
  ```dart
  const c = 1;
  switch (2) {
    case c:
      print('match $c');
    default:
      print('no match'); // Prints "no match".
  }
  ```
- Identificador [wildcard](#wildcard) em qualquer contexto: corresponde a qualquer valor e o descarta:
  `case [_, var y, _]: print('The middle element is $y');`

## Parenthesized {:#parenthesized}

`(subpattern)`

Como expressões entre parênteses, parênteses em um pattern permitem controlar
a [precedência do pattern](#pattern-precedence) e inserir um pattern de menor precedência
onde um de maior precedência é esperado.

Por exemplo, imagine que as constantes booleanas `x`, `y` e `z`
sejam iguais a `true`, `true` e `false`, respectivamente.
Embora o exemplo a seguir se assemelhe à avaliação de expressões booleanas,
o exemplo corresponde patterns.

<?code-excerpt "language/lib/patterns/pattern_types.dart (parens)"?>
```dart
// ...
x || y => 'matches true',
x || y && z => 'matches true',
x || (y && z) => 'matches true',
// `x || y && z` is the same thing as `x || (y && z)`.
(x || y) && z => 'matches nothing',
// ...
```

Dart começa a corresponder o pattern da esquerda para a direita.

1. O primeiro pattern corresponde a `true` pois `x` corresponde a `true`.
1. O segundo pattern corresponde a `true` pois `x` corresponde a `true`.
1. O terceiro pattern corresponde a `true` pois `x` corresponde a `true`.
1. O quarto pattern `(x || y) && z` não tem correspondência.

   * O `x` corresponde a `true`, então Dart não tenta corresponder `y`.
   * Embora `(x || y)` corresponda a `true`, `z` não corresponde a `true`
   * Portanto, o pattern `(x || y) && z` não corresponde a `true`.
   * O subpattern `(x || y)` não corresponde a `false`,
     então Dart não tenta corresponder `z`.
   * Portanto, o pattern `(x || y) && z` não corresponde a `false`.
   * Como conclusão, `(x || y) && z` não tem correspondência.

## List {:#list}

`[subpattern1, subpattern2]`

Um pattern list corresponde a valores que implementam [`List`][], e então recursivamente
corresponde seus subpatterns aos elementos da lista para desestruturá-los por posição:

<?code-excerpt "language/lib/patterns/switch.dart (list-pattern)"?>
```dart
const a = 'a';
const b = 'b';
switch (obj) {
  // List pattern [a, b] matches obj first if obj is a list with two fields,
  // then if its fields match the constant subpatterns 'a' and 'b'.
  case [a, b]:
    print('$a, $b');
}
```

Patterns list requerem que o número de elementos no pattern corresponda à lista inteira.
Você pode, no entanto, usar um [elemento rest](#rest-element) como um espaço reservado para
contabilizar qualquer número de elementos em uma lista.

### Elemento rest {:#rest-element}

Patterns list podem conter _um_ elemento rest (`...`) que permite corresponder listas
de comprimentos arbitrários.

<?code-excerpt "language/lib/patterns/pattern_types.dart (rest)"?>
```dart
var [a, b, ..., c, d] = [1, 2, 3, 4, 5, 6, 7];
// Prints "1 2 6 7".
print('$a $b $c $d');
```

Um elemento rest também pode ter um subpattern que coleta elementos que não correspondem
aos outros subpatterns na lista, em uma nova lista:

<?code-excerpt "language/lib/patterns/pattern_types.dart (rest-sub)"?>
```dart
var [a, b, ...rest, c, d] = [1, 2, 3, 4, 5, 6, 7];
// Prints "1 2 [3, 4, 5] 6 7".
print('$a $b $rest $c $d');
```

## Map {:#map}

`{"key": subpattern1, someConst: subpattern2}`

Patterns map correspondem a valores que implementam [`Map`][], e então recursivamente
correspondem seus subpatterns às chaves do map para desestruturá-los.

Patterns map não requerem que o pattern corresponda ao map inteiro. Um pattern map
ignora quaisquer chaves que o map contenha que não são correspondidas pelo pattern.
Tentar corresponder uma chave que não existe no map irá
lançar um [`StateError`][]:

<?code-excerpt "language/lib/patterns/pattern_types.dart (map-error)"?>
```dart
final {'foo': int? foo} = {};
```

## Record {:#record}

`(subpattern1, subpattern2)`

`(x: subpattern1, y: subpattern2)`

Patterns record correspondem a um objeto [record][] e desestrutura seus campos.
Se o valor não for um record com a mesma [forma][shape] do pattern, a correspondência
falha. Caso contrário, os subpatterns de campo são correspondidos aos campos
correspondentes no record.

Patterns record requerem que o pattern corresponda ao record inteiro. Para desestruturar
um record com campos _nomeados_ usando um pattern, inclua os nomes dos campos no pattern:

<?code-excerpt "language/lib/patterns/pattern_types.dart (record)"?>
```dart
var (myString: foo, myNumber: bar) = (myString: 'string', myNumber: 1);
```

O nome do getter pode ser omitido e inferido do [pattern variable](#variable)
ou [pattern identifier](#identifier) no subpattern de campo. Esses pares de
patterns são equivalentes:

<?code-excerpt "language/lib/patterns/pattern_types.dart (record-getter)"?>
```dart
// Record pattern with variable subpatterns:
var (untyped: untyped, typed: int typed) = record;
var (:untyped, :int typed) = record;

switch (record) {
  case (untyped: var untyped, typed: int typed): // ...
  case (:var untyped, :int typed): // ...
}

// Record pattern with null-check and null-assert subpatterns:
switch (record) {
  case (checked: var checked?, asserted: var asserted!): // ...
  case (:var checked?, :var asserted!): // ...
}

// Record pattern with cast subpattern:
var (untyped: untyped as int, typed: typed as String) = record;
var (:untyped as int, :typed as String) = record;
```

## Object {:#object}

`SomeClass(x: subpattern1, y: subpattern2)`

Patterns object verificam o valor correspondido contra um tipo nomeado fornecido para desestruturar
dados usando getters nas propriedades do objeto. Eles são [refutados][refuted]
se o valor não tiver o mesmo tipo.

<?code-excerpt "language/lib/patterns/pattern_types.dart (object)"?>
```dart
switch (shape) {
  // Matches if shape is of type Rect, and then against the properties of Rect.
  case Rect(width: var w, height: var h): // ...
}
```

O nome do getter pode ser omitido e inferido do [pattern variable](#variable)
ou [pattern identifier](#identifier) no subpattern de campo:

<?code-excerpt "language/lib/patterns/pattern_types.dart (object-getter)"?>
```dart
// Binds new variables x and y to the values of Point's x and y properties.
var Point(:x, :y) = Point(1, 2);
```

Patterns object não requerem que o pattern corresponda ao objeto inteiro.
Se um objeto tiver campos extras que o pattern não desestrutura, ele ainda pode corresponder.

## Wildcard {:#wildcard}

`_`

Um pattern chamado `_` é um wildcard, seja um [pattern variable](#variable) ou
[pattern identifier](#identifier), que não vincula ou atribui a nenhuma variável.

É útil como um espaço reservado em lugares onde você precisa de um subpattern para
desestruturar valores posicionais posteriores:

<?code-excerpt "language/lib/patterns/pattern_types.dart (wildcard)"?>
```dart
var list = [1, 2, 3];
var [_, two, _] = list;
```

Um nome wildcard com uma anotação de tipo é útil quando você deseja testar o tipo de um
valor mas não vincular o valor a um nome:

<?code-excerpt "language/lib/patterns/pattern_types.dart (wildcard-typed)"?>
```dart
switch (record) {
  case (int _, String _):
    print('First field is int and second is String.');
}
```

[Patterns]: /language/patterns
[type cast]: /language/operators#type-test-operators
[destructure]: /language/patterns#destructuring
[throw]: /language/error-handling#throw
[Declaration]: /language/patterns#variable-declaration
[Assignment]: /language/patterns#variable-assignment
[Matching]: /language/patterns#matching
[`List`]: /language/collections#lists
[`Map`]: /language/collections#maps
[`StateError`]: {{site.dart-api}}/dart-core/StateError-class.html
[refuted]: /resources/glossary#refutable-pattern
[record]: /language/records
[shape]: /language/records#record-types
[switch]: /language/branches#switch
