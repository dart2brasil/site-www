---
ia-translate: true
title: Tipos integrados
description: Informações sobre os tipos suportados pelo Dart.
prevpage:
  url: /language/keywords
  title: Palavras-chave
nextpage:
  url: /language/records
  title: Records
---

A linguagem Dart tem suporte especial para o seguinte:

-   [Números](#números)  (`int`,  `double`)
-   [Strings](#strings)  (`String`)
-   [Booleanos](#booleanos)  (`bool`)
-   [Registros][Records]  (`(value1, value2)`)
-   [Funções][Functions]  (`Function`)
-   [Listas][Lists]  (`List`,  também conhecidas como  *arrays*)
-   [Conjuntos][Sets]  (`Set`)
-   [Mapas][Maps]  (`Map`)
-   [Runes](#runes-e-grapheme-clusters)  (`Runes`;
    frequentemente substituído pela API  `characters`)
-   [Símbolos](#símbolos)  (`Symbol`)
-   O valor  `null`  (`Null`)

Este suporte inclui a capacidade de criar objetos usando literais. Por
exemplo,  `'this is a string'`  é uma string literal, e  `true`  é um
booleano literal.

Como toda variável em Dart se refere a um objeto—uma instância de uma
*classe*—você geralmente pode usar *construtores* para inicializar
variáveis. Alguns dos tipos integrados têm seus próprios construtores.
Por exemplo, você pode usar o construtor  `Map()`  para criar um mapa.

Alguns outros tipos também têm funções especiais na linguagem Dart:

-   `Object`: A superclasse de todas as classes Dart, exceto  `Null`.
-   `Enum`: A superclasse de todos os enums.
-   `Future`  e  `Stream`: Usados em [suporte a assincronia][asynchrony support].
-   `Iterable`: Usado em [laços for-in][iteration] e em [funções geradoras][generator functions] síncronas.
-   `Never`: Indica que uma expressão nunca pode terminar de avaliar com sucesso.
    Mais frequentemente usado para funções que sempre lançam uma exceção.
-   `dynamic`: Indica que você deseja desabilitar a verificação estática.
    Normalmente, você deve usar  `Object`  ou  `Object?`  em vez disso.
-   `void`: Indica que um valor nunca é usado.
    Frequentemente usado como um tipo de retorno.

As classes  `Object`,  `Object?`,  `Null`  e  `Never` têm funções especiais
na hierarquia de classes.
Saiba mais sobre essas funções em [Entendendo a segurança nula][Understanding null safety].

{% comment %}
If we decide to cover `dynamic` more,
here's a nice example that illustrates what dynamic does:
  dynamic a = 2;
  String b = a; // No problem! Until runtime, when you get an uncaught error.

  Object c = 2;
  String d = c;  // Problem!
{% endcomment %}

## Números

Os números Dart vêm em dois sabores:

[`int`][`int`]

:   Valores inteiros não maiores que 64 bits, [dependendo da plataforma][dart-numbers].
    Em plataformas nativas, os valores podem ser de -2<sup>63</sup> a 2<sup>63</sup> - 1.
    Na web, os valores inteiros são representados como números JavaScript
    (valores de ponto flutuante de 64 bits sem parte fracionária) e podem
    ser de -2<sup>53</sup> a 2<sup>53</sup> - 1.

[`double`][`double`]

:   Números de ponto flutuante de 64 bits (precisão dupla),
    conforme especificado pelo padrão IEEE 754.

Tanto  `int`  quanto  `double`  são subtipos de  [`num`][`num`]. O tipo num
inclui operadores básicos como +, -, / e *, e também é onde você
encontrará  `abs()`,  `ceil()`  e  `floor()`, entre outros métodos.
(Operadores bit a bit, como >>, são definidos na classe  `int`.) Se num e
seus subtipos não tiverem o que você está procurando, a biblioteca
[`dart:math`][`dart:math`]  pode ter.

Inteiros são números sem ponto decimal. Aqui estão alguns exemplos de
definição de literais inteiros:

<?code-excerpt "misc/lib/language_tour/built_in_types.dart (integer-literals)"?>

```dart
var x = 1;
var hex = 0xDEADBEEF;
```

Se um número incluir um decimal, ele será um double. Aqui estão alguns
exemplos de definição de literais double:

<?code-excerpt "misc/lib/language_tour/built_in_types.dart (double-literals)"?>

```dart
var y = 1.1;
var exponents = 1.42e5;
```

Você também pode declarar uma variável como um num. Se você fizer isso,
a variável pode ter valores inteiros e duplos.

<?code-excerpt "misc/lib/language_tour/built_in_types.dart (declare-num)"?>

```dart
num x = 1; // x can have both int and double values
x += 2.5;
```

Literais inteiros são convertidos automaticamente em doubles quando
necessário:

<?code-excerpt "misc/lib/language_tour/built_in_types.dart (int-to-double)"?>

```dart
double z = 1; // Equivalent to double z = 1.0.
```

Veja como você transforma uma string em um número, ou vice-versa:

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

O tipo  `int`  especifica os operadores tradicionais de deslocamento
bit a bit (`<<`,  `>>`,  `>>>`), complemento (`~`), AND (`&`), OR (`|`) e
XOR (`^`), que são úteis para manipular e mascarar sinalizadores em
campos de bits. Por exemplo:

<?code-excerpt "misc/test/language_tour/built_in_types_test.dart (bit-shifting)"?>

```dart
assert((3 << 1) == 6); // 0011 << 1 == 0110
assert((3 | 4) == 7); // 0011 | 0100 == 0111
assert((3 & 4) == 0); // 0011 & 0100 == 0000
```

Para mais exemplos, veja a seção [operadores bit a bit e de deslocamento][bitwise and shift operator].

Literais numéricos são constantes em tempo de compilação.
Muitas expressões aritméticas também são constantes em tempo de compilação,
contanto que seus operandos sejam constantes em tempo de compilação que
avaliam para números.

<?code-excerpt "misc/lib/language_tour/built_in_types.dart (const-num)"?>

```dart
const msPerSecond = 1000;
const secondsUntilRetry = 5;
const msUntilRetry = secondsUntilRetry * msPerSecond;
```

Para mais informações, veja [Números em Dart][dart-numbers].

<a id="digit-separators"></a>

Você pode usar um ou mais sublinhados (`_`) como separadores de dígitos
para tornar os literais de números longos mais legíveis.
Múltiplos separadores de dígitos permitem agrupamentos de nível superior.

{% comment %}
Attach code excerpt misc/lib/language_tour/built_in_types.dart (digit-separators)
when feature is stable:
{% endcomment %}

```dart
var n1 = 1_000_000;
var n2 = 0.000_000_000_01;
var n3 = 0x00_14_22_01_23_45;  // endereço MAC
var n4 = 555_123_4567;  // Número de telefone dos EUA
var n5 = 100__000_000__000_000;  // cem milhões de milhões!
```

:::version-note
O uso de separadores de dígitos requer uma
[versão de linguagem][language version] de pelo menos 3.6.0.
:::

## Strings

Uma string Dart (objeto `String`) contém uma sequência de unidades de
código UTF-16. Você pode usar aspas simples ou duplas para criar uma
string:

<?code-excerpt "misc/lib/language_tour/built_in_types.dart (quoting)"?>

```dart
var s1 = 'Aspas simples funcionam bem para literais de string.';
var s2 = "Aspas duplas funcionam tão bem quanto.";
var s3 = 'É fácil escapar do delimitador de string.';
var s4 = "É ainda mais fácil usar o outro delimitador.";
```

<a id="string-interpolation"></a>

Você pode colocar o valor de uma expressão dentro de uma string usando
`${`*`expressão`*`}`. Se a expressão for um identificador, você pode
pular o `{}`. Para obter a string correspondente a um objeto, o Dart chama
o método `toString()` do objeto.

<?code-excerpt "misc/test/language_tour/built_in_types_test.dart (string-interpolation)"?>

```dart
var s = 'interpolação de string';

assert('Dart tem $s, o que é muito útil.' ==
    'Dart tem interpolação de string, '
        'o que é muito útil.');
assert('Isso merece todas as letras maiúsculas. '
        '${s.toUpperCase()} é muito útil!' ==
    'Isso merece todas as letras maiúsculas. '
        'INTERPOLAÇÃO DE STRING é muito útil!');
```

:::note
O operador `==` testa se dois objetos são equivalentes.
Duas strings são equivalentes se contiverem a mesma sequência de unidades de código.
:::

Você pode concatenar strings usando literais de string adjacentes ou
o operador `+`:

<?code-excerpt "misc/test/language_tour/built_in_types_test.dart (adjacent-string-literals)"?>

```dart
var s1 = 'String '
    'concatenação'
    " funciona até mesmo em quebras de linha.";
assert(s1 ==
    'String concatenação funciona até mesmo em '
        'quebras de linha.');

var s2 = 'O operador + ' + 'funciona, também.';
assert(s2 == 'O operador + funciona, também.');
```

Para criar uma string de várias linhas, use uma aspa tripla com
aspas simples ou duplas:

<?code-excerpt "misc/lib/language_tour/built_in_types.dart (triple-quotes)"?>

```dart
var s1 = '''
Você pode criar
strings de várias linhas como esta.
''';

var s2 = """Esta também é uma
string de várias linhas.""";
```

Você pode criar uma string "crua" prefixando-a com `r`:

<?code-excerpt "misc/lib/language_tour/built_in_types.dart (raw-strings)"?>

```dart
var s = r'Em uma string crua, nem mesmo \n recebe tratamento especial.';
```

Veja [Runes e aglomerados de grafemas](#runes-and-grapheme-clusters) para
detalhes sobre como expressar caracteres Unicode em uma string.

Literais de string são constantes em tempo de compilação, desde que qualquer
expressão interpolada seja uma constante em tempo de compilação que
avalie para nulo ou um valor numérico, string ou booleano.

<?code-excerpt "misc/lib/language_tour/built_in_types.dart (string-literals)"?>

```dart
// Estes funcionam em uma string const.
const aConstNum = 0;
const aConstBool = true;
const aConstString = 'uma string constante';

// Estes NÃO funcionam em uma string const.
var aNum = 0;
var aBool = true;
var aString = 'uma string';
const aConstList = [1, 2, 3];

const validConstString = '$aConstNum $aConstBool $aConstString';
// const invalidConstString = '$aNum $aBool $aString $aConstList';
```

Para mais informações sobre como usar strings, confira
[Strings e expressões regulares](/libraries/dart-core#strings-and-regular-expressions).

## Booleanos

Para representar valores booleanos, o Dart tem um tipo chamado `bool`.
Apenas dois objetos têm o tipo bool: os literais booleanos `true` e
`false`, que são ambos constantes em tempo de compilação.

A segurança de tipo do Dart significa que você não pode usar código como
<code>if (<em>valorNãoBooleano</em>)</code> ou
<code>assert (<em>valorNãoBooleano</em>)</code>.
Em vez disso, verifique explicitamente os valores, assim:

<?code-excerpt "misc/test/language_tour/built_in_types_test.dart (no-truthy)"?>

```dart
// Verifica se uma string está vazia.
var fullName = '';
assert(fullName.isEmpty);

// Verifica se é zero.
var hitPoints = 0;
assert(hitPoints == 0);

// Verifica se é nulo.
var unicorn = null;
assert(unicorn == null);

// Verifica se é NaN.
var iMeantToDoThis = 0 / 0;
assert(iMeantToDoThis.isNaN);
```

## Runes e aglomerados de grafemas

Em Dart, [runes][runes] expõem os pontos de código Unicode de uma string.
Você pode usar o [pacote characters][characters package] para visualizar ou
manipular caracteres percebidos pelo usuário, também conhecidos como
[aglomerados de grafemas (estendidos) Unicode.][grapheme clusters]

O Unicode define um valor numérico único para cada letra, dígito e símbolo
usado em todos os sistemas de escrita do mundo. Como uma string Dart é uma
sequência de unidades de código UTF-16, expressar pontos de código Unicode
dentro de uma string requer sintaxe especial. A maneira usual de expressar
um ponto de código Unicode é `\uXXXX`, onde XXXX é um valor hexadecimal de
4 dígitos. Por exemplo, o caractere de coração (♥) é `\u2665`. Para
especificar mais ou menos de 4 dígitos hexadecimais, coloque o valor entre
chaves. Por exemplo, o emoji de riso (😆) é `\u{1f606}`.

Se você precisar ler ou escrever caracteres Unicode individuais, use o
getter `characters` definido em String pelo pacote characters. O objeto
[`Characters`][`Characters`] retornado é a string como uma sequência de
aglomerados de grafemas. Aqui está um exemplo de uso da API de caracteres:

<?code-excerpt "misc/lib/language_tour/characters.dart"?>

```dart
import 'package:characters/characters.dart';

void main() {
  var hi = 'Hi 🇩🇰';
  print(hi);
  print('O fim da string: ${hi.substring(hi.length - 1)}');
  print('O último caractere: ${hi.characters.last}');
}
```

A saída, dependendo do seu ambiente, se parece com isto:

```console
$ dart run bin/main.dart
Hi 🇩🇰
O fim da string: ???
O último caractere: 🇩🇰
```

Para obter detalhes sobre como usar o pacote characters para manipular
strings, consulte o [exemplo][characters example] e a [referência da
API][characters API] para o pacote characters.

## Símbolos

Um objeto [`Symbol`][`Symbol`] representa um operador ou identificador
declarado em um programa Dart. Você pode nunca precisar usar símbolos,
mas eles são inestimáveis para APIs que se referem a identificadores pelo
nome, porque a minificação altera os nomes dos identificadores, mas não
os símbolos dos identificadores.

Para obter o símbolo de um identificador, use um literal de símbolo, que é
apenas `#` seguido pelo identificador:

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

Literais de símbolo são constantes em tempo de compilação.

[Records]: /language/records
[Functions]: /language/functions#function-types
[Lists]: /language/collections#lists
[Sets]: /language/collections#sets
[Maps]: /language/collections#maps
[asynchrony support]: /language/async
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
[language version]: /resources/language/evolution#language-versioning
