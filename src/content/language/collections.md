---
ia-translate: true
title: "Coleções"
description: "Resumo dos diferentes tipos de coleções em Dart."
prevpage:
  url: /language/records
  title: Registros
nextpage:
  url: /language/generics
  title: "Genéricos"
---

Dart possui suporte interno para [coleções][collections] do tipo lista, set e map.
Para saber mais sobre como configurar os tipos que as coleções contêm,
confira [Generics][generics].

[generics]: /language/generics
[collections]: /libraries/dart-core#collections

## Lists

Talvez a coleção mais comum em quase todas as linguagens de programação
seja o *array* (matriz), ou grupo ordenado de objetos. Em Dart, arrays são
objetos [`List`][`List`] , então a maioria das pessoas apenas os chama de *listas*.

Dart list literals are denoted by a comma-separated list of
elements enclosed in square brackets (`[]`). Each element
is usually an expression. Here's a simple Dart list:

<?code-excerpt "misc/lib/language_tour/built_in_types.dart (list-literal)"?>
```dart
var list = [1, 2, 3];
```

:::note
Dart infere que `list` tem o tipo `List<int>`. Se você tentar adicionar
objetos não inteiros a esta lista, o analisador ou o tempo de execução gera um erro. Para mais
informações, leia sobre [inferência de tipo][type inference].
:::

<a id="trailing-comma"></a>
Você pode adicionar uma vírgula após o último item em um literal de coleção Dart.
Essa _vírgula à direita_ não afeta a coleção,
mas pode ajudar a evitar erros de copiar e colar.

<?code-excerpt "misc/lib/language_tour/built_in_types.dart (trailing-commas)"?>
```dart
var list = ['Car', 'Boat', 'Plane'];
```

Lists use zero-based indexing, where 0 is the index of the first element
and `list.length - 1` is the index of the last element.
You can get a list's length using the `.length` property
and access a list's elements using the subscript operator (`[]`):

<?code-excerpt "misc/test/language_tour/built_in_types_test.dart (list-indexing)"?>
```dart
var list = [1, 2, 3];
assert(list.length == 3);
assert(list[1] == 2);

list[1] = 1;
assert(list[1] == 1);
```

Para criar uma lista que seja uma constante em tempo de compilação,
adicione `const` antes do literal da lista:

<?code-excerpt "misc/lib/language_tour/built_in_types.dart (const-list)"?>
```dart
var constantList = const [1, 2, 3];
// constantList[1] = 1; // This line will cause an error.
```

Para mais informações sobre listas, consulte a seção Listas da
documentação [`dart:core`](/libraries/dart-core#lists).

[`List`]: {{site.dart-api}}/dart-core/List-class.html
[type inference]: /language/type-system#type-inference

## Sets

A set in Dart is an unordered collection of unique elements.
Dart support for sets is provided by set literals and the
[`Set`][] type.

Aqui está um set simples do Dart, criado usando um literal de set:

<?code-excerpt "misc/lib/language_tour/built_in_types.dart (set-literal)"?>
```dart
var halogens = {'fluorine', 'chlorine', 'bromine', 'iodine', 'astatine'};
```

:::note
Dart infers that `halogens` has the type `Set<String>`. If you try to add the
wrong type of element to the set, the analyzer or runtime raises an error. For
more information, read about
[type inference.](/language/type-system#type-inference)
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
A sintaxe para literais de map é semelhante à de
literais de set. Como os literais de map vieram primeiro, `{}` assume o tipo `Map` por padrão. Se
você esquecer a anotação de tipo em `{}` ou a variável à qual ela está atribuída, então
Dart cria um objeto do tipo `Map<dynamic, dynamic>`.
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

Para criar um set que seja uma constante em tempo de compilação,
adicione `const` antes do literal do set:

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
documentação [`dart:core`](/libraries/dart-core#sets).

[`Set`]: {{site.dart-api}}/dart-core/Set-class.html

## Maps

In a map, each element is a key-value pair. Each key within
a pair is associated with a value, and both keys and values
can be any type of object. Each key can occur only once,
although the same value can be associated with multiple
different keys. Dart support for maps is provided by
map literals and the [`Map`][] type.

Aqui estão alguns maps simples do Dart, criados usando literais de map:

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
Dart infere que `gifts` tem o tipo `Map<String, String>` e `nobleGases`
tem o tipo `Map<int, String>`. Se você tentar adicionar o tipo errado de valor a
qualquer um dos maps, o analisador ou o tempo de execução gera um erro. Para mais informações,
leia sobre [inferência de tipo][type inference].
:::

Você pode criar os mesmos objetos usando um construtor `Map`:

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
Se você vem de uma linguagem como C# ou Java, pode esperar ver `new Map()`
em vez de apenas `Map()`. Em Dart, a palavra-chave `new` é opcional.
Para detalhes, veja [Usando construtores][Usando construtores].
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

Se você procurar por uma chave que não está em um map, você recebe `null` em retorno:

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

Para criar um map que seja uma constante em tempo de compilação,
adicione `const` antes do literal do map:

<?code-excerpt "misc/lib/language_tour/built_in_types.dart (const-map)"?>
```dart
final constantMap = const {2: 'helium', 10: 'neon', 18: 'argon'};

// constantMap[2] = 'Helium'; // This line will cause an error.
```

Para mais informações sobre maps, consulte a seção Maps da
documentação [`dart:core`](/libraries/dart-core#maps).

[Using constructors]: /language/classes#using-constructors
[`Map`]: {{site.dart-api}}/dart-core/Map-class.html
[type inference]: /language/type-system#type-inference

## Collection elements {: #collection-elements }

A collection literal contains a series of elements. During
runtime, each element is evaluated, producing zero or more
values that are then inserted into the resulting collection.
These elements fall into two main categories: leaf elements
and control flow elements.

*   Leaf element: Inserts an individual item into a
    collection literal.
    
    *   Expression element: Evaluates a single
        expression and inserts the resulting value
        into the collection.

    *   Map entry element: Evaluates a pair of key and value
        expressions and inserts the resulting entry into the
        collection. 

*   Control flow element: Conditionally or iteratively adds
    zero or more values to the surrounding collection.

    *   Null-aware element: Evaluates an expression and if
        the result is not `null`, inserts the value into the
        surrounding collection.

    *   Spread element: Iterates over a given sequence
        (collection expression) and inserts all of the
        resulting values into the surrounding collection.
    
    *   Null-aware spread element: Similar to the
        spread element, but allows the collection to be
        `null` and inserts nothing if it is.

    *   If element: Conditionally evaluates an inner element
        based on given a condition expression, and
        optionally evaluates another `else` element if the
        condition is false.

    *   For element: Iterates and repeatedly evaluates a
        given inner element, inserting zero or more
        resulting values.

To learn more about collection elements, see the following
sections.

<a id="control-flow-operators" aria-hidden="true"></a>
<a id="spread-operators" aria-hidden="true"></a>
<a id="collection-operators" aria-hidden="true"></a>

### Expression elements {: #expression-element }

An expression element evaluates a single expression
and inserts the resulting value into a collection. This
expression can encompass various constructs like
literals, variables, operators, function calls, and
constructor calls.

An expression element has this syntax in a collection:

```dart
<expression>
```

### Map entry elements {: #map-entry-element }

A map entry element evaluates a pair of key and value
expressions and inserts the resulting entry into a
collection. Both the key and the value within this pair can
be expressions.

A map entry element has this syntax in a collection:

```dart
<key_expression>: <value_expression>
```

### Null-aware elements {: #null-aware-element }

A null-aware element evaluates an expression and if the
result is not `null`, inserts the value into the surrounding
collection.

:::version-note
Null-aware collection elements require
a [language version][] of at least 3.8.
:::

A null-aware element has the following syntax in an
expression element:

```dart
?<expression>
```

A null-aware element has the following syntax in a
map entry element:

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

In the following example, the result for the
null-aware element `?a` is not added to a list called
`items` because `a` is `null`:

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

The following example illustrates various ways that
you can use null-aware elements inside of
map entry elements:

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

### Spread elements {: #spread-element }

The spread element iterates over a given sequence and
inserts all of the resulting values into the surrounding
collection.

A spread element has the following syntax in a collection.
The sequence expression can represent any expression that
evaluates to an object that implements `Iterable`:

```dart
...<sequence_expression>
```

In the following example, the elements in a list called `a`
are added to a list called `items`.

<?code-excerpt "misc/test/language_tour/collections/spread_operator_in_collection_a.dart (code_sample)"?>
```dart
var a = [1, 2, null, 4];
var items = [0, ...a, 5]; // [0, 1, 2, null, 4, 5]
```

If you are spreading an expression that might evaluate to
`null` and you want to ignore the `null` (and insert no
elements), use a [null-aware spread element][].

To learn more about the spread operator, see
[Spread operator][].

[Spread operator]: /language/operators/#spread-operators
[null-aware spread element]: #null-spread-element

### Null-aware spread elements {: #null-spread-element }

The null-aware spread element is similar to the
spread element, but allows the collection to be `null` and
inserts nothing if it is.

A null-aware spread element has this syntax in a
collection:

```dart
...?<sequence_expression>
```

In the following example, a list called `a` is ignored
because it's null, but the elements in a list called `b`
are added to a list called `items`. Notice that if a
collection itself is not `null`, but it contains elements that
are, those `null` elements are still added to the result.

```dart
List<int>? a = null;
var b = [1, null, 3];
var items = [0, ...?a, ...?b, 4]; // [0, 1, null, 3, 4]
```

Because of null safety, you can't perform a
spread operation (`...`) on a value that might be null. The
following example produces a compile-time error because the 
`extraOptions` parameter is nullable and the
spread operator used on `extraOptions` is not null-aware.

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

If you want to spread a nullable collection, use a
null-aware spread element. The following example is valid
because the null-aware spread operator is used on `extraOptions`.

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

To learn more about the null-aware spread operator, see
[Spread operator][].

[Spread operator]: /language/operators/#spread-operators

### If elements {: #if-element }

An `if` element conditionally evaluates an inner element
based on given a condition expression, and optionally
evaluates another `else` element if the condition is false.

The `if` element has a few syntax variations:

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

The following examples illustrate various ways that
you can use an `if` element inside of a collection with
a boolean expression:

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

The following examples illustrate various ways that
you can use an `if` element with a `case` part inside of a
collection:

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

You can mix different `if` operations with an `else if`
part. For example:

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

To learn more about the `if` conditional, see
[`if` statement][]. To learn more about the `if-case`
conditional, see [`if-case` statement][].

[`if` statement]: /language/branches#if
[`if-case` statement]: /language/branches#if-case

### For elements {: #for-element }

A `for` element iterates and repeatedly evaluates a given
inner element, inserting zero or more resulting values.

A `for` element has this syntax in a collection:

```dart
for (<expression> in <collection>) <result>
```

```dart
for (<initialization_clause>; <condition_clause>; <increment_clause>) <result>
```

The following examples illustrate various ways that
you can use a `for` element inside of a collection:

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

To learn more about the `for` loop, see
[`for` loops][].

[`for` loops]: /language/loops/#for-loops

### Nest control flow elements {: #nesting-elements }

You can nest control flow elements within each other. This
is a powerful alternative to list comprehensions in other
languages.

In the following example, only the even numbers in
`numbers` are included in `items`.

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

It's common and idiomatic to use a spread on a collection
literal immediately inside of an `if` or `for` element. For
example:

<?code-excerpt "misc/test/language_tour/collections/nesting_in_collection_c.dart (code_sample)"?>
```dart
var items = [
  if (condition) oneThing(),
  if (condition) ...[multiple(), things()],
]; // [oneThing, [multiple_a, multiple_b], things]
```

You can nest all kinds of elements arbitrarily deep.
In the following example, `if`, `for` and spread elements
are nested within each other in a collection:

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
