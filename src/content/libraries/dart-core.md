---
ia-translate: true
title: dart:core
description: Saiba mais sobre os principais recursos na biblioteca dart:core do Dart.
prevpage:
  url: /libraries
  title: Bibliotecas principais
nextpage:
  url: /libraries/dart-async
  title: dart:async
---

<?code-excerpt replace="/ *\/\/\s+ignore_for_file:[^\n]+\n//g; /(^|\n) *\/\/\s+ignore:[^\n]+\n/$1/g; /(\n[^\n]+) *\/\/\s+ignore:[^\n]+\n/$1\n/g"?>
<?code-excerpt plaster="none"?>

A biblioteca dart:core ([referência da API][dart:core])
fornece um conjunto pequeno, porém crítico, de funcionalidades integradas.
Esta biblioteca é automaticamente importada em todo programa Dart.


## Imprimindo no console {:#printing-to-the-console}

O método de nível superior `print()` recebe um único argumento (qualquer
Objeto) e exibe o valor da string desse objeto (conforme retornado por
`toString()`) no console.

<?code-excerpt "misc/test/library_tour/core_test.dart (print)"?>
```dart
print(anObject);
print('I drink $tea.');
```

Para obter mais informações sobre strings básicas e `toString()`, consulte
[Strings](/language/built-in-types#strings) no tour da linguagem.


## Números {:#numbers}

A biblioteca dart:core define as classes num, int e double, que possuem
algumas utilidades básicas para trabalhar com números.

Você pode converter uma string em um inteiro ou double com os métodos
`parse()` de int e double, respectivamente:

<?code-excerpt "misc/test/library_tour/core_test.dart (int-double-parse)"?>
```dart
assert(int.parse('42') == 42);
assert(int.parse('0x42') == 66);
assert(double.parse('0.50') == 0.5);
```

Ou use o método parse() de num, que cria um inteiro, se possível, e,
caso contrário, um double:

<?code-excerpt "misc/test/library_tour/core_test.dart (num-parse)"?>
```dart
assert(num.parse('42') is int);
assert(num.parse('0x42') is int);
assert(num.parse('0.50') is double);
```

Para especificar a base de um inteiro, adicione um parâmetro `radix`:

<?code-excerpt "misc/test/library_tour/core_test.dart (radix)"?>
```dart
assert(int.parse('42', radix: 16) == 66);
```

Use o método `toString()` para converter um int ou double em uma string.
Para especificar o número de dígitos à direita da decimal, use
[toStringAsFixed().][toStringAsFixed()] Para especificar o número de
dígitos significativos na string, use
[toStringAsPrecision():][toStringAsPrecision()]

<?code-excerpt "misc/test/library_tour/core_test.dart (to-string)"?>
```dart
// Convert an int to a string.
assert(42.toString() == '42');

// Convert a double to a string.
assert(123.456.toString() == '123.456');

// Specify the number of digits after the decimal.
assert(123.456.toStringAsFixed(2) == '123.46');

// Specify the number of significant figures.
assert(123.456.toStringAsPrecision(2) == '1.2e+2');
assert(double.parse('1.2e+2') == 120.0);
```

Para mais informações, veja a documentação da API para
[int,][int] [double,][double] e [num.][num] Veja também a seção
[dart:math](/libraries/dart-math).

## Strings e expressões regulares {:#strings-and-regular-expressions}

Uma string em Dart é uma sequência imutável de unidades de código UTF-16.
O tour da linguagem tem mais informações sobre
[strings](/language/built-in-types#strings).
Você pode usar expressões regulares
(objetos RegExp) para pesquisar em strings e para substituir
partes de strings.

A classe String define métodos como `split()`, `contains()`,
`startsWith()`, `endsWith()` e outros.

### Pesquisando dentro de uma string {:#searching-inside-a-string}

Você pode encontrar locais específicos dentro de uma string, bem como
verificar se uma string começa ou termina com um padrão específico. Por
exemplo:

<?code-excerpt "misc/test/library_tour/core_test.dart (contains-etc)"?>
```dart
// Check whether a string contains another string.
assert('Never odd or even'.contains('odd'));

// Does a string start with another string?
assert('Never odd or even'.startsWith('Never'));

// Does a string end with another string?
assert('Never odd or even'.endsWith('even'));

// Find the location of a string inside a string.
assert('Never odd or even'.indexOf('odd') == 6);
```

### Extraindo dados de uma string {:#extracting-data-from-a-string}

Você pode obter os caracteres individuais de uma string como Strings ou
ints, respectivamente. Para ser preciso, você realmente obtém unidades
de código UTF-16 individuais; caracteres de alta numeração, como o
símbolo da clave de sol ('\\u{1D11E}'), são duas unidades de código cada.

Você também pode extrair uma substring ou dividir uma string em uma lista
de substrings:

<?code-excerpt "misc/test/library_tour/core_test.dart (substring-etc)"?>
```dart
// Grab a substring.
assert('Never odd or even'.substring(6, 9) == 'odd');

// Split a string using a string pattern.
var parts = 'progressive web apps'.split(' ');
assert(parts.length == 3);
assert(parts[0] == 'progressive');

// Get a UTF-16 code unit (as a string) by index.
assert('Never odd or even'[0] == 'N');

// Use split() with an empty string parameter to get
// a list of all characters (as Strings); good for
// iterating.
for (final char in 'hello'.split('')) {
  print(char);
}

// Get all the UTF-16 code units in the string.
var codeUnitList = 'Never odd or even'.codeUnits.toList();
assert(codeUnitList[0] == 78);
```

:::
Em muitos casos, você deseja trabalhar com
*clusters de grafemas* Unicode,
em vez de unidades de código puras.
Esses são caracteres como são percebidos
pelo usuário (por exemplo, "🇬🇧" é um
caractere percebido pelo usuário, mas várias
unidades de código UTF-16).
Para isso, a equipe do Dart fornece o
pacote [`characters`.]({{site.pub-pkg}}/characters)
:::

### Convertendo para maiúsculas ou minúsculas {:#converting-to-uppercase-or-lowercase}

Você pode facilmente converter strings para suas variantes em maiúsculas e
minúsculas:

<?code-excerpt "misc/test/library_tour/core_test.dart (case-conversions)"?>
```dart
// Convert to uppercase.
assert('web apps'.toUpperCase() == 'WEB APPS');

// Convert to lowercase.
assert('WEB APPS'.toLowerCase() == 'web apps');
```

:::note
Esses métodos não funcionam para todos os idiomas. Por exemplo, o *I* sem
ponto do alfabeto turco é convertido incorretamente.
:::


### Removendo espaços em branco e strings vazias {:#trimming-and-empty-strings}

Remova todos os espaços em branco à esquerda e à direita com `trim()`.
Para verificar se uma string está vazia (o comprimento é zero), use
`isEmpty`.

<?code-excerpt "misc/test/library_tour/core_test.dart (trim-etc)"?>
```dart
// Trim a string.
assert('  hello  '.trim() == 'hello');

// Check whether a string is empty.
assert(''.isEmpty);

// Strings with only white space are not empty.
assert('  '.isNotEmpty);
```

### Substituindo parte de uma string {:#replacing-part-of-a-string}

Strings são objetos imutáveis, o que significa que você pode criá-los,
mas não pode alterá-los. Se você observar atentamente a [referência da API String,][String]
perceberá que nenhum dos métodos realmente altera o estado de uma String.
Por exemplo, o método `replaceAll()` retorna uma nova String sem alterar
a String original:

<?code-excerpt "misc/test/library_tour/core_test.dart (replace)"?>
```dart
var greetingTemplate = 'Hello, NAME!';
var greeting = greetingTemplate.replaceAll(RegExp('NAME'), 'Bob');

// greetingTemplate didn't change.
assert(greeting != greetingTemplate);
```

### Construindo uma string {:#building-a-string}

Para gerar uma string programaticamente, você pode usar StringBuffer.
Um StringBuffer não gera um novo objeto String até que `toString()` seja
chamado. O método `writeAll()` possui um segundo parâmetro opcional que
permite especificar um separador — neste caso, um espaço.

<?code-excerpt "misc/test/library_tour/core_test.dart (string-buffer)"?>
```dart
var sb = StringBuffer();
sb
  ..write('Use a StringBuffer for ')
  ..writeAll(['efficient', 'string', 'creation'], ' ')
  ..write('.');

var fullString = sb.toString();

assert(fullString == 'Use a StringBuffer for efficient string creation.');
```

### Expressões regulares {:#regular-expressions}

A classe RegExp fornece os mesmos recursos que as expressões regulares
JavaScript. Use expressões regulares para pesquisa eficiente e
correspondência de padrões de strings.

<?code-excerpt "misc/test/library_tour/core_test.dart (regexp)"?>
```dart
// Here's a regular expression for one or more digits.
var digitSequence = RegExp(r'\d+');

var lettersOnly = 'llamas live fifteen to twenty years';
var someDigits = 'llamas live 15 to 20 years';

// contains() can use a regular expression.
assert(!lettersOnly.contains(digitSequence));
assert(someDigits.contains(digitSequence));

// Replace every match with another string.
var exedOut = someDigits.replaceAll(digitSequence, 'XX');
assert(exedOut == 'llamas live XX to XX years');
```

Você também pode trabalhar diretamente com a classe RegExp. A classe
Match fornece acesso a uma correspondência de expressão regular.

<?code-excerpt "misc/test/library_tour/core_test.dart (match)"?>
```dart
var digitSequence = RegExp(r'\d+');
var someDigits = 'llamas live 15 to 20 years';

// Check whether the reg exp has a match in a string.
assert(digitSequence.hasMatch(someDigits));

// Loop through all matches.
for (final match in digitSequence.allMatches(someDigits)) {
  print(match.group(0)); // 15, then 20
}
```

### Mais informações {:#more-information}

Consulte a [referência da API String][String] para obter uma lista
completa de métodos. Veja também a referência da API para [StringBuffer,][StringBuffer]
[Pattern,][Pattern] [RegExp,][RegExp] e [Match.][Match]

## Coleções {:#collections}

O Dart é fornecido com uma API de coleções principal, que inclui classes
para listas, conjuntos e maps.

:::tip
Para praticar o uso de APIs que estão disponíveis para listas e
conjuntos, siga o [tutorial de coleções Iterable](/libraries/collections/iterables).
:::

### Listas {:#lists}

Como mostra o tour da linguagem, você pode usar literais para criar e
inicializar [listas](/language/collections#lists). Alternativamente, use um dos
construtores de List. A classe List também define vários métodos para
adicionar e remover itens de listas.

<?code-excerpt "misc/test/library_tour/core_test.dart (list)"?>
```dart
// Create an empty list of strings.
var grains = <String>[];
assert(grains.isEmpty);

// Create a list using a list literal.
var fruits = ['apples', 'oranges'];

// Add to a list.
fruits.add('kiwis');

// Add multiple items to a list.
fruits.addAll(['grapes', 'bananas']);

// Get the list length.
assert(fruits.length == 5);

// Remove a single item.
var appleIndex = fruits.indexOf('apples');
fruits.removeAt(appleIndex);
assert(fruits.length == 4);

// Remove all elements from a list.
fruits.clear();
assert(fruits.isEmpty);

// You can also create a List using one of the constructors.
var vegetables = List.filled(99, 'broccoli');
assert(vegetables.every((v) => v == 'broccoli'));
```

Use `indexOf()` para encontrar o índice de um objeto em uma lista:

<?code-excerpt "misc/test/library_tour/core_test.dart (index-of)"?>
```dart
var fruits = ['apples', 'oranges'];

// Access a list item by index.
assert(fruits[0] == 'apples');

// Find an item in a list.
assert(fruits.indexOf('apples') == 0);
```

Classifica uma lista usando o método `sort()`. Você pode fornecer uma
função de classificação que compare dois objetos. Essa função de
classificação deve retornar < 0 para *menor*, 0 para *igual* e > 0 para
*maior*. O exemplo a seguir usa `compareTo()`, que é definido por
[Comparable][Comparable] e implementado por String.

<?code-excerpt "misc/test/library_tour/core_test.dart (compare-to)"?>
```dart
var fruits = ['bananas', 'apples', 'oranges'];

// Sort a list.
fruits.sort((a, b) => a.compareTo(b));
assert(fruits[0] == 'apples');
```

Listas são tipos parametrizados
([genéricos](/language/generics)),
para que você possa especificar o tipo que uma lista
deve conter:

<?code-excerpt "misc/test/library_tour/core_test.dart (list-of-string)"?>
```dart
// This list should contain only strings.
var fruits = <String>[];

fruits.add('apples');
var fruit = fruits[0];
assert(fruit is String);
```

<?code-excerpt "misc/lib/library_tour/core/collections.dart (list-of-string)"?>
```dart tag=fails-sa
fruits.add(5); // Error: 'int' can't be assigned to 'String'
```

:::note
Em muitos casos, você não precisa
especificar explicitamente tipos genéricos,
porque o Dart os
[inferirá](/language/type-system#type-inference)
para você.
Uma lista como `['Dash', 'Dart']` é entendida
como sendo uma `List<String>` (lê-se: lista de strings).

Mas há momentos em que você _deve_ especificar
o tipo genérico. Como, por exemplo, quando o Dart não tem
nada para inferir: `[]` pode ser uma lista de qualquer
combinação de coisas.
Isso geralmente não é o que você deseja, então você escreve `<String>[]`
ou `<Person>[]` ou algo semelhante.
:::

Consulte a [referência da API List][List] para obter uma lista completa de métodos.

### Conjuntos {:#sets}

Um conjunto em Dart é uma coleção não ordenada de itens exclusivos. Como um
conjunto não é ordenado, você não pode obter os itens de um conjunto por índice (posição).

<?code-excerpt "misc/test/library_tour/core_test.dart (set)"?>
```dart
// Create an empty set of strings.
var ingredients = <String>{};

// Add new items to it.
ingredients.addAll(['gold', 'titanium', 'xenon']);
assert(ingredients.length == 3);

// Adding a duplicate item has no effect.
ingredients.add('gold');
assert(ingredients.length == 3);

// Remove an item from a set.
ingredients.remove('gold');
assert(ingredients.length == 2);

// You can also create sets using
// one of the constructors.
var atomicNumbers = Set.from([79, 22, 54]);
```

Use `contains()` e `containsAll()` para verificar se um ou mais objetos
estão em um conjunto:

<?code-excerpt "misc/test/library_tour/core_test.dart (contains)"?>
```dart
var ingredients = Set<String>();
ingredients.addAll(['gold', 'titanium', 'xenon']);

// Check whether an item is in the set.
assert(ingredients.contains('titanium'));

// Check whether all the items are in the set.
assert(ingredients.containsAll(['titanium', 'xenon']));
```

Uma interseção é um conjunto cujos itens estão em outros dois conjuntos.

<?code-excerpt "misc/test/library_tour/core_test.dart (intersection)"?>
```dart
var ingredients = Set<String>();
ingredients.addAll(['gold', 'titanium', 'xenon']);

// Create the intersection of two sets.
var nobleGases = Set.from(['xenon', 'argon']);
var intersection = ingredients.intersection(nobleGases);
assert(intersection.length == 1);
assert(intersection.contains('xenon'));
```

Consulte a [referência da API Set][Set] para obter uma lista completa de métodos.

### Maps {:#maps}

Um map (mapa), comumente conhecido como *dicionário* ou *hash*, é uma coleção
não ordenada de pares chave-valor. Maps associam uma chave a algum valor para
fácil recuperação. Ao contrário do JavaScript, os objetos Dart não são maps.

Você pode declarar um map usando uma sintaxe literal concisa, ou pode
usar um construtor tradicional:

<?code-excerpt "misc/test/library_tour/core_test.dart (map)"?>
```dart
// Maps often use strings as keys.
var hawaiianBeaches = {
  'Oahu': ['Waikiki', 'Kailua', 'Waimanalo'],
  'Big Island': ['Wailea Bay', 'Pololu Beach'],
  'Kauai': ['Hanalei', 'Poipu'],
};

// Maps can be built from a constructor.
var searchTerms = Map();

// Maps are parameterized types; you can specify what
// types the key and value should be.
var nobleGases = Map<int, String>();
```

Você adiciona, obtém e define itens de map usando a sintaxe de colchetes.
Use `remove()` para remover uma chave e seu valor de um map.

<?code-excerpt "misc/test/library_tour/core_test.dart (remove)"?>
```dart
var nobleGases = {54: 'xenon'};

// Retrieve a value with a key.
assert(nobleGases[54] == 'xenon');

// Check whether a map contains a key.
assert(nobleGases.containsKey(54));

// Remove a key and its value.
nobleGases.remove(54);
assert(!nobleGases.containsKey(54));
```

Você pode recuperar todos os valores ou todas as chaves de um map:

<?code-excerpt "misc/test/library_tour/core_test.dart (keys)"?>
```dart
var hawaiianBeaches = {
  'Oahu': ['Waikiki', 'Kailua', 'Waimanalo'],
  'Big Island': ['Wailea Bay', 'Pololu Beach'],
  'Kauai': ['Hanalei', 'Poipu'],
};

// Get all the keys as an unordered collection
// (an Iterable).
var keys = hawaiianBeaches.keys;

assert(keys.length == 3);
assert(Set.from(keys).contains('Oahu'));

// Get all the values as an unordered collection
// (an Iterable of Lists).
var values = hawaiianBeaches.values;
assert(values.length == 3);
assert(values.any((v) => v.contains('Waikiki')));
```

Para verificar se um map contém uma chave, use `containsKey()`. Como os
valores do map podem ser nulos, você não pode confiar simplesmente em
obter o valor da chave e verificar se há nulo para determinar a existência de uma chave.

<?code-excerpt "misc/test/library_tour/core_test.dart (contains-key)"?>
```dart
var hawaiianBeaches = {
  'Oahu': ['Waikiki', 'Kailua', 'Waimanalo'],
  'Big Island': ['Wailea Bay', 'Pololu Beach'],
  'Kauai': ['Hanalei', 'Poipu'],
};

assert(hawaiianBeaches.containsKey('Oahu'));
assert(!hawaiianBeaches.containsKey('Florida'));
```

Use o método `putIfAbsent()` quando desejar atribuir um valor a uma chave
se e somente se a chave ainda não existir em um map. Você deve fornecer
uma função que retorne o valor.

<?code-excerpt "misc/test/library_tour/core_test.dart (put-if-absent)"?>
```dart
var teamAssignments = <String, String>{};
teamAssignments.putIfAbsent('Catcher', () => pickToughestKid());
assert(teamAssignments['Catcher'] != null);
```

Consulte a [referência da API Map][Map] para obter uma lista completa de métodos.

### Métodos comuns de coleção {:#common-collection-methods}

List, Set e Map compartilham funcionalidades comuns encontradas em muitas
coleções. Parte dessa funcionalidade comum é definida pela classe
Iterable, que List e Set implementam.

:::note
Embora Map não implemente Iterable, você pode obter Iterables dele usando
as propriedades `keys` e `values` do Map.
:::

Use `isEmpty` ou `isNotEmpty` para verificar se uma lista, conjunto ou map possui itens:

<?code-excerpt "misc/test/library_tour/core_test.dart (is-empty)"?>
```dart
var coffees = <String>[];
var teas = ['green', 'black', 'chamomile', 'earl grey'];
assert(coffees.isEmpty);
assert(teas.isNotEmpty);
```

Para aplicar uma função a cada item em uma lista, conjunto ou map, você
pode usar `forEach()`:

<?code-excerpt "misc/test/library_tour/core_test.dart (list-for-each)"?>
```dart
var teas = ['green', 'black', 'chamomile', 'earl grey'];

teas.forEach((tea) => print('I drink $tea'));
```

Quando você invoca `forEach()` em um map, sua função deve receber dois
argumentos (a chave e o valor):

<?code-excerpt "misc/test/library_tour/core_test.dart (map-for-each)"?>
```dart
hawaiianBeaches.forEach((k, v) {
  print('I want to visit $k and swim at $v');
  // I want to visit Oahu and swim at
  // [Waikiki, Kailua, Waimanalo], etc.
});
```

Iterables fornece o método `map()`, que fornece todos os resultados em um
único objeto:

<?code-excerpt "misc/test/library_tour/core_test.dart (list-map)"?>
```dart
var teas = ['green', 'black', 'chamomile', 'earl grey'];

var loudTeas = teas.map((tea) => tea.toUpperCase());
loudTeas.forEach(print);
```

:::note
O objeto retornado por `map()` é um Iterable que é *avaliado
preguiçosamente*: sua função não é chamada até que você solicite um item do objeto retornado.
:::

Para forçar sua função a ser chamada imediatamente em cada item, use
`map().toList()` ou `map().toSet()`:

<?code-excerpt "misc/test/library_tour/core_test.dart (to-list)"?>
```dart
var loudTeas = teas.map((tea) => tea.toUpperCase()).toList();
```

Use o método `where()` do Iterable para obter todos os itens que
correspondem a uma condição. Use os métodos `any()` e `every()` do
Iterable para verificar se alguns ou todos os itens correspondem a uma condição.
{% comment %}
PENDING: Change example as suggested by floitsch to have (maybe)
cities instead of isDecaffeinated.
{% endcomment %}


<?code-excerpt "misc/test/library_tour/core_test.dart (where-etc)"?>
```dart
var teas = ['green', 'black', 'chamomile', 'earl grey'];

// Chamomile is not caffeinated.
bool isDecaffeinated(String teaName) => teaName == 'chamomile';

// Use where() to find only the items that return true
// from the provided function.
var decaffeinatedTeas = teas.where((tea) => isDecaffeinated(tea));
// or teas.where(isDecaffeinated)

// Use any() to check whether at least one item in the
// collection satisfies a condition.
assert(teas.any(isDecaffeinated));

// Use every() to check whether all the items in a
// collection satisfy a condition.
assert(!teas.every(isDecaffeinated));
```

Para obter uma lista completa de métodos, consulte a [referência da API
Iterable,][Iterable] bem como aquelas para [List,][List] [Set,][Set] e
[Map.][Map]

## URIs {:#uris}

A [classe Uri][Uri] fornece funções para codificar e decodificar strings
para uso em URIs (que você pode conhecer como *URLs*). Essas funções
lidam com caracteres especiais para URIs, como `&` e `=`. A classe Uri
também analisa e expõe os componentes de um URI — host, porta, esquema e
assim por diante.
{% comment %}
{PENDING: show
constructors: Uri.http, Uri.https, Uri.file, per floitsch's suggestion}
{% endcomment %}

### Codificando e decodificando URIs totalmente qualificados {:#encoding-and-decoding-fully-qualified-uris}

Para codificar e decodificar caracteres *exceto* aqueles com significado
especial em um URI (como `/`, `:`, `&`, `#`), use os métodos `encodeFull()`
e `decodeFull()`. Esses métodos são bons para codificar ou decodificar
um URI totalmente qualificado, deixando intactos os caracteres especiais do URI.

<?code-excerpt "misc/test/library_tour/core_test.dart (encode-full)"?>
```dart
var uri = 'https://example.org/api?foo=some message';

var encoded = Uri.encodeFull(uri);
assert(encoded == 'https://example.org/api?foo=some%20message');

var decoded = Uri.decodeFull(encoded);
assert(uri == decoded);
```

Observe como apenas o espaço entre `alguma` e `mensagem` foi codificado.

### Codificando e decodificando componentes de URI {:#encoding-and-decoding-uri-components}

Para codificar e decodificar todos os caracteres de uma string que
possuem significado especial em um URI, incluindo (mas não se limitando a)
`/`, `&` e `:`, use os métodos `encodeComponent()` e `decodeComponent()`.

<?code-excerpt "misc/test/library_tour/core_test.dart (encode-component)"?>
```dart
var uri = 'https://example.org/api?foo=some message';

var encoded = Uri.encodeComponent(uri);
assert(
  encoded == 'https%3A%2F%2Fexample.org%2Fapi%3Ffoo%3Dsome%20message',
);

var decoded = Uri.decodeComponent(encoded);
assert(uri == decoded);
```

Observe como cada caractere especial é codificado. Por exemplo, `/` é
codificado para `%2F`.

### Analisando URIs {:#parsing-uris}

Se você tiver um objeto Uri ou uma string URI, poderá obter suas partes
usando campos Uri como `path`. Para criar um Uri a partir de uma string,
use o método estático `parse()`:

<?code-excerpt "misc/test/library_tour/core_test.dart (uri-parse)"?>
```dart
var uri = Uri.parse('https://example.org:8080/foo/bar#frag');

assert(uri.scheme == 'https');
assert(uri.host == 'example.org');
assert(uri.path == '/foo/bar');
assert(uri.fragment == 'frag');
assert(uri.origin == 'https://example.org:8080');
```

Consulte a [referência da API Uri][Uri] para obter mais componentes de URI que você pode obter.

### Construindo URIs {:#building-uris}

Você pode construir um URI a partir de partes individuais usando o
construtor `Uri()`:

<?code-excerpt "misc/test/library_tour/core_test.dart (uri)"?>
```dart
var uri = Uri(
  scheme: 'https',
  host: 'example.org',
  path: '/foo/bar',
  fragment: 'frag',
  queryParameters: {'lang': 'dart'},
);
assert(uri.toString() == 'https://example.org/foo/bar?lang=dart#frag');
```

Se você não precisar especificar um fragmento,
para criar um URI com um esquema http ou https,
você pode usar os construtores de fábrica [`Uri.http`][`Uri.http`] ou [`Uri.https`][`Uri.https`]:

<?code-excerpt "misc/test/library_tour/core_test.dart (uri-http)"?>
```dart
var httpUri = Uri.http('example.org', '/foo/bar', {'lang': 'dart'});
var httpsUri = Uri.https('example.org', '/foo/bar', {'lang': 'dart'});

assert(httpUri.toString() == 'http://example.org/foo/bar?lang=dart');
assert(httpsUri.toString() == 'https://example.org/foo/bar?lang=dart');
```

[`Uri.http`]: {{site.dart-api}}/dart-core/Uri/Uri.http.html
[`Uri.https`]: {{site.dart-api}}/dart-core/Uri/Uri.https.html

## Datas e horas {:#dates-and-times}

Um objeto DateTime é um ponto no tempo. O fuso horário é UTC ou o fuso
horário local.

Você pode criar objetos DateTime usando vários construtores e métodos:

<?code-excerpt "misc/test/library_tour/core_test.dart (date-time)"?>
```dart
// Get the current date and time.
var now = DateTime.now();

// Create a new DateTime with the local time zone.
var y2k = DateTime(2000); // January 1, 2000

// Specify the month and day.
y2k = DateTime(2000, 1, 2); // January 2, 2000

// Specify the date as a UTC time.
y2k = DateTime.utc(2000); // 1/1/2000, UTC

// Specify a date and time in ms since the Unix epoch.
y2k = DateTime.fromMillisecondsSinceEpoch(946684800000, isUtc: true);

// Parse an ISO 8601 date in the UTC time zone.
y2k = DateTime.parse('2000-01-01T00:00:00Z');

// Create a new DateTime from an existing one, adjusting just some properties:
var sameTimeLastYear = now.copyWith(year: now.year - 1);
```

:::warning
As operações `DateTime` podem fornecer resultados inesperados relacionados
ao Horário de Verão e outros ajustes de tempo não padronizados.
:::

A propriedade `millisecondsSinceEpoch` de uma data retorna o número de
milissegundos desde a "época Unix" — 1º de janeiro de 1970, UTC:

<?code-excerpt "misc/test/library_tour/core_test.dart (milliseconds-since-epoch)"?>
```dart
// 1/1/2000, UTC
var y2k = DateTime.utc(2000);
assert(y2k.millisecondsSinceEpoch == 946684800000);

// 1/1/1970, UTC
var unixEpoch = DateTime.utc(1970);
assert(unixEpoch.millisecondsSinceEpoch == 0);
```

Use a classe Duration para calcular a diferença entre duas datas e para
avançar ou retroceder uma data:

<?code-excerpt "misc/test/library_tour/core_test.dart (duration)"?>
```dart
var y2k = DateTime.utc(2000);

// Add one year.
var y2001 = y2k.add(const Duration(days: 366));
assert(y2001.year == 2001);

// Subtract 30 days.
var december2000 = y2001.subtract(const Duration(days: 30));
assert(december2000.year == 2000);
assert(december2000.month == 12);

// Calculate the difference between two dates.
// Returns a Duration object.
var duration = y2001.difference(y2k);
assert(duration.inDays == 366); // y2k was a leap year.
```

:::warning
O uso de uma `Duration` para alterar um `DateTime` por dias pode ser
problemático, devido a mudanças de relógio (para o horário de verão, por
exemplo). Use datas UTC se precisar alterar os dias.
:::

Para obter uma lista completa de métodos,
consulte a referência da API para [DateTime][DateTime] e [Duration.][Duration]


## Classes de utilidade {:#utility-classes}

A biblioteca principal contém várias classes de utilidade, úteis para ordenar,
mapear valores e iterar.

### Comparando objetos {:#comparing-objects}

Implemente a interface [Comparable][Comparable]
para indicar que um objeto pode ser comparado a outro objeto,
geralmente para ordenação. O método `compareTo()` retorna < 0 para
*menor*, 0 para *igual* e > 0 para *maior*.

<?code-excerpt "misc/lib/library_tour/core/comparable.dart"?>
```dart
class Line implements Comparable<Line> {
  final int length;
  const Line(this.length);

  @override
  int compareTo(Line other) => length - other.length;
}

void main() {
  var short = const Line(1);
  var long = const Line(100);
  assert(short.compareTo(long) < 0);
}
```

### Implementando chaves de mapa {:#implementing-map-keys}

Cada objeto em Dart automaticamente fornece um código hash inteiro e,
portanto, pode ser usado como chave em um mapa. No entanto, você pode
substituir o getter `hashCode` para gerar um código hash personalizado.
Se você fizer isso, também poderá substituir o operador `==`. Objetos que
são iguais (via `==`) devem ter códigos hash idênticos. Um código hash
não precisa ser único, mas deve ser bem distribuído.

:::tip
Para implementar de forma consistente e fácil o getter `hashCode`,
considere usar os métodos estáticos de hashing fornecidos pela classe `Object`.

Para gerar um único código hash para várias propriedades de um objeto,
você pode usar [`Object.hash()`][`Object.hash()`].
Para gerar um código hash para uma coleção,
você pode usar [`Object.hashAll()`][`Object.hashAll()`] (se a ordem dos elementos importar)
ou [`Object.hashAllUnordered()`][`Object.hashAllUnordered()`].
:::

[`Object.hash()`]: {{site.dart-api}}/dart-core/Object/hash.html
[`Object.hashAll()`]: {{site.dart-api}}/dart-core/Object/hashAll.html
[`Object.hashAllUnordered()`]: {{site.dart-api}}/dart-core/Object/hashAllUnordered.html

{% comment %}
Observação: Há discordância sobre se deve incluir identical() na
implementação de ==. Isso pode melhorar a velocidade, pelo menos quando
você precisa comparar muitos campos. Eles não fazem identical()
automaticamente porque, por convenção, NaN != NaN.
{% endcomment %}

<?code-excerpt "misc/lib/library_tour/core/hash_code.dart"?>
```dart
class Person {
  final String firstName, lastName;

  Person(this.firstName, this.lastName);

  // Override hashCode using the static hashing methods
  // provided by the `Object` class.
  @override
  int get hashCode => Object.hash(firstName, lastName);

  // You should generally implement operator `==` if you
  // override `hashCode`.
  @override
  bool operator ==(Object other) {
    return other is Person &&
        other.firstName == firstName &&
        other.lastName == lastName;
  }
}

void main() {
  var p1 = Person('Bob', 'Smith');
  var p2 = Person('Bob', 'Smith');
  var p3 = 'not a person';
  assert(p1.hashCode == p2.hashCode);
  assert(p1 == p2);
  assert(p1 != p3);
}
```

### Iteração {:#iteration}

As classes [Iterable][Iterable] e [Iterator][Iterator]
suportam acesso sequencial a uma coleção de valores.
Para praticar o uso dessas coleções,
siga o [tutorial de coleções Iterable](/libraries/collections/iterables).

Se você criar uma classe que pode fornecer Iterators para uso em loops
for-in, estenda (se possível) ou implemente Iterable. Implemente Iterator
para definir a capacidade de iteração real.

<?code-excerpt "misc/lib/library_tour/core/iterator.dart (structure)"?>
```dart
class Process {
  // Represents a process...
}

class ProcessIterator implements Iterator<Process> {
  @override
  Process get current => ...
  @override
  bool moveNext() => ...
}

// A mythical class that lets you iterate through all
// processes. Extends a subclass of [Iterable].
class Processes extends IterableBase<Process> {
  @override
  final Iterator<Process> iterator = ProcessIterator();
}

void main() {
  // Iterable objects can be used with for-in.
  for (final process in Processes()) {
    // Do something with the process.
  }
}
```

## Exceções {:#exceptions}

A biblioteca core (núcleo) do Dart define muitas exceções e erros comuns.
Exceções são consideradas condições para as quais você pode se planejar
com antecedência e capturar. Erros são condições que você não espera ou planeja.

Alguns dos erros mais comuns são:

[NoSuchMethodError][NoSuchMethodError]
: Lançado quando um objeto receptor (que pode ser `null`) não
  implementa um método.

[ArgumentError][ArgumentError]
: Pode ser lançado por um método que encontra um argumento inesperado.

Lançar uma exceção específica do aplicativo é uma forma comum de indicar
que ocorreu um erro. Você pode definir uma exceção personalizada
implementando a interface Exception:

<?code-excerpt "misc/lib/library_tour/core/exception.dart"?>
```dart
class FooException implements Exception {
  final String? msg;

  const FooException([this.msg]);

  @override
  String toString() => msg ?? 'FooException';
}
```

Para mais informações, veja
[Exceções](/language/error-handling#exceptions)
(no tour da linguagem) e a [referência da API de Exception][Exception].

## Referências fracas e finalizadores {:#weak-references-and-finalizers}

Dart é uma linguagem com [coleta de lixo (garbage-collected)][garbage-collected],
o que significa que qualquer objeto Dart
que não seja referenciado
pode ser descartado pelo coletor de lixo.
Este comportamento padrão pode não ser desejável em
alguns cenários envolvendo recursos nativos ou
se o objeto de destino não puder ser modificado.

Uma [WeakReference (Referência fraca)][WeakReference]
armazena uma referência ao objeto de destino
que não afeta como ele é
coletado pelo coletor de lixo.
Outra opção é usar um [Expando][Expando]
para adicionar propriedades a um objeto.

Um [Finalizer][Finalizer] pode ser usado para executar uma função de callback
depois que um objeto não é mais referenciado.
No entanto, não é garantido que esse callback seja executado.

Um [NativeFinalizer][NativeFinalizer]
fornece garantias mais fortes
para interagir com código nativo usando [dart:ffi][dart:ffi];
seu callback é invocado pelo menos uma vez
após o objeto não ser mais referenciado.
Além disso, ele pode ser usado para fechar recursos nativos
como uma conexão de banco de dados ou arquivos abertos.

Para garantir que um objeto não seja
coletado pelo lixo e finalizado muito cedo,
as classes podem implementar a interface [Finalizable][Finalizable].
Quando uma variável local é Finalizable,
ela não será coletada pelo lixo
até que o bloco de código onde foi declarada seja finalizado.

:::version-note
O suporte para referências fracas e finalizadores foi adicionado no Dart 2.17.
:::


[ArgumentError]: {{site.dart-api}}/dart-core/ArgumentError-class.html
[Comparable]: {{site.dart-api}}/dart-core/Comparable-class.html
[DateTime]: {{site.dart-api}}/dart-core/DateTime-class.html
[Duration]: {{site.dart-api}}/dart-core/Duration-class.html
[Exception]: {{site.dart-api}}/dart-core/Exception-class.html
[Expando]: {{site.dart-api}}/dart-core/Expando-class.html
[Finalizable]: {{site.dart-api}}/dart-ffi/Finalizable-class.html
[Finalizer]: {{site.dart-api}}/dart-core/Finalizer-class.html
[Iterable]: {{site.dart-api}}/dart-core/Iterable-class.html
[Iterator]: {{site.dart-api}}/dart-core/Iterator-class.html
[List]: {{site.dart-api}}/dart-core/List-class.html
[Map]: {{site.dart-api}}/dart-core/Map-class.html
[Match]: {{site.dart-api}}/dart-core/Match-class.html
[NativeFinalizer]: {{site.dart-api}}/dart-ffi/NativeFinalizer-class.html
[NoSuchMethodError]: {{site.dart-api}}/dart-core/NoSuchMethodError-class.html
[Pattern]: {{site.dart-api}}/dart-core/Pattern-class.html
[RegExp]: {{site.dart-api}}/dart-core/RegExp-class.html
[Set]: {{site.dart-api}}/dart-core/Set-class.html
[StringBuffer]: {{site.dart-api}}/dart-core/StringBuffer-class.html
[String]: {{site.dart-api}}/dart-core/String-class.html
[Uri]: {{site.dart-api}}/dart-core/Uri-class.html
[WeakReference]: {{site.dart-api}}/dart-core/WeakReference-class.html
[dart:core]: {{site.dart-api}}/dart-core/dart-core-library.html
[dart:ffi]: /interop/c-interop
[double]: {{site.dart-api}}/dart-core/double-class.html
[garbage-collected]: https://medium.com/flutter/flutter-dont-fear-the-garbage-collector-d69b3ff1ca30
[int]: {{site.dart-api}}/dart-core/int-class.html
[num]: {{site.dart-api}}/dart-core/num-class.html
[toStringAsFixed()]: {{site.dart-api}}/dart-core/num/toStringAsFixed.html
[toStringAsPrecision()]: {{site.dart-api}}/dart-core/num/toStringAsPrecision.html
