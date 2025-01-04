---
ia-translate: true
title: Métodos
description: Aprenda sobre métodos em Dart.
prevpage:
  url: /language/constructors
  title: Construtores
nextpage:
  url: /language/extend
  title: Estender uma classe
---

<?code-excerpt replace="/ *\/\/\s+ignore_for_file:[^\n]+\n//g; /(^|\n) *\/\/\s+ignore:[^\n]+\n/$1/g; /(\n[^\n]+) *\/\/\s+ignore:[^\n]+\n/$1\n/g"?>

Métodos são funções que fornecem comportamento para um objeto.

## Métodos de instância {:#instance-methods}

Métodos de instância em objetos podem acessar variáveis de instância e `this` (este).
O método `distanceTo()` (distânciaPara()) no exemplo a seguir é um exemplo de um
método de instância:

<?code-excerpt "misc/lib/language_tour/classes/point.dart (class-with-distance-to)" plaster="none"?>
```dart
import 'dart:math';

class Point {
  final double x;
  final double y;

  // Define as variáveis de instância x e y
  // antes da execução do corpo do construtor.
  Point(this.x, this.y);

  double distanceTo(Point other) {
    var dx = x - other.x;
    var dy = y - other.y;
    return sqrt(dx * dx + dy * dy);
  }
}
```

## Operadores {:#operators}

A maioria dos operadores são métodos de instância com nomes especiais.
Dart permite que você defina operadores com os seguintes nomes:

|       |      |      |      |       |      |
|-------|------|------|------|-------|------|
| `<`   | `>`  | `<=` | `>=` | `==`  | `~`  |
| `-`   | `+`  | `/`  | `~/` | `*`   | `%`  |
| `\|`  | `ˆ`  | `&`  | `<<` | `>>>` | `>>` |
| `[]=` | `[]` |      |      |       |      |

{:.table}

:::note
Você pode ter notado que alguns [operadores][], como `!=`, não estão na
lista de nomes. Esses operadores não são métodos de instância.
Seu comportamento é interno ao Dart.
:::

{%- comment %}
  Internal note from https://github.com/dart2brasil/site-www/pull/2691#discussion_r506184100:
  -  `??`, `&&` e `||` são excluídos porque são operadores preguiçosos / de curto-circuito
  - `!` provavelmente é excluído por razões históricas
{% endcomment %}

Para declarar um operador, use o identificador embutido
`operator` e então o operador que você está definindo.
O exemplo a seguir define adição de vetor (`+`), subtração (`-`),
e igualdade (`==`):

<?code-excerpt "misc/lib/language_tour/classes/vector.dart"?>
```dart
class Vector {
  final int x, y;

  Vector(this.x, this.y);

  Vector operator +(Vector v) => Vector(x + v.x, y + v.y);
  Vector operator -(Vector v) => Vector(x - v.x, y - v.y);

  @override
  bool operator ==(Object other) =>
      other is Vector && x == other.x && y == other.y;

  @override
  int get hashCode => Object.hash(x, y);
}

void main() {
  final v = Vector(2, 3);
  final w = Vector(2, 2);

  assert(v + w == Vector(4, 5));
  assert(v - w == Vector(0, 1));
}
```


## Getters e setters {:#getters-and-setters}

Getters (acessadores) e setters (modificadores) são métodos especiais que fornecem acesso
de leitura e escrita às propriedades de um objeto. Lembre-se de que cada variável de instância tem
um getter (acessador) implícito, mais um setter (modificador) se apropriado. Você pode criar
propriedades adicionais implementando getters (acessadores) e setters (modificadores), usando as
palavras-chave `get` e `set`:

<?code-excerpt "misc/lib/language_tour/classes/rectangle.dart"?>
```dart
class Rectangle {
  double left, top, width, height;

  Rectangle(this.left, this.top, this.width, this.height);

  // Define duas propriedades calculadas: right e bottom.
  double get right => left + width;
  set right(double value) => left = value - width;
  double get bottom => top + height;
  set bottom(double value) => top = value - height;
}

void main() {
  var rect = Rectangle(3, 4, 20, 15);
  assert(rect.left == 3);
  rect.right = 12;
  assert(rect.left == -8);
}
```

Com getters (acessadores) e setters (modificadores), você pode começar com variáveis de instância e depois
envolvê-las com métodos, tudo sem alterar o código do cliente.

:::note
Operadores como incremento (++) funcionam da maneira esperada, quer um
getter (acessador) seja explicitamente definido ou não. Para evitar quaisquer efeitos colaterais
inesperados, o operador chama o getter (acessador) exatamente uma vez, salvando seu valor
em uma variável temporária.
:::

## Métodos abstratos {:#abstract-methods}

Métodos de instância, getter (acessadores) e setter (modificadores) podem ser abstratos, definindo uma
interface, mas deixando sua implementação para outras classes.
Métodos abstratos só podem existir em [classes abstratas][] ou [mixins][].

Para tornar um método abstrato, use um ponto e vírgula (`;`) em vez de um corpo de método:

<?code-excerpt "misc/lib/language_tour/classes/doer.dart"?>
```dart
abstract class Doer {
  // Define variáveis de instância e métodos...

  void doSomething(); // Define um método abstrato.
}

class EffectiveDoer extends Doer {
  void doSomething() {
    // Fornece uma implementação, então o método não é abstrato aqui...
  }
}
```

[operators]: /language/operators
[abstract classes]: /language/class-modifiers#abstract
[mixins]: /language/mixins
