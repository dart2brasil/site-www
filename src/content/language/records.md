---
ia-translate: true
title: Records
description: Resumo da estrutura de dados record em Dart.
prevpage:
  url: /language/built-in-types
  title: Tipos built-in (embutidos)
nextpage:
  url: /language/collections
  title: Collections (Coleções)
---

:::version-note
  Records exigem uma [versão da linguagem][] de no mínimo 3.0.
:::

Records (registros) são um tipo agregado, anônimo e imutável. Assim como outros [tipos de coleção][],
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
como [parâmetros e argumentos][] funcionam em funções.
Campos posicionais vão diretamente dentro dos parênteses:

<?code-excerpt "language/test/records_test.dart (record-type-declaration)"?>
```dart
// Anotação de tipo de record em uma declaração de variável:
(String, int) record;

// Inicializa com uma expressão de record:
record = ('A string', 123);
```

Em uma anotação de tipo de record, campos nomeados vão dentro de uma seção delimitada por chaves
de pares tipo-e-nome, depois de todos os campos posicionais. Em uma expressão de record,
os nomes vão antes de cada valor de campo com dois pontos após:

<?code-excerpt "language/test/records_test.dart (record-type-named-declaration)"?>
```dart
// Anotação de tipo de record em uma declaração de variável:
({int a, bool b}) record;

// Inicializa com uma expressão de record:
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

// Erro de compilação! Esses records não têm o mesmo tipo.
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

Isso é similar a como parâmetros posicionais
em uma declaração de função ou typedef de função
podem ter nomes, mas esses nomes não afetam a assinatura da função.

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

print(record.$1); // Imprime 'first'
print(record.a); // Imprime 2
print(record.b); // Imprime true
print(record.$2); // Imprime 'last'
```

Para otimizar ainda mais o acesso a campos de record,
confira a página sobre [Patterns (Padrões)][pattern].

## Tipos de Record {:#record-types}

Não há declaração de tipo para tipos de record individuais. Records são estruturalmente
tipados com base nos tipos de seus campos. O _formato_ de um record (o conjunto de seus campos,
os tipos dos campos e seus nomes, se houver) determina unicamente o tipo de um record.

Cada campo em um record tem seu próprio tipo. Tipos de campos podem diferir dentro do mesmo
record. O sistema de tipos está ciente do tipo de cada campo onde quer que ele seja acessado
do record:

<?code-excerpt "language/test/records_test.dart (record-getters-two)"?>
```dart
(num, Object) pair = (42, 'a');

var first = pair.$1; // Tipo estático `num`, tipo em tempo de execução `int`.
var second = pair.$2; // Tipo estático `Object`, tipo em tempo de execução `String`.
```

Considere duas bibliotecas não relacionadas que criam records com o mesmo conjunto de campos.
O sistema de tipos entende que esses records são do mesmo tipo, mesmo que as
bibliotecas não estejam acopladas entre si.

## Igualdade de Record {:#record-equality}

Dois records são iguais se eles têm o mesmo _formato_ (conjunto de campos)
e seus campos correspondentes têm os mesmos valores.
Como a _ordem_ dos campos nomeados não faz parte do formato de um record, a ordem dos
campos nomeados não afeta a igualdade.

Por exemplo:

<?code-excerpt "language/test/records_test.dart (record-shape)"?>
```dart
(int x, int y, int z) point = (1, 2, 3);
(int r, int g, int b) color = (1, 2, 3);

print(point == color); // Imprime 'true'.
```

<?code-excerpt "language/test/records_test.dart (record-shape-mismatch)"?>
```dart
({int x, int y, int z}) point = (x: 1, y: 2, z: 3);
({int r, int g, int b}) color = (r: 1, g: 2, b: 3);

print(point == color); // Imprime 'false'. Lint: Equals em tipos não relacionados.
```

Records automaticamente definem os métodos `hashCode` e `==` com base na estrutura
de seus campos.

## Retornos Múltiplos {:#multiple-returns}

Records permitem que funções retornem múltiplos valores agrupados.
Para recuperar valores de record de um retorno,
[desestruture][] os valores em variáveis locais usando [pattern matching (correspondência de padrão)][pattern].

<?code-excerpt "language/test/records_test.dart (record-multiple-returns)"?>
```dart
// Retorna múltiplos valores em um record:
(String name, int age) userInfo(Map<String, dynamic> json) {
  return (json['name'] as String, json['age'] as int);
}

final json = <String, dynamic>{
  'name': 'Dash',
  'age': 10,
  'color': 'blue',
};

// Desestrutura usando um pattern de record com campos posicionais:
var (name, age) = userInfo(json);

/* Equivalente a:
  var info = userInfo(json);
  var name = info.$1;
  var age  = info.$2;
*/
```

Você também pode desestruturar um record usando seus [campos nomeados](#record-fields),
usando a sintaxe de dois pontos `:`, sobre a qual você pode ler mais na página de
[Tipos de Pattern][]:

<?code-excerpt "language/test/records_test.dart (record-name-destructure)"?>
```dart
({String name, int age}) userInfo(Map<String, dynamic> json)
// ···
// Desestrutura usando um pattern de record com campos nomeados:
final (:name, :age) = userInfo(json);
```

Você pode retornar múltiplos valores de uma função sem records,
mas outros métodos vêm com desvantagens.
Por exemplo, criar uma classe é muito mais verboso, e usar outros tipos de coleção
como `List` ou `Map` perde a segurança de tipo.

:::note
As características de retorno múltiplo e tipo heterogêneo de Records habilitam
a paralelização de futures de tipos diferentes, sobre a qual você pode ler na
documentação de [`dart:async`][].
:::

[language version]: /resources/language/evolution#language-versioning
[collection types]: /language/collections
[pattern]: /language/patterns#destructuring-multiple-returns
[`dart:async` documentation]: /libraries/dart-async#handling-errors-for-multiple-futures
[parameters and arguments]: /language/functions#parameters
[destructure]: /language/patterns#destructuring
[Pattern types]: /language/pattern-types#record
