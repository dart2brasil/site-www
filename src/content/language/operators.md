---
ia-translate: true
title: Operadores
description: Aprenda sobre os operadores que o Dart suporta.
prevpage:
  url: /language/variables
  title: Variáveis
nextpage:
  url: /language/comments
  title: Comentários
---

<?code-excerpt replace="/ *\/\/\s+ignore_for_file:[^\n]+\n//g; /(^|\n) *\/\/\s+ignore:[^\n]+\n/$1/g; /(\n[^\n]+) *\/\/\s+ignore:[^\n]+\n/$1\n/g; / *\/\/\s+ignore:[^\n]+//g; /([A-Z]\w*)\d\b/$1/g"?>

<a name="operators"></a>

O Dart suporta os operadores mostrados na tabela a seguir.
A tabela mostra a associatividade do operador do Dart
e a [precedência de operadores](#operator-precedence-example) do maior para o menor,
que são uma **aproximação** das relações de operadores do Dart.
Você pode implementar muitos desses [operadores como membros de classe][].

| Descrição                             | Operador                                                                                          | Associatividade |
|---------------------------------------|---------------------------------------------------------------------------------------------------|-----------------|
| postfix unário                       | *`expr`*`++`   *`expr`*`--`   `()`   `[]`   `?[]`   `.`   `?.`   `!`                          | Nenhuma         |
| prefix unário                        | `-`*`expr`*   `!`*`expr`*   `~`*`expr`*   `++`*`expr`*   `--`*`expr`*      `await` *`expr`*   | Nenhuma         |
| multiplicativo                        | `*`   `/`   `%`   `~/`                                                                           | Esquerda        |
| aditivo                               | `+`   `-`                                                                                         | Esquerda        |
| deslocamento                           | `<<`   `>>`   `>>>`                                                                               | Esquerda        |
| bit a bit AND                          | `&`                                                                                               | Esquerda        |
| bit a bit XOR                          | `^`                                                                                               | Esquerda        |
| bit a bit OR                           | <code>&#124;</code>                                                                                   | Esquerda        |
| relacional e teste de tipo           | `>=`   `>`   `<=`   `<`   `as`   `is`   `is!`                                                   | Nenhuma         |
| igualdade                             | `==`   `!=`                                                                                       | Nenhuma         |
| lógico AND                           | `&&`                                                                                              | Esquerda        |
| lógico OR                            | <code>&#124;&#124;</code>                                                                               | Esquerda        |
| if-null (se nulo)                      | `??`                                                                                              | Esquerda        |
| condicional                           | *`expr1`*   `?`   *`expr2`*   `:`   *`expr3`*                                                     | Direita        |
| cascata                                | `..`   `?..`                                                                                       | Esquerda        |
| atribuição                            | `=`   `*=`   `/=`   `+=`   `-=`   `&=`   `^=`   *etc.*                                          | Direita        |
| spread  ([Ver nota](#spread-operators))| `...`   `...?`                                                                                     | Nenhuma         |

{:.table .table-striped}

:::warning
A tabela anterior deve ser usada apenas como um guia útil.
A noção de precedência e associatividade de operadores
é uma aproximação da verdade encontrada na gramática da linguagem.
Você pode encontrar o comportamento definitivo das relações de operadores do Dart
na gramática definida na [especificação da linguagem Dart][].
:::

Quando você usa operadores, você cria expressões. Aqui estão alguns exemplos
de expressões de operadores:

<?code-excerpt "misc/test/language_tour/operators_test.dart (expressions)" replace="/,//g"?>
```dart
a++
a + b
a = b
a == b
c ? a : b
a is T
```

## Exemplo de precedência de operadores {:#operator-precedence-example}

Na [tabela de operadores](#operators),
cada operador tem precedência maior do que os operadores nas linhas
que o seguem. Por exemplo, o operador multiplicativo `%` tem maior
precedência do que (e, portanto, é executado antes) o operador de igualdade `==`,
que tem maior precedência do que o operador lógico AND `&&`. Essa
precedência significa que as duas linhas de código a seguir executam da mesma
maneira:

<?code-excerpt "misc/test/language_tour/operators_test.dart (precedence)"?>
```dart
// Parentheses improve readability.
if ((n % i == 0) && (d % i == 0)) ...

// Harder to read, but equivalent.
if (n % i == 0 && d % i == 0) ...
```

:::warning
Para operadores que recebem dois operandos, o operando mais à esquerda determina qual
método é usado. Por exemplo, se você tem um objeto `Vector` e
um objeto `Point`, então `aVector + aPoint` usa a adição do `Vector` (`+`).
:::


## Operadores aritméticos {:#arithmetic-operators}

O Dart suporta os operadores aritméticos usuais, conforme mostrado na tabela a seguir.

| Operador    | Significado                                                                 |
|-------------|-----------------------------------------------------------------------------|
| `+`         | Adição                                                                     |
| `-`         | Subtração                                                                  |
| `-`*`expr`* | Menos unário, também conhecido como negação (inverte o sinal da expressão) |
| `*`         | Multiplicação                                                              |
| `/`         | Divisão                                                                    |
| `~/`        | Divisão, retornando um resultado inteiro                                    |
| `%`         | Obtém o resto de uma divisão inteira (módulo)                               |

{:.table .table-striped}

Exemplo:

<?code-excerpt "misc/test/language_tour/operators_test.dart (arithmetic)"?>
```dart
assert(2 + 3 == 5);
assert(2 - 3 == -1);
assert(2 * 3 == 6);
assert(5 / 2 == 2.5); // Result is a double
assert(5 ~/ 2 == 2); // Result is an int
assert(5 % 2 == 1); // Remainder

assert('5/2 = ${5 ~/ 2} r ${5 % 2}' == '5/2 = 2 r 1');
```

O Dart também suporta os operadores de incremento e decremento prefixados
e posfixados.

| Operador                    | Significado                                              |
|-----------------------------|----------------------------------------------------------|
| `++`*`var`* | *`var`* `=` *`var`*  `+ 1` (valor da expressão é *`var`* `+ 1`) |
| *`var`*`++` | *`var`* `=` *`var`*  `+ 1` (valor da expressão é *`var`*)       |
| `--`*`var`* | *`var`* `=` *`var`*  `- 1` (valor da expressão é *`var`* `- 1`) |
| *`var`*`--` | *`var`* `=` *`var`*  `- 1` (valor da expressão é *`var`*)       |

{:.table .table-striped}

Exemplo:

<?code-excerpt "misc/test/language_tour/operators_test.dart (increment-decrement)"?>
```dart
int a;
int b;

a = 0;
b = ++a; // Increment a before b gets its value.
assert(a == b); // 1 == 1

a = 0;
b = a++; // Increment a after b gets its value.
assert(a != b); // 1 != 0

a = 0;
b = --a; // Decrement a before b gets its value.
assert(a == b); // -1 == -1

a = 0;
b = a--; // Decrement a after b gets its value.
assert(a != b); // -1 != 0
```


## Operadores de igualdade e relacionais {:#equality-and-relational-operators}

A tabela a seguir lista os significados dos operadores de igualdade e relacionais.

| Operador  | Significado                                 |
|-----------|---------------------------------------------|
| `==`      | Igual; veja a discussão abaixo               |
| `!=`      | Não igual                                   |
| `>`       | Maior que                                   |
| `<`       | Menor que                                   |
| `>=`      | Maior que ou igual a                        |
| `<=`      | Menor que ou igual a                        |

{:.table .table-striped}

Para testar se dois objetos x e y representam a mesma coisa, use o
operador `==`. (No raro caso em que você precisa saber se dois
objetos são exatamente o mesmo objeto, use a função [identical()][]
em vez disso.) Veja como o operador `==` funciona:

1.  Se *x* ou *y* for nulo, retorna true se ambos forem nulos e false se apenas
    um for nulo.

2.  Retorna o resultado da invocação do método `==` em *x* com o argumento *y*.
    (Isso mesmo, operadores como `==` são métodos que
    são invocados em seu primeiro operando.
    Para mais detalhes, veja [Operadores][].)

Aqui está um exemplo de como usar cada um dos operadores de igualdade
e relacionais:

<?code-excerpt "misc/test/language_tour/operators_test.dart (relational)"?>
```dart
assert(2 == 2);
assert(2 != 3);
assert(3 > 2);
assert(2 < 3);
assert(3 >= 3);
assert(2 <= 3);
```


## Operadores de teste de tipo {:#type-test-operators}

Os operadores `as`, `is` e `is!` são úteis para verificar tipos em
tempo de execução.

| Operador  | Significado                                                    |
|-----------|----------------------------------------------------------------|
| `as`      | Typecast (conversão de tipo) (também usado para especificar [prefixos de biblioteca][]) |
| `is`      | True se o objeto tem o tipo especificado                      |
| `is!`     | True se o objeto não tem o tipo especificado                |

{:.table .table-striped}

O resultado de `obj is T` é verdadeiro se `obj` implementa a interface
especificada por `T`. Por exemplo, `obj is Object?` é sempre verdadeiro.

Use o operador `as` para converter um objeto para um tipo específico se e somente se
você tiver certeza de que o objeto é desse tipo. Exemplo:

<?code-excerpt "misc/lib/language_tour/classes/employee.dart (emp-as-person)"?>
```dart
(employee as Person).firstName = 'Bob';
```

Se você não tiver certeza de que o objeto é do tipo `T`, use `is T` para verificar o
tipo antes de usar o objeto.
<?code-excerpt "misc/lib/language_tour/classes/employee.dart (emp-is-person)"?>
```dart
if (employee is Person) {
  // Type check
  employee.firstName = 'Bob';
}
```

:::note
O código não é equivalente. Se `employee` for nulo ou não for um `Person`, o
primeiro exemplo lança uma exceção; o segundo não faz nada.
:::

## Operadores de atribuição {:#assignment-operators}

Como você já viu, você pode atribuir valores usando o operador `=`.
Para atribuir somente se a variável atribuída for nula,
use o operador `??=`.

<?code-excerpt "misc/test/language_tour/operators_test.dart (assignment)"?>
```dart
// Assign value to a
a = value;
// Assign value to b if b is null; otherwise, b stays the same
b ??= value;
```

Operadores de atribuição compostos como `+=` combinam
uma operação com uma atribuição.

|      |       |       |        |                      |
|------|-------|-------|--------|----------------------|
| `=`  | `*=`  | `%=`  | `>>>=` | `^=`                 |
| `+=` | `/=`  | `<<=` | `&=`   | <code>&#124;=</code> |
| `-=` | `~/=` | `>>=` |        |                      |

{:.table}

Veja como os operadores de atribuição compostos funcionam:

|                            | Atribuição composta | Expressão equivalente |
|----------------------------|---------------------|-----------------------|
| **Para um operador *op*:** | `a`  *`op`*`= b`   | `a = a` *`op`* `b`   |
| **Exemplo:**               | `a += b`            | `a = a + b`           |

{:.table}

O exemplo a seguir usa operadores de atribuição e
atribuição composta:

<?code-excerpt "misc/test/language_tour/operators_test.dart (op-assign)"?>
```dart
var a = 2; // Assign using =
a *= 3; // Assign and multiply: a = a * 3
assert(a == 6);
```


## Operadores lógicos {:#logical-operators}

Você pode inverter ou combinar expressões booleanas usando os
operadores lógicos.

| Operador                   | Significado                                                                |
|----------------------------|----------------------------------------------------------------------------|
| `!`*`expr`*                | inverte a expressão seguinte (muda false para true e vice-versa)          |
| <code>&#124;&#124;</code>  | OR lógico                                                               |
| `&&`                       | AND lógico                                                              |

{:.table .table-striped}

Aqui está um exemplo de uso dos operadores lógicos:

<?code-excerpt "misc/lib/language_tour/operators.dart (op-logical)"?>
```dart
if (!done && (col == 0 || col == 3)) {
  // ...Do something...
}
```


## Operadores bit a bit e de deslocamento {:#bitwise-and-shift-operators}

Você pode manipular os bits individuais de números no Dart. Normalmente,
você usaria esses operadores bit a bit e de deslocamento com inteiros.

| Operador            | Significado                                              |
|---------------------|----------------------------------------------------------|
| `&`                 | AND                                                      |
| <code>&#124;</code> | OR                                                       |
| `^`                 | XOR                                                      |
| `~`*`expr`*         | Complemento bit a bit unário (0s tornam-se 1s; 1s tornam-se 0s) |
| `<<`                | Deslocamento para a esquerda                             |
| `>>`                | Deslocamento para a direita                              |
| `>>>`               | Deslocamento para a direita sem sinal                    |

{:.table .table-striped}

:::note
O comportamento de operações bit a bit com operandos grandes ou negativos
pode diferir entre as plataformas.
Para saber mais, consulte
[Diferenças de plataforma de operações bit a bit][].
:::

Aqui está um exemplo de uso de operadores bit a bit e de deslocamento:

<?code-excerpt "misc/test/language_tour/operators_test.dart (op-bitwise)"?>
```dart
final value = 0x22;
final bitmask = 0x0f;

assert((value & bitmask) == 0x02); // AND
assert((value & ~bitmask) == 0x20); // AND NOT
assert((value | bitmask) == 0x2f); // OR
assert((value ^ bitmask) == 0x2d); // XOR

assert((value << 4) == 0x220); // Shift left
assert((value >> 4) == 0x02); // Shift right

// Shift right example that results in different behavior on web
// because the operand value changes when masked to 32 bits:
assert((-value >> 4) == -0x03);

assert((value >>> 4) == 0x02); // Unsigned shift right
assert((-value >>> 4) > 0); // Unsigned shift right
```

:::version-note
O operador `>>>` (conhecido como _deslocamento triplo_ ou _deslocamento sem sinal_)
requer uma [versão da linguagem][] de pelo menos 2.14.
:::

[Diferenças de plataforma de operações bit a bit]: /resources/language/number-representation#bitwise-operations

## Expressões condicionais {:#conditional-expressions}

O Dart tem dois operadores que permitem que você avalie concisamente expressões
que, de outra forma, poderiam exigir instruções [if-else][]:

*`condição`* `?` *`expr1`* `:` *`expr2`*
: Se _condição_ for verdadeira, avalia _expr1_ (e retorna seu valor);
 caso contrário, avalia e retorna o valor de _expr2_.

 *`expr1`* `??` *`expr2`*
: Se _expr1_ não for nulo, retorna seu valor;
 caso contrário, avalia e retorna o valor de _expr2_.

Quando você precisar atribuir um valor
com base em uma expressão booleana,
considere usar o operador condicional `?` e `:`.

<?code-excerpt "misc/lib/language_tour/operators.dart (if-then-else-operator)"?>
```dart
var visibility = isPublic ? 'public' : 'private';
```

Se a expressão booleana testa se é nulo,
considere usar o operador if-null `??`
(também conhecido como operador de coalescência nula).

<?code-excerpt "misc/test/language_tour/operators_test.dart (if-null)"?>
```dart
String playerName(String? name) => name ?? 'Guest';
```

O exemplo anterior poderia ter sido escrito de pelo menos duas outras maneiras,
mas não de forma tão sucinta:

<?code-excerpt "misc/test/language_tour/operators_test.dart (if-null-alt)"?>
```dart
// Slightly longer version uses ?: operator.
String playerName(String? name) => name != null ? name : 'Guest';

// Very long version uses if-else statement.
String playerName(String? name) {
  if (name != null) {
    return name;
  } else {
    return 'Guest';
  }
}
```

## Notação em cascata {:#cascade-notation}

As cascatas (`..`, `?..`) permitem que você faça uma sequência de operações
no mesmo objeto. Além de acessar membros da instância,
você também pode chamar métodos da instância nesse mesmo objeto.
Isso geralmente economiza a etapa de criar uma variável temporária e
permite que você escreva um código mais fluido.

Considere o seguinte código:

<?code-excerpt "misc/lib/language_tour/cascades.dart (cascade)"?>
```dart
var paint = Paint()
  ..color = Colors.black
  ..strokeCap = StrokeCap.round
  ..strokeWidth = 5.0;
```

O construtor, `Paint()`,
retorna um objeto `Paint`.
O código que segue a notação em cascata opera
neste objeto, ignorando quaisquer valores que
possam ser retornados.

O exemplo anterior é equivalente a este código:

<?code-excerpt "misc/lib/language_tour/cascades.dart (cascade-expanded)"?>
```dart
var paint = Paint();
paint.color = Colors.black;
paint.strokeCap = StrokeCap.round;
paint.strokeWidth = 5.0;
```

Se o objeto no qual a cascata opera pode ser nulo,
use uma cascata de _null-shorting_ (`?..`) para a primeira operação.
Começar com `?..` garante que nenhuma das operações em cascata
seja tentada nesse objeto nulo.

<?code-excerpt "misc/test/language_tour/browser_test.dart (cascade-operator)"?>
```dart
querySelector('#confirm') // Get an object.
  ?..text = 'Confirm' // Use its members.
  ..classes.add('important')
  ..onClick.listen((e) => window.alert('Confirmed!'))
  ..scrollIntoView();
```

:::version-note
A sintaxe `?..` requer uma [versão da linguagem][] de pelo menos 2.12.
:::

O código anterior é equivalente ao seguinte:

<?code-excerpt "misc/test/language_tour/browser_test.dart (cascade-operator-example-expanded)"?>
```dart
var button = querySelector('#confirm');
button?.text = 'Confirm';
button?.classes.add('important');
button?.onClick.listen((e) => window.alert('Confirmed!'));
button?.scrollIntoView();
```

Você também pode aninhar cascatas. Por exemplo:

<?code-excerpt "misc/lib/language_tour/operators.dart (nested-cascades)"?>
```dart
final addressBook = (AddressBookBuilder()
      ..name = 'jenny'
      ..email = 'jenny@example.com'
      ..phone = (PhoneNumberBuilder()
            ..number = '415-555-0100'
            ..label = 'home')
          .build())
    .build();
```

Tenha cuidado ao construir sua cascata em uma função que retorna
um objeto real. Por exemplo, o código a seguir falha:

<?code-excerpt "misc/lib/language_tour/operators.dart (cannot-cascade-on-void)" plaster="none"?>
```dart
var sb = StringBuffer();
sb.write('foo')
  ..write('bar'); // Error: method 'write' isn't defined for 'void'.
```

A chamada `sb.write()` retorna void,
e você não pode construir uma cascata em `void`.

:::note
Estritamente falando, a notação "ponto duplo" para cascatas não é um operador.
É apenas parte da sintaxe Dart.
:::

## Operadores Spread {:#spread-operators}

Os operadores spread avaliam uma expressão que produz uma coleção,
descompactam os valores resultantes e os inserem em outra coleção.

**O operador spread não é realmente uma expressão de operador**.
A sintaxe `...`/`...?` faz parte do próprio literal da coleção.
Portanto, você pode aprender mais sobre os operadores spread na
página [Coleções](/language/collections#spread-operators).

Como não é um operador, a sintaxe não
tem nenhuma "[precedência de operador](#operators)".
Efetivamente, ela tem a menor "precedência" &mdash;
qualquer tipo de expressão é válido como alvo spread, como:

```dart
[...a + b]
```

## Outros operadores {:#other-operators}

Você viu a maioria dos operadores restantes em outros exemplos:

| Operador | Nome                           | Significado                                                                                                                                                                                                                                                               |
|----------|--------------------------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `()`     | Aplicação de função             | Representa uma chamada de função                                                                                                                                                                                                                                        |
| `[]`     | Acesso de subscrito             | Representa uma chamada ao operador `[]` substituível; exemplo: `fooList[1]` passa o int `1` para `fooList` para acessar o elemento no índice `1`                                                                                                                        |
| `?[]`    | Acesso de subscrito condicional | Semelhante a `[]`, mas o operando mais à esquerda pode ser nulo; exemplo: `fooList?[1]` passa o int `1` para `fooList` para acessar o elemento no índice `1`, a menos que `fooList` seja nulo (caso em que a expressão avalia como nula)                             |
| `.`      | Acesso de membro                | Refere-se a uma propriedade de uma expressão; exemplo: `foo.bar` seleciona a propriedade `bar` da expressão `foo`                                                                                                                                                      |
| `?.`     | Acesso de membro condicional    | Semelhante a `.`, mas o operando mais à esquerda pode ser nulo; exemplo: `foo?.bar` seleciona a propriedade `bar` da expressão `foo`, a menos que `foo` seja nulo (caso em que o valor de `foo?.bar` é nulo)                                                                 |
| `!`      | Operador de asserção não nula  | Converte uma expressão para seu tipo não anulável subjacente (underlying), lançando uma exceção em tempo de execução se a conversão falhar; exemplo: `foo!.bar` afirma que `foo` não é nulo e seleciona a propriedade `bar`, a menos que `foo` seja nulo, caso em que uma exceção de tempo de execução é lançada |

{:.table .table-striped}

Para obter mais informações sobre os operadores `.`, `?.` e `..`, consulte
[Classes][].


[operadores como membros de classe]: /language/methods#operators
[especificação da linguagem Dart]: /resources/language/spec
[identical()]: {{site.dart-api}}/dart-core/identical.html
[Operadores]: /language/methods#operators
[prefixos de biblioteca]: /language/libraries#specifying-a-library-prefix
[if-else]: /language/branches#if
[versão da linguagem]: /resources/language/evolution#language-versioning
[Classes]: /language/classes
