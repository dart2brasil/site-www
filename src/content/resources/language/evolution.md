---
ia-translate: true
title: Evolução da linguagem Dart
shortTitle: Evolução da linguagem
breadcrumb: Legacy
description: Mudanças e adições notáveis à linguagem de programação Dart.
lastVerified: 2026-08-12
---

:::warning
**Esta página foi descontinuada.**
Consulte o [Changelog](/changelog) para ver as mudanças na linguagem e no SDK,
e o [Versionamento da linguagem](/language/versioning) para entender como o versionamento é usado
com o Dart e com o SDK.
:::

Esta página lista mudanças e adições notáveis à
linguagem de programação Dart.

* Para aprender detalhes específicos sobre a versão mais recente da linguagem suportada,
  consulte a [documentação da linguagem][language documentation] ou a [especificação da linguagem][language specification].
* Para um histórico completo de mudanças no Dart SDK, veja o [changelog do SDK][SDK changelog].
* Para um histórico completo de mudanças incompatíveis,
  incluindo as mudanças [versionadas por linguagem][language versioned],
  consulte a página [Breaking changes][].

Para usar um recurso da linguagem introduzido após a versão 2.0,
defina uma [restrição de SDK][SDK constraint] não inferior à
versão em que o Dart passou a suportar esse recurso.

**Por exemplo:** para usar null safety, introduzido na [2.12][],
defina `2.12.0` como a restrição inferior no arquivo `pubspec.yaml`.

```yaml
environment:
  sdk: '>=2.12.0 <3.0.0'
```

[2.12]: #dart-2-12
[SDK constraint]: /tools/pub/pubspec#sdk-constraints
[language versioned]: /language/versioning
[Breaking changes]: /resources/breaking-changes

:::tip
Para acompanhar os recursos em discussão, em investigação e
adicionados à linguagem Dart,
confira o [rastreador de language funnel][language funnel]
no repositório do GitHub da linguagem Dart.
:::


## Mudanças em cada versão {:#changes-in-each-release}

### Dart 3.13
_Lançado em 12 de agosto de 2026_
| [Anúncio do Dart 3.13](/blog/announcing-dart-3-13)

O Dart 3.13 introduz [primary constructors][],
uma sintaxe concisa para declarar um construtor e
suas variáveis de instância diretamente no cabeçalho da declaração:

<?code-excerpt "language/lib/primary_constructors/primary_constructors.dart (empty-bodies)" replace="/EmptyBodyPoint/Point/g"?>
```dart
class Point(var int x, var int y);
```

Primary constructors reduzem o trabalho repetitivo de declarar campos,
receber parâmetros e atribuí-los no corpo do construtor.
Eles mudam como você escreve a declaração, não como ela se comporta em tempo de execução.

O Dart 3.13 também adiciona uma [sintaxe concisa de construtor][concise constructor syntax]
para construtores declarados no corpo da classe:
você pode escrever `new` ou `factory` em vez de repetir o nome da classe.

A versão também inclui as seguintes mudanças versionadas por linguagem na
saída do [`dart format`][]:

* Adiciona vírgulas finais para dividir cláusulas de representação de extension types.
* Melhora a divisão antecipada para evitar quebras de linha subótimas.
* Prefere dividir cadeias de chamadas com alvos de elemento único.
* Permite que listas de parâmetros usem formatação em bloco.
* Permite que expressões `as`, `is` e `is!` usem formatação em bloco.
* Separa os imports em seções distintas.
* Divide uma guarda `if-case` quando seu pattern usa formatação em bloco.
* Quando nenhuma solução de formatação cabe na largura da página,
  prefere linhas que transbordam e terminam em literais de string ou comentários.
* Adiciona linhas em branco ao redor de declarações `mixin` e `extension type`
  que não têm corpo com `;`.

Para mais informações sobre essas e outras mudanças,
consulte o [changelog do Dart 3.13][Dart 3.13 changelog].

[primary constructors]: /language/primary-constructors
[concise constructor syntax]: /language/constructors#concise-constructor-syntax
[`dart format`]: /tools/dart-format
[Dart 3.13 changelog]: {{site.repo.dart.sdk}}/blob/main/CHANGELOG.md#3130

### Dart 3.12
_Lançado em 18 de maio de 2026_
| [Anúncio do Dart 3.12](/blog/announcing-dart-3-12)

O Dart 3.12 introduz [private named parameters][], que permitem
inicializar campos privados diretamente por meio de [initializing formal parameters][].
Antes, inicializar um campo privado por um parâmetro nomeado
exigia atribuição manual na lista de inicializadores do construtor.

Agora, quando um initializing formal parameter se refere a um campo privado,
o Dart remove o underscore inicial (`_`) para derivar o nome público do parâmetro,
então quem chama usa o nome sem prefixo na chamada:

```dart
class Point {
  final int _x;
  final int _y;

  Point({required this._x, required this._y});
}

void main() {
  // Callers use the public, unprefixed names of the parameters.
  final point = Point(x: 1, y: 2);
}
```

[initializing formal parameters]: /language/constructors#use-initializing-formal-parameters
[private named parameters]: /language/constructors#private-named-parameters

### Dart 3.11
_Lançado em 9 de fevereiro de 2026_
| [Anúncio do Dart 3.11](/blog/announcing-dart-3-11)

Embora o Dart 3.11 não introduza novos recursos de linguagem,
a versão traz várias melhorias no suporte do analisador e do editor à
sintaxe [dot shorthand][], introduzida no Dart 3.10.

[dot shorthand]: /language/dot-shorthands

### Dart 3.10
_Lançado em 12 de novembro de 2025_
| [Anúncio do Dart 3.10](/blog/announcing-dart-3-10)

O Dart 3.10 introduz [dot shorthands][], uma sintaxe concisa
que permite omitir nomes explícitos de tipo ao acessar valores de enum,
membros estáticos ou construtores. Se o compilador conseguir inferir
o tipo pelo contexto, você pode simplesmente usar `.foo`
em vez de `ContextType.foo`.

<?code-excerpt "language/lib/shorthands/intro.dart"?>
```dart
// Use dot shorthand syntax on enums:
enum Status { none, running, stopped, paused }

Status currentStatus = .running; // Instead of Status.running

// Use dot shorthand syntax on a static method:
int port = .parse('8080'); // Instead of int.parse('8080')

// Uses dot shorthand syntax on a constructor:
class Point {
  final int x, y;
  Point(this.x, this.y);
  Point.origin() : x = 0, y = 0;
}

Point origin = .origin(); // Instead of Point.origin()
```

[dot shorthands]: /language/dot-shorthands

### Dart 3.9
_Lançado em 13 de agosto de 2025_
| [Anúncio do Dart 3.9](/blog/announcing-dart-3-9)


Os seguintes recursos de suporte foram atualizados para
o Dart 3.9:

*   Null safety: o Dart agora assume null safety ao
    calcular promoção de tipo, alcançabilidade e atribuição definitiva.
    Como resultado dessa mudança, mais avisos de `dead_code`
    podem ser produzidos.


*   O limite superior da versão do Flutter agora é respeitado: a partir da
    versão 3.9 da linguagem, o limite superior da [restrição de SDK do flutter][flutter SDK constraint]
    passa a ser respeitado no seu pacote raiz.

    Por exemplo, um arquivo `pubspec.yaml` com as seguintes restrições:

    ```yaml
    name: my_app
    environment:
      sdk: ^3.9.0
      flutter: 3.33.0
    ```

    Faz com que `dart pub get` falhe se for executado com uma versão do
    Flutter SDK diferente de `3.33.0`.
    O limite superior da restrição `flutter` ainda é ignorado em pacotes
    usados como dependências.
    Para mais contexto sobre essa mudança, veja [flutter/flutter#95472][].

Para mais informações sobre essas e outras mudanças, veja
o [changelog do Dart 3.9][Dart 3.9 changelog].

[Dart 3.9 changelog]: {{site.repo.dart.sdk}}/blob/main/CHANGELOG.md#390
[flutter SDK constraint]: /tools/pub/pubspec#flutter-sdk-constraints
[flutter/flutter#95472]: https://github.com/flutter/flutter/issues/95472

### Dart 3.8
_Lançado em 20 de maio de 2025_
| [Anúncio do Dart 3.8](/blog/announcing-dart-3-8)

Os seguintes recursos de linguagem foram adicionados ao Dart 3.8:

*   [Null-aware elements][]: um null-aware element avalia
    uma expressão em um literal de coleção e, se o resultado
    não for `null`, insere o valor na coleção que o envolve.

Os seguintes recursos de suporte foram atualizados:

*   [Dart format][]: o formatador do Dart 3.8 se baseia na
    reescrita da versão anterior, incorporando feedback,
    correções de bugs e outras melhorias. Agora ele decide
    automaticamente onde colocar vírgulas finais,
    escolhendo se divide ou não as construções em vez de forçá-las.
    A atualização também inclui mudanças de estilo para deixar
    a saída do código mais enxuta e melhor.

Para mais informações sobre essas e outras mudanças, veja
o [changelog do Dart 3.8][Dart 3.8 changelog].

[Null-aware elements]: /language/collections#null-aware-element
[Dart format]: {{site.repo.dart.sdk}}/blob/main/CHANGELOG.md#380
[Dart 3.8 changelog]: {{site.repo.dart.sdk}}/blob/main/CHANGELOG.md#380

### Dart 3.7
_Lançado em 12 de fevereiro de 2025_
| [Anúncio do Dart 3.7](/blog/announcing-dart-3-7)

O Dart 3.7 adicionou suporte a [wildcard variables][] na linguagem.
Uma wildcard variable é uma variável local ou parâmetro chamado `_`.
Wildcard variables não vinculam nada,
então podem ser declaradas várias vezes sem colisões.
Por exemplo:

```dart
Foo(_, this._, super._, void _()) {}
```

O comando `dart format` também passou a depender da versão da linguagem a partir da 3.7.
Se a versão da linguagem de um arquivo de entrada for 3.7 ou posterior, o código é formatado
com o novo estilo tall. 

O novo estilo parece com o que você obtém ao adicionar vírgulas finais
às listas de argumentos, exceto que agora o formatador adiciona e remove essas
vírgulas para você. Quando uma lista de argumentos ou parâmetros é dividida, ela é formatada
assim:

```dart
longFunction(
  longArgument,
  anotherLongArgument,
);
```

Você encontra mais detalhes no [changelog][dart-format].

[wildcard variables]: /language/variables#wildcard-variables
[dart-format]: {{site.repo.dart.sdk}}/blob/main/CHANGELOG.md#dart-format

### Dart 3.6
_Lançado em 11 de dezembro de 2024_
| [Anúncio do Dart 3.6](/blog/announcing-dart-3-6)

O Dart 3.6 adicionou suporte a underscores como [separadores de dígitos][digit separator] (`_`) na linguagem.
Separadores de dígitos melhoram a legibilidade de literais numéricos longos.

```dart
var m = 1__000_000__000_000__000_000;
```

[digit separator]: /language/built-in-types#digit-separators

### Dart 3.5
_Lançado em 6 de agosto de 2024_
| [Anúncio do Dart 3.5](/blog/announcing-dart-3-5-and-an-update-on-the-dart-roadmap)

O Dart 3.5 não adicionou recursos novos à linguagem, mas fez pequenas mudanças no
contexto considerado durante a inferência de tipos.
Elas incluem as seguintes mudanças, não versionadas por linguagem:

* Quando o contexto de uma expressão `await` é `dynamic`,
  o contexto do operando da expressão agora é `FutureOr<_>`.
* Quando o contexto de uma expressão if-null inteira (`e1 ?? e2`) é `dynamic`,
  o contexto de `e2` agora é o tipo estático de `e1`.

### Dart 3.4
_Lançado em 14 de maio de 2024_
| [Anúncio do Dart 3.4](/blog/announcing-dart-3-4)

O Dart 3.4 trouxe várias melhorias relacionadas à análise de tipos. Entre elas:

* Melhorias na análise de tipos de expressões condicionais,
  expressões if-null, atribuições e switch expressions.
* Alinhamento do tipo de contexto de pattern para cast patterns com a especificação.
* Torna o tipo do operador spread com null-aware (`...?`) anulável para literais de map e set,
  para igualar o comportamento dos literais de lista.

### Dart 3.3
_Lançado em 15 de fevereiro de 2024_
| [Anúncio do Dart 3.3](/blog/new-in-dart-3-3-extension-types-javascript-interop-and-more)

O Dart 3.3 trouxe algumas melhorias à linguagem:

* [Extension types][] são um novo recurso do Dart que permite envolver
  um tipo existente com custo zero. Eles são parecidos com classes wrapper e
  métodos de extensão, mas com diferenças de implementação e trade-offs diferentes.

  ```dart
  extension type Meters(int value) {
    String get label => '${value}m';
    Meters operator +(Meters other) => Meters(value + other.value);
  }

  void main() {
    var m = Meters(42); // Has type `Meters`.
    var m2 = m + m; // OK, type `Meters`.
    // int i = m; // Compile-time error, wrong type.
    // m.isEven; // Compile-time error, no such member.
    assert(identical(m, m.value)); // Succeeds.
  }
  ```

* Getters abstratos agora podem ser promovidos pelas regras de
  [private final field promotion][], desde que não haja declarações conflitantes.

### Dart 3.2
_Lançado em 15 de novembro de 2023_
| [Anúncio do Dart 3.2](/blog/announcing-dart-3-2)

O Dart 3.2 trouxe melhorias na análise de fluxo, incluindo:

* [Promoção de tipo](/null-safety/understanding-null-safety#type-promotion-on-null-checks) expandida
  para funcionar com campos privados final. Antes, isso valia apenas para
  variáveis locais e parâmetros; agora campos privados final podem ser promovidos a
  tipos não anuláveis por meio de verificações de null e testes `is`. Por exemplo,
  o código a seguir agora é seguro:

  ```dart
  class Example {
    final int? _privateField;
  
    Example(this._privateField);
  
    void f() {
      if (_privateField != null) {
        // _privateField has now been promoted; you can use it without
        // null checking it.
        int i = _privateField; // OK
      }
    }
  }
  
  // Private field promotions also work from outside of the class:
  void f(Example x) {
    if (x._privateField != null) {
      int i = x._privateField; // OK
    }
  }
  ```
  
  Para mais informações sobre quando campos privados final podem ou não ser promovidos, confira
  [Corrigindo falhas de promoção de tipo](/tools/non-promotion-reasons).

* Inconsistências corrigidas no comportamento de promoção de tipo de
  instruções [if-case](/language/branches#if-case) em que o valor
  comparado lança uma exceção.


### Dart 3.1
_Lançado em 16 de agosto de 2023_
| [Anúncio do Dart 3.1](/blog/dart-3-1-a-retrospective-on-functional-style-programming-in-dart-3)

O Dart 3.1 não adicionou novos recursos nem fez mudanças na linguagem.

### Dart 3.0
_Lançado em 10 de maio de 2023_
| [Anúncio do Dart 3.0](/blog/announcing-dart-3)

O Dart 3.0 introduziu vários recursos novos e importantes na linguagem:

* [Patterns][], uma nova categoria de gramática que permite
  comparar e desestruturar valores.
* [Records][], um novo tipo que permite agregar
  vários valores de tipos diferentes em um único retorno de função.
* [Class modifiers][], um novo conjunto de palavras-chave que permite
  controlar como uma classe ou mixin pode ser usada.
* [Switch expressions][], uma nova forma de desvio com múltiplas
  ramificações, permitida onde se espera uma expressão.
* [If-case clauses][], uma nova construção condicional que compara um valor
  com um pattern e executa o ramo then ou else, dependendo
  de o pattern corresponder ou não.

O Dart 3.0 também introduziu algumas mudanças incompatíveis na linguagem:

* Declarações de classe sem o modificador de classe [`mixin`][] não podem mais
  ser usadas como mixins.
* Agora é um erro de tempo de compilação usar dois-pontos (`:`) como separador
  antes do valor padrão de um parâmetro nomeado opcional.
  Use o sinal de igual (`=`) no lugar.
* Agora é um erro de tempo de compilação se uma instrução `continue` aponta para um
  label que não está associado a uma instrução de loop (`for`, `do` e `while`)
  nem a um membro `switch`.

:::note
A versão 3.0 do SDK do Dart deixou de suportar
[versões da linguagem][language versions] anteriores à 2.12.
:::

[Patterns]: /language/patterns
[Records]: /language/records
[Class modifiers]: /language/class-modifiers
[Switch expressions]: /language/branches#switch-expressions
[If-case clauses]: /language/branches#if-case
[`mixin`]: /language/mixins#class-mixin-or-mixin-class
[language versions]: /language/versioning

### Dart 2.19
_Lançado em 25 de janeiro de 2023_

O Dart 2.19 introduziu algumas precauções em torno da inferência de tipos.
Entre elas:

* Mais flags de análise de fluxo para casos de código inalcançável.
* Nomes privados inacessíveis não são mais delegados a `noSuchMethod`.
* A inferência de tipos no nível superior lança erro em dependências cíclicas.

O Dart 2.19 também introduziu suporte a bibliotecas sem nome.
Diretivas de biblioteca, usadas para anexar comentários de documentação e
anotações no nível da biblioteca, agora podem e [devem][should] ser escritas sem nome:

```dart
/// A really great test library.
@TestOn('browser')
library;
```

[should]: /effective-dart/style#dont-explicitly-name-libraries

### Dart 2.18
_Lançado em 30 de agosto de 2022_
| [Anúncio do Dart 2.18](/blog/dart-2-18-objective-c-swift-interop)

O Dart 2.18 aprimorou a inferência de tipos.
Essa mudança permite o fluxo de informações entre argumentos em chamadas de funções genéricas.
Antes da 2.18, se você não especificasse o tipo de um argumento em alguns métodos,
o Dart reportava erros.
Esses erros de tipo apontavam possíveis ocorrências de null.
Com a 2.18, o compilador infere o tipo do argumento
a partir de outros valores na invocação.
Você não precisa especificar o tipo do argumento na linha.

O Dart 2.18 também descontinuou o suporte a mixin classes que não estendem
`Object`.

Para saber mais sobre esses recursos, confira:

* [Inferência de argumentos de tipo][Type argument inference]
* [Adicionando recursos a uma classe: mixins][Adding features to a class: mixins]

[Type argument inference]: /language/type-system#type-argument-inference
[Adding features to a class: mixins]: /language/mixins

### Dart 2.17
_Lançado em 11 de maio de 2022_
| [Anúncio do Dart 2.17](/blog/dart-2-17-productivity-and-integration)

O Dart 2.17 expandiu a funcionalidade de enums com os enhanced enums.
Enhanced enums permitem que declarações de enum definam membros,
incluindo campos, construtores, métodos, getters, etc.

O Dart 2.17 adicionou suporte a super-initializer parameters em
construtores. Super parameters permitem que você evite passar manualmente cada
parâmetro na invocação super de um construtor não redirecionador.
Em vez disso, você pode usar super parameters para repassar parâmetros para
um construtor da superclasse.

O Dart 2.17 removeu algumas restrições sobre argumentos nomeados.
Argumentos nomeados agora podem ser intercalados livremente com argumentos posicionais.
A partir do Dart 2.17, você pode escrever o seguinte código:

```dart
void main() {
  test(skip: true, 'A test description', () {
    // Very long function body here...
  });
}
```

Para saber mais sobre esses recursos, confira:

* [Enhanced enums][]
* [Super parameters][]
* [Named parameters][]

[Enhanced enums]: /language/enums#declaring-enhanced-enums
[Super parameters]: /language/constructors#super-parameters
[Named parameters]: /language/functions#named-parameters

### Dart 2.16
_Lançado em 3 de fevereiro de 2022_
| [Anúncio do Dart 2.16](/blog/announcing-dart-2-15)

O Dart 2.16 não adicionou novos recursos à linguagem Dart.
Ele, porém, expandiu as ferramentas do Dart.

### Dart 2.15
_Lançado em 8 de dezembro de 2021_
| [Anúncio do Dart 2.15](/blog/announcing-dart-2-15)

O Dart 2.15 melhorou o suporte a ponteiros de função, conhecidos como _tear-offs._
Em especial, agora há suporte a tear-offs de construtores.

### Dart 2.14
_Lançado em 8 de setembro de 2021_
| [Anúncio do Dart 2.14](/blog/announcing-dart-2-14)

O Dart 2.14 adicionou o operador de shift sem sinal (ou _triple-shift_) (`>>>`).
Esse novo operador funciona como `>>`,
exceto que sempre preenche os bits mais significativos com zeros.

Para saber mais sobre esses operadores, confira [bitwise and shift operators][].

[bitwise and shift operators]: /language/operators#bitwise-and-shift-operators

O Dart 2.14 também removeu algumas restrições sobre argumentos de tipo.
Você pode passar argumentos de tipo para anotações e usar um tipo de função genérica
como argumento de tipo.
A partir do Dart 2.14, você pode escrever o seguinte código:

```dart
@TypeHelper<int>(42, "The meaning")
late List<T Function<T>(T)> idFunctions;
var callback = [<T>(T value) => value];
late S Function<S extends T Function<T>(T)>(S) f;
```

### Dart 2.13
_Lançado em 19 de maio de 2021_
| [Anúncio do Dart 2.13](/blog/announcing-dart-2-13)

O Dart 2.13 ampliou o suporte a **[type aliases][]** (`typedef`).
Type aliases antes funcionavam apenas para tipos de função,
mas agora funcionam para qualquer tipo.
Você pode usar o novo nome criado com um type alias
em qualquer lugar onde o tipo original poderia ser usado.

O Dart 2.13 melhorou o suporte a structs no **[Dart FFI][]**,
adicionando suporte a arrays inline e structs compactadas (packed).

### Dart 2.12
_Lançado em 3 de março de 2021_
| [Anúncio do Dart 2.12](/blog/announcing-dart-2-12)

O Dart 2.12 adicionou suporte a **[sound null safety][]**.
Quando você ativa o null safety, os tipos do seu código são não anuláveis por padrão,
o que significa que variáveis não podem conter null, a menos que você diga que podem.
Com null safety, os erros de desreferência de null em tempo de execução
viram erros de análise durante a edição.

No Dart 2.12, o **[Dart FFI][]** saiu da versão beta e passou para o canal estável.

### Dart 2.10
_Lançado em 1 de outubro de 2020_
| [Anúncio do Dart 2.10](/blog/announcing-dart-2-10)

O Dart 2.10 não adicionou novos recursos à linguagem Dart.

### Dart 2.9
_Lançado em 5 de agosto de 2020_

O Dart 2.9 não adicionou novos recursos à linguagem Dart.

### Dart 2.8
_Lançado em 6 de maio de 2020_
| [Anúncio do Dart 2.8](/blog/announcing-dart-2-8)

O Dart 2.8 não adicionou recursos à linguagem Dart. Ele trouxe várias
[mudanças incompatíveis][2.8 breaking changes] preparatórias para
melhorar a usabilidade e o desempenho relacionados à anulabilidade, para o [null safety][].

### Dart 2.7
_Lançado em 11 de dezembro de 2019_
| [Anúncio do Dart 2.7](/blog/announcing-dart-2-7-a-safer-more-expressive-dart)

O Dart 2.7 adicionou suporte a **[métodos de extensão][extension methods]**,
permitindo adicionar funcionalidade a qualquer tipo
—-mesmo tipos que você não controla—-
com a concisão e a experiência de autocompletar de chamadas de método comuns.

O exemplo a seguir estende a classe `String` de
`dart:core` com um novo método `parseInt()`:

```dart
extension ParseNumbers on String {
  int parseInt() {
    return int.parse(this);
  }
}

void main() {
  int i = '42'.parseInt();
  print(i);
}
```

### Dart 2.6
_Lançado em 5 de novembro de 2019_
| [Anúncio do Dart 2.6](/blog/announcing-dart-2-6-with-dart2native-compile-dart-to-self-contained-native-executables)

O Dart 2.6 introduziu uma
[mudança incompatível (dart-lang/sdk#37985)]({{site.repo.dart.sdk}}/issues/37985).
Restrições em que `Null` atua como subtipo de `FutureOr<T>`
agora resultam em `Null` como solução para `T`.

Por exemplo: o código a seguir agora imprime `Null`.
Antes do Dart 2.6, ele imprimia `dynamic`.
O closure anônimo `() {}` retorna o tipo `Null`.

```dart
import 'dart:async';

void foo<T>(FutureOr<T> Function() f) { print(T); }

main() { foo(() {}); }
```

### Dart 2.5
_Lançado em 10 de setembro de 2019_
| [Anúncio do Dart 2.5](/blog/announcing-dart-2-5-super-charged-development)

O Dart 2.5 não adicionou recursos à linguagem Dart, mas adicionou
suporte a [chamada de código C nativo][calling native C code] a partir do código Dart
usando uma nova **biblioteca core, `dart:ffi`.**

### Dart 2.4
_Lançado em 27 de junho de 2019_


O Dart 2.4 introduz uma mudança incompatível
[dart-lang/sdk#35097]({{site.repo.dart.sdk}}/issues/35097).

Agora o Dart impõe covariância de variáveis de tipo usadas em super-interfaces.
Por exemplo: antes desta versão o Dart aceitava, mas agora rejeita,
o código a seguir:

```dart
class A<X> {};
class B<X> extends A<void Function(X)> {};
```

Agora você pode usar `async` como identificador em
funções assíncronas e geradoras.

### Dart 2.3
_Lançado em 8 de maio de 2019_
| [Anúncio do Dart 2.3](/blog/announcing-dart-2-3-optimized-for-building-user-interfaces)

O Dart 2.3 adicionou três operadores pensados para melhorar código que manipula
listas, como código declarativo de UI.

O **[operador spread][spread operator]**
permite desempacotar os elementos de uma lista em outra.
No exemplo a seguir, a lista retornada por `buildMainElements()`
é desempacotada na lista passada ao argumento `children`:

```dart
Widget build(BuildContext context) {
  return Column(children: [
    Header(),
    ...buildMainElements(),
    Footer(),
  ]);
}
```

O operador **[collection if][collection if]** permite adicionar elementos condicionalmente.
O exemplo a seguir adiciona um elemento `FlatButton` a menos que
o app esteja exibindo a última página:

```dart
Widget build(BuildContext context) {
  return Column(children: [
    Text(mainText),
    if (page != pages.last)
      FlatButton(child: Text('Next')),
  ]);
}
```

O operador **[collection for][collection for]** permite construir elementos repetidos.
O exemplo a seguir adiciona um elemento `HeadingAction` para
cada seção em `sections`:

```dart
Widget build(BuildContext context) {
  return Column(children: [
    Text(mainText),
    for (var section in sections)
      HeadingAction(section.heading),
  ]);
}
```


### Dart 2.2
_Lançado em 26 de fevereiro de 2019_
| [Anúncio do Dart 2.2](/blog/announcing-dart-2-2-faster-native-code-support-for-set-literals)

O Dart 2.2 adicionou suporte a **[set literals][]**:

```dart
const Set<String> currencies = {'EUR', 'USD', 'JPY'};
```

### Dart 2.1
_Lançado em 15 de novembro de 2018_
| [Anúncio do Dart 2.1](/blog/announcing-dart-2-1-improved-performance-usability)

O Dart 2.1 adicionou suporte a **conversão de int para double**,
permitindo que desenvolvedores definam valores `double` usando literais inteiros.
Esse recurso eliminou o incômodo de ser obrigado a usar um literal `double`
(por exemplo, `4.0`) quando o valor era, conceitualmente, um inteiro.

No código Flutter a seguir, `horizontal` e `vertical` têm tipo `double`:

```dart
padding: const EdgeInsets.symmetric(
  horizontal: 4,
  vertical: 8,
)
```

### Dart 2.0
_Lançado em 22 de fevereiro de 2018_
| [Anúncio do Dart 2.0](/blog/announcing-dart-2-optimized-for-client-side-development)

O Dart 2.0 implementou um novo **[sound type system][]**.
Antes do Dart 2.0, os tipos não eram totalmente sólidos, e
o Dart dependia muito da verificação de tipos em tempo de execução.
Código do Dart 1.x precisava ser migrado para o Dart 2.

<a id="language-version-numbers" aria-hidden="true"></a>
<a id="per-library-language-version-selection" aria-hidden="true"></a>

## Versionamento da linguagem {:#language-versioning}

:::warning Documentação movida
Este conteúdo foi movido para uma
página dedicada sobre o [versionamento da linguagem Dart](/language/versioning).
:::

[2.8 breaking changes]: {{site.repo.dart.sdk}}/issues/40686
[calling native C code]: /interop/c-interop
[collection for]: /language/collections#control-flow-operators
[collection if]: /language/collections#control-flow-operators
[Dart library]: /tools/pub/create-packages#organizing-a-package
[Dart FFI]: /interop/c-interop
[extension methods]: /language/extension-methods
[Extension types]: /language/extension-types
[language funnel]: {{site.repo.dart.lang}}/projects/1
[language specification]: /resources/language/spec
[language documentation]: /language
[null safety]: /null-safety
[private final field promotion]: /tools/non-promotion-reasons
[SDK changelog]: {{site.repo.dart.sdk}}/blob/main/CHANGELOG.md
[set literals]: /language/collections#sets
[sound null safety]: /null-safety
[sound type system]: /language/type-system
[spread operator]: /language/collections#spread-operators
[type aliases]: /language/typedefs
