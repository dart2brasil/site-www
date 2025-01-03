---
ia-translate: true
title: Tipos de Padrões
description: Referência de tipos de padrões em Dart.
prevpage:
  url: /language/patterns
  title: Padrões
nextpage:
  url: /language/functions
  title: Funções
---

Esta página é uma referência para os diferentes tipos de padrões.
Para uma visão geral de como os padrões funcionam, onde você pode usá-los em Dart,
e casos de uso comuns, visite a página principal [Padrões][Patterns].

#### Precedência de Padrões

Semelhante à [precedência de operadores](/language/operators#operator-precedence-example),
a avaliação de padrões segue regras de precedência.
Você pode usar [padrões entre parênteses](#parenthesized) para 
avaliar primeiro os padrões de menor precedência.

Este documento lista os tipos de padrões em ordem crescente de precedência:

* Padrões [Lógico-ou](#logical-or) tem precedência menor que padrões [lógico-e](#logical-and),
padrões lógico-e têm precedência menor que padrões [relacionais](#relational),
e assim por diante.

* Padrões unários pós-fixados ([cast](#cast), [verificação de nulo](#null-check),
e [asserção de não nulo](#null-assert)) compartilham o mesmo nível de precedência.

* Os padrões primários restantes compartilham a maior precedência.
Padrões do tipo coleção ([registro](#record), [lista](#list) e [mapa](#map))
e padrões de [Objeto](#object) englobam outros
dados, portanto, são avaliados primeiro como padrões externos.

## Lógico-ou

`subpadrão1 || subpadrão2`

Um padrão lógico-ou separa subpadrões por `||` e corresponde se qualquer um dos
ramos corresponder. Os ramos são avaliados da esquerda para a direita. Uma vez que
um ramo corresponde, o resto não é avaliado.

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

## Lógico-e

`subpadrão1 && subpadrão2`

Um par de padrões separados por `&&` corresponde apenas se ambos os subpadrões
corresponderem. Se o ramo esquerdo não corresponder, o ramo direito não é avaliado.

Subpadrões em um padrão lógico-e podem vincular variáveis, mas as variáveis em
cada subpadrão não devem se sobrepor, porque ambas serão vinculadas se o padrão
corresponder:

<?code-excerpt "language/lib/patterns/pattern_types.dart (logical-and)"?>
```dart
switch ((1, 2)) {
  // Erro, ambos os subpadrões tentam vincular 'b'.
  case (var a, var b) && (var b, var c): // ...
}
```

## Relacional

`== expressão`

`< expressão`

Padrões relacionais comparam o valor correspondido a uma constante dada usando
qualquer um dos operadores de igualdade ou relacionais: `==`, `!=`, `<`, `>`, `<=`,
e `>=`.

O padrão corresponde quando chamar o operador apropriado no valor correspondido
com a constante como argumento retorna `true`.

Padrões relacionais são úteis para corresponder intervalos numéricos,
especialmente quando combinados com o [padrão lógico-e](#logical-and):

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

## Cast

`foo as String`

Um padrão de cast permite inserir um [type cast][type cast] no meio da desestruturação,
antes de passar o valor para outro subpadrão:

<?code-excerpt "language/lib/patterns/pattern_types.dart (cast)"?>
```dart
(num, Object) record = (1, 's');
var (i as int, s as String) = record;
```

Padrões de cast irão [lançar][throw] se o valor não tiver o tipo declarado.
Como o [padrão de asserção de não nulo](#null-assert), isso permite que você
force a asserção do tipo esperado de algum valor desestruturado.

## Verificação de nulo

`subpadrão?`

Padrões de verificação de nulo correspondem primeiro se o valor não for nulo e,
em seguida, correspondem ao padrão interno em relação a esse mesmo valor. Eles
permitem que você vincule uma variável cujo tipo seja o tipo base não anulável do
valor anulável que está sendo correspondido.

Para tratar valores `null` como falhas de correspondência
sem lançar exceção, use o padrão de verificação de nulo.

<?code-excerpt "language/lib/patterns/pattern_types.dart (null-check)"?>
```dart
String? maybeString = 'nullable with base type String';
switch (maybeString) {
  case var s?:
  // 's' tem tipo String não anulável aqui.
}
```

Para corresponder quando o valor _é_ nulo, use o [padrão constante](#constant) `null`.

## Asserção de não nulo

`subpadrão!`

Padrões de asserção de não nulo correspondem primeiro se o objeto não for nulo e,
em seguida, no valor. Eles permitem que valores não nulos fluam, mas
[lançam][throw] se o valor correspondido for nulo.

Para garantir que valores `null` não sejam tratados silenciosamente como falhas de
correspondência, use um padrão de asserção de não nulo ao corresponder:

<?code-excerpt "language/lib/patterns/pattern_types.dart (null-assert-match)"?>
```dart
List<String?> row = ['user', null];
switch (row) {
  case ['user', var name!]: // ...
  // 'name' é uma string não anulável aqui.
}
```

Para eliminar valores `null` de padrões de declaração de variáveis,
use o padrão de asserção de não nulo:

<?code-excerpt "language/lib/patterns/pattern_types.dart (null-assert-dec)"?>
```dart
(int?, int?) position = (2, 3);

var (x!, y!) = position;
```

Para corresponder quando o valor _é_ nulo, use o [padrão constante](#constant) `null`.

## Constante

`123, null, 'string', math.pi, SomeClass.constant, const Thing(1, 2), const (1 + 2)`

Padrões constantes correspondem quando o valor é igual à constante:

<?code-excerpt "language/lib/patterns/pattern_types.dart (constant)"?>
```dart
switch (number) {
  // Corresponde se 1 == number.
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

Expressões constantes mais complexas devem ser colocadas entre parênteses e prefixadas
com `const` (`const (1 + 2)`):

<?code-excerpt "language/lib/patterns/pattern_types.dart (complex-constant)"?>
```dart
// Padrão de lista ou mapa:
case [a, b]: // ...

// Literal de lista ou mapa:
case const [a, b]: // ...
```

## Variável

`var bar, String str, final int _`

Padrões de variável vinculam novas variáveis a valores que foram correspondidos ou
desestruturados. Eles geralmente ocorrem como parte de um [padrão de
desestruturação][destructure] para capturar um valor desestruturado.

As variáveis estão no escopo em uma região de código que só é acessível quando o
padrão correspondeu.

<?code-excerpt "language/lib/patterns/pattern_types.dart (variable)"?>
```dart
switch ((1, 2)) {
  // 'var a' e 'var b' são padrões de variável que se vinculam a 1 e 2, respectivamente.
  case (var a, var b): // ...
  // 'a' e 'b' estão no escopo no corpo do caso.
}
```

Um padrão de variável _tipada_ só corresponde se o valor correspondido tiver o tipo
declarado e falha caso contrário:

<?code-excerpt "language/lib/patterns/pattern_types.dart (variable-typed)"?>
```dart
switch ((1, 2)) {
  // Não corresponde.
  case (int a, String b): // ...
}
```

Você pode usar um [padrão curinga](#wildcard) como um padrão de variável.

## Identificador

`foo, _`

Padrões de identificador podem se comportar como um [padrão constante](#constant) ou
como um [padrão variável](#variable), dependendo do contexto em que aparecem:

- Contexto de [Declaração][Declaration]: declara uma nova variável com nome de identificador:
  `var (a, b) = (1, 2);`
- Contexto de [Atribuição][Assignment]: atribui a variável existente com nome de identificador:
  `(a, b) = (3, 4);`
- Contexto de [Correspondência][Matching]: tratado como um padrão constante nomeado (a
  menos que seu nome seja `_`):
  <?code-excerpt "language/lib/patterns/pattern_types.dart (match-context)"?>
  ```dart
  const c = 1;
  switch (2) {
    case c:
      print('match $c');
    default:
      print('no match'); // Imprime "no match".
  }
  ```
- Identificador [Curinga](#wildcard) em qualquer contexto: corresponde a qualquer valor
  e o descarta:
  `case [_, var y, _]: print('O elemento do meio é $y');`

## Entre parênteses

`(subpadrão)`

Como expressões entre parênteses, parênteses em um padrão permitem controlar a
[precedência de padrões](#pattern-precedence) e inserir um padrão de precedência
inferior onde um de precedência superior é esperado.

Por exemplo, imagine que as constantes booleanas `x`, `y` e `z` sejam
iguais a `true`, `true` e `false`, respectivamente.
Embora o exemplo a seguir se pareça com a avaliação de expressão booleana,
o exemplo corresponde a padrões.

<?code-excerpt "language/lib/patterns/pattern_types.dart (parens)"?>
```dart
// ...
x || y => 'corresponde a true',
x || y && z => 'corresponde a true',
x || (y && z) => 'corresponde a true',
// `x || y && z` é a mesma coisa que `x || (y && z)`.
(x || y) && z => 'não corresponde a nada',
// ...
```

Dart começa a corresponder ao padrão da esquerda para a direita.

1. O primeiro padrão corresponde a `true` conforme `x` corresponde a `true`.
2. O segundo padrão corresponde a `true` conforme `x` corresponde a `true`.
3. O terceiro padrão corresponde a `true` conforme `x` corresponde a `true`.
4. O quarto padrão `(x || y) && z` não tem correspondência.

   * O `x` corresponde a `true`, então o Dart não tenta corresponder `y`.
   * Embora `(x || y)` corresponda a `true`, `z` não corresponde a `true`
   * Portanto, o padrão `(x || y) && z` não corresponde a `true`.
   * O subpadrão `(x || y)` não corresponde a `false`,
     então o Dart não tenta corresponder a `z`.
   * Portanto, o padrão `(x || y) && z` não corresponde a `false`.
   * Concluindo, `(x || y) && z` não tem correspondência.

## Lista

`[subpadrão1, subpadrão2]`

Um padrão de lista corresponde a valores que implementam [`List`][`List`] e, em
seguida, corresponde recursivamente seus subpadrões aos elementos da lista para
desestruturá-los por posição:

<?code-excerpt "language/lib/patterns/switch.dart (list-pattern)"?>
```dart
const a = 'a';
const b = 'b';
switch (obj) {
  // O padrão de lista [a, b] corresponde a obj primeiro se obj for uma lista com dois campos,
  // em seguida, se seus campos corresponderem aos subpadrões constantes 'a' e 'b'.
  case [a, b]:
    print('$a, $b');
}
```

Padrões de lista exigem que o número de elementos no padrão corresponda a toda a
lista. Você pode, no entanto, usar um [elemento restante](#rest-element) como um
espaço reservado para considerar qualquer número de elementos em uma lista.

### Elemento restante

Padrões de lista podem conter _um_ elemento restante (`...`) que permite corresponder
listas de comprimentos arbitrários.

<?code-excerpt "language/lib/patterns/pattern_types.dart (rest)"?>
```dart
var [a, b, ..., c, d] = [1, 2, 3, 4, 5, 6, 7];
// Imprime "1 2 6 7".
print('$a $b $c $d');
```

Um elemento restante também pode ter um subpadrão que coleta elementos que não
correspondem aos outros subpadrões na lista em uma nova lista:

<?code-excerpt "language/lib/patterns/pattern_types.dart (rest-sub)"?>
```dart
var [a, b, ...rest, c, d] = [1, 2, 3, 4, 5, 6, 7];
// Imprime "1 2 [3, 4, 5] 6 7".
print('$a $b $rest $c $d');
```

## Mapa

`{"chave": subpadrão1, someConst: subpadrão2}`

Padrões de mapa correspondem a valores que implementam [`Map`][`Map`] e, em
seguida, correspondem recursivamente seus subpadrões às chaves do mapa para
desestruturá-los.

Padrões de mapa não exigem que o padrão corresponda ao mapa inteiro. Um padrão de
mapa ignora quaisquer chaves que o mapa contenha que não sejam correspondidas pelo
padrão.

## Registro

`(subpadrão1, subpadrão2)`

`(x: subpadrão1, y: subpadrão2)`

Padrões de registro correspondem a um objeto [registro][record] e desestruturam
seus campos. Se o valor não for um registro com a mesma [forma][shape] que o
padrão, a correspondência falha. Caso contrário, os subpadrões de campo são
correspondidos em relação aos campos correspondentes no registro.

Padrões de registro exigem que o padrão corresponda ao registro inteiro. Para
desestruturar um registro com campos _nomeados_ usando um padrão, inclua os nomes
dos campos no padrão:

<?code-excerpt "language/lib/patterns/pattern_types.dart (record)"?>
```dart
var (myString: foo, myNumber: bar) = (myString: 'string', myNumber: 1);
```

O nome do getter pode ser omitido e inferido a partir do [padrão de variável]
(#variable) ou [padrão de identificador](#identifier) no subpadrão de campo. Esses
pares de padrões são equivalentes:

<?code-excerpt "language/lib/patterns/pattern_types.dart (record-getter)"?>
```dart
// Padrão de registro com subpadrões variáveis:
var (untyped: untyped, typed: int typed) = record;
var (:untyped, :int typed) = record;

switch (record) {
  case (untyped: var untyped, typed: int typed): // ...
  case (:var untyped, :int typed): // ...
}

// Padrão de registro com subpadrões de verificação de nulo e asserção de não nulo:
switch (record) {
  case (checked: var checked?, asserted: var asserted!): // ...
  case (:var checked?, :var asserted!): // ...
}

// Padrão de registro com subpadrão de cast:
var (untyped: untyped as int, typed: typed as String) = record;
var (:untyped as int, :typed as String) = record;
```

## Objeto

`SomeClass(x: subpadrão1, y: subpadrão2)`

Padrões de objeto verificam o valor correspondido em relação a um tipo nomeado
específico para desestruturar dados usando getters nas propriedades do objeto.
Eles são [refutados][refuted] se o valor não tiver o mesmo tipo.

<?code-excerpt "language/lib/patterns/pattern_types.dart (object)"?>
```dart
switch (shape) {
  // Corresponde se shape é do tipo Rect e, em seguida, em relação às propriedades de Rect.
  case Rect(width: var w, height: var h): // ...
}
```

O nome do getter pode ser omitido e inferido a partir do [padrão de variável]
(#variable) ou [padrão de identificador](#identifier) no subpadrão de campo:

<?code-excerpt "language/lib/patterns/pattern_types.dart (object-getter)"?>
```dart
// Vincula novas variáveis x e y aos valores das propriedades x e y de Point.
var Point(:x, :y) = Point(1, 2);
```

Padrões de objeto não exigem que o padrão corresponda ao objeto inteiro.
Se um objeto tiver campos extras que o padrão não desestrutura, ele ainda poderá
corresponder.

## Curinga

`_`

Um padrão nomeado `_` é um curinga, seja um [padrão variável](#variable) ou
[padrão de identificador](#identifier), que não vincula ou atribui a nenhuma
variável.

É útil como um espaço reservado em locais onde você precisa de um subpadrão para
desestruturar valores posicionais posteriores:

<?code-excerpt "language/lib/patterns/pattern_types.dart (wildcard)"?>
```dart
var list = [1, 2, 3];
var [_, two, _] = list;
```

Um nome curinga com uma anotação de tipo é útil quando você deseja testar o tipo
de um valor, mas não vincular o valor a um nome:

<?code-excerpt "language/lib/patterns/pattern_types.dart (wildcard-typed)"?>
```dart
switch (record) {
  case (int _, String _):
    print('O primeiro campo é int e o segundo é String.');
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
[refuted]: /resources/glossary#refutable-pattern
[record]: /language/records
[shape]: /language/records#record-types
[switch]: /language/branches#switch
