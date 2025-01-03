---
ia-translate: true
title: Branches
description: Aprenda como usar branches (ramificações) para controlar o fluxo do seu código Dart.
prevpage:
  url: /language/loops
  title: Loops
nextpage:
  url: /language/error-handling
  title: Tratamento de erros
---

Esta página mostra como você pode controlar o fluxo do seu código Dart usando branches (ramificações):

- Instruções e elementos `if`
- Instruções e elementos `if-case`
- Instruções e expressões `switch`

Você também pode manipular o fluxo de controle em Dart usando:

- [Loops][], como `for` e `while`
- [Exceções][], como `try`, `catch` e `throw`

## If {:#if}

Dart suporta instruções `if` com cláusulas `else` opcionais.
A condição entre parênteses após `if` deve ser
uma expressão que avalie para um [booleano][]:

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
confira [Expressões Condicionais][].

### If-case {:#if-case}

Instruções `if` do Dart suportam cláusulas `case` seguidas por um [pattern (padrão)][]:

<?code-excerpt "language/lib/control_flow/branches.dart (if-case)"?>
```dart
if (pair case [int x, int y]) return Point(x, y);
```

Se o pattern (padrão) corresponder ao valor,
o branch (ramificação) é executado com quaisquer variáveis que o pattern (padrão) define em escopo.

No exemplo anterior,
o pattern (padrão) de lista `[int x, int y]` corresponde ao valor `pair`,
então o branch (ramificação) `return Point(x, y)` executa com as variáveis que
o pattern (padrão) definiu, `x` e `y`.

Caso contrário, o fluxo de controle avança para o branch (ramificação) `else`
para executar, se houver um:

<?code-excerpt "language/lib/control_flow/branches.dart (if-case-else)"?>
```dart
if (pair case [int x, int y]) {
  print('Was coordinate array $x,$y');
} else {
  throw FormatException('Invalid coordinates.');
}
```

A instrução if-case fornece uma maneira de corresponder e
[desestruturar][] contra um _único_ pattern (padrão).
Para testar um valor em relação a _múltiplos_ patterns (padrões), use [switch](#switch).

:::version-note
Cláusulas Case em instruções if requerem
uma [versão de linguagem][] de pelo menos 3.0.
:::

<a id="switch"></a>
## Instruções Switch {:#switch-statements}

Uma instrução `switch` avalia uma expressão de valor em relação a uma série de cases (casos).
Cada cláusula `case` é um [pattern (padrão)][] para o valor corresponder.
Você pode usar [qualquer tipo de pattern (padrão)][] para um case (caso).

Quando o valor corresponde ao pattern (padrão) de um case (caso), o corpo do case (caso) é executado.
Cláusulas `case` não vazias saltam para o final do switch após a conclusão.
Elas não exigem uma instrução `break`.
Outras maneiras válidas de finalizar uma cláusula `case` não vazia são uma instrução
[`continue`][break], [`throw`][] ou [`return`][].

Use uma cláusula `default` ou [coringa `_`][] para
executar o código quando nenhuma cláusula `case` corresponder:

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

Cases (Casos) vazios passam para o próximo case (caso), permitindo que cases (casos) compartilhem um corpo.
Para um case (caso) vazio que não passa adiante,
use [`break`][break] para seu corpo.
Para passagem não sequencial,
você pode usar uma [`instrução continue`][break] e um label (rótulo):

<?code-excerpt "language/lib/control_flow/branches.dart (switch-empty)"?>
```dart
switch (command) {
  case 'OPEN':
    executeOpen();
    continue newCase; // Continua a execução no label newCase.

  case 'DENIED': // Case vazio passa adiante.
  case 'CLOSED':
    executeClosed(); // Executa para DENIED e CLOSED,

  newCase:
  case 'PENDING':
    executeNowClosed(); // Executa para OPEN e PENDING.
}
```

Você pode usar [patterns (padrões) lógico-ou][] para permitir que cases (casos) compartilhem um corpo ou uma guarda.
Para saber mais sobre patterns (padrões) e cláusulas case (caso),
confira a documentação de patterns (padrões) em [Instruções e Expressões Switch][].

[Instruções e Expressões Switch]: /language/patterns#switch-statements-and-expressions

### Expressões Switch {:#switch-expressions}

Uma _expressão_ `switch` produz um valor com base no corpo da expressão
de qualquer case (caso) que corresponda.
Você pode usar uma expressão switch onde quer que o Dart permita expressões,
_exceto_ no início de uma instrução de expressão. Por exemplo:

```dart
var x = switch (y) { ... };

print(switch (x) { ... });

return switch (x) { ... };
```

Se você quiser usar um switch no início de uma instrução de expressão,
use uma [instrução switch](#switch-statements).

Expressões Switch permitem que você reescreva uma _instrução_ switch assim:

<?code-excerpt "language/lib/control_flow/branches.dart (switch-stmt)"?>
```dart
// Onde barra, asterisco, vírgula, ponto e vírgula, etc., são variáveis constantes...
switch (charCode) {
  case slash || star || plus || minus: // Pattern lógico-ou
    token = operator(charCode);
  case comma || semicolon: // Pattern lógico-ou
    token = punctuation(charCode);
  case >= digit0 && <= digit9: // Patterns relacionais e lógico-e
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
  _ => throw FormatException('Invalid')
};
```

A sintaxe de uma expressão `switch` difere da sintaxe da instrução `switch`:

- Cases (Casos) _não_ começam com a palavra-chave `case`.
- Um corpo de case (caso) é uma única expressão em vez de uma série de instruções.
- Cada case (caso) deve ter um corpo; não há passagem implícita para cases (casos) vazios.
- Patterns (Padrões) de case (caso) são separados de seus corpos usando `=>` em vez de `:`.
- Cases (Casos) são separados por `,` (e uma `,` opcional à direita é permitida).
- Cases (Casos) padrão podem _apenas_ usar `_`, em vez de permitir tanto `default` quanto `_`.

:::version-note
Expressões Switch requerem uma [versão de linguagem][] de pelo menos 3.0.
:::

### Verificação de Exaustividade {:#exhaustiveness-checking}

A verificação de exaustividade é um recurso que reporta um
erro de tempo de compilação se for possível para um valor entrar em um switch mas
não corresponder a nenhum dos cases (casos).

<?code-excerpt "language/lib/control_flow/branches.dart (exh-bool)"?>
```dart
// Switch não exaustivo em bool?, faltando case para corresponder a possibilidade null:
switch (nullableBool) {
  case true:
    print('yes');
  case false:
    print('no');
}
```

Um case (caso) padrão (`default` ou `_`) cobre todos os valores possíveis que
podem fluir por um switch.
Isso torna um switch em qualquer tipo exaustivo.

[Enums (Enumerações)][enum] e [tipos sealed (selados)][sealed] são particularmente úteis para
switches porque, mesmo sem um case (caso) padrão,
seus valores possíveis são conhecidos e totalmente enumeráveis.
Use o [`modificador sealed (selado)`][sealed] em uma classe para habilitar
a verificação de exaustividade ao trocar os subtipos dessa classe:

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
      Circle(radius: var r) => math.pi * r * r
    };
```

Se alguém adicionar uma nova subclasse de `Shape`,
esta expressão `switch` estaria incompleta.
A verificação de exaustividade informaria sobre o subtipo ausente.
Isso permite que você use o Dart em um estilo de
[tipo de dados algébrico funcional](https://en.wikipedia.org/wiki/Algebraic_data_type).

<a id="when"></a>
## Cláusula de Guarda {:#guard-clause}

Para definir uma cláusula de guarda opcional após uma cláusula `case`, use a palavra-chave `when`.
Uma cláusula de guarda pode seguir `if case`, e
tanto instruções quanto expressões `switch`.

```dart
// Instrução Switch:
switch (something) {
  case somePattern when some || boolean || expression:
    //             ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Cláusula de guarda.
    body;
}

// Expressão Switch:
var value = switch (something) {
  somePattern when some || boolean || expression => body,
  //               ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Cláusula de guarda.
}

// Instrução If-case:
if (something case somePattern when some || boolean || expression) {
  //                           ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Cláusula de guarda.
  body;
}
```

Guards (Guardas) avaliam uma expressão booleana arbitrária _após_ a correspondência.
Isso permite que você adicione mais restrições sobre
se o corpo de um case (caso) deve executar.
Quando a cláusula de guarda avalia como false (falso),
a execução prossegue para o próximo case (caso), em vez
de sair de todo o switch.

[versão de linguagem]: /resources/language/evolution#language-versioning
[loops]: /language/loops
[exceções]: /language/error-handling
[expressões condicionais]: /language/operators#conditional-expressions
[booleano]: /language/built-in-types#booleans
[pattern (padrão)]: /language/patterns
[enum (enumerações)]: /language/enums
[`throw`]: /language/error-handling#throw
[`return`]: /language/functions#return-values
[coringa `_`]: /language/pattern-types#wildcard
[break]: /language/loops#break-and-continue
[sealed (selado)]: /language/class-modifiers#sealed
[qualquer tipo de pattern (padrão)]: /language/pattern-types
[desestruturar]: /language/patterns#destructuring
[seção sobre switch]: /language/patterns#switch-statements-and-expressions
[patterns (padrões) lógico-ou]: /language/patterns#or-pattern-switch
