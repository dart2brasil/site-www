---
ia-translate: true
title: Construtores
description: Tudo sobre o uso de construtores em Dart.
js: [{url: '/assets/js/inject_dartpad.js', defer: true}]
prevpage:
  url: /language/classes
  title: Classes
nextpage:
  url: /language/methods
  title: Métodos
---

Construtores são funções especiais que criam instâncias de classes.

Dart implementa muitos tipos de construtores.
Exceto pelos construtores padrão,
essas funções usam o mesmo nome de sua classe.

* [Construtores generativos][generative]: Cria novas instâncias e
      inicializa variáveis de instância.
* [Construtores padrão][default]: Usado para criar uma nova instância quando um
      construtor não foi especificado. Ele não recebe argumentos e
      não é nomeado.
* [Construtores nomeados][named]: Clarifica o propósito de
      um construtor ou permite a criação de múltiplos construtores para
      a mesma classe.
* [Construtores constantes][constant]: Cria instâncias como constantes
      de tempo de compilação.
* [Construtores de fábrica][factory]: Ou cria uma nova instância de um
      subtipo ou retorna uma instância existente do cache.
* [Construtor de redirecionamento][redirecting]: Encaminha chamadas para outro
      construtor na mesma classe.

[default]: #default-constructors
[generative]: #generative-constructors
[named]: #named-constructors
[constant]: #constant-constructors
[factory]: #factory-constructors
[redirecting]: #redirecting-constructors

<?code-excerpt path-base="misc/lib/language_tour/classes"?>

<?code-excerpt replace="/ *\/\/\s+ignore_for_file:[^\n]+\n//g; /(^|\n) *\/\/\s+ignore:[^\n]+\n/$1/g; /(\n[^\n]+) *\/\/\s+ignore:[^\n]+\n/$1\n/g; / *\/\/\s+ignore:[^\n]+//g; /([A-Z]\w*)\d\b/$1/g"?>

## Tipos de construtores {:#types-of-constructors}

### Construtores generativos {:#generative-constructors}

Para instanciar uma classe, use um construtor generativo.

<?code-excerpt "point_alt.dart (idiomatic-constructor)" plaster="none"?>
```dart
class Point {
  // Variáveis de instância para armazenar as coordenadas do ponto.
  double x;
  double y;

  // Construtor generativo com parâmetros formais de inicialização:
  Point(this.x, this.y);
}
```

### Construtores padrão {:#default-constructors}

Se você não declarar um construtor, Dart usa o construtor padrão.
O construtor padrão é um construtor generativo sem argumentos ou nome.

### Construtores nomeados {:#named-constructors}

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

### Construtores constantes {:#constant-constructors}

Se sua classe produz objetos imutáveis, faça desses
objetos constantes de tempo de compilação.
Para fazer objetos constantes de tempo de compilação, defina um construtor `const`
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
Para saber mais, consulte a seção sobre [usando construtores][].

### Construtores de redirecionamento {:#redirecting-constructors}

Um construtor pode redirecionar para outro construtor na mesma classe.
Um construtor de redirecionamento tem um corpo vazio.
O construtor usa `this` em vez do nome da classe após dois pontos (:).

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

### Construtores de fábrica {:#factory-constructors}

Ao encontrar um dos dois casos seguintes de implementação de um construtor,
use a palavra-chave `factory`:

* O construtor nem sempre cria uma nova instância de sua classe.
  Embora um construtor de fábrica não possa retornar `null`,
  ele pode retornar:
  
  * uma instância existente de um cache em vez de criar uma nova
  * uma nova instância de um subtipo

* Você precisa executar um trabalho não trivial antes de construir uma instância.
  Isso pode incluir a verificação de argumentos ou qualquer outro processamento
  que não pode ser tratado na lista de inicializadores.

:::tip
Você também pode lidar com a inicialização tardia de uma variável final
com [`late final`][late-final-ivar] (com cuidado!).
:::

O exemplo a seguir inclui dois construtores de fábrica.

* O construtor de fábrica `Logger` retorna objetos de um cache.
* O construtor de fábrica `Logger.fromJson` inicializa uma variável final
  de um objeto JSON.

<?code-excerpt "logger.dart (constructors)"?>
```dart
class Logger {
  final String name;
  bool mute = false;

  // _cache é privado da biblioteca, graças ao
  // _ na frente de seu nome.
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
Construtores de fábrica não podem acessar `this`.
:::

Use um construtor de fábrica como qualquer outro construtor:

<?code-excerpt "logger.dart (logger)"?>
```dart
var logger = Logger('UI');
logger.log('Botão clicado');

var logMap = {'name': 'UI'};
var loggerJson = Logger.fromJson(logMap);
```

### Construtores de fábrica de redirecionamento {:#redirecting-factory-constructors}

Um construtor de fábrica de redirecionamento especifica uma chamada a um construtor de outra
classe para usar sempre que alguém faz uma chamada para o construtor de redirecionamento.

```dart
factory Listenable.merge(List<Listenable> listenables) = _MergingListenable
```

Pode parecer que construtores de fábrica comuns
poderiam criar e retornar instâncias de outras classes.
Isso tornaria as fábricas de redirecionamento desnecessárias.
As fábricas de redirecionamento têm várias vantagens:

* Uma classe abstrata pode fornecer um construtor constante
  que usa o construtor constante de outra classe.
* Um construtor de fábrica de redirecionamento evita a necessidade de encaminhadores
  para repetir os parâmetros formais e seus valores padrão.

### Tear-offs de construtores {:#constructor-tear-offs}

Dart permite que você forneça um construtor como um parâmetro sem chamá-lo.
Chamado de _tear-off_ (já que você _arranca_ os parênteses)
serve como um *closure* (fechamento) que invoca o construtor com os mesmos parâmetros.

Se o tear-off for um construtor com a mesma assinatura e tipo de retorno
que o método aceita, você pode usar o tear-off como um parâmetro ou variável.

Tear-offs diferem de *lambdas* ou funções anônimas.
Lambdas servem como um *wrapper* (envolvedor) para o construtor, enquanto um tear-off
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
// Em vez de um lambda para um construtor nomeado:
var strings = charCodes.map((code) => String.fromCharCode(code));

// Em vez de um lambda para um construtor não nomeado:
var buffers = charCodes.map((code) => StringBuffer(code));
```

Para mais discussão, assista a este vídeo Decoding Flutter sobre tear-offs.

{% ytEmbed "OmCaloD7sis", "Dart Tear-offs | Decoding Flutter" %}

## Inicialização de Variáveis de Instância {:#instance-variable-initialization}

Dart pode inicializar variáveis de três maneiras.

### Inicialize variáveis de instância na declaração {:#initialize-instance-variables-in-the-declaration}

Inicialize as variáveis de instância quando você declara as variáveis.

<?code-excerpt "point_alt.dart (initialize-declaration)" plaster="none"?>
```dart
class PointA {
  double x = 1.0;
  double y = 2.0;

  // O construtor padrão implícito define essas variáveis para (1.0, 2.0)
  // PointA();

  @override
  String toString() {
    return 'PointA($x,$y)';
  }
}
```

### Use parâmetros formais de inicialização {:#use-initializing-formal-parameters}

Para simplificar o padrão comum de atribuição de um argumento de construtor
a uma variável de instância, Dart tem *parâmetros formais de inicialização*.

Na declaração do construtor, inclua `this.<nomeDaPropriedade>`
e omita o corpo. A palavra-chave `this` se refere à instância atual.

Quando o conflito de nome existir, use `this`.
Caso contrário, o estilo Dart omite o `this`.
Uma exceção existe para o construtor generativo, onde
você deve prefixar o nome do parâmetro formal de inicialização com `this`.

Como observado anteriormente neste guia, certos construtores
e certas partes dos construtores não podem acessar `this`. Isso inclui:

* Construtores de fábrica
* O lado direito de uma lista de inicializadores
* Argumentos para um construtor de superclasse

Parâmetros formais de inicialização também permitem que você inicialize
variáveis de instância não anuláveis ou `final`.
Ambos os tipos de variáveis exigem inicialização ou um valor padrão.

<?code-excerpt "point_alt.dart (initialize-formal)" plaster="none"?>
```dart
class PointB {
  final double x;
  final double y;

  // Define as variáveis de instância x e y
  // antes da execução do corpo do construtor.
  PointB(this.x, this.y);

  // Parâmetros formais de inicialização também podem ser opcionais.
  PointB.optional([this.x = 0.0, this.y = 0.0]);
}
```

Campos privados não podem ser usados como parâmetros formais de inicialização nomeados.

{% comment %}
Não anexe o exemplo a seguir a um trecho de código.
Ele não funciona de propósito e causará erros no CI.
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
  double x; // deve ser definida no construtor
  double y; // deve ser definida no construtor

  // Construtor generativo com parâmetros formais de inicialização
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

Todas as variáveis introduzidas a partir de parâmetros formais de inicialização são
tanto final quanto apenas no escopo das variáveis inicializadas.

Para realizar uma lógica que você não pode expressar na lista de inicializadores,
crie um [construtor de fábrica](#factory-constructors)
ou [método estático][] com essa lógica.
Você pode então passar os valores calculados para um construtor normal.

Os parâmetros do construtor podem ser definidos como anuláveis e não serem inicializados.

<?code-excerpt "point_alt.dart (initialize-null)" plaster="none"?>
```dart
class PointD {
  double? x; // nulo se não definido no construtor
  double? y; // nulo se não definido no construtor

  // Construtor generativo com parâmetros formais de inicialização
  PointD(this.x, this.y);

  @override
  String toString() {
    return 'PointD($x,$y)';
  }
}
```

### Use uma lista de inicializadores {:#use-an-initializer-list}

Antes da execução do corpo do construtor, você pode inicializar variáveis de instância.
Separe os inicializadores com vírgulas.

<?code-excerpt "point_alt.dart (initializer-list)"?>
```dart
// A lista de inicializadores define as variáveis de instância antes
// da execução do corpo do construtor.
Point.fromJson(Map<String, double> json)
    : x = json['x']!,
      y = json['y']! {
  print('In Point.fromJson(): ($x, $y)');
}
```

:::warning
O lado direito de uma lista de inicializadores não pode acessar `this`.
:::

Para validar as entradas durante o desenvolvimento,
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

## Herança de construtores {:#constructor-inheritance}

_Subclasses_, ou classes filhas, não herdam *construtores*
de sua _superclasse_, ou classe pai imediata.
Se uma classe não declara um construtor, ela só pode usar o
[construtor padrão](#default-constructors).

Uma classe pode herdar os _parâmetros_ de uma superclasse.
Eles são chamados de [super parâmetros](#super-parameters)

Construtores funcionam de maneira um tanto semelhante a
como você chama uma cadeia de métodos estáticos.
Cada subclasse pode chamar o construtor de sua superclasse para inicializar uma instância,
assim como uma subclasse pode chamar o método estático de uma superclasse.
Este processo não "herda" corpos ou assinaturas de construtores.

### Construtores de superclasse não padrão {:#non-default-superclass-constructors}

Dart executa construtores na seguinte ordem:

1. [lista de inicializadores](#use-an-initializer-list)
1. construtor não nomeado sem argumentos da superclasse
1. construtor sem argumentos da classe principal

Se a superclasse não tiver um construtor não nomeado e sem argumentos,
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
  // Person não tem um construtor padrão;
  // você deve chamar super.fromJson().
  Employee.fromJson(Map data) : super.fromJson(data) {
    print('in Employee');
  }
}

void main() {
  var employee = Employee.fromJson({});
  print(employee);
  // Imprime:
  // in Person
  // in Employee
  // Instance of 'Employee'
}
```

Como o Dart avalia os argumentos para o construtor da superclasse *antes* de
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
Por exemplo, argumentos podem chamar métodos *estáticos*,
mas não métodos de *instância*.
:::

### Super parâmetros {:#super-parameters}

Para evitar passar cada parâmetro para a invocação super de um construtor,
use super-parâmetros de inicialização para encaminhar parâmetros
para o construtor de superclasse especificado ou padrão.
Você não pode usar esse recurso com
[construtores de redirecionamento](#redirecting-constructors).
Super-parâmetros de inicialização têm sintaxe e semântica como
[parâmetros formais de inicialização](#use-initializing-formal-parameters).

:::version-note
Usar super-parâmetros de inicialização
requer uma [versão de linguagem][] de pelo menos 2.17.
Se você estiver usando uma versão de linguagem anterior,
você deve passar manualmente todos os parâmetros do super construtor.
:::

Se a invocação do super-construtor incluir argumentos posicionais,
os super-parâmetros de inicialização não podem ser posicionais.

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

Para ilustrar ainda mais, considere o seguinte exemplo.

```dart
  // Se você invocar o super construtor (`super(0)`) com algum
  // argumentos posicionais, usar um super parâmetro (`super.x`)
  // resulta em um erro.
  Vector3d.xAxisError(super.x): z = 0, super(0); // RUIM
```

Este construtor nomeado tenta definir o valor de `x` duas vezes:
uma vez no super construtor e uma vez como um
super parâmetro posicional.
Como ambos abordam o parâmetro posicional `x`, isso resulta em um erro.

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
