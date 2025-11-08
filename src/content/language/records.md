---
ia-translate: true
title: Records
description: Resumo da estrutura de dados record em Dart.
prevpage:
  url: /language/built-in-types
  title: Tipos built-in (embutidos)
nextpage:
  url: /language/collections
  title: "Collections (Coleções)"
---

:::version-note
  Records exigem uma [versão da linguagem][language version] de no mínimo 3.0.
:::

Records (registros) são um tipo agregado, anônimo e imutável. Assim como outros [tipos de coleção][collection types],
eles permitem que você agrupe múltiplos objetos em um único objeto. Diferente de outros tipos de coleção,
records têm tamanho fixo, são heterogêneos e tipados.

Records são valores reais; você pode armazená-los em variáveis,
aninhá-los, passá-los para e de funções,
e armazená-los em estruturas de dados como listas, maps e sets.

## Sintaxe de Record {:#record-syntax}

_Expressões de records_ são listas delimitadas por vírgulas de campos nomeados ou posicionais,
envolvidas em parênteses:

<?code-excerpt "language/test/records_test.dart (record-syntax)"?>
```dart
var record = ('first', a: 2, b: true, 'last');
```

_Anotações de tipo de record_ são listas de tipos delimitadas por vírgulas, envolvidas em parênteses.
Você pode usar anotações de tipo de record para definir tipos de retorno e tipos de parâmetros.
Por exemplo, as seguintes declarações `(int, int)` são anotações de tipo de record:

<?code-excerpt "language/test/records_test.dart (record-type-annotation)"?>
```dart
(int, int) swap((int, int) record) {
  var (a, b) = record;
  return (b, a);
}
```

Campos em expressões de record e anotações de tipo espelham
como [parâmetros e argumentos][parameters and arguments] funcionam em funções.
Campos posicionais vão diretamente dentro dos parênteses:

<?code-excerpt "language/test/records_test.dart (record-type-declaration)"?>
```dart
// Record type annotation in a variable declaration:
(String, int) record;

// Initialize it with a record expression:
record = ('A string', 123);
```

Em uma anotação de tipo de record, campos nomeados vão dentro de uma seção delimitada por chaves
de pares tipo-e-nome, depois de todos os campos posicionais. Em uma expressão de record,
os nomes vão antes de cada valor de campo com dois pontos após:

<?code-excerpt "language/test/records_test.dart (record-type-named-declaration)"?>
```dart
// Record type annotation in a variable declaration:
({int a, bool b}) record;

// Initialize it with a record expression:
record = (a: 123, b: true);
```

Os nomes de campos nomeados em um tipo de record fazem parte da
[definição de tipo do record](#record-types), ou seu _formato_.
Dois records com campos nomeados com
nomes diferentes têm tipos diferentes:

<?code-excerpt "language/test/records_test.dart (record-type-mismatched-names)"?>
```dart
({int a, int b}) recordAB = (a: 1, b: 2);
({int x, int y}) recordXY = (x: 3, y: 4);

// Compile error! These records don't have the same type.
// recordAB = recordXY;
```

Em uma anotação de tipo de record, você também pode nomear os campos *posicionais*, mas
esses nomes são puramente para documentação e não afetam o tipo do record:

<?code-excerpt "language/test/records_test.dart (record-type-matched-names)"?>
```dart
(int a, int b) recordAB = (1, 2);
(int x, int y) recordXY = (3, 4);

recordAB = recordXY; // OK.
```

This is similar to how positional parameters
in a [function declaration or function typedef][function-type]
can have names but those names don't affect the signature of the function.

Para mais informações e exemplos, confira
[Tipos de record](#record-types) e [Igualdade de record](#record-equality).

## Campos de Record {:#record-fields}

Campos de record são acessíveis através de getters (métodos de acesso) built-in (embutidos). Records são imutáveis,
então campos não possuem setters (métodos de atribuição).

Campos nomeados expõem getters de mesmo nome. Campos posicionais expõem getters
de nome `$<posição>`, pulando campos nomeados:

<?code-excerpt "language/test/records_test.dart (record-getters)"?>
```dart
var record = ('first', a: 2, b: true, 'last');

print(record.$1); // Prints 'first'
print(record.a); // Prints 2
print(record.b); // Prints true
print(record.$2); // Prints 'last'
```

Para otimizar ainda mais o acesso a campos de record,
confira a página sobre [Patterns (Padrões)][pattern].

## Tipos de Record {:#record-types}

There is no type declaration for individual record types.
Records are structurally typed based on the types of their fields.
A record's _shape_ (the set of its fields, the fields' types,
and their names, if any) uniquely determines the type of a record.

Cada campo em um record tem seu próprio tipo. Tipos de campos podem diferir dentro do mesmo
record. O sistema de tipos está ciente do tipo de cada campo onde quer que ele seja acessado
do record:

<?code-excerpt "language/test/records_test.dart (record-getters-two)"?>
```dart
(num, Object) pair = (42, 'a');

var first = pair.$1; // Static type `num`, runtime type `int`.
var second = pair.$2; // Static type `Object`, runtime type `String`.
```

Considere duas bibliotecas não relacionadas que criam records com o mesmo conjunto de campos.
O sistema de tipos entende que esses records são do mesmo tipo, mesmo que as
bibliotecas não estejam acopladas entre si.

:::tip
While you can't declare a unique type for a record shape,
you can create type aliases for readability and reuse.
To learn how and when to do so,
check out [Records and typedefs](#records-and-typedefs).
:::

## Record equality

Dois records são iguais se eles têm o mesmo _formato_ (conjunto de campos)
e seus campos correspondentes têm os mesmos valores.
Como a _ordem_ dos campos nomeados não faz parte do formato de um record, a ordem dos
campos nomeados não afeta a igualdade.

Por exemplo:

<?code-excerpt "language/test/records_test.dart (record-shape)"?>
```dart
(int x, int y, int z) point = (1, 2, 3);
(int r, int g, int b) color = (1, 2, 3);

print(point == color); // Prints 'true'.
```

<?code-excerpt "language/test/records_test.dart (record-shape-mismatch)"?>
```dart
({int x, int y, int z}) point = (x: 1, y: 2, z: 3);
({int r, int g, int b}) color = (r: 1, g: 2, b: 3);

print(point == color); // Prints 'false'. Lint: Equals on unrelated types.
```

Records automaticamente definem os métodos `hashCode` e `==` com base na estrutura
de seus campos.

## Retornos Múltiplos {:#multiple-returns}

Records permitem que funções retornem múltiplos valores agrupados.
Para recuperar valores de record de um retorno,
[desestruture][destructure] os valores em variáveis locais usando [pattern matching (correspondência de padrão)][pattern].

<?code-excerpt "language/test/records_test.dart (record-multiple-returns)"?>
```dart
// Returns multiple values in a record:
(String name, int age) userInfo(Map<String, dynamic> json) {
  return (json['name'] as String, json['age'] as int);
}

final json = <String, dynamic>{'name': 'Dash', 'age': 10, 'color': 'blue'};

// Destructures using a record pattern with positional fields:
var (name, age) = userInfo(json);

/* Equivalent to:
  var info = userInfo(json);
  var name = info.$1;
  var age  = info.$2;
*/
```

Você também pode desestruturar um record usando seus [campos nomeados](#record-fields),
usando a sintaxe de dois pontos `:`, sobre a qual você pode ler mais na página de
[Tipos de Pattern][Pattern types]:

<?code-excerpt "language/test/records_test.dart (record-name-destructure)"?>
```dart
({String name, int age}) userInfo(Map<String, dynamic> json)
// ···
// Destructures using a record pattern with named fields:
final (:name, :age) = userInfo(json);
```

Você pode retornar múltiplos valores de uma função sem records,
mas outros métodos vêm com desvantagens.
Por exemplo, criar uma classe é muito mais verboso, e usar outros tipos de coleção
como `List` ou `Map` perde a segurança de tipo.

:::note
As características de retorno múltiplo e tipo heterogêneo de Records habilitam
a paralelização de futures de tipos diferentes, sobre a qual você pode ler na
documentação de [`dart:async`][`dart:async` documentation].
:::

## Records as simple data structures

Records only hold data. When that's all you need,
they're immediately available and easy to use 
without needing to declare any new classes.
For a simple list of data tuples that all have the same shape,
a *list of records* is the most direct representation.

Take this list of "button definitions", for example:

```dart
final buttons = [
  (
    label: "Button I",
    icon: const Icon(Icons.upload_file),
    onPressed: () => print("Action -> Button I"),
  ),
  (
    label: "Button II",
    icon: const Icon(Icons.info),
    onPressed: () => print("Action -> Button II"),
  )
];
```

This code can be written directly without needing any additional declarations.

### Records and typedefs

You can choose to use [typedefs][] to give the record type itself a name,
and use that rather than writing out the full record type.
This method allows you to state that some fields can be null (`?`),
even if none of the current entries in the list have a null value.

```dart
typedef ButtonItem = ({String label, Icon icon, void Function()? onPressed});
final List<ButtonItem> buttons = [
  // ...
];
```

Because record types are structural types, giving a name like `ButtonItem`
only introduces an alias that makes it easier to refer to the structural type: 
`({String label, Icon icon, void Function()? onPressed})`.

Having all your code refer to a record type by its alias makes it easier to
later change the record's implementation without needing to update every reference.

Code can work with the given button definitions the same way it would
with simple class instances:

```dart
List<Container> widget = [
  for (var button in buttons)
    Container(
      margin: const EdgeInsets.all(4.0),
      child: OutlinedButton.icon(
        onPressed: button.onPressed,
        icon: button.icon,
        label: Text(button.label),
      ),
    ),
];
```

You could even decide to later change the record type to a class type to add methods:

```dart
class ButtonItem {
  final String label;
  final Icon icon;
  final void Function()? onPressed;
  ButtonItem({required this.label, required this.icon, this.onPressed});
  bool get hasOnpressed => onPressed != null;
}
```

Or to an [extension type][]:

```dart
extension type ButtonItem._(({String label, Icon icon, void Function()? onPressed}) _) {
  String get label => _.label;
  Icon get icon => _.icon;
  void Function()? get onPressed => _.onPressed;
  ButtonItem({required String label, required Icon icon, void Function()? onPressed})
      : this._((label: label, icon: icon, onPressed: onPressed));
  bool get hasOnpressed => _.onPressed != null;
}
```

And then create the list of button definitions using that type's constructors:

```dart
final List<ButtonItem> buttons =  [
  ButtonItem(
    label: "Button I",
    icon: const Icon(Icons.upload_file),
    onPressed: () => print("Action -> Button I"),
  ),
  ButtonItem(
    label: "Button II",
    icon: const Icon(Icons.info),
    onPressed: () => print("Action -> Button II"),
  )
];
```

Again, all while not needing to change the code that uses that list.

Changing any type does require the code using it to be very careful about
not making assumptions. A type alias does not offer any protection or guarantee,
for the code using it as a reference, that the value being aliased is a record.
Extension types, also, offer little protection.
Only a class can provide full abstraction and encapsulation.

[language version]: /resources/language/evolution#language-versioning
[collection types]: /language/collections
[pattern]: /language/patterns#destructuring-multiple-returns
[`dart:async` documentation]: /libraries/dart-async#handling-errors-for-multiple-futures
[parameters and arguments]: /language/functions#parameters
[function-type]: /language/functions#function-types
[destructure]: /language/patterns#destructuring
[Pattern types]: /language/pattern-types#record
[typedefs]: /language/typedefs
[extension type]: /language/extension-types