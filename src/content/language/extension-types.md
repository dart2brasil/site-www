---
ia-translate: true
title: Extension types
description: Aprenda como escrever uma interface apenas estática para um tipo existente.
prevpage:
  url: /language/extension-methods
  title: Extension methods
nextpage:
  url: /language/callable-objects
  title: Callable objects
---

Um extension type é uma abstração em tempo de compilação que "envolve"
um tipo existente com uma interface diferente, apenas estática.
Eles são um componente importante da [interoperabilidade estática JS][static JS interop] porque
podem facilmente modificar a interface de um tipo existente
(crucial para qualquer tipo de interoperabilidade)
sem incorrer no custo de um wrapper real.

Extension types impõem disciplina no conjunto de operações (ou interface)
disponíveis para objetos de um tipo subjacente,
chamado de *tipo de representação*.
Ao definir a interface de um extension type,
você pode escolher reutilizar alguns membros do tipo de representação,
omitir outros, substituir outros e adicionar nova funcionalidade.

O exemplo a seguir envolve o tipo `int` para criar um extension type
que permite apenas operações que fazem sentido para números de ID:

```dart
extension type IdNumber(int id) {
  // Wraps the 'int' type's '<' operator:
  operator <(IdNumber other) => id < other.id;
  // Doesn't declare the '+' operator, for example,
  // because addition does not make sense for ID numbers.
}

void main() {
  // Without the discipline of an extension type,
  // 'int' exposes ID numbers to unsafe operations:
  int myUnsafeId = 42424242;
  myUnsafeId = myUnsafeId + 10; // This works, but shouldn't be allowed for IDs.

  var safeId = IdNumber(42424242);
  safeId + 10; // Compile-time error: No '+' operator.
  myUnsafeId = safeId; // Compile-time error: Wrong type.
  myUnsafeId = safeId as int; // OK: Run-time cast to representation type.
  safeId < IdNumber(42424241); // OK: Uses wrapped '<' operator.
}
```

:::note
Extension types servem ao mesmo propósito que **classes wrapper**,
mas não requerem a criação de um objeto extra em tempo de execução,
o que pode ficar caro quando você precisa envolver muitos objetos.
Como extension types são apenas estáticos e compilados em tempo de execução,
eles são essencialmente de custo zero.

[**Extension methods**][ext] (também conhecidos apenas como "extensions")
são uma abstração estática similar aos extension types.
No entanto, um extension method adiciona funcionalidade *diretamente*
a todas as instâncias de seu tipo subjacente.
Extension types são diferentes;
a interface de um extension type *apenas* se aplica a expressões
cujo tipo estático é esse extension type.
Elas são distintas da interface de seu tipo subjacente por padrão.
:::

[static JS interop]: /go/next-gen-js-interop
[ext]: /language/extension-methods

## Sintaxe

### Declaração

Defina um novo extension type com a declaração `extension type` e um nome,
seguido pela *declaração do tipo de representação* entre parênteses:

```dart
extension type E(int i) {
  // Define set of operations.
}
```

A declaração do tipo de representação `(int i)` especifica que
o tipo subjacente do extension type `E` é `int`,
e que a referência ao *objeto de representação* é chamada `i`.
A declaração também introduz:

- Um getter implícito para o objeto de representação
  com o tipo de representação como o tipo de retorno: `int get i`.
- Um construtor implícito: `E(int i) : i = i`.

O getter de representação dá acesso ao
objeto de representação tipado como o tipo subjacente.
O getter está no escopo do corpo do extension type,
e você pode acessá-lo usando seu nome como qualquer outro getter:

- Dentro do corpo do extension type usando `i` (ou `this.i`).
- Fora com uma extração de propriedade usando `e.i`
  (onde `e` tem o extension type como seu tipo estático).

Declarações de extension type também podem incluir [parâmetros de tipo][generics]
assim como classes ou extensions:

```dart
extension type E<T>(List<T> elements) {
  // ...
}
```

[generics]: /language/generics

### Construtores

Você pode opcionalmente declarar [construtores][constructors] no corpo de um extension type.
A declaração de representação em si é um construtor implícito,
então por padrão toma o lugar de um construtor sem nome para o extension type.
Quaisquer construtores generativos adicionais que não redirecionam devem
inicializar a variável de instância do objeto de representação
usando `this.i` em sua lista de inicializadores ou parâmetros formais.

```dart
extension type E(int i) {
  E.n(this.i);
  E.m(int j, String foo) : i = j + foo.length;
}

void main() {
  E(4); // Implicit unnamed constructor.
  E.n(3); // Named constructor.
  E.m(5, "Hello!"); // Named constructor with additional parameters.
}
```

Ou, você pode nomear o construtor de declaração de representação,
nesse caso há espaço para um construtor sem nome no corpo:

```dart
extension type const E._(int it) {
  E(): this._(42);
  E.otherName(this.it);
}

void main2() {
  E();
  const E._(2);
  E.otherName(3);
}
```

Você também pode ocultar completamente o construtor, em vez de apenas definir um novo,
usando a mesma sintaxe de construtor privado para classes, `_`. Por exemplo,
se você quiser que os clientes construam `E` com uma `String`, mesmo que
o tipo subjacente seja `int`:

```dart
extension type E._(int i) {
  E.fromString(String foo) : i = int.parse(foo);
}
```

Você também pode declarar construtores generativos de encaminhamento,
ou [construtores factory][factory]
(que também podem encaminhar para construtores de sub-extension types).

[constructors]: /language/constructors
[factory]: /language/constructors#factory-constructors

### Membros

Declare membros no corpo de um extension type para definir sua interface
da mesma forma que você faria com membros de classe.
Membros de extension type podem ser métodos, getters, setters ou operadores
([variáveis de instância][instance variables] e [membros abstract][abstract members]
não-[`external`][] não são permitidos):

```dart
extension type NumberE(int value) {
  // Operator:
  NumberE operator +(NumberE other) =>
      NumberE(value + other.value);
  // Getter:
  NumberE get myNum => this;
  // Method:
  bool isValid() => !value.isNegative;
}
```

Membros de interface do tipo de representação não são membros de interface
do extension type [por padrão](#transparency).
Para tornar um único membro do tipo de representação disponível
no extension type, você deve escrever uma declaração para ele
na definição do extension type, como o `operator +` em `NumberE`.
Você também pode definir novos membros não relacionados ao tipo de representação,
como o getter `i` e o método `isValid`.

[`external`]: /language/functions#external
[instance variables]: /language/classes#instance-variables
[abstract members]: /language/methods#abstract-methods

### Implements

Você pode opcionalmente usar a cláusula `implements` para:

- Introduzir uma relação de subtipo em um extension type, E
- Adicionar os membros do objeto de representação à interface do extension type.

A cláusula `implements` introduz uma relação de [aplicabilidade][applicability]
como a entre um [extension method][ext] e seu tipo `on`.
Membros que são aplicáveis ao supertipo são aplicáveis ao
subtipo também, a menos que o subtipo tenha uma declaração com o mesmo
nome de membro.

Um extension type só pode implementar:

- **Seu tipo de representação**.
  Isso torna todos os membros do tipo de representação implicitamente disponíveis
  para o extension type.

  ```dart
  extension type NumberI(int i)
    implements int{
    // 'NumberI' can invoke all members of 'int',
    // plus anything else it declares here.
  }
  ```

- **Um supertipo de seu tipo de representação**.
  Isso torna os membros do supertipo disponíveis,
  embora não necessariamente todos os membros do tipo de representação.

  ```dart
  extension type Sequence<T>(List<T> _) implements Iterable<T> {
    // Better operations than List.
  }

  extension type Id(int _id) implements Object {
    // Makes the extension type non-nullable.
    static Id? tryParse(String source) => int.tryParse(source) as Id?;
  }
  ```

- **Outro extension type** que é válido no mesmo tipo de representação.
  Isso permite que você reutilize operações em múltiplos extension types
  (similar à herança múltipla).

  ```dart
  extension type const Opt<T>._(({T value})? _) {
    const factory Opt(T value) = Val<T>;
    const factory Opt.none() = Non<T>;
  }
  extension type const Val<T>._(({T value}) _) implements Opt<T> {
    const Val(T value) : this._((value: value));
    T get value => _.value;
  }
  extension type const Non<T>._(Null _) implements Opt<Never> {
    const Non() : this._(null);
  }
  ```

Leia a seção [Uso](#usage) para saber mais sobre o efeito de `implements`
em diferentes cenários.

[applicability]: {{site.repo.dart.lang}}/blob/main/accepted/2.7/static-extension-methods/feature-specification.md#examples
[ext]: /language/extension-methods

#### `@redeclare`

Declarar um membro de extension type que
compartilha um nome com um membro de um supertipo *não* é uma
relação de sobrescrita como é entre classes, mas sim uma *redeclaração*.
A declaração de membro de um extension type *substitui completamente* qualquer
membro de supertipo com o mesmo nome.
Não é possível fornecer uma
implementação alternativa para a mesma função.

Você pode usar a annotation [`@redeclare`][] de `package:meta` para
dizer ao compilador que você está *conscientemente* escolhendo
usar o mesmo nome que o membro de um supertipo.
O analisador então avisará se isso não for realmente verdade,
por exemplo, se um dos nomes estiver digitado incorretamente.

<?code-excerpt "language/lib/extension_types/redeclare.dart"?>
```dart
import 'package:meta/meta.dart';

extension type MyString(String _) implements String {
  // Replaces 'String.operator[]'.
  @redeclare
  int operator [](int index) => codeUnitAt(index);
}
```

Você também pode habilitar o lint [`annotate_redeclares`][]
para obter um aviso se você declarar um método de extension type
que oculta um membro de superinterface e *não* está anotado com `@redeclare`.

[`@redeclare`]: {{site.pub-api}}/meta/latest/meta/redeclare-constant.html
[`annotate_redeclares`]: /tools/linter-rules/annotate_redeclares

## Uso

Para usar um extension type, crie uma instância da mesma forma que você faria com uma classe:
chamando um construtor:

```dart
extension type NumberE(int value) {
  NumberE operator +(NumberE other) =>
      NumberE(value + other.value);

  NumberE get next => NumberE(value + 1);
  bool isValid() => !value.isNegative;
}

void testE() {
  var num = NumberE(1);
}
```

Então, você pode invocar membros no objeto como faria com um objeto de classe.

Existem dois casos de uso principais igualmente válidos, mas substancialmente diferentes
para extension types:

1. Fornecer uma interface *estendida* para um tipo existente.
2. Fornecer uma interface *diferente* para um tipo existente.

:::note
Em qualquer caso, o tipo de representação de um extension type nunca é seu subtipo,
então um tipo de representação não pode ser usado de forma intercambiável onde
o extension type é necessário.
:::

<a id="transparency" aria-hidden="true"></a>
<a id="1-provide-an-extended-interface-to-an-existing-type" aria-hidden="true"></a>

### 1. Fornecer uma interface *estendida* para um tipo existente {#provide-extended-interface}

Quando um extension type [implementa](#implements) seu tipo de representação,
você pode considerá-lo "transparente", porque permite que o extension type
"veja" o tipo subjacente.

Um extension type transparente pode invocar todos os membros do
tipo de representação (que não foram [redeclarados](#redeclare)),
mais quaisquer membros auxiliares que ele defina.
Isso cria uma nova interface *estendida* para um tipo existente.
A nova interface está disponível para expressões
cujo tipo estático é o extension type.

Isso significa que você *pode* invocar membros do tipo de representação
(ao contrário de um extension type [não-transparente](#provide-different-interface)),
assim:

```dart
extension type NumberT(int value)
  implements int {
  // Doesn't explicitly declare any members of 'int'.
  NumberT get i => this;
}

void main () {
  // All OK: Transparency allows invoking `int` members on the extension type:
  var v1 = NumberT(1); // v1 type: NumberT
  int v2 = NumberT(2); // v2 type: int
  var v3 = v1.i - v1;  // v3 type: int
  var v4 = v2 + v1; // v4 type: int
  var v5 = 2 + v1; // v5 type: int
  // Error: Extension type interface is not available to representation type
  v2.i;
}
```

Você também pode ter um extension type "quase-transparente"
que adiciona novos membros e adapta outros redeclarando um determinado nome de membro
do supertipo.
Isso permitiria que você usasse tipos mais restritos em alguns parâmetros de um método,
ou valores padrão diferentes, por exemplo.

Outra abordagem de extension type quase-transparente é implementar
um tipo que é um supertipo do tipo de representação.
Por exemplo, se o tipo de representação é privado, mas seu supertipo
define a parte da interface que importa para os clientes.

<a id="2-provide-a-different-interface-to-an-existing-type" aria-hidden="true"></a>

### 2. Fornecer uma interface *diferente* para um tipo existente {:#provide-different-interface}

Um extension type que não é [transparente](#transparency)
(que não [`implement`](#implements) seu tipo de representação)
é estaticamente tratado como um tipo completamente novo,
distinto de seu tipo de representação.
Você não pode atribuí-lo ao seu tipo de representação,
e ele não expõe os membros de seu tipo de representação.

Por exemplo, pegue o extension type `NumberE` que declaramos em [Uso](#usage):

```dart
void testE() {
  var num1 = NumberE(1);
  int num2 = NumberE(2); // Error: Can't assign 'NumberE' to 'int'.

  num1.isValid(); // OK: Extension member invocation.
  num1.isNegative(); // Error: 'NumberE' does not define 'int' member 'isNegative'.

  var sum1 = num1 + num1; // OK: 'NumberE' defines '+'.
  var diff1 = num1 - num1; // Error: 'NumberE' does not define 'int' member '-'.
  var diff2 = num1.value - 2; // OK: Can access representation object with reference.
  var sum2 = num1 + 2; // Error: Can't assign 'int' to parameter type 'NumberE'.

  List<NumberE> numbers = [
    NumberE(1),
    num1.next, // OK: 'next' getter returns type 'NumberE'.
    1, // Error: Can't assign 'int' element to list type 'NumberE'.
  ];
}
```

Você pode usar um extension type dessa maneira para *substituir* a interface
de um tipo existente. Isso permite que você modele uma interface que
faça sentido para as restrições de seu novo tipo
(como o exemplo `IdNumber` na introdução), ao mesmo tempo que se beneficia do
desempenho e conveniência de um tipo predefinido simples, como `int`.

Este caso de uso é o mais próximo que você pode chegar do encapsulamento completo
de uma classe wrapper (mas é realisticamente apenas uma
abstração [*um tanto* protegida](#type-considerations)).

## Considerações de tipo

Extension types são uma construção de wrapping em tempo de compilação.
Em tempo de execução, não há absolutamente nenhum traço do extension type.
Qualquer consulta de tipo ou operações similares em tempo de execução funcionam no tipo de representação.

Isso torna extension types uma abstração *insegura*,
porque você sempre pode descobrir o tipo de representação em tempo de execução
e acessar o objeto subjacente.

Testes de tipo dinâmico (`e is T`), casts (`e as T`),
e outras consultas de tipo em tempo de execução (como `switch (e) ...` ou `if (e case ...)`)
todas avaliam para o objeto de representação subjacente,
e verificam o tipo contra o tipo de tempo de execução desse objeto.
Isso é verdade quando o tipo estático de `e` é um extension type,
e ao testar contra um extension type (`case MyExtensionType(): ... `).

```dart
void main() {
  var n = NumberE(1);

  // The run-time type of 'n' is the representation type 'int'.
  if (n is int) print(n); // Prints 1.

  // Can use 'int' methods on 'n' at run time.
  if (n case int x) print(x.toRadixString(10)); // Prints 1.
  switch (n) {
    case int(:var isEven): print("$n (${isEven ? "even" : "odd"})"); // Prints 1 (odd).
  }
}
```

De forma similar, o tipo estático do valor correspondido é o do extension type
neste exemplo:

```dart
void main() {
  int i = 2;
  if (i is NumberE) print("It is"); // Prints 'It is'.
  if (i case NumberE v) print("value: ${v.value}"); // Prints 'value: 2'.
  switch (i) {
    case NumberE(:var value): print("value: $value"); // Prints 'value: 2'.
  }
}
```

Quando `i` obtém o tipo estático `NumberE` baseado em um cast ou uma correspondência de padrão, `i`
ainda se refere ao mesmo objeto, e `v` se refere ao mesmo objeto que `i`, e
o objeto em si permanece inalterado. É apenas o tipo estático que mudou
(e, portanto, os métodos que podemos chamar neste objeto). Em particular, a
mudança de tipo não envolve uma invocação de um construtor. Se você deseja
executar um construtor (por exemplo, para realizar algum tipo de validação), então é
necessário escrever uma invocação de construtor explícita (como `NumberE(i)`).

É importante estar ciente desse comportamento ao usar extension types.
Sempre tenha em mente que um extension type existe e importa em tempo de compilação,
mas é _apagado_ durante a compilação.

Por exemplo, considere uma expressão `e` cujo tipo estático é o
extension type `E`. Assuma que o tipo de representação de `E` é `R`.
O tipo de tempo de execução do valor de `e` é então um subtipo de `R`.
Até o tipo em si é apagado;
`List<E>` é exatamente a mesma coisa que `List<R>` em tempo de execução.

Em outras palavras, uma classe wrapper real pode encapsular um objeto envolvido,
enquanto um extension type é apenas uma visão em tempo de compilação do objeto envolvido.
Enquanto um wrapper real é mais seguro, a compensação é que extension types
dão a você a opção de evitar objetos wrapper, o que pode melhorar muito
o desempenho em alguns cenários.
