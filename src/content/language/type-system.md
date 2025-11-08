---
ia-translate: true
title: O sistema de tipos do Dart
shortTitle: Sistema de tipos
description: Por que e como escrever código Dart sound.
prevpage:
  url: /language/typedefs
  title: Typedefs
nextpage:
  url: /language/patterns
  title: Patterns
---
<?code-excerpt replace="/ *\/\/\s+ignore_for_file:[^\n]+\n//g; /([A-Z]\w*)\d\b/$1/g; /\b(main)\d\b/$1/g; /(^|\n) *\/\/\s+ignore:[^\n]+\n/$1/g; /(\n[^\n]+) *\/\/\s+ignore:[^\n]+\n/$1\n/g"?>
<?code-excerpt path-base="type_system"?>

A linguagem Dart é type safe: ela usa uma combinação de verificação estática de tipos
e [verificações em tempo de execução](#runtime-checks) para
garantir que o valor de uma variável sempre corresponda ao tipo estático da variável,
às vezes chamado de tipagem sound.
Embora _tipos_ sejam obrigatórios, _anotações_ de tipo são opcionais
por causa da [inferência de tipos](#type-inference).

Um benefício da verificação estática de tipos é a capacidade de encontrar bugs
em tempo de compilação usando o [analisador estático][analysis] do Dart.

Você pode corrigir a maioria dos erros de análise estática adicionando anotações de tipo a classes
genéricas. As classes genéricas mais comuns são os tipos de coleção
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

O erro destaca um cast implícito não sound de `List<dynamic>` para `List<int>`.
A variável `list` tem tipo estático `List<dynamic>`. Isso ocorre porque a
declaração de inicialização `var list = []` não fornece ao analisador
informações suficientes para inferir um argumento de tipo mais específico que `dynamic`.
A função `printInts()` espera um parâmetro do tipo `List<int>`,
causando uma incompatibilidade de tipos.

Ao adicionar uma anotação de tipo (`<int>`) na criação da lista
(destacado abaixo), o analisador reclama que
um argumento string não pode ser atribuído a um parâmetro `int`.
Remover as aspas em `list.add('2')` resulta em código
que passa na análise estática e executa sem erros ou avisos.

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

## O que é soundness? {:#what-is-soundness}

*Soundness* é garantir que seu programa não possa entrar em certos
estados inválidos. Um *sistema de tipos* sound significa que você nunca pode entrar em
um estado onde uma expressão avalia para um valor que não corresponde
ao tipo estático da expressão. Por exemplo, se o tipo estático de uma expressão
é `String`, em tempo de execução você tem garantia de obter apenas uma string
quando avaliá-la.

O sistema de tipos do Dart, como os sistemas de tipos em Java e C#, é sound. Ele
impõe essa soundness usando uma combinação de verificação estática
(erros em tempo de compilação) e verificações em tempo de execução. Por exemplo, atribuir uma `String`
a `int` é um erro em tempo de compilação. Converter um objeto para uma `String` usando
`as String` falha com um erro em tempo de execução se o objeto não for uma `String`.


## Os benefícios da soundness {:#the-benefits-of-soundness}

Um sistema de tipos sound tem vários benefícios:

* Revelar bugs relacionados a tipos em tempo de compilação.<br>
  Um sistema de tipos sound força o código a ser inequívoco sobre seus tipos,
  então bugs relacionados a tipos que podem ser difíceis de encontrar em tempo de execução são
  revelados em tempo de compilação.

* Código mais legível.<br>
  O código é mais fácil de ler porque você pode confiar que um valor realmente tem
  o tipo especificado. Em Dart sound, tipos não podem mentir.

* Código mais manutenível.<br>
  Com um sistema de tipos sound, quando você muda uma parte do código, o
  sistema de tipos pode avisar sobre as outras partes
  do código que acabaram de quebrar.

* Melhor compilação ahead of time (AOT).<br>
  Embora a compilação AOT seja possível sem tipos, o código gerado
  é muito menos eficiente.


## Dicas para passar na análise estática {:#tips-for-passing-static-analysis}

A maioria das regras para tipos estáticos é fácil de entender.
Aqui estão algumas das regras menos óbvias:

* Use tipos de retorno sound ao sobrescrever métodos.
* Use tipos de parâmetro sound ao sobrescrever métodos.
* Não use uma lista dynamic como uma lista tipada.

Vejamos essas regras em detalhes, com exemplos que usam a seguinte
hierarquia de tipos:

<img src="/assets/img/language/type-hierarchy.png" class="diagram-wrap" alt="uma hierarquia de animais onde o supertipo é Animal e os subtipos são Alligator, Cat e HoneyBadger. Cat tem os subtipos Lion e MaineCoon">

<a name="use-proper-return-types"></a>
### Use tipos de retorno sound ao sobrescrever métodos {:#use-sound-return-types-when-overriding-methods}

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

O método getter `parent` retorna um `Animal`. Na subclasse `HoneyBadger`,
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
### Use tipos de parâmetro sound ao sobrescrever métodos {:#use-sound-parameter-types-when-overriding-methods}

O parâmetro de um método sobrescrito deve ter o mesmo tipo
ou um supertipo do parâmetro correspondente na superclasse.
Não "aperte" o tipo do parâmetro substituindo o tipo por um
subtipo do parâmetro original.

:::note
Se você tem uma razão válida para usar um subtipo, pode usar a
[palavra-chave `covariant`](/language/type-system#covariant-keyword).
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
É OK sobrescrever o método `chase()` para receber qualquer coisa (`Object`).

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

O código a seguir aperta o parâmetro no método `chase()`
de `Animal` para `Mouse`, um subtipo de `Animal`.

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

Este código não é type safe porque seria possível definir
um gato e enviá-lo atrás de um jacaré:

<?code-excerpt "lib/incorrect_animal.dart (would-not-be-type-safe)" replace="/Alligator/[!$&!]/g"?>
```dart
Animal a = Cat();
a.chase([!Alligator!]()); // Not type safe or feline safe.
```

### Não use uma lista dynamic como uma lista tipada {:#dont-use-a-dynamic-list-as-a-typed-list}

Uma lista `dynamic` é boa quando você quer ter uma lista com
diferentes tipos de coisas nela. No entanto, você não pode usar uma
lista `dynamic` como uma lista tipada.

Esta regra também se aplica a instâncias de tipos genéricos.

O código a seguir cria uma lista `dynamic` de `Dog`, e a atribui a
uma lista do tipo `Cat`, o que gera um erro durante a análise estática.

<?code-excerpt "lib/incorrect_animal.dart (invalid-dynamic-list)" replace="/(<dynamic\x3E)(.*?)Error/[!$1!]$2Error/g"?>
```dart tag=fails-sa
void main() {
  List<Cat> foo = [!<dynamic>!][Dog()]; // Error
  List<dynamic> bar = <dynamic>[Dog(), Cat()]; // OK
}
```

## Verificações em tempo de execução {:#runtime-checks}

Verificações em tempo de execução lidam com problemas de segurança de tipo
que não podem ser detectados em tempo de compilação.

Por exemplo, o código a seguir lança uma exceção em tempo de execução
porque é um erro converter uma lista de cachorros em uma lista de gatos:

<?code-excerpt "test/strong_test.dart (runtime-checks)" replace="/animals as[^;]*/[!$&!]/g"?>
```dart tag=runtime-fail
void main() {
  List<Animal> animals = <Dog>[Dog()];
  List<Cat> cats = [!animals as List<Cat>!];
}
```

### Downcasts implícitos de `dynamic` {:#implicit-downcasts-from-dynamic}

Expressões com tipo estático de `dynamic` podem ser
implicitamente convertidas para um tipo mais específico.
Se o tipo real não corresponder, a conversão lança um erro em tempo de execução.
Considere o seguinte método `assumeString`:

<?code-excerpt "lib/strong_analysis.dart (downcast-check)" replace="/string = object/[!$&!]/g"?>
```dart tag=passes-sa
int assumeString(dynamic object) {
  String [!string = object!]; // Check at run time that `object` is a `String`.
  return string.length;
}
```

Neste exemplo, se `object` for uma `String`, a conversão tem sucesso.
Se não for um subtipo de `String`, como `int`,
um `TypeError` é lançado:

<?code-excerpt "lib/strong_analysis.dart (fail-downcast-check)" replace="/1/[!$&!]/g"?>
```dart tag=runtime-fail
final length = assumeString([!1!]);
```

:::tip
Para evitar downcasts implícitos de `dynamic` e evitar esse problema,
considere habilitar o modo _strict casts_ do analisador.

```yaml title="analysis_options.yaml" highlightLines=3
analyzer:
  language:
    strict-casts: true
```

Para saber mais sobre personalizar o comportamento do analisador,
confira [Personalizando análise estática](/tools/analysis).
:::

## Inferência de tipos {:#type-inference}

O analisador pode inferir tipos para campos, métodos, variáveis locais,
e a maioria dos argumentos de tipo genérico.
Quando o analisador não tem informações suficientes para inferir
um tipo específico, ele usa o tipo `dynamic`.

Aqui está um exemplo de como a inferência de tipos funciona com genéricos.
Neste exemplo, uma variável chamada `arguments` contém um map que
emparelha chaves string com valores de vários tipos.

Se você tipar explicitamente a variável, pode escrever isso:

<?code-excerpt "lib/strong_analysis.dart (type-inference-1-orig)" replace="/Map<String, Object\?\x3E/[!$&!]/g"?>
```dart
[!Map<String, Object?>!] arguments = {'argA': 'hello', 'argB': 42};
```

Alternativamente, você pode usar `var` ou `final` e deixar Dart inferir o tipo:

<?code-excerpt "lib/strong_analysis.dart (type-inference-1)" replace="/var/[!$&!]/g"?>
```dart
[!var!] arguments = {'argA': 'hello', 'argB': 42}; // Map<String, Object>
```

O literal de map infere seu tipo de suas entradas,
e então a variável infere seu tipo do tipo do literal de map.
Neste map, as chaves são ambas strings, mas os valores têm diferentes
tipos (`String` e `int`, que têm o limite superior `Object`).
Então o literal de map tem o tipo `Map<String, Object>`,
e assim tem a variável `arguments`.


### Inferência de campo e método {:#field-and-method-inference}

Um campo ou método que não tem tipo especificado e que sobrescreve
um campo ou método da superclasse, herda o tipo do
método ou campo da superclasse.

Um campo que não tem um tipo declarado ou herdado mas que é declarado
com um valor inicial, obtém um tipo inferido baseado no valor inicial.

### Inferência de campo estático {:#static-field-inference}

Campos estáticos e variáveis obtêm seus tipos inferidos de seu
inicializador. Note que a inferência falha se encontrar um ciclo
(ou seja, inferir um tipo para a variável depende de conhecer o
tipo dessa variável).

### Inferência de variável local {:#local-variable-inference}

Tipos de variáveis locais são inferidos de seu inicializador, se houver.
Atribuições subsequentes não são levadas em conta.
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
são inferidos baseados em uma combinação de informação descendente do contexto
de ocorrência, e informação ascendente dos argumentos para o construtor
ou método genérico. Se a inferência não estiver fazendo o que você quer ou espera,
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

No último exemplo, `x` é inferido como `double` usando informação descendente.
O tipo de retorno do closure é inferido como `int` usando informação ascendente.
Dart usa esse tipo de retorno como informação ascendente ao inferir o argumento de tipo
do método `map()`: `<int>`.

#### Inferência usando limites {:#inference-using-bounds}

:::version-note
Inferência usando limites requer uma [language version][] de pelo menos 3.7.0.
:::

Com o recurso de inferência usando limites,
o algoritmo de inferência de tipos do Dart gera restrições combinando
restrições existentes com os limites de tipo declarados,
não apenas aproximações de melhor esforço.

Isso é especialmente importante para tipos [F-bounded][],
onde a inferência usando limites infere corretamente que, no exemplo abaixo,
`X` pode ser vinculado a `B`.
Sem o recurso, o argumento de tipo deve ser especificado explicitamente: `f<B>(C())`:

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

Aqui está um exemplo mais realista usando tipos do dia a dia em Dart como `int` ou `num`:

<?code-excerpt "lib/bounded/instantiate_to_bound.dart (inference-using-bounds-2)"?>
```dart
X max<X extends Comparable<X>>(X x1, X x2) => x1.compareTo(x2) > 0 ? x1 : x2;

void main() {
  // Inferred as `max<num>(3, 7)` with the feature, fails without it.
  max(3, 7);
}
```

Com inferência usando limites, Dart pode *desconstruir* argumentos de tipo,
extraindo informações de tipo do limite de um parâmetro de tipo genérico.
Isso permite que funções como `f` no exemplo a seguir preservem tanto o
tipo específico de iterável (`List` ou `Set`) *quanto* o tipo de elemento.
Antes da inferência usando limites, isso não era possível
sem perder segurança de tipo ou informações de tipo específicas.

```dart
(X, Y) f<X extends Iterable<Y>, Y>(X x) => (x, x.first);

void main() {
  var (myList, myInt) = f([1]);
  myInt.whatever; // Compile-time error, `myInt` has type `int`.

  var (mySet, myString) = f({'Hello!'});
  mySet.union({}); // Works, `mySet` has type `Set<String>`.
}
```

Sem inferência usando limites, `myInt` teria o tipo `dynamic`.
O algoritmo de inferência anterior não detectaria a expressão incorreta
`myInt.whatever` em tempo de compilação, e lançaria em tempo de execução.
Por outro lado, `mySet.union({})` seria um erro em tempo de compilação
sem inferência usando limites, porque o algoritmo anterior não conseguia
preservar a informação de que `mySet` é um `Set`.

Para mais informações sobre o algoritmo de inferência usando limites,
leia o [documento de design][].


[F-bounded]: /language/generics/#f-bounds
[documento de design]: {{site.repo.dart.lang}}/blob/main/accepted/future-releases/3009-inference-using-bounds/design-document.md#motivating-example

## Substituindo tipos {:#substituting-types}

Quando você sobrescreve um método, está substituindo algo de um tipo (no
método antigo) com algo que pode ter um novo tipo (no novo método).
Da mesma forma, quando você passa um argumento para uma função,
está substituindo algo que tem um tipo (um parâmetro
com um tipo declarado) com algo que tem outro tipo
(o argumento real). Quando você pode substituir algo que
tem um tipo com algo que tem um subtipo ou um supertipo?

Ao substituir tipos, ajuda pensar em termos de _consumidores_
e _produtores_. Um consumidor absorve um tipo e um produtor gera um tipo.

**Você pode substituir o tipo de um consumidor por um supertipo e o tipo de um produtor
por um subtipo.**

Vejamos exemplos de atribuição de tipo simples e atribuição com
tipos genéricos.

### Atribuição de tipo simples {:#simple-type-assignment}

Ao atribuir objetos a objetos, quando você pode substituir um tipo por um
tipo diferente? A resposta depende se o objeto é um consumidor
ou um produtor.

Considere a seguinte hierarquia de tipos:

<img src="/assets/img/language/type-hierarchy.png" class="diagram-wrap" alt="uma hierarquia de animais onde o supertipo é Animal e os subtipos são Alligator, Cat e HoneyBadger. Cat tem os subtipos Lion e MaineCoon">

Considere a seguinte atribuição simples onde `Cat c` é um _consumidor_
e `Cat()` é um _produtor_:

<?code-excerpt "lib/strong_analysis.dart (Cat-Cat-ok)"?>
```dart
Cat c = Cat();
```

Em uma posição de consumo, é seguro substituir algo que consome um
tipo específico (`Cat`) com algo que consome qualquer coisa (`Animal`),
então substituir `Cat c` por `Animal c` é permitido, porque `Animal` é
um supertipo de `Cat`.

<?code-excerpt "lib/strong_analysis.dart (Animal-Cat-ok)"?>
```dart tag=passes-sa
Animal c = Cat();
```

Mas substituir `Cat c` por `MaineCoon c` quebra a segurança de tipo, porque a
superclasse pode fornecer um tipo de Cat com comportamentos diferentes, como
`Lion`:

<?code-excerpt "lib/strong_analysis.dart (MaineCoon-Cat-err)"?>
```dart tag=fails-sa
MaineCoon c = Cat();
```

Em uma posição de produção, é seguro substituir algo que produz um
tipo (`Cat`) com um tipo mais específico (`MaineCoon`). Então, o seguinte
é permitido:

<?code-excerpt "lib/strong_analysis.dart (Cat-MaineCoon-ok)"?>
```dart tag=passes-sa
Cat c = MaineCoon();
```

### Atribuição de tipo genérico {:#generic-type-assignment}

As regras são as mesmas para tipos genéricos? Sim. Considere a hierarquia
de listas de animais—uma `List` de `Cat` é um subtipo de uma `List` de
`Animal`, e um supertipo de uma `List` de `MaineCoon`:

<img src="/assets/img/language/type-hierarchy-generics.png" class="diagram-wrap" alt="List<Animal> -> List<Cat> -> List<MaineCoon>">

No exemplo a seguir,
você pode atribuir uma lista de `MaineCoon` a `myCats`
porque `List<MaineCoon>` é um subtipo de `List<Cat>`:

<?code-excerpt "lib/strong_analysis.dart (generic-type-assignment-MaineCoon)" replace="/<MaineCoon/<[!MaineCoon!]/g"?>
```dart tag=passes-sa
List<[!MaineCoon!]> myMaineCoons = ...
List<Cat> myCats = myMaineCoons;
```

E quanto a ir na outra direção?
Você pode atribuir uma lista de `Animal` a uma `List<Cat>`?

<?code-excerpt "lib/strong_analysis.dart (generic-type-assignment-Animal)" replace="/<Animal/<[!Animal!]/g"?>
```dart tag=fails-sa
List<[!Animal!]> myAnimals = ...
List<Cat> myCats = myAnimals;
```

Esta atribuição não passa na análise estática
porque cria um downcast implícito,
que não é permitido de tipos não-`dynamic` como `Animal`.

Para fazer este tipo de código passar na análise estática,
você pode usar uma conversão explícita.

<?code-excerpt "lib/strong_analysis.dart (generic-type-assignment-implied-cast)" replace="/as.*(?=;)/[!$&!]/g"?>
```dart
List<Animal> myAnimals = ...
List<Cat> myCats = myAnimals [!as List<Cat>!];
```

Uma conversão explícita ainda pode falhar em tempo de execução, no entanto,
dependendo do tipo real da lista sendo convertida (`myAnimals`).

### Métodos {:#methods}

Ao sobrescrever um método, as regras de produtor e consumidor ainda se aplicam.
Por exemplo:

<img src="/assets/img/language/consumer-producer-methods.png" class="diagram-wrap" alt="Classe Animal mostrando o método chase como consumidor e o getter parent como produtor">

Para um consumidor (como o método `chase(Animal)`), você pode substituir
o tipo de parâmetro por um supertipo. Para um produtor (como
o método getter `parent`), você pode substituir o tipo de retorno por
um subtipo.

Para mais informações, veja
[Use tipos de retorno sound ao sobrescrever métodos](#use-proper-return-types)
e [Use tipos de parâmetro sound ao sobrescrever métodos](#use-proper-param-types).

<a id="covariant-keyword" aria-hidden="true"></a>
#### Parâmetros covariantes {:#covariant-parameters}

Alguns padrões de código (raramente usados) dependem de apertar um tipo
sobrescrevendo o tipo de um parâmetro com um subtipo, o que é inválido.
Neste caso, você pode usar a palavra-chave `covariant` para
informar ao analisador que você está fazendo isso intencionalmente.
Isso remove o erro estático e, em vez disso, verifica se há um
tipo de argumento inválido em tempo de execução.

O seguinte mostra como você pode usar `covariant`:

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

Embora este exemplo mostre usando `covariant` no subtipo,
a palavra-chave `covariant` pode ser colocada no método da superclasse
ou no método da subclasse.
Geralmente o método da superclasse é o melhor lugar para colocá-la.
A palavra-chave `covariant` se aplica a um único parâmetro e também é
suportada em setters e campos.

## Outros recursos {:#other-resources}

Os seguintes recursos têm mais informações sobre Dart sound:

* [Corrigindo falhas de promoção de tipo](/tools/non-promotion-reasons) -
  Entenda e aprenda como corrigir erros de promoção de tipo.
* [Sound null safety](/null-safety) -
  Aprenda sobre escrever código com sound null safety.
* [Personalizando análise estática][analysis] -
  Como configurar e personalizar o analisador e linter
  usando um arquivo de opções de análise.


[analysis]: /tools/analysis
[language version]: /resources/language/evolution#language-versioning
[null safety]: /null-safety
