---
ia-translate: true
title: Operadores
description: Saiba mais sobre os operadores que o Dart suporta.
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
A tabela mostra a associatividade dos operadores do Dart
e [precedência de operadores](#operator-precedence-example) do mais alto para o mais baixo,
que são uma **aproximação** das relações de operadores do Dart.
Você pode implementar muitos desses [operadores como membros de classe][operators as class members].

| Descrição                             | Operador                                                                                           | Associatividade |
|-----------------------------------------|----------------------------------------------------------------------------------------------------|---------------|
| sufixo unário                           | *`expr`*`++`    *`expr`*`--`    `()`    `[]`    `?[]`    `.`    `?.`    `!`                        | Nenhuma         |
| prefixo unário                           | `-`*`expr`*    `!`*`expr`*    `~`*`expr`*    `++`*`expr`*    `--`*`expr`*      `await` *`expr`*    | Nenhuma         |
| multiplicativo                          | `*`    `/`    `%`    `~/`                                                                          | Esquerda        |
| aditivo                                | `+`    `-`                                                                                         | Esquerda        |
| deslocamento                            | `<<`    `>>`    `>>>`                                                                              | Esquerda        |
| bit a bit AND                           | `&`                                                                                                | Esquerda        |
| bit a bit XOR                           | `^`                                                                                                | Esquerda        |
| bit a bit OR                            | <code>&#124;</code>                                                                                | Esquerda        |
| relacional e teste de tipo                | `>=`    `>`    `<=`    `<`    `as`    `is`    `is!`                                                | Nenhuma         |
| igualdade                                | `==`    `!=`                                                                                       | Nenhuma         |
| lógico AND                             | `&&`                                                                                               | Esquerda        |
| lógico OR                              | <code>&#124;&#124;</code>                                                                          | Esquerda        |
| if-null                                 | `??`                                                                                               | Esquerda        |
| condicional                             | *`expr1`*    `?`    *`expr2`*    `:`    *`expr3`*                                                  | Direita         |
| cascata                                 | `..`    `?..`                                                                                      | Esquerda        |
| atribuição                              | `=`    `*=`    `/=`    `+=`    `-=`    `&=`    `^=`    *etc.*                                      | Direita         |
| espalhamento  ([Ver nota](#spread-operators)) | `...`    `...?`                                                                                    | Nenhuma         |

{:.table .table-striped}

:::warning
A tabela anterior deve ser usada apenas como um guia útil.
A noção de precedência e associatividade de operadores
é uma aproximação da verdade encontrada na gramática da linguagem.
Você pode encontrar o comportamento definitivo das relações de operadores do Dart
na gramática definida na [especificação da linguagem Dart][Dart language specification].
:::

Quando você usa operadores, você cria expressões. Aqui estão alguns exemplos
de expressões de operador:

<?code-excerpt "misc/test/language_tour/operators_test.dart (expressions)" replace="/,//g"?>
```dart
a++
a + b
a = b
a == b
c ? a : b
a is T
```

## Exemplo de precedência de operador

Na [tabela de operadores](#operators),
cada operador tem precedência mais alta do que os operadores nas linhas
que o seguem. Por exemplo, o operador multiplicativo `%` tem precedência mais alta
do que (e, portanto, é executado antes de) o operador de igualdade `==`,
que tem precedência mais alta do que o operador lógico AND `&&`. Essa
precedência significa que as duas linhas de código a seguir executam da mesma
maneira:

<?code-excerpt "misc/test/language_tour/operators_test.dart (precedence)"?>
```dart
// Parênteses melhoram a legibilidade.
if ((n % i == 0) && (d % i == 0)) ...

// Mais difícil de ler, mas equivalente.
if (n % i == 0 && d % i == 0) ...
```

:::warning
Para operadores que recebem dois operandos, o operando mais à esquerda determina qual
método é usado. Por exemplo, se você tem um objeto `Vector` e
um objeto `Point`, então `aVector + aPoint` usa a adição do `Vector` (`+`).
:::

## Operadores aritméticos

O Dart suporta os operadores aritméticos usuais, conforme mostrado na tabela a seguir.

| Operador    | Significado                                                                  |
|-------------|--------------------------------------------------------------------------|
| `+`         | Adição                                                                     |
| `-`         | Subtração                                                                 |
| `-`*`expr`* | Menos unário, também conhecido como negação (inverte o sinal da expressão) |
| `*`         | Multiplicação                                                                 |
| `/`         | Divisão                                                                   |
| `~/`        | Divisão, retornando um resultado inteiro                                      |
| `%`         | Obtém o resto de uma divisão inteira (módulo)                        |

{:.table .table-striped}

Exemplo:

<?code-excerpt "misc/test/language_tour/operators_test.dart (arithmetic)"?>
```dart
assert(2 + 3 == 5);
assert(2 - 3 == -1);
assert(2 * 3 == 6);
assert(5 / 2 == 2.5); // Resultado é um double
assert(5 ~/ 2 == 2); // Resultado é um int
assert(5 % 2 == 1); // Resto

assert('5/2 = ${5 ~/ 2} r ${5 % 2}' == '5/2 = 2 r 1');
```

O Dart também suporta operadores de incremento e decremento de prefixo e sufixo.

| Operador                    | Significado                                            |
|-----------------------------|----------------------------------------------------|
| `++`*`var`* | *`var`*  `=`  *`var `*  `+ 1` (o valor da expressão é *`var`* ` + 1`) |
| *`var`*`++` | *`var`*  `=`  *`var `*  `+ 1` (o valor da expressão é *`var`*)        |
| `--`*`var`* | *`var`*  `=`  *`var `*  `- 1` (o valor da expressão é *`var`* ` - 1`) |
| *`var`*`--` | *`var`*  `=`  *`var `*  `- 1` (o valor da expressão é *`var`*)       |

{:.table .table-striped}

Exemplo:

<?code-excerpt "misc/test/language_tour/operators_test.dart (increment-decrement)"?>
```dart
int a;
int b;

a = 0;
b = ++a; // Incrementa a antes que b obtenha seu valor.
assert(a == b); // 1 == 1

a = 0;
b = a++; // Incrementa a depois que b obtém seu valor.
assert(a != b); // 1 != 0

a = 0;
b = --a; // Decrementa a antes que b obtenha seu valor.
assert(a == b); // -1 == -1

a = 0;
b = a--; // Decrementa a depois que b obtém seu valor.
assert(a != b); // -1 != 0
```

## Operadores de igualdade e relacionais

A tabela a seguir lista os significados dos operadores de igualdade e relacionais.

| Operador  | Significado                                   |
|-----------|-------------------------------------------|
| `==`      | Igual; veja a discussão abaixo               |
| `!=`      | Não igual                                 |
| `>`       | Maior que                                 |
| `<`       | Menor que                                 |
| `>=`      | Maior ou igual a                  |
| `<=`      | Menor ou igual a                     |

{:.table .table-striped}

Para testar se dois objetos x e y representam a mesma coisa, use o
operador `==`. (No caso raro em que você precisa saber se dois
objetos são exatamente o mesmo objeto, use a função [identical()][identical()]
em vez disso.) Veja como o operador `==` funciona:

1.  Se *x* ou *y* for nulo, retorna verdadeiro se ambos forem nulos e falso se apenas
    um for nulo.

2.  Retorna o resultado da invocação do método `==` em *x* com o argumento *y*.
    (Isso mesmo, operadores como `==` são métodos que
    são invocados em seu primeiro operando.
    Para detalhes, veja [Operadores][Operators].)

Aqui está um exemplo de como usar cada um dos operadores de igualdade e relacionais:

<?code-excerpt "misc/test/language_tour/operators_test.dart (relational)"?>
```dart
assert(2 == 2);
assert(2 != 3);
assert(3 > 2);
assert(2 < 3);
assert(3 >= 3);
assert(2 <= 3);
```

## Operadores de teste de tipo

Os operadores `as`, `is` e `is!` são úteis para verificar tipos em tempo
de execução.

| Operador  | Significado                                              |
|-----------|------------------------------------------------------|
| `as`      | Conversão de tipo (também usado para especificar [prefixos de biblioteca][library prefixes]) |
| `is`      | Verdadeiro se o objeto tem o tipo especificado            |
| `is!`     | Verdadeiro se o objeto não tem o tipo especificado   |

{:.table .table-striped}

O resultado de `obj is T` é verdadeiro se `obj` implementar a interface
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
  // Verificação de tipo
  employee.firstName = 'Bob';
}
```

:::note
O código não é equivalente. Se `employee` for nulo ou não for um `Person`, o
primeiro exemplo lançará uma exceção; o segundo não faz nada.
:::

## Operadores de atribuição

Como você já viu, você pode atribuir valores usando o operador `=`.
Para atribuir apenas se a variável atribuída for nula,
use o operador `??=`.

<?code-excerpt "misc/test/language_tour/operators_test.dart (assignment)"?>
```dart
// Atribui valor a a
a = value;
// Atribui valor a b se b for nulo; caso contrário, b permanece o mesmo
b ??= value;
```

Operadores de atribuição composta, como `+=`, combinam
uma operação com uma atribuição.

|      |       |       |        |                      |
|------|-------|-------|--------|----------------------|
| `=`  | `*=`  | `%=`  | `>>>=` | `^=`                 |
| `+=` | `/=`  | `<<=` | `&=`   | <code>&#124;=</code> |
| `-=` | `~/=` | `>>=` |        |                      |

{:.table}

Veja como funcionam os operadores de atribuição composta:

|                           | Atribuição composta | Expressão equivalente |
|---------------------------|---------------------|-----------------------|
| **Para um operador *op*:** | `a `  *`op`*`= b`   | `a = a ` *`op `* `b`  |
| **Exemplo:**              | `a += b`            | `a = a + b`           |

{:.table}

O exemplo a seguir usa operadores de atribuição e atribuição composta:

<?code-excerpt "misc/test/language_tour/operators_test.dart (op-assign)"?>
```dart
var a = 2; // Atribui usando =
a *= 3; // Atribui e multiplica: a = a * 3
assert(a == 6);
```

## Operadores lógicos

Você pode inverter ou combinar expressões booleanas usando os operadores
lógicos.

| Operador                   | Significado                                                                  |
|----------------------------|--------------------------------------------------------------------------|
| `!`*`expr`*                | inverte a expressão seguinte (muda falso para verdadeiro e vice-versa) |
| <code>&#124;&#124;</code>  | OR lógico                                                               |
| `&&`                       | AND lógico                                                              |

{:.table .table-striped}

Aqui está um exemplo de como usar os operadores lógicos:

<?code-excerpt "misc/lib/language_tour/operators.dart (op-logical)"?>
```dart
if (!done && (col == 0 || col == 3)) {
  // ...Faça algo...
}
```

## Operadores bit a bit e de deslocamento

Você pode manipular os bits individuais de números no Dart. Normalmente,
você usaria esses operadores bit a bit e de deslocamento com inteiros.

| Operador            | Significado                                               |
|---------------------|-------------------------------------------------------|
| `&`                 | AND                                                   |
| <code>&#124;</code> | OR                                                    |
| `^`                 | XOR                                                   |
| `~`*`expr`*         | Complemento bit a bit unário (0s se tornam 1s; 1s se tornam 0s) |
| `<<`                | Deslocamento para a esquerda                                            |
| `>>`                | Deslocamento para a direita                                           |
| `>>>`               | Deslocamento não assinado para a direita                                  |

{:.table .table-striped}

:::note
O comportamento das operações bit a bit com operandos grandes ou negativos
pode diferir entre as plataformas.
Para saber mais, confira
[Diferenças de plataforma de operações bit a bit][Bitwise operations platform differences].
:::

Aqui está um exemplo de como usar operadores bit a bit e de deslocamento:

<?code-excerpt "misc/test/language_tour/operators_test.dart (op-bitwise)"?>
```dart
final value = 0x22;
final bitmask = 0x0f;

assert((value & bitmask) == 0x02); // AND
assert((value & ~bitmask) == 0x20); // AND NOT
assert((value | bitmask) == 0x2f); // OR
assert((value ^ bitmask) == 0x2d); // XOR

assert((value << 4) == 0x220); // Deslocamento para a esquerda
assert((value >> 4) == 0x02); // Deslocamento para a direita

// Exemplo de deslocamento para a direita que resulta em comportamento diferente na web
// porque o valor do operando muda quando mascarado para 32 bits:
assert((-value >> 4) == -0x03);

assert((value >>> 4) == 0x02); // Deslocamento não assinado para a direita
assert((-value >>> 4) > 0); // Deslocamento não assinado para a direita
```

:::version-note
O operador `>>>` (conhecido como _deslocamento triplo_ ou _deslocamento não assinado_)
requer uma [versão da linguagem][language version] de pelo menos 2.14.
:::

[Bitwise operations platform differences]: /resources/language/number-representation#bitwise-operations

## Expressões condicionais

O Dart tem dois operadores que permitem avaliar expressões de forma concisa
que, de outra forma, exigiriam instruções [if-else][if-else]:

*`condição `* `? ` *`expr1 `* `: ` *`expr2`*
: Se _condição_ for verdadeira, avalia _expr1_ (e retorna seu valor);
  caso contrário, avalia e retorna o valor de _expr2_.

 *`expr1 `* `?? ` *`expr2`*
: Se _expr1_ não for nulo, retorna seu valor;
  caso contrário, avalia e retorna o valor de _expr2_.

Quando você precisa atribuir um valor
com base em uma expressão booleana,
considere usar o operador condicional `?` e `:`.

<?code-excerpt "misc/lib/language_tour/operators.dart (if-then-else-operator)"?>
```dart
var visibility = isPublic ? 'public' : 'private';
```

Se a expressão booleana testar para nulo,
considere usar o operador if-null `??`
(também conhecido como operador de coalescência nula).

<?code-excerpt "misc/test/language_tour/operators_test.dart (if-null)"?>
```dart
String playerName(String? name) => name ?? 'Guest';
```

O exemplo anterior poderia ter sido escrito de pelo menos duas outras maneiras,
mas não de forma tão concisa:

<?code-excerpt "misc/test/language_tour/operators_test.dart (if-null-alt)"?>
```dart
// Uma versão um pouco mais longa usa o operador ?:.
String playerName(String? name) => name != null ? name : 'Guest';

// Versão muito longa usa instrução if-else.
String playerName(String? name) {
  if (name != null) {
    return name;
  } else {
    return 'Guest';
  }
}
```

## Notação em cascata

As cascatas (`..`, `?..`) permitem que você faça uma sequência de operações
no mesmo objeto. Além de acessar membros de instância,
você também pode chamar métodos de instância nesse mesmo objeto.
Isso geralmente economiza a etapa de criar uma variável temporária e
permite que você escreva um código mais fluído.

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

Se o objeto no qual a cascata opera puder ser nulo,
use uma cascata _de curto-circuito nula_ (`?..`) para a primeira operação.
Começar com `?..` garante que nenhuma das operações em cascata
seja tentada nesse objeto nulo.

<?code-excerpt "misc/test/language_tour/browser_test.dart (cascade-operator)"?>
```dart
querySelector('#confirm') // Obtém um objeto.
  ?..text = 'Confirm' // Usa seus membros.
  ..classes.add('important')
  ..onClick.listen((e) => window.alert('Confirmado!'))
  ..scrollIntoView();
```

:::version-note
A sintaxe `?..` requer uma [versão da linguagem][language version] de pelo menos 2.12.
:::

O código anterior é equivalente ao seguinte:

<?code-excerpt "misc/test/language_tour/browser_test.dart (cascade-operator-example-expanded)"?>
```dart
var button = querySelector('#confirm');
button?.text = 'Confirm';
button?.classes.add('important');
button?.onClick.listen((e) => window.alert('Confirmado!'));
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

Tenha cuidado para construir sua cascata em uma função que retorne
um objeto real. Por exemplo, o código a seguir falha:

<?code-excerpt "misc/lib/language_tour/operators.dart (cannot-cascade-on-void)" plaster="none"?>
```dart
var sb = StringBuffer();
sb.write('foo')
  ..write('bar'); // Erro: o método 'write' não está definido para 'void'.
```

A chamada `sb.write()` retorna void,
e você não pode construir uma cascata em `void`.

:::note
Estritamente falando, a notação de "ponto duplo" para cascatas não é um operador.
É apenas parte da sintaxe do Dart.
:::

## Operadores de espalhamento

Os operadores de espalhamento avaliam uma expressão que produz uma coleção,
descompacta os valores resultantes e os insere em outra coleção.

**O operador de espalhamento não é realmente uma expressão de operador**.
A sintaxe `...`/`...?` faz parte do próprio literal de coleção.
Portanto, você pode aprender mais sobre os operadores de espalhamento na
página [Coleções](/language/collections#spread-operators).

Como não é um operador, a sintaxe não
tem nenhuma "[precedência de operador](#operators)".
Efetivamente, ele tem a "precedência" mais baixa &mdash;
qualquer tipo de expressão é válido como o destino do espalhamento, como:

```dart
[...a + b]
```

## Outros operadores

Você viu a maioria dos operadores restantes em outros exemplos:

| Operador | Nome                         | Significado                                                                                                                                                                                                                                                 |
|----------|------------------------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `()`     | Aplicação de função         | Representa uma chamada de função                                                                                                                                                                                                                              |
| `[]`     | Acesso de subscrito             | Representa uma chamada ao operador `[]` substituível; exemplo: `fooList[1]` passa o int `1` para `fooList` para acessar o elemento no índice `1`                                                                                                            |
| `?[]`    | Acesso de subscrito condicional | Como `[]`, mas o operando mais à esquerda pode ser nulo; exemplo: `fooList?[1]` passa o int `1` para `fooList` para acessar o elemento no índice `1` a menos que `fooList` seja nulo (caso em que a expressão é avaliada como nula)                                    |
| `.`      | Acesso de membro                | Refere-se a uma propriedade de uma expressão; exemplo: `foo.bar` seleciona a propriedade `bar` da expressão `foo`                                                                                                                                                  |
| `?.`     | Acesso de membro condicional    | Como `.`, mas o operando mais à esquerda pode ser nulo; exemplo: `foo?.bar` seleciona a propriedade `bar` da expressão `foo` a menos que `foo` seja nulo (caso em que o valor de `foo?.bar` é nulo)                                                                   |
| `!`      | Operador de asserção não nula  | Converte uma expressão para seu tipo não anulável, lançando uma exceção de tempo de execução se a conversão falhar; exemplo: `foo!.bar` afirma que `foo` não é nulo e seleciona a propriedade `bar`, a menos que `foo` seja nulo, caso em que uma exceção de tempo de execução é lançada |

{:.table .table-striped}

Para obter mais informações sobre os operadores `.`, `?.` e `..`, consulte
[Classes][Classes].

[operators as class members]: /language/methods#operators
[Dart language specification]: /resources/language/spec
[identical()]: {{site.dart-api}}/dart-core/identical.html
[Operators]: /language/methods#operators
[library prefixes]: /language/libraries#specifying-a-library-prefix
[if-else]: /language/branches#if
[language version]: /resources/language/evolution#language-versioning
[Classes]: /language/classes
