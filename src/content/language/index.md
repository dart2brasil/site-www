---
ia-translate: true
title: Introdução ao Dart
description: Uma breve introdução aos programas Dart e conceitos importantes.
short-title: Fundamentos do Dart
nextpage:
  url: /language/variables
  title: Variáveis
---

Esta página fornece uma breve introdução à linguagem Dart
através de exemplos de suas principais funcionalidades.

Para aprender mais sobre a linguagem Dart,
visite as páginas de tópicos individuais e aprofundados
listadas em **Linguagem** no menu lateral esquerdo.

Para a cobertura das bibliotecas principais do Dart,
confira a [documentação da biblioteca principal](/libraries).
Você também pode conferir o [guia de consulta do Dart](/resources/dart-cheatsheet),
para uma introdução mais interativa.

## Olá Mundo

Todo aplicativo requer a função `main()` de nível superior, onde a execução começa.
Funções que não retornam explicitamente um valor têm o tipo de retorno `void`.
Para exibir texto no console, você pode usar a função `print()` de nível superior:

<?code-excerpt "misc/test/samples_test.dart (hello-world)"?>
```dart
void main() {
  print('Olá, Mundo!');
}
```

Leia mais sobre [a função `main()`][a função `main()`] em Dart,
incluindo parâmetros opcionais para argumentos de linha de comando.

[a função `main()`]: /language/functions#the-main-function

## Variáveis

Mesmo em código Dart [com segurança de tipo](/language/type-system),
você pode declarar a maioria das variáveis sem especificar seu tipo explicitamente usando `var`.
Graças à inferência de tipo, os tipos dessas variáveis são determinados por seus valores iniciais:

<?code-excerpt "misc/test/samples_test.dart (var)"?>
```dart
var name = 'Voyager I';
var year = 1977;
var antennaDiameter = 3.7;
var flybyObjects = ['Jupiter', 'Saturn', 'Uranus', 'Neptune'];
var image = {
  'tags': ['saturn'],
  'url': '//path/to/saturn.jpg'
};
```

[Leia mais](/language/variables) sobre variáveis em Dart,
incluindo valores padrão, as palavras-chave `final` e `const` e tipos estáticos.

## Instruções de fluxo de controle

Dart oferece suporte às instruções de fluxo de controle usuais:

<?code-excerpt "misc/test/samples_test.dart (control-flow)"?>
```dart
if (year >= 2001) {
  print('Século 21');
} else if (year >= 1901) {
  print('Século 20');
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
[`switch` e `case`](/language/branches) e
[`assert`](/language/error-handling#assert).

## Funções

[Recomendamos](/effective-dart/design#types)
especificar os tipos dos argumentos e do valor de retorno de cada função:

<?code-excerpt "misc/test/samples_test.dart (functions)"?>
```dart
int fibonacci(int n) {
  if (n == 0 || n == 1) return n;
  return fibonacci(n - 1) + fibonacci(n - 2);
}

var result = fibonacci(20);
```

Uma sintaxe abreviada `=>` (_seta_) é útil para funções que
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

## Comentários

Os comentários em Dart geralmente começam com `//`.

```dart
// Este é um comentário normal de uma linha.

/// Este é um comentário de documentação, usado para documentar bibliotecas,
/// classes e seus membros. Ferramentas como IDEs e dartdoc tratam
/// comentários de documentação de forma especial.

/* Comentários como estes também são suportados. */
```

[Leia mais](/language/comments) sobre comentários em Dart,
incluindo como as ferramentas de documentação funcionam.

## Imports

Para acessar APIs definidas em outras bibliotecas, use `import`.

<?code-excerpt "misc/test/samples_test.dart (import)" plaster="none"?>
```dart
// Importando bibliotecas principais
import 'dart:math';

// Importando bibliotecas de pacotes externos
import 'package:test/test.dart';

// Importando arquivos
import 'path/to/my_other_file.dart';
```

[Leia mais](/language/libraries)
sobre bibliotecas e visibilidade em Dart,
incluindo prefixos de biblioteca, `show` e `hide` e
carregamento lento através da palavra-chave `deferred`.

## Classes

Aqui está um exemplo de uma classe com três propriedades, dois construtores e
um método. Uma das propriedades não pode ser definida diretamente, então ela é
definida usando um método getter (em vez de uma variável). O método
usa interpolação de string para imprimir equivalentes de string de variáveis dentro
de literais de string.

<?code-excerpt "misc/lib/samples/spacecraft.dart (class)"?>
```dart
class Spacecraft {
  String name;
  DateTime? launchDate;

  // Propriedade somente leitura não final
  int? get launchYear => launchDate?.year;

  // Construtor, com açúcar sintático para atribuição a membros.
  Spacecraft(this.name, this.launchDate) {
    // O código de inicialização vai aqui.
  }

  // Construtor nomeado que encaminha para o padrão.
  Spacecraft.unlaunched(String name) : this(name, null);

  // Método.
  void describe() {
    print('Nave Espacial: $name');
    // A promoção de tipo não funciona em getters.
    var launchDate = this.launchDate;
    if (launchDate != null) {
      int years = DateTime.now().difference(launchDate).inDays ~/ 365;
      print('Lançada em: $launchYear ($years anos atrás)');
    } else {
      print('Não Lançada');
    }
  }
}
```

[Leia mais](/language/built-in-types#strings) sobre strings,
incluindo interpolação de strings, literais, expressões e o método `toString()`.

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

Enums são uma forma de enumerar um conjunto predefinido de valores ou instâncias
de uma forma que garante que não pode haver outras instâncias desse tipo.

Aqui está um exemplo de um `enum` simples que define
uma lista simples de tipos de planetas predefinidos:

<?code-excerpt "misc/lib/samples/spacecraft.dart (simple-enum)"?>
```dart
enum PlanetType { terrestrial, gas, ice }
```

Aqui está um exemplo de uma declaração de enum aprimorada
de uma classe que descreve planetas,
com um conjunto definido de instâncias constantes,
nomeadamente os planetas do nosso próprio sistema solar.

<?code-excerpt "misc/lib/samples/spacecraft.dart (enhanced-enum)"?>
```dart
/// Enum que enumera os diferentes planetas do nosso sistema solar
/// e algumas de suas propriedades.
enum Planet {
  mercury(planetType: PlanetType.terrestrial, moons: 0, hasRings: false),
  venus(planetType: PlanetType.terrestrial, moons: 0, hasRings: false),
  // ···
  uranus(planetType: PlanetType.ice, moons: 27, hasRings: true),
  neptune(planetType: PlanetType.ice, moons: 14, hasRings: true);

  /// Um construtor constante gerador
  const Planet(
      {required this.planetType, required this.moons, required this.hasRings});

  /// Todas as variáveis ​​de instância são finais
  final PlanetType planetType;
  final int moons;
  final bool hasRings;

  /// Enums aprimorados oferecem suporte a getters e outros métodos
  bool get isGiant =>
      planetType == PlanetType.gas || planetType == PlanetType.ice;
}
```

Você pode usar o enum `Planet` assim:

<?code-excerpt "misc/test/samples_test.dart (use-enum)" plaster="none"?>
```dart
final yourPlanet = Planet.earth;

if (!yourPlanet.isGiant) {
  print('Seu planeta não é um "planeta gigante".');
}
```

[Leia mais](/language/enums) sobre enums em Dart,
incluindo requisitos de enum aprimorados, propriedades introduzidas automaticamente,
acessando nomes de valores enumerados, suporte a instruções switch e muito mais.

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
sobre estender classes, a anotação opcional `@override` e muito mais.

## Mixins

Mixins são uma maneira de reutilizar código em várias hierarquias de classe. O seguinte é
uma declaração mixin:

<?code-excerpt "misc/lib/samples/spacecraft.dart (mixin)"?>
```dart
mixin Piloted {
  int astronauts = 1;

  void describeCrew() {
    print('Número de astronautas: $astronauts');
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

## Interfaces e classes abstratas

Todas as classes definem implicitamente uma interface.
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

Qualquer classe que estenda `Describable` tem o método `describeWithEmphasis()`,
que chama a implementação do extensor de `describe()`.

[Leia mais](/language/class-modifiers#abstract)
sobre classes e métodos abstratos.

## Async

Evite o inferno de callback e torne seu código muito mais legível usando
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

Como o próximo exemplo mostra, `async` e `await` ajudam a tornar o código assíncrono
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
            'Arquivo para $object já existe. Ele foi modificado em $modified.');
        continue;
      }
      await file.create();
      await file.writeAsString('Comece a descrever $object neste arquivo.');
    } on IOException catch (e) {
      print('Não é possível criar a descrição para $object: $e');
    }
  }
}
```

Você também pode usar `async*`, que oferece uma maneira agradável e legível de criar streams.

<?code-excerpt "misc/test/samples_test.dart (async-star)"?>
```dart
Stream<String> report(Spacecraft craft, Iterable<String> objects) async* {
  for (final object in objects) {
    await Future.delayed(oneSecond);
    yield '${craft.name} passa por $object';
  }
}
```

[Leia mais](/language/async) sobre
suporte a assincronia, incluindo funções `async`, `Future`, `Stream`,
e o loop assíncrono (`await for`).

## Exceções

Para gerar uma exceção, use `throw`:

<?code-excerpt "misc/test/samples_test.dart (throw)"?>
```dart
if (astronauts == 0) {
  throw StateError('Sem astronautas.');
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
    print('Não foi possível descrever o objeto: $e');
  } finally {
    flybyObjects.clear();
  }
}
```

Observe que o código acima é assíncrono;
`try` funciona para código síncrono e código em uma função `async`.

[Leia mais](/language/error-handling#exceptions) sobre exceções,
incluindo rastreamentos de pilha, `rethrow` e
a diferença entre `Error` e `Exception`.

## Conceitos importantes

Ao continuar aprendendo sobre a linguagem Dart,
tenha em mente os seguintes fatos e conceitos:

-   Tudo o que você pode colocar em uma variável é um *objeto* e cada
    objeto é uma instância de uma *classe*. Até números, funções e
    `null` são objetos.
    Com exceção de `null` (se você habilitar [segurança nula completa][ns]),
    todos os objetos herdam da classe [`Object`][`Object`].

    :::version-note
    [Segurança nula][ns] foi introduzida no Dart 2.12.
    Usar segurança nula requer uma [versão de linguagem][language version] de pelo menos 2.12.
    :::

-   Embora Dart seja fortemente tipado, as anotações de tipo são opcionais
    porque o Dart pode inferir tipos. Em `var number = 101`, `number`
    é inferido como sendo do tipo `int`.

-   Se você habilitar [segurança nula][ns],
    as variáveis não podem conter `null`, a menos que você diga que podem.
    Você pode tornar uma variável anulável colocando
    um ponto de interrogação (`?`) no final de seu tipo.
    Por exemplo, uma variável do tipo `int?` pode ser um inteiro,
    ou pode ser `null`.
    Se você _sabe_ que uma expressão nunca avalia para `null`
    mas o Dart discorda,
    você pode adicionar `!` para afirmar que não é nulo
    (e para lançar uma exceção se for).
    Um exemplo: `int x = nullableButNotNullInt!`

-   Quando você deseja dizer explicitamente
    que qualquer tipo é permitido, use o tipo `Object?`
    (se você habilitou a segurança nula), `Object`,
    ou — se você precisar adiar a verificação de tipo até o tempo de execução — o
    [tipo especial `dynamic`][ObjectVsDynamic].

-   Dart oferece suporte a tipos genéricos, como `List<int>` (uma lista de inteiros)
    ou `List<Object>` (uma lista de objetos de qualquer tipo).

-   Dart oferece suporte a funções de nível superior (como `main()`), bem como
    funções vinculadas a uma classe ou objeto (*métodos estáticos* e *de instância*,
    respectivamente). Você também pode criar funções dentro
    de funções (*funções aninhadas* ou *locais*).

-   Da mesma forma, o Dart oferece suporte a *variáveis* de nível superior, bem como variáveis
    vinculadas a uma classe ou objeto (variáveis estáticas e de instância). Variáveis de instância
    são às vezes conhecidas como *campos* ou *propriedades*.

-   Ao contrário do Java, o Dart não tem as palavras-chave `public`, `protected` e `private`.
    Se um identificador começar com um sublinhado (`_`), ele é privado para sua biblioteca.
    Para obter detalhes, consulte [Bibliotecas e importações][Libraries and imports].

-   *Identificadores* podem começar com uma letra ou sublinhado (`_`), seguido por qualquer
    combinação desses caracteres mais dígitos.

-   Dart tem *expressões* (que têm valores de tempo de execução) e
    *instruções* (que não têm).
    Por exemplo, a [expressão condicional][conditional expression]
    `condition ? expr1 : expr2` tem um valor de `expr1` ou `expr2`.
    Compare isso com uma [instrução if-else][if-else statement], que não tem valor.
    Uma instrução geralmente contém uma ou mais expressões,
    mas uma expressão não pode conter diretamente uma instrução.

-   As ferramentas do Dart podem relatar dois tipos de problemas: _avisos_ e _erros_.
    Avisos são apenas indicações de que seu código pode não funcionar, mas
    eles não impedem a execução do seu programa. Os erros podem ser
    tempo de compilação ou tempo de execução. Um erro de tempo de compilação impede que o código
    de ser executado; um erro de tempo de execução resulta em um
    [exceção][exception] sendo levantada enquanto o código é executado.


## Recursos adicionais

Você pode encontrar mais documentação e exemplos de código no
[documentação da biblioteca principal](/libraries/dart-core)
e a [referência da API do Dart]({{site.dart-api}}).
O código deste site segue as convenções do
[guia de estilo do Dart](/effective-dart/style).

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
