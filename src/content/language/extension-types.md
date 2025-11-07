---
ia-translate: true
title: Tipos de extensão
description: Aprenda como escrever uma interface estática para um tipo existente.
prevpage:
  url: /language/extension-methods
  title: Métodos de extensão
nextpage:
  url: /language/callable-objects
  title: Objetos invocáveis
---

An extension type is a compile-time abstraction that "wraps"
an existing type with a different, static-only interface.
They are a major component of [static JS interop][] because
they can easily modify an existing type's interface
(crucial for any kind of interop)
without incurring the cost of an actual wrapper.

Tipos de extensão impõem disciplina no conjunto de operações (ou interface)
disponíveis para objetos de um tipo subjacente,
chamado de *tipo de representação*.
Ao definir a interface de um tipo de extensão,
você pode optar por reutilizar alguns membros do tipo de representação,
omitir outros, substituir outros e adicionar novas funcionalidades.

O exemplo a seguir envolve o tipo `int` para criar um tipo de extensão
que permite apenas operações que fazem sentido para números de ID:

```dart
extension type IdNumber(int id) {
  // Envolve o operador '<' do tipo 'int':
  operator <(IdNumber other) => id < other.id;
  // Não declara o operador '+', por exemplo,
  // porque a adição não faz sentido para números de ID.
}

void main() {
  // Sem a disciplina de um tipo de extensão,
  // 'int' expõe números de ID a operações não seguras:
  int myUnsafeId = 42424242;
  myUnsafeId = myUnsafeId + 10; // Isso funciona, mas não deveria ser permitido para IDs.

  var safeId = IdNumber(42424242);
  safeId + 10; // Erro em tempo de compilação: Nenhum operador '+'.
  myUnsafeId = safeId; // Erro em tempo de compilação: Tipo errado.
  myUnsafeId = safeId as int; // OK: Conversão em tempo de execução para o tipo de representação.
  safeId < IdNumber(42424241); // OK: Usa o operador '<' envolvido.
}
```

:::note
Tipos de extensão têm o mesmo propósito que **classes *wrapper***,
mas não exigem a criação de um objeto extra em tempo de execução,
o que pode ficar caro quando você precisa envolver muitos objetos.
Como os tipos de extensão são apenas estáticos e compilados em tempo de execução,
eles são essencialmente de custo zero.

[**Métodos de extensão**][ext] (também conhecidos apenas como "extensões")
são uma abstração estática semelhante aos tipos de extensão.
No entanto, um método de extensão adiciona funcionalidade *diretamente*
a cada instância de seu tipo subjacente.
Tipos de extensão são diferentes;
a interface de um tipo de extensão *aplica-se apenas* a expressões
cujo tipo estático é esse tipo de extensão.
Eles são distintos da interface de seu tipo subjacente por padrão.
:::

[static JS interop]: /go/next-gen-js-interop
[ext]: /language/extension-methods

## Syntax

### Declaração {:#declaration}

Define a new extension type with the `extension type` declaration and a name,
followed by the *representation type declaration* in parentheses:

```dart
extension type E(int i) {
  // Define o conjunto de operações.
}
```

The representation type declaration `(int i)` specifies that
the underlying type of extension type `E` is `int`,
and that the reference to the *representation object* is named `i`.
The declaration also introduces:

- An implicit getter for the representation object
  with the representation type as the return type: `int get i`.
- An implicit constructor: `E(int i) : i = i`.

The representation getter gives access to the
representation object typed as the underlying type.
The getter is in scope in the extension type body,
and you can access it using its name like any other getter:

- Within the extension type body using `i` (or `this.i`).
- Outside with a property extraction using `e.i`
  (where `e` has the extension type as its static type).

Extension type declarations can also include [type parameters][generics]
just like classes or extensions:

```dart
extension type E<T>(List<T> elements) {
  // ...
}
```

[generics]: /language/generics

### Constructors

Você pode opcionalmente declarar [construtores][] no corpo de um tipo de extensão.
A própria declaração de representação é um construtor implícito,
portanto, por padrão, assume o lugar de um construtor não nomeado para o tipo de extensão.
Quaisquer construtores generativos adicionais não redirecionadores devem
inicializar a variável de instância do objeto de representação
usando `this.i` em sua lista de inicializadores ou parâmetros formais.

```dart
extension type E(int i) {
  E.n(this.i);
  E.m(int j, String foo) : i = j + foo.length;
}

void main() {
  E(4); // Construtor não nomeado implícito.
  E.n(3); // Construtor nomeado.
  E.m(5, "Olá!"); // Construtor nomeado com parâmetros adicionais.
}
```

Ou, você pode nomear o construtor de declaração de representação,
caso em que há espaço para um construtor não nomeado no corpo:

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
se você quiser apenas clientes construindo `E` com uma `String`, mesmo que
o tipo subjacente seja `int`:

```dart
extension type E._(int i) {
  E.fromString(String foo) : i = int.parse(foo);
}
```

Você também pode declarar construtores generativos de encaminhamento,
ou [construtores de fábrica][factory]
(que também podem encaminhar para construtores de tipos de subextensão).

[constructors]: /language/constructors
[factory]: /language/constructors#factory-constructors

### Members

Declare membros no corpo de um tipo de extensão para definir sua interface
da mesma forma que você faria para membros de classe.
Os membros do tipo de extensão podem ser métodos, *getters*, *setters* ou operadores
(não são permitidas [variáveis de instância][]
não [`external`][] e [membros abstratos][]):

```dart
extension type NumberE(int value) {
  // Operador:
  NumberE operator +(NumberE other) =>
      NumberE(value + other.value);
  // Getter:
  NumberE get myNum => this;
  // Método:
  bool isValid() => !value.isNegative;
}
```

Membros de interface do tipo de representação não são membros de interface
do tipo de extensão [por padrão](#transparency).
Para tornar um único membro do tipo de representação disponível
no tipo de extensão, você deve escrever uma declaração para ele
na definição do tipo de extensão, como o `operator +` em `NumberE`.
Você também pode definir novos membros não relacionados ao tipo de representação,
como o *getter* `i` e o método `isValid`.

[`external`]: /language/functions#external
[instance variables]: /language/classes#instance-variables
[abstract members]: /language/methods#abstract-methods

### Implements

You can optionally use the `implements` clause to:

- Introduce a subtype relationship on an extension type, AND
- Add the members of the representation object to the extension type interface.

A cláusula `implements` introduz um relacionamento de [aplicabilidade][]
como aquele entre um [método de extensão][ext] e seu tipo `on`.
Membros que são aplicáveis ao supertipo são aplicáveis ao
subtipo também, a menos que o subtipo tenha uma declaração com o mesmo
nome de membro.

Um tipo de extensão só pode implementar:

- **Its representation type**.
  This makes all members of the representation type implicitly available
  to the extension type.

  ```dart
  extension type NumberI(int i)
    implements int{
    // 'NumberI' pode invocar todos os membros de 'int',
    // mais qualquer outra coisa que declare aqui.
  }
  ```

- **A supertype of its representation type**.
  This makes the members of the supertype available,
  while not necessarily all the members of representation type.

  ```dart
  extension type Sequence<T>(List<T> _) implements Iterable<T> {
    // Melhores operações do que List.
  }

  extension type Id(int _id) implements Object {
    // Torna o tipo de extensão não nulo.
    static Id? tryParse(String source) => int.tryParse(source) as Id?;
  }
  ```

- **Another extension type** that is valid on the same representation type.
  This allows you to reuse operations across multiple extension types
  (similar to multiple inheritance).

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

Declaring an extension type member that
shares a name with a member of a supertype is *not* an
override relationship like it is between classes, but rather a *redeclaration*.
An extension type member declaration *completely replaces* any
supertype member with the same name.
It's not possible to provide an
alternative implementation for the same function.

You can use the [`@redeclare`][] annotation from `package:meta` to
tell the compiler you are *knowingly* choosing to
use the same name as a supertype's member.
The analyzer will then warn you if that's not actually true,
for example, if one of the names is mistyped.

<?code-excerpt "language/lib/extension_types/redeclare.dart"?>
```dart
import 'package:meta/meta.dart';

extension type MyString(String _) implements String {
  // Replaces 'String.operator[]'.
  @redeclare
  int operator [](int index) => codeUnitAt(index);
}
```

You can also enable the lint [`annotate_redeclares`][]
to get a warning if you declare an extension type method
that hides a superinterface member and *isn't* annotated with `@redeclare`.

[`@redeclare`]: {{site.pub-api}}/meta/latest/meta/redeclare-constant.html
[`annotate_redeclares`]: /tools/linter-rules/annotate_redeclares

## Usage

Para usar um tipo de extensão, crie uma instância da mesma forma que você faria com uma classe:
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
para tipos de extensão:

1. Fornecer uma interface *estendida* para um tipo existente.
2. Fornecer uma interface *diferente* para um tipo existente.

:::note
In any case, the representation type of an extension type is never its subtype,
so a representation type can't be used interchangeably where
the extension type is needed.
:::

<a id="transparency" aria-hidden="true"></a>
<a id="1-provide-an-extended-interface-to-an-existing-type" aria-hidden="true"></a>

### 1. Provide an *extended* interface to an existing type {#provide-extended-interface}

Quando um tipo de extensão [implementa](#implements) seu tipo de representação,
você pode considerá-lo "transparente", porque permite que o tipo de extensão
"veja" o tipo subjacente.

A transparent extension type can invoke all members of the
representation type (that aren't [redeclared](#redeclare)),
plus any auxiliary members it defines.
This creates a new, *extended* interface for an existing type.
The new interface is available to expressions
whose static type is the extension type.

This means you *can* invoke members of the representation type
(unlike a [non-transparent](#provide-different-interface)
extension type), like so:

```dart
extension type NumberT(int value)
  implements int {
  // Não declara explicitamente nenhum membro de 'int'.
  NumberT get i => this;
}

void main () {
  // Tudo OK: A transparência permite invocar membros `int` no tipo de extensão:
  var v1 = NumberT(1); // v1 tipo: NumberT
  int v2 = NumberT(2); // v2 tipo: int
  var v3 = v1.i - v1;  // v3 tipo: int
  var v4 = v2 + v1; // v4 tipo: int
  var v5 = 2 + v1; // v5 tipo: int
  // Erro: A interface do tipo de extensão não está disponível para o tipo de representação
  v2.i;
}
```

Você também pode ter um tipo de extensão "principalmente transparente"
que adiciona novos membros e adapta outros, redeclarando um determinado nome de membro
do supertipo.
Isso permitiria que você usasse tipos mais estritos em alguns parâmetros de um método,
ou valores padrão diferentes, por exemplo.

Outra abordagem de tipo de extensão principalmente transparente é implementar
um tipo que é um supertipo do tipo de representação.
Por exemplo, se o tipo de representação for privado, mas seu supertipo
definir a parte da interface que importa para os clientes.

<a id="2-provide-a-different-interface-to-an-existing-type" aria-hidden="true"></a>

### 2. Provide a *different* interface to an existing type {:#provide-different-interface}

Um tipo de extensão que não é [transparente](#transparency)
(que não [`implementa`](#implements) seu tipo de representação)
é tratado estaticamente como um tipo completamente novo,
distinto de seu tipo de representação.
Você não pode atribuí-lo ao seu tipo de representação,
e ele não expõe os membros de seu tipo de representação.

Por exemplo, pegue o tipo de extensão `NumberE` que declaramos em [Uso](#usage):

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

Você pode usar um tipo de extensão dessa forma para *substituir* a interface
de um tipo existente. Isso permite que você modele uma interface que seja
faz sentido para as restrições do seu novo tipo
(como o exemplo `IdNumber` na introdução), enquanto também se beneficia de
o desempenho e a conveniência de um tipo simples predefinido, como `int`.

Este caso de uso é o mais próximo que você pode chegar da encapsulação completa
de uma classe *wrapper* (mas é realisticamente apenas uma
abstração [*um tanto* protegida](#type-considerations)).

## Considerações sobre tipo {:#type-considerations}

Tipos de extensão são um construto de envolvimento em tempo de compilação.
Em tempo de execução, não há absolutamente nenhum traço do tipo de extensão.
Qualquer consulta de tipo ou operações de tempo de execução semelhantes funcionam no tipo de representação.

Isso torna os tipos de extensão uma abstração *não segura*,
porque você sempre pode descobrir o tipo de representação em tempo de execução
e acessar o objeto subjacente.

Dynamic type tests (`e is T`), casts (`e as T`),
and other run-time type queries (like `switch (e) ...` or `if (e case ...)`)
all evaluate to the underlying representation object,
and type check against that object's runtime type.
That's true when the static type of `e` is an extension type,
and when testing against an extension type (`case MyExtensionType(): ... `).

```dart
void main() {
  var n = NumberE(1);

  // The run-time type of 'n' is the representation type 'int'.
  if (n is int) print(n); // Prints 1.

  // Pode usar métodos 'int' em 'n' em tempo de execução.
  if (n case int x) print(x.toRadixString(10)); // Imprime 1.
  switch (n) {
    case int(:var isEven): print("$n (${isEven ? "par" : "ímpar"})"); // Imprime 1 (ímpar).
  }
}
```

Da mesma forma, o tipo estático do valor correspondido é o do tipo de extensão
neste exemplo:

```dart
void main() {
  int i = 2;
  if (i is NumberE) print("É"); // Imprime 'É'.
  if (i case NumberE v) print("valor: ${v.value}"); // Imprime 'valor: 2'.
  switch (i) {
    case NumberE(:var value): print("valor: $value"); // Imprime 'valor: 2'.
  }
}
```

When `i` gets the static type `NumberE` based on a cast or a pattern match, `i`
still refers to the same object, and `v` refers to the same object as `i`, and
the object itself remains unchanged. It is only the static type that changed
(and hence the methods that we can call on this object). In particular, the
change of type does not involve an invocation of a constructor. If you wish to
execute a constructor (for example, to perform some kind of validation) then it
is necessary to write an explicit constructor invocation (such as `NumberE(i)`).

It's important to be aware of this behavior when using extension types.
Always keep in mind that an extension type exists and matters at compile time,
but gets _erased_ during compilation.

For example, consider an expression `e` whose static type is the
extension type `E`. Assume that the representation type of `E` is `R`.
The run-time type of the value of `e` is then a subtype of `R`.
Even the type itself is erased;
`List<E>` is exactly the same thing as `List<R>` at run time.

In other words, a real wrapper class can encapsulate a wrapped object,
whereas an extension type is just a compile-time view on the wrapped object.
While a real wrapper is safer, the trade-off is extension types
give you the option to avoid wrapper objects, which can greatly
improve performance in some scenarios.
