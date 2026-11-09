---
ia-translate: true
title: Atalhos de ponto
description: Aprenda sobre a sintaxe de atalho de ponto em Dart.
prevpage:
  url: /language/enums
  title: Tipos enumerados
nextpage:
  url: /language/extension-methods
  title: Métodos de extensão
---

<?code-excerpt replace="/ *\/\/\s+ignore_for_file:[^\n]+\n//g; /(^|\n) *\/\/\s+ignore:[^\n]+\n/$1/g; /(\n[^\n]+) *\/\/\s+ignore:[^\n]+\n/$1\n/g"?>

:::version-note
Atalhos de ponto requerem uma [language version][] de pelo menos 3.10.
:::

[language version]: /language/versioning

## Visão geral {:#overview}

A sintaxe de atalho de ponto `.foo` permite que você escreva código Dart
mais conciso ao omitir o tipo quando o compilador consegue inferi-lo
a partir do contexto. Isso oferece uma alternativa limpa para escrever
o `ContextType.foo` completo ao acessar valores de enum,
membros estáticos ou construtores.

Em essência, os atalhos de ponto permitem que uma expressão
comece com um dos seguintes itens e, opcionalmente, encadeie
outras operações a ela:

* Identificador `.myValue`

* Construtor `.new()`

* Criação de constante `const .myValue()`

Veja uma rápida amostra de como isso simplifica a atribuição de um enum:

<?code-excerpt "language/lib/shorthands/intro.dart"?>
```dart
// Use dot shorthand syntax on enums:
enum Status { none, running, stopped, paused }

Status currentStatus = .running; // Instead of Status.running

// Use dot shorthand syntax on a static method:
int port = .parse('8080'); // Instead of int.parse('8080')

// Uses dot shorthand syntax on a constructor:
class Point {
  final int x, y;
  Point(this.x, this.y);
  Point.origin() : x = 0, y = 0;
}

Point origin = .origin(); // Instead of Point.origin()
```

## O papel do tipo de contexto {:#the-role-of-context-type}

Os atalhos de ponto usam o [tipo de contexto][context type] para determinar
a qual membro o compilador resolve a expressão. O tipo de contexto é o tipo
que o Dart espera que uma expressão tenha, com base na posição dela no código.
Por exemplo, em `Status currentStatus = .running`,
o compilador sabe que é esperado um `Status`, então ele infere
que `.running` significa `Status.running`.

[context type]: /resources/glossary#context-type

## Estrutura léxica e sintaxe {:#lexical-structure-and-syntax}

Um _atalho de membro estático_ é uma expressão que
começa com um ponto (`.`).
Quando o tipo é conhecido pelo contexto ao redor,
essa sintaxe oferece uma forma concisa de acessar
membros estáticos, construtores e valores de enum.

### Enums {:#enums}

Um caso de uso principal e altamente recomendado para os atalhos de ponto
são os enums, especialmente em atribuições e instruções `switch`,
em que o tipo do enum é bem óbvio.

<?code-excerpt "language/lib/shorthands/enums.dart"?>
```dart
enum LogLevel { debug, info, warning, error }

/// Returns the color code to use for the specified log [level].
String colorCode(LogLevel level) {
  // Use dot shorthand syntax for enum values in switch cases:
  return switch (level) {
    .debug => 'gray', // Instead of LogLevel.debug
    .info => 'blue', // Instead of LogLevel.info
    .warning => 'orange', // Instead of LogLevel.warning
    .error => 'red', // Instead of LogLevel.error
  };
}

// Example usage:
String warnColor = colorCode(.warning); // Returns 'orange'
```

### Construtores nomeados {:#named-constructors}

Os atalhos de ponto são úteis para invocar construtores nomeados
ou construtores factory. Essa sintaxe também funciona ao fornecer
argumentos de tipo para o construtor de uma classe genérica.

<?code-excerpt "language/lib/shorthands/constructors.dart"?>
```dart
class Point {
  final double x, y;
  const Point(this.x, this.y);
  const Point.origin() : x = 0, y = 0; // Named constructor

  // Factory constructor
  factory Point.fromList(List<double> list) {
    return Point(list[0], list[1]);
  }
}

// Use dot shorthand syntax on a named constructor:
Point origin = .origin(); // Instead of Point.origin()

// Use dot shorthand syntax on a factory constructor:
Point p1 = .fromList([1.0, 2.0]); // Instead of Point.fromList([1.0, 2.0])

// Use dot shorthand syntax on a generic class constructor:
List<int> intList = .filled(5, 0); // Instead of List.filled(5, 0)
```

### Construtores sem nome {:#unnamed-constructors}

O atalho de ponto `.new` oferece uma forma concisa de chamar o
construtor sem nome de uma classe. Isso é útil
para atribuir campos ou variáveis cujo tipo já está
declarado explicitamente.

Essa sintaxe é especialmente eficaz para limpar
inicializadores de campos de classe repetitivos.
Como mostrado no exemplo "depois" a seguir, que usa atalhos de ponto,
ela pode ser usada tanto para construtores com argumentos quanto sem.
Ela também infere os argumentos de tipo genérico
a partir do contexto.

**Sem atalhos de ponto:**

<?code-excerpt "language/lib/shorthands/unnamed_constructors.dart (unnamed-before)"?>
```dart
class _PageState extends State<Page> {
  late final AnimationController _animationController = AnimationController(
    vsync: this,
  );
  final ScrollController _scrollController = ScrollController();

  final GlobalKey<ScaffoldMessengerState> scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();

  Map<String, Map<String, bool>> properties = <String, Map<String, bool>>{};
  // ...
}
```

**Usando atalhos de ponto:**

<?code-excerpt "language/lib/shorthands/unnamed_constructors.dart (unnamed-after)" replace="/_PageStateAfter/_PageState/g;"?>
```dart
// Use dot shorthand syntax for calling unnamed constructors:
class _PageState extends State<Page> {
  late final AnimationController _animationController = .new(vsync: this);
  final ScrollController _scrollController = .new();
  final GlobalKey<ScaffoldMessengerState> scaffoldKey = .new();
  Map<String, Map<String, bool>> properties = .new();
  // ...
}
```

### Membros estáticos {:#static-members}

Você pode usar a sintaxe de atalho de ponto para chamar métodos estáticos ou
acessar campos e getters estáticos. O compilador infere a
classe alvo a partir do tipo de contexto da expressão.

<?code-excerpt "language/lib/shorthands/static_members.dart"?>
```dart
// Use dot shorthand syntax to invoke a static method:
int httpPort = .parse('80'); // Instead of int.parse('80')

// Use dot shorthand syntax to access a static field or getter:
BigInt bigIntZero = .zero; // Instead of BigInt.zero
```

### Expressões constantes {:#constant-expressions}

Você pode usar atalhos de ponto dentro de um contexto constante
se o membro acessado for uma constante de tempo de compilação.
Isso é comum para valores de enum e para invocação de construtores `const`.

<?code-excerpt "language/lib/shorthands/consts.dart"?>
```dart
enum Status { none, running, stopped, paused }

class Point {
  final double x, y;
  const Point(this.x, this.y);
  const Point.origin() : x = 0.0, y = 0.0;
}

// Use dot shorthand syntax for enum value:
const Status defaultStatus = .running; // Instead of Status.running

// Use dot shorthand syntax to invoke a const named constructor:
const Point myOrigin = .origin(); // Instead of Point.origin()

// Use dot shorthand syntax in a const collection literal:
const List<Point> keyPoints = [.origin(), .new(1.0, 1.0)];
// Instead of [Point.origin(), Point(1.0, 1.0)]
```

## Regras e limitações {:#rules-and-limitations}

Os atalhos de ponto dependem de um tipo de contexto claro, o que leva a
algumas regras e limitações específicas que você deve conhecer.

### Tipo de contexto claro necessário em cadeias {:#clear-context-type-required-in-chains}

Embora você possa encadear operações como chamadas de método ou
acessos a propriedades em um atalho de ponto, a expressão inteira
é validada contra o tipo de contexto.

O compilador primeiro usa o contexto para determinar a que o
atalho de ponto resolve. Quaisquer operações subsequentes na
cadeia precisam retornar um valor que corresponda a esse mesmo
tipo de contexto inicial.

<?code-excerpt "language/lib/shorthands/chain.dart (chain)"?>
```dart
// .fromCharCode(72) resolves to the String "H",
// then the instance method .toLowerCase() is called on that String.
String lowerH = .fromCharCode(72).toLowerCase();
// Instead of String.fromCharCode(72).toLowerCase()

print(lowerH); // Output: h
```

### Verificações de igualdade assimétricas {:#asymmetric-equality-checks}

Os operadores `==` e `!=` têm uma regra especial para atalhos de ponto.
Quando a sintaxe de atalho de ponto é usada diretamente no lado direito
de uma verificação de igualdade, o Dart usa o tipo estático do
lado esquerdo para determinar a classe ou o enum do atalho.

Por exemplo, em uma expressão como `myColor == .green`,
o tipo da variável `myColor` é usado como contexto.
Isso significa que o compilador interpreta `.green` como `Color.green`.

<?code-excerpt "language/lib/shorthands/equality.dart"?>
```dart
enum Color { red, green, blue }

// Use dot shorthand syntax for equality expressions:
void allowedExamples() {
  Color myColor = Color.red;
  bool condition = true;

  // OK: `myColor` is a `Color`, so `.green` is inferred as `Color.green`.
  if (myColor == .green) {
    print('The color is green.');
  }

  // OK: Works with `!=` as well.
  if (myColor != .blue) {
    print('The color is not blue.');
  }

  // OK: The context for the ternary is the variable `inferredColor`
  // being assigned to, which has a type of `Color`.
  Color inferredColor = condition ? .green : .blue;
  print('Inferred color is $inferredColor');
}
```

O atalho de ponto deve estar no lado direito do operador `==`
ou `!=`. Comparar com uma expressão mais complexa,
como uma expressão condicional, também não é permitido.

<?code-excerpt "language/lib/shorthands/equality_with_errors.dart"?>
```dart tag=fails-sa
enum Color { red, green, blue }

void notAllowedExamples() {
  Color myColor = Color.red;
  bool condition = true;

  // ERROR: The shorthand must be on the right side of `==`.
  // Dart's `==` operator is not symmetric for this feature.
  if (.red == myColor) {
    print('This will not compile.');
  }

  // ERROR: The right-hand side is a complex expression (a conditional expression),
  // which is not a valid target for shorthand in a comparison.
  if (myColor == (condition ? .green : .blue)) {
    print('This will not compile.');
  }

  // ERROR: The type context is lost by casting `myColor` to `Object`.
  // The compiler no longer knows that `.green` should refer to `Color.green`.
  if ((myColor as Object) == .green) {
    print('This will not compile.');
  }
}
```

### Instruções de expressão não podem começar com `.` {:#expression-statements-cant-start-with}

Para evitar possíveis ambiguidades de análise no futuro, uma
instrução de expressão não pode começar com um
token `.`.

<?code-excerpt "language/lib/shorthands/expression_with_errors.dart"?>
```dart tag=fails-sa
class Logger {
  static void log(String message) {
    print(message);
  }
}

void main() {
  // ERROR: An expression statement can't begin with `.`.
  // The compiler has no type context (like a variable assignment)
  // to infer that `.log` should refer to `Logger.log`.
  .log('Hello');
}
```

### Tratamento limitado de tipos union {:#limited-handling-of-union-types}

Embora haja tratamento especial para tipos anuláveis (`T?`) e
`FutureOr<T>`, o suporte é limitado.

*  Para um tipo anulável (`T?`), você pode acessar membros estáticos
   de `T`, mas não de `Null`.

*  Para `FutureOr<T>`, você pode acessar membros estáticos de `T`
   (principalmente para dar suporte a retornos de funções `async`), mas não
   pode acessar membros estáticos da própria classe `Future`.
