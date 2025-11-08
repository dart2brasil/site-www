---
title: Evolução da linguagem Dart
shortTitle: Evolução da linguagem
breadcrumb: Evolução
description: Mudanças e adições notáveis à linguagem de programação Dart.
lastVerified: 2024-08-04
ia-translate: true
---

<!-- Traduzido do commit em inglês: 5acb9e1cfe3d9a5d7a9d0a0d8a1b5b4b5b4b5b4b -->

Esta página lista mudanças e adições notáveis à
linguagem de programação Dart.

* Para aprender detalhes específicos sobre a versão mais recente da linguagem suportada,
  consulte a [documentação da linguagem][] ou a [especificação da linguagem][].
* Para um histórico completo de mudanças no Dart SDK, veja o [changelog do SDK][].
* Para um histórico completo de mudanças incompatíveis,
  incluindo mudanças [versionadas da linguagem][language versioned],
  consulte a página [Mudanças incompatíveis][Breaking changes].

Para usar um recurso de linguagem introduzido após a versão 2.0,
defina uma [restrição de SDK][] não inferior à
versão em que o Dart começou a suportar esse recurso.

**Por exemplo:** Para usar null safety, introduzido na [2.12][],
defina `2.12.0` como a restrição inferior no arquivo `pubspec.yaml`.

```yaml
environment:
  sdk: '>=2.12.0 <3.0.0'
```

[2.12]: #dart-2-12
[SDK constraint]: /tools/pub/pubspec#sdk-constraints
[language versioned]: #language-versioning
[Breaking changes]: /resources/breaking-changes

:::tip
Para revisar os recursos sendo discutidos, investigados e
adicionados à linguagem Dart,
confira o [rastreador de funil de linguagem][]
no repositório do GitHub da linguagem Dart.
:::


## Mudanças em cada versão

### Dart 3.9
_Lançado em 13 de agosto de 2025_
| [Anúncio do Dart 3.9](https://blog.dart.dev/announcing-dart-3-9-ba49e8f38298)


Os seguintes recursos de suporte foram atualizados para
Dart 3.9:

*   Null safety: O Dart agora assume null safety ao
    calcular promoção de tipo, acessibilidade e atribuição definitiva.
    Como resultado dessa mudança, mais avisos de `dead_code`
    podem ser produzidos.


*   O limite superior da versão do Flutter agora é respeitado: A partir da
    versão de linguagem 3.9, o limite superior da [restrição do SDK do flutter][]
    agora é respeitado em seu pacote raiz.

    Por exemplo, um arquivo `pubspec.yaml` com as seguintes restrições:

    ```yaml
    name: my_app
    environment:
      sdk: ^3.9.0
      flutter: 3.33.0
    ```

    Resulta em `dart pub get` falhando se invocado com uma versão do
    Flutter SDK diferente de `3.33.0`.
    O limite superior da restrição `flutter` ainda é
    ignorado em pacotes usados como dependências.
    Para mais contexto sobre essa mudança, veja [flutter/flutter#95472][].

Para mais informações sobre essas e outras mudanças, veja
o [changelog do Dart 3.9][Dart 3.9 changelog].

[Dart 3.9 changelog]: {{site.repo.dart.sdk}}/blob/main/CHANGELOG.md#390
[flutter SDK constraint]: /tools/pub/pubspec#flutter-sdk-constraints
[flutter/flutter#95472]: https://github.com/flutter/flutter/issues/95472

### Dart 3.8
_Lançado em 20 de maio de 2025_
| [Anúncio do Dart 3.8](https://blog.dart.dev/announcing-dart-3-8-724eaaec9f47)

Os seguintes recursos de linguagem foram adicionados ao Dart 3.8:

*   [Elementos null-aware][]: Um elemento null-aware avalia
    uma expressão em um literal de coleção e, se o resultado
    não for `null`, insere o valor na coleção
    circundante.

Os seguintes recursos de suporte foram atualizados:

*   [Dart format][]: O formatador do Dart 3.8 se baseia na
    reescrita da versão anterior, incorporando feedback,
    correções de bugs e melhorias adicionais. Ele agora
    automatiza inteligentemente o posicionamento de vírgulas finais,
    decidindo se deve dividir construções em vez de forçá-las.
    A atualização também inclui mudanças de estilo para apertar
    e melhorar a saída do código.

Para mais informações sobre essas e outras mudanças, veja
o [changelog do Dart 3.8][Dart 3.8 changelog].

[Null-aware elements]: /language/collections#null-aware-element
[Dart format]: {{site.repo.dart.sdk}}/blob/main/CHANGELOG.md#380
[Dart 3.8 changelog]: {{site.repo.dart.sdk}}/blob/main/CHANGELOG.md#380

### Dart 3.7
_Lançado em 12 de fevereiro de 2025_
| [Anúncio do Dart 3.7](https://blog.dart.dev/announcing-dart-3-7-bf864a1b195c)

O Dart 3.7 adicionou suporte para [variáveis wildcard][] à linguagem.
Uma variável wildcard é uma variável local ou parâmetro chamado `_`.
Variáveis wildcard não são vinculantes,
então podem ser declaradas várias vezes sem conflitos.
Por exemplo:

```dart
Foo(_, this._, super._, void _()) {}
```

O comando `dart format` também está agora vinculado à versão da linguagem a partir da versão 3.7.
Se a versão da linguagem de um arquivo de entrada for 3.7 ou posterior, o código é formatado
com o novo estilo alto.

O novo estilo parece semelhante ao estilo que você obtém quando adiciona vírgulas finais
às listas de argumentos, exceto que agora o formatador adicionará e removerá essas
vírgulas para você. Quando uma lista de argumentos ou parâmetros é dividida, ela é formatada
assim:

```dart
longFunction(
  longArgument,
  anotherLongArgument,
);
```

Você pode encontrar mais detalhes no [changelog][dart-format].

[wildcard variables]: /language/variables#wildcard-variables
[dart-format]: {{site.repo.dart.sdk}}/blob/main/CHANGELOG.md#dart-format

### Dart 3.6
_Lançado em 11 de dezembro de 2024_
| [Anúncio do Dart 3.6](https://blog.dart.dev/announcing-dart-3-6-778dd7a80983)

O Dart 3.6 adicionou suporte para underscores [separadores de dígitos][] (`_`) à linguagem.
Separadores de dígitos melhoram a legibilidade de literais numéricos longos.

```dart
var m = 1__000_000__000_000__000_000;
```

[digit separator]: /language/built-in-types#digit-separators

### Dart 3.5
_Lançado em 6 de agosto de 2024_
| [Anúncio do Dart 3.5](https://blog.dart.dev/dart-3-5-6ca36259fa2f)

O Dart 3.5 não adicionou novos recursos de linguagem, mas fez pequenas mudanças no
contexto considerado durante a inferência de tipos.
Estas incluem as seguintes mudanças não versionadas da linguagem:

* Quando o contexto para uma expressão `await` é `dynamic`,
  o contexto para o operando da expressão agora é `FutureOr<_>`.
* Quando o contexto para uma expressão if-null inteira (`e1 ?? e2`) é `dynamic`,
  o contexto para `e2` agora é o tipo estático de `e1`.

### Dart 3.4
_Lançado em 14 de maio de 2024_
| [Anúncio do Dart 3.4](https://blog.dart.dev/dart-3-4-bd8d23b4462a)

O Dart 3.4 fez várias melhorias relacionadas à análise de tipos. Estas incluem:

* Melhorias na análise de tipos de expressões condicionais,
  expressões e atribuições if-null, e expressões switch.
* Alinhamento do esquema de tipo de contexto de padrão para padrões de cast com a especificação.
* Tornando o esquema de tipo para o operador de spread null-aware (`...?`)
  nullable para literais de mapas e conjuntos, para corresponder ao comportamento de literais de lista.

### Dart 3.3
_Lançado em 15 de fevereiro de 2024_
| [Anúncio do Dart 3.3](https://blog.dart.dev/dart-3-3-325bf2bf6c13)

O Dart 3.3 adicionou algumas melhorias à linguagem:

* [Tipos de extensão][] são um novo recurso no Dart que permite o encapsulamento
  de custo zero de um tipo existente. Eles são semelhantes a classes wrapper e métodos de extensão,
  mas com diferenças de implementação e trade-offs diferentes.

  ```dart
  extension type Meters(int value) {
    String get label => '${value}m';
    Meters operator +(Meters other) => Meters(value + other.value);
  }

  void main() {
    var m = Meters(42); // Tem tipo `Meters`.
    var m2 = m + m; // OK, tipo `Meters`.
    // int i = m; // Erro de compilação, tipo errado.
    // m.isEven; // Erro de compilação, nenhum membro desse tipo.
    assert(identical(m, m.value)); // Sucesso.
  }
  ```

* Getters abstratos agora são promovíveis sob as regras de
  [promoção de campo final privado][], se não houver declarações conflitantes.

### Dart 3.2
_Lançado em 15 de novembro de 2023_
| [Anúncio do Dart 3.2](https://blog.dart.dev/dart-3-2-c8de8fe1b91f)

O Dart 3.2 adicionou melhorias à análise de fluxo, incluindo:

* Expansão da [promoção de tipo](/null-safety/understanding-null-safety#type-promotion-on-null-checks)
  para funcionar em campos finais privados. Anteriormente disponível apenas para
  variáveis locais e parâmetros, agora campos finais privados podem ser promovidos para
  tipos não-nullable através de verificações null e testes `is`. Por exemplo,
  o seguinte código agora é válido:

  ```dart
  class Example {
    final int? _privateField;

    Example(this._privateField);

    void f() {
      if (_privateField != null) {
        // _privateField foi agora promovido; você pode usá-lo sem
        // verificar null.
        int i = _privateField; // OK
      }
    }
  }

  // Promoções de campo privado também funcionam de fora da classe:
  void f(Example x) {
    if (x._privateField != null) {
      int i = x._privateField; // OK
    }
  }
  ```

  Para mais informações sobre quando campos finais privados podem e não podem ser promovidos, consulte
  [Corrigindo falhas de promoção de tipo](/tools/non-promotion-reasons).

* Corrigidas inconsistências no comportamento de promoção de tipo de
  instruções [if-case](/language/branches#if-case)
  onde o valor sendo comparado lança uma exceção.


### Dart 3.1
_Lançado em 16 de agosto de 2023_
| [Anúncio do Dart 3.1](https://blog.dart.dev/dart-3-1-a-retrospective-on-functional-style-programming-in-dart-3-a1f4b3a7cdda)

O Dart 3.1 não adicionou novos recursos e não fez mudanças na linguagem.

### Dart 3.0
_Lançado em 10 de maio de 2023_
| [Anúncio do Dart 3.0](https://blog.dart.dev/announcing-dart-3-53f065a10635)

O Dart 3.0 introduziu vários novos recursos principais de linguagem:

* [Padrões][], uma nova categoria de gramática que permite
  combinar e desestruturar valores.
* [Records][], um novo tipo que permite agregar
  múltiplos valores de diferentes tipos em um único retorno de função.
* [Modificadores de classe][], um novo conjunto de palavras-chave que permite
  controlar como uma classe ou mixin pode ser usado.
* [Expressões switch][], uma nova forma de ramificação múltipla
  permitida onde expressões são esperadas.
* [Cláusulas if-case][], uma nova construção condicional que combina um valor
  contra um padrão e executa o ramo then ou else, dependendo
  se o padrão corresponde.

O Dart 3.0 também introduziu algumas mudanças incompatíveis na linguagem:

* Declarações de classe sem o modificador de classe [`mixin`][]
  não podem mais ser aplicadas como mixins.
* Agora é um erro de tempo de compilação se dois pontos (`:`) forem usados como separador
  antes do valor padrão de um parâmetro nomeado opcional.
  Use um sinal de igual (`=`) em vez disso.
* Agora é um erro de tempo de compilação se uma instrução `continue` tiver como alvo um
  rótulo que não esteja anexado a uma
  instrução de loop (`for`, `do` e `while`) ou a um membro `switch`.

:::note
A versão 3.0 do Dart SDK eliminou o suporte para
[versões de linguagem][language versions] anteriores à 2.12.
:::

[Patterns]: /language/patterns
[Records]: /language/records
[Class modifiers]: /language/class-modifiers
[Switch expressions]: /language/branches#switch-expressions
[If-case clauses]: /language/branches#if-case
[`mixin`]: /language/mixins#class-mixin-or-mixin-class
[language versions]: #language-versioning

### Dart 2.19
_Lançado em 25 de janeiro de 2023_

O Dart 2.19 introduziu algumas precauções em torno da inferência de tipos.
Estas incluem:

* Mais sinalizadores de análise de fluxo para casos de código inacessível.
* Não delegar mais nomes privados inacessíveis para `noSuchMethod`.
* Inferência de tipo de nível superior lança em dependências cíclicas.

O Dart 2.19 também introduziu suporte para bibliotecas sem nome.
Diretivas de biblioteca, usadas para anexar comentários de documentação e
anotações no nível da biblioteca, agora podem e [devem][] ser escritas sem um nome:

```dart
/// Uma biblioteca de teste realmente ótima.
@TestOn('browser')
library;
```

[should]: /effective-dart/style#dont-explicitly-name-libraries

### Dart 2.18
_Lançado em 30 de agosto de 2022_
| [Anúncio do Dart 2.18](https://blog.dart.dev/dart-2-18-f4b3101f146c)

O Dart 2.18 melhorou a inferência de tipos.
Esta mudança permite o fluxo de informações entre argumentos em chamadas de função genérica.
Antes da 2.18, se você não especificasse o tipo de um argumento em alguns métodos,
o Dart reportava erros.
Esses erros de tipo citavam possíveis ocorrências de null.
Com a 2.18, o compilador infere o tipo de argumento
de outros valores em uma invocação.
Você não precisa especificar o tipo de argumento inline.

O Dart 2.18 também descontinuou o suporte para classes mixin que não estendem
`Object`.

Para aprender mais sobre esses recursos, consulte:

* [Inferência de argumento de tipo][]
* [Adicionando recursos a uma classe: mixins][]

[Type argument inference]: /language/type-system#type-argument-inference
[Adding features to a class: mixins]: /language/mixins

### Dart 2.17
_Lançado em 11 de maio de 2022_
| [Anúncio do Dart 2.17](https://blog.dart.dev/dart-2-17-b216bfc80c5d)

O Dart 2.17 expandiu a funcionalidade de enum com enums aprimorados.
Enums aprimorados permitem que declarações de enum definam membros
incluindo campos, construtores, métodos, getters, etc.

O Dart 2.17 adicionou suporte para parâmetros super-inicializadores em
construtores.
Parâmetros super permitem que você evite ter que passar manualmente cada
parâmetro para a invocação super de um construtor não-redirecionador.
Você pode usar parâmetros super para encaminhar parâmetros para um
construtor de superclasse.

O Dart 2.17 removeu algumas restrições sobre argumentos nomeados.
Argumentos nomeados agora podem ser livremente intercalados com argumentos posicionais.
A partir do Dart 2.17, você pode escrever o seguinte código:

```dart
void main() {
  test(skip: true, 'A test description', () {
    // Corpo de função muito longo aqui...
  });
}
```

Para aprender mais sobre esses recursos, consulte:

* [Enums aprimorados][]
* [Parâmetros super][]
* [Parâmetros nomeados][]

[Enhanced enums]: /language/enums#declaring-enhanced-enums
[Super parameters]: /language/constructors#super-parameters
[Named parameters]: /language/functions#named-parameters

### Dart 2.16
_Lançado em 3 de fevereiro de 2022_
| [Anúncio do Dart 2.16](https://blog.dart.dev/dart-2-15-7e7a598e508a)

O Dart 2.16 não adicionou novos recursos à linguagem Dart.
Ele expandiu as ferramentas do Dart.

### Dart 2.15
_Lançado em 8 de dezembro de 2021_
| [Anúncio do Dart 2.15](https://blog.dart.dev/dart-2-15-7e7a598e508a)

O Dart 2.15 melhorou o suporte para ponteiros de função, conhecidos como _tear-offs._
Em particular, tear-offs de construtor agora são suportados.

### Dart 2.14
_Lançado em 8 de setembro de 2021_
| [Anúncio do Dart 2.14](https://blog.dart.dev/announcing-dart-2-14-b48b9bb2fb67)

O Dart 2.14 adicionou o operador de deslocamento não assinado (ou _deslocamento triplo_) (`>>>`).
Este novo operador funciona como `>>`,
exceto que sempre preenche os bits mais significativos com zeros.

Para aprender mais sobre esses operadores, consulte [operadores bitwise e de deslocamento][].

[bitwise and shift operators]: /language/operators#bitwise-and-shift-operators

O Dart 2.14 removeu algumas restrições sobre argumentos de tipo.
Você pode passar argumentos de tipo para anotações e usar um tipo de função genérica
como um argumento de tipo.
A partir do Dart 2.14, você pode escrever o seguinte código:

```dart
@TypeHelper<int>(42, "The meaning")
late List<T Function<T>(T)> idFunctions;
var callback = [<T>(T value) => value];
late S Function<S extends T Function<T>(T)>(S) f;
```

### Dart 2.13
_Lançado em 19 de maio de 2021_
| [Anúncio do Dart 2.13](https://blog.dart.dev/announcing-dart-2-13-c6d547b57067)

O Dart 2.13 expandiu o suporte para **[aliases de tipo][]** (`typedef`).
Aliases de tipo costumavam funcionar apenas para tipos de função
mas agora funcionam para qualquer tipo.
Você pode usar o novo nome criado com um alias de tipo
em qualquer lugar onde o tipo original poderia ser usado.

O Dart 2.13 melhorou o suporte de struct no **[Dart FFI][]**,
adicionando suporte para arrays inline e structs compactas.

### Dart 2.12
_Lançado em 3 de março de 2021_
| [Anúncio do Dart 2.12](https://blog.dart.dev/announcing-dart-2-12-499a6e689c87)

O Dart 2.12 adicionou suporte para **[sound null safety][]**.
Quando você opta por null safety, os tipos em seu código são não-nullable por padrão,
o que significa que variáveis não podem conter null, a menos que você diga que podem.
Com null safety, seus erros de desreferenciação null em tempo de execução
se transformam em erros de análise em tempo de edição.

No Dart 2.12, **[Dart FFI][]** graduou-se de beta para o canal estável.

### Dart 2.10
_Lançado em 1 de outubro de 2020_
| [Anúncio do Dart 2.10](https://blog.dart.dev/announcing-dart-2-10-350823952bd5)

O Dart 2.10 não adicionou novos recursos à linguagem Dart.

### Dart 2.9
_Lançado em 5 de agosto de 2020_

O Dart 2.9 não adicionou novos recursos à linguagem Dart.

### Dart 2.8
_Lançado em 6 de maio de 2020_
| [Anúncio do Dart 2.8](https://blog.dart.dev/announcing-dart-2-8-7750918db0a)

O Dart 2.8 não adicionou recursos à linguagem Dart. Ele continha
várias [mudanças incompatíveis][2.8 breaking changes] preparatórias
para melhorar a usabilidade e o desempenho relacionados à nulidade para [null safety][].

### Dart 2.7
_Lançado em 11 de dezembro de 2019_
| [Anúncio do Dart 2.7](https://blog.dart.dev/dart-2-7-a3710ec54e97)

O Dart 2.7 adicionou suporte para **[métodos de extensão][]**,
permitindo que você adicione funcionalidade a qualquer tipo
—-mesmo tipos que você não controla—-
com a brevidade e experiência de auto-completar de chamadas de método regulares.

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
| [Anúncio do Dart 2.6](https://blog.dart.dev/dart2native-a76c815e6baf)

O Dart 2.6 introduziu uma
[mudança incompatível (dart-lang/sdk#37985)]({{site.repo.dart.sdk}}/issues/37985).
Restrições onde `Null` serve como um subtipo de `FutureOr<T>`
agora produzem `Null` como a solução para `T`.

Por exemplo: O código a seguir agora imprime `Null`.
Antes do Dart 2.6, imprimia `dynamic`.
A closure anônima `() {}` retorna o tipo `Null`.

```dart
import 'dart:async';

void foo<T>(FutureOr<T> Function() f) { print(T); }

main() { foo(() {}); }
```

### Dart 2.5
_Lançado em 10 de setembro de 2019_
| [Anúncio do Dart 2.5](https://blog.dart.dev/announcing-dart-2-5-super-charged-development-328822024970)

O Dart 2.5 não adicionou recursos à linguagem Dart, mas adicionou
suporte para [chamar código C nativo][] de código Dart
usando uma nova **biblioteca central, `dart:ffi`.**

### Dart 2.4
_Lançado em 27 de junho de 2019_


O Dart 2.4 introduz uma mudança incompatível
[dart-lang/sdk#35097]({{site.repo.dart.sdk}}/issues/35097).

O Dart agora impõe a covariância de variáveis de tipo usadas em super-interfaces.
Por exemplo: Antes desta versão, o Dart aceitava, mas agora rejeita,
o seguinte código:

```dart
class A<X> {};
class B<X> extends A<void Function(X)> {};
```

Agora você pode usar `async` como um identificador em
funções assíncronas e geradoras.

### Dart 2.3
_Lançado em 8 de maio de 2019_
| [Anúncio do Dart 2.3](https://blog.dart.dev/announcing-dart-2-3-optimized-for-building-user-interfaces-e84919ca1dff)

O Dart 2.3 adicionou três operadores projetados para melhorar código que realiza
manipulação de lista, como código de UI declarativa.

O **[operador spread][]**
permite desempacotar os elementos de uma lista em outra.
No exemplo a seguir, a lista retornada por `buildMainElements()`
é desempacotada na lista sendo passada para o argumento `children`:

```dart
Widget build(BuildContext context) {
  return Column(children: [
    Header(),
    ...buildMainElements(),
    Footer(),
  ]);
}
```

O **[operador collection if][]** permite adicionar elementos condicionalmente.
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

O **[operador collection for][]** permite construir elementos repetidos.
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
| [Anúncio do Dart 2.2](https://blog.dart.dev/announcing-dart-2-2-faster-native-code-support-for-set-literals-7e2ab19cc86d)

O Dart 2.2 adicionou suporte para **[literais de conjunto][]**:

```dart
const Set<String> currencies = {'EUR', 'USD', 'JPY'};
```

### Dart 2.1
_Lançado em 15 de novembro de 2018_
| [Anúncio do Dart 2.1](https://blog.dart.dev/announcing-dart-2-1-improved-performance-usability-9f55fca6f31a)

O Dart 2.1 adicionou suporte para **conversão int-para-double**,
permitindo que desenvolvedores definam valores `double` usando literais inteiros.
Este recurso removeu a inconveniência de ser forçado a usar um
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
_Lançado em 22 de fevereiro de 2018_
| [Anúncio do Dart 2.0](https://blog.dart.dev/announcing-dart-2-80ba01f43b6)

O Dart 2.0 implementou um novo **[sistema de tipos sólido][]**.
Antes do Dart 2.0, os tipos não eram totalmente sólidos, e
o Dart dependia fortemente de verificação de tipo em tempo de execução.
O código Dart 1.x teve que ser migrado para Dart 2.

## Versionamento de linguagem {:#language-versioning}

Um único Dart SDK pode simultaneamente suportar
múltiplas versões da linguagem Dart.
O compilador determina qual versão o código está mirando,
e interpreta o código de acordo com essa versão.

O versionamento de linguagem se torna importante nas raras ocasiões em que o Dart
introduz um recurso incompatível como [null safety][].
Quando o Dart introduz uma mudança incompatível, código que
compilava pode não compilar mais.
O versionamento de linguagem permite que você defina a versão de linguagem de cada biblioteca
para manter a compatibilidade.

No caso de null safety, Dart SDKs 2.12 a 2.19 permitiram que você
_escolhesse_ atualizar seu código para usar null safety.
O Dart usa versionamento de linguagem para permitir que código não-null-safe execute
ao lado de código null-safe.
Esta decisão possibilitou a migração de código não-null-safe para código null-safe.
Para revisar um exemplo de como um aplicativo ou pacote pode migrar para uma nova
versão de linguagem com um recurso incompatível, consulte
[Migrando para null safety](/null-safety/migration-guide).

Cada pacote tem uma versão de linguagem padrão igual ao **limite inferior**
da restrição de SDK no arquivo `pubspec.yaml`.

**Por exemplo:** A seguinte entrada em um arquivo `pubspec.yaml`
indica que este pacote padroniza para a versão de linguagem Dart 2.18.

```yaml
environment:
  sdk: '>=2.18.0 <3.0.0'
```

### Números de versão de linguagem

O Dart formata suas versões de linguagem como dois números separados por um ponto.
Lê-se como um número de versão principal e um número de versão secundária.
Números de versão secundária podem introduzir mudanças incompatíveis.

As versões do Dart podem anexar um número de patch a uma versão de linguagem.
Patches não devem alterar a linguagem exceto para correções de bugs.
Para ilustrar: Dart 2.18.3 serve como a versão mais recente do
versão de linguagem do Dart 2.18 SDK.

Cada Dart SDK suporta todas as versões de linguagem dentro
de seu número de versão principal.
Isso significa que o Dart SDK 2.18.3 suporta versões de linguagem
2.0 a 2.18 inclusive, mas não Dart 1.x.

Derivar a versão de linguagem da versão do SDK implica o seguinte:

* Sempre que uma versão secundária do SDK é lançada, uma nova versão de linguagem aparece.
  Na prática, muitas dessas versões de linguagem funcionam de maneira muito semelhante
  a versões anteriores e têm compatibilidade total entre elas.
  Por exemplo: A linguagem Dart 2.9 funciona muito como a linguagem Dart 2.8.

* Quando uma versão de patch do SDK é lançada,
  ela não pode introduzir novos recursos de linguagem.
  Por exemplo: A versão 2.18.3 _permanece_ versão de linguagem 2.18.
  Ela deve permanecer compatível com 2.18.2, 2.18.1 e 2.18.0.

### Seleção de versão de linguagem por biblioteca

Por padrão, cada arquivo Dart em um pacote usa a mesma versão de linguagem.
O Dart identifica a versão de linguagem padrão como o
limite-inferior da restrição de SDK especificada no arquivo `pubspec.yaml`.
Às vezes, um arquivo Dart pode precisar usar uma versão de linguagem mais antiga.
Por exemplo, você pode não conseguir migrar todos os arquivos em um pacote
para null safety ao mesmo tempo.

O Dart suporta seleção de versão de linguagem por biblioteca.
Para optar por ter uma versão de linguagem diferente da
do resto de um pacote, uma [biblioteca Dart][] deve
incluir um comentário no seguinte formato:

```dart
// @dart = <major>.<minor>
```

Por exemplo:

```dart
// Descrição do que está neste arquivo.
// @dart = 2.17
import 'dart:math';
...
```

A string `@dart` deve estar em um comentário `//` (não `///` ou `/*`),
e deve aparecer antes de qualquer código Dart no arquivo.
Espaço em branco (tabs e espaços) não importa,
exceto dentro das strings `@dart` e de versão.
Como o exemplo anterior mostra,
outros comentários podem aparecer antes do comentário `@dart`.

Para aprender como e por que a equipe Dart desenvolveu este método de versionamento,
consulte a [especificação de versionamento de linguagem][].

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
[language versioning specification]: {{site.repo.dart.lang}}/blob/main/accepted/2.8/language-versioning/feature-specification.md#dart-language-versioning
[null safety]: /null-safety
[private final field promotion]: /tools/non-promotion-reasons
[SDK changelog]: {{site.repo.dart.sdk}}/blob/main/CHANGELOG.md
[set literals]: /language/collections#sets
[sound null safety]: /null-safety
[sound type system]: /language/type-system
[spread operator]: /language/collections#spread-operators
[type aliases]: /language/typedefs
[versionadas da linguagem]: #language-versioning
[restrição de SDK]: /tools/pub/pubspec#sdk-constraints
[rastreador de funil de linguagem]: {{site.repo.dart.lang}}/projects/1
[documentação da linguagem]: /language
[especificação da linguagem]: /resources/language/spec
[changelog do SDK]: {{site.repo.dart.sdk}}/blob/main/CHANGELOG.md
[Mudanças incompatíveis]: /resources/breaking-changes
[restrição do SDK do flutter]: /tools/pub/pubspec#flutter-sdk-constraints
[variáveis wildcard]: /language/variables#wildcard-variables
[separadores de dígitos]: /language/built-in-types#digit-separators
[Tipos de extensão]: /language/extension-types
[promoção de campo final privado]: /tools/non-promotion-reasons
[Padrões]: /language/patterns
[Modificadores de classe]: /language/class-modifiers
[Expressões switch]: /language/branches#switch-expressions
[Cláusulas if-case]: /language/branches#if-case
[devem]: /effective-dart/style#dont-explicitly-name-libraries
[Inferência de argumento de tipo]: /language/type-system#type-argument-inference
[Adicionando recursos a uma classe: mixins]: /language/mixins
[Enums aprimorados]: /language/enums#declaring-enhanced-enums
[Parâmetros super]: /language/constructors#super-parameters
[Parâmetros nomeados]: /language/functions#named-parameters
[operadores bitwise e de deslocamento]: /language/operators#bitwise-and-shift-operators
[aliases de tipo]: /language/typedefs
[sound null safety]: /null-safety
[métodos de extensão]: /language/extension-methods
[chamar código C nativo]: /interop/c-interop
[operador spread]: /language/collections#spread-operators
[operador collection if]: /language/collections#control-flow-operators
[operador collection for]: /language/collections#control-flow-operators
[literais de conjunto]: /language/collections#sets
[sistema de tipos sólido]: /language/type-system
[biblioteca Dart]: /tools/pub/create-packages#organizing-a-package
[especificação de versionamento de linguagem]: {{site.repo.dart.lang}}/blob/main/accepted/2.8/language-versioning/feature-specification.md#dart-language-versioning
[Elementos null-aware]: /language/collections#null-aware-element
