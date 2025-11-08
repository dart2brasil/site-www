---
ia-translate: true
title: Patterns
description: Resumo de patterns em Dart.
prevpage:
  url: /language/type-system
  title: Type system
nextpage:
  url: /language/pattern-types
  title: Pattern types
---

:::version-note
Patterns requerem uma [language version][] de pelo menos 3.0.
:::

Patterns são uma categoria sintática na linguagem Dart, como statements e expressions.
Um pattern representa a forma de um conjunto de valores que pode corresponder contra valores
reais.

Esta página descreve:
- O que patterns fazem.
- Onde patterns são permitidos no código Dart.
- Quais são os casos de uso comuns para patterns.

Para aprender sobre os diferentes tipos de patterns, visite a página de [tipos de pattern][types].

## O que patterns fazem {:#what-patterns-do}

Em geral, um pattern pode **corresponder** a um valor, **desestruturar** um valor, ou ambos,
dependendo do contexto e da forma do pattern.

Primeiro, _correspondência de pattern_ permite verificar se um determinado valor:
- Tem uma certa forma.
- É uma certa constante.
- É igual a algo mais.
- Tem um certo tipo.

Então, _desestruturação de pattern_ fornece uma sintaxe declarativa conveniente para
quebrar esse valor em suas partes constituintes. O mesmo pattern também pode permitir que você
vincule variáveis a algumas ou todas essas partes no processo.

### Correspondência {:#matching}

Um pattern sempre testa contra um valor para determinar se o valor tem a forma
que você espera. Em outras palavras, você está verificando se o valor _corresponde_ ao pattern.

O que constitui uma correspondência depende de [que tipo de pattern][types] você está usando.
Por exemplo, um pattern constant corresponde se o valor for igual à constante do pattern:

<?code-excerpt "language/lib/patterns/switch.dart (constant-pattern)"?>
```dart
switch (number) {
  // Constant pattern matches if 1 == number.
  case 1:
    print('one');
}
```

Muitos patterns fazem uso de subpatterns, às vezes chamados de patterns _externos_ e _internos_,
respectivamente. Patterns correspondem recursivamente em seus subpatterns.
Por exemplo, os campos individuais de qualquer pattern de [tipo coleção][collection-type] podem ser
[patterns variable][variable] ou [patterns constant][constant]:

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

Para ignorar partes de um valor correspondido, você pode usar um [pattern wildcard][]
como um espaço reservado. No caso de patterns list, você pode usar um [elemento rest][rest element].

### Desestruturação {:#destructuring}

Quando um objeto e pattern correspondem, o pattern pode então acessar os dados do objeto
e extraí-los em partes. Em outras palavras, o pattern _desestrutura_ o objeto:

<?code-excerpt "language/lib/patterns/destructuring.dart (list-pattern)"?>
```dart
var numList = [1, 2, 3];
// List pattern [a, b, c] destructures the three elements from numList...
var [a, b, c] = numList;
// ...and assigns them to new variables.
print(a + b + c);
```

Você pode aninhar [qualquer tipo de pattern][types] dentro de um pattern de desestruturação.
Por exemplo, este case pattern corresponde e desestrutura uma lista de dois elementos cujo primeiro
elemento é `'a'` ou `'b'`:

<?code-excerpt "language/lib/patterns/destructuring.dart (nested-pattern)"?>
```dart
switch (list) {
  case ['a' || 'b', var c]:
    print(c);
}
```

## Lugares onde patterns podem aparecer {:#places-patterns-can-appear}

Você pode usar patterns em vários lugares na linguagem Dart:

<a id="pattern-uses"></a>

- [Declarações](#variable-declaration) e [atribuições](#variable-assignment) de variáveis locais
- [Loops for e for-in][for]
- [if-case][if] e [switch-case][switch]
- Fluxo de controle em [literais de coleção][collection literals]

Esta seção descreve casos de uso comuns para correspondência e desestruturação com patterns.

### Declaração de variável {:#variable-declaration}

Você pode usar uma _declaração de variável pattern_ em qualquer lugar que Dart permita declaração de variável
local.
O pattern corresponde contra o valor à direita da declaração.
Uma vez correspondido, ele desestrutura o valor e o vincula a novas variáveis locais:

<?code-excerpt "language/lib/patterns/destructuring.dart (variable-declaration)"?>
```dart
// Declares new variables a, b, and c.
var (a, [b, c]) = ('str', [1, 2]);
```

Uma declaração de variável pattern deve começar com `var` ou `final`, seguido
por um pattern.

### Atribuição de variável {:#variable-assignment}

Um _pattern de atribuição de variável_ fica no lado esquerdo de uma atribuição.
Primeiro, ele desestrutura o objeto correspondido. Então atribui os valores a
variáveis _existentes_, em vez de vincular novas.

Use um pattern de atribuição de variável para trocar os valores de duas variáveis sem
declarar uma terceira temporária:

<?code-excerpt "language/lib/patterns/destructuring.dart (variable-assignment)"?>
```dart
var (a, b) = ('left', 'right');
(b, a) = (a, b); // Swap.
print('$a $b'); // Prints "right left".
```

### Switch statements e expressions {:#switch-statements-and-expressions}

Toda cláusula case contém um pattern. Isso se aplica a [switch statements][switch]
e [expressions][], assim como [if-case statements][if].
Você pode usar [qualquer tipo de pattern][types] em um case.

_Case patterns_ são [refutáveis][refutable].
Eles permitem que o fluxo de controle:
- Corresponda e desestruture o objeto sendo verificado no switch.
- Continue a execução se o objeto não corresponder.

Os valores que um pattern desestrutura em um case se tornam variáveis locais.
Seu escopo está apenas dentro do corpo desse case.

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

[Patterns logical-or][logical-or] são úteis para ter múltiplos cases compartilhando um
corpo em switch expressions ou statements:

<?code-excerpt "language/lib/patterns/switch.dart (or-share-body)"?>
```dart
var isPrimary = switch (color) {
  Color.red || Color.yellow || Color.blue => true,
  _ => false,
};
```

Switch statements podem ter múltiplos cases compartilhando um corpo
[sem usar patterns logical-or][share], mas eles ainda são
unicamente úteis por permitirem múltiplos cases compartilharem uma [guard][]:

<?code-excerpt "language/lib/patterns/switch.dart (or-share-guard)"?>
```dart
switch (shape) {
  case Square(size: var s) || Circle(size: var s) when s > 0:
    print('Non-empty symmetric shape');
}
```

[Cláusulas guard][guard] avaliam uma condição arbitrária como parte de um case, sem
sair do switch se a condição for falsa
(como usar um statement `if` no corpo do case causaria).

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

### Loops For e for-in {:#for-and-for-in-loops}

Você pode usar patterns em [loops for e for-in][for] para iterar sobre e desestruturar
valores em uma coleção.

Este exemplo usa [desestruturação de objeto][object] em um loop for-in para desestruturar
os objetos [`MapEntry`][] que uma chamada `<Map>.entries` retorna:

<?code-excerpt "language/lib/patterns/for_in.dart (for-in-pattern)"?>
```dart
Map<String, int> hist = {'a': 23, 'b': 100};

for (var MapEntry(key: key, value: count) in hist.entries) {
  print('$key occurred $count times');
}
```

O pattern object verifica que `hist.entries` tem o tipo nomeado `MapEntry`,
e então recursa nos subpatterns de campo nomeados `key` e `value`.
Ele chama o getter `key` e o getter `value` no `MapEntry` em cada iteração,
e vincula os resultados às variáveis locais `key` e `count`, respectivamente.

Vincular o resultado de uma chamada de getter a uma variável com o mesmo nome é um
caso de uso comum, então patterns object também podem inferir o nome do getter do
[subpattern variable][variable]. Isso permite simplificar o pattern variable
de algo redundante como `key: key` para apenas `:key`:

<?code-excerpt "language/lib/patterns/for_in.dart (for-in-short)"?>
```dart
for (var MapEntry(:key, value: count) in hist.entries) {
  print('$key occurred $count times');
}
```

## Casos de uso para patterns {:#use-cases-for-patterns}

A [seção anterior](#places-patterns-can-appear)
descreve _como_ patterns se encaixam em outros construtos de código Dart.
Você viu alguns exemplos de casos de uso interessantes, como [trocar](#variable-assignment)
os valores de duas variáveis, ou
[desestruturar pares chave-valor](#for-and-for-in-loops)
em um map. Esta seção descreve ainda mais casos de uso, respondendo:

- _Quando e por que_ você pode querer usar patterns.
- Que tipos de problemas eles resolvem.
- Quais idiomas eles se adequam melhor.

### Desestruturando múltiplos retornos {:#destructuring-multiple-returns}

Records permitem agregar e [retornar múltiplos valores][] de uma única
chamada de função. Patterns adicionam a habilidade de desestruturar os campos de um record
diretamente em variáveis locais, em linha com a chamada de função.

Em vez de declarar individualmente novas variáveis locais para cada campo do record,
assim:

<?code-excerpt "language/lib/patterns/destructuring.dart (destructure-multiple-returns-1)"?>
```dart
var info = userInfo(json);
var name = info.$1;
var age = info.$2;
```

Você pode desestruturar os campos de um record que uma função retorna em variáveis
locais usando uma [declaração de variável](#variable-declaration) ou
[pattern de atribuição](#variable-assignment), e um [pattern record][record]
como seu subpattern:

<?code-excerpt "language/lib/patterns/destructuring.dart (destructure-multiple-returns-2)"?>
```dart
var (name, age) = userInfo(json);
```

Para desestruturar um record com campos nomeados usando um pattern:

<?code-excerpt "language/lib/patterns/destructuring.dart (destructure-multiple-returns-3)"?>
```dart
final (:name, :age) =
    getData(); // For example, return (name: 'doug', age: 25);
```

### Desestruturando instâncias de classe {:#destructuring-class-instances}

[Patterns object][object] correspondem contra tipos de objeto nomeados, permitindo
que você desestruture seus dados usando os getters que a classe do objeto já expõe.

Para desestruturar uma instância de uma classe, use o tipo nomeado,
seguido pelas propriedades a
desestruturar entre parênteses:

<?code-excerpt "language/lib/patterns/destructuring.dart (destructure-class-instances)"?>
```dart
final Foo myFoo = Foo(one: 'one', two: 2);
var Foo(:one, :two) = myFoo;
print('one $one, two $two');
```

### Tipos de dados algébricos {:#algebraic-data-types}

Desestruturação de objetos e cases de switch são propícios para escrever
código em estilo de [tipo de dados algébrico][algebraic data type].
Use este método quando:
- Você tem uma família de tipos relacionados.
- Você tem uma operação que precisa de comportamento específico para cada tipo.
- Você quer agrupar esse comportamento em um lugar em vez de espalhá-lo por todos
as diferentes definições de tipo.

Em vez de implementar a operação como um método de instância para cada tipo,
mantenha as variações da operação em uma única função que faz switch sobre os subtipos:

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
  Circle(radius: var r) => math.pi * r * r,
};
```

### Validando JSON de entrada {:#validating-incoming-json}

Patterns [map][] e [list][] funcionam bem para desestruturar pares chave-valor em
dados desserializados, como dados analisados de JSON:

<?code-excerpt "language/lib/patterns/json.dart (json-1)"?>
```dart
var data = {
  'user': ['Lily', 13],
};
var {'user': [name, age]} = data;
```

Se você sabe que os dados JSON têm a estrutura que você espera,
o exemplo anterior é realista.
Mas os dados normalmente vêm de uma fonte externa, como pela rede.
Você precisa validá-los primeiro para confirmar sua estrutura.

Sem patterns, validação é verbosa:

<?code-excerpt "language/lib/patterns/json.dart (json-2)"?>
```dart
if (data is Map<String, Object?> &&
    data.length == 1 &&
    data.containsKey('user')) {
  var user = data['user'];
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

Um único [case pattern](#switch-statements-and-expressions)
pode alcançar a mesma validação.
Cases únicos funcionam melhor como [if-case][if] statements.
Patterns fornecem um método mais declarativo, e muito menos verboso
de validar JSON:

<?code-excerpt "language/lib/patterns/json.dart (json-3)"?>
```dart
if (data case {'user': [String name, int age]}) {
  print('User $name is $age years old.');
}
```

Este case pattern valida simultaneamente que:

- `json` é um map, porque ele deve primeiro corresponder ao [pattern map][map] externo para prosseguir.
  - E, como é um map, também confirma que `json` não é null.
- `json` contém uma chave `user`.
- A chave `user` é pareada com uma lista de dois valores.
- Os tipos dos valores da lista são `String` e `int`.
- As novas variáveis locais para armazenar os valores são `name` e `age`.


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
[retornar múltiplos valores]: /language/records#multiple-returns
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
