---
ia-translate: true
title: Desvios
description: Aprenda a usar desvios para controlar o fluxo do seu código Dart.
prevpage:
  url: /language/loops
  title: Loops
nextpage:
  url: /language/error-handling
  title: Tratamento de erros
---

Esta página mostra como você pode controlar o fluxo do seu código Dart usando desvios:

- Instruções e elementos `if`
- Instruções e elementos `if-case`
- Instruções e expressões `switch`

Você também pode manipular o fluxo de controle em Dart usando:

- [Loops][loops], como `for` e `while`
- [Exceções][exceptions], como `try`, `catch` e `throw`

## If {:#if}

O Dart suporta instruções `if` com cláusulas `else` opcionais.
A condição entre parênteses após `if` deve ser
uma expressão que avalia para um [boolean][boolean]:

<?code-excerpt "language/lib/control_flow/branches.dart (if-else)"?>
```dart
if (isRaining()) {
  you.bringRainCoat();
} else if (isSnowing()) {
  you.wearJacket();
} else {
  car.putTopDown();
}
```

Para aprender como usar `if` em um contexto de expressão,
confira [Expressões condicionais][conditional expressions].

### If-case {:#if-case}

As instruções `if` do Dart suportam cláusulas `case` seguidas de um [pattern][pattern]:

<?code-excerpt "language/lib/control_flow/branches.dart (if-case)"?>
```dart
if (pair case [int x, int y]) return Point(x, y);
```

Se o pattern corresponder ao valor,
o desvio é executado com as variáveis que o pattern define no escopo.

No exemplo anterior,
o list pattern `[int x, int y]` corresponde ao valor `pair`,
então o desvio `return Point(x, y)` é executado com as variáveis que
o pattern definiu, `x` e `y`.

Caso contrário, o fluxo de controle segue para o desvio `else`,
para ser executado, se houver um:

<?code-excerpt "language/lib/control_flow/branches.dart (if-case-else)"?>
```dart 
if (pair case [int x, int y]) {
  print('Was coordinate array $x,$y');
} else {
  throw FormatException('Invalid coordinates.');
}
```

A instrução if-case oferece uma forma de fazer match e
[desestruturar][destructure] contra um _único_ pattern.
Para testar um valor contra _vários_ patterns, use [switch](#switch).

:::version-note
Cláusulas case em instruções if exigem uma
[versão da linguagem][language version] de pelo menos 3.0.
:::

<a id="switch"></a>
## Instruções switch {:#switch-statements}

Uma instrução `switch` avalia uma expressão de valor contra uma série de cases.
Cada cláusula `case` é um [pattern][pattern] para o valor comparar.
Você pode usar [qualquer tipo de pattern][any kind of pattern] em um case.

Quando o valor corresponde ao pattern de um case, o corpo do case é executado.
Cláusulas `case` não vazias pulam para o fim do switch após a conclusão.
Elas não exigem uma instrução `break`.
Outras formas válidas de encerrar uma cláusula `case` não vazia são uma
instrução [`continue`][break], [`throw`][`throw`] ou [`return`][`return`].

Use uma cláusula `default` ou o [wildcard `_`][wildcard `_`] para
executar código quando nenhuma cláusula `case` corresponder:

<?code-excerpt "language/lib/control_flow/branches.dart (switch)"?>
```dart
var command = 'OPEN';
switch (command) {
  case 'CLOSED':
    executeClosed();
  case 'PENDING':
    executePending();
  case 'APPROVED':
    executeApproved();
  case 'DENIED':
    executeDenied();
  case 'OPEN':
    executeOpen();
  default:
    executeUnknown();
}
```

<a id="switch-share"></a>

Cases vazios passam para o próximo case, permitindo que cases compartilhem um corpo.
Para um case vazio que não passa adiante,
use [`break`][break] para o corpo dele.
Para passagem não sequencial,
você pode usar uma [instrução `continue`][break] e um label:

<?code-excerpt "language/lib/control_flow/branches.dart (switch-empty)"?>
```dart
switch (command) {
  case 'OPEN':
    executeOpen();
    continue newCase; // Continues executing at the newCase label.

  case 'DENIED': // Empty case falls through.
  case 'CLOSED':
    executeClosed(); // Runs for both DENIED and CLOSED,

  newCase:
  case 'PENDING':
    executeNowClosed(); // Runs for both OPEN and PENDING.
}
```

Você pode usar [logical-or patterns][logical-or patterns] para permitir que cases compartilhem um corpo ou um guard.
Para aprender mais sobre patterns e cláusulas case,
confira a documentação de patterns sobre [Switch statements and expressions][Switch statements and expressions].

[Switch statements and expressions]: /language/patterns#switch-statements-and-expressions

### Expressões switch {:#switch-expressions}

Uma _expressão_ `switch` produz um valor com base no corpo da expressão
do case que corresponder.
Você pode usar uma expressão switch onde quer que o Dart permita expressões,
_exceto_ no início de uma instrução de expressão. Por exemplo:

```dart
var x = switch (y) { ... };

print(switch (x) { ... });

return switch (x) { ... };
```

Se você quiser usar um switch no início de uma instrução de expressão,
use uma [instrução switch](#switch-statements).

Expressões switch permitem reescrever uma _instrução_ switch assim:

<?code-excerpt "language/lib/control_flow/branches.dart (switch-stmt)"?>
```dart
// Where slash, star, comma, semicolon, etc., are constant variables...
switch (charCode) {
  case slash || star || plus || minus: // Logical-or pattern
    token = operator(charCode);
  case comma || semicolon: // Logical-or pattern
    token = punctuation(charCode);
  case >= digit0 && <= digit9: // Relational and logical-and patterns
    token = number();
  default:
    throw FormatException('Invalid');
}
```

Em uma _expressão_, assim:

<?code-excerpt "language/lib/control_flow/branches.dart (switch-exp)"?>
```dart
token = switch (charCode) {
  slash || star || plus || minus => operator(charCode),
  comma || semicolon => punctuation(charCode),
  >= digit0 && <= digit9 => number(),
  _ => throw FormatException('Invalid'),
};
```

A sintaxe de uma expressão `switch` difere da sintaxe da instrução `switch`:

- Cases _não_ começam com a keyword `case`.
- O corpo de um case é uma única expressão, em vez de uma série de instruções.
- Cada case deve ter um corpo; não há passagem implícita para cases vazios.
- Os patterns dos cases são separados de seus corpos usando `=>` em vez de `:`.
- Cases são separados por `,` (e uma `,` final opcional é permitida).
- Cases default podem usar _apenas_ `_`, em vez de permitir tanto `default` quanto `_`.

:::version-note
Expressões switch exigem uma [versão da linguagem][language version] de pelo menos 3.0.
:::

### Verificação de exaustividade {:#exhaustiveness-checking}

A verificação de exaustividade é um recurso que relata um
erro de tempo de compilação se for possível que um valor entre em um switch sem
corresponder a nenhum dos cases.

<?code-excerpt "language/lib/control_flow/branches.dart (exh-bool)"?>
```dart
// Non-exhaustive switch on bool?, missing case to match null possibility:
switch (nullableBool) {
  case true:
    print('yes');
  case false:
    print('no');
}
```

Um case default (`default` ou `_`) cobre todos os valores possíveis que
podem passar por um switch.
Isso torna um switch sobre qualquer tipo exaustivo.

[Enums][enum] e [tipos sealed][sealed] são especialmente úteis para
switches porque, mesmo sem um case default,
seus valores possíveis são conhecidos e totalmente enumeráveis.
Use o [modificador `sealed`][sealed] em uma classe para habilitar
a verificação de exaustividade ao fazer switch sobre subtipos dessa classe:

<?code-excerpt "language/lib/patterns/algebraic_datatypes.dart (algebraic-datatypes)"?>
```dart
sealed class Shape {}

class Square implements Shape {
  final double length;
  Square(this.length);
}

class Circle implements Shape {
  final double radius;
  Circle(this.radius);
}

double calculateArea(Shape shape) => switch (shape) {
  Square(length: var l) => l * l,
  Circle(radius: var r) => math.pi * r * r,
};
```

Se alguém adicionar uma nova subclasse de `Shape`,
esta expressão `switch` ficaria incompleta.
A verificação de exaustividade avisaria você sobre o subtipo faltante.
Isso permite usar Dart de um jeito um tanto
[funcional, no estilo de tipos de dados algébricos](https://en.wikipedia.org/wiki/Algebraic_data_type).

<a id="when"></a>
## Cláusula guard {:#guard-clause}

Para definir uma cláusula guard opcional após uma cláusula `case`, use a keyword `when`.
Uma cláusula guard pode seguir `if case`, e
tanto instruções quanto expressões `switch`.

```dart
// Switch statement:
switch (something) {
  case somePattern when some || boolean || expression:
    //             ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Guard clause.
    body;
}

// Switch expression:
var value = switch (something) {
  somePattern when some || boolean || expression => body,
  //               ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Guard clause.
}

// If-case statement:
if (something case somePattern when some || boolean || expression) {
  //                           ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Guard clause.
  body;
}
```

Guards avaliam uma expressão booleana arbitrária _depois_ do matching.
Isso permite adicionar restrições extras sobre
se o corpo de um case deve ser executado.
Quando a cláusula guard avalia para false,
a execução segue para o próximo case, em vez
de sair de todo o switch.

[language version]: /language/versioning
[loops]: /language/loops
[exceptions]: /language/error-handling
[conditional expressions]: /language/operators#conditional-expressions
[boolean]: /language/built-in-types#booleans
[pattern]: /language/patterns
[enum]: /language/enums
[`throw`]: /language/error-handling#throw
[`return`]: /language/functions#return-values
[wildcard `_`]: /language/pattern-types#wildcard
[break]: /language/loops#break-and-continue
[sealed]: /language/class-modifiers#sealed
[any kind of pattern]: /language/pattern-types
[destructure]: /language/patterns#destructuring
[section on switch]: /language/patterns#switch-statements-and-expressions
[logical-or patterns]: /language/patterns#or-pattern-switch
