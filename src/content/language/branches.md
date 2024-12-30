---
ia-translate: true
title: Branches
description: Aprenda como usar branches para controlar o fluxo do seu código Dart.
prevpage:
  url: /language/loops
  title: Loops
nextpage:
  url: /language/error-handling
  title: Tratamento de erros
---

Esta página mostra como você pode controlar o fluxo do seu código Dart usando branches:

- Declarações e elementos `if`
- Declarações e elementos `if-case`
- Declarações e expressões `switch`

Você também pode manipular o fluxo de controle em Dart usando:

- [Loops][Loops], como `for` e `while`
- [Exceções][Exceptions], como `try`, `catch` e `throw`

## If

Dart suporta declarações `if` com cláusulas `else` opcionais.
A condição entre parênteses após `if` deve ser
uma expressão que avalie para um [booleano][boolean]:

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
confira [Expressões condicionais][Conditional expressions].

### If-case

As declarações `if` do Dart suportam cláusulas `case` seguidas por um [padrão][pattern]:

<?code-excerpt "language/lib/control_flow/branches.dart (if-case)"?>
```dart
if (pair case [int x, int y]) return Point(x, y);
```

Se o padrão corresponder ao valor,
o branch é executado com quaisquer variáveis que o padrão defina no escopo.

No exemplo anterior,
o padrão de lista `[int x, int y]` corresponde ao valor `pair`,
então o branch `return Point(x, y)` é executado com as variáveis que
o padrão definiu, `x` e `y`.

Caso contrário, o fluxo de controle progride para o branch `else`
para ser executado, se houver um:

<?code-excerpt "language/lib/control_flow/branches.dart (if-case-else)"?>
```dart
if (pair case [int x, int y]) {
  print('Was coordinate array $x,$y');
} else {
  throw FormatException('Invalid coordinates.');
}
```

A declaração if-case fornece uma maneira de corresponder e
[desestruturar][destructure] em relação a um padrão _único_.
Para testar um valor em relação a _múltiplos_ padrões, use [switch](#switch).

:::version-note
Cláusulas case em declarações if requerem
uma [versão de linguagem][language version] de pelo menos 3.0.
:::

<a id="switch"></a>
## Declarações Switch

Uma declaração `switch` avalia uma expressão de valor em relação a uma série de cases.
Cada cláusula `case` é um [padrão][pattern] para o valor corresponder.
Você pode usar [qualquer tipo de padrão][any kind of pattern] para um case.

Quando o valor corresponde ao padrão de um case, o corpo do case é executado.
Cláusulas `case` não vazias saltam para o final do switch após a conclusão.
Elas não exigem uma declaração `break`.
Outras maneiras válidas de finalizar uma cláusula `case` não vazia são
declarações [`continue`][break], [`throw`][`throw`], ou [`return`][`return`].

Use uma cláusula `default` ou [curinga `_`][wildcard `_`] para
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

Cases vazios passam para o próximo case, permitindo que os cases compartilhem um corpo.
Para um case vazio que não passa adiante,
use [`break`][break] para seu corpo.
Para passagens não sequenciais,
você pode usar uma [`declaração continue`][break] e um rótulo:

<?code-excerpt "language/lib/control_flow/branches.dart (switch-empty)"?>
```dart
switch (command) {
  case 'OPEN':
    executeOpen();
    continue newCase; // Continua a execução no rótulo newCase.

  case 'DENIED': // Case vazio passa adiante.
  case 'CLOSED':
    executeClosed(); // Executa para DENIED e CLOSED,

  newCase:
  case 'PENDING':
    executeNowClosed(); // Executa para OPEN e PENDING.
}
```

Você pode usar [padrões lógico-ou][logical-or patterns] para permitir que os cases compartilhem um corpo ou uma guarda.
Para aprender mais sobre padrões e cláusulas case,
confira a documentação de padrões em [Declarações e expressões Switch][Switch statements and expressions].

[Switch statements and expressions]: /language/patterns#switch-statements-and-expressions

### Expressões Switch

Uma _expressão_ `switch` produz um valor baseado no corpo da expressão
de qualquer case que corresponder.
Você pode usar uma expressão switch onde quer que o Dart permita expressões,
_exceto_ no início de uma declaração de expressão. Por exemplo:

```dart
var x = switch (y) { ... };

print(switch (x) { ... });

return switch (x) { ... };
```

Se você quiser usar um switch no início de uma declaração de expressão,
use uma [declaração switch](#switch-statements).

Expressões switch permitem que você reescreva uma _declaração_ switch como esta:

<?code-excerpt "language/lib/control_flow/branches.dart (switch-stmt)"?>
```dart
// Onde barra, asterisco, vírgula, ponto e vírgula, etc., são variáveis constantes...
switch (charCode) {
  case slash || star || plus || minus: // Padrão lógico-ou
    token = operator(charCode);
  case comma || semicolon: // Padrão lógico-ou
    token = punctuation(charCode);
  case >= digit0 && <= digit9: // Padrões relacionais e lógico-e
    token = number();
  default:
    throw FormatException('Invalid');
}
```

Em uma _expressão_, como esta:

<?code-excerpt "language/lib/control_flow/branches.dart (switch-exp)"?>
```dart
token = switch (charCode) {
  slash || star || plus || minus => operator(charCode),
  comma || semicolon => punctuation(charCode),
  >= digit0 && <= digit9 => number(),
  _ => throw FormatException('Invalid')
};
```

A sintaxe de uma expressão `switch` difere da sintaxe da declaração `switch`:

- Cases _não_ começam com a palavra-chave `case`.
- O corpo de um case é uma expressão única em vez de uma série de declarações.
- Cada case deve ter um corpo; não há passagem implícita para cases vazios.
- Padrões de case são separados de seus corpos usando `=>` em vez de `:`.
- Cases são separados por `,` (e um `,` opcional no final é permitido).
- Cases default podem _apenas_ usar `_`, em vez de permitir tanto `default` quanto `_`.

:::version-note
Expressões switch exigem uma [versão de linguagem][language version] de pelo menos 3.0.
:::

### Verificação de exaustividade

A verificação de exaustividade é um recurso que relata um
erro em tempo de compilação se for possível que um valor entre em um switch, mas
não corresponda a nenhum dos cases.

<?code-excerpt "language/lib/control_flow/branches.dart (exh-bool)"?>
```dart
// Switch não exaustivo em bool?, faltando case para corresponder à possibilidade de null:
switch (nullableBool) {
  case true:
    print('yes');
  case false:
    print('no');
}
```

Um case default (`default` ou `_`) cobre todos os valores possíveis que
podem fluir através de um switch.
Isso torna um switch em qualquer tipo exaustivo.

[Enums][enum] e [tipos selados][sealed] são particularmente úteis para
switches porque, mesmo sem um case default,
seus valores possíveis são conhecidos e totalmente enumeráveis.
Use o [`modificador sealed`][sealed] em uma classe para habilitar
a verificação de exaustividade ao alternar entre subtipos dessa classe:

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

Se alguém adicionasse uma nova subclasse de `Shape`,
esta expressão `switch` estaria incompleta.
A verificação de exaustividade informaria você sobre o subtipo ausente.
Isso permite que você use o Dart em um estilo de [tipo de dados algébrico funcional](https://en.wikipedia.org/wiki/Algebraic_data_type).

<a id="when"></a>
## Cláusula de guarda

Para definir uma cláusula de guarda opcional após uma cláusula `case`, use a palavra-chave `when`.
Uma cláusula de guarda pode seguir `if case`, e
tanto declarações quanto expressões `switch`.

```dart
// Declaração Switch:
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

// Declaração If-case:
if (something case somePattern when some || boolean || expression) {
  //                           ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Cláusula de guarda.
  body;
}
```

Guards avaliam uma expressão booleana arbitrária _após_ a correspondência.
Isso permite adicionar mais restrições sobre
se um corpo de case deve ser executado.
Quando a cláusula de guarda avalia como falso,
a execução prossegue para o próximo case em vez de
sair de todo o switch.

[language version]: /resources/language/evolution#language-versioning
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
