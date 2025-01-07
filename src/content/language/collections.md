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

Dart possui suporte interno para [coleções][collections] do tipo lista, set e map.
Para saber mais sobre como configurar os tipos que as coleções contêm,
confira [Generics][generics].

## Listas {:#lists}

Talvez a coleção mais comum em quase todas as linguagens de programação
seja o *array* (matriz), ou grupo ordenado de objetos. Em Dart, arrays são
objetos [`List`][`List`] , então a maioria das pessoas apenas os chama de *listas*.

Literais de lista em Dart são denotados por
uma lista separada por vírgulas de expressões ou valores,
envolvida em colchetes (`[]`).
Aqui está uma lista simples de Dart:

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
var list = [
  'Carro',
  'Barco',
  'Avião',
];
```

Listas usam indexação baseada em zero, onde 0 é o índice do primeiro valor
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

Para criar uma lista que seja uma constante em tempo de compilação,
adicione `const` antes do literal da lista:

<?code-excerpt "misc/lib/language_tour/built_in_types.dart (const-list)"?>
```dart
var constantList = const [1, 2, 3];
// constantList[1] = 1; // Esta linha causará um erro.
```

Para mais informações sobre listas, consulte a seção Listas da
documentação [`dart:core`](/libraries/dart-core#lists).

## Sets {:#sets}

Um set em Dart é uma coleção não ordenada de itens únicos.
O suporte do Dart para sets é fornecido por literais de set e pelo
tipo [`Set`][`Set`].

Aqui está um set simples do Dart, criado usando um literal de set:

<?code-excerpt "misc/lib/language_tour/built_in_types.dart (set-literal)"?>
```dart
var halogens = {'flúor', 'cloro', 'bromo', 'iodo', 'astato'};
```

:::note
Dart infere que `halogens` tem o tipo `Set<String>`. Se você tentar adicionar
o tipo errado de valor ao set, o analisador ou o tempo de execução gera um erro. Para
mais informações, leia sobre
[inferência de tipo.](/language/type-system#type-inference)
:::

Para criar um set vazio, use `{}` precedido por um argumento de tipo,
ou atribua `{}` a uma variável do tipo `Set`:

<?code-excerpt "misc/lib/language_tour/built_in_types.dart (set-vs-map)"?>
```dart
var names = <String>{};
// Set<String> names = {}; // Isso também funciona.
// var names = {}; // Cria um map, não um set.
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
elements.add('flúor');
elements.addAll(halogens);
```

Use `.length` para obter o número de itens no set:

<?code-excerpt "misc/test/language_tour/built_in_types_test.dart (set-length)"?>
```dart
var elements = <String>{};
elements.add('flúor');
elements.addAll(halogens);
assert(elements.length == 5);
```

Para criar um set que seja uma constante em tempo de compilação,
adicione `const` antes do literal do set:

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

Para mais informações sobre sets, consulte a seção Sets da
documentação [`dart:core`](/libraries/dart-core#sets).

## Maps {:#maps}

Em geral, um map é um objeto que associa chaves e valores. Tanto
chaves quanto valores podem ser qualquer tipo de objeto. Cada *chave* ocorre apenas uma vez,
mas você pode usar o mesmo *valor* várias vezes. O suporte do Dart para maps
é fornecido por literais de map e pelo tipo [`Map`][`Map`].

Aqui estão alguns maps simples do Dart, criados usando literais de map:

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
Dart infere que `gifts` tem o tipo `Map<String, String>` e `nobleGases`
tem o tipo `Map<int, String>`. Se você tentar adicionar o tipo errado de valor a
qualquer um dos maps, o analisador ou o tempo de execução gera um erro. Para mais informações,
leia sobre [inferência de tipo][type inference].
:::

Você pode criar os mesmos objetos usando um construtor `Map`:

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
em vez de apenas `Map()`. Em Dart, a palavra-chave `new` é opcional.
Para detalhes, veja [Usando construtores][Usando construtores].
:::

Adicione um novo par chave-valor a um map existente
usando o operador de atribuição de subscrito (`[]=`):

<?code-excerpt "misc/lib/language_tour/built_in_types.dart (map-add-item)"?>
```dart
var gifts = {'primeiro': 'perdiz'};
gifts['quarto'] = 'pássaros cantando'; // Adiciona um par chave-valor
```

Recupere um valor de um map usando o operador de subscrito (`[]`):

<?code-excerpt "misc/test/language_tour/built_in_types_test.dart (map-retrieve-item)"?>
```dart
var gifts = {'primeiro': 'perdiz'};
assert(gifts['primeiro'] == 'perdiz');
```

Se você procurar por uma chave que não está em um map, você recebe `null` em retorno:

<?code-excerpt "misc/test/language_tour/built_in_types_test.dart (map-missing-key)"?>
```dart
var gifts = {'primeiro': 'perdiz'};
assert(gifts['quinto'] == null);
```

Use `.length` para obter o número de pares chave-valor no map:

<?code-excerpt "misc/test/language_tour/built_in_types_test.dart (map-length)"?>
```dart
var gifts = {'primeiro': 'perdiz'};
gifts['quarto'] = 'pássaros cantando';
assert(gifts.length == 2);
```

Para criar um map que seja uma constante em tempo de compilação,
adicione `const` antes do literal do map:

<?code-excerpt "misc/lib/language_tour/built_in_types.dart (const-map)"?>
```dart
final constantMap = const {
  2: 'hélio',
  10: 'neônio',
  18: 'argônio',
};

// constantMap[2] = 'Hélio'; // Esta linha causará um erro.
```

Para mais informações sobre maps, consulte a seção Maps da
documentação [`dart:core`](/libraries/dart-core#maps).

## Operadores {:#operators}

### Operadores Spread {:#spread-operators}

Dart oferece suporte ao **operador spread** (`...`) e ao
**operador spread com reconhecimento de nulo** (`...?`) em literais de lista, map e set.
Os operadores spread fornecem uma maneira concisa de inserir vários valores em uma coleção.

Por exemplo, você pode usar o operador spread (`...`) para inserir
todos os valores de uma lista em outra lista:

<?code-excerpt "misc/test/language_tour/built_in_types_test.dart (list-spread)"?>
```dart
var list = [1, 2, 3];
var list2 = [0, ...list];
assert(list2.length == 4);
```

Se a expressão à direita do operador spread puder ser nula,
você pode evitar exceções usando um operador spread com reconhecimento de nulo (`...?`):

<?code-excerpt "misc/test/language_tour/built_in_types_test.dart (list-null-spread)"?>
```dart
var list2 = [0, ...?list];
assert(list2.length == 1);
```

Para mais detalhes e exemplos de como usar o operador spread, veja a
[proposta do operador spread][spread proposal].

<a id="collection-operators"></a>
### Operadores de fluxo de controle {:#control-flow-operators}

Dart oferece **collection if** e **collection for** para uso em literais de lista, map,
e set. Você pode usar esses operadores para construir coleções usando
condicionais (`if`) e repetição (`for`).

Aqui está um exemplo de como usar **collection if**
para criar uma lista com três ou quatro itens nela:

<?code-excerpt "misc/test/language_tour/built_in_types_test.dart (list-if)"?>
```dart
var nav = ['Home', 'Móveis', 'Plantas', if (promoActive) 'Outlet'];
```

Dart também suporta [if-case][if-case] dentro de literais de coleção:

```dart
var nav = ['Home', 'Móveis', 'Plantas', if (login case 'Gerente') 'Estoque'];
```

Aqui está um exemplo de como usar **collection for**
para manipular os itens de uma lista antes de
adicioná-los a outra lista:

<?code-excerpt "misc/test/language_tour/built_in_types_test.dart (list-for)"?>
```dart
var listOfInts = [1, 2, 3];
var listOfStrings = ['#0', for (var i in listOfInts) '#$i'];
assert(listOfStrings[1] == '#1');
```

Para mais detalhes e exemplos de como usar `if` e `for` em collections, veja a
[proposta de collections com fluxo de controle][collections proposal].

[collections]: /libraries/dart-core#collections
[type inference]: /language/type-system#type-inference
[`List`]: {{site.dart-api}}/dart-core/List-class.html
[`Map`]: {{site.dart-api}}/dart-core/Map-class.html
[Usando construtores]: /language/classes#using-constructors
[collections proposal]: {{site.repo.dart.lang}}/blob/main/accepted/2.3/control-flow-collections/feature-specification.md
[spread proposal]: {{site.repo.dart.lang}}/blob/main/accepted/2.3/spread-collections/feature-specification.md
[generics]: /language/generics
[`Set`]: {{site.dart-api}}/dart-core/Set-class.html
[if-case]: /language/branches#if-case
