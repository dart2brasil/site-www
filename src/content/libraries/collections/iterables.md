---
ia-translate: true
title: Coleções Iteráveis
description: >-
  Um guia interativo para usar objetos `Iterable`, como listas e conjuntos.
js: [{url: '/assets/js/inject_dartpad.js', defer: true}]
---
<?code-excerpt replace="/ *\/\/\s+ignore_for_file:[^\n]+\n//g; /(^|\n) *\/\/\s+ignore:[^\n]+\n/$1/g; /(\n[^\n]+) *\/\/\s+ignore:[^\n]+\n/$1\n/g"?>
<?code-excerpt plaster="none"?>

Este tutorial ensina como usar coleções
que implementam a classe
[Iterable][iterable class] — por exemplo,
[List][list class] e [Set][set class].
`Iterables` são blocos de construção
básicos para todos os tipos
de aplicações Dart, e você provavelmente já os está usando,
mesmo sem perceber. Este tutorial ajuda você a tirar o máximo proveito deles.

Usando os editores DartPad incorporados,
você pode testar seu conhecimento executando
exemplos de código e concluindo os exercícios.

Para tirar o máximo proveito deste tutorial, você deve ter
conhecimento básico da [sintaxe Dart](/language).

Este tutorial abrange o seguinte material:

* Como ler elementos de um `Iterable`.
* Como verificar se os elementos de um `Iterable` satisfazem uma condição.
* Como filtrar o conteúdo de um `Iterable`.
* Como mapear o conteúdo de um `Iterable` para um valor diferente.

Tempo estimado para completar este tutorial: 60 minutos.

:::note
Esta página usa DartPads incorporados para exibir exemplos e exercícios.
{% render 'dartpads-embedded-troubleshooting.md' %}
:::

Os exercícios neste tutorial têm trechos de código parcialmente completos.
Você pode usar o DartPad para testar seu conhecimento, completando o código e
clicando no botão **Run** (Executar).
**Não edite o código de teste na função `main` ou abaixo**.

Se precisar de ajuda, expanda o dropdown **Hint** (Dica) ou **Solution** (Solução)
após cada exercício.

## O que são coleções? {:#what-are-collections}

Uma coleção é um objeto que representa um grupo de
objetos, que são chamados de _elementos_.
`Iterables` são um tipo de coleção.

Uma coleção pode estar vazia ou pode conter muitos elementos.
Dependendo do propósito, as coleções
podem ter estruturas e implementações diferentes.
Estes são alguns dos tipos de coleção mais comuns:

* [List:][list class] Usado para ler elementos por seus índices.
* [Set:][set class] Usado para conter elementos que podem ocorrer apenas uma vez.
* [Map:][map class] Usado para ler elementos usando uma chave.


## O que é um Iterable? {:#what-is-an-iterable}

Um `Iterable` é uma coleção de elementos que podem ser acessados sequencialmente.

Em Dart, um `Iterable` é uma classe abstrata,
o que significa que você não pode instanciá-la diretamente.
No entanto, você pode criar um novo `Iterable` criando uma nova `List` ou `Set`.

Tanto `List` quanto `Set` são `Iterable`,
portanto, eles têm os mesmos métodos e propriedades que a classe `Iterable`.

Um `Map` usa uma estrutura de dados diferente internamente,
dependendo de sua implementação.
Por exemplo, [HashMap][hashmap class] usa uma tabela hash na qual os elementos
(também chamados de _valores_) são obtidos usando uma chave.
Elementos de um `Map` também podem ser lidos como objetos `Iterable`
usando a propriedade `entries` ou `values` do mapa.

Este exemplo mostra uma `List` de `int` (inteiro),
que também é um `Iterable` de `int`:

<?code-excerpt "iterables/test/iterables_test.dart (iterable)"?>
```dart
Iterable<int> iterable = [1, 2, 3];
```

A diferença com uma `List` é que com o `Iterable`,
você não pode garantir que a leitura de elementos por índice seja eficiente.
`Iterable`, ao contrário de `List`, não tem o operador `[]`.

Por exemplo, considere o seguinte código, que é **inválido**:

<?code-excerpt "iterables/test/iterables_test.dart (iterable-elementat)" replace="/\.elementAt\(1\)/[![1]!]/g"?>
```dart tag=bad
Iterable<int> iterable = [1, 2, 3];
int value = iterable[![1]!];
```

Se você ler elementos com `[]`,
o compilador informa que o operador `'[]'`
não está definido para a classe `Iterable`,
o que significa que você não pode usar `[index]` neste caso.

Em vez disso, você pode ler elementos com `elementAt()`,
que percorre os elementos do iterável até
atingir essa posição.

<?code-excerpt "iterables/test/iterables_test.dart (iterable-elementat)"?>
```dart
Iterable<int> iterable = [1, 2, 3];
int value = iterable.elementAt(1);
```

Continue para a próxima seção para saber mais sobre
como acessar elementos de um `Iterable`.

## Lendo elementos {:#reading-elements}

Você pode ler os elementos de um iterável sequencialmente, usando
um loop `for-in`.

### Exemplo: Usando um loop for-in {:#example-using-a-for-in-loop}

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
Nos bastidores, o loop `for-in` usa um _iterador_.
Você raramente vê a [API do Iterator][iterator class] usada diretamente, no entanto,
porque `for-in` é mais fácil de ler e entender,
e é menos propenso a erros.
:::

:::secondary Termos-chave
* **Iterable**: A classe [Iterable][iterable class] do Dart.
* **Iterator** (Iterador): Um objeto usado por `for-in` para ler elementos de um
  objeto `Iterable`.
* **Loop `for-in`**: Uma maneira fácil de ler sequencialmente elementos de
  um `Iterable`.
:::

### Exemplo: Usando first e last {:#example-using-first-and-last}

Em alguns casos, você deseja acessar apenas o primeiro ou o último elemento
de um `Iterable`.

Com a classe `Iterable`, você não pode acessar os elementos diretamente,
então você não pode chamar `iterable[0]` para acessar o primeiro elemento.
Em vez disso, você pode usar `first`,
que obtém o primeiro elemento.

Além disso, com a classe `Iterable`,
você não pode usar o operador `[]` para acessar o último elemento,
mas você pode usar a propriedade `last`.

:::warning
Como acessar o último elemento de um `Iterable` requer
percorrer todos os outros elementos,
**`last` pode ser lento.**
Usar `first` ou `last` em um **`Iterable` vazio**
resulta em um [StateError][StateError class].
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
obter o primeiro e o último elemento de um `Iterable`.
Também é possível encontrar o primeiro elemento que satisfaz uma condição.
A próxima seção mostra como fazer isso usando um método chamado `firstWhere()`.

### Exemplo: Usando firstWhere() {:#example-using-firstwhere}

Você já viu que pode acessar os elementos de um `Iterable` sequencialmente,
e você pode facilmente obter o primeiro ou o último elemento.

Agora, você aprenderá como usar `firstWhere()` para encontrar o primeiro elemento que
satisfaz certas condições.
Este método exige que você passe um _predicado_,
que é uma função que retorna verdadeiro se
a entrada satisfaz uma determinada condição.

<?code-excerpt "iterables/test/iterables_test.dart (firstwhere)"?>
```dart
String element = iterable.firstWhere((element) => element.length > 5);
```

Por exemplo, se você quiser encontrar a primeira `String` que tenha
mais de 5 caracteres,
você deve passar um predicado que retorne verdadeiro quando
o tamanho do elemento for maior que 5.

Execute o exemplo a seguir para ver como `firstWhere()` funciona.
Você acha que todas as funções darão o mesmo resultado?

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

Neste exemplo, você pode ver três maneiras diferentes de escrever um predicado:

* **Como uma expressão:**
  O código de teste tem uma linha que usa a sintaxe de seta (`=>`).
* **Como um bloco:**
  O código de teste tem várias linhas entre colchetes e uma declaração de retorno.
* **Como uma função:**
  O código de teste está em uma função externa que é passada para
  o método `firstWhere()` como um parâmetro.

Não há maneira certa ou errada.
Use a maneira que funciona melhor para você,
e que torna seu código mais fácil de ler e entender.

O exemplo final chama `firstWhere()` com
o parâmetro nomeado opcional `orElse`,
que fornece uma alternativa quando um elemento não é encontrado.
Nesse caso, o texto `'None!'` é retornado porque
nenhum elemento satisfaz a condição fornecida.

:::note
Se nenhum elemento satisfizer o predicado de teste e
o parâmetro `orElse` não for fornecido,
então `firstWhere()` lança um [StateError][StateError class].
:::

:::secondary Revisão rápida
* Os elementos de um `Iterable` devem ser acessados sequencialmente.
* A maneira mais fácil de iterar por todos os elementos é
  usando um loop `for-in`.
* Você pode usar os getters `first` e `last` para obter
  o primeiro e o último elementos.
* Você também pode encontrar o primeiro elemento que
  satisfaz uma condição com `firstWhere()`.
* Você pode escrever predicados de teste como expressões, blocos ou funções.

  **Termos-chave:**
* **Predicado:**
  Uma função que retorna `true` quando uma determinada condição é satisfeita.
:::

### Exercício: Pratique a escrita de um predicado de teste {:#exercise-practice-writing-a-test-predicate}

O exercício a seguir é um teste de unidade com falha que
contém um trecho de código parcialmente completo.
Sua tarefa é completar o exercício escrevendo código para fazer os testes passarem.
Você não precisa implementar `main()`.

Este exercício introduz `singleWhere()`.
Este método funciona de forma semelhante a `firstWhere()`,
mas, neste caso, ele espera que apenas um elemento do `Iterable`
satisfaça o predicado.
Se mais de um ou nenhum elemento no `Iterable`
satisfizer a condição do predicado,
então o método lançará uma exceção [StateError][StateError class].

:::warning
`singleWhere()` percorre todo o `Iterable` até o último elemento,
o que pode causar problemas se o `Iterable` for infinito ou
contiver uma grande coleção de elementos.
:::

Seu objetivo é implementar o predicado para `singleWhere()` que
satisfaz as seguintes condições:

* O elemento contém o caractere `'a'`.
* O elemento começa com o caractere `'M'`.

Todos os elementos nos dados de teste são [strings][String class];
você pode verificar a documentação da classe para obter ajuda.

```dartpad theme="dark"
// Implemente o predicado de singleWhere
// com as seguintes condições
// * O elemento contém o caractere `'a'`
// * O elemento começa com o caractere `'M'`
String singleWhere(Iterable<String> items) {
  return items.singleWhere(TODO('Implemente o predicado delineado.'));
}

// O código a seguir é usado para fornecer feedback sobre sua solução.
// Não há necessidade de ler ou modificar.
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
      print('Sucesso. Todos os testes passaram!');
    } else {
      print(
        'Tentei chamar singleWhere, mas recebi $str em vez de '
        'o valor esperado \'Mozzarella\'',
      );
    }
  } on StateError catch (stateError) {
    print(
      'Tentei chamar singleWhere, mas recebi um StateError: ${stateError.message}. '
      'singleWhere falhará se 0 ou muitos elementos corresponderem ao predicado.',
    );
  } on UnimplementedError {
    print(
      'Tentei executar `singleWhere`, mas recebi um erro. '
      'Você implementou a função?',
    );
  } catch (e) {
    print('Tentei chamar singleWhere, mas recebi uma exceção: $e');
  }
}
```

<details>
  <summary title="Expandir para uma dica sobre o exercício do predicado.">Dica</summary>

  Sua solução pode fazer uso dos métodos `contains` e `startsWith`
  da classe `String`.

</details>

<details>
  <summary title="Expandir para a solução do exercício do predicado.">Solução</summary>

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

No entanto, você pode realizar o mesmo usando o método `every()`:

<?code-excerpt "iterables/test/iterables_test.dart (every-good)"?>
```dart
return items.every((item) => item.length >= 5);
```

Usar o método `every()` resulta em um código mais
legível, compacto e menos propenso a erros.

### Exemplo: Usando any() e every() {:#example-using-any-and-every}

A classe `Iterable` fornece dois métodos que
você pode usar para verificar condições:

* `any()`: Retorna verdadeiro se pelo menos um elemento satisfizer a condição.
* `every()`: Retorna verdadeiro se todos os elementos satisfizerem a condição.

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
têm um comprimento igual ou maior que 5.

Depois de executar o código, tente alterar o predicado de `any()` para
que ele retorne falso:

<?code-excerpt "iterables/test/iterables_test.dart (any-false)"?>
```dart
if (items.any((item) => item.contains('Z'))) {
  print('At least one item contains "Z"');
} else {
  print('No item contains "Z"');
}
```

Você também pode usar `any()` para verificar se nenhum elemento de um `Iterable`
satisfaz uma determinada condição.


### Exercício: Verifique se um Iterable satisfaz uma condição {:#exercise-verify-that-an-iterable-satisfies-a-condition}

O exercício a seguir fornece prática usando os
métodos `any()` e `every()`, descritos no exemplo anterior.
Neste caso, você trabalha com um grupo de usuários,
representado por objetos `User` que têm o campo membro `age` (idade).

Use `any()` e `every()` para implementar duas funções:

* Parte 1: Implemente `anyUserUnder18()`.
  * Retorne `true` se pelo menos um usuário tiver 17 anos ou menos.
* Parte 2: Implemente `everyUserOver13()`.
  * Retorne `true` se todos os usuários tiverem 14 anos ou mais.

```dartpad
bool anyUserUnder18(Iterable<User> users) {
  // TODO: Implemente a função anyUserUnder18.
}

bool everyUserOver13(Iterable<User> users) {
  // TODO: Implemente a função everyUserOver13.
}

class User {
  final String name;
  final int age;

  User(
    this.name,
    this.age,
  );
}

// O código a seguir é usado para fornecer feedback sobre sua solução.
// Não há necessidade de ler ou modificar.
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
      print('Parece que `anyUserUnder18` está errado. Continue tentando!');
      return;
    }
  } on UnimplementedError {
    print(
      'Tentei executar `anyUserUnder18`, mas recebi um erro. '
      'Você implementou a função?',
    );
    return;
  } catch (e) {
    print('Tentei executar `anyUserUnder18`, mas recebi uma exceção: $e');
    return;
  }

  try {
    // com apenas um usuário com mais de 18 anos, deve ser falso
    final out = anyUserUnder18([User('Alice', 21)]);
    if (out) {
      print(
          'Parece que `anyUserUnder18` está errado. E se todos os usuários tiverem mais de 18 anos?');
      return;
    }
  } on UnimplementedError {
    print(
      'Tentei executar `anyUserUnder18`, mas recebi um erro. '
      'Você implementou a função?',
    );
    return;
  } catch (e) {
    print(
      'Tentei executar `anyUserUnder18([User("Alice", 21)])`, '
      'mas recebi uma exceção: $e',
    );
    return;
  }

  try {
    final out = everyUserOver13(users);
    if (!out) {
      print(
        'Parece que `everyUserOver13` está errado. '
        'Não há usuários menores de 13 anos!',
      );
      return;
    }
  } on UnimplementedError {
    print(
      'Tentei executar `everyUserOver13`, mas recebi um erro. '
      'Você implementou a função?',
    );
    return;
  } catch (e) {
    print(
      'Tentei executar `everyUserOver13`, '
      'mas recebi uma exceção: $e',
    );
    return;
  }

  try {
    final out = everyUserOver13([User('Dan', 12)]);
    if (out) {
      print(
        'Parece que `everyUserOver13` está errado. '
        'Há pelo menos um usuário com menos de 13 anos!',
      );
      return;
    }
  } on UnimplementedError {
    print(
      'Tentei executar `everyUserOver13`, mas recebi um erro. '
      'Você implementou a função?',
    );
    return;
  } catch (e) {
    print(
      'Tentei executar `everyUserOver13([User(\'Dan\', 12)])`, '
      'mas recebi uma exceção: $e',
    );
    return;
  }

  print('Sucesso. Todos os testes passaram!');
}
```

<details>
  <summary title="Expandir para uma dica sobre o exercício de filtragem condicional.">Dica</summary>

  Lembre-se de usar os métodos `any` e `every` da classe `Iterable`.
  Para obter ajuda e exemplos sobre o uso desses métodos, consulte
  a [discussão anterior sobre eles](#example-using-any-and-every).

</details>

<details>
  <summary title="Expandir para a solução do exercício de filtragem condicional.">Solução</summary>

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
  existem maneiras melhores de fazer isso.
* O método `any()` permite verificar se
  algum elemento satisfaz uma condição.
* O método `every()` permite verificar se
  todos os elementos satisfazem uma condição.
:::

## Filtrando {:#filtering}

As seções anteriores abordam métodos como `firstWhere()` ou
`singleWhere()` que podem ajudá-lo a encontrar um elemento que
satisfaz um determinado predicado.

Mas e se você quiser encontrar todos os elementos que
satisfazem uma determinada condição?
Você pode conseguir isso usando o método `where()`.

<?code-excerpt "iterables/test/iterables_test.dart (where)"?>
```dart
var evenNumbers = numbers.where((number) => number.isEven);
```

Neste exemplo,
`numbers` contém um `Iterable` com vários valores `int`, e
`where()` encontra todos os números que são pares.

A saída de `where()` é outro `Iterable`,
e você pode usá-lo como tal para iterar sobre ele ou
aplicar outros métodos `Iterable`.
No próximo exemplo, a saída de `where()`
é usada diretamente dentro do loop `for-in`.

<?code-excerpt "iterables/test/iterables_test.dart (where-for)"?>
```dart
var evenNumbers = numbers.where((number) => number.isEven);
for (final number in evenNumbers) {
  print('$number is even');
}
```

### Exemplo: Usando where() {:#example-using-where}

Execute este exemplo para ver como `where()` pode ser usado junto com outros
métodos como `any()`.

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

Neste exemplo, `where()` é usado para encontrar todos os números que são pares, então
`any()` é usado para verificar se os resultados contêm um número negativo.

Mais adiante no exemplo, `where()` é usado novamente para
encontrar todos os números maiores que 1000.
Como não há nenhum, o resultado é um `Iterable` vazio.

:::note
Se nenhum elemento satisfizer o predicado em `where()`,
então o método retorna um `Iterable` vazio.
Ao contrário de `singleWhere()` ou `firstWhere()`,
`where()` não lança uma exceção [StateError][StateError class].
:::

### Exemplo: Usando takeWhile {:#example-using-takewhile}

Os métodos `takeWhile()` e `skipWhile()` também podem
ajudá-lo a filtrar elementos de um `Iterable`.

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
Por outro lado, `skipWhile()` retorna um `Iterable`
que contém todos os elementos após e incluindo o primeiro
que _não_ satisfaz o predicado.

Depois de executar o exemplo,
altere `takeWhile()` para pegar elementos até
atingir o primeiro número negativo.

<?code-excerpt "iterables/test/iterables_test.dart (takewhile)"?>
```dart
var numbersUntilNegative =
    numbers.takeWhile((number) => !number.isNegative);
```

Observe que a condição `number.isNegative` é negada com `!`.

### Exercício: Filtrando elementos de uma lista {:#exercise-filtering-elements-from-a-list}

O exercício a seguir fornece prática usando o método `where()` com
a classe `User` do exercício anterior.

Use `where()` para implementar duas funções:

* Parte 1: Implemente `filterOutUnder21()`.
  * Retorne um `Iterable` contendo todos os usuários com 21 anos ou mais.
* Parte 2: Implemente `findShortNamed()`.
  * Retorne um `Iterable` contendo todos os usuários com
    nomes de comprimento 3 ou menos.

```dartpad theme="dark"
Iterable<User> filterOutUnder21(Iterable<User> users) {
  // TODO: Implemente a função filterOutUnder21.
}

Iterable<User> findShortNamed(Iterable<User> users) {
  // TODO: Implemente a função findShortNamed.
}

class User {
  final String name;
  final int age;

  User(
    this.name,
    this.age,
  );
}

// O código a seguir é usado para fornecer feedback sobre sua solução.
// Não há necessidade de ler ou modificar.
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
        'Parece que `filterOutUnder21` está errado, existem '
        'exatamente dois usuários com idade inferior a 21. Continue tentando!',
      );
      return;
    }
  } on UnimplementedError {
    print(
      'Tentei executar `filterOutUnder21`, mas recebi um erro. '
      'Você implementou a função?',
    );
    return;
  } catch (e) {
    print(
      'Tentei executar `filterOutUnder21`, '
      'mas recebi uma exceção: ${e.runtimeType}',
    );
    return;
  }

  try {
    final out = findShortNamed(users);
    if (out.any((user) => user.name.length > 3) || out.length != 2) {
      print(
        'Parece que `findShortNamed` está errado, existem '
        'exatamente dois usuários com um nome de três letras. Continue tentando!',
      );
      return;
    }
  } on UnimplementedError {
    print(
      'Tentei executar `findShortNamed`, mas recebi um erro. '
      'Você implementou a função?',
    );
    return;
  } catch (e) {
    print(
      'Tentei executar `findShortNamed`, '
      'mas recebi uma exceção: ${e.runtimeType}',
    );
    return;
  }

  print('Sucesso. Todos os testes passaram!');
}
```

<details>
  <summary title="Expandir para uma dica sobre o exercício de filtragem de elementos.">Dica</summary>

  Lembre-se de usar o método `where` da classe `Iterable`.
  Para obter ajuda e exemplos sobre o uso de `where`, consulte
  a [discussão anterior sobre ele](#example-using-where).

</details>

<details>
  <summary title="Expandir para a solução do exercício de filtragem de elementos.">Solução</summary>

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
* Use `takeWhile()` e `skipWhile()` para obter elementos até ou depois que
  uma condição for atendida.
* A saída desses métodos pode ser um `Iterable` vazio.
:::

## Mapeamento {:#mapping}

Mapear `Iterables` com o método `map()` permite que você
aplique uma função sobre cada um dos elementos,
substituindo cada elemento por um novo.

<?code-excerpt "iterables/test/iterables_test.dart (map-int)"?>
```dart
Iterable<int> output = numbers.map((number) => number * 10);
```

Neste exemplo, cada elemento do `Iterable` numbers é multiplicado por 10.

Você também pode usar `map()`
para transformar um elemento em um objeto diferente — por exemplo,
para converter todos os `int` em `String`,
como você pode ver no exemplo a seguir:

<?code-excerpt "iterables/test/iterables_test.dart (map-string)"?>
```dart
Iterable<String> output = numbers.map((number) => number.toString());
```

:::note
`map()` retorna um `Iterable` _preguiçoso_, o que significa que a função fornecida
é chamada apenas quando os elementos são iterados.
:::

### Exemplo: Usando map para alterar elementos {:#example-using-map-to-change-elements}

Execute este exemplo para ver como usar `map()` para
multiplicar todos os elementos de um `Iterable` por 2.
O que você acha que será a saída?

<?code-excerpt "iterables/test/iterables_test.dart (numbers-by-two)"?>
```dartpad
void main() {
  var numbersByTwo = const [1, -2, 3, 42].map((number) => number * 2);
  print('Numbers: $numbersByTwo');
}
```


### Exercício: Mapeando para um tipo diferente {:#exercise-mapping-to-a-different-type}

No exemplo anterior, você multiplicou os elementos de um `Iterable` por 2.
Tanto a entrada quanto a saída dessa operação eram um `Iterable` de `int`.

Neste exercício, seu código recebe um `Iterable` de `User` (Usuário),
e você precisa retornar um `Iterable` que
contém strings contendo o nome e a idade de cada usuário.

Cada string no `Iterable` deve seguir este formato:
`'{nome} tem {idade}'`—por exemplo `'Alice tem 21'`.

```dartpad theme="dark"
Iterable<String> getNameAndAges(Iterable<User> users) {
  // TODO: Implementar a função getNameAndAges.
}

class User {
  final String name;
  final int age;

  User(
    this.name,
    this.age,
  );
}

// O código a seguir é usado para fornecer feedback sobre sua solução.
// Não há necessidade de lê-lo ou modificá-lo.
void main() {
  final users = [
    User('Alice', 21),
    User('Bob', 17),
    User('Claire', 52),
  ];

  try {
    final out = getNameAndAges(users).toList();
    if (!_listEquals(out, ['Alice tem 21', 'Bob tem 17', 'Claire tem 52'])) {
      print(
        'Parece que `getNameAndAges` está errado. Continue tentando! '
        'A saída foi: $out',
      );
      return;
    }
  } on UnimplementedError {
    print(
      'Tentou executar `getNameAndAges`, mas recebeu um erro. '
      'Você implementou a função?',
    );
    return;
  } catch (e) {
    print('Tentou executar a função, mas recebeu uma exceção: $e');
    return;
  }

  print('Sucesso. Todos os testes passaram!');
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
  <summary title="Expandir para uma dica sobre o exercício de mapeamento de elementos.">Dica</summary>

  Lembre-se de aproveitar o método `map` da classe `Iterable`.
  Para obter ajuda e exemplos usando `map`, consulte
  a [discussão anterior sobre isso](#example-using-map-to-change-elements).

  Para concatenar vários valores em uma única string, considere
  usar [interpolação de string](/language/built-in-types#string-interpolation).

</details>

<details>
  <summary title="Expandir para a solução do exercício de mapeamento de elementos.">Solução</summary>

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

## Exercício: Juntando tudo {:#exercise-putting-it-all-together}

É hora de praticar o que você aprendeu, em um exercício final.

Este exercício fornece a classe `EmailAddress` (EndereçoDeEmail),
que tem um construtor que recebe uma string.
Outra função fornecida é `isValidEmailAddress()` (éEndereçoDeEmailVálido),
que testa se um endereço de e-mail é válido.

| Construtor/função   | Assinatura do tipo                             | Descrição                                                    |
|----------------------|------------------------------------------------|-------------------------------------------------------------|
| EmailAddress()       | `EmailAddress(String address)`                | Cria um `EmailAddress` para o endereço especificado.        |
| isValidEmailAddress()| `bool isValidEmailAddress(EmailAddress)`       | Retorna `true` se o `EmailAddress` fornecido for válido.    |

{:.table .table-striped}

Escreva o seguinte código:

Parte 1: Implemente `parseEmailAddresses()`.
- Escreva a função `parseEmailAddresses()`,
  que recebe um `Iterable<String>` contendo endereços de e-mail,
  e retorna um `Iterable<EmailAddress>`.
- Use o método `map()` para mapear de uma `String` para `EmailAddress`.
- Crie os objetos `EmailAddress` usando
  o construtor `EmailAddress(String)`.

Parte 2: Implemente `anyInvalidEmailAddress()`.
- Escreva a função `anyInvalidEmailAddress()`,
  que recebe um `Iterable<EmailAddress>` e
  retorna `true` se algum `EmailAddress` no `Iterable` não for válido.
- Use o método `any()` junto com
  a função fornecida `isValidEmailAddress()`.

Parte 3: Implemente `validEmailAddresses()`.
- Escreva a função `validEmailAddresses()`,
  que recebe um `Iterable<EmailAddress>` e
  retorna outro `Iterable<EmailAddress>` contendo apenas endereços válidos.
- Use o método `where()` para filtrar o `Iterable<EmailAddress>`.
- Use a função fornecida `isValidEmailAddress()` para avaliar se
  um `EmailAddress` é válido.

```dartpad theme="dark"
Iterable<EmailAddress> parseEmailAddresses(Iterable<String> strings) {
  // TODO: Implementar a função parseEmailAddresses.
}

bool anyInvalidEmailAddress(Iterable<EmailAddress> emails) {
  // TODO: Implementar a função anyInvalidEmailAddress.
}

Iterable<EmailAddress> validEmailAddresses(Iterable<EmailAddress> emails) {
  // TODO: Implementar a função validEmailAddresses.
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

// O código a seguir é usado para fornecer feedback sobre sua solução.
// Não há necessidade de lê-lo ou modificá-lo.
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
        'Tentou executar `parseEmailAddresses`, mas recebeu uma lista vazia.',
      );
      return;
    }
    if (!_listEquals(emails.toList(), [
      EmailAddress('ali@gmail.com'),
      EmailAddress('bobgmail.com'),
      EmailAddress('cal@gmail.com'),
    ])) {
      print('Parece que `parseEmailAddresses` está errado. Continue tentando!');
      return;
    }
  } on UnimplementedError {
    print(
      'Tentou executar `parseEmailAddresses`, mas recebeu um erro. '
      'Você implementou a função?',
    );
    return;
  } catch (e) {
    print(
      'Tentou executar `parseEmailAddresses`, '
      'mas recebeu uma exceção: $e',
    );
    return;
  }

  try {
    final out = anyInvalidEmailAddress(emails);
    if (!out) {
      print(
        'Parece que `anyInvalidEmailAddress` está errado. Continue tentando! '
        'O resultado deve ser falso com pelo menos um endereço inválido.',
      );
      return;
    }
    final falseOut = anyInvalidEmailAddress(correctEmails);
    if (falseOut) {
      print(
        'Parece que `anyInvalidEmailAddress` está errado. Continue tentando! '
        'O resultado deve ser falso com todos os endereços válidos.',
      );
      return;
    }
  } on UnimplementedError {
    print(
      'Tentou executar `anyInvalidEmailAddress`, mas recebeu um erro. '
      'Você implementou a função?',
    );
    return;
  } catch (e) {
    print(
        'Tentou executar `anyInvalidEmailAddress`, mas recebeu uma exceção: $e');
    return;
  }

  try {
    final valid = validEmailAddresses(emails);
    if (emails.isEmpty) {
      print('Tentou executar `validEmailAddresses`, mas recebeu uma lista vazia.');
      return;
    }
    if (!_listEquals(valid.toList(), [
      EmailAddress('ali@gmail.com'),
      EmailAddress('cal@gmail.com'),
    ])) {
      print('Parece que `validEmailAddresses` está errado. Continue tentando!');
      return;
    }
  } on UnimplementedError {
    print(
      'Tentou executar `validEmailAddresses`, mas recebeu um erro. '
      'Você implementou a função?',
    );
    return;
  } catch (e) {
    print(
      'Tentou executar a `validEmailAddresses`, '
      'mas recebeu uma exceção: $e',
    );
    return;
  }

  print('Sucesso. Todos os testes passaram!');
}

bool isValidEmailAddress(EmailAddress email) {
  return email.address.contains('@');
}
```

<details>
  <summary title="Expandir para a solução do exercício 'Juntando tudo'.">Solução</summary>

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

## Próximos passos {:#what-s-next}

Parabéns, você terminou o tutorial!
Se você quiser aprender mais,
aqui estão algumas sugestões de para onde ir em seguida:

* Brinque com o [DartPad.]({{site.dartpad}})
* Experimente outro [tutorial](/tutorials).
* Leia a [referência da API Iterable][iterable class]
  para aprender sobre métodos que este tutorial não aborda.

[hashmap class]: {{site.dart-api}}/dart-collection/HashMap-class.html
[iterable class]: {{site.dart-api}}/dart-core/Iterable-class.html
[iterator class]: {{site.dart-api}}/dart-core/Iterator-class.html
[list class]: {{site.dart-api}}/dart-core/List-class.html
[map class]: {{site.dart-api}}/dart-core/Map-class.html
[set class]: {{site.dart-api}}/dart-core/Set-class.html
[StateError class]: {{site.dart-api}}/dart-core/StateError-class.html
[String class]: {{site.dart-api}}/dart-core/String-class.html
