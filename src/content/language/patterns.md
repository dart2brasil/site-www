---
ia-translate: true
title: Padrões
description: Resumo de padrões em Dart.
prevpage:
  url: /language/type-system
  title: Sistema de tipos
nextpage:
  url: /language/pattern-types
  title: Tipos de padrões
---

:::version-note
Padrões requerem uma [versão de linguagem][language version] de pelo menos 3.0.
:::

Padrões são uma categoria sintática na linguagem Dart, como declarações e expressões.
Um padrão representa a forma de um conjunto de valores que ele pode comparar com valores
reais.

Esta página descreve:
- O que os padrões fazem.
- Onde os padrões são permitidos no código Dart.
- Quais são os casos de uso comuns para padrões.

Para aprender sobre os diferentes tipos de padrões, visite a página
[tipos de padrões][types].

## O que os padrões fazem {:#what-patterns-do}

Em geral, um padrão pode **corresponder** a um valor, **desestruturar** um valor, ou ambos,
dependendo do contexto e da forma do padrão.

Primeiro, a _correspondência de padrões_ permite verificar se um determinado valor:
- Tem uma certa forma.
- É uma certa constante.
- É igual a algo mais.
- Tem um certo tipo.

Em seguida, a _desestruturação de padrões_ fornece uma sintaxe declarativa conveniente para
quebrar esse valor em suas partes constituintes. O mesmo padrão também pode permitir que você
vincule variáveis a algumas ou todas essas partes no processo.

### Correspondência {:#matching}

Um padrão sempre testa um valor para determinar se o valor tem a forma
que você espera. Em outras palavras, você está verificando se o valor _corresponde_ ao padrão.

O que constitui uma correspondência depende de [qual tipo de padrão][types] você está usando.
Por exemplo, um padrão constante corresponde se o valor for igual à constante
do padrão:

<?code-excerpt "language/lib/patterns/switch.dart (constant-pattern)"?>
```dart
switch (number) {
  // Constant pattern matches if 1 == number.
  case 1:
    print('one');
}
```

Muitos padrões fazem uso de subpadrões, às vezes chamados de padrões _externos_ e _internos_, respectivamente.
Padrões correspondem recursivamente em seus subpadrões.
Por exemplo, os campos individuais de qualquer padrão de [tipo coleção][collection-type] podem ser
[padrões de variáveis][variable] ou [padrões constantes][constant]:

<?code-excerpt "language/lib/patterns/switch.dart (list-pattern)"?>
```dart
const a = 'a';
const b = 'b';
switch (obj) {
  // List pattern [a, b] matches obj first if obj is a list with two fields,
  // then if its fields match the constant subpatterns 'a' and 'b'.
  case [a, b]:
    print('$a, $b');
}
```

Para ignorar partes de um valor correspondido, você pode usar um [padrão curinga][wildcard pattern]
como um marcador. No caso de padrões de lista, você pode usar um [elemento resto][rest element].

### Desestruturação {:#destructuring}

Quando um objeto e um padrão correspondem, o padrão pode acessar os dados do objeto
e extraí-los em partes. Em outras palavras, o padrão _desestrutura_ o objeto:

<?code-excerpt "language/lib/patterns/destructuring.dart (list-pattern)"?>
```dart
var numList = [1, 2, 3];
// List pattern [a, b, c] destructures the three elements from numList...
var [a, b, c] = numList;
// ...and assigns them to new variables.
print(a + b + c);
```

Você pode aninhar [qualquer tipo de padrão][types] dentro de um padrão de desestruturação.
Por exemplo, este padrão de caso corresponde e desestrutura uma lista de dois elementos
cujo primeiro elemento é `'a'` ou `'b'`:

<?code-excerpt "language/lib/patterns/destructuring.dart (nested-pattern)"?>
```dart
switch (list) {
  case ['a' || 'b', var c]:
    print(c);
}
```

## Lugares onde os padrões podem aparecer {:#places-patterns-can-appear}

Você pode usar padrões em vários lugares na linguagem Dart:

<a id="pattern-uses"></a>

- [Declarações](#variable-declaration) e [atribuições](#variable-assignment) de variáveis locais
- [laços for e for-in][for]
- [if-case][if] e [switch-case][switch]
- Fluxo de controle em [literais de coleção][collection literals]

Esta seção descreve casos de uso comuns para correspondência e desestruturação com padrões.

### Declaração de variável {:#variable-declaration}

Você pode usar uma _declaração de variável de padrão_ em qualquer lugar que o Dart
permita a declaração de variável local.
O padrão corresponde ao valor à direita da declaração.
Uma vez correspondido, ele desestrutura o valor e o vincula a novas variáveis locais:

<?code-excerpt "language/lib/patterns/destructuring.dart (variable-declaration)"?>
```dart
// Declares new variables a, b, and c.
var (a, [b, c]) = ('str', [1, 2]);
```

Uma declaração de variável de padrão deve começar com `var` ou `final`, seguido
por um padrão.

### Atribuição de variável {:#variable-assignment}

Um _padrão de atribuição de variável_ cai no lado esquerdo de uma atribuição.
Primeiro, ele desestrutura o objeto correspondido. Em seguida, atribui os valores a
variáveis _existentes_, em vez de vincular novas.

Use um padrão de atribuição de variável para trocar os valores de duas variáveis sem
declarar uma terceira temporária:

<?code-excerpt "language/lib/patterns/destructuring.dart (variable-assignment)"?>
```dart
var (a, b) = ('left', 'right');
(b, a) = (a, b); // Swap.
print('$a $b'); // Prints "right left".
```

### Declarações e expressões switch {:#switch-statements-and-expressions}

Toda cláusula case contém um padrão. Isso se aplica a [declarações switch][switch]
e [expressões][expressions], bem como [declarações if-case][if].
Você pode usar [qualquer tipo de padrão][types] em um case.

_Padrões de case_ são [refutáveis][refutable].
Eles permitem que o fluxo de controle:
- Corresponda e desestruture o objeto que está sendo avaliado no switch.
- Continue a execução se o objeto não corresponder.

Os valores que um padrão desestrutura em um case tornam-se variáveis locais.
Seu escopo é apenas dentro do corpo desse case.

<?code-excerpt "language/lib/patterns/switch.dart (switch-statement)"?>
```dart
switch (obj) {
  // Matches if 1 == obj.
  case 1:
    print('one');

  // Matches if the value of obj is between the
  // constant values of 'first' and 'last'.
  case >= first && <= last:
    print('in range');

  // Matches if obj is a record with two fields,
  // then assigns the fields to 'a' and 'b'.
  case (var a, var b):
    print('a = $a, b = $b');

  default:
}
```

<a id="or-pattern-switch"></a>

[Padrões lógico-ou][logical-or] são úteis para fazer com que vários cases compartilhem um
corpo em expressões ou declarações switch:

<?code-excerpt "language/lib/patterns/switch.dart (or-share-body)"?>
```dart
var isPrimary = switch (color) {
  Color.red || Color.yellow || Color.blue => true,
  _ => false
};
```

As declarações switch podem ter vários cases compartilhando um corpo
[sem usar padrões lógico-ou][share], mas eles ainda são
exclusivamente úteis para permitir que vários cases compartilhem uma [cláusula guarda][guard]:

<?code-excerpt "language/lib/patterns/switch.dart (or-share-guard)"?>
```dart
switch (shape) {
  case Square(size: var s) || Circle(size: var s) when s > 0:
    print('Non-empty symmetric shape');
}
```

[Cláusulas guarda][guard] avaliam uma condição arbitrária como parte de um case, sem
sair do switch se a condição for falsa
(como usar uma declaração `if` no corpo do case causaria).

<?code-excerpt "language/lib/control_flow/branches.dart (guard)"?>
```dart
switch (pair) {
  case (int a, int b):
    if (a > b) print('First element greater');
  // If false, prints nothing and exits the switch.
  case (int a, int b) when a > b:
    // If false, prints nothing but proceeds to next case.
    print('First element greater');
  case (int a, int b):
    print('First element not greater');
}
```

### Laços for e for-in {:#for-and-for-in-loops}

Você pode usar padrões em [laços for e for-in][for] para iterar e desestruturar
valores em uma coleção.

Este exemplo usa [desestruturação de objeto][object] em um laço for-in para desestruturar
os objetos [`MapEntry`][`MapEntry`] que uma chamada `<Map>.entries` retorna:

<?code-excerpt "language/lib/patterns/for_in.dart (for-in-pattern)"?>
```dart
Map<String, int> hist = {
  'a': 23,
  'b': 100,
};

for (var MapEntry(key: key, value: count) in hist.entries) {
  print('$key occurred $count times');
}
```

O padrão de objeto verifica se `hist.entries` tem o tipo nomeado `MapEntry`,
e então faz recursão para os subpadrões de campo nomeados `key` e `value`.
Ele chama o getter `key` e o getter `value` no `MapEntry` em cada iteração,
e vincula os resultados às variáveis locais `key` e `count`, respectivamente.

Vincular o resultado de uma chamada de getter a uma variável de mesmo nome é um caso de uso comum,
então padrões de objeto também podem inferir o nome do getter do
[subpadrão de variável][variable]. Isso permite simplificar o padrão de variável
de algo redundante como `key: key` para apenas `:key`:

<?code-excerpt "language/lib/patterns/for_in.dart (for-in-short)"?>
```dart
for (var MapEntry(:key, value: count) in hist.entries) {
  print('$key occurred $count times');
}
```

## Casos de uso para padrões {:#use-cases-for-patterns}

A [seção anterior](#places-patterns-can-appear)
descreve _como_ os padrões se encaixam em outras construções de código Dart.
Você viu alguns casos de uso interessantes como exemplos, como [trocar](#variable-assignment)
os valores de duas variáveis, ou
[desestruturar pares chave-valor](#for-and-for-in-loops)
em um mapa. Esta seção descreve ainda mais casos de uso, respondendo:

- _Quando e por que_ você pode querer usar padrões.
- Que tipos de problemas eles resolvem.
- Quais idiomas eles melhor se adequam.

### Desestruturando múltiplos retornos {:#destructuring-multiple-returns}

Registros permitem agregar e [retornar múltiplos valores][returning multiple values] de uma única
chamada de função. Padrões adicionam a capacidade de desestruturar os campos de um registro
diretamente em variáveis locais, em linha com a chamada de função.

Em vez de declarar individualmente novas variáveis locais para cada campo de registro,
assim:

<?code-excerpt "language/lib/patterns/destructuring.dart (destructure-multiple-returns-1)"?>
```dart
var info = userInfo(json);
var name = info.$1;
var age = info.$2;
```

Você pode desestruturar os campos de um registro que uma função retorna em locais
variáveis usando uma [declaração de variável](#variable-declaration) ou
[padrão de atribuição](#variable-assignment), e um [padrão de registro][record]
como seu subpadrão:

<?code-excerpt "language/lib/patterns/destructuring.dart (destructure-multiple-returns-2)"?>
```dart
var (name, age) = userInfo(json);
```

Para desestruturar um registro com campos nomeados usando um padrão:

<?code-excerpt "language/lib/patterns/destructuring.dart (destructure-multiple-returns-3)"?>
```dart
final (:name, :age) =
    getData(); // For example, return (name: 'doug', age: 25);
```

### Desestruturando instâncias de classe {:#destructuring-class-instances}

[Padrões de objeto][object] correspondem a tipos de objetos nomeados, permitindo que
você desestruture seus dados usando os getters que a classe do objeto já expõe.

Para desestruturar uma instância de uma classe, use o tipo nomeado,
seguido pelas propriedades a serem
desestruturadas entre parênteses:

<?code-excerpt "language/lib/patterns/destructuring.dart (destructure-class-instances)"?>
```dart
final Foo myFoo = Foo(one: 'one', two: 2);
var Foo(:one, :two) = myFoo;
print('one $one, two $two');
```

### Tipos de dados algébricos {:#algebraic-data-types}

A desestruturação de objetos e cases de switch são propícios para escrever
código em um estilo de [tipo de dados algébrico][algebraic data type].
Use este método quando:
- Você tem uma família de tipos relacionados.
- Você tem uma operação que precisa de comportamento específico para cada tipo.
- Você deseja agrupar esse comportamento em um só lugar em vez de espalhá-lo por todos
as diferentes definições de tipo.

Em vez de implementar a operação como um método de instância para cada tipo,
mantenha as variações da operação em uma única função que avalia os subtipos no switch:

<?code-excerpt "language/lib/patterns/algebraic_datatypes.dart (algebraic-datatypes)"?>
```dart
sealed class Shape {}

class Square implements Shape {
  final double length;
  Square(this.length);
}

class Circle implements Shape {
  final double radius;
  Circle(this.radius);
}

double calculateArea(Shape shape) => switch (shape) {
      Square(length: var l) => l * l,
      Circle(radius: var r) => math.pi * r * r
    };
```

### Validando JSON de entrada {:#validating-incoming-json}

Padrões de [Map][map] (Mapa) e [list][list] (lista) funcionam bem para desestruturar pares chave-valor em
dados JSON:

<?code-excerpt "language/lib/patterns/json.dart (json-1)"?>
```dart
var json = {
  'user': ['Lily', 13]
};
var {'user': [name, age]} = json;
```

Se você sabe que os dados JSON têm a estrutura que você espera,
o exemplo anterior é realista.
Mas os dados normalmente vêm de uma fonte externa, como pela rede.
Você precisa validá-los primeiro para confirmar sua estrutura.

Sem padrões, a validação é verbosa:

<?code-excerpt "language/lib/patterns/json.dart (json-2)"?>
```dart
if (json is Map<String, Object?> &&
    json.length == 1 &&
    json.containsKey('user')) {
  var user = json['user'];
  if (user is List<Object> &&
      user.length == 2 &&
      user[0] is String &&
      user[1] is int) {
    var name = user[0] as String;
    var age = user[1] as int;
    print('User $name is $age years old.');
  }
}
```

Um único [padrão de case](#switch-statements-and-expressions)
pode alcançar a mesma validação.
Cases únicos funcionam melhor como declarações [if-case][if].
Padrões fornecem um método mais declarativo e muito menos verboso
de validar JSON:

<?code-excerpt "language/lib/patterns/json.dart (json-3)"?>
```dart
if (json case {'user': [String name, int age]}) {
  print('User $name is $age years old.');
}
```

Este padrão de case valida simultaneamente que:

- `json` é um mapa, porque primeiro deve corresponder ao [padrão de mapa][map] externo para prosseguir.
  - E, como é um mapa, também confirma que `json` não é nulo.
- `json` contém uma chave `user`.
- A chave `user` emparelha com uma lista de dois valores.
- Os tipos dos valores da lista são `String` e `int`.
- As novas variáveis locais para manter os valores são `name` e `age`.


[language version]: /resources/language/evolution#language-versioning
[types]: /language/pattern-types
[collection-type]: /language/collections
[wildcard pattern]: /language/pattern-types#wildcard
[rest element]: /language/pattern-types#rest-element
[null-check pattern]: /language/pattern-types#null-check
[for]: /language/loops#for-loops
[if]: /language/branches#if-case
[switch]: /language/branches#switch-statements
[expressions]: /language/branches#switch-expressions
[collection literals]: /language/collections#control-flow-operators
[null-assert pattern]: /language/pattern-types#null-assert
[record]: /language/pattern-types#record
[returning multiple values]: /language/records#multiple-returns
[refutable]: /resources/glossary#refutable-pattern
[constant]: /language/pattern-types#constant
[list]: /language/pattern-types#list
[map]: /language/pattern-types#map
[variable]: /language/pattern-types#variable
[logical-or]: /language/pattern-types#logical-or
[share]: /language/branches#switch-share
[guard]: /language/branches#guard-clause
[relational]: /language/pattern-types#relational
[check]: /language/pattern-types#null-check
[assert]: /language/pattern-types#null-assert
[object]: /language/pattern-types#object
[`MapEntry`]: {{site.dart-api}}/dart-core/MapEntry-class.html
[algebraic data type]: https://en.wikipedia.org/wiki/Algebraic_data_type
