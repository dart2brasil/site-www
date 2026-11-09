---
ia-translate: true
title: Tipos integrados
description: Informações sobre os tipos que o Dart suporta.
prevpage:
  url: /language/comments
  title: Comentários
nextpage:
  url: /language/records
  title: Records
---

A linguagem Dart tem suporte especial para o seguinte:

- [Numbers](#numbers) (`int`, `double`)
- [Strings](#strings) (`String`)
- [Booleans](#booleans) (`bool`)
- [Records][] (`(value1, value2)`)
- [Functions][] (`Function`)
- [Lists][] (`List`, também conhecidas como *arrays*)
- [Sets][] (`Set`)
- [Maps][] (`Map`)
- [Runes](#runes-and-grapheme-clusters) (`Runes`; frequentemente substituído pela API `characters`)
- [Symbols](#symbols) (`Symbol`)
- O valor `null` (`Null`)

Esse suporte inclui a capacidade de criar objetos usando literais.
Por exemplo, `'this is a string'` é um literal de string,
e `true` é um literal booleano.

Como toda variável em Dart referencia um objeto (uma instância de uma
*classe*), você geralmente pode usar *construtores* para inicializar variáveis. Alguns
dos tipos integrados têm seus próprios construtores. Por exemplo, você pode
usar o construtor `Map()` para criar um map.

Alguns outros tipos também têm papéis especiais na linguagem Dart:

* `Object`: A superclasse de todas as classes Dart, exceto `Null`.
* `Enum`: A superclasse de todos os enums.
* `Future` e `Stream`: Usados em [programação assíncrona][asynchronous programming].
* `Iterable`: Usado em [loops for-in][iteration] e
  em [funções geradoras][generator functions] síncronas.
* `Never`: Indica que uma expressão nunca pode
  terminar de ser avaliada com sucesso.
  Mais usado em funções que sempre lançam uma exceção.
* `dynamic`: Indica que você quer desabilitar a verificação estática.
  Normalmente, você deve usar `Object` ou `Object?` em vez disso.
* `void`: Indica que um valor nunca é usado.
  Frequentemente usado como tipo de retorno.

As classes `Object`, `Object?`, `Null` e `Never`
têm papéis especiais na hierarquia de classes.
Saiba mais sobre esses papéis em [Entendendo null safety][Understanding null safety].

{% comment %}
If we decide to cover `dynamic` more,
here's a nice example that illustrates what dynamic does:
  dynamic a = 2;
  String b = a; // No problem! Until runtime, when you get an uncaught error.

  Object c = 2;
  String d = c;  // Problem!
{% endcomment %}


## Numbers {:#numbers}

Números em Dart vêm em dois tipos:

[`int`][`int`]

:   Valores inteiros de no máximo 64 bits,
    [dependendo da plataforma][dart-numbers].
    Em plataformas nativas, os valores podem ir de
    -2<sup>63</sup> a 2<sup>63</sup> - 1.
    Na web, valores inteiros são representados como números JavaScript
    (valores de ponto flutuante de 64 bits sem parte fracionária)
    e podem ir de -2<sup>53</sup> a 2<sup>53</sup> - 1.

[`double`][`double`]

:   Números de ponto flutuante de 64 bits (precisão dupla), conforme
    definido pelo padrão IEEE 754.

Tanto `int` quanto `double` são subtipos de [`num`][`num`].
O tipo num inclui operadores básicos como +, -, / e \*,
e é também onde você encontra `abs()`,` ceil()`,
e `floor()`, entre outros métodos.
(Operadores bit a bit, como \>\>, são definidos na classe `int`.)
Se num e seus subtipos não tiverem o que você procura, a
biblioteca [`dart:math`][`dart:math`] pode ter.

Inteiros são números sem ponto decimal. Aqui estão alguns exemplos de
definição de literais inteiros:

<?code-excerpt "misc/lib/language_tour/built_in_types.dart (integer-literals)"?>
```dart
var x = 1;
var hex = 0xDEADBEEF;
```

Se um número tem parte decimal, ele é um double. Aqui estão alguns exemplos
de definição de literais double:

<?code-excerpt "misc/lib/language_tour/built_in_types.dart (double-literals)"?>
```dart
var y = 1.1;
var exponents = 1.42e5;
```

Você também pode declarar uma variável como num. Se fizer isso, a variável
pode ter valores inteiros e double.

<?code-excerpt "misc/lib/language_tour/built_in_types.dart (declare-num)"?>
```dart
num x = 1; // x can have both int and double values
x += 2.5;
```

Literais inteiros são convertidos automaticamente para double quando necessário:

<?code-excerpt "misc/lib/language_tour/built_in_types.dart (int-to-double)"?>
```dart
double z = 1; // Equivalent to double z = 1.0.
```

Veja como transformar uma string em número, ou vice-versa:

<?code-excerpt "misc/test/language_tour/built_in_types_test.dart (number-conversion)"?>
```dart
// String -> int
var one = int.parse('1');
assert(one == 1);

// String -> double
var onePointOne = double.parse('1.1');
assert(onePointOne == 1.1);

// int -> String
String oneAsString = 1.toString();
assert(oneAsString == '1');

// double -> String
String piAsString = 3.14159.toStringAsFixed(2);
assert(piAsString == '3.14');
```

O tipo `int` define os operadores tradicionais de deslocamento de bits (`<<`, `>>`, `>>>`),
complemento (`~`), AND (`&`), OR (`|`) e XOR (`^`),
que são úteis para manipular e mascarar flags em campos de bits.
Por exemplo:

<?code-excerpt "misc/test/language_tour/built_in_types_test.dart (bit-shifting)"?>
```dart
assert((3 << 1) == 6); // 0011 << 1 == 0110
assert((3 | 4) == 7); // 0011 | 0100 == 0111
assert((3 & 4) == 0); // 0011 & 0100 == 0000
```

Para mais exemplos, veja a seção sobre o
[operador bit a bit e de deslocamento][bitwise and shift operator].

Literais numéricos são constantes de tempo de compilação.
Muitas expressões aritméticas também são constantes de tempo de compilação,
desde que seus operandos sejam
constantes de tempo de compilação que avaliam para números.

<?code-excerpt "misc/lib/language_tour/built_in_types.dart (const-num)"?>
```dart
const msPerSecond = 1000;
const secondsUntilRetry = 5;
const msUntilRetry = secondsUntilRetry * msPerSecond;
```

Para mais informações, veja [Números em Dart][dart-numbers].

<a id="digit-separators"></a>

Você pode usar um ou mais sublinhados (`_`) como separadores de dígitos
para tornar literais numéricos longos mais legíveis.
Vários separadores de dígitos permitem um agrupamento de nível mais alto.

<?code-excerpt "misc/lib/language_tour/built_in_types.dart (digit-separators)"?>
```dart
var n1 = 1_000_000;
var n2 = 0.000_000_000_01;
var n3 = 0x00_14_22_01_23_45; // MAC address
var n4 = 555_123_4567; // US Phone number
var n5 = 100__000_000__000_000; // one hundred million million!
```

:::version-note
Usar separadores de dígitos exige uma [versão da linguagem][language version] de pelo menos 3.6.
:::

## Strings {:#strings}

Uma string Dart (objeto `String`) contém uma sequência de unidades de código UTF-16.
Você pode usar aspas simples
ou duplas para criar uma string:

<?code-excerpt "misc/lib/language_tour/built_in_types.dart (quoting)"?>
```dart
var s1 = 'Single quotes work well for string literals.';
var s2 = "Double quotes work just as well.";
var s3 = 'It\'s easy to escape the string delimiter.';
var s4 = "It's even easier to use the other delimiter.";
```

<a id="string-interpolation"></a>

Você pode colocar o valor de uma expressão dentro de uma string usando
`${`*`expression`*`}`. Se a expressão for um identificador, você pode omitir
as `{}`. Para obter a string correspondente a um objeto, o Dart chama o
método `toString()` do objeto.

<?code-excerpt "misc/test/language_tour/built_in_types_test.dart (string-interpolation)"?>
```dart
var s = 'string interpolation';

assert(
  'Dart has $s, which is very handy.' ==
      'Dart has string interpolation, '
          'which is very handy.',
);
assert(
  'That deserves all caps. '
          '${s.toUpperCase()} is very handy!' ==
      'That deserves all caps. '
          'STRING INTERPOLATION is very handy!',
);
```

:::note
O operador `==` testa se dois objetos são equivalentes.
Duas strings são equivalentes se contêm a
mesma sequência de unidades de código.
:::

Você pode concatenar strings usando literais de string adjacentes ou o operador `+`:

<?code-excerpt "misc/test/language_tour/built_in_types_test.dart (adjacent-string-literals)"?>
```dart
var s1 =
    'String '
    'concatenation'
    " works even over line breaks.";
assert(
  s1 ==
      'String concatenation works even over '
          'line breaks.',
);

var s2 = 'The + operator ' + 'works, as well.';
assert(s2 == 'The + operator works, as well.');
```

Para criar uma string de múltiplas linhas, use aspas triplas com
aspas simples ou duplas:

<?code-excerpt "misc/lib/language_tour/built_in_types.dart (triple-quotes)"?>
```dart
var s1 = '''
You can create
multi-line strings like this one.
''';

var s2 = """This is also a
multi-line string.""";
```

Você pode criar uma string "raw" prefixando-a com `r`:

<?code-excerpt "misc/lib/language_tour/built_in_types.dart (raw-strings)"?>
```dart
var s = r'In a raw string, not even \n gets special treatment.';
```

Veja [Runes e clusters de grafemas](#runes-and-grapheme-clusters) para detalhes sobre
como expressar caracteres Unicode em uma string.

Literais de string são constantes de tempo de compilação,
desde que qualquer expressão interpolada seja uma constante de tempo de compilação
que avalie para null ou para um valor numérico, string ou booleano.

<?code-excerpt "misc/lib/language_tour/built_in_types.dart (string-literals)"?>
```dart
// These work in a const string.
const aConstNum = 0;
const aConstBool = true;
const aConstString = 'a constant string';

// These do NOT work in a const string.
var aNum = 0;
var aBool = true;
var aString = 'a string';
const aConstList = [1, 2, 3];

const validConstString = '$aConstNum $aConstBool $aConstString';
// const invalidConstString = '$aNum $aBool $aString $aConstList';
```

Para mais informações sobre o uso de strings, confira
[Strings e expressões regulares](/libraries/dart-core#strings-and-regular-expressions).


## Booleans {:#booleans}

Para representar valores booleanos, o Dart tem um tipo chamado `bool`. Apenas dois
objetos têm tipo bool: os literais booleanos `true` e `false`,
que são ambos constantes de tempo de compilação.

A segurança de tipos do Dart significa que você não pode usar código como
<code>if (<em>nonBooleanValue</em>)</code> ou
<code>assert (<em>nonBooleanValue</em>)</code>.
Em vez disso, verifique explicitamente os valores, assim:

<?code-excerpt "misc/test/language_tour/built_in_types_test.dart (no-truthy)"?>
```dart
// Check for an empty string.
var fullName = '';
assert(fullName.isEmpty);

// Check for zero.
var hitPoints = 0;
assert(hitPoints == 0);

// Check for null.
var unicorn = null;
assert(unicorn == null);

// Check for NaN.
var iMeantToDoThis = 0 / 0;
assert(iMeantToDoThis.isNaN);
```

## Runes e clusters de grafemas {:#runes-and-grapheme-clusters}

No Dart, [runes][runes] expõem os code points Unicode de uma string.
Você pode usar o [pacote characters][characters package]
para visualizar ou manipular caracteres percebidos pelo usuário,
também conhecidos como
[clusters de grafemas Unicode (estendidos)][grapheme clusters].

O Unicode define um valor numérico único para cada letra, dígito
e símbolo usado em todos os sistemas de escrita do mundo.
Como uma string Dart é uma sequência de unidades de código UTF-16,
expressar code points Unicode dentro de uma string exige
uma sintaxe especial.
A forma usual de expressar um code point Unicode é
`\uXXXX`, em que XXXX é um valor hexadecimal de 4 dígitos.
Por exemplo, o caractere de coração (♥) é `♥`.
Para especificar mais ou menos de 4 dígitos hexadecimais,
coloque o valor entre chaves.
Por exemplo, o emoji de risada (😆) é `\u{1f606}`.

Se você precisar ler ou escrever caracteres Unicode individuais,
use o getter `characters` definido em String
pelo pacote characters.
O objeto [`Characters`][`Characters`] retornado é a string como
uma sequência de clusters de grafemas.
Aqui está um exemplo de uso da API characters:

<?code-excerpt "misc/lib/language_tour/characters.dart"?>
```dart
import 'package:characters/characters.dart';

void main() {
  var hi = 'Hi 🇩🇰';
  print(hi);
  print('The end of the string: ${hi.substring(hi.length - 1)}');
  print('The last character: ${hi.characters.last}');
}
```

A saída, dependendo do seu ambiente, fica parecida com esta:

```console
$ dart run bin/main.dart
Hi 🇩🇰
The end of the string: ???
The last character: 🇩🇰
```

Para detalhes sobre como usar o pacote characters para manipular strings,
veja o [exemplo][characters example] e a [referência da API][characters API]
do pacote characters.

## Symbols {:#symbols}

Um objeto [`Symbol`][`Symbol`]
representa um operador ou identificador declarado em um programa Dart. Você
talvez nunca precise usar symbols, mas eles são muito úteis para APIs que
referenciam identificadores pelo nome, porque a minificação altera os nomes
dos identificadores, mas não os símbolos dos identificadores.

Para obter o symbol de um identificador, use um literal de symbol, que é apenas
`#` seguido do identificador:

```plaintext
#radix
#bar
```

{% comment %}
The code from the following excerpt isn't actually what is being shown in the page

<?code-excerpt "misc/lib/language_tour/built_in_types.dart (symbols)"?>
```dart
void main() {
  print(Function.apply(int.parse, ['11']));
  print(Function.apply(int.parse, ['11'], {#radix: 16}));
}
```
{% endcomment %}

Literais de symbol são constantes de tempo de compilação.



[Records]: /language/records
[Functions]: /language/functions#function-types
[Lists]: /language/collections#lists
[Sets]: /language/collections#sets
[Maps]: /language/collections#maps
[asynchronous programming]: /language/async
[iteration]: /libraries/dart-core#iteration
[generator functions]: /language/functions#generators
[Understanding null safety]: /null-safety/understanding-null-safety#top-and-bottom
[`int`]: {{site.dart-api}}/dart-core/int-class.html
[`double`]: {{site.dart-api}}/dart-core/double-class.html
[`num`]: {{site.dart-api}}/dart-core/num-class.html
[`dart:math`]: {{site.dart-api}}/dart-math/dart-math-library.html
[bitwise and shift operator]: /language/operators#bitwise-and-shift-operators
[dart-numbers]: /resources/language/number-representation
[runes]: {{site.dart-api}}/dart-core/Runes-class.html
[characters package]: {{site.pub-pkg}}/characters
[grapheme clusters]: https://unicode.org/reports/tr29/#Grapheme_Cluster_Boundaries
[`Characters`]: {{site.pub-api}}/characters/latest/characters/Characters-class.html
[characters API]: {{site.pub-api}}/characters
[characters example]: {{site.pub-pkg}}/characters/example
[`Symbol`]: {{site.dart-api}}/dart-core/Symbol-class.html
[language version]: /language/versioning
