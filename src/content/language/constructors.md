---
ia-translate: true
title: Construtores
description: Tudo sobre o uso de construtores em Dart.
prevpage:
  url: /language/classes
  title: Classes
nextpage:
  url: /language/methods
  title: Methods
---

Construtores são funções especiais que criam instâncias de classes.

O Dart implementa muitos tipos de construtores.
Exceto pelos construtores padrão,
essas funções usam o mesmo nome de sua classe.

[Construtores generativos][generative]
: Cria novas instâncias e inicializa variáveis de instância.

[Construtores padrão][default]
: Usado para criar uma nova instância quando um construtor não foi especificado.
  Ele não aceita argumentos e não é nomeado.

[Construtores nomeados][named]
: Esclarece o propósito de um construtor ou
  permite a criação de múltiplos construtores para a mesma classe.

[Construtores constantes][constant]
: Cria instâncias como constantes de tempo de compilação.

[Construtores factory][factory]
: Cria uma nova instância de um subtipo ou
  retorna uma instância existente do cache.

[Construtor de redirecionamento][redirecting]
: Encaminha chamadas para outro construtor na mesma classe.

[default]: #default-constructors
[generative]: #generative-constructors
[named]: #named-constructors
[constant]: #constant-constructors
[factory]: #factory-constructors
[redirecting]: #redirecting-constructors

<?code-excerpt path-base="misc/lib/language_tour/classes"?>

<?code-excerpt replace="/ *\/\/\s+ignore_for_file:[^\n]+\n//g; /(^|\n) *\/\/\s+ignore:[^\n]+\n/$1/g; /(\n[^\n]+) *\/\/\s+ignore:[^\n]+\n/$1\n/g; / *\/\/\s+ignore:[^\n]+//g; /([A-Z]\w*)\d\b/$1/g"?>

## Tipos de construtores

### Construtores generativos

Para instanciar uma classe, use um construtor generativo.

<?code-excerpt "point_alt.dart (idiomatic-constructor)" plaster="none"?>
```dart
class Point {
  // Instance variables to hold the coordinates of the point.
  double x;
  double y;

  // Generative constructor with initializing formal parameters:
  Point(this.x, this.y);
}
```

### Construtores padrão

Se você não declarar um construtor, o Dart usa o construtor padrão.
O construtor padrão é um construtor generativo sem argumentos ou nome.

### Construtores nomeados

Use um construtor nomeado para implementar múltiplos construtores para uma classe
ou para fornecer clareza extra:

<?code-excerpt "point.dart (named-constructor)" replace="/Point\.\S*/[!$&!]/g" plaster="none"?>
```dart
const double xOrigin = 0;
const double yOrigin = 0;

class Point {
  final double x;
  final double y;

  // Sets the x and y instance variables
  // before the constructor body runs.
  Point(this.x, this.y);

  // Named constructor
  [!Point.origin()!] : x = xOrigin, y = yOrigin;
}
```

Uma subclasse não herda o construtor nomeado de uma superclasse.
Para criar uma subclasse com um construtor nomeado definido na superclasse,
implemente esse construtor na subclasse.

### Construtores constantes

Se sua classe produz objetos imutáveis, torne esses
objetos constantes de tempo de compilação.
Para tornar objetos constantes de tempo de compilação, defina um construtor `const`
com todas as variáveis de instância definidas como `final`.

<?code-excerpt "immutable_point.dart"?>
```dart
class ImmutablePoint {
  static const ImmutablePoint origin = ImmutablePoint(0, 0);

  final double x, y;

  const ImmutablePoint(this.x, this.y);
}
```

Construtores constantes nem sempre criam constantes.
Eles podem ser invocados em um contexto não-`const`.
Para saber mais, consulte a seção sobre [usando construtores][using constructors].

### Construtores de redirecionamento

Um construtor pode redirecionar para outro construtor na mesma classe.
Um construtor de redirecionamento tem um corpo vazio.
O construtor usa `this` em vez do nome da classe após dois pontos (`:`).

<?code-excerpt "point_redirecting.dart"?>
```dart
class Point {
  double x, y;

  // The main constructor for this class.
  Point(this.x, this.y);

  // Delegates to the main constructor.
  Point.alongXAxis(double x) : this(x, 0);
}
```

### Construtores factory

Ao encontrar um dos seguintes dois casos de implementação de um construtor,
use a keyword `factory`:

* O construtor nem sempre cria uma nova instância de sua classe.
  Embora um construtor factory não possa retornar `null`,
  ele pode retornar:

  * uma instância existente de um cache em vez de criar uma nova
  * uma nova instância de um subtipo

* Você precisa executar trabalho não trivial antes de construir uma instância.
  Isso pode incluir verificar argumentos ou fazer qualquer outro processamento
  que não pode ser tratado na lista de inicializadores.

:::tip
Você também pode lidar com a inicialização tardia de uma variável final
com [`late final`][late-final-ivar] (cuidadosamente!).
:::

O exemplo a seguir inclui dois construtores factory.

* O construtor factory `Logger` retorna objetos de um cache.
* O construtor factory `Logger.fromJson` inicializa uma variável final
  de um objeto JSON.

<?code-excerpt "logger.dart (constructors)"?>
```dart
class Logger {
  final String name;
  bool mute = false;

  // _cache is library-private, thanks to
  // the _ in front of its name.
  static final Map<String, Logger> _cache = <String, Logger>{};

  factory Logger(String name) {
    return _cache.putIfAbsent(name, () => Logger._internal(name));
  }

  factory Logger.fromJson(Map<String, Object> json) {
    return Logger(json['name'].toString());
  }

  Logger._internal(this.name);

  void log(String msg) {
    if (!mute) print(msg);
  }
}
```

:::warning
Construtores factory não podem acessar `this`.
:::

Use um construtor factory como qualquer outro construtor:

<?code-excerpt "logger.dart (logger)"?>
```dart
var logger = Logger('UI');
logger.log('Button clicked');

var logMap = {'name': 'UI'};
var loggerJson = Logger.fromJson(logMap);
```

### Construtores factory de redirecionamento

Um construtor factory de redirecionamento especifica uma chamada para um construtor de outra
classe para usar sempre que alguém fizer uma chamada para o construtor de redirecionamento.

```dart
factory Listenable.merge(List<Listenable> listenables) = _MergingListenable
```

Pode parecer que construtores factory comuns
poderiam criar e retornar instâncias de outras classes.
Isso tornaria os factories de redirecionamento desnecessários.
Construtores factory de redirecionamento têm várias vantagens:

* Uma classe abstract pode fornecer um construtor constante
  que usa o construtor constante de outra classe.
* Um construtor factory de redirecionamento evita a necessidade de forwarders
  para repetir os parâmetros formais e seus valores padrão.

### Tear-offs de construtor

O Dart permite que você forneça um construtor como parâmetro sem chamá-lo.
Chamado de _tear-off_ (como você _arranca_ os parênteses)
serve como um closure que invoca o construtor com os mesmos parâmetros.

Se o tear-off é um construtor com a mesma
assinatura e tipo de retorno que o método aceita,
você pode usar o tear-off como parâmetro ou variável.

Tear-offs diferem de lambdas ou funções anônimas.
Lambdas servem como um wrapper para o construtor,
enquanto um tear-off é o construtor.

**Use Tear-Offs**

```dart tag=good
// Use a tear-off for a named constructor:
var strings = charCodes.map(String.fromCharCode);

// Use a tear-off for an unnamed constructor:
var buffers = charCodes.map(StringBuffer.new);
```

**Não Lambdas**

```dart tag=bad
// Instead of a lambda for a named constructor:
var strings = charCodes.map((code) => String.fromCharCode(code));

// Instead of a lambda for an unnamed constructor:
var buffers = charCodes.map((code) => StringBuffer(code));
```

Para mais discussão, assista a este vídeo Decoding Flutter sobre tear-offs.

<YouTubeEmbed id="OmCaloD7sis" title="Dart Tear-offs | Decoding Flutter"></YouTubeEmbed>

## Inicialização de variáveis de instância

O Dart pode inicializar variáveis de três maneiras.

### Inicializar variáveis de instância na declaração

Inicialize as variáveis de instância quando você declarar as variáveis.

<?code-excerpt "point_alt.dart (initialize-declaration)" plaster="none"?>
```dart
class PointA {
  double x = 1.0;
  double y = 2.0;

  // The implicit default constructor sets these variables to (1.0,2.0)
  // PointA();

  @override
  String toString() {
    return 'PointA($x,$y)';
  }
}
```

### Usar parâmetros formais de inicialização

Para simplificar o padrão comum de atribuir um argumento de construtor
a uma variável de instância, o Dart tem *parâmetros formais de inicialização*.

Na declaração do construtor, inclua `this.<propertyName>`
e omita o corpo. A keyword `this` refere-se à instância atual.

Quando o conflito de nomes existe, use `this`.
Caso contrário, o estilo Dart omite o `this`.
Uma exceção existe para o construtor generativo onde
você deve prefixar o nome do parâmetro formal de inicialização com `this`.

Como observado anteriormente neste guia, certos construtores
e certas partes de construtores não podem acessar `this`. Estes incluem:

* Construtores factory
* O lado direito de uma lista de inicializadores
* Argumentos para um construtor de superclasse

Parâmetros formais de inicialização também permitem que você inicialize
variáveis de instância non-nullable ou `final`.
Ambos os tipos de variáveis requerem inicialização ou um valor padrão.

<?code-excerpt "point_alt.dart (initialize-formal)" plaster="none"?>
```dart
class PointB {
  final double x;
  final double y;

  // Sets the x and y instance variables
  // before the constructor body runs.
  PointB(this.x, this.y);

  // Initializing formal parameters can also be optional.
  PointB.optional([this.x = 0.0, this.y = 0.0]);
}
```

Campos privados não podem ser usados como parâmetros formais de inicialização nomeados.

{% comment %}
Don't attach the following example to a code excerpt.
It doesn't work on purpose and will cause errors in CI.
{% endcomment %}

```dart
class PointB {
// ...

  PointB.namedPrivate({required double x, required double y})
      : _x = x,
        _y = y;

// ...
}
```

Isso também funciona com variáveis nomeadas.

<?code-excerpt "point_alt.dart (initialize-named)" plaster="none"?>
```dart
class PointC {
  double x; // must be set in constructor
  double y; // must be set in constructor

  // Generative constructor with initializing formal parameters
  // with default values
  PointC.named({this.x = 1.0, this.y = 1.0});

  @override
  String toString() {
    return 'PointC.named($x,$y)';
  }
}

// Constructor using named variables.
final pointC = PointC.named(x: 2.0, y: 2.0);
```

Todas as variáveis introduzidas de parâmetros formais de inicialização são tanto
final quanto apenas no escopo das variáveis inicializadas.

Para executar lógica que você não pode expressar na lista de inicializadores,
crie um [construtor factory](#factory-constructors)
ou [método static][static method] com essa lógica.
Você pode então passar os valores computados para um construtor normal.

Os parâmetros do construtor podem ser definidos como nullable e não ser inicializados.

<?code-excerpt "point_alt.dart (initialize-null)" plaster="none"?>
```dart
class PointD {
  double? x; // null if not set in constructor
  double? y; // null if not set in constructor

  // Generative constructor with initializing formal parameters
  PointD(this.x, this.y);

  @override
  String toString() {
    return 'PointD($x,$y)';
  }
}
```

### Usar uma lista de inicializadores

Antes do corpo do construtor ser executado, você pode inicializar variáveis de instância.
Separe os inicializadores com vírgulas.

<?code-excerpt "point_alt.dart (initializer-list)"?>
```dart
// Initializer list sets instance variables before
// the constructor body runs.
Point.fromJson(Map<String, double> json) : x = json['x']!, y = json['y']! {
  print('In Point.fromJson(): ($x, $y)');
}
```

:::warning
O lado direito de uma lista de inicializadores não pode acessar `this`.
:::

Para validar entradas durante o desenvolvimento,
use `assert` na lista de inicializadores.

<?code-excerpt "point_alt.dart (initializer-list-with-assert)" replace="/assert\(.*?\)/[!$&!]/g"?>
```dart
Point.withAssert(this.x, this.y) : [!assert(x >= 0)!] {
  print('In Point.withAssert(): ($x, $y)');
}
```

Listas de inicializadores ajudam a configurar campos `final`.

O exemplo a seguir inicializa três campos `final` em uma lista de inicializadores.
Para executar o código, clique em **Run**.

<?code-excerpt "point_with_distance_field.dart"?>
```dartpad
import 'dart:math';

class Point {
  final double x;
  final double y;
  final double distanceFromOrigin;

  Point(double x, double y)
    : x = x,
      y = y,
      distanceFromOrigin = sqrt(x * x + y * y);
}

void main() {
  var p = Point(2, 3);
  print(p.distanceFromOrigin);
}
```

## Herança de construtor

_Subclasses_, ou classes filhas, não herdam *construtores*
de sua _superclasse_, ou classe pai imediata.
Se uma classe não declarar um construtor, ela só pode usar o
[construtor padrão](#default-constructors).

Uma classe pode herdar os _parâmetros_ de uma superclasse.
Estes são chamados [super parâmetros](#super-parameters)

Construtores funcionam de maneira um tanto semelhante a
como você chama uma cadeia de métodos static.
Cada subclasse pode chamar o construtor de sua superclasse para inicializar uma instância,
como uma subclasse pode chamar um método static de uma superclasse.
Este processo não "herda" corpos ou assinaturas de construtores.

### Construtores de superclasse não padrão

O Dart executa construtores na seguinte ordem:

1. [lista de inicializadores](#use-an-initializer-list)
1. construtor sem nome e sem argumentos da superclasse
1. construtor sem argumentos da classe principal

Se a superclasse não tiver um construtor sem nome e sem argumentos,
chame um dos construtores na superclasse.
Antes do corpo do construtor (se houver),
especifique o construtor da superclasse após dois pontos (`:`).

No exemplo a seguir,
o construtor da classe `Employee` chama o construtor nomeado
para sua superclasse, `Person`. Para executar o código a seguir, clique em **Run**.

<?code-excerpt "employee.dart (super)" plaster="none"?>
```dartpad
class Person {
  String? firstName;

  Person.fromJson(Map data) {
    print('in Person');
  }
}

class Employee extends Person {
  // Person does not have a default constructor;
  // you must call super.fromJson().
  Employee.fromJson(Map data) : super.fromJson(data) {
    print('in Employee');
  }
}

void main() {
  var employee = Employee.fromJson({});
  print(employee);
  // Prints:
  // in Person
  // in Employee
  // Instance of 'Employee'
}
```

Como o Dart avalia os argumentos para o construtor da superclasse *antes*
de invocar o construtor, um argumento pode ser uma expressão como uma
chamada de função.

<?code-excerpt "employee.dart (method-then-constructor)"?>
```dart
class Employee extends Person {
  Employee() : super.fromJson(fetchDefaultData());
  // ···
}
```

:::warning
Argumentos para o construtor da superclasse não podem acessar `this`.
Por exemplo, argumentos podem chamar métodos *static*
mas não métodos de *instância*.
:::

### Super parâmetros

Para evitar passar cada parâmetro para a invocação super de um construtor,
use parâmetros super-initializer para encaminhar parâmetros
para o construtor de superclasse especificado ou padrão.
Você não pode usar este recurso com
[construtores de redirecionamento](#redirecting-constructors).
Parâmetros super-initializer têm sintaxe e semântica como
[parâmetros formais de inicialização](#use-initializing-formal-parameters).

:::version-note
Usar parâmetros super-initializer
requer uma [versão da linguagem][language version] de pelo menos 2.17.
Se você estiver usando uma versão de linguagem anterior,
você deve passar manualmente todos os parâmetros do construtor super.
:::

Se a invocação do super-constructor inclui argumentos posicionais,
parâmetros super-initializer não podem ser posicionais.

<?code-excerpt "super_initializer_positional_parameters.dart (positional)" plaster="none"?>
```dart
class Vector2d {
  final double x;
  final double y;

  Vector2d(this.x, this.y);
}

class Vector3d extends Vector2d {
  final double z;

  // Forward the x and y parameters to the default super constructor like:
  // Vector3d(final double x, final double y, this.z) : super(x, y);
  Vector3d(super.x, super.y, this.z);
}
```

Para ilustrar ainda mais, considere o exemplo a seguir.

```dart
  // If you invoke the super constructor (`super(0)`) with any
  // positional arguments, using a super parameter (`super.x`)
  // results in an error.
  Vector3d.xAxisError(super.x): z = 0, super(0); // BAD
```

Este construtor nomeado tenta definir o valor `x` duas vezes:
uma vez no construtor super e uma vez como um
parâmetro super posicional.
Como ambos endereçam o parâmetro posicional `x`, isso resulta em um erro.

Quando o construtor super tem argumentos nomeados, você pode dividi-los
entre parâmetros super nomeados (`super.y` no próximo exemplo)
e argumentos nomeados para a invocação do construtor super
(`super.named(x: 0)`).

<?code-excerpt "super_initializer_named_parameters.dart (named)" plaster="none"?>
```dart
class Vector2d {
  // ...
  Vector2d.named({required this.x, required this.y});
}

class Vector3d extends Vector2d {
  final double z;

  // Forward the y parameter to the named super constructor like:
  // Vector3d.yzPlane({required double y, required this.z})
  //       : super.named(x: 0, y: y);
  Vector3d.yzPlane({required super.y, required this.z}) : super.named(x: 0);
}
```

[language version]: /resources/language/evolution#language-versioning
[using constructors]: /language/classes#using-constructors
[late-final-ivar]: /effective-dart/design#avoid-public-late-final-fields-without-initializers
[static method]: /language/classes#static-methods
