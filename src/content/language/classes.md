---
ia-translate: true
title: Classes
description: Resumo de classes, instâncias de classes e seus membros.
prevpage:
  url: /language/error-handling
  title: Tratamento de erros
nextpage:
  url: /language/constructors
  title: Construtores
---

<?code-excerpt replace="/ *\/\/\s+ignore_for_file:[^\n]+\n//g; /(^|\n) *\/\/\s+ignore:[^\n]+\n/$1/g; /(\n[^\n]+) *\/\/\s+ignore:[^\n]+\n/$1\n/g; / *\/\/\s+ignore:[^\n]+//g; /([A-Z]\w*)\d\b/$1/g"?>

Dart é uma linguagem orientada a objetos (object-oriented) com classes e herança
baseada em mixin. Cada objeto é uma instância de uma classe, e todas as classes,
exceto `Null`, descendem de [`Object`][].
*Herança baseada em mixin* significa que, embora cada classe
(exceto a [classe superior][top-and-bottom], `Object?`)
tenha exatamente uma superclasse, o corpo de uma classe pode ser reutilizado em
várias hierarquias de classes.
[Extension methods][] são uma maneira de
adicionar funcionalidade a uma classe sem alterá-la ou criar uma subclasse.
[Class modifiers][] permitem que você controle como as bibliotecas podem subtipar uma classe.


## Usando membros de classe {:#using-class-members}

Objetos têm *membros* que consistem em funções e dados (*métodos* e
*variáveis de instância*, respectivamente).
Quando você chama um método, você o *invoca*
em um objeto: o método tem acesso às funções e aos dados desse objeto.

Use um ponto (`.`) para se referir a uma variável de instância ou método:

<?code-excerpt "misc/test/language_tour/classes_test.dart (object-members)"?>
```dart
var p = Point(2, 2);

// Obtém o valor de y.
assert(p.y == 2);

// Invoca distanceTo() em p.
double distance = p.distanceTo(Point(4, 4));
```

Use `?.` em vez de `.` para evitar uma exceção
quando o operando mais à esquerda for nulo:

<?code-excerpt "misc/test/language_tour/classes_test.dart (safe-member-access)"?>
```dart
// Se p não for nulo, define uma variável igual ao seu valor y.
var a = p?.y;
```


## Usando construtores {:#using-constructors}

Você pode criar um objeto usando um *construtor*.
Os nomes dos construtores podem ser <code><em>ClassName</em></code> ou
<code><em>ClassName</em>.<em>identifier</em></code>.
Por exemplo, o código a seguir cria objetos `Point` usando os
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

Algumas classes fornecem [constant constructors][].
Para criar uma constante em tempo de compilação usando um construtor constante,
coloque a palavra-chave `const` antes do nome do construtor:

<?code-excerpt "misc/test/language_tour/classes_test.dart (const)"?>
```dart
var p = const ImmutablePoint(2, 2);
```

Construir duas constantes idênticas em tempo de compilação resulta em uma única
instância canônica:

<?code-excerpt "misc/test/language_tour/classes_test.dart (identical)"?>
```dart
var a = const ImmutablePoint(1, 1);
var b = const ImmutablePoint(1, 1);

assert(identical(a, b)); // Elas são a mesma instância!
```

Dentro de um *contexto constante*, você pode omitir o `const` antes de um construtor
ou literal. Por exemplo, veja este código, que cria um mapa constante:

<?code-excerpt "misc/test/language_tour/classes_test.dart (const-context-withconst)" replace="/pointAndLine1/pointAndLine/g"?>
```dart
// Muitas palavras-chave const aqui.
const pointAndLine = const {
  'point': const [const ImmutablePoint(0, 0)],
  'line': const [const ImmutablePoint(1, 10), const ImmutablePoint(-2, 11)],
};
```

Você pode omitir todos, exceto o primeiro uso da palavra-chave `const`:

<?code-excerpt "misc/test/language_tour/classes_test.dart (const-context-noconst)" replace="/pointAndLine2/pointAndLine/g"?>
```dart
// Apenas um const, que estabelece o contexto constante.
const pointAndLine = {
  'point': [ImmutablePoint(0, 0)],
  'line': [ImmutablePoint(1, 10), ImmutablePoint(-2, 11)],
};
```

Se um construtor constante estiver fora de um contexto constante
e for invocado sem `const`,
ele criará um **objeto não constante**:

<?code-excerpt "misc/test/language_tour/classes_test.dart (nonconst-const-constructor)"?>
```dart
var a = const ImmutablePoint(1, 1); // Cria uma constante
var b = ImmutablePoint(1, 1); // NÃO cria uma constante

assert(!identical(a, b)); // NÃO são a mesma instância!
```


## Obtendo o tipo de um objeto {:#getting-an-object-s-type}

Para obter o tipo de um objeto em tempo de execução,
você pode usar a propriedade `runtimeType` do `Object`,
que retorna um objeto [`Type`][].

<?code-excerpt "misc/test/language_tour/classes_test.dart (runtime-type)"?>
```dart
print('O tipo de a é ${a.runtimeType}');
```

:::warning
Use um [type test operator][] em vez de `runtimeType`
para testar o tipo de um objeto.
Em ambientes de produção, o teste `object is Type` é mais estável
do que o teste `object.runtimeType == Type`.
:::

Até aqui, você viu como *usar* classes.
O restante desta seção mostra como *implementar* classes.


## Variáveis de instância {:#instance-variables}

Veja como você declara variáveis de instância:

<?code-excerpt "misc/lib/language_tour/classes/point_with_main.dart (class)"?>
```dart
class Point {
  double? x; // Declara a variável de instância x, inicialmente nula.
  double? y; // Declara y, inicialmente nula.
  double z = 0; // Declara z, inicialmente 0.
}
```

Uma variável de instância não inicializada declarada com um
[nullable type][] tem o valor `null`.
Variáveis de instância não anuláveis [must be initialized][] na declaração.

Todas as variáveis de instância geram um método *getter* implícito.
Variáveis de instância não finais e
variáveis de instância `late final` sem inicializadores também geram
um método *setter* implícito. Para detalhes,
veja [Getters and setters][].

<?code-excerpt "misc/lib/language_tour/classes/point_with_main.dart (class-main)" replace="/(double .*?;).*/$1/g" plaster="none"?>
```dart
class Point {
  double? x; // Declara a variável de instância x, inicialmente nula.
  double? y; // Declara y, inicialmente nula.
}

void main() {
  var point = Point();
  point.x = 4; // Usa o método setter para x.
  assert(point.x == 4); // Usa o método getter para x.
  assert(point.y == null); // Os valores são nulos por padrão.
}
```

Inicializar uma variável de instância não `late` onde ela é declarada
define o valor quando a instância é criada,
antes do construtor e de sua lista de inicializadores serem executados.
Como resultado, a expressão de inicialização (após o `=`)
de uma variável de instância não `late` não pode acessar `this`.

<?code-excerpt "misc/lib/language_tour/classes/point_this.dart"?>
```dart
double initialX = 1.5;

class Point {
  // OK, pode acessar declarações que não dependem de `this`:
  double? x = initialX;

  // ERRO, não pode acessar `this` em inicializador não `late`:
  double? y = this.x;

  // OK, pode acessar `this` em inicializador `late`:
  late double? z = this.x;

  // OK, `this.x` e `this.y` são declarações de parâmetros, não expressões:
  Point(this.x, this.y);
}
```

Variáveis de instância podem ser `final`,
nesse caso, elas devem ser definidas exatamente uma vez.
Inicialize variáveis de instância `final` não `late`
na declaração,
usando um parâmetro de construtor ou
usando a [initializer list][] de um construtor:

<?code-excerpt "misc/lib/effective_dart/usage_good.dart (field-init-at-decl)"?>
```dart
class ProfileMark {
  final String name;
  final DateTime start = DateTime.now();

  ProfileMark(this.name);
  ProfileMark.unnamed() : name = '';
}
```

Se você precisar atribuir o valor de uma variável de instância `final`
após o início do corpo do construtor, você pode usar um dos seguintes:

*   Use um [factory constructor][].
*   Use `late final`, mas [_tenha cuidado:_][late-final-ivar]
    um `late final` sem um inicializador adiciona um setter à API.

## Interfaces implícitas {:#implicit-interfaces}

Cada classe define implicitamente uma interface contendo todos os
membros de instância da classe e de quaisquer interfaces que ela implemente.
Se você quiser criar uma classe A que suporte a API da classe B sem herdar a
implementação de B, a classe A deve implementar a interface B.

Uma classe implementa uma ou mais interfaces declarando-as em uma
cláusula `implements` e, em seguida, fornecendo as APIs exigidas pelas
interfaces. Por exemplo:

<?code-excerpt "misc/lib/language_tour/classes/impostor.dart"?>
```dart
// Uma pessoa. A interface implícita contém greet().
class Person {
  // Na interface, mas visível apenas nesta biblioteca.
  final String _name;

  // Não está na interface, pois este é um construtor.
  Person(this._name);

  // Na interface.
  String greet(String who) => 'Hello, $who. I am $_name.';
}

// Uma implementação da interface Person.
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

Aqui está um exemplo de especificação de que uma classe implementa várias
interfaces:

<?code-excerpt "misc/lib/language_tour/classes/misc.dart (point-interfaces)"?>
```dart
class Point implements Comparable, Location {...}
```


## Variáveis e métodos de classe {:#class-variables-and-methods}

Use a palavra-chave `static` para implementar variáveis e métodos de toda a classe.

### Variáveis estáticas {:#static-variables}

Variáveis estáticas (variáveis de classe) são úteis para estado de toda a classe e
constantes:

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

Variáveis estáticas não são inicializadas até serem usadas.

:::note
Esta página segue a
[style guide recommendation](/effective-dart/style#identifiers)
de preferir `lowerCamelCase` para nomes de constantes.
:::

### Métodos estáticos {:#static-methods}

Métodos estáticos (métodos de classe) não operam em uma instância e, portanto,
não têm acesso a `this`.
Eles têm, no entanto, acesso a variáveis estáticas.
Como o exemplo a seguir mostra,
você invoca métodos estáticos diretamente em uma classe:

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
Considere usar funções de nível superior, em vez de métodos estáticos, para
utilitários e funcionalidades comuns ou amplamente usados.
:::

Você pode usar métodos estáticos como constantes em tempo de compilação.
Por exemplo, você
pode passar um método estático como um parâmetro para um construtor constante.

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
