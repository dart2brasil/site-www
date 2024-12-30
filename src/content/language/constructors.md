---
ia-translate: true
title: Construtores
description: Tudo sobre como usar construtores em Dart.
js: [{url: '/assets/js/inject_dartpad.js', defer: true}]
prevpage:
  url: /language/classes
  title: Classes
nextpage:
  url: /language/methods
  title: Métodos
---

Construtores são funções especiais que criam instâncias de classes.

Dart implementa vários tipos de construtores.
Exceto por construtores padrão,
essas funções usam o mesmo nome da sua classe.

* [Construtores generativos][generative]: Criam novas instâncias e
      inicializam variáveis de instância.
* [Construtores padrão][default]: Usados para criar uma nova instância quando um
     construtor não foi especificado. Não recebe argumentos e
     não é nomeado.
* [Construtores nomeados][named]: Clarificam o propósito de
      um construtor ou permite a criação de múltiplos construtores para
      a mesma classe.
* [Construtores constantes][constant]: Cria instâncias como constantes
      de tempo de compilação.
* [Construtores factory][factory]: Cria uma nova instância de uma
      subtipo ou retorna uma instância existente do cache.
* [Construtores de redirecionamento][redirecting]: Encaminha chamadas para outro
      construtor na mesma classe.

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
  // Variáveis de instância para armazenar as coordenadas do ponto.
  double x;
  double y;

  // Construtor generativo com parâmetros formais inicializadores:
  Point(this.x, this.y);
}
```

### Construtores padrão

Se você não declarar um construtor, Dart usa o construtor padrão.
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

  // Define as variáveis de instância x e y
  // antes da execução do corpo do construtor.
  Point(this.x, this.y);

  // Construtor nomeado
  [!Point.origin()!]
      : x = xOrigin,
        y = yOrigin;
}
```

Uma subclasse não herda um construtor nomeado de uma superclasse.
Para criar uma subclasse com um construtor nomeado definido na superclasse,
implemente esse construtor na subclasse.

### Construtores constantes

Se sua classe produz objetos imutáveis, faça com que esses
objetos sejam constantes de tempo de compilação.
Para fazer com que objetos sejam constantes de tempo de compilação, defina um construtor `const`
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
O construtor usa `this` em vez do nome da classe após os dois pontos (:).

<?code-excerpt "point_redirecting.dart"?>
```dart
class Point {
  double x, y;

  // O construtor principal para esta classe.
  Point(this.x, this.y);

  // Delega para o construtor principal.
  Point.alongXAxis(double x) : this(x, 0);
}
```

### Construtores factory

Ao encontrar um dos dois casos seguintes de implementação de um construtor,
use a palavra-chave `factory`:

* O construtor nem sempre cria uma nova instância de sua classe.
  Embora um construtor factory não possa retornar `null`,
  ele pode retornar:
  
  * uma instância existente de um cache em vez de criar uma nova
  * uma nova instância de um subtipo

* Você precisa realizar um trabalho não trivial antes de construir uma instância.
  Isso pode incluir a verificação de argumentos ou fazer qualquer outro processamento
  que não pode ser tratado na lista de inicialização.

:::tip
Você também pode lidar com a inicialização tardia de uma variável final
com [`late final`][late-final-ivar] (com cuidado!).
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

  // _cache é privado da biblioteca, graças ao
  // _ na frente do seu nome.
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
logger.log('Botão clicado');

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
Factories de redirecionamento têm várias vantagens:

* Uma classe abstrata pode fornecer um construtor constante
  que usa o construtor constante de outra classe.
* Um construtor factory de redirecionamento evita a necessidade de encaminhadores
  para repetir os parâmetros formais e seus valores padrão.

### Tear-offs de construtor

Dart permite que você forneça um construtor como um parâmetro sem chamá-lo.
Chamado de _tear-off_ (já que você _arranca_ os parênteses)
serve como um closure que invoca o construtor com os mesmos parâmetros.

Se o tear-off for um construtor com a mesma assinatura e tipo de retorno
que o método aceita, você pode usar o tear-off como um parâmetro ou variável.

Tear-offs diferem de lambdas ou funções anônimas.
Lambdas servem como um wrapper para o construtor, enquanto um tear-off
é o construtor.

**Use Tear-Offs**

```dart tag=good
// Use um tear-off para um construtor nomeado:
var strings = charCodes.map(String.fromCharCode);

// Use um tear-off para um construtor não nomeado:
var buffers = charCodes.map(StringBuffer.new);
```

**Não Lambdas**

```dart tag=bad
// Em vez de uma lambda para um construtor nomeado:
var strings = charCodes.map((code) => String.fromCharCode(code));

// Em vez de uma lambda para um construtor não nomeado:
var buffers = charCodes.map((code) => StringBuffer(code));
```

Para mais discussão, assista este vídeo Decoding Flutter sobre tear-offs.

{% ytEmbed "OmCaloD7sis", "Dart Tear-offs | Decoding Flutter" %}

## Inicialização de Variável de Instância

Dart pode inicializar variáveis de três maneiras.

### Inicialize variáveis de instância na declaração

Inicialize as variáveis de instância quando você declarar as variáveis.

<?code-excerpt "point_alt.dart (initialize-declaration)" plaster="none"?>
```dart
class PointA {
  double x = 1.0;
  double y = 2.0;

  // O construtor padrão implícito define essas variáveis para (1.0,2.0)
  // PointA();

  @override
  String toString() {
    return 'PointA($x,$y)';
  }
}
```

### Use parâmetros formais inicializadores

Para simplificar o padrão comum de atribuir um argumento de construtor
para uma variável de instância, Dart tem *parâmetros formais inicializadores*.

Na declaração do construtor, inclua `this.<nomeDaPropriedade>`
e omita o corpo. A palavra-chave `this` refere-se à instância atual.

Quando o conflito de nomes existe, use `this`.
Caso contrário, o estilo Dart omite o `this`.
Existe uma exceção para o construtor generativo onde
você deve prefixar o nome do parâmetro formal inicializador com `this`.

Como observado anteriormente neste guia, certos construtores
e certas partes de construtores não podem acessar `this`. Estes incluem:

* Construtores factory
* O lado direito de uma lista de inicialização
* Argumentos para um construtor de superclasse

Parâmetros formais inicializadores também permitem que você inicialize
variáveis de instância não anuláveis ou `final`.
Ambos esses tipos de variáveis exigem inicialização ou um valor padrão.

<?code-excerpt "point_alt.dart (initialize-formal)" plaster="none"?>
```dart
class PointB {
  final double x;
  final double y;

  // Define as variáveis de instância x e y
  // antes da execução do corpo do construtor.
  PointB(this.x, this.y);

  // Parâmetros formais inicializadores também podem ser opcionais.
  PointB.optional([this.x = 0.0, this.y = 0.0]);
}
```

Campos privados não podem ser usados como formais inicializadores nomeados.

{% comment %}
Não anexe o exemplo a seguir a um trecho de código.
Não funciona de propósito e causará erros no CI.
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
  double x; // deve ser definido no construtor
  double y; // deve ser definido no construtor

  // Construtor generativo com parâmetros formais inicializadores
  // com valores padrão
  PointC.named({this.x = 1.0, this.y = 1.0});

  @override
  String toString() {
    return 'PointC.named($x,$y)';
  }
}

// Construtor usando variáveis nomeadas.
final pointC = PointC.named(x: 2.0, y: 2.0);
```

Todas as variáveis introduzidas a partir de parâmetros formais inicializadores são ambas
final e apenas no escopo das variáveis inicializadas.

Para realizar uma lógica que você não pode expressar na lista de inicialização,
crie um [construtor factory](#factory-constructors)
ou [método estático][static method] com essa lógica.
Você pode então passar os valores calculados para um construtor normal.

Os parâmetros do construtor podem ser definidos como anuláveis e não serem inicializados.

<?code-excerpt "point_alt.dart (initialize-null)" plaster="none"?>
```dart
class PointD {
  double? x; // nulo se não definido no construtor
  double? y; // nulo se não definido no construtor

  // Construtor generativo com parâmetros formais inicializadores
  PointD(this.x, this.y);

  @override
  String toString() {
    return 'PointD($x,$y)';
  }
}
```

### Use uma lista de inicialização

Antes da execução do corpo do construtor, você pode inicializar variáveis de instância.
Separe os inicializadores com vírgulas.

<?code-excerpt "point_alt.dart (initializer-list)"?>
```dart
// A lista de inicialização define variáveis de instância antes
// da execução do corpo do construtor.
Point.fromJson(Map<String, double> json)
    : x = json['x']!,
      y = json['y']! {
  print('Em Point.fromJson(): ($x, $y)');
}
```

:::warning
O lado direito de uma lista de inicialização não pode acessar `this`.
:::

Para validar as entradas durante o desenvolvimento,
use `assert` na lista de inicialização.

<?code-excerpt "point_alt.dart (initializer-list-with-assert)" replace="/assert\(.*?\)/[!$&!]/g"?>
```dart
Point.withAssert(this.x, this.y) : [!assert(x >= 0)!] {
  print('Em Point.withAssert(): ($x, $y)');
}
```

Listas de inicialização ajudam a configurar campos `final`.

O exemplo a seguir inicializa três campos `final` em uma lista de inicialização.
Para executar o código, clique em **Executar**.

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
Estes são chamados de [super parâmetros](#super-parameters)

Construtores funcionam de forma um tanto semelhante a
como você chama uma cadeia de métodos estáticos.
Cada subclasse pode chamar o construtor de sua superclasse para inicializar uma instância,
como uma subclasse pode chamar o método estático de uma superclasse.
Esse processo não "herda" corpos ou assinaturas de construtores.

### Construtores de superclasse não padrão

Dart executa construtores na seguinte ordem:

1. [lista de inicialização](#use-an-initializer-list)
1. construtor sem nome e sem argumentos da superclasse
1. construtor sem argumentos da classe principal

Se a superclasse não tiver um construtor sem nome e sem argumentos,
chame um dos construtores na superclasse.
Antes do corpo do construtor (se houver),
especifique o construtor da superclasse após os dois pontos (`:`).

No exemplo a seguir,
o construtor da classe `Employee` chama o construtor nomeado
para sua superclasse, `Person`. Para executar o código a seguir, clique em **Executar**.

<?code-excerpt "employee.dart (super)" plaster="none"?>
```dartpad
class Person {
  String? firstName;

  Person.fromJson(Map data) {
    print('em Person');
  }
}

class Employee extends Person {
  // Person não tem um construtor padrão;
  // você deve chamar super.fromJson().
  Employee.fromJson(Map data) : super.fromJson(data) {
    print('em Employee');
  }
}

void main() {
  var employee = Employee.fromJson({});
  print(employee);
  // Imprime:
  // em Person
  // em Employee
  // Instância de 'Employee'
}
```

Como Dart avalia os argumentos para o construtor da superclasse *antes* de
invocar o construtor, um argumento pode ser uma expressão como uma
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
Por exemplo, os argumentos podem chamar métodos *estáticos*
mas não métodos de *instância*.
:::

### Super parâmetros

Para evitar passar cada parâmetro para a invocação super de um construtor,
use parâmetros super-inicializadores para encaminhar parâmetros
para o construtor de superclasse especificado ou padrão.
Você não pode usar esse recurso com
[construtores de redirecionamento](#redirecting-constructors).
Super parâmetros inicializadores têm sintaxe e semântica como
[parâmetros formais inicializadores](#use-initializing-formal-parameters).

:::version-note
Usar parâmetros super-inicializadores
requer uma [versão de linguagem][language version] de pelo menos 2.17.
Se você estiver usando uma versão de idioma anterior,
você deve passar manualmente todos os parâmetros do construtor super.
:::

Se a invocação super-construtor incluir argumentos posicionais,
super parâmetros inicializadores não podem ser posicionais.

<?code-excerpt "super_initializer_positional_parameters.dart (positional)" plaster="none"?>
```dart
class Vector2d {
  final double x;
  final double y;

  Vector2d(this.x, this.y);
}

class Vector3d extends Vector2d {
  final double z;

  // Encaminhe os parâmetros x e y para o construtor super padrão como:
  // Vector3d(final double x, final double y, this.z) : super(x, y);
  Vector3d(super.x, super.y, this.z);
}
```

Para ilustrar ainda mais, considere o exemplo a seguir.

```dart
  // Se você invocar o super construtor (`super(0)`) com qualquer
  // argumentos posicionais, usar um super parâmetro (`super.x`)
  // resulta em um erro.
  Vector3d.xAxisError(super.x): z = 0, super(0); // RUIM
```

Este construtor nomeado tenta definir o valor `x` duas vezes:
uma vez no super construtor e uma vez como um
super parâmetro posicional.
Como ambos se referem ao parâmetro posicional `x`, isso resulta em um erro.

Quando o super construtor tem argumentos nomeados, você pode dividi-los
entre super parâmetros nomeados (`super.y` no próximo exemplo)
e argumentos nomeados para a invocação do super construtor
(`super.named(x: 0)`).

<?code-excerpt "super_initializer_named_parameters.dart (named)" plaster="none"?>
```dart
class Vector2d {
  // ...
  Vector2d.named({required this.x, required this.y});
}

class Vector3d extends Vector2d {
  final double z;

  // Encaminhe o parâmetro y para o construtor super nomeado como:
  // Vector3d.yzPlane({required double y, required this.z})
  //       : super.named(x: 0, y: y);
  Vector3d.yzPlane({required super.y, required this.z}) : super.named(x: 0);
}
```

[language version]: /resources/language/evolution#language-versioning
[using constructors]: /language/classes#using-constructors
[late-final-ivar]: /effective-dart/design#avoid-public-late-final-fields-without-initializers
[static method]: /language/classes#static-methods
