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
print('Eu bebo $tea.');
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
// Converte um int em uma string.
assert(42.toString() == '42');

// Converte um double em uma string.
assert(123.456.toString() == '123.456');

// Especifica o número de dígitos após a decimal.
assert(123.456.toStringAsFixed(2) == '123.46');

// Especifica o número de dígitos significativos.
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
// Verifica se uma string contém outra string.
assert('Nunca ímpar ou par'.contains('ímpar'));

// Uma string começa com outra string?
assert('Nunca ímpar ou par'.startsWith('Nunca'));

// Uma string termina com outra string?
assert('Nunca ímpar ou par'.endsWith('par'));

// Encontra a localização de uma string dentro de uma string.
assert('Nunca ímpar ou par'.indexOf('ímpar') == 6);
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
// Pega uma substring.
assert('Nunca ímpar ou par'.substring(6, 9) == 'ímpar');

// Divide uma string usando um padrão de string.
var parts = 'aplicativos web progressivos'.split(' ');
assert(parts.length == 3);
assert(parts[0] == 'aplicativos');

// Obtém uma unidade de código UTF-16 (como uma string) por índice.
assert('Nunca ímpar ou par'[0] == 'N');

// Use split() com um parâmetro de string vazia para obter
// uma lista de todos os caracteres (como Strings); bom para
// iteração.
for (final char in 'olá'.split('')) {
  print(char);
}

// Obtém todas as unidades de código UTF-16 na string.
var codeUnitList = 'Nunca ímpar ou par'.codeUnits.toList();
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
// Converte para maiúsculas.
assert('aplicativos web'.toUpperCase() == 'APLICATIVOS WEB');

// Converte para minúsculas.
assert('APLICATIVOS WEB'.toLowerCase() == 'aplicativos web');
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
// Remove espaços em branco de uma string.
assert('  olá  '.trim() == 'olá');

// Verifica se uma string está vazia.
assert(''.isEmpty);

// Strings com apenas espaços em branco não estão vazias.
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
var greetingTemplate = 'Olá, NOME!';
var greeting = greetingTemplate.replaceAll(RegExp('NOME'), 'Bob');

// greetingTemplate não mudou.
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
  ..write('Use um StringBuffer para ')
  ..writeAll(['criação', 'de', 'string', 'eficiente'], ' ')
  ..write('.');

var fullString = sb.toString();

assert(fullString == 'Use um StringBuffer para criação de string eficiente.');
```

### Expressões regulares {:#regular-expressions}

A classe RegExp fornece os mesmos recursos que as expressões regulares
JavaScript. Use expressões regulares para pesquisa eficiente e
correspondência de padrões de strings.

<?code-excerpt "misc/test/library_tour/core_test.dart (regexp)"?>
```dart
// Aqui está uma expressão regular para um ou mais dígitos.
var numbers = RegExp(r'\d+');

var allCharacters = 'lhamas vivem de quinze a vinte anos';
var someDigits = 'lhamas vivem 15 a 20 anos';

// contains() pode usar uma expressão regular.
assert(!allCharacters.contains(numbers));
assert(someDigits.contains(numbers));

// Substitui cada correspondência por outra string.
var exedOut = someDigits.replaceAll(numbers, 'XX');
assert(exedOut == 'lhamas vivem XX a XX anos');
```

Você também pode trabalhar diretamente com a classe RegExp. A classe
Match fornece acesso a uma correspondência de expressão regular.

<?code-excerpt "misc/test/library_tour/core_test.dart (match)"?>
```dart
var numbers = RegExp(r'\d+');
var someDigits = 'lhamas vivem 15 a 20 anos';

// Verifica se a expressão regular tem uma correspondência em uma string.
assert(numbers.hasMatch(someDigits));

// Percorre todas as correspondências.
for (final match in numbers.allMatches(someDigits)) {
  print(match.group(0)); // 15, depois 20
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
// Cria uma lista vazia de strings.
var grains = <String>[];
assert(grains.isEmpty);

// Cria uma lista usando um literal de lista.
var fruits = ['maçãs', 'laranjas'];

// Adiciona à lista.
fruits.add('kiwis');

// Adiciona vários itens a uma lista.
fruits.addAll(['uvas', 'bananas']);

// Obtém o comprimento da lista.
assert(fruits.length == 5);

// Remove um único item.
var appleIndex = fruits.indexOf('maçãs');
fruits.removeAt(appleIndex);
assert(fruits.length == 4);

// Remove todos os elementos de uma lista.
fruits.clear();
assert(fruits.isEmpty);

// Você também pode criar uma Lista usando um dos construtores.
var vegetables = List.filled(99, 'brócolis');
assert(vegetables.every((v) => v == 'brócolis'));
```

Use `indexOf()` para encontrar o índice de um objeto em uma lista:

<?code-excerpt "misc/test/library_tour/core_test.dart (index-of)"?>
```dart
var fruits = ['maçãs', 'laranjas'];

// Acessa um item da lista por índice.
assert(fruits[0] == 'maçãs');

// Encontra um item em uma lista.
assert(fruits.indexOf('maçãs') == 0);
```

Classifica uma lista usando o método `sort()`. Você pode fornecer uma
função de classificação que compare dois objetos. Essa função de
classificação deve retornar < 0 para *menor*, 0 para *igual* e > 0 para
*maior*. O exemplo a seguir usa `compareTo()`, que é definido por
[Comparable][] e implementado por String.

<?code-excerpt "misc/test/library_tour/core_test.dart (compare-to)"?>
```dart
var fruits = ['bananas', 'maçãs', 'laranjas'];

// Classifica uma lista.
fruits.sort((a, b) => a.compareTo(b));
assert(fruits[0] == 'maçãs');
```

Listas são tipos parametrizados
([genéricos](/language/generics)),
para que você possa especificar o tipo que uma lista
deve conter:

<?code-excerpt "misc/test/library_tour/core_test.dart (list-of-string)"?>
```dart
// Esta lista deve conter apenas strings.
var fruits = <String>[];

fruits.add('maçãs');
var fruit = fruits[0];
assert(fruit is String);
```

<?code-excerpt "misc/lib/library_tour/core/collections.dart (list-of-string)"?>
```dart tag=fails-sa
fruits.add(5); // Erro: 'int' não pode ser atribuído a 'String'
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
// Cria um conjunto vazio de strings.
var ingredients = <String>{};

// Adiciona novos itens a ele.
ingredients.addAll(['ouro', 'titânio', 'xenônio']);
assert(ingredients.length == 3);

// Adicionar um item duplicado não tem efeito.
ingredients.add('ouro');
assert(ingredients.length == 3);

// Remove um item de um conjunto.
ingredients.remove('ouro');
assert(ingredients.length == 2);

// Você também pode criar conjuntos usando
// um dos construtores.
var atomicNumbers = Set.from([79, 22, 54]);
```

Use `contains()` e `containsAll()` para verificar se um ou mais objetos
estão em um conjunto:

<?code-excerpt "misc/test/library_tour/core_test.dart (contains)"?>
```dart
var ingredients = Set<String>();
ingredients.addAll(['ouro', 'titânio', 'xenônio']);

// Verifica se um item está no conjunto.
assert(ingredients.contains('titânio'));

// Verifica se todos os itens estão no conjunto.
assert(ingredients.containsAll(['titânio', 'xenônio']));
```

Uma interseção é um conjunto cujos itens estão em outros dois conjuntos.

<?code-excerpt "misc/test/library_tour/core_test.dart (intersection)"?>
```dart
var ingredients = Set<String>();
ingredients.addAll(['ouro', 'titânio', 'xenônio']);

// Cria a interseção de dois conjuntos.
var nobleGases = Set.from(['xenônio', 'argônio']);
var intersection = ingredients.intersection(nobleGases);
assert(intersection.length == 1);
assert(intersection.contains('xenônio'));
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
// Maps geralmente usam strings como chaves.
var hawaiianBeaches = {
  'Oahu': ['Waikiki', 'Kailua', 'Waimanalo'],
  'Big Island': ['Wailea Bay', 'Pololu Beach'],
  'Kauai': ['Hanalei', 'Poipu']
};

// Maps podem ser construídos a partir de um construtor.
var searchTerms = Map();

// Maps são tipos parametrizados; você pode especificar quais
// tipos a chave e o valor devem ser.
var nobleGases = Map<int, String>();
```

Você adiciona, obtém e define itens de map usando a sintaxe de colchetes.
Use `remove()` para remover uma chave e seu valor de um map.

<?code-excerpt "misc/test/library_tour/core_test.dart (remove)"?>
```dart
var nobleGases = {54: 'xenônio'};

// Recupera um valor com uma chave.
assert(nobleGases[54] == 'xenônio');

// Verifica se um map contém uma chave.
assert(nobleGases.containsKey(54));

// Remove uma chave e seu valor.
nobleGases.remove(54);
assert(!nobleGases.containsKey(54));
```

Você pode recuperar todos os valores ou todas as chaves de um map:

<?code-excerpt "misc/test/library_tour/core_test.dart (keys)"?>
```dart
var hawaiianBeaches = {
  'Oahu': ['Waikiki', 'Kailua', 'Waimanalo'],
  'Big Island': ['Wailea Bay', 'Pololu Beach'],
  'Kauai': ['Hanalei', 'Poipu']
};

// Obtém todas as chaves como uma coleção não ordenada
// (um Iterable).
var keys = hawaiianBeaches.keys;

assert(keys.length == 3);
assert(Set.from(keys).contains('Oahu'));

// Obtém todos os valores como uma coleção não ordenada
// (um Iterable de Listas).
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
  'Kauai': ['Hanalei', 'Poipu']
};

assert(hawaiianBeaches.containsKey('Oahu'));
assert(!hawaiianBeaches.containsKey('Flórida'));
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
var teas = ['verde', 'preto', 'camomila', 'earl grey'];
assert(coffees.isEmpty);
assert(teas.isNotEmpty);
```

Para aplicar uma função a cada item em uma lista, conjunto ou map, você
pode usar `forEach()`:

<?code-excerpt "misc/test/library_tour/core_test.dart (list-for-each)"?>
```dart
var teas = ['verde', 'preto', 'camomila', 'earl grey'];

teas.forEach((tea) => print('Eu bebo $tea'));
```

Quando você invoca `forEach()` em um map, sua função deve receber dois
argumentos (a chave e o valor):

<?code-excerpt "misc/test/library_tour/core_test.dart (map-for-each)"?>
```dart
hawaiianBeaches.forEach((k, v) {
  print('Quero visitar $k e nadar em $v');
  // Quero visitar Oahu e nadar em
  // [Waikiki, Kailua, Waimanalo], etc.
});
```

Iterables fornece o método `map()`, que fornece todos os resultados em um
único objeto:

<?code-excerpt "misc/test/library_tour/core_test.dart (list-map)"?>
```dart
var teas = ['verde', 'preto', 'camomila', 'earl grey'];

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
var teas = ['verde', 'preto', 'camomila', 'earl grey'];

// Camomila não tem cafeína.
bool isDecaffeinated(String teaName) => teaName == 'camomila';

// Use where() para encontrar apenas os itens que retornam verdadeiro
// da função fornecida.
var decaffeinatedTeas = teas.where((tea) => isDecaffeinated(tea));
// ou teas.where(isDecaffeinated)

// Use any() para verificar se pelo menos um item na
// coleção satisfaz uma condição.
assert(teas.any(isDecaffeinated));

// Use every() para verificar se todos os itens em uma
// coleção satisfazem uma condição.
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
var uri = 'https://example.org/api?foo=alguma mensagem';

var encoded = Uri.encodeFull(uri);
assert(encoded == 'https://example.org/api?foo=alguma%20mensagem');

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
var uri = 'https://example.org/api?foo=alguma mensagem';

var encoded = Uri.encodeComponent(uri);
assert(
    encoded == 'https%3A%2F%2Fexample.org%2Fapi%3Ffoo%3Dalguma%20mensagem');

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
    queryParameters: {'lang': 'dart'});
assert(uri.toString() == 'https://example.org/foo/bar?lang=dart#frag');
```

Se você não precisar especificar um fragmento,
para criar um URI com um esquema http ou https,
você pode usar os construtores de fábrica [`Uri.http`][] ou [`Uri.https`][]:

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
// Obtém a data e hora atuais.
var now = DateTime.now();

// Cria um novo DateTime com o fuso horário local.
var y2k = DateTime(2000); // 1º de janeiro de 2000

// Especifica o mês e o dia.
y2k = DateTime(2000, 1, 2); // 2 de janeiro de 2000

// Especifica a data como uma hora UTC.
y2k = DateTime.utc(2000); // 01/01/2000, UTC

// Especifica uma data e hora em ms desde a época Unix.
y2k = DateTime.fromMillisecondsSinceEpoch(946684800000, isUtc: true);

// Analisa uma data ISO 8601 no fuso horário UTC.
y2k = DateTime.parse('2000-01-01T00:00:00Z');

// Cria um novo DateTime a partir de um existente, ajustando apenas algumas propriedades:
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
// 01/01/2000, UTC
var y2k = DateTime.utc(2000);
assert(y2k.millisecondsSinceEpoch == 946684800000);

// 01/01/1970, UTC
var unixEpoch = DateTime.utc(1970);
assert(unixEpoch.millisecondsSinceEpoch == 0);
```

Use a classe Duration para calcular a diferença entre duas datas e para
avançar ou retroceder uma data:

<?code-excerpt "misc/test/library_tour/core_test.dart (duration)"?>
```dart
var y2k = DateTime.utc(2000);

// Adiciona um ano.
var y2001 = y2k.add(const Duration(days: 366));
assert(y2001.year == 2001);

// Subtrai 30 dias.
var december2000 = y2001.subtract(const Duration(days: 30));
assert(december2000.year == 2000);
assert(december2000.month == 12);

// Calcula a diferença entre duas datas.
// Retorna um objeto Duration.
var duration = y2001.difference(y2k);
assert(duration.inDays == 366); // y2k foi um ano bissexto.
```

:::warning
O uso de uma `Duration` para alterar um `DateTime` por dias pode ser
problemático, devido a mudanças de relógio (para o horário de verão, por
exemplo). Use datas UTC se precisar alterar os dias.
:::

Para obter uma lista completa de métodos,
consulte a referência da API para [DateTime][] e [Duration.][Duration]


## Classes de utilidade {:#utility-classes}

A biblioteca principal contém várias classes de utilidade, úteis para ordenar,
mapear valores e iterar.

### Comparando objetos {:#comparing-objects}

Implemente a interface [Comparable][]
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
você pode usar [`Object.hash()`][].
Para gerar um código hash para uma coleção,
você pode usar [`Object.hashAll()`][] (se a ordem dos elementos importar)
ou [`Object.hashAllUnordered()`][].
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

  // Substitua o hashCode usando os métodos estáticos de hashing
  // fornecidos pela classe `Object`.
  @override
  int get hashCode => Object.hash(firstName, lastName);

  // Geralmente você deve implementar o operador `==` se você
  // substituir `hashCode`.
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

As classes [Iterable][] e [Iterator][]
suportam acesso sequencial a uma coleção de valores.
Para praticar o uso dessas coleções,
siga o [tutorial de coleções Iterable](/libraries/collections/iterables).

Se você criar uma classe que pode fornecer Iterators para uso em loops
for-in, estenda (se possível) ou implemente Iterable. Implemente Iterator
para definir a capacidade de iteração real.

<?code-excerpt "misc/lib/library_tour/core/iterator.dart (structure)"?>
```dart
class Process {
  // Representa um processo...
}

class ProcessIterator implements Iterator<Process> {
  @override
  Process get current => ...
  @override
  bool moveNext() => ...
}

// Uma classe mítica que permite iterar por todos os
// processos. Estende uma subclasse de [Iterable].
class Processes extends IterableBase<Process> {
  @override
  final Iterator<Process> iterator = ProcessIterator();
}

void main() {
  // Objetos Iterable podem ser usados com for-in.
  for (final process in Processes()) {
    // Faça algo com o processo.
  }
}
```

## Exceções {:#exceptions}

A biblioteca core (núcleo) do Dart define muitas exceções e erros comuns.
Exceções são consideradas condições para as quais você pode se planejar
com antecedência e capturar. Erros são condições que você não espera ou planeja.

Alguns dos erros mais comuns são:

[NoSuchMethodError][]
: Lançado quando um objeto receptor (que pode ser `null`) não
  implementa um método.

[ArgumentError][]
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

Dart é uma linguagem com [coleta de lixo (garbage-collected)][],
o que significa que qualquer objeto Dart
que não seja referenciado
pode ser descartado pelo coletor de lixo.
Este comportamento padrão pode não ser desejável em
alguns cenários envolvendo recursos nativos ou
se o objeto de destino não puder ser modificado.

Uma [WeakReference (Referência fraca)][]
armazena uma referência ao objeto de destino
que não afeta como ele é
coletado pelo coletor de lixo.
Outra opção é usar um [Expando][]
para adicionar propriedades a um objeto.

Um [Finalizer][] pode ser usado para executar uma função de callback
depois que um objeto não é mais referenciado.
No entanto, não é garantido que esse callback seja executado.

Um [NativeFinalizer][]
fornece garantias mais fortes
para interagir com código nativo usando [dart:ffi][];
seu callback é invocado pelo menos uma vez
após o objeto não ser mais referenciado.
Além disso, ele pode ser usado para fechar recursos nativos
como uma conexão de banco de dados ou arquivos abertos.

Para garantir que um objeto não seja
coletado pelo lixo e finalizado muito cedo,
as classes podem implementar a interface [Finalizable][].
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
[dart:ffi]: /guides/libraries/c-interop
[double]: {{site.dart-api}}/dart-core/double-class.html
[garbage-collected]: https://medium.com/flutter/flutter-dont-fear-the-garbage-collector-d69b3ff1ca30
[int]: {{site.dart-api}}/dart-core/int-class.html
[num]: {{site.dart-api}}/dart-core/num-class.html
[toStringAsFixed()]: {{site.dart-api}}/dart-core/num/toStringAsFixed.html
[toStringAsPrecision()]: {{site.dart-api}}/dart-core/num/toStringAsPrecision.html
