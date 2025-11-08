---
ia-translate: true
title: "Abreviações com ponto (Dot shorthands)"
description: "Aprenda sobre a sintaxe de abreviação com ponto em Dart."
prevpage:
  url: /language/enums
  title: Enums
nextpage:
  url: /language/extension-methods
  title: Extension methods
---

<?code-excerpt replace="/ *\/\/\s+ignore_for_file:[^\n]+\n//g; /(^|\n) *\/\/\s+ignore:[^\n]+\n/$1/g; /(\n[^\n]+) *\/\/\s+ignore:[^\n]+\n/$1\n/g"?>

:::version-note
Dot shorthands requerem uma [versão de linguagem][] de pelo menos 3.10.
:::

[versão de linguagem]: /resources/language/evolution#language-versioning

## Visão geral

A sintaxe de abreviação com ponto `.foo` permite que você escreva código Dart
mais conciso omitindo o tipo quando o compilador pode inferi-lo
do contexto. Isso fornece uma alternativa limpa para escrever
o `ContextType.foo` completo ao acessar valores enum,
membros estáticos ou construtores.

Em essência, dot shorthands permitem que uma expressão
comece com uma das seguintes opções e, em seguida, opcionalmente encadeie
outras operações:

* Identificador `.myValue`

* Construtor `.new()`

* Criação de constante `const .myValue()`

Aqui está uma visão rápida de como isso simplifica uma atribuição de enum:

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

## O papel do tipo de contexto

Dot shorthands usam o [tipo de contexto][] para determinar o membro
que o compilador resolve. O tipo de contexto é o tipo que Dart
espera que uma expressão tenha com base em sua localização.
Por exemplo, em `Status currentStatus = .running`,
o compilador sabe que um `Status` é esperado, então ele infere
`.running` para significar `Status.running`.

[tipo de contexto]: /resources/glossary#context-type

## Estrutura léxica e sintaxe

Uma _abreviação de membro estático_ é uma expressão que
começa com um ponto inicial (`.`).
Quando o tipo é conhecido pelo contexto ao redor,
essa sintaxe fornece uma maneira concisa de acessar
membros estáticos, construtores e valores enum.

### Enums

Um caso de uso primário e altamente recomendado para dot shorthands
é com enums, especialmente em atribuições e instruções switch,
onde o tipo enum é muito óbvio.

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

### Construtores nomeados

Dot shorthands são úteis para invocar construtores nomeados
ou construtores de fábrica. Essa sintaxe também funciona ao fornecer
argumentos de tipo a um construtor de classe genérica.

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

### Construtores sem nome

A abreviação `.new` fornece uma maneira concisa de chamar um
construtor sem nome de uma classe. Isso é útil
para atribuir campos ou variáveis onde o tipo já está
explicitamente declarado.

Essa sintaxe é particularmente eficaz para limpar
inicializadores de campos de classe repetitivos.
Conforme mostrado no exemplo "depois" a seguir usando dot shorthands,
ele pode ser usado para construtores com e sem argumentos.
Ele também infere quaisquer argumentos de tipo genérico
do contexto.

**Sem dot shorthands:**

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

**Usando dot shorthands:**

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

### Membros estáticos

Você pode usar a sintaxe dot shorthand para chamar métodos estáticos ou
acessar campos/getters estáticos. O compilador infere a
classe de destino do tipo de contexto da expressão.

<?code-excerpt "language/lib/shorthands/static_members.dart"?>
```dart
// Use dot shorthand syntax to invoke a static method:
int httpPort = .parse('80'); // Instead of int.parse('80')

// Use dot shorthand syntax to access a static field or getter:
BigInt bigIntZero = .zero; // Instead of BigInt.zero
```

### Expressões constantes

Você pode usar dot shorthands dentro de um contexto constante
se o membro que está sendo acessado for uma constante de tempo de compilação.
Isso é comum para valores enum e invocação de construtores `const`.

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

## Regras e limitações

Dot shorthands dependem de um tipo de contexto claro, o que leva a
algumas regras e limitações específicas que você deve conhecer.

### Tipo de contexto claro necessário em cadeias

Embora você possa encadear operações como chamadas de método ou
acessos de propriedade em um dot shorthand, a expressão inteira
é validada contra o tipo de contexto.

O compilador primeiro usa o contexto para determinar o que o
dot shorthand resolve. Quaisquer operações subsequentes na
cadeia devem retornar um valor que corresponda a esse mesmo
tipo de contexto inicial.

<?code-excerpt "language/lib/shorthands/chain.dart (chain)"?>
```dart
// .fromCharCode(72) resolves to the String "H",
// then the instance method .toLowerCase() is called on that String.
String lowerH = .fromCharCode(72).toLowerCase();
// Instead of String.fromCharCode(72).toLowerCase()

print(lowerH); // Output: h
```

### Verificações de igualdade assimétricas

Os operadores `==` e `!=` têm uma regra especial para dot shorthands.
Quando a sintaxe dot shorthand é usada diretamente no lado direito
de uma verificação de igualdade, Dart usa o tipo estático do
lado esquerdo para determinar a classe ou enum para o shorthand.

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

O dot shorthand deve estar no lado direito do operador `==`
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

### Instruções de expressão não podem começar com `.`

Para evitar ambiguidades de análise potenciais no futuro, uma
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

### Manipulação limitada de tipos de união

Embora haja tratamento especial para tipos anuláveis (`T?`) e
`FutureOr<T>`, o suporte é limitado.

*  Para um tipo anulável (T?), você pode acessar membros estáticos
   de `T`, mas não de `Null`.

*  Para `FutureOr<T>`, você pode acessar membros estáticos de `T`
  (principalmente para suportar retornos de função `async`), mas você
  não pode acessar membros estáticos da própria classe `Future`.
