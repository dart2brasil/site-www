---
ia-translate: true
title: "Introdução ao Dart"
shortTitle: Básico do Dart
breadcrumb: Language
description: "Uma breve introdução aos programas Dart e conceitos importantes."
nextpage:
  url: /language/variables
  title: "Variáveis"
---

Esta página fornece uma breve introdução à linguagem Dart
através de exemplos de suas principais funcionalidades.

Para aprender mais sobre a linguagem Dart,
visite as páginas detalhadas de tópicos individuais
listadas em **Linguagem** no menu lateral esquerdo.

Para obter cobertura das bibliotecas principais do Dart,
confira a [documentação da biblioteca principal](/libraries).
Você também pode conferir o [guia de consulta do Dart](/resources/dart-cheatsheet),
para uma introdução mais interativa.


## Olá Mundo {:#hello-world}

Todo aplicativo requer a função `main()` de nível superior, onde a execução começa.
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

## Variáveis {:#variables}

Mesmo em código Dart [type-safe] (/language/type-system) (com segurança de tipos),
você pode declarar a maioria das variáveis sem especificar explicitamente seu tipo usando `var`.
Graças à inferência de tipo, os tipos dessas variáveis são determinados por seus valores iniciais:


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


## Comandos de fluxo de controle {:#control-flow-statements}

Dart suporta os comandos de fluxo de controle usuais:

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

Leia mais sobre comandos de fluxo de controle em Dart,
incluindo [`break` e `continue`](/language/loops),
[`switch` e `case`](/language/branches),
e [`assert`](/language/error-handling#assert).


## Funções {:#functions}

[Recomendamos](/effective-dart/design#types)
especificar os tipos de cada argumento de função e valor de retorno:

<?code-excerpt "misc/test/samples_test.dart (functions)"?>
```dart
int fibonacci(int n) {
  if (n == 0 || n == 1) return n;
  return fibonacci(n - 1) + fibonacci(n - 2);
}

var result = fibonacci(20);
```

Uma sintaxe abreviada `=>` (_arrow_) é útil para funções que
contêm uma única instrução.
Essa sintaxe é especialmente útil ao passar funções anônimas como argumentos:

<?code-excerpt "misc/test/samples_test.dart (arrow)"?>
```dart
flybyObjects.where((name) => name.contains('turn')).forEach(print);
```

Além de mostrar uma função anônima (o argumento para `where()`),
este código mostra que você pode usar uma função como um argumento:
a função `print()` de nível superior é um argumento para `forEach()`.

[Leia mais](/language/functions) sobre funções em Dart,
incluindo parâmetros opcionais, valores de parâmetros padrão e escopo léxico.


## Comentários {:#comments}

Comentários em Dart geralmente começam com `//`.

```dart
// Este é um comentário normal de uma linha.

/// Este é um comentário de documentação, usado para documentar bibliotecas,
/// classes e seus membros. Ferramentas como IDEs e dartdoc tratam
/// comentários de doc de forma especial.

/* Comentários como estes também são suportados. */
```

[Leia mais](/language/comments) sobre comentários em Dart,
incluindo como a ferramenta de documentação funciona.


## Imports {:#imports}

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
e carregamento lento através da palavra-chave `deferred`.


## Classes {:#classes}

Aqui está um exemplo de uma classe com três propriedades, dois construtores,
e um método. Uma das propriedades não pode ser definida diretamente, então é
definida usando um método getter (em vez de uma variável). O método
usa interpolação de string para imprimir os equivalentes de string das variáveis dentro
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
incluindo listas de inicializadores, opcionais `new` e `const`, construtores de redirecionamento,
construtores `factory`, getters, setters e muito mais.


## Enums {:#enums}

Enums (Enumerações) são uma forma de enumerar um conjunto predefinido de valores ou instâncias
de uma forma que garante que não pode haver nenhuma outra instância desse tipo.

Aqui está um exemplo de um `enum` simples que define
uma lista simples de tipos de planetas predefinidos:

<?code-excerpt "misc/lib/samples/spacecraft.dart (simple-enum)"?>
```dart
enum PlanetType { terrestrial, gas, ice }
```

Aqui está um exemplo de uma declaração de enumeração aprimorada
de uma classe que descreve planetas,
com um conjunto definido de instâncias constantes,
nomeadamente os planetas do nosso próprio sistema solar.

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

Você pode usar o `enum` `Planet` assim:

<?code-excerpt "misc/test/samples_test.dart (use-enum)" plaster="none"?>
```dart
final yourPlanet = Planet.earth;

if (!yourPlanet.isGiant) {
  print('Your planet is not a "giant planet".');
}
```

Quando o compilador pode inferir o tipo enum do contexto,
você pode usar a sintaxe dot-shorthand (abreviação com ponto) mais concisa para acessar valores enum.
Em vez de escrever o `EnumName.value` completo,
você pode simplesmente escrever `.value`. Isso pode tornar seu código mais limpo
e fácil de ler.


Por exemplo, ao declarar uma variável com um tipo explícito de `Planet`,
você pode omitir o nome do enum porque
o tipo de `Planet` já está estabelecido:


```dart
// Instead of the full, explicit syntax:
Planet myPlanet = Planet.venus;

// You can use a dot shorthand:
Planet myPlanet = .venus;
```

Dot shorthands não se limitam a declarações de variáveis.
Eles também podem ser usados em contextos como argumentos de função
e casos de switch onde o tipo enum é claro para o compilador.

[Leia mais](/language/enums) sobre enums em Dart,
incluindo requisitos de enum aprimorado, propriedades introduzidas automaticamente,
acessando nomes de valores enumerados, suporte a comando switch e muito mais.
[Leia mais](/language/dot-shorthands) sobre a sintaxe dot shorthand. 


## Herança {:#inheritance}

Dart tem herança única.

<?code-excerpt "misc/lib/samples/spacecraft.dart (extends)"?>
```dart
class Orbiter extends Spacecraft {
  double altitude;

  Orbiter(super.name, DateTime super.launchDate, this.altitude);
}
```

[Leia mais](/language/extend)
sobre como estender classes, a anotação opcional `@override` e muito mais.


## Mixins {:#mixins}

Mixins são uma forma de reutilizar código em várias hierarquias de classes. O seguinte é
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

Para adicionar os recursos de um mixin a uma classe, basta estender a classe com o mixin.

<?code-excerpt "misc/lib/samples/spacecraft.dart (mixin-use)" replace="/with/[!$&!]/g"?>
```dart
class PilotedCraft extends Spacecraft [!with!] Piloted {
  // ···
}
```

`PilotedCraft` agora tem o campo `astronauts`, bem como o método `describeCrew()`.

[Leia mais](/language/mixins) sobre mixins.


## Interfaces e classes abstratas {:#interfaces-and-abstract-classes}

Todas as classes definem implicitamente uma interface.
Portanto, você pode implementar qualquer classe.

<?code-excerpt "misc/lib/samples/spacecraft.dart (implements)"?>
```dart
class MockSpaceship implements Spacecraft {
  // ···
}
```

Leia mais sobre [interfaces implícitas](/language/classes#implicit-interfaces), ou
sobre a palavra-chave explícita [`interface` ](/language/class-modifiers#interface).

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

Qualquer classe que estenda `Describable` tem o método `describeWithEmphasis()`,
que chama a implementação do extensor de `describe()`.

[Leia mais](/language/class-modifiers#abstract)
sobre classes e métodos abstratos.


## Async {:#async}

Evite o callback hell (inferno de callbacks) e torne seu código muito mais legível usando
`async` e `await`.

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

Como mostra o próximo exemplo, `async` e `await` ajudam a tornar o código assíncrono
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

Você também pode usar `async*`, que oferece uma maneira agradável e legível de construir streams (fluxos).

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
suporte à assincronia, incluindo funções `async`, `Future`, `Stream`,
e o loop assíncrono (`await for`).


## Exceções {:#exceptions}

Para gerar uma exceção, use `throw`:

<?code-excerpt "misc/test/samples_test.dart (throw)"?>
```dart
if (astronauts == 0) {
  throw StateError('No astronauts.');
}
```

Para capturar uma exceção, use uma declaração `try` com `on` ou `catch` (ou ambos):

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

Observe que o código acima é assíncrono;
`try` funciona tanto para código síncrono quanto assíncrono em uma função `async`.

[Leia mais](/language/error-handling#exceptions) sobre exceções,
incluindo stack traces (rastreamento de pilha), `rethrow`,
e a diferença entre `Error` e `Exception`.


## Conceitos importantes {:#important-concepts}

À medida que você continua aprendendo sobre a linguagem Dart,
tenha em mente estes fatos e conceitos:

-   Tudo o que você pode colocar em uma variável é um *objeto*, e todo
    objeto é uma instância de uma *classe*. Até mesmo números, funções e
    `null` são objetos.
    Com exceção de `null` (se você habilitar [sound null safety][ns]),
    todos os objetos herdam da classe [`Object`][].

    :::version-note
    [Null safety][ns] (Segurança nula) foi introduzido no Dart 2.12.
    Usar null safety requer uma [versão de linguagem][] de pelo menos 2.12.
    :::

-   Embora Dart seja fortemente tipado, as anotações de tipo são opcionais
    porque o Dart pode inferir tipos. Em `var number = 101`, `number`
    é inferido como sendo do tipo `int`.

-   Se você habilitar [null safety][ns],
    variáveis não podem conter `null` a menos que você diga que podem.
    Você pode tornar uma variável anulável colocando
    um ponto de interrogação (`?`) no final de seu tipo.
    Por exemplo, uma variável do tipo `int?` pode ser um inteiro,
    ou pode ser `null`.
    Se você _sabe_ que uma expressão nunca é avaliada como `null`
    mas o Dart discorda,
    você pode adicionar `!` para afirmar que não é nulo
    (e para lançar uma exceção se for).
    Um exemplo: `int x = nullableButNotNullInt!`

-   Quando você deseja dizer explicitamente
    que qualquer tipo é permitido, use o tipo `Object?`
    (se você habilitou null safety), `Object`,
    ou—se você precisar adiar a verificação de tipo até o tempo de execução—o
    [tipo especial `dynamic`][ObjectVsDynamic].

-   Dart suporta tipos genéricos, como `List<int>` (uma lista de inteiros)
    ou `List<Object>` (uma lista de objetos de qualquer tipo).

-   Dart suporta funções de nível superior (como `main()`), bem como
    funções vinculadas a uma classe ou objeto (*métodos estáticos* e *de instância*,
    respectivamente). Você também pode criar funções dentro
    de funções (*funções aninhadas* ou *locais*).

-   Da mesma forma, Dart suporta *variáveis* de nível superior, bem como variáveis
    vinculadas a uma classe ou objeto (variáveis estáticas e de instância). Instância
    variáveis são às vezes conhecidas como *campos* ou *propriedades*.

-   Ao contrário do Java, Dart não possui as palavras-chave `public`, `protected`
    e `private`. Se um identificador começar com um sublinhado (`_`), ele é
    privado para sua biblioteca. Para detalhes, veja
    [Bibliotecas e imports][].

-   *Identificadores* podem começar com uma letra ou sublinhado (`_`), seguido por qualquer
    combinação desses caracteres mais dígitos.

-   Dart tem *expressões* (que têm valores de tempo de execução) e
    *comandos* (que não têm).
    Por exemplo, a [expressão condicional][]
    `condição ? expr1 : expr2` tem um valor de `expr1` ou `expr2`.
    Compare isso com um [comando if-else][], que não tem valor.
    Um comando geralmente contém uma ou mais expressões,
    mas uma expressão não pode conter diretamente um comando.

-   As ferramentas Dart podem relatar dois tipos de problemas: _avisos_ e _erros_.
    Avisos são apenas indicações de que seu código pode não funcionar, mas
    eles não impedem que seu programa seja executado. Os erros podem ser de
    tempo de compilação ou tempo de execução. Um erro de tempo de compilação impede que o código
    de ser executado; um erro de tempo de execução resulta em um
    [exceção][] sendo gerada enquanto o código é executado.


## Recursos adicionais {:#additional-resources}

Você pode encontrar mais documentação e amostras de código no
[documentação da biblioteca principal](/libraries/dart-core)
e a [referência da API do Dart]({{site.dart-api}}).
O código deste site segue as convenções do
[guia de estilo Dart](/effective-dart/style).

[Especificação da linguagem Dart]: /resources/language/spec
[Comentários]: /language/comments
[tipos internos]: /language/built-in-types
[Strings]: /language/built-in-types#strings
[A função main()]: /language/functions#the-main-function
[ns]: /null-safety
[`Object`]: {{site.dart-api}}/dart-core/Object-class.html
[versão de linguagem]: /resources/language/evolution#language-versioning
[ObjectVsDynamic]: /effective-dart/design#avoid-using-dynamic-unless-you-want-to-disable-static-checking
[Bibliotecas e imports]: /language/libraries
[expressão condicional]: /language/operators#conditional-expressions
[comando if-else]: /language/branches#if
[exceção]: /language/error-handling#exceptions
