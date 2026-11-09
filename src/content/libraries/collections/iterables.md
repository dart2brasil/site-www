---
ia-translate: true
title: Coleções Iterable
description: >-
  Um guia interativo para usar objetos Iterable, como listas e conjuntos.
showBreadcrumbs: false
---
<?code-excerpt replace="/ *\/\/\s+ignore_for_file:[^\n]+\n//g; /(^|\n) *\/\/\s+ignore:[^\n]+\n/$1/g; /(\n[^\n]+) *\/\/\s+ignore:[^\n]+\n/$1\n/g"?>
<?code-excerpt plaster="none"?>

Este tutorial ensina a usar coleções que
implementam a classe [Iterable][iterable class]—por exemplo,
[List][list class] e [Set.][set class]
Iterables são blocos básicos de construção para
todos os tipos de aplicativos Dart,
e você provavelmente já os usa,
mesmo sem perceber.
Este tutorial ajuda você a tirar o máximo proveito deles.

Usando os editores DartPad embutidos,
você pode testar seus conhecimentos
executando código de exemplo e resolvendo exercícios.

Para aproveitar ao máximo este tutorial,
você deve ter conhecimento básico de [sintaxe do Dart](/language).

Este tutorial cobre o seguinte conteúdo:

* Como ler elementos de um Iterable.
* Como verificar se os elementos de um Iterable satisfazem uma condição.
* Como filtrar o conteúdo de um Iterable.
* Como mapear o conteúdo de um Iterable para um valor diferente.

Tempo estimado para concluir este tutorial: 60 minutos.

:::note
Esta página usa DartPads embutidos para exibir exemplos e exercícios.
{% render 'dartpads-embedded-troubleshooting.md' %}
:::

Os exercícios deste tutorial têm trechos de código parcialmente completos.
Você pode usar o DartPad para testar seus conhecimentos completando o código e
clicando no botão **Run**.
**Não edite o código de teste na função `main` nem abaixo dela**.

Se precisar de ajuda, expanda o menu suspenso **Hint** ou **Solution**
após cada exercício.

## O que são coleções? {:#what-are-collections}

Uma coleção é um objeto que
representa um grupo de objetos, chamados _elementos_.
Iterables são um tipo de coleção.

Uma coleção pode estar vazia ou conter muitos elementos.
Dependendo da finalidade,
coleções podem ter estruturas e implementações diferentes.
Estes são alguns dos tipos de coleção mais comuns:

* [List:][list class] usado para ler elementos pelos seus índices.
* [Set:][set class] usado para conter elementos que podem aparecer apenas uma vez.
* [Map:][map class] usado para ler elementos usando uma chave.


## O que é um Iterable? {:#what-is-an-iterable}

Um `Iterable` é uma coleção de elementos que podem ser acessados sequencialmente.

Em Dart, `Iterable` é uma classe abstrata,
o que significa que você não pode instanciá-la diretamente.
No entanto, você pode criar um novo `Iterable` criando uma nova `List` ou `Set`.

Tanto `List` quanto `Set` são `Iterable`,
então têm os mesmos métodos e propriedades da classe `Iterable`.

Um `Map` usa uma estrutura de dados diferente internamente,
dependendo da implementação.
Por exemplo, [HashMap][hashmap class] usa uma tabela hash
na qual os elementos (também chamados _valores_) são obtidos por meio de uma chave.
Os elementos de um `Map` também podem ser lidos como objetos `Iterable`
usando a propriedade `entries` ou `values` do mapa.

Este exemplo mostra uma `List` de `int`,
que também é um `Iterable` de `int`:

<?code-excerpt "iterables/test/iterables_test.dart (iterable)"?>
```dart
Iterable<int> iterable = [1, 2, 3];
```

A diferença em relação a uma `List` é que, com o `Iterable`,
você não pode garantir que a leitura de elementos por índice seja eficiente.
Diferentemente de `List`, `Iterable` não tem o operador `[]`.

Por exemplo, considere o código a seguir, que é **inválido**:

<?code-excerpt "iterables/test/iterables_test.dart (iterable-elementat)" replace="/\.elementAt\(1\)/[![1]!]/g"?>
```dart tag=bad
Iterable<int> iterable = [1, 2, 3];
int value = iterable[![1]!];
```

Se você ler elementos com `[]`,
o compilador informa que o operador `'[]'`
não está definido para a classe `Iterable`,
o que significa que você não pode usar `[index]` nesse caso.

Em vez disso, você pode ler elementos com `elementAt()`,
que percorre os itens do iterable até
chegar ao item naquela posição.

<?code-excerpt "iterables/test/iterables_test.dart (iterable-elementat)"?>
```dart
Iterable<int> iterable = [1, 2, 3];
int value = iterable.elementAt(1);
```

Dependendo da implementação do iterable e do número de itens,
`elementAt` pode ter complexidade linear e ser custoso.
Se você planeja acessar itens específicos repetidamente, considere
chamar `.toList()` no iterable para convertê-lo em uma lista uma única vez,
e então usar o operador `[]`.

<?code-excerpt "iterables/test/iterables_test.dart (iterable-to-list)"?>
```dart
final items = veryLargeIterable().toList();

final tenthItem = items[9];
final hundredthItem = items[99];
final thousandthItem = items[999];
final lastItem = items.last;
```

Continue para a próxima seção para aprender mais sobre
como acessar elementos de um `Iterable`.

## Lendo elementos {:#reading-elements}

Você pode ler os elementos de um iterable sequencialmente,
usando um loop `for-in`.

### Exemplo: usando um loop for-in {:#example-using-a-for-in-loop}

O exemplo a seguir mostra como ler elementos usando um loop `for-in`.

<?code-excerpt "iterables/test/iterables_test.dart (for-in)"?>
```dartpad
void main() {
  const iterable = ['Salad', 'Popcorn', 'Toast'];
  for (final element in iterable) {
    print(element);
  }
}
```

:::note Detalhes
Por trás dos panos, o loop `for-in` usa um _iterator._
Você raramente vê a API [Iterator][iterator class] sendo usada diretamente,
porque `for-in` é mais fácil de ler e entender,
e é menos propenso a erros.
:::

:::secondary Termos-chave
* **Iterable**: A classe [Iterable][iterable class] do Dart.
* **Iterator**: Um objeto usado pelo `for-in` para ler elementos de
  um objeto `Iterable`.
* **Loop `for-in`**: Uma forma fácil de ler elementos sequencialmente de
  um `Iterable`.
:::

### Exemplo: usando first e last {:#example-using-first-and-last}

Em alguns casos, você quer acessar apenas o primeiro ou o último elemento
de um `Iterable`.

Com a classe `Iterable`, você não pode acessar os elementos diretamente,
então não pode chamar `iterable[0]` para acessar o primeiro elemento.
Em vez disso, você pode usar `first`,
que obtém o primeiro elemento.

Além disso, com a classe `Iterable`,
você não pode usar o operador `[]` para acessar o último elemento,
mas pode usar a propriedade `last`.

:::warning
Como acessar o último elemento de um `Iterable` exige
percorrer todos os outros elementos,
**`last` pode ser lento.**
Usar `first` ou `last` em um **`Iterable` vazio**
resulta em um [StateError.][StateError class]
:::

<?code-excerpt "iterables/test/iterables_test.dart (first-last)"?>
```dartpad
void main() {
  Iterable<String> iterable = const ['Salad', 'Popcorn', 'Toast'];
  print('The first element is ${iterable.first}');
  print('The last element is ${iterable.last}');
}
```

Neste exemplo, você viu como usar `first` e `last` para
obter o primeiro e o último elementos de um `Iterable`.
Também é possível encontrar o primeiro elemento que satisfaz uma condição.
A próxima seção mostra como fazer isso usando um método chamado `firstWhere()`.

### Exemplo: usando firstWhere() {:#example-using-firstwhere}

Você já viu que pode acessar os elementos de um `Iterable` sequencialmente,
e pode obter facilmente o primeiro ou o último elemento.

Agora, você aprende a usar `firstWhere()` para encontrar o primeiro elemento que
satisfaz certas condições.
Esse método exige que você passe um _predicado_,
que é uma função que retorna true se
a entrada satisfaz determinada condição.

<?code-excerpt "iterables/test/iterables_test.dart (firstwhere)"?>
```dart
String element = iterable.firstWhere((element) => element.length > 5);
```

Por exemplo, se você quer encontrar a primeira `String` que tem
mais de 5 caracteres,
precisa passar um predicado que retorne true quando
o tamanho do elemento for maior que 5.

Execute o exemplo a seguir para ver como `firstWhere()` funciona.
Você acha que todas as funções vão dar o mesmo resultado?

<?code-excerpt "iterables/test/iterables_test.dart (first-where-long)"?>
```dartpad
bool predicate(String item) {
  return item.length > 5;
}

void main() {
  const items = ['Salad', 'Popcorn', 'Toast', 'Lasagne'];

  // You can find with a simple expression:
  var foundItem1 = items.firstWhere((item) => item.length > 5);
  print(foundItem1);

  // Or try using a function block:
  var foundItem2 = items.firstWhere((item) {
    return item.length > 5;
  });
  print(foundItem2);

  // Or even pass in a function reference:
  var foundItem3 = items.firstWhere(predicate);
  print(foundItem3);

  // You can also use an `orElse` function in case no value is found!
  var foundItem4 = items.firstWhere(
    (item) => item.length > 10,
    orElse: () => 'None!',
  );
  print(foundItem4);
}
```

Neste exemplo, você vê três formas diferentes de escrever um predicado:

* **Como expressão:**
  o código de teste tem uma linha que usa a sintaxe de seta (`=>`).
* **Como bloco:**
  o código de teste tem várias linhas entre chaves e um comando return.
* **Como função:**
  o código de teste está em uma função externa, que é passada ao
  método `firstWhere()` como parâmetro.

Não existe jeito certo ou errado.
Use o jeito que funcionar melhor para você
e que deixe seu código mais fácil de ler e entender.

O exemplo final chama `firstWhere()` com
o parâmetro nomeado opcional `orElse`,
que fornece uma alternativa quando um elemento não é encontrado.
Nesse caso, o texto `'None!'` é retornado porque
nenhum elemento satisfaz a condição fornecida.

:::note
Se nenhum elemento satisfizer o predicado de teste e
o parâmetro `orElse` não for fornecido,
então `firstWhere()` lança um [StateError.][StateError class]
:::

:::secondary Revisão rápida
* Os elementos de um `Iterable` devem ser acessados sequencialmente.
* A forma mais fácil de percorrer todos os elementos é
  usando um loop `for-in`.
* Você pode usar os getters `first` e `last` para obter
  o primeiro e o último elementos.
* Você também pode encontrar o primeiro elemento que
  satisfaz uma condição com `firstWhere()`.
* Você pode escrever predicados de teste como expressões, blocos ou funções.

  **Termos-chave:**
* **Predicado:**
  uma função que retorna `true` quando uma certa condição é satisfeita.
:::

### Exercício: praticando a escrita de um predicado de teste {:#exercise-practice-writing-a-test-predicate}

O exercício a seguir é um teste unitário que falha e
contém um trecho de código parcialmente completo.
Sua tarefa é completar o exercício escrevendo código para fazer os testes passarem.
Você não precisa implementar `main()`.

Este exercício apresenta `singleWhere()`.
Esse método funciona de forma parecida com `firstWhere()`,
mas, neste caso, ele espera que apenas um elemento do `Iterable` satisfaça
o predicado.
Se mais de um elemento ou nenhum elemento do `Iterable`
satisfizer a condição do predicado,
então o método lança uma exceção [StateError][StateError class].

:::warning
`singleWhere()` percorre todo o `Iterable` até o último elemento,
o que pode causar problemas se o `Iterable` for infinito ou
contiver uma coleção grande de elementos.
:::

Seu objetivo é implementar o predicado para `singleWhere()` que
satisfaça as seguintes condições:

* O elemento contém o caractere `'a'`.
* O elemento começa com o caractere `'M'`.

Todos os elementos nos dados de teste são [strings][String class];
você pode consultar a documentação da classe para ajuda.

```dartpad theme="dark"
// Implement the predicate of singleWhere
// with the following conditions
// * The element contains the character `'a'`
// * The element starts with the character `'M'`
String singleWhere(Iterable<String> items) {
  return items.singleWhere(TODO('Implement the outlined predicate.'));
}

// The following code is used to provide feedback on your solution.
// There is no need to read or modify it.
void main() {
  const items = [
    'Salad',
    'Popcorn',
    'Milk',
    'Toast',
    'Sugar',
    'Mozzarella',
    'Tomato',
    'Egg',
    'Water',
  ];

  try {
    final str = singleWhere(items);
    if (str == 'Mozzarella') {
      print('Success. All tests passed!');
    } else {
      print(
        'Tried calling singleWhere, but received $str instead of '
        'the expected value \'Mozzarella\'',
      );
    }
  } on StateError catch (stateError) {
    print(
      'Tried calling singleWhere, but received a StateError: ${stateError.message}. '
      'singleWhere will fail if 0 or many elements match the predicate.',
    );
  } on UnimplementedError {
    print(
      'Tried running `singleWhere`, but received an error. '
      'Did you implement the function?',
    );
  } catch (e) {
    print('Tried calling singleWhere, but received an exception: $e');
  }
}
```

<details>
  <summary title="Expand for a hint on the predicate exercise.">Dica</summary>

  Sua solução pode usar os métodos `contains` e `startsWith`
  da classe `String`.

</details>

<details>
  <summary title="Expand for the solution of the predicate exercise.">Solução</summary>

  ```dart
  String singleWhere(Iterable<String> items) {
    return items.singleWhere(
            (element) => element.startsWith('M') && element.contains('a'));
  }
  ```

</details>

## Verificando condições {:#checking-conditions}

Ao trabalhar com `Iterable`, às vezes você precisa verificar se
todos os elementos de uma coleção satisfazem alguma condição.

Você pode ser tentado a escrever uma solução usando um loop `for-in` como este:

<?code-excerpt "iterables/test/iterables_test.dart (every-bad)"?>
```dart tag=bad
for (final item in items) {
  if (item.length < 5) {
    return false;
  }
}
return true;
```

No entanto, você pode fazer o mesmo usando o método `every()`:

<?code-excerpt "iterables/test/iterables_test.dart (every-good)"?>
```dart
return items.every((item) => item.length >= 5);
```

Usar o método `every()` resulta em código mais
legível, compacto e menos propenso a erros.

### Exemplo: usando any() e every() {:#example-using-any-and-every}

A classe `Iterable` oferece dois métodos que
você pode usar para verificar condições:

* `any()`: retorna true se pelo menos um elemento satisfaz a condição.
* `every()`: retorna true se todos os elementos satisfazem a condição.

Execute este exercício para vê-los em ação.

<?code-excerpt "iterables/test/iterables_test.dart (any-every)"?>
```dartpad
void main() {
  const items = ['Salad', 'Popcorn', 'Toast'];

  if (items.any((item) => item.contains('a'))) {
    print('At least one item contains "a"');
  }

  if (items.every((item) => item.length >= 5)) {
    print('All items have length >= 5');
  }
}
```

No exemplo, `any()` verifica se
pelo menos um elemento contém o caractere `a`,
e `every()` verifica se todos os elementos
têm tamanho igual ou maior que 5.

Depois de executar o código, tente mudar o predicado de `any()` para que
ele retorne false:

<?code-excerpt "iterables/test/iterables_test.dart (any-false)"?>
```dart
if (items.any((item) => item.contains('Z'))) {
  print('At least one item contains "Z"');
} else {
  print('No item contains "Z"');
}
```

Você também pode usar `any()` para verificar se nenhum elemento de um `Iterable`
satisfaz determinada condição.


### Exercício: verificando se um Iterable satisfaz uma condição {:#exercise-verify-that-an-iterable-satisfies-a-condition}

O exercício a seguir oferece prática com os métodos
`any()` e `every()`, descritos no exemplo anterior.
Neste caso, você trabalha com um grupo de usuários,
representados por objetos `User` que têm o campo `age`.

Use `any()` e `every()` para implementar duas funções:

* Parte 1: implemente `anyUserUnder18()`.
  * Retorne `true` se pelo menos um usuário tiver 17 anos ou menos.
* Parte 2: implemente `everyUserOver13()`.
  * Retorne `true` se todos os usuários tiverem 14 anos ou mais.

```dartpad
bool anyUserUnder18(Iterable<User> users) {
  // TODO: Implement the anyUserUnder18 function.
}

bool everyUserOver13(Iterable<User> users) {
  // TODO: Implement the everyUserOver13 function.
}

class User {
  final String name;
  final int age;

  User(
    this.name,
    this.age,
  );
}

// The following code is used to provide feedback on your solution.
// There is no need to read or modify it.
void main() {
  final users = [
    User('Alice', 21),
    User('Bob', 17),
    User('Claire', 52),
    User('David', 14),
  ];

  try {
    final out = anyUserUnder18(users);
    if (!out) {
      print('Looks like `anyUserUnder18` is wrong. Keep trying!');
      return;
    }
  } on UnimplementedError {
    print(
      'Tried running `anyUserUnder18`, but received an error. '
      'Did you implement the function?',
    );
    return;
  } catch (e) {
    print('Tried running `anyUserUnder18`, but received an exception: $e');
    return;
  }

  try {
    // with only one user older than 18, should be false
    final out = anyUserUnder18([User('Alice', 21)]);
    if (out) {
      print(
          'Looks like `anyUserUnder18` is wrong. What if all users are over 18?');
      return;
    }
  } on UnimplementedError {
    print(
      'Tried running `anyUserUnder18`, but received an error. '
      'Did you implement the function?',
    );
    return;
  } catch (e) {
    print(
      'Tried running `anyUserUnder18([User("Alice", 21)])`, '
      'but received an exception: $e',
    );
    return;
  }

  try {
    final out = everyUserOver13(users);
    if (!out) {
      print(
        'Looks like `everyUserOver13` is wrong. '
        'There are no users under 13!',
      );
      return;
    }
  } on UnimplementedError {
    print(
      'Tried running `everyUserOver13`, but received an error. '
      'Did you implement the function?',
    );
    return;
  } catch (e) {
    print(
      'Tried running `everyUserOver13`, '
      'but received an exception: $e',
    );
    return;
  }

  try {
    final out = everyUserOver13([User('Dan', 12)]);
    if (out) {
      print(
        'Looks like `everyUserOver13` is wrong. '
        'There is at least one user under 13!',
      );
      return;
    }
  } on UnimplementedError {
    print(
      'Tried running `everyUserOver13`, but received an error. '
      'Did you implement the function?',
    );
    return;
  } catch (e) {
    print(
      'Tried running `everyUserOver13([User(\'Dan\', 12)])`, '
      'but received an exception: $e',
    );
    return;
  }

  print('Success. All tests passed!');
}
```

<details>
  <summary title="Expand for a hint on the conditional filtering exercise.">Dica</summary>

  Lembre-se de usar os métodos `any` e `every` da classe `Iterable`.
  Para ajuda e exemplos usando esses métodos, consulte
  a [discussão anterior sobre eles](#example-using-any-and-every).

</details>

<details>
  <summary title="Expand for the solution of the conditional filtering exercise.">Solução</summary>

  ```dart
  bool anyUserUnder18(Iterable<User> users) {
    return users.any((user) => user.age < 18);
  }
  
  bool everyUserOver13(Iterable<User> users) {
    return users.every((user) => user.age > 13);
  }
  ```

</details>

:::secondary Revisão rápida
* Embora você possa usar loops `for-in` para verificar condições,
  existem formas melhores de fazer isso.
* O método `any()` permite verificar se
  algum elemento satisfaz uma condição.
* O método `every()` permite verificar se
  todos os elementos satisfazem uma condição.
:::

## Filtrando {:#filtering}

As seções anteriores abordam métodos como `firstWhere()` ou
`singleWhere()`, que ajudam a encontrar um elemento que
satisfaz determinado predicado.

Mas e se você quiser encontrar todos os elementos que
satisfazem certa condição?
Você pode fazer isso usando o método `where()`.

<?code-excerpt "iterables/test/iterables_test.dart (where)"?>
```dart
var evenNumbers = numbers.where((number) => number.isEven);
```

Neste exemplo,
`numbers` contém um `Iterable` com vários valores `int`, e
`where()` encontra todos os números que são pares.

A saída de `where()` é outro `Iterable`,
e você pode usá-lo como tal para iterar sobre ele ou
aplicar outros métodos de `Iterable`.
No próximo exemplo, a saída de `where()`
é usada diretamente dentro do loop `for-in`.

<?code-excerpt "iterables/test/iterables_test.dart (where-for)"?>
```dart
var evenNumbers = numbers.where((number) => number.isEven);
for (final number in evenNumbers) {
  print('$number is even');
}
```

### Exemplo: usando where() {:#example-using-where}

Execute este exemplo para ver como `where()` pode ser usado junto com outros
métodos, como `any()`.

<?code-excerpt "iterables/test/iterables_test.dart (numbers-where)"?>
```dartpad
void main() {
  var evenNumbers = const [1, -2, 3, 42].where((number) => number.isEven);

  for (final number in evenNumbers) {
    print('$number is even.');
  }

  if (evenNumbers.any((number) => number.isNegative)) {
    print('evenNumbers contains negative numbers.');
  }

  // If no element satisfies the predicate, the output is empty.
  var largeNumbers = evenNumbers.where((number) => number > 1000);
  if (largeNumbers.isEmpty) {
    print('largeNumbers is empty!');
  }
}
```

Neste exemplo, `where()` é usado para encontrar todos os números pares, e depois
`any()` é usado para verificar se os resultados contêm um número negativo.

Mais adiante no exemplo, `where()` é usado novamente para
encontrar todos os números maiores que 1000.
Como não há nenhum, o resultado é um `Iterable` vazio.

:::note
Se nenhum elemento satisfizer o predicado em `where()`,
então o método retorna um `Iterable` vazio.
Diferentemente de `singleWhere()` ou `firstWhere()`,
`where()` não lança uma exceção [StateError][StateError class].
:::

### Exemplo: usando takeWhile {:#example-using-takewhile}

Os métodos `takeWhile()` e `skipWhile()` também podem
ajudar a filtrar elementos de um `Iterable`.

Execute este exemplo para ver como `takeWhile()` e `skipWhile()` podem
dividir um `Iterable` que contém números.

<?code-excerpt "iterables/test/iterables_test.dart (take-while-long)"?>
```dartpad
void main() {
  const numbers = [1, 3, -2, 0, 4, 5];

  var numbersUntilZero = numbers.takeWhile((number) => number != 0);
  print('Numbers until 0: $numbersUntilZero');

  var numbersStartingAtZero = numbers.skipWhile((number) => number != 0);
  print('Numbers starting at 0: $numbersStartingAtZero');
}
```

Neste exemplo, `takeWhile()` retorna um `Iterable` que
contém todos os elementos antes daquele que
satisfaz o predicado.
Já `skipWhile()` retorna um `Iterable`
que contém todos os elementos depois do primeiro que
_não_ satisfaz o predicado, incluindo esse primeiro.

Depois de executar o exemplo,
altere `takeWhile()` para pegar elementos até
chegar ao primeiro número negativo.

<?code-excerpt "iterables/test/iterables_test.dart (takewhile)"?>
```dart
var numbersUntilNegative = numbers.takeWhile(
  (number) => !number.isNegative,
);
```

Observe que a condição `number.isNegative` é negada com `!`.

### Exercício: filtrando elementos de uma lista {:#exercise-filtering-elements-from-a-list}

O exercício a seguir oferece prática com o método `where()`, usando
a classe `User` do exercício anterior.

Use `where()` para implementar duas funções:

* Parte 1: implemente `filterOutUnder21()`.
  * Retorne um `Iterable` contendo todos os usuários com 21 anos ou mais.
* Parte 2: implemente `findShortNamed()`.
  * Retorne um `Iterable` contendo todos os usuários com
    nomes de tamanho 3 ou menos.

```dartpad theme="dark"
Iterable<User> filterOutUnder21(Iterable<User> users) {
  // TODO: Implement the filterOutUnder21 function.
}

Iterable<User> findShortNamed(Iterable<User> users) {
  // TODO: Implement the findShortNamed function.
}

class User {
  final String name;
  final int age;

  User(
    this.name,
    this.age,
  );
}

// The following code is used to provide feedback on your solution.
// There is no need to read or modify it.
void main() {
  final users = [
    User('Alice', 21),
    User('Bob', 17),
    User('Claire', 52),
    User('Dan', 12),
  ];

  try {
    final out = filterOutUnder21(users);
    if (out.any((user) => user.age < 21) || out.length != 2) {
      print(
        'Looks like `filterOutUnder21` is wrong, there are '
        'exactly two users with age under 21. Keep trying!',
      );
      return;
    }
  } on UnimplementedError {
    print(
      'Tried running `filterOutUnder21`, but received an error. '
      'Did you implement the function?',
    );
    return;
  } catch (e) {
    print(
      'Tried running `filterOutUnder21`, '
      'but received an exception: ${e.runtimeType}',
    );
    return;
  }

  try {
    final out = findShortNamed(users);
    if (out.any((user) => user.name.length > 3) || out.length != 2) {
      print(
        'Looks like `findShortNamed` is wrong, there are '
        'exactly two users with a three letter name. Keep trying!',
      );
      return;
    }
  } on UnimplementedError {
    print(
      'Tried running `findShortNamed`, but received an error. '
      'Did you implement the function?',
    );
    return;
  } catch (e) {
    print(
      'Tried running `findShortNamed`, '
      'but received an exception: ${e.runtimeType}',
    );
    return;
  }

  print('Success. All tests passed!');
}
```

<details>
  <summary title="Expand for a hint on the filtering elements exercise.">Dica</summary>

  Lembre-se de aproveitar o método `where` da classe `Iterable`.
  Para ajuda e exemplos usando `where`, consulte
  a [discussão anterior sobre ele](#example-using-where).

</details>

<details>
  <summary title="Expand for the solution of the filtering elements exercise.">Solução</summary>

  ```dart
  Iterable<User> filterOutUnder21(Iterable<User> users) {
    return users.where((user) => user.age >= 21);
  }
  
  Iterable<User> findShortNamed(Iterable<User> users) {
    return users.where((user) => user.name.length <= 3);
  }
  ```

</details>

:::secondary Revisão rápida
* Filtre os elementos de um `Iterable` com `where()`.
* A saída de `where()` é outro `Iterable`.
* Use `takeWhile()` e `skipWhile()` para obter elementos até ou depois
  de uma condição ser atendida.
* A saída desses métodos pode ser um `Iterable` vazio.
:::

## Mapeando {:#mapping}

Mapear `Iterables` com o método `map()` permite
aplicar uma função sobre cada um dos elementos,
substituindo cada elemento por um novo.

<?code-excerpt "iterables/test/iterables_test.dart (map-int)"?>
```dart
Iterable<int> output = numbers.map((number) => number * 10);
```

Neste exemplo, cada elemento do `Iterable` numbers é multiplicado por 10.

Você também pode usar `map()`
para transformar um elemento em um objeto diferente—por exemplo,
para converter todos os `int` em `String`,
como você vê no exemplo a seguir:

<?code-excerpt "iterables/test/iterables_test.dart (map-string)"?>
```dart
Iterable<String> output = numbers.map((number) => number.toString());
```

:::note
`map()` retorna um `Iterable` _lazy_, o que significa que a função fornecida
só é chamada quando os elementos são iterados.
:::

### Exemplo: usando map para alterar elementos {:#example-using-map-to-change-elements}

Execute este exemplo para ver como usar `map()` para
multiplicar todos os elementos de um `Iterable` por 2.
O que você acha que a saída vai ser?

<?code-excerpt "iterables/test/iterables_test.dart (numbers-by-two)"?>
```dartpad
void main() {
  var numbersByTwo = const [1, -2, 3, 42].map((number) => number * 2);
  print('Numbers: $numbersByTwo');
}
```


### Exercício: mapeando para um tipo diferente {:#exercise-mapping-to-a-different-type}

No exemplo anterior, você multiplicou os elementos de um `Iterable` por 2.
Tanto a entrada quanto a saída dessa operação eram um `Iterable` de `int`.

Neste exercício, seu código recebe um `Iterable` de `User`,
e você precisa retornar um `Iterable` que
contém strings com o nome e a idade de cada usuário.
Cada string no `Iterable` deve seguir este formato:
`'{name} is {age}'`—por exemplo, `'Alice is 21'`.

```dartpad theme="dark"
Iterable<String> getNameAndAges(Iterable<User> users) {
  // TODO: Implement the getNameAndAges function.
}

class User {
  final String name;
  final int age;

  User(
    this.name,
    this.age,
  );
}

// The following code is used to provide feedback on your solution.
// There is no need to read or modify it.
void main() {
  final users = [
    User('Alice', 21),
    User('Bob', 17),
    User('Claire', 52),
  ];

  try {
    final out = getNameAndAges(users).toList();
    if (!_listEquals(out, ['Alice is 21', 'Bob is 17', 'Claire is 52'])) {
      print(
        'Looks like `getNameAndAges` is wrong. Keep trying! '
        'The output was: $out',
      );
      return;
    }
  } on UnimplementedError {
    print(
      'Tried running `getNameAndAges`, but received an error. '
      'Did you implement the function?',
    );
    return;
  } catch (e) {
    print('Tried running the function, but received an exception: $e');
    return;
  }

  print('Success. All tests passed!');
}

bool _listEquals<T>(List<T>? a, List<T>? b) {
  if (a == null) return b == null;
  if (b == null || a.length != b.length) return false;
  for (var index = 0; index < a.length; index += 1) {
    if (a[index] != b[index]) return false;
  }
  return true;
}
```

<details>
  <summary title="Expand for a hint on the mapping elements exercise.">Dica</summary>

  Lembre-se de aproveitar o método `map` da classe `Iterable`.
  Para ajuda e exemplos usando `map`, consulte
  a [discussão anterior sobre ele](#example-using-map-to-change-elements).

  Para concatenar vários valores em uma única string, considere
  usar [interpolação de strings](/language/built-in-types#string-interpolation).

</details>

<details>
  <summary title="Expand for the solution of the mapping elements exercise.">Solução</summary>

  ```dart
  Iterable<String> getNameAndAges(Iterable<User> users) {
    return users.map((user) => '${user.name} is ${user.age}');
  }
  ```

</details>

:::secondary Revisão rápida
* `map()` aplica uma função a todos os elementos de um `Iterable`.
* A saída de `map()` é outro `Iterable`.
* A função não é avaliada até que o `Iterable` seja iterado.
:::

## Exercício: juntando tudo {:#exercise-putting-it-all-together}

Chegou a hora de praticar o que você aprendeu, em um último exercício.

Este exercício fornece a classe `EmailAddress`,
que tem um construtor que recebe uma string.
Outra função fornecida é `isValidEmailAddress()`,
que testa se um endereço de e-mail é válido.

| Construtor/função     | Assinatura de tipo                       | Descrição                                               |
|-----------------------|------------------------------------------|---------------------------------------------------------|
| EmailAddress()        | `EmailAddress(String address)`           | Cria um `EmailAddress` para o endereço especificado.    | 
| isValidEmailAddress() | `bool isValidEmailAddress(EmailAddress)` | Retorna `true` se o `EmailAddress` fornecido for válido. |

{:.table .table-striped}

Escreva o seguinte código:

Parte 1: implemente `parseEmailAddresses()`.
- Escreva a função `parseEmailAddresses()`,
  que recebe um `Iterable<String>` contendo endereços de e-mail,
  e retorna um `Iterable<EmailAddress>`.
- Use o método `map()` para mapear de `String` para `EmailAddress`.
- Crie os objetos `EmailAddress` usando
  o construtor `EmailAddress(String)`.

Parte 2: implemente `anyInvalidEmailAddress()`.
- Escreva a função `anyInvalidEmailAddress()`,
  que recebe um `Iterable<EmailAddress>` e
  retorna `true` se algum `EmailAddress` do `Iterable` não for válido.
- Use o método `any()` junto com
  a função fornecida `isValidEmailAddress()`.

Parte 3: implemente `validEmailAddresses()`.
- Escreva a função `validEmailAddresses()`,
  que recebe um `Iterable<EmailAddress>` e
  retorna outro `Iterable<EmailAddress>` contendo apenas os endereços válidos.
- Use o método `where()` para filtrar o `Iterable<EmailAddress>`.
- Use a função fornecida `isValidEmailAddress()` para avaliar se
  um `EmailAddress` é válido.

```dartpad theme="dark"
Iterable<EmailAddress> parseEmailAddresses(Iterable<String> strings) {
  // TODO: Implement the parseEmailAddresses function.
}

bool anyInvalidEmailAddress(Iterable<EmailAddress> emails) {
  // TODO: Implement the anyInvalidEmailAddress function.
}

Iterable<EmailAddress> validEmailAddresses(Iterable<EmailAddress> emails) {
  // TODO: Implement the validEmailAddresses function.
}

class EmailAddress {
  final String address;

  EmailAddress(this.address);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EmailAddress && address == other.address;

  @override
  int get hashCode => address.hashCode;

  @override
  String toString() => 'EmailAddress{address: $address}';
}

// The following code is used to provide feedback on your solution.
// There is no need to read or modify it.
void main() {
  const input = [
    'ali@gmail.com',
    'bobgmail.com',
    'cal@gmail.com',
  ];

  const correctInput = ['dash@gmail.com', 'sparky@gmail.com'];

  bool _listEquals<T>(List<T>? a, List<T>? b) {
    if (a == null) return b == null;
    if (b == null || a.length != b.length) return false;
    for (var index = 0; index < a.length; index += 1) {
      if (a[index] != b[index]) return false;
    }
    return true;
  }

  final Iterable<EmailAddress> emails;
  final Iterable<EmailAddress> correctEmails;
  try {
    emails = parseEmailAddresses(input);
    correctEmails = parseEmailAddresses(correctInput);
    if (emails.isEmpty) {
      print(
        'Tried running `parseEmailAddresses`, but received an empty list.',
      );
      return;
    }
    if (!_listEquals(emails.toList(), [
      EmailAddress('ali@gmail.com'),
      EmailAddress('bobgmail.com'),
      EmailAddress('cal@gmail.com'),
    ])) {
      print('Looks like `parseEmailAddresses` is wrong. Keep trying!');
      return;
    }
  } on UnimplementedError {
    print(
      'Tried running `parseEmailAddresses`, but received an error. '
      'Did you implement the function?',
    );
    return;
  } catch (e) {
    print(
      'Tried running `parseEmailAddresses`, '
      'but received an exception: $e',
    );
    return;
  }

  try {
    final out = anyInvalidEmailAddress(emails);
    if (!out) {
      print(
        'Looks like `anyInvalidEmailAddress` is wrong. Keep trying! '
        'The result should be false with at least one invalid address.',
      );
      return;
    }
    final falseOut = anyInvalidEmailAddress(correctEmails);
    if (falseOut) {
      print(
        'Looks like `anyInvalidEmailAddress` is wrong. Keep trying! '
        'The result should be false with all valid addresses.',
      );
      return;
    }
  } on UnimplementedError {
    print(
      'Tried running `anyInvalidEmailAddress`, but received an error. '
      'Did you implement the function?',
    );
    return;
  } catch (e) {
    print(
        'Tried running `anyInvalidEmailAddress`, but received an exception: $e');
    return;
  }

  try {
    final valid = validEmailAddresses(emails);
    if (emails.isEmpty) {
      print('Tried running `validEmailAddresses`, but received an empty list.');
      return;
    }
    if (!_listEquals(valid.toList(), [
      EmailAddress('ali@gmail.com'),
      EmailAddress('cal@gmail.com'),
    ])) {
      print('Looks like `validEmailAddresses` is wrong. Keep trying!');
      return;
    }
  } on UnimplementedError {
    print(
      'Tried running `validEmailAddresses`, but received an error. '
      'Did you implement the function?',
    );
    return;
  } catch (e) {
    print(
      'Tried running the `validEmailAddresses`, '
      'but received an exception: $e',
    );
    return;
  }

  print('Success. All tests passed!');
}

bool isValidEmailAddress(EmailAddress email) {
  return email.address.contains('@');
}
```

<details>
  <summary title="Expand for the solution of the 'Putting it all together' exercise.">Solução</summary>

  ```dart
  Iterable<EmailAddress> parseEmailAddresses(Iterable<String> strings) {
    return strings.map((s) => EmailAddress(s));
  }
  
  bool anyInvalidEmailAddress(Iterable<EmailAddress> emails) {
    return emails.any((email) => !isValidEmailAddress(email));
  }
  
  Iterable<EmailAddress> validEmailAddresses(Iterable<EmailAddress> emails) {
    return emails.where((email) => isValidEmailAddress(email));
  }
  ```

</details>

## O que vem a seguir {:#whats-next}

Parabéns, você concluiu o tutorial!
Se quiser aprender mais,
aqui estão algumas sugestões de próximos passos:

* Brinque com o [DartPad.]({{site.dartpad}})
* Leia a [referência da API de Iterable][iterable class]
  para conhecer métodos que este tutorial não cobre.

[hashmap class]: {{site.dart-api}}/dart-collection/HashMap-class.html
[iterable class]: {{site.dart-api}}/dart-core/Iterable-class.html
[iterator class]: {{site.dart-api}}/dart-core/Iterator-class.html
[list class]: {{site.dart-api}}/dart-core/List-class.html
[map class]: {{site.dart-api}}/dart-core/Map-class.html
[set class]: {{site.dart-api}}/dart-core/Set-class.html
[StateError class]: {{site.dart-api}}/dart-core/StateError-class.html
[String class]: {{site.dart-api}}/dart-core/String-class.html
