---
ia-translate: true
title: Tipos de padrões
description: Referência de tipos de padrões em Dart.
prevpage:
  url: /language/patterns
  title: Padrões
nextpage:
  url: /language/functions
  title: Funções
---

Esta página é uma referência para os diferentes tipos de padrões.
Para uma visão geral de como os padrões funcionam, onde você pode usá-los em
Dart, e casos de uso comuns, visite a página principal [Padrões][Padrões].

#### Precedência de padrões {:#pattern-precedence}

Semelhante à [precedência de operadores](/language/operators#operator-precedence-example),
a avaliação de padrões segue regras de precedência.
Você pode usar [padrões entre parênteses](#parenthesized) para
avaliar padrões de precedência inferior primeiro.

Este documento lista os tipos de padrões em ordem crescente de precedência:

* Padrões [lógicos-ou](#logical-or) têm precedência menor que os [lógicos-e](#logical-and),
padrões lógicos-e têm precedência menor que padrões [relacionais](#relational),
e assim por diante.

* Padrões unários pós-fixados ([cast](#cast), [null-check](#null-check),
e [null-assert](#null-assert)) compartilham o mesmo nível de precedência.

* Os padrões primários restantes compartilham a maior precedência.
Padrões de tipo coleção ([registro](#record), [lista](#list) e [mapa](#map))
e padrões de [Objeto](#object) englobam outros
dados, então são avaliados primeiro como padrões externos.

## Lógico-ou {:#logical-or}

`subpadrão1 || subpadrão2`

Um padrão lógico-ou separa subpadrões por `||` e corresponde se qualquer um dos
ramos corresponder. Os ramos são avaliados da esquerda para a direita. Uma vez que um ramo corresponde,
o resto não é avaliado.

<?code-excerpt "language/lib/patterns/pattern_types.dart (logical-or)"?>
```dart
var isPrimary = switch (color) {
  Color.red || Color.yellow || Color.blue => true,
  _ => false
};
```

Subpadrões em um padrão lógico-ou podem vincular variáveis, mas os ramos devem
definir o mesmo conjunto de variáveis, porque apenas um ramo será avaliado quando
o padrão corresponder.

## Lógico-e {:#logical-and}

`subpadrão1 && subpadrão2`

Um par de padrões separados por `&&` corresponde somente se ambos os subpadrões
corresponderem. Se o ramo esquerdo não corresponder, o ramo direito não é avaliado.

Subpadrões em um padrão lógico-e podem vincular variáveis, mas as variáveis em
cada subpadrão não devem se sobrepor, porque ambos serão vinculados se o padrão
corresponder:

<?code-excerpt "language/lib/patterns/pattern_types.dart (logical-and)"?>
```dart
switch ((1, 2)) {
  // Error, both subpatterns attempt to bind 'b'.
  case (var a, var b) && (var b, var c): // ...
}
```

## Relacional {:#relational}

`== expressão`

`< expressão`

Padrões relacionais comparam o valor correspondido a uma constante dada usando qualquer
um dos operadores de igualdade ou relacionais: `==`, `!=`, `<`, `>`, `<=`, e `>=`.

O padrão corresponde quando chamar o operador apropriado no valor correspondido
com a constante como argumento retorna `true`.

Padrões relacionais são úteis para corresponder em intervalos numéricos, especialmente quando
combinados com o [padrão lógico-e](#logical-and):

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
    _ => ''
  };
}
```

## Cast {:#cast}

`foo as String`

Um padrão de cast (conversão de tipo) permite inserir um [type cast][type cast] no meio da desestruturação,
antes de passar o valor para outro subpadrão:

<?code-excerpt "language/lib/patterns/pattern_types.dart (cast)"?>
```dart
(num, Object) record = (1, 's');
var (i as int, s as String) = record;
```

Padrões de cast vão [lançar (throw)][lançar (throw)] se o valor não tiver o tipo declarado.
Como o [padrão null-assert](#null-assert), isso permite que você afirme a força o
tipo esperado de algum valor desestruturado.

## Null-check {:#null-check}

`subpadrão?`

Padrões null-check (verificação de nulo) correspondem primeiro se o valor não é nulo e,
em seguida, correspondem o padrão interno contra esse mesmo valor. Eles permitem que você vincule
uma variável cujo tipo é o tipo base não anulável do valor anulável que está sendo correspondido.

Para tratar valores `null` como falhas de correspondência
sem lançar, use o padrão null-check.

<?code-excerpt "language/lib/patterns/pattern_types.dart (null-check)"?>
```dart
String? maybeString = 'nullable with base type String';
switch (maybeString) {
  case var s?:
  // 's' has type non-nullable String here.
}
```

Para corresponder quando o valor _é_ nulo, use o [padrão constante](#constant) `null`.

## Null-assert {:#null-assert}

`subpadrão!`

Padrões null-assert (afirmação de não nulo) correspondem primeiro se o objeto não é nulo, depois no valor.
Eles permitem que valores não nulos fluam através, mas [lançam (throw)][lançar (throw)] se o valor correspondido
for nulo.

Para garantir que valores `null` não sejam silenciosamente tratados como falhas de correspondência,
use um padrão null-assert enquanto corresponder:

<?code-excerpt "language/lib/patterns/pattern_types.dart (null-assert-match)"?>
```dart
List<String?> row = ['user', null];
switch (row) {
  case ['user', var name!]: // ...
  // 'name' is a non-nullable string here.
}
```

Para eliminar valores `null` de padrões de declaração de variáveis,
use o padrão null-assert:

<?code-excerpt "language/lib/patterns/pattern_types.dart (null-assert-dec)"?>
```dart
(int?, int?) position = (2, 3);

var (x!, y!) = position;
```

Para corresponder quando o valor _é_ nulo, use o [padrão constante](#constant) `null`.

## Constante {:#constant}

`123, null, 'string', math.pi, SomeClass.constant, const Thing(1, 2), const (1 + 2)`

Padrões constantes correspondem quando o valor é igual à constante:

<?code-excerpt "language/lib/patterns/pattern_types.dart (constant)"?>
```dart
switch (number) {
  // Matches if 1 == number.
  case 1: // ...
}
```

Você pode usar literais simples e referências a constantes nomeadas diretamente como padrões constantes:

- Literais numéricos (`123`, `45.56`)
- Literais booleanos (`true`)
- Literais de string (`'string'`)
- Constantes nomeadas (`someConstant`, `math.pi`, `double.infinity`)
- Construtores constantes (`const Point(0, 0)`)
- Literais de coleção constantes (`const []`, `const {1, 2}`)

Expressões constantes mais complexas devem ser colocadas entre parênteses e prefixadas com
`const` (`const (1 + 2)`):

<?code-excerpt "language/lib/patterns/pattern_types.dart (complex-constant)"?>
```dart
// List or map pattern:
case [a, b]: // ...

// List or map literal:
case const [a, b]: // ...
```

## Variável {:#variable}

`var bar, String str, final int _`

Padrões de variável vinculam novas variáveis a valores que foram correspondidos ou
desestruturados. Eles geralmente ocorrem como parte de um [padrão de desestruturação][destructure] para
capturar um valor desestruturado.

As variáveis estão no escopo em uma região de código que só é alcançável quando o
padrão correspondeu.

<?code-excerpt "language/lib/patterns/pattern_types.dart (variable)"?>
```dart
switch ((1, 2)) {
  // 'var a' and 'var b' are variable patterns that bind to 1 and 2, respectively.
  case (var a, var b): // ...
  // 'a' and 'b' are in scope in the case body.
}
```

Um padrão de variável _tipada_ só corresponde se o valor correspondido tiver o tipo declarado,
e falha caso contrário:

<?code-excerpt "language/lib/patterns/pattern_types.dart (variable-typed)"?>
```dart
switch ((1, 2)) {
  // Does not match.
  case (int a, String b): // ...
}
```

Você pode usar um [padrão curinga](#wildcard) como um padrão de variável.

## Identificador {:#identifier}

`foo, _`

Padrões de identificador podem se comportar como um [padrão constante](#constant) ou como um
[padrão de variável](#variable), dependendo do contexto em que aparecem:

- Contexto de [Declaração][Declaração]: declara uma nova variável com nome de identificador:
  `var (a, b) = (1, 2);`
- Contexto de [Atribuição][Atribuição]: atribui à variável existente com nome de identificador:
  `(a, b) = (3, 4);`
- Contexto de [Correspondência][Correspondência]: tratado como um padrão constante nomeado (a menos que seu nome seja `_`):
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
- Identificador [Curinga](#wildcard) em qualquer contexto: corresponde a qualquer valor e o descarta:
  `case [_, var y, _]: print('O elemento do meio é $y');`

## Entre parênteses {:#parenthesized}

`(subpadrão)`

Como expressões entre parênteses, parênteses em um padrão permitem que você controle a
[precedência de padrão](#pattern-precedence) e insira um padrão de precedência inferior
onde um de precedência superior é esperado.

Por exemplo, imagine que as constantes booleanas `x`, `y` e `z`
são iguais a `true`, `true` e `false`, respectivamente.
Embora o exemplo a seguir se assemelhe à avaliação de expressão booleana,
o exemplo corresponde a padrões.

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

Dart começa a corresponder ao padrão da esquerda para a direita.

1. O primeiro padrão corresponde a `true` quando `x` corresponde a `true`.
2. O segundo padrão corresponde a `true` quando `x` corresponde a `true`.
3. O terceiro padrão corresponde a `true` quando `x` corresponde a `true`.
4. O quarto padrão `(x || y) && z` não tem correspondência.

   * O `x` corresponde a `true`, então Dart não tenta corresponder a `y`.
   * Embora `(x || y)` corresponda a `true`, `z` não corresponde a `true`
   * Portanto, o padrão `(x || y) && z` não corresponde a `true`.
   * O subpadrão `(x || y)` não corresponde a `false`,
     então Dart não tenta corresponder a `z`.
   * Portanto, o padrão `(x || y) && z` não corresponde a `false`.
   * Em conclusão, `(x || y) && z` não tem correspondência.

## Lista {:#list}

`[subpadrão1, subpadrão2]`

Um padrão de lista corresponde a valores que implementam [`List`][`List`], e então recursivamente
corresponde seus subpadrões contra os elementos da lista para desestruturá-los por posição:

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

Padrões de lista exigem que o número de elementos no padrão corresponda à lista inteira. Você pode,
no entanto, usar um [elemento rest](#rest-element) como um espaço reservado para
considerar qualquer número de elementos em uma lista.

### Elemento rest {:#rest-element}

Padrões de lista podem conter _um_ elemento rest (`...`) que permite corresponder listas
de comprimentos arbitrários.

<?code-excerpt "language/lib/patterns/pattern_types.dart (rest)"?>
```dart
var [a, b, ..., c, d] = [1, 2, 3, 4, 5, 6, 7];
// Prints "1 2 6 7".
print('$a $b $c $d');
```

Um elemento rest também pode ter um subpadrão que coleta elementos que não correspondem
aos outros subpadrões na lista, em uma nova lista:

<?code-excerpt "language/lib/patterns/pattern_types.dart (rest-sub)"?>
```dart
var [a, b, ...rest, c, d] = [1, 2, 3, 4, 5, 6, 7];
// Prints "1 2 [3, 4, 5] 6 7".
print('$a $b $rest $c $d');
```

## Mapa {:#map}

`{"chave": subpadrão1, someConst: subpadrão2}`

Padrões de mapa correspondem a valores que implementam [`Map`][`Map`], e então recursivamente
correspondem seus subpadrões contra as chaves do mapa para desestruturá-los.

Padrões de mapa não exigem que o padrão corresponda ao mapa inteiro. Um padrão de mapa
ignora quaisquer chaves que o mapa contenha que não sejam correspondidas pelo padrão.
Tentar corresponder a uma chave que não existe no mapa irá
lançar um [`StateError`][]:

<?code-excerpt "language/lib/patterns/pattern_types.dart (map-error)"?>
```dart
final {'foo': int? foo} = {};
```

## Registro {:#record}

`(subpadrão1, subpadrão2)`

`(x: subpadrão1, y: subpadrão2)`

Padrões de registro correspondem a um objeto [registro][registro] e desestruturam seus campos.
Se o valor não for um registro com a mesma [forma][forma] que o padrão, a correspondência
falha. Caso contrário, os subpadrões de campo são correspondidos contra os
campos correspondentes no registro.

Padrões de registro exigem que o padrão corresponda ao registro inteiro. Para desestruturar
um registro com campos _nomeados_ usando um padrão, inclua os nomes dos campos no padrão:

<?code-excerpt "language/lib/patterns/pattern_types.dart (record)"?>
```dart
var (myString: foo, myNumber: bar) = (myString: 'string', myNumber: 1);
```

O nome do getter pode ser omitido e inferido do [padrão de variável](#variable)
ou [padrão de identificador](#identifier) no subpadrão de campo. Estes pares de
padrões são cada um equivalente:

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

## Objeto {:#object}

`SomeClass(x: subpadrão1, y: subpadrão2)`

Padrões de objeto verificam o valor correspondido em relação a um tipo nomeado dado para desestruturar
dados usando getters nas propriedades do objeto. Eles são [refutados][refutado]
se o valor não tiver o mesmo tipo.

<?code-excerpt "language/lib/patterns/pattern_types.dart (object)"?>
```dart
switch (shape) {
  // Matches if shape is of type Rect, and then against the properties of Rect.
  case Rect(width: var w, height: var h): // ...
}
```

O nome do getter pode ser omitido e inferido do [padrão de variável](#variable)
ou [padrão de identificador](#identifier) no subpadrão de campo:

<?code-excerpt "language/lib/patterns/pattern_types.dart (object-getter)"?>
```dart
// Binds new variables x and y to the values of Point's x and y properties.
var Point(:x, :y) = Point(1, 2);
```

Padrões de objeto não exigem que o padrão corresponda ao objeto inteiro.
Se um objeto tiver campos extras que o padrão não desestrutura, ele ainda pode corresponder.

## Curinga {:#wildcard}

`_`

Um padrão nomeado `_` é um curinga, seja um [padrão de variável](#variable) ou
[padrão de identificador](#identifier), que não vincula ou atribui a nenhuma variável.

É útil como um espaço reservado em locais onde você precisa de um subpadrão para
desestruturar valores posicionais posteriores:

<?code-excerpt "language/lib/patterns/pattern_types.dart (wildcard)"?>
```dart
var list = [1, 2, 3];
var [_, two, _] = list;
```

Um nome curinga com uma anotação de tipo é útil quando você deseja testar o
tipo de um valor, mas não vincular o valor a um nome:

<?code-excerpt "language/lib/patterns/pattern_types.dart (wildcard-typed)"?>
```dart
switch (record) {
  case (int _, String _):
    print('First field is int and second is String.');
}
```

[Padrões]: /language/patterns
[type cast]: /language/operators#type-test-operators
[destructure]: /language/patterns#destructuring
[lançar (throw)]: /language/error-handling#throw
[Declaração]: /language/patterns#variable-declaration
[Atribuição]: /language/patterns#variable-assignment
[Correspondência]: /language/patterns#matching
[`List`]: /language/collections#lists
[`Map`]: /language/collections#maps
[`StateError`]: {{site.dart-api}}/dart-core/StateError-class.html
[refutado]: /resources/glossary#refutable-pattern
[registro]: /language/records
[forma]: /language/records#record-types
[switch]: /language/branches#switch
