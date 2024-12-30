---
ia-translate: true
title: Coleções
description: Resumo dos diferentes tipos de coleções em Dart.
prevpage:
  url: /language/records
  title: Registros
nextpage:
  url: /language/generics
  title: Genéricos
---

O Dart tem suporte integrado para listas, conjuntos e mapas [coleções][collections].
Para saber mais sobre como configurar os tipos que as coleções contêm,
confira [Genéricos][Generics].

## Listas

Talvez a coleção mais comum em quase todas as linguagens de programação
seja o *array*, ou grupo ordenado de objetos. No Dart, arrays são
objetos [`List`][`List`], então a maioria das pessoas apenas os chama de *listas*.

Literais de lista do Dart são denotados por
uma lista de expressões ou valores separados por vírgula,
entre colchetes (`[]`).
Aqui está uma lista simples do Dart:

<?code-excerpt "misc/lib/language_tour/built_in_types.dart (list-literal)"?>
```dart
var list = [1, 2, 3];
```

:::note
O Dart infere que `list` tem o tipo `List<int>`. Se você tentar adicionar objetos não inteiros a esta lista, o analisador ou o tempo de execução levanta um erro. Para mais informações, leia sobre [inferência de tipo][type inference].
:::

<a id="trailing-comma"></a>
Você pode adicionar uma vírgula após o último item em um literal de coleção do Dart.
Essa _vírgula à direita_ não afeta a coleção,
mas pode ajudar a evitar erros de copiar e colar.

<?code-excerpt "misc/lib/language_tour/built_in_types.dart (trailing-commas)"?>
```dart
var list = [
  'Carro',
  'Barco',
  'Avião',
];
```

As listas usam indexação baseada em zero, onde 0 é o índice do primeiro valor
e `list.length - 1` é o índice do último valor.
Você pode obter o tamanho de uma lista usando a propriedade `.length`
e acessar os valores de uma lista usando o operador de subscrito (`[]`):

<?code-excerpt "misc/test/language_tour/built_in_types_test.dart (list-indexing)"?>
```dart
var list = [1, 2, 3];
assert(list.length == 3);
assert(list[1] == 2);

list[1] = 1;
assert(list[1] == 1);
```

Para criar uma lista que seja uma constante de tempo de compilação,
adicione `const` antes do literal da lista:

<?code-excerpt "misc/lib/language_tour/built_in_types.dart (const-list)"?>
```dart
var constantList = const [1, 2, 3];
// constantList[1] = 1; // Esta linha causará um erro.
```

Para mais informações sobre listas, consulte a seção Listas da
documentação [`dart:core`](/libraries/dart-core#lists).

## Conjuntos

Um conjunto no Dart é uma coleção não ordenada de itens únicos.
O suporte do Dart para conjuntos é fornecido por literais de conjunto e o
tipo [`Set`][`Set`].

Aqui está um conjunto simples do Dart, criado usando um literal de conjunto:

<?code-excerpt "misc/lib/language_tour/built_in_types.dart (set-literal)"?>
```dart
var halogens = {'flúor', 'cloro', 'bromo', 'iodo', 'astato'};
```

:::note
O Dart infere que `halogens` tem o tipo `Set<String>`. Se você tentar adicionar o tipo errado de valor ao conjunto, o analisador ou o tempo de execução levanta um erro. Para mais informações, leia sobre
[inferência de tipo.](/language/type-system#type-inference)
:::

Para criar um conjunto vazio, use `{}` precedido por um argumento de tipo,
ou atribua `{}` a uma variável do tipo `Set`:

<?code-excerpt "misc/lib/language_tour/built_in_types.dart (set-vs-map)"?>
```dart
var names = <String>{};
// Set<String> names = {}; // Isso também funciona.
// var names = {}; // Cria um mapa, não um conjunto.
```

:::note Conjunto ou mapa?
A sintaxe para literais de mapa é semelhante à de literais de conjunto. Como os literais de mapa vieram primeiro, `{}` assume o tipo `Map` por padrão. Se você esquecer a anotação de tipo em `{}` ou a variável à qual ela é atribuída, o Dart cria um objeto do tipo `Map<dynamic, dynamic>`.
:::

Adicione itens a um conjunto existente usando os métodos `add()` ou `addAll()`:

<?code-excerpt "misc/lib/language_tour/built_in_types.dart (set-add-items)"?>
```dart
var elements = <String>{};
elements.add('flúor');
elements.addAll(halogens);
```

Use `.length` para obter o número de itens no conjunto:

<?code-excerpt "misc/test/language_tour/built_in_types_test.dart (set-length)"?>
```dart
var elements = <String>{};
elements.add('flúor');
elements.addAll(halogens);
assert(elements.length == 5);
```

Para criar um conjunto que seja uma constante de tempo de compilação,
adicione `const` antes do literal do conjunto:

<?code-excerpt "misc/lib/language_tour/built_in_types.dart (const-set)"?>
```dart
final constantSet = const {
  'flúor',
  'cloro',
  'bromo',
  'iodo',
  'astato',
};
// constantSet.add('hélio'); // Esta linha causará um erro.
```

Para mais informações sobre conjuntos, consulte a seção Conjuntos da
documentação [`dart:core`](/libraries/dart-core#sets).

## Mapas

Em geral, um mapa é um objeto que associa chaves e valores. Ambos
chaves e valores podem ser qualquer tipo de objeto. Cada *chave* ocorre apenas uma vez,
mas você pode usar o mesmo *valor* várias vezes. O suporte do Dart para mapas
é fornecido por literais de mapa e o tipo [`Map`][`Map`].

Aqui estão alguns mapas simples do Dart, criados usando literais de mapa:

<?code-excerpt "misc/lib/language_tour/built_in_types.dart (map-literal)"?>
```dart
var gifts = {
  // Chave:    Valor
  'primeiro': 'perdiz',
  'segundo': 'rola',
  'quinto': 'anéis de ouro'
};

var nobleGases = {
  2: 'hélio',
  10: 'neônio',
  18: 'argônio',
};
```

:::note
O Dart infere que `gifts` tem o tipo `Map<String, String>` e `nobleGases`
tem o tipo `Map<int, String>`. Se você tentar adicionar o tipo errado de valor a qualquer um dos mapas, o analisador ou o tempo de execução levanta um erro. Para mais informações, leia sobre [inferência de tipo][type inference].
:::

Você pode criar os mesmos objetos usando um construtor Map:

<?code-excerpt "misc/lib/language_tour/built_in_types.dart (map-constructor)"?>
```dart
var gifts = Map<String, String>();
gifts['primeiro'] = 'perdiz';
gifts['segundo'] = 'rola';
gifts['quinto'] = 'anéis de ouro';

var nobleGases = Map<int, String>();
nobleGases[2] = 'hélio';
nobleGases[10] = 'neônio';
nobleGases[18] = 'argônio';
```

:::note
Se você vem de uma linguagem como C# ou Java, pode esperar ver `new Map()`
em vez de apenas `Map()`. No Dart, a palavra-chave `new` é opcional.
Para detalhes, veja [Usando construtores][Using constructors].
:::

Adicione um novo par chave-valor a um mapa existente
usando o operador de atribuição de subscrito (`[]=`):

<?code-excerpt "misc/lib/language_tour/built_in_types.dart (map-add-item)"?>
```dart
var gifts = {'primeiro': 'perdiz'};
gifts['quarto'] = 'pássaros chamando'; // Adiciona um par chave-valor
```

Recupere um valor de um mapa usando o operador de subscrito (`[]`):

<?code-excerpt "misc/test/language_tour/built_in_types_test.dart (map-retrieve-item)"?>
```dart
var gifts = {'primeiro': 'perdiz'};
assert(gifts['primeiro'] == 'perdiz');
```

Se você procurar por uma chave que não está em um mapa, você receberá `null` em retorno:

<?code-excerpt "misc/test/language_tour/built_in_types_test.dart (map-missing-key)"?>
```dart
var gifts = {'primeiro': 'perdiz'};
assert(gifts['quinto'] == null);
```

Use `.length` para obter o número de pares chave-valor no mapa:

<?code-excerpt "misc/test/language_tour/built_in_types_test.dart (map-length)"?>
```dart
var gifts = {'primeiro': 'perdiz'};
gifts['quarto'] = 'pássaros chamando';
assert(gifts.length == 2);
```

Para criar um mapa que seja uma constante de tempo de compilação,
adicione `const` antes do literal do mapa:

<?code-excerpt "misc/lib/language_tour/built_in_types.dart (const-map)"?>
```dart
final constantMap = const {
  2: 'hélio',
  10: 'neônio',
  18: 'argônio',
};

// constantMap[2] = 'Hélio'; // Esta linha causará um erro.
```

Para mais informações sobre mapas, consulte a seção Mapas da
documentação [`dart:core`](/libraries/dart-core#maps).

## Operadores

### Operadores de propagação

O Dart suporta o **operador de propagação** (`...`) e o
**operador de propagação nulo-ciente** (`...?`) em literais de lista, mapa e conjunto.
Os operadores de propagação fornecem uma maneira concisa de inserir vários valores em uma coleção.

Por exemplo, você pode usar o operador de propagação (`...`) para inserir
todos os valores de uma lista em outra lista:

<?code-excerpt "misc/test/language_tour/built_in_types_test.dart (list-spread)"?>
```dart
var list = [1, 2, 3];
var list2 = [0, ...list];
assert(list2.length == 4);
```

Se a expressão à direita do operador de propagação puder ser nula,
você pode evitar exceções usando um operador de propagação nulo-ciente (`...?`):

<?code-excerpt "misc/test/language_tour/built_in_types_test.dart (list-null-spread)"?>
```dart
var list2 = [0, ...?list];
assert(list2.length == 1);
```

Para mais detalhes e exemplos de como usar o operador de propagação, veja a [proposta do operador de propagação][spread proposal].

<a id="collection-operators"></a>
### Operadores de fluxo de controle

O Dart oferece **coleção if** e **coleção for** para uso em literais de lista, mapa
e conjunto. Você pode usar esses operadores para construir coleções usando
condicionais (`if`) e repetição (`for`).

Aqui está um exemplo de como usar **coleção if**
para criar uma lista com três ou quatro itens:

<?code-excerpt "misc/test/language_tour/built_in_types_test.dart (list-if)"?>
```dart
var nav = ['Home', 'Móveis', 'Plantas', if (promoActive) 'Outlet'];
```

O Dart também suporta [if-case][if-case] dentro de literais de coleção:

```dart
var nav = ['Home', 'Móveis', 'Plantas', if (login case 'Manager') 'Inventário'];
```

Aqui está um exemplo de como usar **coleção for**
para manipular os itens de uma lista antes de
adicioná-los a outra lista:

<?code-excerpt "misc/test/language_tour/built_in_types_test.dart (list-for)"?>
```dart
var listOfInts = [1, 2, 3];
var listOfStrings = ['#0', for (var i in listOfInts) '#$i'];
assert(listOfStrings[1] == '#1');
```

Para mais detalhes e exemplos de como usar coleção `if` e `for`, veja a [proposta de coleções de fluxo de controle][collections proposal].

[collections]: /libraries/dart-core#collections
[type inference]: /language/type-system#type-inference
[`List`]: {{site.dart-api}}/dart-core/List-class.html
[`Map`]: {{site.dart-api}}/dart-core/Map-class.html
[Using constructors]: /language/classes#using-constructors
[collections proposal]: {{site.repo.dart.lang}}/blob/main/accepted/2.3/control-flow-collections/feature-specification.md
[spread proposal]: {{site.repo.dart.lang}}/blob/main/accepted/2.3/spread-collections/feature-specification.md
[generics]: /language/generics
[`Set`]: {{site.dart-api}}/dart-core/Set-class.html
[if-case]: /language/branches#if-case
