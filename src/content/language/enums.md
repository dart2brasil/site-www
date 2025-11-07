---
title: Enumerated types
description: Learn about the enum type in Dart.
shortTitle: Enums
prevpage:
  url: /language/mixins
  title: Mixins
nextpage:
  url: /language/dot-shorthands
  title: Dot shorthands
---

Tipos enumerados, frequentemente chamados de _enumerações_ ou _enums_,
são um tipo especial de classe usada para representar
um número fixo de valores constantes.

:::note
Todos os enums automaticamente estendem a classe [`Enum`][].
Eles também são sealed (selados),
o que significa que não podem ser subclassificados, implementados, misturados,
ou instanciados explicitamente de outra forma.

Classes abstratas e mixins podem explicitamente implementar ou estender `Enum`,
mas a menos que sejam então implementados ou misturados em uma declaração enum,
nenhum objeto pode realmente implementar o tipo dessa classe ou mixin.
:::

## Declarando enums simples {:#declaring-simple-enums}

Para declarar um tipo enumerado simples,
use a palavra-chave `enum` e
liste os valores que você quer que sejam enumerados:

<?code-excerpt "misc/lib/language_tour/classes/enum.dart (enum)"?>
```dart
enum Color { red, green, blue }
```

:::tip
Você também pode usar [vírgulas à direita][] ao declarar um tipo enumerado
para ajudar a prevenir erros de copiar e colar.
:::

## Declarando enums aprimorados {:#declaring-enhanced-enums}

Dart também permite que declarações enum declarem classes
com campos, métodos e construtores const
que são limitados a um número fixo de instâncias constantes conhecidas.

Para declarar um enum aprimorado,
siga uma sintaxe similar a [classes][] normais,
mas com alguns requisitos extras:

* Variáveis de instância devem ser `final`,
  incluindo aquelas adicionadas por [mixins][].
* Todos os [construtores geradores][] devem ser constantes.
* [Construtores factory][] só podem retornar
  uma das instâncias enum fixas e conhecidas.
* Nenhuma outra classe pode ser estendida já que [`Enum`] é estendida automaticamente.
* Não pode haver sobrescritas para `index`, `hashCode`, o operador de igualdade `==`.
* Um membro chamado `values` não pode ser declarado em um enum,
  já que entraria em conflito com o getter estático `values` gerado automaticamente.
* Todas as instâncias do enum devem ser declaradas
  no início da declaração,
  e deve haver pelo menos uma instância declarada.

Métodos de instância em um enum aprimorado podem usar `this` para
referenciar o valor enum atual.

Aqui está um exemplo que declara um enum aprimorado
com múltiplas instâncias, variáveis de instância,
getters e uma interface implementada:

<?code-excerpt "misc/lib/language_tour/classes/enum.dart (enhanced)"?>
```dart
enum Vehicle implements Comparable<Vehicle> {
  car(tires: 4, passengers: 5, carbonPerKilometer: 400),
  bus(tires: 6, passengers: 50, carbonPerKilometer: 800),
  bicycle(tires: 2, passengers: 1, carbonPerKilometer: 0);

  const Vehicle({
    required this.tires,
    required this.passengers,
    required this.carbonPerKilometer,
  });

  final int tires;
  final int passengers;
  final int carbonPerKilometer;

  int get carbonFootprint => (carbonPerKilometer / passengers).round();

  bool get isTwoWheeled => this == Vehicle.bicycle;

  @override
  int compareTo(Vehicle other) => carbonFootprint - other.carbonFootprint;
}
```

:::version-note
Enums aprimorados requerem uma [versão de linguagem][] de pelo menos 2.17.
:::

## Usando enums {:#using-enums}

Acesse os valores enumerados como
qualquer outra [variável estática][]:

<?code-excerpt "misc/lib/language_tour/classes/enum.dart (access)"?>
```dart
final favoriteColor = Color.blue;
if (favoriteColor == Color.blue) {
  print('Your favorite color is blue!');
}
```

Cada valor em um enum tem um getter `index`,
que retorna a posição baseada em zero do valor na declaração enum.
Por exemplo, o primeiro valor tem índice 0,
e o segundo valor tem índice 1.

<?code-excerpt "misc/lib/language_tour/classes/enum.dart (index)"?>
```dart
assert(Color.red.index == 0);
assert(Color.green.index == 1);
assert(Color.blue.index == 2);
```

Para obter uma lista de todos os valores enumerados,
use a constante `values` do enum.

<?code-excerpt "misc/lib/language_tour/classes/enum.dart (values)"?>
```dart
List<Color> colors = Color.values;
assert(colors[2] == Color.blue);
```

Você pode usar enums em [comandos switch][], e
você receberá um aviso se não lidar com todos os valores do enum:

<?code-excerpt "misc/lib/language_tour/classes/enum.dart (switch)"?>
```dart
var aColor = Color.blue;

switch (aColor) {
  case Color.red:
    print('Red as roses!');
  case Color.green:
    print('Green as grass!');
  default: // Without this, you see a WARNING.
    print(aColor); // 'Color.blue'
}
```

Se você precisa acessar o nome de um valor enumerado,
como `'blue'` de `Color.blue`,
use a propriedade `.name`:

<?code-excerpt "misc/lib/language_tour/classes/enum.dart (name)"?>
```dart
print(Color.blue.name); // 'blue'
```

Você pode acessar um membro de um valor enum
como faria em um objeto normal:

<?code-excerpt "misc/lib/language_tour/classes/enum.dart (method-call)"?>
```dart
print(Vehicle.car.carbonFootprint);
```

[`Enum`]: {{site.dart-api}}/dart-core/Enum-class.html
[vírgulas à direita]: /language/collections#lists
[classes]: /language/classes
[mixins]: /language/mixins
[construtores geradores]: /language/constructors#constant-constructors
[Construtores factory]: /language/constructors#factory-constructors
[versão de linguagem]: /resources/language/evolution#language-versioning
[variável estática]: /language/classes#class-variables-and-methods
[comandos switch]: /language/branches#switch
