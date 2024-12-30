---
ia-translate: true
title: O sistema de tipos do Dart
description: Por que e como escrever código Dart sólido.
prevpage:
  url: /language/typedefs
  title: Typedefs
nextpage:
  url: /language/patterns
  title: Patterns
---
<?code-excerpt replace="/ *\/\/\s+ignore_for_file:[^\n]+\n//g; /([A-Z]\w*)\d\b/$1/g; /\b(main)\d\b/$1/g; /(^|\n) *\/\/\s+ignore:[^\n]+\n/$1/g; /(\n[^\n]+) *\/\/\s+ignore:[^\n]+\n/$1\n/g"?>
<?code-excerpt path-base="type_system"?>

A linguagem Dart é de tipo seguro: ela usa uma combinação de verificação de tipo
estática e [verificações de tempo de execução](#runtime-checks) para
garantir que o valor de uma variável sempre corresponda ao tipo estático da
variável, às vezes referida como tipagem sólida.
Embora _tipos_ sejam obrigatórios, _anotações_ de tipo são opcionais
por causa da [inferência de tipo](#type-inference).

Um benefício da verificação de tipo estática é a capacidade de encontrar
bugs em tempo de compilação usando o [analisador estático do Dart][analysis].

Você pode corrigir a maioria dos erros de análise estática adicionando
anotações de tipo a classes genéricas. As classes genéricas mais comuns
são os tipos de coleção `List<T>` e `Map<K,V>`.

Por exemplo, no código a seguir, a função `printInts()` imprime uma lista
de inteiros, e `main()` cria uma lista e a passa para `printInts()`.

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

O código anterior resulta em um erro de tipo em `list` (destacado acima) na
chamada de `printInts(list)`:

<?code-excerpt "analyzer-results-stable.txt" retain="/strong_analysis.*List.*argument_type_not_assignable/" replace="/-(.*?):(.*?):(.*?)-/-/g; /. • (lib|test)\/\w+\.dart:\d+:\d+//g"?>
```plaintext
error - O tipo do argumento 'List<dynamic>' não pode ser atribuído ao tipo do parâmetro 'List<int>'. - argument_type_not_assignable
```

O erro destaca uma conversão implícita não sólida de `List<dynamic>` para
`List<int>`. A variável `list` tem tipo estático `List<dynamic>`. Isso ocorre
porque a declaração de inicialização `var list = []` não fornece ao analisador
informações suficientes para inferir um argumento de tipo mais específico que
`dynamic`. A função `printInts()` espera um parâmetro do tipo `List<int>`,
causando uma incompatibilidade de tipos.

Ao adicionar uma anotação de tipo (`<int>`) na criação da lista
(destacado abaixo), o analisador reclama que um argumento de string
não pode ser atribuído a um parâmetro `int`. Remover as aspas em
`list.add('2')` resulta em um código que passa na análise estática e
é executado sem erros ou avisos.

<?code-excerpt "test/strong_test.dart (opening-example)" replace="/<int.(?=\[)|2/[!$&!]/g"?>
```dart tag=passes-sa
void printInts(List<int> a) => print(a);

void main() {
  final list = [!<int>!][!<int>!];
  list.add(1);
  list.add([!2!]);
  printInts(list);
}
```

[Experimente no DartPad]({{site.dartpad}}/?id=25074a51a00c71b4b000f33b688dedd0).

## O que é solidez?

*Solidez* é sobre garantir que seu programa não entre em determinados
estados inválidos. Um *sistema de tipos* sólido significa que você nunca
pode entrar em um estado em que uma expressão seja avaliada para um valor
que não corresponda ao tipo estático da expressão. Por exemplo, se o tipo
estático de uma expressão for `String`, em tempo de execução você tem a
garantia de obter apenas uma string ao avaliá-la.

O sistema de tipos do Dart, como os sistemas de tipos em Java e C#, é sólido.
Ele impõe essa solidez usando uma combinação de verificação estática
(erros em tempo de compilação) e verificações em tempo de execução.
Por exemplo, atribuir uma `String` a `int` é um erro em tempo de compilação.
Converter um objeto para uma `String` usando `as String` falha com um erro
em tempo de execução se o objeto não for uma `String`.

## Os benefícios da solidez

Um sistema de tipos sólido tem vários benefícios:

* Revelar bugs relacionados a tipos em tempo de compilação.<br>
  Um sistema de tipos sólido força o código a ser inequívoco sobre seus tipos,
  de modo que bugs relacionados a tipos que podem ser difíceis de encontrar em
  tempo de execução são revelados em tempo de compilação.

* Código mais legível.<br>
  O código é mais fácil de ler porque você pode confiar que um valor realmente
  tenha o tipo especificado. No Dart sólido, os tipos não podem mentir.

* Código mais fácil de manter.<br>
  Com um sistema de tipos sólido, quando você altera um trecho de código,
  o sistema de tipos pode avisá-lo sobre os outros trechos de código que
  acabaram de quebrar.

* Melhor compilação ahead-of-time (AOT).<br>
  Embora a compilação AOT seja possível sem tipos, o código gerado é muito
  menos eficiente.

## Dicas para passar na análise estática

A maioria das regras para tipos estáticos são fáceis de entender.
Aqui estão algumas das regras menos óbvias:

* Use tipos de retorno sólidos ao substituir métodos.
* Use tipos de parâmetro sólidos ao substituir métodos.
* Não use uma lista dinâmica como uma lista tipada.

Vamos ver essas regras em detalhes, com exemplos que usam a seguinte
hierarquia de tipos:

<img src="/assets/img/language/type-hierarchy.png" alt="uma hierarquia de animais onde o supertipo é Animal e os subtipos são Alligator, Cat e HoneyBadger. Cat tem os subtipos Lion e MaineCoon">

<a name="use-proper-return-types"></a>
### Use tipos de retorno sólidos ao substituir métodos

O tipo de retorno de um método em uma subclasse deve ser o mesmo tipo ou
um subtipo do tipo de retorno do método na superclasse.
Considere o método getter na classe `Animal`:

<?code-excerpt "lib/animal.dart (Animal)" replace="/Animal get.*/[!$&!]/g"?>
```dart
class Animal {
  void chase(Animal a) { ... }
  [!Animal get parent => ...!]
}
```

O método getter `parent` retorna um `Animal`. Na subclasse `HoneyBadger`,
você pode substituir o tipo de retorno do getter por `HoneyBadger`
(ou qualquer outro subtipo de `Animal`), mas um tipo não relacionado
não é permitido.

<?code-excerpt "lib/animal.dart (HoneyBadger)" replace="/(\w+)(?= get)/[!$&!]/g"?>
```dart tag=passes-sa
class HoneyBadger extends Animal {
  @override
  void chase(Animal a) { ... }

  @override
  [!HoneyBadger!] get parent => ...
}
```

<?code-excerpt "lib/animal.dart (HoneyBadger)" replace="/HoneyBadger get/[!Root!] get/g"?>
```dart tag=fails-sa
class HoneyBadger extends Animal {
  @override
  void chase(Animal a) { ... }

  @override
  [!Root!] get parent => ...
}
```

<a name="use-proper-param-types"></a>
### Use tipos de parâmetro sólidos ao substituir métodos

O parâmetro de um método substituído deve ter o mesmo tipo ou um
supertipo do parâmetro correspondente na superclasse.
Não "restrinja" o tipo do parâmetro substituindo o tipo por um
subtipo do parâmetro original.

:::note
Se você tiver um motivo válido para usar um subtipo, você pode usar a
palavra-chave [`covariant`](/deprecated/sound-problems#the-covariant-keyword).
:::

Considere o método `chase(Animal)` para a classe `Animal`:

<?code-excerpt "lib/animal.dart (Animal)" replace="/void chase.*/[!$&!]/g"?>
```dart
class Animal {
  [!void chase(Animal a) { ... }!]
  Animal get parent => ...
}
```

O método `chase()` recebe um `Animal`. Um `HoneyBadger` persegue qualquer coisa.
Não há problema em substituir o método `chase()` para receber qualquer coisa
(`Object`).

<?code-excerpt "lib/animal.dart (chase-Object)" replace="/Object/[!$&!]/g"?>
```dart tag=passes-sa
class HoneyBadger extends Animal {
  @override
  void chase([!Object!] a) { ... }

  @override
  Animal get parent => ...
}
```

O código a seguir restringe o parâmetro no método `chase()` de `Animal`
para `Mouse`, um subtipo de `Animal`.

<?code-excerpt "lib/incorrect_animal.dart (chase-mouse)" replace="/Mouse/[!$&!]/g"?>
```dart tag=fails-sa
class [!Mouse!] extends Animal { ... }

class Cat extends Animal {
  @override
  void chase([!Mouse!] a) { ... }
}
```

Este código não é seguro para tipos, pois seria possível definir
um gato e enviá-lo atrás de um jacaré:

<?code-excerpt "lib/incorrect_animal.dart (would-not-be-type-safe)" replace="/Alligator/[!$&!]/g"?>
```dart
Animal a = Cat();
a.chase([!Alligator!]()); // Não é seguro para tipos nem para felinos.
```

### Não use uma lista dinâmica como uma lista tipada

Uma lista `dynamic` é boa quando você quer ter uma lista com
diferentes tipos de coisas nela. No entanto, você não pode usar uma
lista `dynamic` como uma lista tipada.

Essa regra também se aplica a instâncias de tipos genéricos.

O código a seguir cria uma lista `dynamic` de `Dog` e a atribui a
uma lista do tipo `Cat`, o que gera um erro durante a análise estática.

<?code-excerpt "lib/incorrect_animal.dart (invalid-dynamic-list)" replace="/(<dynamic\x3E)(.*?)Error/[!$1!]$2Error/g"?>
```dart tag=fails-sa
void main() {
  List<Cat> foo = [!<dynamic>!][Dog()]; // Erro
  List<dynamic> bar = <dynamic>[Dog(), Cat()]; // OK
}
```

## Verificações em tempo de execução

Verificações em tempo de execução lidam com questões de segurança de tipo
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

## Inferência de tipo

O analisador pode inferir tipos para campos, métodos, variáveis locais
e a maioria dos argumentos de tipo genérico.
Quando o analisador não tem informações suficientes para inferir
um tipo específico, ele usa o tipo `dynamic`.

Aqui está um exemplo de como a inferência de tipo funciona com genéricos.
Neste exemplo, uma variável chamada `arguments` contém um mapa que
emparelha chaves de string com valores de vários tipos.

Se você digitar explicitamente a variável, você pode escrever isso:

<?code-excerpt "lib/strong_analysis.dart (type-inference-1-orig)" replace="/Map<String, dynamic\x3E/[!$&!]/g"?>
```dart
[!Map<String, dynamic>!] arguments = {'argA': 'hello', 'argB': 42};
```

Alternativamente, você pode usar `var` ou `final` e deixar o Dart inferir o tipo:

<?code-excerpt "lib/strong_analysis.dart (type-inference-1)" replace="/var/[!$&!]/g"?>
```dart
[!var!] arguments = {'argA': 'hello', 'argB': 42}; // Map<String, Object>
```

O literal do mapa infere seu tipo de suas entradas,
e então a variável infere seu tipo do tipo do literal do mapa.
Neste mapa, as chaves são ambas strings, mas os valores têm tipos diferentes
(`String` e `int`, que têm o limite superior `Object`).
Portanto, o literal do mapa tem o tipo `Map<String, Object>`,
e o mesmo acontece com a variável `arguments`.

### Inferência de campo e método

Um campo ou método que não tem tipo especificado e que substitui
um campo ou método da superclasse, herda o tipo do
método ou campo da superclasse.

Um campo que não tem um tipo declarado ou herdado, mas que é declarado
com um valor inicial, obtém um tipo inferido com base no valor inicial.

### Inferência de campo estático

Campos e variáveis estáticas têm seus tipos inferidos a partir de seu
inicializador. Observe que a inferência falha se encontrar um ciclo
(ou seja, inferir um tipo para a variável depende de saber o
tipo dessa variável).

### Inferência de variável local

Os tipos de variável local são inferidos de seu inicializador, se houver.
Atribuições subsequentes não são levadas em consideração.
Isso pode significar que um tipo muito preciso pode ser inferido.
Se for esse o caso, você pode adicionar uma anotação de tipo.

<?code-excerpt "lib/strong_analysis.dart (local-var-type-inference-error)"?>
```dart tag=fails-sa
var x = 3; // x é inferido como um int.
x = 4.0;
```

<?code-excerpt "lib/strong_analysis.dart (local-var-type-inference-ok)"?>
```dart tag=passes-sa
num y = 3; // Um num pode ser double ou int.
y = 4.0;
```

### Inferência de argumento de tipo

Argumentos de tipo para chamadas de construtor e
invocações de [método genérico](/language/generics#using-generic-methods)
são inferidos com base em uma combinação de informações descendentes do contexto
de ocorrência e informações ascendentes dos argumentos para o construtor
ou método genérico. Se a inferência não estiver fazendo o que você quer ou espera,
você sempre pode especificar explicitamente os argumentos de tipo.

<?code-excerpt "lib/strong_analysis.dart (type-arg-inference)"?>
```dart tag=passes-sa
// Inferido como se você escrevesse <int>[].
List<int> listOfInt = [];

// Inferido como se você escrevesse <double>[3.0].
var listOfDouble = [3.0];

// Inferido como Iterable<int>.
var ints = listOfDouble.map((x) => x.toInt());
```

No último exemplo, `x` é inferido como `double` usando informações descendentes.
O tipo de retorno do closure é inferido como `int` usando informações ascendentes.
O Dart usa esse tipo de retorno como informação ascendente ao inferir o
argumento de tipo do método `map()`: `<int>`.

## Substituindo tipos

Ao substituir um método, você está substituindo algo de um tipo (no
método antigo) por algo que pode ter um novo tipo (no novo método).
Da mesma forma, quando você passa um argumento para uma função,
você está substituindo algo que tem um tipo (um parâmetro
com um tipo declarado) por algo que tem outro tipo
(o argumento real). Quando você pode substituir algo que
tem um tipo por algo que tem um subtipo ou um supertipo?

Ao substituir tipos, ajuda pensar em termos de _consumidores_
e _produtores_. Um consumidor absorve um tipo e um produtor gera um tipo.

**Você pode substituir o tipo de um consumidor por um supertipo e o tipo
de um produtor por um subtipo.**

Vamos ver exemplos de atribuição de tipo simples e atribuição com
tipos genéricos.

### Atribuição de tipo simples

Ao atribuir objetos a objetos, quando você pode substituir um tipo por um
tipo diferente? A resposta depende se o objeto é um consumidor
ou um produtor.

Considere a seguinte hierarquia de tipos:

<img src="/assets/img/language/type-hierarchy.png" alt="uma hierarquia de animais onde o supertipo é Animal e os subtipos são Alligator, Cat e HoneyBadger. Cat tem os subtipos Lion e MaineCoon">

Considere a seguinte atribuição simples, onde `Cat c` é um _consumidor_
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

Mas substituir `Cat c` por `MaineCoon c` quebra a segurança de tipo, porque
a superclasse pode fornecer um tipo de `Cat` com comportamentos diferentes,
como `Lion`:

<?code-excerpt "lib/strong_analysis.dart (MaineCoon-Cat-err)"?>
```dart tag=fails-sa
MaineCoon c = Cat();
```

Em uma posição de produção, é seguro substituir algo que produz um
tipo (`Cat`) por um tipo mais específico (`MaineCoon`). Portanto, o seguinte
é permitido:

<?code-excerpt "lib/strong_analysis.dart (Cat-MaineCoon-ok)"?>
```dart tag=passes-sa
Cat c = MaineCoon();
```

### Atribuição de tipo genérico

As regras são as mesmas para tipos genéricos? Sim. Considere a hierarquia
de listas de animais — uma `List` de `Cat` é um subtipo de uma `List` de
`Animal` e um supertipo de uma `List` de `MaineCoon`:

<img src="/assets/img/language/type-hierarchy-generics.png" alt="List<Animal> -> List<Cat> -> List<MaineCoon>">

No exemplo a seguir,
você pode atribuir uma lista `MaineCoon` para `myCats`
porque `List<MaineCoon>` é um subtipo de `List<Cat>`:

<?code-excerpt "lib/strong_analysis.dart (generic-type-assignment-MaineCoon)" replace="/<MaineCoon/<[!MaineCoon!]/g"?>
```dart tag=passes-sa
List<[!MaineCoon!]> myMaineCoons = ...
List<Cat> myCats = myMaineCoons;
```

E quanto a ir na outra direção?
Você pode atribuir uma lista `Animal` para uma `List<Cat>`?

<?code-excerpt "lib/strong_analysis.dart (generic-type-assignment-Animal)" replace="/<Animal/<[!Animal!]/g"?>
```dart tag=fails-sa
List<[!Animal!]> myAnimals = ...
List<Cat> myCats = myAnimals;
```

Esta atribuição não passa na análise estática
porque cria uma conversão implícita,
que não é permitida de tipos não `dynamic` como `Animal`.

Para fazer com que esse tipo de código passe na análise estática,
você pode usar uma conversão explícita.

<?code-excerpt "lib/strong_analysis.dart (generic-type-assignment-implied-cast)" replace="/as.*(?=;)/[!$&!]/g"?>
```dart
List<Animal> myAnimals = ...
List<Cat> myCats = myAnimals [!as List<Cat>!];
```

Uma conversão explícita ainda pode falhar em tempo de execução, porém,
dependendo do tipo real da lista que está sendo convertida (`myAnimals`).

### Métodos

Ao substituir um método, as regras de produtor e consumidor ainda se aplicam.
Por exemplo:

<img src="/assets/img/language/consumer-producer-methods.png" alt="Classe Animal mostrando o método chase como consumidor e o getter parent como produtor">

Para um consumidor (como o método `chase(Animal)`), você pode substituir
o tipo de parâmetro por um supertipo. Para um produtor (como
o método getter `parent`), você pode substituir o tipo de retorno por
um subtipo.

Para obter mais informações, consulte
[Use tipos de retorno sólidos ao substituir métodos](#use-proper-return-types)
e [Use tipos de parâmetro sólidos ao substituir métodos](#use-proper-param-types).

## Outros recursos

Os seguintes recursos têm mais informações sobre o Dart sólido:

* [Corrigindo problemas comuns de tipo](/deprecated/sound-problems) -
  Erros que você pode encontrar ao escrever código Dart sólido e como corrigi-los.
* [Corrigindo falhas de promoção de tipo](/tools/non-promotion-reasons) -
  Entenda e aprenda como corrigir erros de promoção de tipo.
* [Segurança nula sólida](/null-safety) -
  Aprenda sobre como escrever código com segurança nula sólida.
* [Personalizando a análise estática][analysis] -
  Como configurar e personalizar o analisador e o linter
  usando um arquivo de opções de análise.
  

[analysis]: /tools/analysis
[language version]: /resources/language/evolution#language-versioning
[null safety]: /null-safety
