---
ia-translate: true
title: Records
description: Resumo da estrutura de dados record em Dart.
prevpage:
  url: /language/built-in-types
  title: Built-in types
nextpage:
  url: /language/collections
  title: Collections
---

:::version-note
  Records requerem uma [language version][] de pelo menos 3.0.
:::

Records são um tipo agregado anônimo e imutável. Como outros [tipos de coleção][collection types],
eles permitem agrupar múltiplos objetos em um único objeto. Ao contrário de outros tipos de
coleção, records têm tamanho fixo, são heterogêneos e tipados.

Records são valores reais; você pode armazená-los em variáveis,
aninhá-los, passá-los de e para funções,
e armazená-los em estruturas de dados como listas, maps e sets.

## Sintaxe de record {:#record-syntax}

_Expressões record_ são listas delimitadas por vírgula de campos nomeados ou posicionais,
entre parênteses:

<?code-excerpt "language/test/records_test.dart (record-syntax)"?>
```dart
var record = ('first', a: 2, b: true, 'last');
```

_Anotações de tipo record_ são listas delimitadas por vírgula de tipos entre parênteses.
Você pode usar anotações de tipo record para definir tipos de retorno e tipos de parâmetros.
Por exemplo, os seguintes statements `(int, int)` são anotações de tipo record:

<?code-excerpt "language/test/records_test.dart (record-type-annotation)"?>
```dart
(int, int) swap((int, int) record) {
  var (a, b) = record;
  return (b, a);
}
```

Campos em expressões record e anotações de tipo espelham
como [parâmetros e argumentos][parameters and arguments] funcionam em funções.
Campos posicionais vão diretamente dentro dos parênteses:

<?code-excerpt "language/test/records_test.dart (record-type-declaration)"?>
```dart
// Record type annotation in a variable declaration:
(String, int) record;

// Initialize it with a record expression:
record = ('A string', 123);
```

Em uma anotação de tipo record, campos nomeados vão dentro de uma seção delimitada por chaves
de pares tipo-e-nome, após todos os campos posicionais. Em uma expressão
record, os nomes vão antes de cada valor de campo, seguidos de dois-pontos:

<?code-excerpt "language/test/records_test.dart (record-type-named-declaration)"?>
```dart
// Record type annotation in a variable declaration:
({int a, bool b}) record;

// Initialize it with a record expression:
record = (a: 123, b: true);
```

Os nomes de campos nomeados em um tipo record fazem parte da
[definição de tipo do record](#record-types), ou sua _forma_.
Dois records com campos nomeados com
nomes diferentes têm tipos diferentes:

<?code-excerpt "language/test/records_test.dart (record-type-mismatched-names)"?>
```dart
({int a, int b}) recordAB = (a: 1, b: 2);
({int x, int y}) recordXY = (x: 3, y: 4);

// Compile error! These records don't have the same type.
// recordAB = recordXY;
```

Em uma anotação de tipo record, você também pode nomear os campos *posicionais*, mas
esses nomes servem apenas para documentação e não
afetam o tipo do record:

<?code-excerpt "language/test/records_test.dart (record-type-matched-names)"?>
```dart
(int a, int b) recordAB = (1, 2);
(int x, int y) recordXY = (3, 4);

recordAB = recordXY; // OK.
```

Isso é similar a como parâmetros posicionais
em uma [declaração de função ou typedef de função][function-type]
podem ter nomes, mas esses nomes não afetam a assinatura da função.

Para mais informações e exemplos, confira
[Tipos de record](#record-types) e [Igualdade de record](#record-equality).

## Campos de record {:#record-fields}

Campos de record são acessíveis através de getters integrados. Records são imutáveis,
então os campos não têm setters.

Campos nomeados expõem getters com o mesmo nome. Campos posicionais expõem getters
com o nome `$<posição>`, pulando campos nomeados:

<?code-excerpt "language/test/records_test.dart (record-getters)"?>
```dart
var record = ('first', a: 2, b: true, 'last');

print(record.$1); // Prints 'first'
print(record.a); // Prints 2
print(record.b); // Prints true
print(record.$2); // Prints 'last'
```

Para simplificar ainda mais o acesso aos campos de record,
confira a página sobre [Patterns][pattern].

## Tipos de record {:#record-types}

Não há declaração de tipo para tipos de record individuais.
Records são tipados estruturalmente com base nos tipos de seus campos.
A _forma_ de um record (o conjunto de seus campos, os tipos dos campos
e seus nomes, se houver) determina exclusivamente o tipo do record.

Cada campo em um record tem seu próprio tipo. Os tipos de campo podem diferir dentro do mesmo
record. O sistema de tipos conhece o tipo de cada campo sempre que ele é acessado
a partir do record:

<?code-excerpt "language/test/records_test.dart (record-getters-two)"?>
```dart
(num, Object) pair = (42, 'a');

var first = pair.$1; // Static type `num`, runtime type `int`.
var second = pair.$2; // Static type `Object`, runtime type `String`.
```

Considere duas bibliotecas não relacionadas que criam records com o mesmo conjunto de campos.
O sistema de tipos entende que esses records são do mesmo tipo, mesmo que as
bibliotecas não estejam acopladas uma à outra.

:::tip
Embora você não possa declarar um tipo único para uma forma de record,
você pode criar aliases de tipo para legibilidade e reutilização.
Para aprender como e quando fazer isso,
confira [Records e typedefs](#records-and-typedefs).
:::

## Igualdade de record {:#record-equality}

Dois records são iguais se tiverem a mesma _forma_ (conjunto de campos),
e seus campos correspondentes tiverem os mesmos valores.
Como a _ordem_ dos campos nomeados não faz parte da forma de um record, ela
não afeta a igualdade.

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

Records definem automaticamente os métodos `hashCode` e `==` com base na estrutura
de seus campos.

## Múltiplos retornos {:#multiple-returns}

Records permitem que funções retornem múltiplos valores agrupados.
Para recuperar os valores de um record retornado,
[desestruture][destructure] os valores em variáveis locais usando [pattern matching][pattern].

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
com a sintaxe de dois-pontos `:`, sobre a qual você pode ler mais na
página de [Pattern types][Pattern types]:

<?code-excerpt "language/test/records_test.dart (record-name-destructure)"?>
```dart
({String name, int age}) userInfo(Map<String, dynamic> json)
// ···
// Destructures using a record pattern with named fields:
final (:name, :age) = userInfo(json);
```

Você pode retornar múltiplos valores de uma função sem records,
mas outros métodos têm desvantagens.
Por exemplo, criar uma classe é muito mais verboso, e usar outros tipos de
coleção como `List` ou `Map` perde segurança de tipo.

:::note
A característica de múltiplos retornos e de tipos heterogêneos dos records permite
paralelizar futures de tipos diferentes, sobre o que você pode ler na
[documentação de `dart:async`][`dart:async` documentation].
:::

## Records como estruturas de dados simples {:#records-as-simple-data-structures}

Records apenas armazenam dados. Quando isso é tudo que você precisa,
eles estão imediatamente disponíveis e são fáceis de usar
sem precisar declarar novas classes.
Para uma lista simples de tuplas de dados que têm todas a mesma forma,
uma *lista de records* é a representação mais direta.

Considere esta lista de "definições de botões", por exemplo:

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

Esse código pode ser escrito diretamente, sem nenhuma declaração adicional.

### Records e typedefs {:#records-and-typedefs}

Você pode optar por usar [typedefs][] para dar um nome ao próprio tipo record,
e usar esse nome em vez de escrever o tipo record completo.
Esse método permite declarar que alguns campos podem ser null (`?`),
mesmo que nenhuma das entradas atuais da lista tenha valor null.

```dart
typedef ButtonItem = ({String label, Icon icon, void Function()? onPressed});
final List<ButtonItem> buttons = [
  // ...
];
```

Como tipos record são tipos estruturais, dar um nome como `ButtonItem`
apenas introduz um alias que facilita referir-se ao tipo estrutural:
`({String label, Icon icon, void Function()? onPressed})`.

Fazer com que todo o seu código se refira a um tipo record pelo seu alias facilita
mudar depois a implementação do record sem precisar atualizar cada referência.

O código pode trabalhar com as definições de botões fornecidas da mesma forma que faria
com instâncias de classe simples:

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

Você pode até decidir mais tarde mudar o tipo record para um tipo de classe, para adicionar métodos:

```dart
class ButtonItem {
  final String label;
  final Icon icon;
  final void Function()? onPressed;
  ButtonItem({required this.label, required this.icon, this.onPressed});
  bool get hasOnPressed => onPressed != null;
}
```

Ou para um [tipo de extensão][extension type]:

```dart
extension type ButtonItem._(({String label, Icon icon, void Function()? onPressed}) _) {
  String get label => _.label;
  Icon get icon => _.icon;
  void Function()? get onPressed => _.onPressed;
  ButtonItem({required String label, required Icon icon, void Function()? onPressed})
      : this._((label: label, icon: icon, onPressed: onPressed));
  bool get hasOnPressed => _.onPressed != null;
}
```

E então criar a lista de definições de botões usando os construtores desse tipo:

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

Novamente, tudo isso sem precisar mudar o código que usa essa lista.

Mudar qualquer tipo exige que o código que o utiliza tenha muito cuidado para
não fazer suposições. Um alias de tipo não oferece nenhuma proteção ou garantia,
para o código que o usa como referência, de que o valor aliasado é um record.
Tipos de extensão também oferecem pouca proteção.
Somente uma classe pode fornecer abstração e encapsulamento completos.

[language version]: /language/versioning
[collection types]: /language/collections
[pattern]: /language/patterns#destructuring-multiple-returns
[`dart:async` documentation]: /libraries/dart-async#handling-errors-for-multiple-futures
[parameters and arguments]: /language/functions#parameters
[function-type]: /language/functions#function-types
[destructure]: /language/patterns#destructuring
[Pattern types]: /language/pattern-types#record
[typedefs]: /language/typedefs
[extension type]: /language/extension-types
