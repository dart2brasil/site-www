---
ia-translate: true
title: O sistema de tipos do Dart
shortTitle: Sistema de tipos
description: Por que e como escrever código Dart com tipagem sólida.
prevpage:
  url: /language/typedefs
  title: Typedefs
nextpage:
  url: /language/patterns
  title: Padrões
---
<?code-excerpt replace="/ *\/\/\s+ignore_for_file:[^\n]+\n//g; /([A-Z]\w*)\d\b/$1/g; /\b(main)\d\b/$1/g; /(^|\n) *\/\/\s+ignore:[^\n]+\n/$1/g; /(\n[^\n]+) *\/\/\s+ignore:[^\n]+\n/$1\n/g"?>
<?code-excerpt path-base="type_system"?>

A linguagem Dart é type safe (segura em relação a tipos): ela usa uma combinação
de verificação estática de tipos e [verificações em tempo de execução](#runtime-checks)
para garantir que o valor de uma variável sempre corresponda ao tipo estático da
variável, às vezes referida como tipagem sólida. Embora _tipos_ sejam
obrigatórios, _anotações_ de tipo são opcionais
devido à [inferência de tipo](#type-inference).

Um benefício da verificação estática de tipos é a capacidade de encontrar bugs
em tempo de compilação usando o [analisador estático][analysis] do Dart.

Você pode corrigir a maioria dos erros de análise estática adicionando anotações
de tipo a classes genéricas. As classes genéricas mais comuns são os tipos de coleção
`List<T>` e `Map<K,V>`.

Por exemplo, no código a seguir, a função `printInts()` imprime uma lista de inteiros,
e `main()` cria uma lista e a passa para `printInts()`.

<?code-excerpt "lib/strong_analysis.dart (opening-example)" replace="/list(?=\))/[!$&!]/g"?>
```dart tag=fails-sa
void printInts(List<int> a) => print(a);

void main() {
  final list = [];
  list.add(1);
  list.add('2');
  printInts([!list!]);
}
```

O código anterior resulta em um erro de tipo em `list` (destacado
acima) na chamada de `printInts(list)`:

<?code-excerpt "analyzer-results-stable.txt" retain="/strong_analysis.*List.*argument_type_not_assignable/" replace="/-(.*?):(.*?):(.*?)-/-/g; /. • (lib|test)\/\w+\.dart:\d+:\d+//g"?>
```plaintext
error - The argument type 'List<dynamic>' can't be assigned to the parameter type 'List<int>'. - argument_type_not_assignable
```

O erro destaca uma conversão implícita não sólida de `List<dynamic>` para `List<int>`.
A variável `list` tem o tipo estático `List<dynamic>`. Isso ocorre porque a
declaração de inicialização `var list = []` não fornece ao analisador
informações suficientes para que ele infira um argumento de tipo mais específico que `dynamic`.
A função `printInts()` espera um parâmetro do tipo `List<int>`,
causando uma incompatibilidade de tipos.

Ao adicionar uma anotação de tipo (`<int>`) na criação da lista
(destacado abaixo) o analisador reclama que
um argumento de string não pode ser atribuído a um parâmetro `int`.
Remover as aspas em `list.add('2')` resulta em código
que passa na análise estática e é executado sem erros ou avisos.

<?code-excerpt "test/strong_test.dart (opening-example)" replace="/<int.(?=\[)|2/[!$&!]/g"?>
```dart tag=passes-sa
void printInts(List<int> a) => print(a);

void main() {
  final list = [!<int>!][];
  list.add(1);
  list.add([!2!]);
  printInts(list);
}
```

[Experimente no DartPad]({{site.dartpad}}/?id=25074a51a00c71b4b000f33b688dedd0).

## O que é solidez? {:#what-is-soundness}

*Solidez* é sobre garantir que seu programa não entre em certos
estados inválidos. Um *sistema de tipos* sólido significa que você nunca
entrará em um estado onde uma expressão avalie para um valor que não corresponda
ao tipo estático da expressão. Por exemplo, se o tipo estático de uma expressão
for `String`, em tempo de execução você tem a garantia de obter apenas uma string
ao avaliá-la.

O sistema de tipos do Dart, como os sistemas de tipos em Java e C#, é sólido. Ele
impõe essa solidez usando uma combinação de verificação estática
(erros em tempo de compilação) e verificações em tempo de execução. Por exemplo, atribuir uma `String`
a `int` é um erro em tempo de compilação. Converter um objeto para uma `String` usando
`as String` falha com um erro em tempo de execução se o objeto não for uma `String`.


## Os benefícios da solidez {:#the-benefits-of-soundness}

Um sistema de tipos sólido tem vários benefícios:

* Revelar bugs relacionados a tipos em tempo de compilação.<br>
  Um sistema de tipos sólido força o código a ser inequívoco sobre seus tipos,
  portanto, bugs relacionados a tipos que podem ser difíceis de encontrar em tempo de execução são
  revelados em tempo de compilação.

* Código mais legível.<br>
  O código é mais fácil de ler porque você pode confiar que um valor realmente tenha
  o tipo especificado. No Dart sólido, os tipos não podem mentir.

* Código mais fácil de manter.<br>
  Com um sistema de tipos sólido, quando você altera um trecho de código, o
  sistema de tipos pode avisá-lo sobre os outros trechos
  de código que acabaram de ser quebrados.

* Melhor compilação ahead-of-time (AOT).<br>
  Embora a compilação AOT seja possível sem tipos, o
  código gerado é muito menos eficiente.


## Dicas para passar na análise estática {:#tips-for-passing-static-analysis}

A maioria das regras para tipos estáticos são fáceis de entender.
Aqui estão algumas das regras menos óbvias:

* Use tipos de retorno sólidos ao substituir métodos.
* Use tipos de parâmetro sólidos ao substituir métodos.
* Não use uma lista dinâmica como uma lista tipada.

Vamos ver essas regras em detalhes, com exemplos que usam a seguinte
hierarquia de tipos:

<img src="/assets/img/language/type-hierarchy.png" class="diagram-wrap" alt="a hierarchy of animals where the supertype is Animal and the subtypes are Alligator, Cat, and HoneyBadger. Cat has the subtypes of Lion and MaineCoon">

<a name="use-proper-return-types"></a>
### Use tipos de retorno sólidos ao substituir métodos {:#use-sound-return-types-when-overriding-methods}

O tipo de retorno de um método em uma subclasse deve ser o mesmo tipo ou um
subtipo do tipo de retorno do método na superclasse.
Considere o método getter na classe `Animal`:

<?code-excerpt "lib/animal.dart (Animal)" replace="/Animal get.*/[!$&!]/g"?>
```dart
class Animal {
  void chase(Animal a) {
     ...
  }
  [!Animal get parent => ...!]
}
```

O método getter `parent` retorna um `Animal`. Na subclasse `HoneyBadger` (Texugo-Melandês),
você pode substituir o tipo de retorno do getter por `HoneyBadger`
(ou qualquer outro subtipo de `Animal`), mas um tipo não relacionado não é permitido.

<?code-excerpt "lib/animal.dart (HoneyBadger)" replace="/(\w+)(?= get)/[!$&!]/g"?>
```dart tag=passes-sa
class HoneyBadger extends Animal {
  @override
  void chase(Animal a) {
     ...
  }

  @override
  [!HoneyBadger!] get parent => ...
}
```

<?code-excerpt "lib/animal.dart (HoneyBadger)" replace="/HoneyBadger get/[!Root!] get/g"?>
```dart tag=fails-sa
class HoneyBadger extends Animal {
  @override
  void chase(Animal a) {
     ...
  }

  @override
  [!Root!] get parent => ...
}
```

<a name="use-proper-param-types"></a>
### Use tipos de parâmetro sólidos ao substituir métodos {:#use-sound-parameter-types-when-overriding-methods}

O parâmetro de um método substituído deve ter o mesmo tipo
ou um supertipo do parâmetro correspondente na superclasse.
Não "restrinja" o tipo de parâmetro substituindo o tipo por um
subtipo do parâmetro original.

:::note
Se você tiver um motivo válido para usar um subtipo, você pode usar a
palavra-chave [`covariant`](/language/type-system#covariant-keyword).
:::

Considere o método `chase(Animal)` para a classe `Animal`:

<?code-excerpt "lib/animal.dart (Animal)" replace="/void chase.*/[!$&!]/g"?>
```dart
class Animal {
  [!void chase(Animal a) {!]
     ...
  }
  Animal get parent => ...
}
```

O método `chase()` recebe um `Animal`. Um `HoneyBadger` persegue qualquer coisa.
Não há problema em substituir o método `chase()` para receber qualquer coisa (`Object`).

<?code-excerpt "lib/animal.dart (chase-Object)" replace="/Object/[!$&!]/g"?>
```dart tag=passes-sa
class HoneyBadger extends Animal {
  @override
  void chase([!Object!] a) {
     ...
  }

  @override
  Animal get parent => ...
}
```

O código a seguir restringe o parâmetro no método `chase()`
de `Animal` para `Mouse` (Rato), uma subclasse de `Animal`.

<?code-excerpt "lib/incorrect_animal.dart (chase-mouse)" replace="/Mouse/[!$&!]/g"?>
```dart tag=fails-sa
class [!Mouse!] extends Animal {
   ...
}

class Cat extends Animal {
  @override
  void chase([!Mouse!] a) {
     ...
  }
}
```

Este código não é type safe (seguro em relação a tipos) porque seria possível definir
um gato e enviá-lo atrás de um jacaré:

<?code-excerpt "lib/incorrect_animal.dart (would-not-be-type-safe)" replace="/Alligator/[!$&!]/g"?>
```dart
Animal a = Cat();
a.chase([!Alligator!]()); // Not type safe or feline safe.
```

### Não use uma lista dinâmica como uma lista tipada {:#dont-use-a-dynamic-list-as-a-typed-list}

Uma lista `dynamic` é boa quando você quer ter uma lista com
diferentes tipos de coisas nela. No entanto, você não pode usar uma
lista `dynamic` como uma lista tipada.

Essa regra também se aplica a instâncias de tipos genéricos.

O código a seguir cria uma lista `dynamic` de `Dog` (Cachorro) e a atribui a
uma lista do tipo `Cat` (Gato), o que gera um erro durante a análise estática.

<?code-excerpt "lib/incorrect_animal.dart (invalid-dynamic-list)" replace="/(<dynamic\x3E)(.*?)Error/[!$1!]$2Error/g"?>
```dart tag=fails-sa
void main() {
  List<Cat> foo = [!<dynamic>!][Dog()]; // Error
  List<dynamic> bar = <dynamic>[Dog(), Cat()]; // OK
}
```

## Verificações em tempo de execução {:#runtime-checks}

As verificações em tempo de execução lidam com questões de type safety
que não podem ser detectadas em tempo de compilação.

Por exemplo, o código a seguir lança uma exceção em tempo de execução
porque é um erro converter uma lista de cachorros em uma lista de gatos:

<?code-excerpt "test/strong_test.dart (runtime-checks)" replace="/animals as[^;]*/[!$&!]/g"?>
```dart tag=runtime-fail
void main() {
  List<Animal> animals = <Dog>[Dog()];
  List<Cat> cats = [!animals as List<Cat>!];
}
```

### Implicit downcasts from `dynamic`

Expressions with a static type of `dynamic` can be
implicitly cast to a more specific type.
If the actual type doesn't match, the cast throws an error at run time.
Consider the following `assumeString` method:

<?code-excerpt "lib/strong_analysis.dart (downcast-check)" replace="/string = object/[!$&!]/g"?>
```dart tag=passes-sa
int assumeString(dynamic object) {
  String [!string = object!]; // Check at run time that `object` is a `String`.
  return string.length;
}
```

In this example, if `object` is a `String`, the cast succeeds.
If it's not a subtype of `String`, such as `int`,
a `TypeError` is thrown:

<?code-excerpt "lib/strong_analysis.dart (fail-downcast-check)" replace="/1/[!$&!]/g"?>
```dart tag=runtime-fail
final length = assumeString([!1!]);
```

:::tip
To prevent implicit downcasts from `dynamic` and avoid this issue,
consider enabling the analyzer's _strict casts_ mode.

```yaml title="analysis_options.yaml" highlightLines=3
analyzer:
  language:
    strict-casts: true
```

To learn more about customizing the analyzer's behavior,
check out [Customizing static analysis](/tools/analysis).
:::

## Inferência de tipo {:#type-inference}

O analisador pode inferir tipos para campos, métodos, variáveis locais
e a maioria dos argumentos de tipo genérico.
Quando o analisador não tem informações suficientes para inferir
um tipo específico, ele usa o tipo `dynamic`.

Aqui está um exemplo de como a inferência de tipo funciona com genéricos.
Neste exemplo, uma variável chamada `arguments` contém um mapa que
emparelha chaves de string com valores de vários tipos.

Se você tipar explicitamente a variável, você pode escrever isso:

<?code-excerpt "lib/strong_analysis.dart (type-inference-1-orig)" replace="/Map<String, Object\?\x3E/[!$&!]/g"?>
```dart
[!Map<String, Object?>!] arguments = {'argA': 'hello', 'argB': 42};
```

Alternativamente, você pode usar `var` ou `final` e deixar o Dart inferir o tipo:

<?code-excerpt "lib/strong_analysis.dart (type-inference-1)" replace="/var/[!$&!]/g"?>
```dart
[!var!] arguments = {'argA': 'hello', 'argB': 42}; // Map<String, Object>
```

O literal do mapa infere seu tipo a partir de suas entradas,
e então a variável infere seu tipo a partir do tipo literal do mapa.
Neste mapa, as chaves são ambas strings, mas os valores têm tipos
diferentes (`String` e `int`, que têm o limite superior `Object`).
Portanto, o literal do mapa tem o tipo `Map<String, Object>`,
e o mesmo ocorre com a variável `arguments`.


### Inferência de campo e método {:#field-and-method-inference}

Um campo ou método que não possui um tipo especificado e que substitui
um campo ou método da superclasse, herda o tipo do
método ou campo da superclasse.

Um campo que não possui um tipo declarado ou herdado, mas que é declarado
com um valor inicial, recebe um tipo inferido com base no valor inicial.

### Inferência de campo estático {:#static-field-inference}

Campos e variáveis estáticas têm seus tipos inferidos a partir de seu
inicializador. Observe que a inferência falha se encontrar um ciclo
(ou seja, inferir um tipo para a variável depende de conhecer o
tipo dessa variável).

### Inferência de variável local {:#local-variable-inference}

Os tipos de variáveis locais são inferidos a partir de seu inicializador, se houver.
Atribuições subsequentes não são levadas em consideração.
Isso pode significar que um tipo muito preciso pode ser inferido.
Se for o caso, você pode adicionar uma anotação de tipo.

<?code-excerpt "lib/strong_analysis.dart (local-var-type-inference-error)"?>
```dart tag=fails-sa
var x = 3; // x is inferred as an int.
x = 4.0;
```

<?code-excerpt "lib/strong_analysis.dart (local-var-type-inference-ok)"?>
```dart tag=passes-sa
num y = 3; // A num can be double or int.
y = 4.0;
```

### Inferência de argumento de tipo {:#type-argument-inference}

Argumentos de tipo para chamadas de construtor e
invocações de [método genérico](/language/generics#using-generic-methods)
são inferidos com base em uma combinação de informações descendentes do contexto
de ocorrência e informações ascendentes dos argumentos para o construtor
ou método genérico. Se a inferência não estiver fazendo o que você deseja ou espera,
você sempre pode especificar explicitamente os argumentos de tipo.

<?code-excerpt "lib/strong_analysis.dart (type-arg-inference)"?>
```dart tag=passes-sa
// Inferred as if you wrote <int>[].
List<int> listOfInt = [];

// Inferred as if you wrote <double>[3.0].
var listOfDouble = [3.0];

// Inferred as Iterable<int>.
var ints = listOfDouble.map((x) => x.toInt());
```

No último exemplo, `x` é inferido como `double` usando informações descendentes.
O tipo de retorno do closure é inferido como `int` usando informações ascendentes.
O Dart usa esse tipo de retorno como informações ascendentes ao inferir o
argumento de tipo do método `map()`: `<int>`.

#### Inference using bounds

:::version-note
Inference using bounds requires a [language version][] of at least 3.7.0.
:::

With the inference using bounds feature,
Dart's type inference algorithm generates constraints by
combining existing constraints with the declared type bounds,
not just best-effort approximations.

This is especially important for [F-bounded][] types,
where inference using bounds correctly infers that, in the example below,
`X` can be bound to `B`.
Without the feature, the type argument must be specified explicitly: `f<B>(C())`:

<?code-excerpt "lib/strong_analysis.dart (inference-using-bounds)"?>
```dart
class A<X extends A<X>> {}

class B extends A<B> {}

class C extends B {}

void f<X extends A<X>>(X x) {}

void main() {
  f(B()); // OK.

  // OK. Without using bounds, inference relying on best-effort approximations
  // would fail after detecting that `C` is not a subtype of `A<C>`.
  f(C());

  f<B>(C()); // OK.
}
```

Here's a more realistic example using everyday types in Dart like `int` or `num`:

<?code-excerpt "lib/bounded/instantiate_to_bound.dart (inference-using-bounds-2)"?>
```dart
X max<X extends Comparable<X>>(X x1, X x2) => x1.compareTo(x2) > 0 ? x1 : x2;

void main() {
  // Inferred as `max<num>(3, 7)` with the feature, fails without it.
  max(3, 7);
}
```

With inference using bounds, Dart can *deconstruct* type arguments,
extracting type information from a generic type parameter's bound.
This allows functions like `f` in the following example to preserve both the
specific iterable type (`List` or `Set`) *and* the element type.
Before inference using bounds, this wasn't possible 
without losing type safety or specific type information.

```dart
(X, Y) f<X extends Iterable<Y>, Y>(X x) => (x, x.first);

void main() {
  var (myList, myInt) = f([1]);
  myInt.whatever; // Compile-time error, `myInt` has type `int`.

  var (mySet, myString) = f({'Hello!'});
  mySet.union({}); // Works, `mySet` has type `Set<String>`.
}
```

Without inference using bounds, `myInt` would have the type `dynamic`.
The previous inference algorithm wouldn't catch the incorrect expression
`myInt.whatever` at compile time, and would instead throw at run time.
Conversely, `mySet.union({})` would be a compile-time error
without inference using bounds, because the previous algorithm couldn't
preserve the information that `mySet` is a `Set`.

For more information on the inference using bounds algorithm,
read the [design document][]. 


[F-bounded]: /language/generics/#f-bounds
[design document]: {{site.repo.dart.lang}}/blob/main/accepted/future-releases/3009-inference-using-bounds/design-document.md#motivating-example

## Substituindo tipos {:#substituting-types}

Quando você substitui um método, você está substituindo algo de um tipo (no
método antigo) por algo que pode ter um novo tipo (no novo método).
Da mesma forma, quando você passa um argumento para uma função,
você está substituindo algo que tem um tipo (um parâmetro
com um tipo declarado) por algo que tem outro tipo
(o argumento real). Quando você pode substituir algo que
tem um tipo por algo que tem um subtipo ou um supertipo?

Ao substituir tipos, é útil pensar em termos de _consumidores_
e _produtores_. Um consumidor absorve um tipo e um produtor gera um tipo.

**Você pode substituir o tipo de um consumidor por um supertipo e o tipo de um produtor
por um subtipo.**

Vamos ver exemplos de atribuição de tipo simples e atribuição com
tipos genéricos.

### Atribuição de tipo simples {:#simple-type-assignment}

Ao atribuir objetos a objetos, quando você pode substituir um tipo por um
tipo diferente? A resposta depende se o objeto é um consumidor
ou um produtor.

Considere a seguinte hierarquia de tipos:

<img src="/assets/img/language/type-hierarchy.png" class="diagram-wrap" alt="a hierarchy of animals where the supertype is Animal and the subtypes are Alligator, Cat, and HoneyBadger. Cat has the subtypes of Lion and MaineCoon">

Considere a seguinte atribuição simples onde `Cat c` é um _consumidor_
e `Cat()` é um _produtor_:

<?code-excerpt "lib/strong_analysis.dart (Cat-Cat-ok)"?>
```dart
Cat c = Cat();
```

Em uma posição de consumo, é seguro substituir algo que consome um
tipo específico (`Cat`) por algo que consome qualquer coisa (`Animal`),
portanto, substituir `Cat c` por `Animal c` é permitido, porque `Animal` é
um supertipo de `Cat`.

<?code-excerpt "lib/strong_analysis.dart (Animal-Cat-ok)"?>
```dart tag=passes-sa
Animal c = Cat();
```

Mas substituir `Cat c` por `MaineCoon c` quebra a type safety, porque a
superclasse pode fornecer um tipo de `Cat` com diferentes comportamentos,
como `Lion` (Leão):

<?code-excerpt "lib/strong_analysis.dart (MaineCoon-Cat-err)"?>
```dart tag=fails-sa
MaineCoon c = Cat();
```

Em uma posição de produção, é seguro substituir algo que produz um
tipo (`Cat`) com um tipo mais específico (`MaineCoon`). Portanto, o seguinte
é permitido:

<?code-excerpt "lib/strong_analysis.dart (Cat-MaineCoon-ok)"?>
```dart tag=passes-sa
Cat c = MaineCoon();
```

### Atribuição de tipo genérico {:#generic-type-assignment}

As regras são as mesmas para tipos genéricos? Sim. Considere a hierarquia
de listas de animais—uma `List` de `Cat` é um subtipo de uma `List` de
`Animal` e um supertipo de uma `List` de `MaineCoon`:

<img src="/assets/img/language/type-hierarchy-generics.png" class="diagram-wrap" alt="List<Animal> -> List<Cat> -> List<MaineCoon>">

No exemplo a seguir,
você pode atribuir uma lista `MaineCoon` a `myCats`
porque `List<MaineCoon>` é um subtipo de `List<Cat>`:

<?code-excerpt "lib/strong_analysis.dart (generic-type-assignment-MaineCoon)" replace="/<MaineCoon/<[!MaineCoon!]/g"?>
```dart tag=passes-sa
List<[!MaineCoon!]> myMaineCoons = ...
List<Cat> myCats = myMaineCoons;
```

E quanto a ir na outra direção?
Você pode atribuir uma lista `Animal` a uma `List<Cat>`?

<?code-excerpt "lib/strong_analysis.dart (generic-type-assignment-Animal)" replace="/<Animal/<[!Animal!]/g"?>
```dart tag=fails-sa
List<[!Animal!]> myAnimals = ...
List<Cat> myCats = myAnimals;
```

Essa atribuição não passa na análise estática
porque cria um downcast (conversão para subtipo) implícito,
que não é permitido a partir de tipos não-`dynamic`, como `Animal`.

Para fazer com que esse tipo de código passe na análise estática,
você pode usar uma conversão explícita.

<?code-excerpt "lib/strong_analysis.dart (generic-type-assignment-implied-cast)" replace="/as.*(?=;)/[!$&!]/g"?>
```dart
List<Animal> myAnimals = ...
List<Cat> myCats = myAnimals [!as List<Cat>!];
```

Uma conversão explícita ainda pode falhar em tempo de execução, porém,
dependendo do tipo real da lista que está sendo convertida (`myAnimals`).

### Métodos {:#methods}

Ao substituir um método, as regras de produtor e consumidor ainda se aplicam.
Por exemplo:

<img src="/assets/img/language/consumer-producer-methods.png" class="diagram-wrap" alt="Animal class showing the chase method as the consumer and the parent getter as the producer">

Para um consumidor (como o método `chase(Animal)`), você pode substituir
o tipo de parâmetro por um supertipo. Para um produtor (como
o método getter `parent`), você pode substituir o tipo de retorno por
um subtipo.

Para mais informações, veja
[Use tipos de retorno sólidos ao substituir métodos](#use-sound-return-types-when-overriding-methods)
e [Use tipos de parâmetro sólidos ao substituir métodos](#use-sound-parameter-types-when-overriding-methods).

<a id="covariant-keyword" aria-hidden="true"></a>
#### Covariant parameters

Some (rarely used) coding patterns rely on tightening a type
by overriding a parameter's type with a subtype, which is invalid.
In this case, you can use the `covariant` keyword to
tell the analyzer that you're doing this intentionally.
This removes the static error and instead checks for an invalid
argument type at runtime.

The following shows how you might use `covariant`:

<?code-excerpt "lib/covariant.dart" replace="/covariant/[!$&!]/g"?>
```dart tag=passes-sa
class Animal {
  void chase(Animal x) {
     ...
  }
}

class Mouse extends Animal {
   ...
}

class Cat extends Animal {
  @override
  void chase([!covariant!] Mouse x) {
     ...
  }
}
```

Although this example shows using `covariant` in the subtype,
the `covariant` keyword can be placed in either the superclass
or the subclass method.
Usually the superclass method is the best place to put it.
The `covariant` keyword applies to a single parameter and is
also supported on setters and fields.

## Outros recursos {:#other-resources}

Os seguintes recursos têm mais informações sobre o Dart sólido:

* [Fixing type promotion failures](/tools/non-promotion-reasons) -
  Understand and learn how to fix type promotion errors.
* [Sound null safety](/null-safety) -
  Learn about writing code with sound null safety.
* [Customizing static analysis][analysis] -
  How to set up and customize the analyzer and linter
  using an analysis options file.


[analysis]: /tools/analysis
[language version]: /resources/language/evolution#language-versioning
[null safety]: /null-safety
