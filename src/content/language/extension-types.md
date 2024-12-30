---
ia-translate: true
title: Tipos de extensão
description: Aprenda como escrever uma interface estática apenas para um tipo existente.
prevpage:
  url: /language/extension-methods
  title: Métodos de extensão
nextpage:
  url: /language/callable-objects
  title: Objetos invocáveis
---

Um tipo de extensão é uma abstração em tempo de compilação que "envolve"
um tipo existente com uma interface diferente, estática apenas.
Eles são um componente principal do [interop JS estático][static JS interop] porque
eles podem facilmente modificar a interface de um tipo existente
(crucial para qualquer tipo de interop)
sem incorrer no custo de um wrapper real.

Tipos de extensão impõem disciplina no conjunto de operações (ou interface)
disponível para objetos de um tipo subjacente,
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
  safeId + 10; // Erro em tempo de compilação: Sem operador '+'.
  myUnsafeId = safeId; // Erro em tempo de compilação: Tipo errado.
  myUnsafeId = safeId as int; // OK: Cast em tempo de execução para o tipo de representação.
  safeId < IdNumber(42424241); // OK: Usa o operador '<' envolvido.
}
```

:::note
Tipos de extensão servem ao mesmo propósito que **classes wrapper**,
mas não exigem a criação de um objeto extra em tempo de execução,
o que pode ficar caro quando você precisa envolver muitos objetos.
Como os tipos de extensão são estáticos apenas e compilados em tempo de execução,
eles são essencialmente de custo zero.

[**Métodos de extensão**][ext] (também conhecidos apenas como "extensões")
são uma abstração estática semelhante aos tipos de extensão.
No entanto, um método de extensão adiciona funcionalidade *diretamente*
a cada instância de seu tipo subjacente.
Tipos de extensão são diferentes;
a interface de um tipo de extensão *apenas* se aplica a expressões
cujo tipo estático é esse tipo de extensão.
Eles são distintos da interface de seu tipo subjacente por padrão.
:::

## Sintaxe

### Declaração

Defina um novo tipo de extensão com a declaração `extension type` e um nome,
seguido pela *declaração do tipo de representação* entre parênteses:

```dart
extension type E(int i) {
  // Define o conjunto de operações.
}
```

A declaração do tipo de representação `(int i)` especifica que
o tipo subjacente do tipo de extensão `E` é `int`,
e que a referência ao *objeto de representação* é nomeada `i`.
A declaração também introduz:
- Um getter implícito para o objeto de representação
  com o tipo de representação como o tipo de retorno: `int get i`.
- Um construtor implícito: `E(int i) : i = i`.

O objeto de representação dá ao tipo de extensão acesso a um objeto
no tipo subjacente.
O objeto está no escopo no corpo do tipo de extensão, e
você pode acessá-lo usando seu nome como um getter:

- Dentro do corpo do tipo de extensão usando `i` (ou `this.i` em um construtor).
- Fora com uma extração de propriedade usando `e.i`
  (onde `e` tem o tipo de extensão como seu tipo estático).

Declarações de tipo de extensão também podem incluir [parâmetros de tipo](generics)
assim como classes ou extensões:

```dart
extension type E<T>(List<T> elements) {
  // ...
}
```

### Construtores

Você pode opcionalmente declarar [construtores][constructors] no corpo de um tipo de extensão.
A própria declaração de representação é um construtor implícito,
então, por padrão, assume o lugar de um construtor sem nome para o tipo de extensão.
Quaisquer construtores generativos não redirecionadores adicionais devem
inicializar a variável de instância do objeto de representação
usando `this.i` em sua lista de inicializadores ou parâmetros formais.

```dart
extension type E(int i) {
  E.n(this.i);
  E.m(int j, String foo) : i = j + foo.length;
}

void main() {
  E(4); // Construtor sem nome implícito.
  E.n(3); // Construtor nomeado.
  E.m(5, "Olá!"); // Construtor nomeado com parâmetros adicionais.
}
```

Ou, você pode nomear o construtor da declaração de representação,
caso em que há espaço para um construtor sem nome no corpo:

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
se você quiser que os clientes construam `E` apenas com uma `String`, mesmo que
o tipo subjacente seja `int`:

```dart
extension type E._(int i) {
  E.fromString(String foo) : i = int.parse(foo);
}
```

Você também pode declarar construtores generativos de encaminhamento,
ou [construtores de fábrica][factory]
(que também podem encaminhar para construtores de subtipos de extensão).

### Membros

Declare membros no corpo de um tipo de extensão para definir sua interface
da mesma forma que você faria para membros de classe.
Membros de tipo de extensão podem ser métodos, getters, setters ou operadores
(não-[`external`][`external`] [variáveis de instância][instance variables] e [membros abstratos][abstract members]
não são permitidos):

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
como o getter `i` e o método `isValid`.

### Implements

Você pode opcionalmente usar a cláusula `implements` para:
- Introduzir uma relação de subtipo em um tipo de extensão, E
- Adicionar os membros do objeto de representação à interface do tipo de extensão.

A cláusula `implements` introduz uma relação de [aplicabilidade][applicability]
como aquela entre um [método de extensão][ext] e seu tipo `on`.
Membros que são aplicáveis ao supertipo são aplicáveis ao
subtipo também, a menos que o subtipo tenha uma declaração com o mesmo
nome de membro.

Um tipo de extensão só pode implementar:

- **Seu tipo de representação**.
  Isso torna todos os membros do tipo de representação implicitamente disponíveis
  para o tipo de extensão.
  
  ```dart
  extension type NumberI(int i) 
    implements int{
    // 'NumberI' pode invocar todos os membros de 'int',
    // mais qualquer outra coisa que ele declarar aqui.
  }
  ```
  
- **Um supertipo de seu tipo de representação**.
  Isso torna os membros do supertipo disponíveis,
  enquanto não necessariamente todos os membros do tipo de representação.
  
  ```dart
  extension type Sequence<T>(List<T> _) implements Iterable<T> {
    // Operações melhores do que List.
  }
  
  extension type Id(int _id) implements Object {
    // Torna o tipo de extensão não anulável.
    static Id? tryParse(String source) => int.tryParse(source) as Id?;
  }
  ```
  
- **Outro tipo de extensão** que é válido no mesmo tipo de representação.
  Isso permite que você reutilize operações em vários tipos de extensão
  (semelhante à herança múltipla).
  
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

#### `@redeclare`

Declarar um membro de tipo de extensão que compartilha um nome com um membro de um supertipo
*não* é uma relação de sobreposição como é entre classes,
mas sim uma *redeclaração*. Uma declaração de membro de tipo de extensão
*substitui completamente* qualquer membro de supertipo com o mesmo nome.
Não é possível fornecer uma implementação alternativa
para a mesma função.

Você pode usar a anotação `@redeclare` para dizer ao compilador que você está
*conscientemente* escolhendo usar o mesmo nome que o membro de um supertipo.
O analisador então avisará se isso não for realmente verdade,
por exemplo, se um dos nomes estiver digitado incorretamente.

```dart
extension type MyString(String _) implements String {
  // Substitui 'String.operator[]'
  @redeclare
  int operator [](int index) => codeUnitAt(index);
}
```

Você também pode habilitar o lint [`annotate_redeclares`][lint]
para receber um aviso se você declarar um método de tipo de extensão
que oculta um membro de superinterface e *não* é anotado com `@redeclare`.

## Uso

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
Em qualquer caso, o tipo de representação de um tipo de extensão nunca é seu subtipo,
portanto, um tipo de representação não pode ser usado alternadamente onde o tipo de extensão é necessário.
:::

<a id="transparency"></a>

### 1. Fornecer uma interface *estendida* para um tipo existente

Quando um tipo de extensão [implementa](#implements) seu tipo de representação,
você pode considerá-lo "transparente", porque permite que o tipo de extensão
"veja" o tipo subjacente.

Um tipo de extensão transparente pode invocar todos os membros do
tipo de representação (que não são [redeclarados](#redeclare)),
além de quaisquer membros auxiliares que ele defina.
Isso cria uma nova interface *estendida* para um tipo existente.
A nova interface está disponível para expressões
cujo tipo estático é o tipo de extensão.

Isso significa que você *pode* invocar membros do tipo de representação
(ao contrário de um tipo de extensão [não transparente](#2-fornecer-uma-interface-diferente-para-um-tipo-existente)),
assim:

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
  // Erro: Interface de tipo de extensão não está disponível para o tipo de representação
  v2.i;
}
```

Você também pode ter um tipo de extensão "quase transparente"
que adiciona novos membros e adapta outros redeclarando um determinado nome de membro
do supertipo.
Isso permitiria que você usasse tipos mais rigorosos em alguns parâmetros de um método,
ou valores padrão diferentes, por exemplo.

Outra abordagem de tipo de extensão quase transparente é implementar
um tipo que é um supertipo do tipo de representação.
Por exemplo, se o tipo de representação for privado, mas seu supertipo
define a parte da interface que importa para os clientes.

### 2. Fornecer uma interface *diferente* para um tipo existente

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
  int num2 = NumberE(2); // Erro: Não é possível atribuir 'NumberE' a 'int'.
  
  num1.isValid(); // OK: Invocação de membro de extensão.
  num1.isNegative(); // Erro: 'NumberE' não define o membro 'isNegative' de 'int'.
  
  var sum1 = num1 + num1; // OK: 'NumberE' define '+'.
  var diff1 = num1 - num1; // Erro: 'NumberE' não define o membro '-' de 'int'.
  var diff2 = num1.value - 2; // OK: Pode acessar o objeto de representação com referência.
  var sum2 = num1 + 2; // Erro: Não é possível atribuir 'int' ao tipo de parâmetro 'NumberE'. 
  
  List<NumberE> numbers = [
    NumberE(1), 
    num1.next, // OK: O getter 'next' retorna o tipo 'NumberE'.
    1, // Erro: Não é possível atribuir o elemento 'int' ao tipo de lista 'NumberE'.
  ];
}
```

Você pode usar um tipo de extensão dessa forma para *substituir* a interface
de um tipo existente. Isso permite que você modele uma interface que é
faz sentido para as restrições de seu novo tipo
(como o exemplo `IdNumber` na introdução), enquanto também se beneficia de
o desempenho e a conveniência de um tipo simples predefinido, como `int`.

Este caso de uso é o mais próximo que você pode chegar da encapsulação completa
de uma classe wrapper (mas é realisticamente apenas uma
abstração [*um tanto* protegida](#type-considerations)).

## Considerações de tipo

Tipos de extensão são um construto de encapsulamento em tempo de compilação.
Em tempo de execução, não há absolutamente nenhum traço do tipo de extensão.
Qualquer consulta de tipo ou operações semelhantes em tempo de execução funcionam no tipo de representação.

Isso torna os tipos de extensão uma abstração *insegura*,
porque você sempre pode descobrir o tipo de representação em tempo de execução
e acessar o objeto subjacente.

Testes de tipo dinâmico (`e is T`), casts (`e as T`),
e outras consultas de tipo em tempo de execução (como `switch (e) ...` ou `if (e case ...)`)
todos avaliam o objeto de representação subjacente,
e verificam o tipo em relação ao tipo de tempo de execução desse objeto.
Isso é verdade quando o tipo estático de `e` é um tipo de extensão,
e ao testar em relação a um tipo de extensão (`case MyExtensionType(): ...`).

```dart
void main() {
  var n = NumberE(1);

  // O tipo de tempo de execução de 'n' é o tipo de representação 'int'.
  if (n is int) print(n.value); // Imprime 1.

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

É importante estar ciente dessa qualidade ao usar tipos de extensão.
Tenha sempre em mente que um tipo de extensão existe e importa em tempo de compilação,
mas é apagado _durante_ a compilação.

Por exemplo, considere uma expressão `e` cujo tipo estático é o
tipo de extensão `E`, e o tipo de representação de `E` é `R`.
Então, o tipo de tempo de execução do valor de `e` é um subtipo de `R`.
Até mesmo o próprio tipo é apagado;
`List<E>` é exatamente a mesma coisa que `List<R>` em tempo de execução.

Em outras palavras, uma classe wrapper real pode encapsular um objeto envolvido,
enquanto um tipo de extensão é apenas uma visão em tempo de compilação do objeto envolvido.
Embora um wrapper real seja mais seguro, a compensação é que os tipos de extensão
dão a você a opção de evitar objetos wrapper, o que pode melhorar muito
o desempenho em alguns cenários.

[static JS interop]: /go/next-gen-js-interop
[ext]: /language/extension-methods
[generics]: /language/generics
[constructors]: /language/constructors
[factory]: /language/constructors#factory-constructors
[applicability]: {{site.repo.dart.lang}}/blob/main/accepted/2.7/static-extension-methods/feature-specification.md#examples
[more specific]: {{site.repo.dart.lang}}/blob/main/accepted/2.7/static-extension-methods/feature-specification.md#specificity
[lint]: /tools/linter-rules/annotate_redeclares
[instance variables]: /language/classes#instance-variables
[`external`]: /language/functions#external
[abstract members]: /language/methods#abstract-methods
[`is` or `as` check]: /language/operators#type-test-operators
