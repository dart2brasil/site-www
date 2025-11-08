---
title: Dart language evolution
shortTitle: Language evolution
breadcrumb: Evolution
description: Notable changes and additions to the Dart programming language.
lastVerified: 2024-08-04
---

Esta página lista mudanças e adições notáveis à
linguagem de programação Dart.

* Para aprender detalhes específicos sobre a versão de linguagem suportada mais recente,
  confira a [documentação da linguagem][documentação da linguagem] ou a [especificação da linguagem][especificação da linguagem].
* Para um histórico completo de mudanças no SDK Dart, veja o [changelog do SDK][changelog do SDK].
* Para um histórico completo de mudanças de quebra (breaking changes),
  incluindo mudanças com [versionamento da linguagem][versionamento da linguagem],
  confira a página [Mudanças de quebra][Mudanças de quebra].

Para usar um recurso de linguagem introduzido após a versão 2.0,
defina uma [restrição de SDK][restrição de SDK] não inferior à
versão quando o Dart começou a dar suporte a esse recurso.

**Por exemplo:** Para usar null safety (segurança nula), introduzido em [2.12][2.12],
defina `2.12.0` como a restrição inferior no arquivo `pubspec.yaml`.

```yaml
environment:
  sdk: '>=2.12.0 <3.0.0'
```

[2.12]: #dart-2-12
[restrição de SDK]: /tools/pub/pubspec#sdk-constraints
[versionamento da linguagem]: #language-versioning
[Mudanças de quebra]: /resources/breaking-changes

:::tip
Para revisar os recursos que estão sendo discutidos, investigados e
adicionados à linguagem Dart,
confira o rastreador do [funil da linguagem][funil da linguagem]
no repositório da linguagem Dart no GitHub.
:::


## Mudanças em cada versão {:#changes-in-each-release}

### Dart 3.9
_Released 13 August 2025_
| [Dart 3.9 announcement](https://blog.dart.dev/announcing-dart-3-9-ba49e8f38298)


The following supporting features have been updated for
Dart 3.9:

*   Null safety: Dart now assumes null safety when
    computing type promotion, reachability, and definite assignment.
    As a result of this change, more `dead_code` warnings
    might be produced.


*   Flutter upper version bound is now respected: Starting from
    language version 3.9, the [flutter SDK constraint][] upper bound
    is now respected in your root package.

    For example, a `pubspec.yaml` file with the following constraints:

    ```yaml
    name: my_app
    environment:
      sdk: ^3.9.0
      flutter: 3.33.0
    ```

    Results in `dart pub get` failing if invoked with a version of
    the Flutter SDK different from `3.33.0`.
    The upper bound of the `flutter` constraint is
    still ignored in packages used as dependencies.
    For more background on this change, see [flutter/flutter#95472][].

For more information about these and additional changes, see
the [Dart 3.9 changelog][].

[Dart 3.9 changelog]: {{site.repo.dart.sdk}}/blob/main/CHANGELOG.md#390
[flutter SDK constraint]: /tools/pub/pubspec#flutter-sdk-constraints
[flutter/flutter#95472]: https://github.com/flutter/flutter/issues/95472

### Dart 3.8
_Released 20 May 2025_
| [Dart 3.8 announcement](https://blog.dart.dev/announcing-dart-3-8-724eaaec9f47)

The following language features have been added to Dart 3.8:

*   [Null-aware elements][]: A null-aware element evaluates
    an expression in a collection literal and if the result
    is not `null`, inserts the value into the surrounding
    collection.

The following supporting features have been updated:

*   [Dart format][]: Dart 3.8's formatter builds on the
    previous release's rewrite, incorporating feedback,
    bug fixes, and further enhancements. It now
    intelligently automates trailing comma placement,
    deciding whether to split constructs rather than forcing
    them. The update also includes style changes to tighten
    and improve code output.
    
For more information about these and additional changes, see
the [Dart 3.8 changelog][].

[Null-aware elements]: /language/collections#null-aware-element
[Dart format]: {{site.repo.dart.sdk}}/blob/main/CHANGELOG.md#380
[Dart 3.8 changelog]: {{site.repo.dart.sdk}}/blob/main/CHANGELOG.md#380

### Dart 3.7
_Released 12 February 2025_
| [Dart 3.7 announcement](https://blog.dart.dev/announcing-dart-3-7-bf864a1b195c)

Dart 3.7 added support for [wildcard variables][] to the language.
A wildcard variable is a local variable or parameter named `_`.
Wildcard variables are non-binding,
so they can be declared multiple times without collisions.
For example:

```dart
Foo(_, this._, super._, void _()) {}
```

The `dart format` command is also now tied to the language version as of 3.7.
If the language version of an input file is 3.7 or later, the code is formatted
with the new tall style. 

The new style looks similar to the style you get when you add trailing commas
to argument lists, except that now the formatter will add and remove those
commas for you. When an argument or parameter lists splits, it is formatted
like so:

```dart
longFunction(
  longArgument,
  anotherLongArgument,
);
```

You can find more details in the [changelog][dart-format].

[wildcard variables]: /language/variables#wildcard-variables
[dart-format]: {{site.repo.dart.sdk}}/blob/main/CHANGELOG.md#dart-format

### Dart 3.6
_Released 11 December 2024_
| [Dart 3.6 announcement](https://blog.dart.dev/announcing-dart-3-6-778dd7a80983)

O Dart 3.6 adicionou suporte a underscores (`_`) como [separador de dígitos][separador de dígitos] à linguagem.
Separadores de dígitos melhoram a legibilidade de literais numéricos longos.

```dart
var m = 1__000_000__000_000__000_000;
```

[separador de dígitos]: /language/built-in-types#digit-separators

### Dart 3.5
_Released 6 August 2024_
| [Dart 3.5 announcement](https://blog.dart.dev/dart-3-5-6ca36259fa2f)

O Dart 3.5 não adicionou nenhum recurso novo de linguagem, mas fez pequenas alterações no
contexto considerado durante a inferência de tipo.
Estas incluem as seguintes alterações não versionadas pela linguagem:

* Quando o contexto para uma expressão `await` é `dynamic` (dinâmico),
  o contexto para o operando da expressão agora é `FutureOr<_>`.
* Quando o contexto para uma expressão if-null (se-nulo) inteira (`e1 ?? e2`) é `dynamic` (dinâmico),
  o contexto para `e2` agora é o tipo estático de `e1`.

### Dart 3.4
_Released 14 May 2024_
| [Dart 3.4 announcement](https://blog.dart.dev/dart-3-4-bd8d23b4462a)

O Dart 3.4 fez diversas melhorias relacionadas à análise de tipo. Estas incluem:

* Melhorias na análise de tipo de expressões condicionais,
  expressões if-null (se-nulo) e atribuições, e expressões switch (mudar).
* Alinhando o esquema de tipo de contexto de pattern (padrão) para padrões de cast (conversão) com a especificação.
* Tornando o esquema de tipo para o operador spread (espalhar) com reconhecimento de nulo (`...?`)
  nullable (anulável) para mapas e literais de conjunto, para corresponder ao comportamento de literais de lista.

### Dart 3.3
_Released 15 February 2024_
| [Dart 3.3 announcement](https://blog.dart.dev/dart-3-3-325bf2bf6c13)

O Dart 3.3 adicionou alguns aprimoramentos à linguagem:

* [Tipos de extensão][Tipos de extensão] são um novo recurso no Dart que permitem o embrulho de custo zero
  de um tipo existente. Eles são semelhantes às classes wrapper (invólucro) e métodos de extensão,
  mas com diferenças de implementação e diferentes vantagens e desvantagens.

  ```dart
  extension type Metros(int value) {
    String get label => '${value}m';
    Metros operator +(Metros other) => Metros(value + other.value);
  }

  void main() {
    var m = Metros(42); // Tem tipo `Metros`.
    var m2 = m + m; // OK, tipo `Metros`.
    // int i = m; // Erro de tempo de compilação, tipo errado.
    // m.isEven; // Erro de tempo de compilação, nenhum membro desse tipo.
    assert(identical(m, m.value)); // Sucesso.
  }
  ```

* Getters abstratos agora podem ser promovidos sob as regras de
  [promoção de campo final privado][promoção de campo final privado], se não houver declarações conflitantes.

### Dart 3.2
_Released 15 November 2023_
| [Dart 3.2 announcement](https://blog.dart.dev/dart-3-2-c8de8fe1b91f)

O Dart 3.2 adicionou aprimoramentos à análise de fluxo, incluindo:

* [Promoção de tipo](/null-safety/understanding-null-safety#type-promotion-on-null-checks) expandida
  para funcionar em campos finais privados. Anteriormente disponível apenas para
  variáveis e parâmetros locais, agora campos finais privados podem ser promovidos para
  tipos não anuláveis por meio de verificações de nulo e testes `is`. Por exemplo,
  o seguinte código agora é _sound_:

  ```dart
  class Exemplo {
    final int? _campoPrivado;
  
    Exemplo(this._campoPrivado);
  
    void f() {
      if (_campoPrivado != null) {
        // _campoPrivado foi promovido agora; você pode usá-lo sem
        // verificá-lo quanto a nulo.
        int i = _campoPrivado; // OK
      }
    }
  }
  
  // Promoções de campo privado também funcionam de fora da classe:
  void f(Exemplo x) {
    if (x._campoPrivado != null) {
      int i = x._campoPrivado; // OK
    }
  }
  ```
  
  Para obter mais informações sobre quando campos finais privados podem e não podem promover, confira
  [Corrigindo falhas de promoção de tipo](/tools/non-promotion-reasons).

* Inconsistências corrigidas no comportamento de promoção de tipo de
  instruções [if-case](/language/branches#if-case)
  onde o valor que está sendo comparado gera uma exceção.
  

### Dart 3.1 {:#dart-3-1}
_Lançado em 16 de agosto de 2023_
| [Anúncio do Dart 3.1](https://medium.com/dartlang/dart-3-1-a-retrospective-on-functional-style-programming-in-dart-3-a1f4b3a7cdda)

### Dart 3.1
_Released 16 August 2023_
| [Dart 3.1 announcement](https://blog.dart.dev/dart-3-1-a-retrospective-on-functional-style-programming-in-dart-3-a1f4b3a7cdda)

### Dart 3.0 {:#dart-3-0}
_Lançado em 10 de maio de 2023_
| [Anúncio do Dart 3.0](https://medium.com/dartlang/announcing-dart-3-53f065a10635)

### Dart 3.0
_Released 10 May 2023_
| [Dart 3.0 announcement](https://blog.dart.dev/announcing-dart-3-53f065a10635)

* [Patterns (Padrões)][Patterns], uma nova categoria de gramática que permite
  comparar e desestruturar valores.
* [Records (Registros)][Records], um novo tipo que permite agregar
  vários valores de diferentes tipos em um único retorno de função.
* [Modificadores de classe][Modificadores de classe], um novo conjunto de palavras-chave que permitem
  controlar como uma classe ou mixin pode ser usado.
* [Expressões switch (mudar)][Expressões switch (mudar)], uma nova forma de ramificação (branching) de várias vias
  permitida onde expressões são esperadas.
* [Cláusulas if-case][Cláusulas if-case], uma nova construção condicional que compara um valor
  com um padrão e executa o branch (ramificação) then ou else, dependendo
  se o padrão corresponde ou não.

O Dart 3.0 também introduziu algumas mudanças de quebra de linguagem:

* Declarações de classe sem o modificador de classe [`mixin`][`mixin`]
  não podem mais ser aplicadas como mixins.
* Agora é um erro de tempo de compilação se dois pontos (`:`) forem usados como separador
  antes do valor padrão de um parâmetro nomeado opcional.
  Use um sinal de igual (`=`) em vez disso.
* Agora é um erro de tempo de compilação se uma instrução `continue` tiver como alvo um
  label (rótulo) que não esteja anexado a uma
  instrução de loop (`for`, `do` e `while`) ou um membro `switch`.

:::note
A versão 3.0 do SDK Dart removeu o suporte para
[versões de linguagem][versões de linguagem] anteriores à 2.12.
:::

[Patterns]: /language/patterns
[Records]: /language/records
[Modificadores de classe]: /language/class-modifiers
[Expressões switch (mudar)]: /language/branches#switch-expressions
[Cláusulas if-case]: /language/branches#if-case
[`mixin`]: /language/mixins#class-mixin-or-mixin-class
[versões de linguagem]: #language-versioning

### Dart 2.19 {:#dart-2-19}
_Lançado em 25 de janeiro de 2023_

O Dart 2.19 introduziu algumas precauções em torno da inferência de tipo.
Estas incluem:

* Mais _flags_ de análise de fluxo para casos de código inacessíveis.
* Não delegar mais nomes privados inacessíveis para `noSuchMethod`.
* A inferência de tipo de nível superior gera erros em dependências cíclicas.

O Dart 2.19 também introduziu suporte para bibliotecas sem nome.
Diretivas de biblioteca, usadas para anexar comentários de doc em nível de biblioteca e
anotações, podem e [devem][devem] agora ser escritas sem um nome:

```dart
/// Uma ótima biblioteca de teste.
@TestOn('browser')
library;
```

[devem]: /effective-dart/style#dont-explicitly-name-libraries

### Dart 2.18
_Released 30 August 2022_
| [Dart 2.18 announcement](https://blog.dart.dev/dart-2-18-f4b3101f146c)

O Dart 2.18 aprimorou a inferência de tipo.
Essa alteração permite o fluxo de informações entre argumentos em chamadas de função genéricas.
Antes do 2.18, se você não especificasse o tipo de um argumento em alguns métodos,
o Dart relatava erros.
Esses erros de tipo citavam possíveis ocorrências de nulo.
Com o 2.18, o compilador infere o tipo do argumento
de outros valores em uma invocação.
Você não precisa especificar o tipo do argumento inline.

O Dart 2.18 também descontinuou o suporte para classes mixin que não estendem
`Object`.

Para saber mais sobre esses recursos, confira:

* [Inferência de argumento de tipo][Inferência de argumento de tipo]
* [Adicionando recursos a uma classe: mixins][Adicionando recursos a uma classe: mixins]

[Inferência de argumento de tipo]: /language/type-system#type-argument-inference
[Adicionando recursos a uma classe: mixins]: /language/mixins

### Dart 2.17
_Released 11 May 2022_
| [Dart 2.17 announcement](https://blog.dart.dev/dart-2-17-b216bfc80c5d)

O Dart 2.17 expandiu a funcionalidade enum com enums aprimorados.
Enums aprimorados permitem que declarações enum definam membros
incluindo campos, construtores, métodos, getters, etc.

O Dart 2.17 adicionou suporte para parâmetros superinicializadores em
construtores.
Superparâmetros permitem que você evite ter que passar manualmente cada
parâmetro na invocação super de um construtor não redirecionador.
Você pode, em vez disso, usar superparâmetros para encaminhar parâmetros para um
construtor de superclasse.

O Dart 2.17 removeu algumas restrições em argumentos nomeados.
Argumentos nomeados agora podem ser intercalados livremente com argumentos posicionais.
A partir do Dart 2.17, você pode escrever o seguinte código:

```dart
void main() {
  test(skip: true, 'A test description', () {
    // Corpo de função muito longo aqui...
  });
}
```

Para saber mais sobre esses recursos, confira:

* [Enums aprimorados][Enums aprimorados]
* [Superparâmetros][Superparâmetros]
* [Parâmetros nomeados][Parâmetros nomeados]

[Enums aprimorados]: /language/enums#declaring-enhanced-enums
[Superparâmetros]: /language/constructors#super-parameters
[Parâmetros nomeados]: /language/functions#named-parameters

### Dart 2.16
_Released 3 February 2022_
| [Dart 2.16 announcement](https://blog.dart.dev/dart-2-15-7e7a598e508a)

O Dart 2.16 não adicionou nenhum recurso novo à linguagem Dart.
Ele expandiu as ferramentas Dart.

### Dart 2.15
_Released 8 December 2021_
| [Dart 2.15 announcement](https://blog.dart.dev/dart-2-15-7e7a598e508a)

O Dart 2.15 melhorou o suporte para ponteiros de função, conhecidos como _tear-offs_.
Em particular, tear-offs de construtores agora são suportados.

### Dart 2.14
_Released 8 September 2021_
| [Dart 2.14 announcement](https://blog.dart.dev/announcing-dart-2-14-b48b9bb2fb67)

O Dart 2.14 adicionou o operador de deslocamento não assinado (ou _deslocamento triplo_) (`>>>`).
Este novo operador funciona como `>>`,
exceto que sempre preenche os bits mais significativos com zeros.

Para saber mais sobre esses operadores, confira [operadores bit a bit e de deslocamento][operadores bit a bit e de deslocamento].

[operadores bit a bit e de deslocamento]: /language/operators#bitwise-and-shift-operators

O Dart 2.14 removeu algumas restrições em argumentos de tipo.
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
_Released 19 May 2021_
| [Dart 2.13 announcement](https://blog.dart.dev/announcing-dart-2-13-c6d547b57067)

O Dart 2.13 expandiu o suporte para **[aliases de tipo][aliases de tipo]** (`typedef`).
Aliases de tipo costumavam funcionar apenas para tipos de função
mas agora funcionam para qualquer tipo.
Você pode usar o novo nome criado com um alias de tipo
em qualquer lugar onde o tipo original pudesse ser usado.

O Dart 2.13 melhorou o suporte a struct em **[Dart FFI][Dart FFI]**,
adicionando suporte para arrays (matrizes) inline e structs compactados.

### Dart 2.12
_Released 3 March 2021_
| [Dart 2.12 announcement](https://blog.dart.dev/announcing-dart-2-12-499a6e689c87)

O Dart 2.12 adicionou suporte para **[sound null safety (segurança nula _sound_)]**.
Quando você opta por null safety (segurança nula), os tipos em seu código são não anuláveis por padrão,
o que significa que as variáveis não podem conter nulo, a menos que você diga que podem.
Com null safety (segurança nula), seus erros de desreferência nula de tempo de execução
se transformam em erros de análise de tempo de edição.

No Dart 2.12, o **[Dart FFI][Dart FFI]** passou do beta para o canal estável.

### Dart 2.10
_Released 1 October 2020_
| [Dart 2.10 announcement](https://blog.dart.dev/announcing-dart-2-10-350823952bd5)

O Dart 2.10 não adicionou nenhum recurso novo à linguagem Dart.

### Dart 2.9 {:#dart-2-9}
_Lançado em 5 de agosto de 2020_

O Dart 2.9 não adicionou nenhum recurso novo à linguagem Dart.

### Dart 2.8
_Released 6 May 2020_
| [Dart 2.8 announcement](https://blog.dart.dev/announcing-dart-2-8-7750918db0a)

O Dart 2.8 não adicionou nenhum recurso à linguagem Dart. Ele
conteve várias [mudanças de quebra][2.8 breaking changes] preparatórias
para melhorar a usabilidade e o desempenho relacionados à nulidade para [null safety (segurança nula)][null safety (segurança nula)].

### Dart 2.7
_Released 11 December 2019_
| [Dart 2.7 announcement](https://blog.dart.dev/dart-2-7-a3710ec54e97)

O Dart 2.7 adicionou suporte para **[métodos de extensão][métodos de extensão]**,
permitindo que você adicione funcionalidades a qualquer tipo
— mesmo tipos que você não controla —
com a brevidade e a experiência de auto completar de chamadas de método regulares.

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
_Released 5 November 2019_
| [Dart 2.6 announcement](https://blog.dart.dev/dart2native-a76c815e6baf)

O Dart 2.6 introduziu uma
[mudança de quebra (dart-lang/sdk#37985)]({{site.repo.dart.sdk}}/issues/37985).
Restrições em que `Null` serve como um subtipo de `FutureOr<T>`
agora geram `Null` como a solução para `T`.

Por exemplo: O código a seguir agora imprime `Null`.
Antes do Dart 2.6, ele imprimia `dynamic`.
O fechamento anônimo `() {}` retorna o tipo `Null`.

```dart
import 'dart:async';

void foo<T>(FutureOr<T> Function() f) { print(T); }

main() { foo(() {}); }
```

### Dart 2.5
_Released 10 September 2019_
| [Dart 2.5 announcement](https://blog.dart.dev/announcing-dart-2-5-super-charged-development-328822024970)

O Dart 2.5 não adicionou nenhum recurso à linguagem Dart, mas adicionou
suporte para [chamar código C nativo][chamar código C nativo] de código Dart
usando uma nova **biblioteca principal, `dart:ffi`.**

### Dart 2.4 {:#dart-2-4}
_Lançado em 27 de junho de 2019_


O Dart 2.4 introduz uma mudança de quebra
[dart-lang/sdk#35097]({{site.repo.dart.sdk}}/issues/35097).

O Dart agora impõe covariância de variáveis de tipo usadas em superinterfaces.
Por exemplo: Antes desta versão, o Dart aceitava, mas agora rejeita,
o seguinte código:

```dart
class A<X> {};
class B<X> extends A<void Function(X)> {};
```

Você agora pode usar `async` como um identificador em
funções assíncronas e geradoras.

### Dart 2.3
_Released 8 May 2019_
| [Dart 2.3 announcement](https://blog.dart.dev/announcing-dart-2-3-optimized-for-building-user-interfaces-e84919ca1dff)

O Dart 2.3 adicionou três operadores projetados para melhorar o código que executa
manipulação de lista, como código de interface do usuário declarativa.

O **[operador spread (espalhar)][operador spread (espalhar)]**
permite descompactar os elementos de uma lista em outra.
No exemplo a seguir, a lista retornada por `buildMainElements()`
é descompactada na lista que está sendo passada para o argumento `children`:

```dart
Widget build(BuildContext context) {
  return Column(children: [
    Header(),
    ...buildMainElements(),
    Footer(),
  ]);
}
```

O operador **[collection if (coleção se)][collection if (coleção se)]** permite adicionar elementos condicionalmente.
O exemplo a seguir adiciona um elemento `FlatButton` a menos que
o aplicativo exiba a última página:

```dart
Widget build(BuildContext context) {
  return Column(children: [
    Text(mainText),
    if (page != pages.last)
      FlatButton(child: Text('Next')),
  ]);
}
```

O operador **[collection for (coleção para)][collection for (coleção para)]** permite construir elementos repetidos.
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
_Released 26 February 2019_
| [Dart 2.2 announcement](https://blog.dart.dev/announcing-dart-2-2-faster-native-code-support-for-set-literals-7e2ab19cc86d)

O Dart 2.2 adicionou suporte para **[literais de conjunto][literais de conjunto]**:

```dart
const Set<String> currencies = {'EUR', 'USD', 'JPY'};
```

### Dart 2.1
_Released 15 November 2018_
| [Dart 2.1 announcement](https://blog.dart.dev/announcing-dart-2-1-improved-performance-usability-9f55fca6f31a)

O Dart 2.1 adicionou suporte para **conversão int-para-double**,
permitindo que os desenvolvedores definam valores `double` usando literais inteiros.
Este recurso removeu o incômodo de ser forçado a usar um
literal `double` (por exemplo, `4.0`)
quando o valor era um inteiro no conceito.

No seguinte código Flutter, `horizontal` e `vertical` têm tipo `double`:

```dart
padding: const EdgeInsets.symmetric(
  horizontal: 4,
  vertical: 8,
)
```

### Dart 2.0
_Released 22 February 2018_
| [Dart 2.0 announcement](https://blog.dart.dev/announcing-dart-2-80ba01f43b6)

O Dart 2.0 implementou um novo **[sistema de tipo _sound_][sistema de tipo _sound_]**.
Antes do Dart 2.0, os tipos não eram totalmente _sound_, e
o Dart dependia muito da verificação de tipo de tempo de execução.
O código Dart 1.x teve que ser migrado para o Dart 2.

## Versionamento da linguagem {:#language-versioning}

Um único SDK Dart pode suportar simultaneamente
várias versões da linguagem Dart.
O compilador determina qual versão o código está visando,
e ele interpreta o código de acordo com essa versão.

O versionamento da linguagem torna-se importante nas raras ocasiões em que o Dart
introduz um recurso incompatível como [null safety (segurança nula)][null safety (segurança nula)].
Quando o Dart introduz uma mudança de quebra, o código que
compilava pode não compilar mais.
O versionamento da linguagem permite que você defina a versão da linguagem de cada biblioteca
para manter a compatibilidade.

No caso de null safety (segurança nula), os SDKs Dart 2.12 a 2.19 permitiram que você
_escolhesse_ atualizar seu código para usar null safety (segurança nula).
O Dart usa o versionamento da linguagem para permitir que código não null-safe (seguro para nulo) seja executado
juntamente com código null-safe (seguro para nulo).
Essa decisão permitiu a migração de código não null-safe (seguro para nulo) para código null-safe (seguro para nulo).
Para revisar um exemplo de como um aplicativo ou pacote pode migrar para uma nova
versão de linguagem com um recurso incompatível, confira
[Migrando para null safety (segurança nula)](/null-safety/migration-guide).

Cada pacote tem uma versão de linguagem padrão igual ao **limite inferior**
da restrição de SDK no arquivo `pubspec.yaml`.

**Por exemplo:** A seguinte entrada em um arquivo `pubspec.yaml`
indica que este pacote usa por padrão a versão de linguagem Dart 2.18.

```yaml
environment:
  sdk: '>=2.18.0 <3.0.0'
```

### Números de versão da linguagem {:#language-version-numbers}

O Dart formata suas versões de linguagem como dois números separados com um ponto.
Ele é lido como um número de versão principal e um número de versão secundária.
Números de versão secundária podem introduzir mudanças de quebra.

As versões do Dart podem acrescentar um número de patch a uma versão da linguagem.
Patches não devem mudar a linguagem, exceto para correções de bugs.
Para ilustrar: Dart 2.18.3 serve como a versão mais recente da
versão da linguagem Dart 2.18 do SDK.

Cada SDK Dart suporta todas as versões da linguagem dentro
de seu número de versão principal.
Isso significa que o SDK Dart 2.18.3 suporta versões de linguagem
2.0 a 2.18 inclusivas, mas não Dart 1.x.

Derivar a versão da linguagem da versão do SDK implica o seguinte:

* Sempre que uma versão secundária do SDK é lançada, uma nova versão da linguagem aparece.
  Na prática, muitas dessas versões de linguagem funcionam de maneira muito semelhante
  às versões anteriores e têm compatibilidade total entre elas.
  Por exemplo: a linguagem Dart 2.9 funciona muito como a linguagem Dart 2.8.

* Quando um patch de versão do SDK é lançado,
  ele não pode introduzir novos recursos de linguagem.
  Por exemplo: o lançamento 2.18.3 _permanece_ na versão de linguagem 2.18.
  Ele deve permanecer compatível com 2.18.2, 2.18.1 e 2.18.0.

### Seleção de versão de linguagem por biblioteca {:#per-library-language-version-selection}

Por padrão, todo arquivo Dart em um pacote usa a mesma versão de linguagem.
O Dart identifica a versão de linguagem padrão como o
limite inferior da restrição de SDK especificada no arquivo `pubspec.yaml`.
Às vezes, um arquivo Dart pode precisar usar uma versão de linguagem mais antiga.
Por exemplo, você pode não conseguir migrar todos os arquivos em um pacote
para null safety (segurança nula) ao mesmo tempo.

O Dart suporta a seleção de versão de linguagem por biblioteca.
Para optar por ter uma versão de linguagem diferente do
restante de um pacote, uma [biblioteca Dart][biblioteca Dart] deve
incluir um comentário no seguinte formato:

```dart
// @dart = <principal>.<secundário>
```

Por exemplo:

```dart
// Descrição do que está neste arquivo.
// @dart = 2.17
import 'dart:math';
...
```

A string `@dart` deve estar em um comentário `//` (não `///` ou `/*`),
e ela deve aparecer antes de qualquer código Dart no arquivo.
Espaço em branco (tabs e espaços) não importam,
exceto dentro das strings `@dart` e versão.
Como o exemplo anterior mostra,
outros comentários podem aparecer antes do comentário `@dart`.

Para aprender como e por que a equipe Dart desenvolveu este método de versionamento,
confira a [especificação de versionamento da linguagem][especificação de versionamento da linguagem].

[2.8 breaking changes]: {{site.repo.dart.sdk}}/issues/40686
[chamar código C nativo]: /interop/c-interop
[collection for (coleção para)]: /language/collections#control-flow-operators
[collection if (coleção se)]: /language/collections#control-flow-operators
[biblioteca Dart]: /tools/pub/create-packages#organizing-a-package
[Dart FFI]: /interop/c-interop
[métodos de extensão]: /language/extension-methods
[Tipos de extensão]: /language/extension-types
[funil da linguagem]: {{site.repo.dart.lang}}/projects/1
[especificação da linguagem]: /resources/language/spec
[documentação da linguagem]: /language
[especificação de versionamento da linguagem]: {{site.repo.dart.lang}}/blob/main/accepted/2.8/language-versioning/feature-specification.md#dart-language-versioning
[null safety (segurança nula)]: /null-safety
[promoção de campo final privado]: /tools/non-promotion-reasons
[changelog do SDK]: {{site.repo.dart.sdk}}/blob/main/CHANGELOG.md
[literais de conjunto]: /language/collections#sets
[sound null safety (segurança nula _sound_)]: /null-safety
[sistema de tipo _sound_]: /language/type-system
[operador spread (espalhar)]: /language/collections#spread-operators
[aliases de tipo]: /language/typedefs
