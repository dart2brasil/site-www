---
ia-translate: true
title: Classes
description: Resumo de classes, instâncias de classe e seus membros.
prevpage:
  url: /language/error-handling
  title: Error handling
nextpage:
  url: /language/constructors
  title: Constructors
---

<?code-excerpt replace="/ *\/\/\s+ignore_for_file:[^\n]+\n//g; /(^|\n) *\/\/\s+ignore:[^\n]+\n/$1/g; /(\n[^\n]+) *\/\/\s+ignore:[^\n]+\n/$1\n/g; / *\/\/\s+ignore:[^\n]+//g; /([A-Z]\w*)\d\b/$1/g"?>

Dart é uma linguagem orientada a objetos com classes e herança
baseada em mixin. Cada objeto é uma instância de uma classe, e todas as classes
exceto `Null` descendem de [`Object`][].
*Herança baseada em mixin* significa que, embora cada classe
(exceto a [classe superior][top-and-bottom], `Object?`)
tenha exatamente uma superclasse, um corpo de classe pode ser reutilizado em
múltiplas hierarquias de classe.
[Extension methods][] são uma forma de
adicionar funcionalidade a uma classe sem alterar a classe ou criar uma subclasse.
[Modificadores de classe][Class modifiers] permitem que você controle como as bibliotecas podem subtipificar uma classe.


## Usando membros de classe

Objetos têm *membros* que consistem em funções e dados (*métodos* e
*variáveis de instância*, respectivamente). Quando você chama um método, você o *invoca*
em um objeto: o método tem acesso às funções e
dados desse objeto.

Use um ponto (`.`) para se referir a uma variável de instância ou método:

<?code-excerpt "misc/test/language_tour/classes_test.dart (object-members)"?>
```dart
var p = Point(2, 2);

// Get the value of y.
assert(p.y == 2);

// Invoke distanceTo() on p.
double distance = p.distanceTo(Point(4, 4));
```

Use `?.` em vez de `.` para evitar uma exceção
quando o operando mais à esquerda for null:

<?code-excerpt "misc/test/language_tour/classes_test.dart (safe-member-access)"?>
```dart
// If p is non-null, set a variable equal to its y value.
var a = p?.y;
```


## Usando construtores

Você pode criar um objeto usando um *construtor*.
Nomes de construtores podem ser <code><em>NomeDaClasse</em></code> ou
<code><em>NomeDaClasse</em>.<em>identificador</em></code>. Por exemplo,
o código a seguir cria objetos `Point` usando os
construtores `Point()` e `Point.fromJson()`:

<?code-excerpt "misc/test/language_tour/classes_test.dart (object-creation)" replace="/ as .*?;/;/g"?>
```dart
var p1 = Point(2, 2);
var p2 = Point.fromJson({'x': 1, 'y': 2});
```

O código a seguir tem o mesmo efeito, mas
usa a palavra-chave opcional `new` antes do nome do construtor:

<?code-excerpt "misc/test/language_tour/classes_test.dart (object-creation-new)" replace="/ as .*?;/;/g"?>
```dart
var p1 = new Point(2, 2);
var p2 = new Point.fromJson({'x': 1, 'y': 2});
```

Algumas classes fornecem [construtores constantes][constant constructors].
Para criar uma constante de tempo de compilação usando um construtor constante,
coloque a palavra-chave `const` antes do nome do construtor:

<?code-excerpt "misc/test/language_tour/classes_test.dart (const)"?>
```dart
var p = const ImmutablePoint(2, 2);
```

Construir duas constantes de tempo de compilação idênticas resulta em uma única
instância canônica:

<?code-excerpt "misc/test/language_tour/classes_test.dart (identical)"?>
```dart
var a = const ImmutablePoint(1, 1);
var b = const ImmutablePoint(1, 1);

assert(identical(a, b)); // They are the same instance!
```

Dentro de um _contexto constante_, você pode omitir o `const` antes de um construtor
ou literal. Por exemplo, veja este código, que cria um mapa const:

<?code-excerpt "misc/test/language_tour/classes_test.dart (const-context-withconst)" replace="/pointAndLine1/pointAndLine/g"?>
```dart
// Lots of const keywords here.
const pointAndLine = const {
  'point': const [const ImmutablePoint(0, 0)],
  'line': const [const ImmutablePoint(1, 10), const ImmutablePoint(-2, 11)],
};
```

Você pode omitir todos os usos de `const` exceto o primeiro:

<?code-excerpt "misc/test/language_tour/classes_test.dart (const-context-noconst)" replace="/pointAndLine2/pointAndLine/g"?>
```dart
// Only one const, which establishes the constant context.
const pointAndLine = {
  'point': [ImmutablePoint(0, 0)],
  'line': [ImmutablePoint(1, 10), ImmutablePoint(-2, 11)],
};
```

Se um construtor constante estiver fora de um contexto constante
e for invocado sem `const`,
ele cria um **objeto não constante**:

<?code-excerpt "misc/test/language_tour/classes_test.dart (nonconst-const-constructor)"?>
```dart
var a = const ImmutablePoint(1, 1); // Creates a constant
var b = ImmutablePoint(1, 1); // Does NOT create a constant

assert(!identical(a, b)); // NOT the same instance!
```


## Obtendo o tipo de um objeto

Para obter o tipo de um objeto em tempo de execução,
você pode usar a propriedade `runtimeType` de `Object`,
que retorna um objeto [`Type`][].

<?code-excerpt "misc/test/language_tour/classes_test.dart (runtime-type)"?>
```dart
print('The type of a is ${a.runtimeType}');
```

:::warning
Use um [operador de teste de tipo][type test operator] em vez de `runtimeType`
para testar o tipo de um objeto.
Em ambientes de produção, o teste `object is Type` é mais estável
do que o teste `object.runtimeType == Type`.
:::

Até aqui, você viu como _usar_ classes.
O restante desta seção mostra como _implementar_ classes.


## Variáveis de instância

Aqui está como você declara variáveis de instância:

<?code-excerpt "misc/lib/language_tour/classes/point_with_main.dart (class)"?>
```dart
class Point {
  double? x; // Declare instance variable x, initially null.
  double? y; // Declare y, initially null.
  double z = 0; // Declare z, initially 0.
}
```

Uma variável de instância não inicializada declarada com um
[tipo nullable][nullable type] tem o valor `null`.
Variáveis de instância non-nullable [devem ser inicializadas][must be initialized] na declaração.

Todas as variáveis de instância geram um método *getter* implícito.
Variáveis de instância non-final e
variáveis de instância `late final` sem inicializadores também geram
um método *setter* implícito. Para detalhes,
confira [Getters e setters][Getters and setters].

<?code-excerpt "misc/lib/language_tour/classes/point_with_main.dart (class-main)" replace="/(double .*?;).*/$1/g" plaster="none"?>
```dart
class Point {
  double? x; // Declare instance variable x, initially null.
  double? y; // Declare y, initially null.
}

void main() {
  var point = Point();
  point.x = 4; // Use the setter method for x.
  assert(point.x == 4); // Use the getter method for x.
  assert(point.y == null); // Values default to null.
}
```

Inicializar uma variável de instância não-`late` onde ela é declarada
define o valor quando a instância é criada,
antes do construtor e sua lista de inicializadores serem executados.
Como resultado, a expressão de inicialização (após o `=`)
de uma variável de instância não-`late` não pode acessar `this`.

<?code-excerpt "misc/lib/language_tour/classes/point_this.dart"?>
```dart
double initialX = 1.5;

class Point {
  // OK, can access declarations that do not depend on `this`:
  double? x = initialX;

  // ERROR, can't access `this` in non-`late` initializer:
  double? y = this.x;

  // OK, can access `this` in `late` initializer:
  late double? z = this.x;

  // OK, `this.x` and `this.y` are parameter declarations, not expressions:
  Point(this.x, this.y);
}
```

Variáveis de instância podem ser `final`,
caso em que devem ser definidas exatamente uma vez.
Inicialize variáveis de instância `final`, não-`late`
na declaração,
usando um parâmetro de construtor, ou
usando a [lista de inicializadores][initializer list] de um construtor:

<?code-excerpt "misc/lib/effective_dart/usage_good.dart (field-init-at-decl)"?>
```dart
class ProfileMark {
  final String name;
  final DateTime start = DateTime.now();

  ProfileMark(this.name);
  ProfileMark.unnamed() : name = '';
}
```

Se você precisa atribuir o valor de uma variável de instância `final`
após o corpo do construtor começar, você pode usar uma das seguintes opções:

* Use um [factory constructor][factory constructor].
* Use `late final`, mas [_tenha cuidado:_][late-final-ivar]
  um `late final` sem inicializador adiciona um setter à API.

## Interfaces implícitas

Toda classe define implicitamente uma interface contendo todos os membros
de instância da classe e de quaisquer interfaces que ela implementa. Se você quer
criar uma classe A que suporte a API da classe B sem herdar a
implementação de B, a classe A deve implementar a interface B.

Uma classe implementa uma ou mais interfaces declarando-as em uma
cláusula `implements` e então fornecendo as APIs exigidas pelas
interfaces. Por exemplo:

<?code-excerpt "misc/lib/language_tour/classes/impostor.dart"?>
```dart
// A person. The implicit interface contains greet().
class Person {
  // In the interface, but visible only in this library.
  final String _name;

  // Not in the interface, since this is a constructor.
  Person(this._name);

  // In the interface.
  String greet(String who) => 'Hello, $who. I am $_name.';
}

// An implementation of the Person interface.
class Impostor implements Person {
  String get _name => '';

  String greet(String who) => 'Hi $who. Do you know who I am?';
}

String greetBob(Person person) => person.greet('Bob');

void main() {
  print(greetBob(Person('Kathy')));
  print(greetBob(Impostor()));
}
```

Aqui está um exemplo de especificação de que uma classe implementa múltiplas
interfaces:

<?code-excerpt "misc/lib/language_tour/classes/misc.dart (point-interfaces)"?>
```dart
class Point implements Comparable, Location {
  ...
}
```


## Variáveis e métodos de classe

Use a palavra-chave `static` para implementar variáveis e métodos que abrangem toda a classe.

### Variáveis static

Variáveis static (variáveis de classe) são úteis para estado e
constantes que abrangem toda a classe:

<?code-excerpt "misc/lib/language_tour/classes/misc.dart (static-field)"?>
```dart
class Queue {
  static const initialCapacity = 16;
  // ···
}

void main() {
  assert(Queue.initialCapacity == 16);
}
```

Variáveis static não são inicializadas até serem usadas.

:::note
Esta página segue a
[recomendação do guia de estilo](/effective-dart/style#identifiers)
de preferir `lowerCamelCase` para nomes de constantes.
:::

### Métodos static

Métodos static (métodos de classe) não operam em uma instância e, portanto,
não têm acesso a `this`.
Eles têm, no entanto, acesso a variáveis static.
Como mostra o exemplo a seguir,
você invoca métodos static diretamente em uma classe:

<?code-excerpt "misc/lib/language_tour/classes/point_with_distance_method.dart"?>
```dart
import 'dart:math';

class Point {
  double x, y;
  Point(this.x, this.y);

  static double distanceBetween(Point a, Point b) {
    var dx = a.x - b.x;
    var dy = a.y - b.y;
    return sqrt(dx * dx + dy * dy);
  }
}

void main() {
  var a = Point(2, 2);
  var b = Point(4, 4);
  var distance = Point.distanceBetween(a, b);
  assert(2.8 < distance && distance < 2.9);
  print(distance);
}
```

:::note
Considere usar funções de nível superior, em vez de métodos static, para
utilitários e funcionalidades comuns ou amplamente usados.
:::

Você pode usar métodos static como constantes de tempo de compilação. Por exemplo, você
pode passar um método static como parâmetro para um construtor constante.


[`Object`]: {{site.dart-api}}/dart-core/Object-class.html
[top-and-bottom]: /null-safety/understanding-null-safety#top-and-bottom
[Extension methods]: /language/extension-methods
[Class modifiers]: /language/class-modifiers
[constant constructors]: /language/constructors#constant-constructors
[`Type`]: {{site.dart-api}}/dart-core/Type-class.html
[type test operator]: /language/operators#type-test-operators
[Getters and setters]: /language/methods#getters-and-setters
[initializer list]: /language/constructors#use-an-initializer-list
[factory constructor]: /language/constructors#factory-constructors
[late-final-ivar]: /effective-dart/design#avoid-public-late-final-fields-without-initializers
[nullable type]: /null-safety/understanding-null-safety#using-nullable-types
[must be initialized]: /null-safety/understanding-null-safety#uninitialized-variables
