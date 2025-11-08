---
ia-translate: true
title: Coleções
description: Resumo dos diferentes tipos de coleções em Dart.
prevpage:
  url: /language/records
  title: Records
nextpage:
  url: /language/generics
  title: Generics
---

O Dart tem suporte integrado para [coleções][collections] de list, set e map.
Para saber mais sobre como configurar os tipos que as coleções contêm,
confira [Generics][generics].

[generics]: /language/generics
[collections]: /libraries/dart-core#collections

## Lists

Talvez a coleção mais comum em quase todas as linguagens de programação
seja o *array*, ou grupo ordenado de objetos. No Dart, arrays são
objetos [`List`][], então a maioria das pessoas os chama apenas de *lists*.

Literais de list em Dart são denotados por uma lista separada por vírgulas de
elementos entre colchetes (`[]`). Cada elemento
geralmente é uma expressão. Aqui está uma list simples em Dart:

<?code-excerpt "misc/lib/language_tour/built_in_types.dart (list-literal)"?>
```dart
var list = [1, 2, 3];
```

:::note
O Dart infere que `list` tem o tipo `List<int>`. Se você tentar adicionar objetos não inteiros
a esta list, o analisador ou runtime gera um erro. Para mais
informações, leia sobre [inferência de tipos][type inference].
:::

<a id="trailing-comma"></a>
Você pode adicionar uma vírgula após o último item em um literal de coleção Dart.
Esta _vírgula final_ não afeta a coleção,
mas pode ajudar a prevenir erros de copiar-colar.

<?code-excerpt "misc/lib/language_tour/built_in_types.dart (trailing-commas)"?>
```dart
var list = ['Car', 'Boat', 'Plane'];
```

Lists usam indexação baseada em zero, onde 0 é o índice do primeiro elemento
e `list.length - 1` é o índice do último elemento.
Você pode obter o comprimento de uma list usando a propriedade `.length`
e acessar os elementos de uma list usando o operador de subscrito (`[]`):

<?code-excerpt "misc/test/language_tour/built_in_types_test.dart (list-indexing)"?>
```dart
var list = [1, 2, 3];
assert(list.length == 3);
assert(list[1] == 2);

list[1] = 1;
assert(list[1] == 1);
```

Para criar uma list que seja uma constante de tempo de compilação,
adicione `const` antes do literal de list:

<?code-excerpt "misc/lib/language_tour/built_in_types.dart (const-list)"?>
```dart
var constantList = const [1, 2, 3];
// constantList[1] = 1; // This line will cause an error.
```

Para mais informações sobre lists, consulte a seção Lists da
[documentação do `dart:core`](/libraries/dart-core#lists).

[`List`]: {{site.dart-api}}/dart-core/List-class.html
[type inference]: /language/type-system#type-inference

## Sets

Um set em Dart é uma coleção não ordenada de elementos únicos.
O suporte do Dart para sets é fornecido por literais de set e o
tipo [`Set`][].

Aqui está um set simples em Dart, criado usando um literal de set:

<?code-excerpt "misc/lib/language_tour/built_in_types.dart (set-literal)"?>
```dart
var halogens = {'fluorine', 'chlorine', 'bromine', 'iodine', 'astatine'};
```

:::note
O Dart infere que `halogens` tem o tipo `Set<String>`. Se você tentar adicionar o
tipo errado de elemento ao set, o analisador ou runtime gera um erro. Para
mais informações, leia sobre
[inferência de tipos.](/language/type-system#type-inference)
:::

Para criar um set vazio, use `{}` precedido por um argumento de tipo,
ou atribua `{}` a uma variável do tipo `Set`:

<?code-excerpt "misc/lib/language_tour/built_in_types.dart (set-vs-map)"?>
```dart
var names = <String>{};
// Set<String> names = {}; // This works, too.
// var names = {}; // Creates a map, not a set.
```

:::note Set ou map?
A sintaxe para literais de map é semelhante à de literais de
set. Como os literais de map vieram primeiro, `{}` é padrão para o tipo `Map`. Se
você esquecer a anotação de tipo em `{}` ou a variável à qual ele é atribuído, então
o Dart cria um objeto do tipo `Map<dynamic, dynamic>`.
:::

Adicione itens a um set existente usando os métodos `add()` ou `addAll()`:

<?code-excerpt "misc/lib/language_tour/built_in_types.dart (set-add-items)"?>
```dart
var elements = <String>{};
elements.add('fluorine');
elements.addAll(halogens);
```

Use `.length` para obter o número de itens no set:

<?code-excerpt "misc/test/language_tour/built_in_types_test.dart (set-length)"?>
```dart
var elements = <String>{};
elements.add('fluorine');
elements.addAll(halogens);
assert(elements.length == 5);
```

Para criar um set que seja uma constante de tempo de compilação,
adicione `const` antes do literal de set:

<?code-excerpt "misc/lib/language_tour/built_in_types.dart (const-set)"?>
```dart
final constantSet = const {
  'fluorine',
  'chlorine',
  'bromine',
  'iodine',
  'astatine',
};
// constantSet.add('helium'); // This line will cause an error.
```

Para mais informações sobre sets, consulte a seção Sets da
[documentação do `dart:core`](/libraries/dart-core#sets).

[`Set`]: {{site.dart-api}}/dart-core/Set-class.html

## Maps

Em um map, cada elemento é um par chave-valor. Cada chave dentro
de um par está associada a um valor, e tanto as chaves quanto os valores
podem ser qualquer tipo de objeto. Cada chave pode ocorrer apenas uma vez,
embora o mesmo valor possa ser associado a múltiplas
chaves diferentes. O suporte do Dart para maps é fornecido por
literais de map e o tipo [`Map`][].

Aqui estão alguns maps simples em Dart, criados usando literais de map:

<?code-excerpt "misc/lib/language_tour/built_in_types.dart (map-literal)"?>
```dart
var gifts = {
  // Key:    Value
  'first': 'partridge',
  'second': 'turtledoves',
  'fifth': 'golden rings',
};

var nobleGases = {2: 'helium', 10: 'neon', 18: 'argon'};
```

:::note
O Dart infere que `gifts` tem o tipo `Map<String, String>` e `nobleGases`
tem o tipo `Map<int, String>`. Se você tentar adicionar o tipo errado de valor a
qualquer um dos maps, o analisador ou runtime gera um erro. Para mais informações,
leia sobre [inferência de tipos][type inference].
:::

Você pode criar os mesmos objetos usando um construtor Map:

<?code-excerpt "misc/lib/language_tour/built_in_types.dart (map-constructor)"?>
```dart
var gifts = Map<String, String>();
gifts['first'] = 'partridge';
gifts['second'] = 'turtledoves';
gifts['fifth'] = 'golden rings';

var nobleGases = Map<int, String>();
nobleGases[2] = 'helium';
nobleGases[10] = 'neon';
nobleGases[18] = 'argon';
```

:::note
Se você vem de uma linguagem como C# ou Java, você pode esperar ver `new Map()`
em vez de apenas `Map()`. Em Dart, a palavra-chave `new` é opcional.
Para detalhes, veja [Usando construtores][Using constructors].
:::

Adicione um novo par chave-valor a um map existente
usando o operador de atribuição de subscrito (`[]=`):

<?code-excerpt "misc/lib/language_tour/built_in_types.dart (map-add-item)"?>
```dart
var gifts = {'first': 'partridge'};
gifts['fourth'] = 'calling birds'; // Add a key-value pair
```

Recupere um valor de um map usando o operador de subscrito (`[]`):

<?code-excerpt "misc/test/language_tour/built_in_types_test.dart (map-retrieve-item)"?>
```dart
var gifts = {'first': 'partridge'};
assert(gifts['first'] == 'partridge');
```

Se você procurar uma chave que não está em um map, você recebe `null` de volta:

<?code-excerpt "misc/test/language_tour/built_in_types_test.dart (map-missing-key)"?>
```dart
var gifts = {'first': 'partridge'};
assert(gifts['fifth'] == null);
```

Use `.length` para obter o número de pares chave-valor no map:

<?code-excerpt "misc/test/language_tour/built_in_types_test.dart (map-length)"?>
```dart
var gifts = {'first': 'partridge'};
gifts['fourth'] = 'calling birds';
assert(gifts.length == 2);
```

Para criar um map que seja uma constante de tempo de compilação,
adicione `const` antes do literal de map:

<?code-excerpt "misc/lib/language_tour/built_in_types.dart (const-map)"?>
```dart
final constantMap = const {2: 'helium', 10: 'neon', 18: 'argon'};

// constantMap[2] = 'Helium'; // This line will cause an error.
```

Para mais informações sobre maps, consulte a seção Maps da
[documentação do `dart:core`](/libraries/dart-core#maps).

[Using constructors]: /language/classes#using-constructors
[`Map`]: {{site.dart-api}}/dart-core/Map-class.html
[type inference]: /language/type-system#type-inference

## Elementos de coleção {: #collection-elements }

Um literal de coleção contém uma série de elementos. Durante
o runtime, cada elemento é avaliado, produzindo zero ou mais
valores que são então inseridos na coleção resultante.
Esses elementos se dividem em duas categorias principais: elementos folha
e elementos de fluxo de controle.

*   Elemento folha: Insere um item individual em um
    literal de coleção.

    *   Elemento de expressão: Avalia uma única
        expressão e insere o valor resultante
        na coleção.

    *   Elemento de entrada de map: Avalia um par de expressões de chave e valor
        e insere a entrada resultante na
        coleção.

*   Elemento de fluxo de controle: Adiciona condicionalmente ou iterativamente
    zero ou mais valores à coleção circundante.

    *   Elemento null-aware: Avalia uma expressão e se
        o resultado não for `null`, insere o valor na
        coleção circundante.

    *   Elemento spread: Itera sobre uma sequência dada
        (expressão de coleção) e insere todos os
        valores resultantes na coleção circundante.

    *   Elemento spread null-aware: Semelhante ao
        elemento spread, mas permite que a coleção seja
        `null` e não insere nada se ela for.

    *   Elemento if: Avalia condicionalmente um elemento interno
        com base em uma expressão de condição dada, e
        opcionalmente avalia outro elemento `else` se a
        condição for false.

    *   Elemento for: Itera e avalia repetidamente um
        elemento interno dado, inserindo zero ou mais
        valores resultantes.

Para saber mais sobre elementos de coleção, consulte as seguintes
seções.

<a id="control-flow-operators" aria-hidden="true"></a>
<a id="spread-operators" aria-hidden="true"></a>
<a id="collection-operators" aria-hidden="true"></a>

### Elementos de expressão {: #expression-element }

Um elemento de expressão avalia uma única expressão
e insere o valor resultante em uma coleção. Esta
expressão pode abranger várias construções como
literais, variáveis, operadores, chamadas de função e
chamadas de construtor.

Um elemento de expressão tem esta sintaxe em uma coleção:

```dart
<expression>
```

### Elementos de entrada de map {: #map-entry-element }

Um elemento de entrada de map avalia um par de expressões de chave e valor
e insere a entrada resultante em uma
coleção. Tanto a chave quanto o valor dentro deste par podem
ser expressões.

Um elemento de entrada de map tem esta sintaxe em uma coleção:

```dart
<key_expression>: <value_expression>
```

### Elementos null-aware {: #null-aware-element }

Um elemento null-aware avalia uma expressão e se o
resultado não for `null`, insere o valor na coleção
circundante.

:::version-note
Elementos de coleção null-aware requerem
uma [versão da linguagem][language version] de pelo menos 3.8.
:::

Um elemento null-aware tem a seguinte sintaxe em um
elemento de expressão:

```dart
?<expression>
```

Um elemento null-aware tem a seguinte sintaxe em um
elemento de entrada de map:

```dart
// key is a null-aware element
?<key_expression>: <value_expression>
```

```dart
// value is a null-aware element
<key_expression>: ?<value_expression>
```

```dart
// key and value are null-aware elements
?<key_expression>: ?<value_expression>
```

No exemplo a seguir, o resultado para o
elemento null-aware `?a` não é adicionado a uma list chamada
`items` porque `a` é `null`:

<?code-excerpt "misc/test/language_tour/collections/null_aware_element_a.dart (code-sample)"?>
```dart
int? absentValue = null;
int? presentValue = 3;
var items = [
  1,
  ?absentValue,
  ?presentValue,
  absentValue,
  5,
]; // [1, 3, null, 5]
```

O exemplo a seguir ilustra várias maneiras de
usar elementos null-aware dentro de
elementos de entrada de map:

<?code-excerpt "misc/test/language_tour/collections/null_aware_element_b.dart (code-sample)"?>
```dart
String? presentKey = 'Apple';
String? absentKey = null;

int? presentValue = 3;
int? absentValue = null;

var itemsA = {presentKey: absentValue}; // {Apple: null}
var itemsB = {presentKey: ?absentValue}; // {}

var itemsC = {absentKey: presentValue}; // {null: 3}
var itemsD = {?absentKey: presentValue}; // {}

var itemsE = {absentKey: absentValue}; // {null: null}
var itemsF = {?absentKey: ?absentValue}; // {}
```

[language version]: /resources/language/evolution#language-versioning

### Elementos spread {: #spread-element }

O elemento spread itera sobre uma sequência dada e
insere todos os valores resultantes na coleção
circundante.

Um elemento spread tem a seguinte sintaxe em uma coleção.
A expressão de sequência pode representar qualquer expressão que
seja avaliada como um objeto que implementa `Iterable`:

```dart
...<sequence_expression>
```

No exemplo a seguir, os elementos em uma list chamada `a`
são adicionados a uma list chamada `items`.

<?code-excerpt "misc/test/language_tour/collections/spread_operator_in_collection_a.dart (code_sample)"?>
```dart
var a = [1, 2, null, 4];
var items = [0, ...a, 5]; // [0, 1, 2, null, 4, 5]
```

Se você estiver espalhando uma expressão que pode ser avaliada como
`null` e quiser ignorar o `null` (e não inserir
elementos), use um [elemento spread null-aware][null-aware spread element].

Para saber mais sobre o operador spread, veja
[Operador spread][Spread operator].

[Spread operator]: /language/operators/#spread-operators
[null-aware spread element]: #null-spread-element

### Elementos spread null-aware {: #null-spread-element }

O elemento spread null-aware é semelhante ao
elemento spread, mas permite que a coleção seja `null` e
não insere nada se ela for.

Um elemento spread null-aware tem esta sintaxe em uma
coleção:

```dart
...?<sequence_expression>
```

No exemplo a seguir, uma list chamada `a` é ignorada
porque é null, mas os elementos em uma list chamada `b`
são adicionados a uma list chamada `items`. Observe que se uma
coleção em si não for `null`, mas contiver elementos que
são, esses elementos `null` ainda são adicionados ao resultado.

```dart
List<int>? a = null;
var b = [1, null, 3];
var items = [0, ...?a, ...?b, 4]; // [0, 1, null, 3, 4]
```

Devido ao null safety, você não pode realizar uma
operação spread (`...`) em um valor que possa ser null. O
exemplo a seguir produz um erro de tempo de compilação porque o
parâmetro `extraOptions` é nullable e o
operador spread usado em `extraOptions` não é null-aware.

<?code-excerpt "misc/test/language_tour/collections/null_spread_operator_in_collection_b.dart (code_sample)"?>
```dart tag=fails-sa
List<String> buildCommandLine(
  String executable,
  List<String> options, [
  List<String>? extraOptions,
]) {
  return [
    executable,
    ...options,
    ...extraOptions, // <-- Error
  ];
}

// Usage:
//   buildCommandLine('dart', ['run', 'my_script.dart'], null);
// Result:
//   Compile-time error
```

Se você quiser espalhar uma coleção nullable, use um
elemento spread null-aware. O exemplo a seguir é válido
porque o operador spread null-aware é usado em `extraOptions`.

<?code-excerpt "misc/test/language_tour/collections/null_spread_operator_in_collection_a.dart (code_sample)"?>
```dart
List<String> buildCommandLine(
  String executable,
  List<String> options, [
  List<String>? extraOptions,
]) {
  return [
    executable,
    ...options,
    ...?extraOptions, // <-- OK now.
  ];
}

// Usage:
//   buildCommandLine('dart', ['run', 'my_script.dart'], null);
// Result:
//   [dart, run, my_script.dart]
```

Para saber mais sobre o operador spread null-aware, veja
[Operador spread][Spread operator].

[Spread operator]: /language/operators/#spread-operators

### Elementos if {: #if-element }

Um elemento `if` avalia condicionalmente um elemento interno
com base em uma expressão de condição dada, e opcionalmente
avalia outro elemento `else` se a condição for false.

O elemento `if` tem algumas variações de sintaxe:

```dart
// If the bool expression is true, include the result.
if (<bool_expression>) <result>
```

```dart
// If the expression matches the pattern, include the result.
if (<expression> case <pattern>) <result>
```

```dart
// If the operation resolves as true, include the first
// result, otherwise, include the second result.
if (<bool_expression>) <result> else <result>
```

```dart
// If the operation resolves as true, include the first
// result, otherwise, include the second result.
if (<expression> case <pattern>) <result> else <result>
```

Os exemplos a seguir ilustram várias maneiras de
usar um elemento `if` dentro de uma coleção com
uma expressão booleana:

<?code-excerpt "misc/test/language_tour/collections/if_case_operator_in_collection_e.dart (code_sample)"?>
```dart
var includeItem = true;
var items = [0, if (includeItem) 1, 2, 3]; // [0, 1, 2, 3]
```

<?code-excerpt "misc/test/language_tour/collections/if_case_operator_in_collection_f.dart (code_sample)"?>
```dart
var includeItem = true;
var items = [0, if (!includeItem) 1, 2, 3]; // [0, 2, 3]
```

<?code-excerpt "misc/test/language_tour/collections/if_case_operator_in_collection_g.dart (code_sample)"?>
```dart
var name = 'apple';
var items = [0, if (name == 'orange') 1 else 10, 2, 3]; // [0, 10, 2, 3]
```

<?code-excerpt "misc/test/language_tour/collections/if_case_operator_in_collection_h.dart (code_sample)"?>
```dart
var name = 'apple';
var items = [
  0,
  if (name == 'kiwi') 1 else if (name == 'pear') 10,
  2,
  3,
]; // [0, 2, 3]
```

Os exemplos a seguir ilustram várias maneiras de
usar um elemento `if` com uma parte `case` dentro de uma
coleção:

<?code-excerpt "misc/test/language_tour/collections/if_case_operator_in_collection_a.dart (code_sample)"?>
```dart
Object data = 123;
var typeInfo = [
  if (data case int i) 'Data is an integer: $i',
  if (data case String s) 'Data is a string: $s',
  if (data case bool b) 'Data is a boolean: $b',
  if (data case double d) 'Data is a double: $d',
]; // [Data is an integer: 123, Data is a double: 123]
```

<?code-excerpt "misc/test/language_tour/collections/if_case_operator_in_collection_d.dart (code_sample)"?>
```dart
var word = 'hello';
var items = [
  1,
  if (word case String(length: var wordLength)) wordLength,
  3,
]; // [1, 5, 3]
```

<?code-excerpt "misc/test/language_tour/collections/if_case_operator_in_collection_b.dart (code_sample)"?>
```dart
var orderDetails = ['Apples', 12, ''];
var summary = [
  'Product: ${orderDetails[0]}',
  if (orderDetails case [_, int qty, _]) 'Quantity: $qty',
  if (orderDetails case [_, _, ''])
    'Delivery: Not Started'
  else
    'Delivery: In Progress',
]; // [Product: Apples, Quantity: 12, Delivery: Not Started]
```

Você pode misturar diferentes operações `if` com uma parte `else if`.
Por exemplo:

<?code-excerpt "misc/test/language_tour/collections/if_case_operator_in_collection_c.dart (code_sample)"?>
```dart
var a = 'apple';
var b = 'orange';
var c = 'mango';
var items = [
  0,
  if (a == 'apple') 1 else if (a case 'mango') 10,
  if (b case 'pear') 2 else if (b == 'mango') 20,
  if (c case 'apple') 3 else if (c case 'mango') 30,
  4,
]; // [0, 1, 30, 4]
```

Para saber mais sobre o condicional `if`, veja
[instrução `if`][`if` statement]. Para saber mais sobre o condicional `if-case`,
veja [instrução `if-case`][`if-case` statement].

[`if` statement]: /language/branches#if
[`if-case` statement]: /language/branches#if-case

### Elementos for {: #for-element }

Um elemento `for` itera e avalia repetidamente um
elemento interno dado, inserindo zero ou mais valores resultantes.

Um elemento `for` tem esta sintaxe em uma coleção:

```dart
for (<expression> in <collection>) <result>
```

```dart
for (<initialization_clause>; <condition_clause>; <increment_clause>) <result>
```

Os exemplos a seguir ilustram várias maneiras de
usar um elemento `for` dentro de uma coleção:

<?code-excerpt "misc/test/language_tour/collections/for_loop_in_collection_a.dart (code_sample)"?>
```dart
var numbers = [2, 3, 4];
var items = [1, for (var n in numbers) n * n, 7]; // [1, 4, 9, 16, 7]
```

<?code-excerpt "misc/test/language_tour/collections/for_loop_in_collection_b.dart (code_sample)"?>
```dart
var items = [1, for (var x = 5; x > 2; x--) x, 7]; // [1, 5, 4, 3, 7]
```

<?code-excerpt "misc/test/language_tour/collections/for_loop_in_collection_c.dart (code_sample)"?>
```dart
var items = [1, for (var x = 2; x < 4; x++) x, 7]; // [1, 2, 3, 7]
```

Para saber mais sobre o loop `for`, veja
[loops `for`][`for` loops].

[`for` loops]: /language/loops/#for-loops

### Aninhar elementos de fluxo de controle {: #nesting-elements }

Você pode aninhar elementos de fluxo de controle uns dentro dos outros. Esta
é uma alternativa poderosa às list comprehensions em outras
linguagens.

No exemplo a seguir, apenas os números pares em
`numbers` são incluídos em `items`.

<?code-excerpt "misc/test/language_tour/collections/nesting_in_collection_a.dart (code_sample)"?>
```dart
var numbers = [1, 2, 3, 4, 5, 6, 7];
var items = [
  0,
  for (var n in numbers)
    if (n.isEven) n,
  8,
]; // [0, 2, 4, 6, 8]
```

É comum e idiomático usar um spread em um literal de coleção
imediatamente dentro de um elemento `if` ou `for`. Por
exemplo:

<?code-excerpt "misc/test/language_tour/collections/nesting_in_collection_c.dart (code_sample)"?>
```dart
var items = [
  if (condition) oneThing(),
  if (condition) ...[multiple(), things()],
]; // [oneThing, [multiple_a, multiple_b], things]
```

Você pode aninhar todos os tipos de elementos arbitrariamente profundamente.
No exemplo a seguir, elementos `if`, `for` e spread
são aninhados uns dentro dos outros em uma coleção:

<?code-excerpt "misc/test/language_tour/collections/nesting_in_collection_b.dart (code_sample)"?>
```dart
var nestItems = true;
var ys = [1, 2, 3, 4];
var items = [
  if (nestItems) ...[
    for (var x = 0; x < 3; x++)
      for (var y in ys)
        if (x < y) x + y * 10,
  ],
]; // [10, 20, 30, 40, 21, 31, 41, 32, 42]
```
