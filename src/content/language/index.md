---
title: Introdução ao Dart
shortTitle: Básicos do Dart
breadcrumb: Language
description: Uma breve introdução aos programas Dart e conceitos importantes.
ia-translate: true
nextpage:
  url: /language/variables
  title: Variables
---

Esta página fornece uma breve introdução à linguagem Dart
através de amostras de seus principais recursos.

Para aprender mais sobre a linguagem Dart,
visite as páginas detalhadas de tópicos individuais
listadas em **Language** no menu lateral esquerdo.

Para cobertura das bibliotecas principais do Dart,
confira a [documentação da biblioteca principal](/libraries).
Você também pode conferir o [Dart cheatsheet](/resources/dart-cheatsheet),
para uma introdução mais interativa.


## Hello World

Cada aplicação requer a função `main()` de nível superior, onde a execução começa.
Funções que não retornam explicitamente um valor têm o tipo de retorno `void`.
Para exibir texto no console, você pode usar a função `print()` de nível superior:

<?code-excerpt "misc/test/samples_test.dart (hello-world)"?>
```dart
void main() {
  print('Hello, World!');
}
```

Leia mais sobre [a função `main()`][] em Dart,
incluindo parâmetros opcionais para argumentos de linha de comando.

[a função `main()`]: /language/functions#the-main-function

## Variáveis

Mesmo em código Dart [type-safe](/language/type-system),
você pode declarar a maioria das variáveis sem especificar explicitamente seu tipo usando `var`.
Graças à inferência de tipos, os tipos dessas variáveis são determinados por seus valores iniciais:


<?code-excerpt "misc/test/samples_test.dart (var)"?>
```dart
var name = 'Voyager I';
var year = 1977;
var antennaDiameter = 3.7;
var flybyObjects = ['Jupiter', 'Saturn', 'Uranus', 'Neptune'];
var image = {
  'tags': ['saturn'],
  'url': '//path/to/saturn.jpg',
};
```

[Leia mais](/language/variables) sobre variáveis em Dart,
incluindo valores padrão, as palavras-chave `final` e `const`, e tipos estáticos.


## Instruções de fluxo de controle

Dart suporta as instruções de fluxo de controle usuais:

<?code-excerpt "misc/test/samples_test.dart (control-flow)"?>
```dart
if (year >= 2001) {
  print('21st century');
} else if (year >= 1901) {
  print('20th century');
}

for (final object in flybyObjects) {
  print(object);
}

for (int month = 1; month <= 12; month++) {
  print(month);
}

while (year < 2016) {
  year += 1;
}
```

Leia mais sobre instruções de fluxo de controle em Dart,
incluindo [`break` e `continue`](/language/loops),
[`switch` e `case`](/language/branches),
e [`assert`](/language/error-handling#assert).


## Funções

[Recomendamos](/effective-dart/design#types)
especificar os tipos dos argumentos e valor de retorno de cada função:

<?code-excerpt "misc/test/samples_test.dart (functions)"?>
```dart
int fibonacci(int n) {
  if (n == 0 || n == 1) return n;
  return fibonacci(n - 1) + fibonacci(n - 2);
}

var result = fibonacci(20);
```

Uma sintaxe abreviada `=>` (_arrow_) é conveniente para funções que
contêm uma única instrução.
Esta sintaxe é especialmente útil ao passar funções anônimas como argumentos:

<?code-excerpt "misc/test/samples_test.dart (arrow)"?>
```dart
flybyObjects.where((name) => name.contains('turn')).forEach(print);
```

Além de mostrar uma função anônima (o argumento para `where()`),
este código mostra que você pode usar uma função como argumento:
a função `print()` de nível superior é um argumento para `forEach()`.

[Leia mais](/language/functions) sobre funções em Dart,
incluindo parâmetros opcionais, valores de parâmetro padrão e escopo léxico.


## Comentários

Comentários Dart geralmente começam com `//`.

```dart
// This is a normal, one-line comment.

/// This is a documentation comment, used to document libraries,
/// classes, and their members. Tools like IDEs and dartdoc treat
/// doc comments specially.

/* Comments like these are also supported. */
```

[Leia mais](/language/comments) sobre comentários em Dart,
incluindo como as ferramentas de documentação funcionam.


## Imports

Para acessar APIs definidas em outras bibliotecas, use `import`.

<?code-excerpt "misc/test/samples_test.dart (import)" plaster="none"?>
```dart
// Importing core libraries
import 'dart:math';

// Importing libraries from external packages
import 'package:test/test.dart';

// Importing files
import 'path/to/my_other_file.dart';
```

[Leia mais](/language/libraries)
sobre bibliotecas e visibilidade em Dart,
incluindo prefixos de biblioteca, `show` e `hide`,
e carregamento preguiçoso através da palavra-chave `deferred`.


## Classes

Aqui está um exemplo de uma classe com três propriedades, dois construtores,
e um método. Uma das propriedades não pode ser definida diretamente, então ela é
definida usando um método getter (em vez de uma variável). O método
usa interpolação de string para imprimir equivalentes de string de variáveis dentro
de literais de string.

<?code-excerpt "misc/lib/samples/spacecraft.dart (class)"?>
```dart
class Spacecraft {
  String name;
  DateTime? launchDate;

  // Read-only non-final property
  int? get launchYear => launchDate?.year;

  // Constructor, with syntactic sugar for assignment to members.
  Spacecraft(this.name, this.launchDate) {
    // Initialization code goes here.
  }

  // Named constructor that forwards to the default one.
  Spacecraft.unlaunched(String name) : this(name, null);

  // Method.
  void describe() {
    print('Spacecraft: $name');
    // Type promotion doesn't work on getters.
    var launchDate = this.launchDate;
    if (launchDate != null) {
      int years = DateTime.now().difference(launchDate).inDays ~/ 365;
      print('Launched: $launchYear ($years years ago)');
    } else {
      print('Unlaunched');
    }
  }
}
```

[Leia mais](/language/built-in-types#strings) sobre strings,
incluindo interpolação de string, literais, expressões e o método `toString()`.

Você pode usar a classe `Spacecraft` assim:

<?code-excerpt "misc/test/samples_test.dart (use-class)" plaster="none"?>
```dart
var voyager = Spacecraft('Voyager I', DateTime(1977, 9, 5));
voyager.describe();

var voyager3 = Spacecraft.unlaunched('Voyager III');
voyager3.describe();
```

[Leia mais](/language/classes) sobre classes em Dart,
incluindo listas de inicialização, `new` e `const` opcionais, construtores de redirecionamento,
construtores `factory`, getters, setters e muito mais.


## Enums

Enums são uma maneira de enumerar um conjunto predefinido de valores ou instâncias
de uma forma que garante que não podem existir outras instâncias desse tipo.

Aqui está um exemplo de um `enum` simples que define
uma lista simples de tipos de planeta predefinidos:

<?code-excerpt "misc/lib/samples/spacecraft.dart (simple-enum)"?>
```dart
enum PlanetType { terrestrial, gas, ice }
```

Aqui está um exemplo de uma declaração de enum aprimorado
de uma classe descrevendo planetas,
com um conjunto definido de instâncias constantes,
ou seja, os planetas do nosso próprio sistema solar.

<?code-excerpt "misc/lib/samples/spacecraft.dart (enhanced-enum)"?>
```dart
/// Enum that enumerates the different planets in our solar system
/// and some of their properties.
enum Planet {
  mercury(planetType: PlanetType.terrestrial, moons: 0, hasRings: false),
  venus(planetType: PlanetType.terrestrial, moons: 0, hasRings: false),
  // ···
  uranus(planetType: PlanetType.ice, moons: 27, hasRings: true),
  neptune(planetType: PlanetType.ice, moons: 14, hasRings: true);

  /// A constant generating constructor
  const Planet({
    required this.planetType,
    required this.moons,
    required this.hasRings,
  });

  /// All instance variables are final
  final PlanetType planetType;
  final int moons;
  final bool hasRings;

  /// Enhanced enums support getters and other methods
  bool get isGiant =>
      planetType == PlanetType.gas || planetType == PlanetType.ice;
}
```

Você pode usar o enum `Planet` assim:

<?code-excerpt "misc/test/samples_test.dart (use-enum)" plaster="none"?>
```dart
final yourPlanet = Planet.earth;

if (!yourPlanet.isGiant) {
  print('Your planet is not a "giant planet".');
}
```

Quando o compilador pode inferir o tipo do enum a partir do contexto,
você pode usar a sintaxe dot-shorthand mais concisa para acessar valores de enum.
Em vez de escrever o `EnumName.value` completo,
você pode escrever apenas `.value`. Isso pode tornar seu código mais limpo
e mais fácil de ler.


Por exemplo, ao declarar uma variável com um tipo explícito de `Planet`,
você pode omitir o nome do enum porque
o tipo de `Planet` já está estabelecido:


```dart
// Instead of the full, explicit syntax:
Planet myPlanet = Planet.venus;

// You can use a dot shorthand:
Planet myPlanet = .venus;
```

Dot shorthands não estão limitados a declarações de variáveis.
Eles também podem ser usados em contextos como argumentos de função
e casos switch onde o tipo de enum é claro para o compilador.

[Leia mais](/language/enums) sobre enums em Dart,
incluindo requisitos de enum aprimorado, propriedades automaticamente introduzidas,
acesso a nomes de valores enumerados, suporte a instrução switch e muito mais.
[Leia mais](/language/dot-shorthands) sobre sintaxe dot shorthand.


## Herança

Dart tem herança única.

<?code-excerpt "misc/lib/samples/spacecraft.dart (extends)"?>
```dart
class Orbiter extends Spacecraft {
  double altitude;

  Orbiter(super.name, DateTime super.launchDate, this.altitude);
}
```

[Leia mais](/language/extend)
sobre extensão de classes, a anotação `@override` opcional e muito mais.


## Mixins

Mixins são uma maneira de reutilizar código em múltiplas hierarquias de classes. O seguinte é
uma declaração de mixin:

<?code-excerpt "misc/lib/samples/spacecraft.dart (mixin)"?>
```dart
mixin Piloted {
  int astronauts = 1;

  void describeCrew() {
    print('Number of astronauts: $astronauts');
  }
}
```

Para adicionar as capacidades de um mixin a uma classe, apenas estenda a classe com o mixin.

<?code-excerpt "misc/lib/samples/spacecraft.dart (mixin-use)" replace="/with/[!$&!]/g"?>
```dart
class PilotedCraft extends Spacecraft [!with!] Piloted {
  // ···
}
```

`PilotedCraft` agora tem o campo `astronauts` assim como o método `describeCrew()`.

[Leia mais](/language/mixins) sobre mixins.


## Interfaces e classes abstratas

Todas as classes implicitamente definem uma interface.
Portanto, você pode implementar qualquer classe.

<?code-excerpt "misc/lib/samples/spacecraft.dart (implements)"?>
```dart
class MockSpaceship implements Spacecraft {
  // ···
}
```

Leia mais sobre [interfaces implícitas](/language/classes#implicit-interfaces), ou
sobre a palavra-chave explícita [`interface`](/language/class-modifiers#interface).

Você pode criar uma classe abstrata
para ser estendida (ou implementada) por uma classe concreta.
Classes abstratas podem conter métodos abstratos (com corpos vazios).

<?code-excerpt "misc/lib/samples/spacecraft.dart (abstract)" replace="/abstract/[!$&!]/g"?>
```dart
[!abstract!] class Describable {
  void describe();

  void describeWithEmphasis() {
    print('=========');
    describe();
    print('=========');
  }
}
```

Qualquer classe estendendo `Describable` tem o método `describeWithEmphasis()`,
que chama a implementação do estendedor de `describe()`.

[Leia mais](/language/class-modifiers#abstract)
sobre classes e métodos abstratos.


## Async

Evite callback hell e torne seu código muito mais legível
usando `async` e `await`.

<?code-excerpt "misc/test/samples_test.dart (async)" replace="/async/[!$&!]/g"?>
```dart
const oneSecond = Duration(seconds: 1);
// ···
Future<void> printWithDelay(String message) [!async!] {
  await Future.delayed(oneSecond);
  print(message);
}
```

O método acima é equivalente a:

<?code-excerpt "misc/test/samples_test.dart (future-then)"?>
```dart
Future<void> printWithDelay(String message) {
  return Future.delayed(oneSecond).then((_) {
    print(message);
  });
}
```

Como o próximo exemplo mostra, `async` e `await` ajudam a tornar código assíncrono
fácil de ler.

<?code-excerpt "misc/test/samples_test.dart (await)"?>
```dart
Future<void> createDescriptions(Iterable<String> objects) async {
  for (final object in objects) {
    try {
      var file = File('$object.txt');
      if (await file.exists()) {
        var modified = await file.lastModified();
        print(
          'File for $object already exists. It was modified on $modified.',
        );
        continue;
      }
      await file.create();
      await file.writeAsString('Start describing $object in this file.');
    } on IOException catch (e) {
      print('Cannot create description for $object: $e');
    }
  }
}
```

Você também pode usar `async*`, que lhe dá uma maneira agradável e legível de construir streams.

<?code-excerpt "misc/test/samples_test.dart (async-star)"?>
```dart
Stream<String> report(Spacecraft craft, Iterable<String> objects) async* {
  for (final object in objects) {
    await Future.delayed(oneSecond);
    yield '${craft.name} flies by $object';
  }
}
```

[Leia mais](/language/async) sobre
suporte a assincronia, incluindo funções `async`, `Future`, `Stream`,
e o loop assíncrono (`await for`).


## Exceções

Para lançar uma exceção, use `throw`:

<?code-excerpt "misc/test/samples_test.dart (throw)"?>
```dart
if (astronauts == 0) {
  throw StateError('No astronauts.');
}
```

Para capturar uma exceção, use uma instrução `try` com `on` ou `catch` (ou ambos):

<?code-excerpt "misc/test/samples_test.dart (try)" replace="/on.*e\)/[!$&!]/g"?>
```dart
Future<void> describeFlybyObjects(List<String> flybyObjects) async {
  try {
    for (final object in flybyObjects) {
      var description = await File('$object.txt').readAsString();
      print(description);
    }
  } [!on IOException catch (e)!] {
    print('Could not describe object: $e');
  } finally {
    flybyObjects.clear();
  }
}
```

Note que o código acima é assíncrono;
`try` funciona tanto para código síncrono quanto assíncrono em uma função `async`.

[Leia mais](/language/error-handling#exceptions) sobre exceções,
incluindo stack traces, `rethrow`,
e a diferença entre `Error` e `Exception`.


## Conceitos importantes

Ao continuar a aprender sobre a linguagem Dart,
mantenha esses fatos e conceitos em mente:

-   Tudo o que você pode colocar em uma variável é um *objeto*, e todo
    objeto é uma instância de uma *classe*. Até números, funções e
    `null` são objetos.
    Com exceção de `null` (se você habilitar [null safety sólido][ns]),
    todos os objetos herdam da classe [`Object`][].

    :::version-note
    [Null safety][ns] foi introduzido no Dart 2.12.
    Usar null safety requer uma [versão de linguagem][language version] de pelo menos 2.12.
    :::

-   Embora Dart seja fortemente tipado, anotações de tipo são opcionais
    porque Dart pode inferir tipos. Em `var number = 101`, `number`
    é inferido como sendo do tipo `int`.

-   Se você habilitar [null safety][ns],
    variáveis não podem conter `null` a menos que você diga que podem.
    Você pode tornar uma variável nullable colocando
    um ponto de interrogação (`?`) no final do seu tipo.
    Por exemplo, uma variável do tipo `int?` pode ser um inteiro,
    ou pode ser `null`.
    Se você _sabe_ que uma expressão nunca avalia para `null`
    mas Dart discorda,
    você pode adicionar `!` para afirmar que não é null
    (e para lançar uma exceção se for).
    Um exemplo: `int x = nullableButNotNullInt!`

-   Quando você quer explicitamente dizer
    que qualquer tipo é permitido, use o tipo `Object?`
    (se você habilitou null safety), `Object`,
    ou—se você deve adiar verificação de tipo até o tempo de execução—o
    [tipo especial `dynamic`][ObjectVsDynamic].

-   Dart suporta tipos genéricos, como `List<int>` (uma lista de inteiros)
    ou `List<Object>` (uma lista de objetos de qualquer tipo).

-   Dart suporta funções de nível superior (como `main()`), assim como
    funções vinculadas a uma classe ou objeto (métodos *static* e *instance*,
    respectivamente). Você também pode criar funções dentro
    de funções (funções *nested* ou *local*).

-   Similarmente, Dart suporta *variáveis* de nível superior, assim como variáveis
    vinculadas a uma classe ou objeto (variáveis static e instance). Variáveis instance
    são às vezes conhecidas como *fields* ou *properties*.

-   Diferente de Java, Dart não tem as palavras-chave `public`, `protected`,
    e `private`. Se um identificador começa com um underscore (`_`), é
    privado para sua biblioteca. Para detalhes, veja
    [Libraries and imports][].

-   *Identificadores* podem começar com uma letra ou underscore (`_`), seguido por qualquer
    combinação desses caracteres mais dígitos.

-   Dart tem tanto *expressões* (que têm valores em tempo de execução) quanto
    *instruções* (que não têm).
    Por exemplo, a [expressão condicional][conditional expression]
    `condition ? expr1 : expr2` tem um valor de `expr1` ou `expr2`.
    Compare isso com uma [instrução if-else][if-else statement], que não tem valor.
    Uma instrução frequentemente contém uma ou mais expressões,
    mas uma expressão não pode conter diretamente uma instrução.

-   Ferramentas Dart podem reportar dois tipos de problemas: _warnings_ e _errors_.
    Warnings são apenas indicações de que seu código pode não funcionar, mas
    eles não impedem que seu programa execute. Errors podem ser tanto
    em tempo de compilação quanto em tempo de execução. Um erro de tempo de compilação impede que o código
    execute de qualquer forma; um erro de tempo de execução resulta em uma
    [exceção][exception] sendo lançada enquanto o código executa.


## Recursos adicionais

Você pode encontrar mais documentação e exemplos de código na
[documentação da biblioteca principal](/libraries/dart-core)
e na [referência da API Dart]({{site.dart-api}}).
O código deste site segue as convenções no
[guia de estilo Dart](/effective-dart/style).

[Dart language specification]: /resources/language/spec
[Comments]: /language/comments
[built-in types]: /language/built-in-types
[Strings]: /language/built-in-types#strings
[The main() function]: /language/functions#the-main-function
[ns]: /null-safety
[`Object`]: {{site.dart-api}}/dart-core/Object-class.html
[language version]: /resources/language/evolution#language-versioning
[ObjectVsDynamic]: /effective-dart/design#avoid-using-dynamic-unless-you-want-to-disable-static-checking
[Libraries and imports]: /language/libraries
[conditional expression]: /language/operators#conditional-expressions
[if-else statement]: /language/branches#if
[exception]: /language/error-handling#exceptions
