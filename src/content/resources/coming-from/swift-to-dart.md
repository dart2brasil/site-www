---
ia-translate: true
title: Aprendendo Dart como um desenvolvedor Swift
description: Aproveite seu conhecimento em Swift ao aprender Dart.
body_class: highlight-languages
lastVerified: 2022-12-13
---

Este guia tem como objetivo aproveitar seu conhecimento
de programação em Swift ao aprender Dart. Ele mostra as principais
similaridades e diferenças em ambas as
linguagens, e introduz conceitos de Dart que não estão
presentes em Swift. Como um desenvolvedor Swift, Dart
pode parecer familiar, já que ambas as linguagens compartilham muitos conceitos.

Tanto Swift quanto Dart suportam _null safety_ (segurança nula)
sólida. Nenhuma das linguagens permite que variáveis sejam nulas por padrão.

Assim como Swift, Dart tem suporte semelhante para
[coleções](#collections), [genéricos](#generics),
[concorrência](#concurrency) (usando async/await),
e [extensões](#extension-methods).

[Mixins](#mixins) são outro conceito em Dart que pode
ser novo para desenvolvedores Swift. Assim como Swift,
Dart oferece compilação AOT (_ahead-of-time_).
No entanto, Dart também suporta um modo de compilação JIT
(_just-in-time_) para auxiliar em vários aspectos
do desenvolvimento, como recompilação incremental
ou depuração. Para mais informações, consulte a [visão geral do Dart][Dart overview].

[Dart overview]: /overview#native-platform

:::note
O Flutter usa a linguagem Dart, então se você está
programando em Flutter, pode achar [Flutter para
desenvolvedores iOS][Flutter for iOS developers] útil.
:::

[Flutter for iOS developers]: {{site.flutter-docs}}/get-started/flutter-for/ios-devs

## Convenções e _linting_ {:#conventions-and-linting}

Swift e Dart possuem ferramentas de _linting_
(análise estática de código) para aplicar convenções
padrão. No entanto, enquanto Swift tem `SwiftLint`
como uma ferramenta independente, Dart tem convenções
de layout oficiais e inclui um _linter_ (analisador de
código) para tornar a conformidade fácil. Para
personalizar as regras de _lint_ para seu projeto, siga as instruções de
[Personalizando a análise estática][Customizing static analysis]. (Observe que os _plugins_ IDE para Dart
e Flutter também fornecem essa funcionalidade.)

[Customizing static analysis]: /tools/analysis

:::tip
Dart fornece [`dart fix`][`dart fix`], que encontra e corrige
erros encontrados pelo analisador.
:::

[`dart fix`]: /tools/dart-fix

Dart também fornece um formatador de código, que pode
formatar automaticamente qualquer projeto Dart ao executar
`dart format` a partir da linha de comando ou
através do IDE.

:::tip
Dart suporta vírgulas opcionais no final para quaisquer
valores separados por vírgula, como parâmetros de função
ou itens de lista. Isso força o formatador a colocar
cada item em sua própria linha,
o que ajuda na legibilidade,
especialmente quando você tem muito código aninhado
(como pode acontecer no código de layout do Flutter).

Para mais informações sobre como usar vírgulas para tornar
seu código mais legível, consulte
[Usando vírgulas finais][Using trailing commas] em docs.flutter.dev.
:::

[Using trailing commas]: {{site.flutter-docs}}/development/tools/formatting#using-trailing-commas

Para mais informações sobre as convenções Dart e _linting_,
consulte [Effective Dart][Effective Dart] e [Regras do Linter][Linter rules].

[Effective Dart]: /effective-dart
[Linter rules]: /tools/linter-rules

## Variáveis {:#variables}

Declarar e inicializar variáveis em Dart é um pouco
diferente quando comparado com Swift. Uma declaração
de variável sempre começa com o tipo da variável, a
palavra-chave `var` ou a palavra-chave `final`. Como
em Swift, Dart suporta a inferência de tipo onde o
compilador infere o tipo com base no valor
atribuído à variável:

```dart
// Variável do tipo String.
String name = 'Bob';

// Variável do tipo String imutável.
final String name = 'Bob';

// Isso é o mesmo que `String name = 'Bob';`
// já que o Dart infere que o tipo é String.
var name = 'Bob';

// E isso é o mesmo que `final String name = 'Bob';`.
final name = 'Bob';
```

Cada declaração em Dart termina com um ponto e vírgula
para indicar o final da declaração. Você pode substituir
`var` em Dart por um tipo explícito. No entanto, por
convenção, [`var` é recomendado quando o analisador pode
inferir o tipo implicitamente][inference].

[inference]: /effective-dart/design#types

```dart
// Declara uma variável primeiro:
String name;
// Inicializa a variável mais tarde:
name = 'bob';
// Declara e inicializa uma variável de uma vez com inferência:
var name = 'bob';
```

O equivalente em Swift do código Dart acima seria
semelhante ao seguinte:

```swift
// Declara uma variável primeiro:
var name: String
// Inicializa a variável mais tarde
name = "bob"

// Declara e inicializa uma variável de uma vez com inferência:
var name = "bob"
```

Em Dart, quando uma variável sem um tipo explícito
é inicializada após sua declaração, seu tipo é
inferido como o tipo genérico `dynamic`. Da mesma
forma, quando um tipo não pode ser inferido
automaticamente, ele assume o tipo `dynamic` por
padrão, **o que remove toda a segurança de tipo**.
Portanto, o _linter_ (analisador de código) Dart
desencoraja isso, gerando um aviso. Se você _pretende_
permitir que uma variável tenha qualquer tipo, é
preferível atribuí-la a `Object?` em vez de `dynamic`.

Para mais informações, consulte a seção
[Variáveis][Variables section] no tour da linguagem Dart.

[Variables section]: /language/variables

### Final {:#final}

A palavra-chave `final` em Dart indica que uma
variável pode ser definida apenas uma vez. Isso é
semelhante à palavra-chave `let` em Swift.

Tanto em Dart quanto em Swift, você só pode inicializar
uma variável `final` uma vez, seja na declaração
ou na lista de inicializadores. Qualquer tentativa de
atribuir um valor pela segunda vez resulta em um erro
em tempo de compilação. Ambos os seguintes trechos
de código são válidos, mas definir `name`
posteriormente resulta em erros de compilação.

```dart
final String name;
if (b1) {
  name = 'John';
} else {
  name = 'Jane';
}
```

```swift
let name: String
if (b1) {
  name = "John"
} else {
  name = "Jane"
}
```

### Const {:#const}

Além de `final`, Dart também tem a palavra-chave
`const`. Um benefício de `const` é que ela é
totalmente avaliada em tempo de compilação e não
pode ser modificada durante a vida útil do aplicativo.

```dart
const bar = 1000000; // Unidade de pressão (dynes/cm2)
const double atm = 1.01325 * bar; // Atmosfera padrão
```

Uma variável `const` definida no nível de classe
precisa ser marcada como `static const`.

```dart
class StandardAtmosphere {
  static const bar = 1000000; // Unidade de pressão (dynes/cm2)
  static const double atm = 1.01325 * bar; // Atmosfera padrão
}
```

A palavra-chave `const` não é apenas para declarar
variáveis constantes; ela também pode ser usada
para criar valores constantes:

```dart
var foo = const ['one', 'two', 'three'];
foo.add('four'); // Erro: foo contém um valor constante.
foo = ['apple', 'pear']; // Isso é permitido, pois foo em si não é constante.
foo.add('orange'); // Permitido, pois foo não contém mais um valor constante.
```

No exemplo acima, você não pode alterar o valor
`const` (adicionar, atualizar ou remover os elementos
na lista fornecida), mas você pode atribuir um novo
valor a `foo`. Depois que `foo` recebe uma nova
lista (não constante), você _pode_ adicionar, atualizar ou remover o conteúdo da lista.

Você também pode atribuir um valor constante a um
campo `final`. Você não pode usar o campo `final` em
um contexto constante, mas pode usar a constante. Por exemplo:

```dart
final foo1 = const [1, 2, 3];
const foo2 = [1, 2, 3]; // Equivalente a `const [1, 2, 3]`
const bar2 = foo2; // OK
const bar1 = foo1; // Erro em tempo de compilação, `foo1` não é constante
```

Você também pode definir construtores `const`,
tornando essas classes imutáveis (inalteráveis) e
possibilitando a criação de instâncias dessas classes
como constantes em tempo de compilação.
Para mais informações, consulte
[construtores const](#const-constructors).

## Tipos _built-in_ {:#built-in-types}
Dart inclui vários tipos nas bibliotecas da
plataforma, como:

* Tipos de valores básicos como
  * Números (`num`, `int`, `double`)
  * Strings (`String`)
  * Booleanos (`bool`)
  * O valor nulo (`Null`)
* Coleções
  * Listas/arrays (`List`)
  * Sets (`Set`)
  * Maps/dicionários (`Map`)

Para mais informações, consulte [Tipos _built-in_][Built-in types]
no tour da linguagem Dart.

[Built-in types]: /language/built-in-types

### Números {:#numbers}

Dart define três tipos numéricos para armazenar números:

`num`
: Um tipo de número genérico de 64 bits.

`int`
: Um número inteiro dependente da plataforma. Em código
  nativo, é um inteiro de complemento de dois de 64 bits.
  Na web, é um número de ponto flutuante de 64 bits
  não fracionário.

`double`
: Um número de ponto flutuante de 64 bits.

Ao contrário de Swift, não há tipos específicos para
inteiros não sinalizados.

Todos esses tipos também são classes na API Dart.
Tanto os tipos `int` quanto `double` compartilham `num`
como sua classe pai:

<img
  src="/assets/img/number-class-hierarchy.svg"
  alt="Object é o pai de num, que é o pai de int e double">

Como os valores numéricos são tecnicamente instâncias
de classe, eles têm a conveniência de expor suas
próprias funções de utilidade. Por causa disso, um
`int` pode, por exemplo, ser transformado em um `double`
da seguinte forma:

{% comment %}
TODO: Usar um exemplo diferente aqui, como arredondamento
{% endcomment %}

```dart
int intVariable = 3;
double doubleVariable = intVariable.toDouble();
```

O mesmo é realizado em Swift usando o
inicializador especializado:

```swift
var intVariable: Int = 3
var doubleVariable: Double = Double(intVariable)
```

No caso de valores literais, Dart converte
automaticamente o literal inteiro em um valor `double`.
O código a seguir está perfeitamente correto:

```dart
double doubleValue = 3;
```

Ao contrário de Swift, em Dart você pode comparar um
valor inteiro com um double usando o operador de
igualdade (`==`), conforme mostrado abaixo:

```dart
int intVariable = 3;
double doubleVariable = 3.0;
print(intVariable == doubleVariable); // true
```
 
Este código imprime `true`. No entanto, em Dart a
implementação subjacente dos números é diferente entre
a web e as plataformas nativas. A página [Números em
Dart][Numbers in Dart] detalha essas diferenças e mostra como escrever
código para que as diferenças não importem.

[Numbers in Dart]: /resources/language/number-representation

### Strings {:#strings}

Assim como no Swift, Dart representa uma série de
caracteres usando o tipo `String`, embora Dart não
suporte um tipo `Character` representando um caractere.
Uma `String` pode ser definida com aspas simples ou
duplas, no entanto, _aspas simples são preferidas_.

```dart
String c = 'a'; // Não existe um tipo "Character" especializado
String s1 = 'Esta é uma String';
String s2 = "Esta também é uma String";
```

```swift
let c: Character = "a"
let s1: String = "Esta é uma String"
let s2: String = "Esta também é uma String"
```

#### Escapando caracteres especiais {:#escaping-special-characters}

Escapar caracteres especiais em Dart é semelhante a
Swift (e à maioria das outras linguagens). Para incluir
caracteres especiais, escape-os usando o caractere
barra invertida.

O código a seguir mostra alguns exemplos:

```dart
final singleQuotes = 'Eu estou aprendendo Dart'; // Eu estou aprendendo Dart
final doubleQuotes = "Escapando o caractere \""; // Escapando o caractere "
final unicode = '\u{1F60E}'; // 😎,  Escalar Unicode U+1F60E
```

Observe que valores hexadecimais de 4 dígitos também
podem ser usados diretamente (por exemplo, `\u2665`),
no entanto, chaves também funcionam. Para mais
informações sobre como trabalhar com caracteres
unicode, consulte
[Runes e _grapheme clusters_][Runes e _grapheme clusters_]
no tour da linguagem Dart.

[Runes e _grapheme clusters_]: /language/built-in-types#runes-and-grapheme-clusters

#### Concatenação de Strings e declaração multi-linha {:#string-concatenation-and-multiline-declaration}

Tanto em Dart quanto em Swift, você pode escapar
das quebras de linha em uma string multi-linha, o
que permite que você mantenha seu código-fonte mais
fácil de ler, mas ainda assim gere a `String` em
uma única linha. Dart tem várias maneiras de definir strings multi-linha:

1. Usando concatenação implícita de string:
   Quaisquer literais de string vizinhos são
   automaticamente concatenados, mesmo quando
   espalhados por várias linhas:

   ```dart
   final s1 = 'String '
     'concatenação'
     " funciona até em quebras de linha.";
   ```
 
2. Usando um literal de string multi-linha:
   Ao usar três aspas
   (simples ou duplas) em
   ambos os lados da string, o literal pode
   abrange várias linhas:


   ```dart
   final s2 = '''Você pode criar
   strings multi-linha como esta.''';

   final s3 = """Esta também é uma
   string multi-linha.""";
   ```

3. Dart também suporta a concatenação de strings
   usando o operador `+`. Isso funciona tanto com
   literais de string quanto com variáveis de string:


   ```dart
   final name = 'John';
   final greeting = 'Olá ' + name + '!';
   ```

#### Interpolação de string {:#string-interpolation}

Insira expressões no literal de string usando a
sintaxe `${<expressão>}`. Dart expande isso
permitindo que as chaves sejam omitidas quando a
expressão é um único identificador:

```dart
var food = 'pão';
var str = 'Eu como $food'; // Eu como pão
var str = 'Eu como ${bakery.bestSeller}'; // Eu como pão
```

Em Swift, você pode obter o mesmo resultado
cercando a variável ou expressão com parênteses
e prefixando com uma barra invertida:

```swift
let s = "interpolação de string"
let c = "Swift tem \(s), o que é muito útil."
```

#### Strings brutas {:#raw-strings}

Assim como em Swift, você pode definir strings brutas
em Dart. Uma string bruta ignora o caractere de escape
e inclui quaisquer caracteres especiais presentes na
string. Você pode fazer isso em Dart prefixando o
literal de string com a letra `r`, conforme mostrado
no exemplo a seguir.

```dart
// Inclui os caracteres \n.
final s1 = r'Inclui os caracteres \n.';
// Também inclui os caracteres \n.
final s2 = r"Também inclui os caracteres \n.";

final s3 = r'''
  Os caracteres \n também são incluídos
  ao usar strings multi-linha brutas.
  ''';
final s4 = r"""
  Os caracteres \n também são incluídos
  ao usar strings multi-linha brutas.
  """;
```

```swift
let s1 = #"Inclui os caracteres \n."#
let s2 = #"""
  Os caracteres \n também são incluídos
  ao usar strings multi-linha brutas.
  """#
```

#### Igualdade {:#equality}

Assim como em Swift, o operador de igualdade de Dart
(`==`) compara se duas strings são iguais. Duas
strings são iguais se contiverem a mesma sequência
de unidades de código.

```dart
final s1 = 'String '
  'concatenação'
  " funciona até em quebras de linha.";
assert(s1 ==
  'String concatenação funciona até em '
  'quebras de linha.');
```

#### API comumente usada {:#commonly-used-api}

Dart oferece várias APIs comuns para strings. Por
exemplo, tanto Dart quanto Swift permitem que você
verifique se uma string está vazia com `isEmpty`.
Existem outros métodos de conveniência, como
`toUpperCase` e `toLowerCase`. Para mais informações,
consulte [Strings][Strings] no tour da linguagem Dart.

[Strings]: /language/built-in-types#strings

### Booleanos {:#booleans}

Booleanos representam um valor binário tanto em Dart
(`bool`) quanto em Swift (`Bool`).

### _Null safety_ (segurança nula) {:#null-safety}

Dart impõe uma _null safety_ (segurança nula) sólida.
Por padrão, os tipos não permitem um valor nulo a
menos que sejam marcados como anuláveis. Dart indica
isso com um ponto de interrogação (`?`) no final do tipo.
Isso funciona como os _optionals_ do Swift.

### Operadores _null-aware_ {:#null-aware-operators}

Dart suporta vários operadores para lidar com a
anulabilidade. O operador de coalescência nula (`??`),
e o operador de encadeamento opcional (`?.`) estão
disponíveis em Dart e operam da mesma forma que em Swift:

```dart
a = a ?? b;
```

```swift
let str: String? = nil
let count = str?.count ?? 0
```

Além disso, Dart oferece uma versão _null safe_
(segura contra nulos) do operador _cascade_ (`?..`).
Este operador ignora quaisquer operações quando a
expressão de destino é resolvida como `null`. Dart
também oferece o operador de atribuição nula (`??=`),
que Swift não tem. Se uma variável com um tipo
anulável tem um valor atual de `null`, este operador
atribui um valor a essa variável. Expressa como
`a ??= b;`, serve como abreviação para o seguinte:

```dart
a = a ?? b;

// Atribui b a a se a for nulo; caso contrário, a permanece o mesmo
a ??= b;
```

```swift
a = a ?? b
```

#### Operador ! (também chamado de "desembrulho forçado") {:#operator-also-called-force-unwrap}

Nos casos em que é seguro presumir que uma variável
ou expressão anulável é, de fato, não nula, é
possível dizer ao compilador para reprimir quaisquer
erros em tempo de compilação.
Isso é feito usando
o operador sufixo `!`, colocando-o como um sufixo
na expressão. (Não confunda isso com o operador "não"
de Dart, que usa o mesmo símbolo):

```dart
int? a = 5;

int b = a; // Não permitido.
int b = a!; // Permitido.
```

Em tempo de execução, se `a` for nulo, ocorre um
erro de tempo de execução.

Assim como o operador `?.`, use o operador `!` ao
acessar propriedades ou métodos em um objeto:

```dart
myObject!.someProperty;
myObject!.someMethod();
```

Se `myObject` for `null` em tempo de execução,
ocorre um erro de tempo de execução.

### Campos _late_ {:#late-fields}

A palavra-chave `late` pode ser atribuída a campos
de classe para indicar que eles são inicializados em
um ponto posterior, permanecendo não anuláveis. Isso
é semelhante aos "optionals implicitamente
desembrulhados" do Swift. Isso é útil para casos
em que uma variável nunca é observada antes de ser
inicializada, permitindo que seja inicializada mais
tarde. Um campo `late` não anulável não pode ter
null atribuído em um ponto posterior. Além disso,
um campo `late` não anulável lança um erro de
tempo de execução quando observado antes de ser
inicializado, um cenário que você deseja evitar em um aplicativo bem comportado.

```dart
// Usando null safety:
class Coffee {
  late String _temperature;

  void heat() { _temperature = 'hot'; }
  void chill() { _temperature = 'iced'; }

  String serve() => _temperature + ' coffee';
}
```

Nesse caso, `_temperature` só é inicializada
após chamar `heat()` ou `chill()`. Se `serve()`
for chamado antes dos outros, ocorre uma exceção
em tempo de execução. Observe que `_temperature`
nunca pode ser `null`.

Você também pode usar a palavra-chave `late` para
tornar a inicialização preguiçosa ao combiná-la com um inicializador:

```dart
class Weather {
  late int _temperature = _readThermometer();
}
```

Nesse caso, `_readThermometer()` só é executado
quando o campo é acessado pela primeira vez,
e não na inicialização.

Outra vantagem em Dart é usar a palavra-chave
`late` para atrasar a inicialização de variáveis
`final`. Embora você não precise inicializar
imediatamente a variável `final` ao marcá-la
como `late`, ela ainda pode ser inicializada
apenas uma vez. Uma segunda atribuição resulta em um erro de tempo de execução.

```dart
late final int a;
a = 1;
a = 2; // Lança uma exceção de tempo de execução porque
       // "a" já está inicializado.
```

## Funções {:#functions}

Swift usa o arquivo `main.swift` como ponto de
entrada de um aplicativo. Dart usa a função `main`
como ponto de entrada de um aplicativo. Todo
programa deve ter uma função `main` para ser executável. Por exemplo:

```dart
void main() {
  // a função main é o ponto de entrada
  print("olá mundo");
}
```

```swift
// o arquivo main.swift é o ponto de entrada
print("olá mundo")
```

Dart não suporta `Tuples` (embora existam
[vários pacotes de tupla][several tuple packages] disponíveis em
pub.dev). No caso de uma função precisar retornar
vários valores, você pode envolvê-los em uma
coleção, como uma lista, set ou map, ou pode escrever
uma classe _wrapper_ (envoltório) onde uma instância
pode ser retornada que contém esses valores. Mais
sobre isso pode ser encontrado nas seções sobre
[coleções](#collections) e [classes](#classes).

[several tuple packages]: {{site.pub-pkg}}?q=tuples

### Tratamento de exceções e erros {:#exception-and-error-handling}

Assim como em Swift, as funções e métodos de Dart
suportam o tratamento de [exceções][exceptions] e [erros][errors].
Os _erros_ Dart geralmente representam erros do
programador ou falhas do sistema, como estouro de
pilha. Não se espera que erros Dart sejam capturados.
Por outro lado, as _exceções_ Dart representam uma
falha recuperável e devem ser capturadas. Por
exemplo, em tempo de execução, o código pode tentar
acessar um feed de _streaming_, mas, em vez disso,
recebe uma exceção que, se não for capturada, resulta
no encerramento do aplicativo. Você pode gerenciar
exceções em Dart envolvendo a chamada de função em um bloco `try-catch`.

[errors]: {{site.dart-api}}/dart-core/Error-class.html
[exceptions]: {{site.dart-api}}/dart-core/Exception-class.html

```dart
try {
  // Cria o objeto reprodutor de áudio
  audioPlayer = AVAudioPlayer(soundUrl);
            
  // Toca o som
  audioPlayer.play();
}
catch {
  // Não foi possível criar o objeto reprodutor de áudio, registra a exceção
  print("Não foi possível criar o reprodutor de áudio para o arquivo $soundFilename");
}
```

Da mesma forma, Swift usa um bloco `do-try-catch`.
Por exemplo:

```swift
do {
  // Cria o objeto reprodutor de áudio
  audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
            
  // Toca o som
  audioPlayer?.play()
}
catch {
  // Não foi possível criar o objeto reprodutor de áudio, registra o erro
  print("Não foi possível criar o reprodutor de áudio para o arquivo \(soundFilename)")
}
```

Você pode usar o bloco `try-catch` tanto em código
Dart síncrono quanto assíncrono. Para mais
informações, consulte os documentos para as
classes [`Error`][errors] e
[`Exception`][exceptions].

### Parâmetros {:#parameters}

Semelhante ao Swift, Dart suporta parâmetros nomeados
em suas funções. No entanto, ao contrário do Swift,
esses não são o padrão em Dart.
O tipo de parâmetro
padrão em Dart é um parâmetro posicional.

```dart
int multiply(int a, int b) {
  return a * b;
}
```

O equivalente em Swift precede um parâmetro com um
sublinhado para remover a necessidade de um rótulo
de argumento.

```swift
func multiply(_ a: Int, _ b: Int) -> Int {
  return a * b
}
```

Ao criar parâmetros nomeados em Dart, defina-os
em um bloco separado de chaves, após os parâmetros
posicionais:

```dart
int multiply(int a, int b, {int c = 1, int d = 1}) {
  return a * b * c * d;
}

// Chamando uma função com parâmetros obrigatórios e nomeados
multiply(3, 5); // 15
multiply(3, 5, c: 2); // 30
multiply(3, 5, d: 3); // 45
multiply(3, 5, c: 2, d: 3); // 90
```

```swift
// O equivalente em Swift
func multiply(_ a: Int, _ b: Int, c: Int = 1, d: Int = 1) -> Int {
  return a * b * c * d
}
```

Os parâmetros nomeados devem incluir um dos seguintes:

* Um valor padrão
* Um `?` no final do tipo para definir o tipo como anulável
* A palavra-chave `required` antes do tipo da variável

Para saber mais sobre tipos anuláveis, consulte [segurança nula](#null-safety).

Para marcar um parâmetro nomeado como obrigatório em
Dart, você deve prefixá-lo com a palavra-chave `required`:

```dart
int multiply(int a, int b, { required int c }) {
  return a * b * c;
}
// Ao chamar a função, c precisa ser fornecido
multiply(3, 5, c: 2);
```

Um terceiro tipo de parâmetro é o _parâmetro
posicional opcional_. Como o nome sugere, eles são
semelhantes aos parâmetros posicionais padrão,
mas podem ser omitidos ao chamar a função. Eles
devem ser listados após quaisquer parâmetros
posicionais obrigatórios e não podem ser usados em
conjunto com parâmetros nomeados.

```dart
int multiply(int a, int b, [int c = 1, int d = 1]) {
  return a * b * c * d;
}
// Chamando uma função com parâmetros posicionados obrigatórios e opcionais.
multiply(3, 5); // 15
multiply(3, 5, 2); // 30
multiply(3, 5, 2, 3); // 90
```

```swift
// O equivalente em Swift
func multiply(_ a: Int, _ b: Int, _ c: Int = 1, _ d: Int = 1) -> Int {
  return a * b * c * d
}
```

Como os parâmetros nomeados, os parâmetros
posicionais opcionais devem ter um valor padrão ou um tipo anulável.

### Funções de primeira classe {:#first-class-functions}

Assim como no Swift, as funções Dart também são
[cidadãos de primeira classe][first class citizens], o que significa
que são tratadas como qualquer outro objeto.
Por exemplo, o código a seguir mostra como retornar
uma função de uma função:

[first class citizens]: https://en.wikipedia.org/wiki/First-class_citizen

```dart
typedef int MultiplierFunction(int value);
// Define uma função que retorna outra função
MultiplierFunction multiplyBy(int multiplier) {
  return (int value) {
    return value * multiplier;
  };
}
// Chama a função que retorna uma nova função
MultiplierFunction multiplyByTwo = multiplyBy(2);
// Chama a nova função
print(multiplyByTwo(3)); // 6
```

```swift
// O equivalente em Swift da função Dart abaixo
// Define uma função que retorna um closure
typealias MultiplierFunction = (Int) -> (Int)

func multiplyBy(_ multiplier: Int) -> MultiplierFunction {
  return { $0 * multiplier} // Retorna um closure
}

// Chama a função que retorna uma função
let multiplyByTwo = multiplyBy(2)
// Chama a nova função
print(multiplyByTwo(3)) // 6
```

### Funções anônimas {:#anonymous-functions}

[_Funções anônimas_][_Anonymous functions_] em Dart funcionam quase
identicamente aos _closures_ (fechamentos) em Swift,
salvo uma diferença na sintaxe. Assim como as funções
nomeadas, você pode passar funções anônimas como
qualquer outro valor. Por exemplo, você pode
armazenar funções anônimas em uma variável, passá-las
como um argumento para outra função ou retorná-las de outra função.

[_Anonymous functions_]: https://en.wikipedia.org/wiki/Anonymous_function

Dart tem duas maneiras de declarar funções anônimas.
A primeira, com chaves, funciona como qualquer outra
função. Ela permite que você use várias linhas e
precisa de uma instrução de retorno para que
qualquer valor seja retornado.

```dart
// Função anônima multi-linha
[1,2,3].map((element) {
  return element * 2;
}).toList(); // [2, 4, 6]
```

:::note
Como a função map usada no exemplo retorna um
`Iterable<T>` em vez de um `List<T>`, a função
`toList` precisa ser chamada no `Iterator` retornado
para transformá-lo de volta em um `List`.
:::

```swift
  // Função anônima equivalente em Swift
  [1, 2, 3].map { $0 * 2 }
```

O outro método usa uma _arrow function_ (função
seta), nomeada após o símbolo semelhante a uma
seta usado em sua sintaxe. Você pode usar esta
sintaxe abreviada quando o corpo da sua função
contém apenas uma única expressão e onde o valor
é retornado. Isso omite a necessidade de quaisquer
chaves ou uma instrução de retorno, pois estas são implícitas.

```dart
// Função anônima de linha única
[1,2,3].map((element) => element * 2).toList(); // [2, 4, 6]
```

A escolha entre a sintaxe de seta ou chaves está
disponível para qualquer função, não apenas para funções
anônimas.

```dart
multiply(int a, int b) => a * b;

multiply(int a, int b) {
  return a * b;
}
```

### Funções geradoras {:#generator-functions}

Dart suporta [_funções geradoras_][_generator functions_] que retornam uma
coleção iterável de itens que são construídos de
forma preguiçosa. Adicione itens à iterável final
usando a palavra-chave `yield`, ou adicione coleções
inteiras de itens usando `yield*`.

[_generator functions_]: /language/functions#generators

O exemplo a seguir mostra como escrever uma função
geradora básica:

```dart
Iterable<int> listNumbers(int n) sync* {
  int k = 0;
  while (k < n) yield k++;
}

// Retorna um `Iterable<int>` que itera
// através de 0, 1, 2, 3 e 4.
print(listNumbers(5));

Iterable<int> doubleNumbersTo(int n) sync* {
  int k = 0;
  while (k < n) {
    yield* [k, k];
    k++;
  }
}

print(doubleNumbersTo(3)); // Retorna um iterável com [0, 0], [1, 1] e [2, 2].
```

Este é um exemplo de uma função geradora
**síncrona**. Você também pode definir funções
geradoras **assíncronas**, que retornam _streams_
(fluxos) em vez de iteráveis. Saiba mais na seção [Concorrência](#concurrency).

## Declarações {:#statements}

Esta seção aborda as semelhanças e diferenças nas
declarações entre Dart e Swift.

### Fluxo de controle (if/else, for, while, switch) {:#control-flow-if-else-for-while-switch}

Todas as instruções de fluxo de controle em Dart funcionam
de forma semelhante às suas contrapartes em Swift,
exceto por algumas diferenças na sintaxe.

#### if {:#if}

Ao contrário do Swift, a instrução `if` em Dart
requer parênteses ao redor da condição.
Embora o guia de estilo do Dart recomende o uso de
chaves em torno de instruções de controle de fluxo
(como mostrado abaixo), quando você tem uma instrução `if`
sem cláusula else e toda a instrução if
cabe em uma linha, você pode omitir as chaves se preferir.

```dart
var a = 1;
// Parênteses para condições são obrigatórios em Dart.
if (a == 1) {
  print('a == 1');
} else if (a == 2) {
  print('a == 2');
} else {
  print('a != 1 && a != 2');
}

// Chaves são opcionais para instruções `if` de uma única linha.
if (a == 1) print('a == 1');
```

```swift
let a = 1;
if a == 1 {
  print("a == 1")
} else if a == 2 {
  print("a == 2")
} else {
  print("a != 1 && a != 2")
}
```

#### for(-in) {:#for-in}

Em Swift, o loop `for` é usado apenas para percorrer
coleções. Para percorrer um pedaço de código
várias vezes, o Swift permite que você percorra um intervalo.
O Dart não suporta sintaxe para definir intervalos,
mas inclui um loop for padrão,
além do `for-in` que percorre coleções.

O loop `for-in` do Dart funciona como sua contraparte do Swift,
e pode percorrer qualquer valor que seja um `Iterable`,
como no exemplo de `List` abaixo:

```dart
var list = [0, 1, 2, 3, 4];
for (var i in list) {
  print(i);
}
```

```swift
let array = [0, 1, 2, 3, 4]
for i in array {
  print(i)
}
```

O Dart não possui nenhuma sintaxe especial com
loops `for-in` que permitam percorrer mapas,
como o Swift tem para dicionários.
Para obter um efeito semelhante, você pode
extrair as entradas do mapa como um tipo `Iterable`.
Alternativamente, você pode usar `Map.forEach`:

```dart
Map<String, int> dict = {
  'Foo': 1,
  'Bar': 2
};
for (var e in dict.entries) {
  print('${e.key}, ${e.value}');
}
dict.forEach((key, value) {
  print('$key, $value');
});
```

```swift
var dict:[String:Int] = [
  "Foo":1,
  "Bar":2
]
for (key, value) in dict {
   print("\(key),\(value)")
}
```

### Operadores {:#operators}

Ao contrário do Swift, o Dart não permite a adição
de novos operadores, mas permite que você sobrecarregue
operadores existentes com a palavra-chave `operator`.
Por exemplo:

```dart
class Vector {
  final double x;
  final double y;
  final double z;

  Vector operator +(Vector v) {
    return Vector(x: x + v.x, y: y + v.y, z: z+v.z);
  }
}
```

```swift
struct Vector {
  let x: Double
  let y: Double
  let z: Double
}

func +(lhs: Vector, rhs: Vector) -> Vector {
  return Vector(x: lhs.x + rhs.x, y: lhs.y + rhs.y, z: lhs.z + rhs.z)
}

...
```

### Operadores aritméticos {:#arithmetic-operators}

Na maior parte, os operadores aritméticos se comportam
da mesma forma no Swift e no Dart, com a notável
exceção do operador de divisão (`/`).
No Swift (e em muitas outras linguagens de programação),
o resultado de `let x = 5/2` é `2` (um inteiro).
No Dart, `int x = 5/2,` resulta em um valor de
`2.5` (um valor de ponto flutuante). Para obter um resultado inteiro,
use o operador de divisão truncada do Dart (`~/`).


:::secondary Diferença entre web e VM
Na web, um `integer` também é um `double`
(porque todos os números são),
mas na VM é um puro `int` truncado `2`.
(Truncado significa que o resultado é truncado
e não arredondado.) Por exemplo:

```dart
assert(25 == 50.4 ~/ 2);
assert(25 == 50.6 ~/ 2);
assert(25 == 51.6 ~/ 2);
```
:::

Embora os operadores `++` e `--` existissem em
versões anteriores do Swift, eles foram
[removidos no Swift 3.0][removidos no Swift 3.0].
Os equivalentes do Dart operam da mesma forma.
Por exemplo:

[removidos no Swift 3.0]: https://www.appsloveworld.com/swift/100/9/-is-deprecated-it-will-be-removed-in-swift-3

```dart
assert(2 + 3 == 5);
assert(2 - 3 == -1);
assert(2 * 3 == 6);
assert(5 / 2 == 2.5); // O resultado é um double
assert(5 ~/ 2 == 2); // O resultado é um int
assert(5 % 2 == 1); // Resto

a = 0;
b = ++a; // Incrementa a antes que b receba seu valor.
assert(a == b); // 1 == 1

a = 0;
b = a++; // Incrementa a DEPOIS que b recebe seu valor.
assert(a != b); // 1 != 0
```

### Operadores de teste de tipo {:#type-test-operators}

A implementação dos operadores de teste é um pouco
diferente entre as duas linguagens.

{% assign ckw = '&nbsp;<sup title="contextual keyword" alt="contextual keyword">1</sup>' %}
{% assign bii = '&nbsp;<sup title="built-in-identifier" alt="built-in-identifier">2</sup>' %}
{% assign lrw = '&nbsp;<sup title="limited reserved word" alt="limited reserved word">3</sup>' %}

| **Significado**                                  | **Operador Dart** | **Equivalente Swift**        |
| ------------------------------------------------ | ----------------- | ---------------------------- |
| Typecast (descrição abaixo)                      | expr as T         | expr as! T<br>expr as? T      |
| Verdadeiro se o objeto tiver o tipo especificado | expr is T         | expr is T                    |
| Verdadeiro se o objeto não tiver o tipo especificado | expr is! T        | !(expr is T)                 |

{:.table .table-striped .nowrap}

O resultado de `obj is T` é `true` se `obj`
for um subtipo do tipo especificado por `T`.
Por exemplo, `obj is Object?` é sempre verdadeiro.

Use o operador de typecast para converter um objeto
para um tipo específico &mdash; se e somente se &mdash; você tiver
certeza de que o objeto é desse tipo. Por exemplo:

```dart
(person as Employee).employeeNumber = 4204583;
```

O Dart tem apenas o operador de conversão de tipo único,
que age como o operador `as!` do Swift.
Não há equivalente para o operador `as?` do Swift.

```swift
(person as! Employee).employeeNumber = 4204583;
```

Se você não tem certeza de que o objeto é do tipo `T`,
então use `is T` para verificar antes de usar o objeto.

No Dart, a promoção de tipo atualiza os tipos de
variáveis locais dentro do escopo da instrução `if`.
Isso também acontece para verificações de nulos.
A promoção se aplica apenas a variáveis _locais_,
não a variáveis de instância.

```dart
if (person is Employee) {
  person.employeeNumber = 4204583;
}
```

```swift
// O Swift requer que a variável seja convertida.
if let person = person as? Employee {
  print(person.employeeNumber) 
}
```

#### Operadores lógicos {:#logical-operators}

Os operadores lógicos (como AND (`&&`),
OR (`||`) e NOT (`!`)) são idênticos
em ambas as linguagens. Por exemplo:

```dart
if (!done && (col == 0 || col == 3)) {
  // ...Faça alguma coisa...
}
```

#### Operadores bit a bit e de deslocamento {:#bitwise-and-shift-operators}

:::secondary Números na web
Na web,
o Dart usa operações bit a bit do JavaScript
para melhor desempenho, mas isso pode causar
comportamento diferente entre nativo e web
aplicações. Para mais informações,
consulte [Operações bit a bit][Operações bit a bit] na
página [Números no Dart][Números no Dart].
:::

[Operações bit a bit]: /resources/language/number-representation#bitwise-operations
[Números no Dart]: /resources/language/number-representation

Os operadores bit a bit são praticamente idênticos
em ambas as linguagens.

Por exemplo:

```dart
final value = 0x22;
final bitmask = 0x0f;

assert((value & bitmask) == 0x02); // AND
assert((value & ~bitmask) == 0x20); // AND NOT
assert((value | bitmask) == 0x2f); // OR
assert((value ^ bitmask) == 0x2d); // XOR
assert((value << 4) == 0x220); // Deslocamento para a esquerda
assert((value >> 4) == 0x02); // Deslocamento para a direita
assert((-value >> 4) == -0x03); // Deslocamento para a direita // O resultado pode diferir na web
```

#### Operador condicional {:#conditional-operator}

Tanto o Dart quanto o Swift contêm um operador condicional
(`?:`) para avaliar expressões que, de outra forma,
poderiam exigir instruções `if-else`:

```dart
final displayLabel = canAfford ? 'Please pay below' : 'Insufficient funds';
```

```swift
let displayLabel = canAfford ?  "Please pay below" : "Insufficient funds"
```

#### Cascades (.. operador) {:#cascades-operator}

Ao contrário do Swift, o Dart suporta cascata com
o operador de cascata. Isso permite que você
encadeie várias chamadas de método ou
atribuições de propriedade em um único objeto.

O exemplo a seguir mostra a configuração do
valor de várias propriedades e, em seguida, a chamada de
vários métodos em um objeto recém-construído,
tudo dentro de uma única cadeia usando o operador de cascata:

```dart
Animal animal = Animal()
  ..name = 'Bob'
  ..age = 5
  ..feed()
  ..walk();

print(animal.name); // "Bob"
print(animal.age); // 5
```

```swift
var animal = Animal()
animal.name = "Bob"
animal.age = 5
animal.feed()
animal.walk()

print(animal.name)
print(animal.age)
```

## Coleções {:#collections}

Esta seção aborda alguns tipos de coleção em
Swift e como eles se comparam aos seus equivalentes em Dart.

### Listas {:#lists}

Literais de `List` são definidos da mesma forma em Dart como
arrays são em Swift, usando colchetes e
separados por vírgulas. A sintaxe entre as duas
linguagens é muito semelhante, no entanto, existem algumas
diferenças sutis, mostradas no exemplo a seguir:

```dart
final List<String> list1 = <String>['one', 'two', 'three']; // Inicializa a lista e especifica o tipo completo
final list2 = <String>['one', 'two', 'three']; // Inicializa a lista usando o tipo abreviado
final list3 = ['one', 'two', 'three']; // O Dart também pode inferir o tipo
```

```swift
var list1: Array<String> = ["one", "two", "three"] // Inicializa o array e especifica o tipo completo
var list2: [String] = ["one", "two", "three"] // Inicializa o array usando o tipo abreviado
var list3 = ["one", "two", "three"] // O Swift também pode inferir o tipo
```

Os seguintes exemplos de código fornecem uma visão geral das
ações básicas que você pode realizar em uma `List` do Dart.
O primeiro exemplo mostra como recuperar um valor
de uma lista usando o operador `index`:

```dart
final fruits = ['apple', 'orange', 'pear'];
final fruit = fruits[1];
```

Para adicionar um valor ao final da lista,
use o método `add`. Para adicionar outra `List`,
use o método `addAll`:

```dart
final fruits = ['apple', 'orange', 'pear'];
fruits.add('peach');
fruits.addAll(['kiwi', 'mango']);
```

Para a API completa da List,
consulte a documentação da [`List` class].

[`List` class]: {{site.dart-api}}/dart-core/List-class.html

#### Imutável

Atribuir um array a uma constante (`let` no Swift)
torna o array imutável, o que significa que seu tamanho e
conteúdo não podem ser alterados. Você também não pode atribuir
um novo array a uma constante.

No Dart, isso funciona de forma um pouco diferente e,
dependendo de suas necessidades,
você tem várias opções para escolher:

*   Se a lista for uma constante de tempo de compilação e não deve
    ser modificada, use a palavra-chave `const`:<br>
    `const fruits = ['apple', 'orange', 'pear'];`
*   Atribua a lista a um campo `final`.
    Isso significa que a lista em si não
    precisa ser uma constante de tempo de compilação e
    garante que o campo não possa ser substituído
    por outra lista. No entanto,
    ainda permite que o tamanho ou o conteúdo
    da lista seja modificado:<br>
    `final fruits = ['apple', 'orange', 'pear'];`
*   Crie uma `final List` usando o construtor imutável
    (mostrado no exemplo a seguir).
    Isso cria uma `List` que não pode alterar seu tamanho
    ou conteúdo, fazendo com que ela se comporte como um `Array`
    constante no Swift.

```dart
final fruits = List<String>.unmodifiable(['apple', 'orange', 'pear']);
```

```swift
let fruits = ["apple", "orange", "pear"]
```

#### Operadores de propagação (spread operators) {:#spread-operators}

Outro recurso útil no Dart é o **operador de propagação**
(`...`) e o **operador de propagação com reconhecimento de nulo** (`...?`),
que fornecem uma maneira concisa de inserir vários valores
em uma coleção.

Por exemplo, você pode usar o operador de propagação
(`...`) para inserir todos os valores de uma lista
em outra lista, como mostrado abaixo:

```dart
final list = [1, 2, 3];
final list2 = [0, ...list]; // [ 0, 1, 2, 3 ]
assert(list2.length == 4);
```

Embora o Swift não tenha operador de propagação,
o equivalente à linha 2 acima seria
o seguinte:

```swift
let list2 = [0] + list
```

Se a expressão à direita do operador de propagação
puder ser `null`, você pode evitar exceções usando
um operador de propagação com reconhecimento de nulo (`...?`):

```dart
List<int>? list;
final list2 = [0, ...?list]; //[ 0 ]
assert(list2.length == 1);
```

```swift
let list2 = [0] + list ?? []
```

### Conjuntos (Sets) {:#sets}

Tanto o Dart quanto o Swift suportam a definição de `Set`s com literais.
Os conjuntos são definidos da mesma forma que as listas,
mas usando chaves em vez de colchetes.
Os conjuntos são coleções não ordenadas que contêm apenas itens exclusivos.
A exclusividade desses itens é implementada usando
códigos de hash, o que significa que os objetos precisam de valores de hash
para serem armazenados em um `Set`. Cada objeto Dart contém
um código de hash, enquanto no Swift você precisa aplicar explicitamente
o protocolo `Hashable` antes que o objeto
possa ser armazenado em um `Set`.

:::note
No Dart, o `hashCode` herdado da
classe `Object` é baseado apenas na identidade do objeto.
Se o operador `==` puder tornar objetos não idênticos iguais,
o getter `hashCode` precisará ser substituído para corresponder
à igualdade. Para mais informações,
consulte a página da API para a [`hashCode` property][`hashCode` property].
:::

Os seguintes trechos de código mostram as diferenças
entre inicializar um `Set` em Dart e Swift:

```dart
final abc = {'a', 'b', 'c'};
```

```swift
var abc: Set<String> = ["a", "b", "c"]
```

Você não cria um conjunto vazio em Dart
especificando chaves vazias (`{}`);
isso resulta na criação de um `Map` vazio.
Para criar um `Set` vazio,
preceda a declaração `{}` com um argumento de tipo
ou atribua `{}` a uma variável do tipo `Set`:

```dart
final names = <String>{};
Set<String> alsoNames = {}; // Isso também funciona.
// final names = {}; // Cria um mapa vazio, não um conjunto.
```

#### Imutável

Semelhante a `List`, `Set` também tem uma versão imutável.
Por exemplo:

```dart
final abc = Set<String>.unmodifiable(['a', 'b', 'c']);
```

```swift
let abc: Set<String> = ["a", "b", "c"]
```

### Mapas {:#maps}

O tipo `Map` em Dart pode ser comparado com o
tipo `Dictionary` em Swift. Ambos os tipos associam
chaves e valores. Essas chaves e valores podem ser qualquer
tipo de objeto. Cada chave ocorre apenas uma vez,
mas você pode usar o mesmo valor várias vezes.

Em ambas as linguagens, o dicionário é baseado em uma tabela de hash,
o que significa que as chaves precisam ser hasheáveis.
No Dart, cada objeto contém um hash enquanto no Swift
você precisa aplicar explicitamente o protocolo `Hashable`
antes que o objeto possa ser armazenado em um `Dictionary`.

:::note
No Dart, o `hashCode` herdado da classe `Object`
é baseado apenas na identidade do objeto.
Se o operador `==` puder tornar objetos não idênticos iguais,
o getter `hashCode` precisará ser substituído para corresponder
à igualdade. Para mais informações,
consulte a página da API para a [`hashCode` property][`hashCode` property].
:::

[`hashCode` property]: {{site.dart-api}}/dart-core/Object/hashCode.html

Aqui estão alguns exemplos simples de `Map` e `Dictionary`,
criados usando literais:

```dart
final gifts = {
 'first': 'partridge',
 'second': 'turtle doves',
 'fifth': 'golden rings',
};

final nobleGases = {
 2: 'helium',
 10: 'neon',
 18: 'argon',
};
```

```swift
let gifts = [
   "first": "partridge",
   "second": "turtle doves",
   "fifth": "golden rings",
]

let nobleGases = [
   2: "helium",
   10: "neon",
   18: "argon",
]
```

Os seguintes exemplos de código fornecem uma visão geral
das ações básicas que você pode realizar em um
`Map` do Dart. O primeiro exemplo mostra como
recuperar um valor de um `Map` usando o operador `key`:

```dart
final gifts = {'first': 'partridge'};
final gift = gifts['first']; // 'partridge'
```

Use o método `containsKey` para verificar se uma
chave já está presente no `Map`:

```dart
final gifts = {'first': 'partridge'};
assert(gifts.containsKey('fifth')); // false
```

Use o operador de atribuição de índice (`[]=`) para adicionar
ou atualizar uma entrada no `Map`. Se o `Map`
ainda não contiver a chave, a entrada será adicionada.
Se a chave estiver presente, o valor da entrada será atualizado:

```dart
final gifts = {'first': 'partridge'};
gifts['second'] = 'turtle'; // É adicionado
gifts['second'] = 'turtle doves'; // É atualizado
```

Para remover uma entrada do `Map` use o método `remove`,
e para remover todas as entradas que satisfaçam um determinado teste
use o método `removeWhere`:

```dart
final gifts = {'first': 'partridge'};
gifts.remove('first');
gifts.removeWhere((key, value) => value == 'partridge');
```

## Classes {:#classes}

O Dart não define um tipo de interface &mdash; _qualquer_
classe pode ser usada como uma interface.
Se você quiser introduzir apenas uma interface,
crie uma classe abstrata sem membros concretos.
Para obter uma compreensão mais detalhada dessas categorias,
consulte a documentação nas seções
[classes abstratas](#abstract-classes),
[interfaces implícitas](#implicit-interfaces)
e [estendendo uma classe](#extending-a-class).

O Dart não oferece suporte para tipos de valor.
Conforme mencionado na seção [Tipos integrados](#built-in-types),
todos os tipos em Dart são tipos de referência (mesmo primitivos),
o que significa que o Dart não fornece uma palavra-chave `struct`.

### Enums {:#enums}

Tipos enumerados, geralmente chamados de enumerações ou enums,
são um tipo especial de classe usado para representar
um número fixo de valores constantes. Os enums fazem
parte da linguagem Dart há muito tempo,
mas o Dart 2.17 adicionou suporte aprimorado a enums para membros.
Isso significa que você pode adicionar campos que mantêm o estado,
construtores que definem esse estado,
métodos com funcionalidade,
e até mesmo substituir membros existentes.
Para mais informações, consulte
[Declarando enums aprimorados][Declarando enums aprimorados] no tour da linguagem Dart.

[Declarando enums aprimorados]: /language/enums#declaring-enhanced-enums

### Construtores {:#constructors}

Os construtores de classe do Dart funcionam de forma semelhante aos
inicializadores de classe no Swift. No entanto, no Dart,
eles oferecem mais funcionalidade para definir propriedades de classe.

#### Construtor padrão {:#standard-constructor}

Um construtor de classe padrão parece muito semelhante
a um inicializador do Swift, tanto na declaração quanto na chamada.
Em vez da palavra-chave `init`, o Dart usa o nome completo da classe.
A palavra-chave `new`, antes obrigatória para criar novas
instâncias de classe, agora é opcional e não é mais recomendada.

```dart
class Point {
  double x = 0;
  double y = 0;

  Point(double x, double y) {
    // Há uma maneira melhor de fazer isso no Dart, fique ligado.
    this.x = x;
    this.y = y;
  }
}

// Cria uma nova instância da classe Point
Point p = Point(3, 5);
```

#### Parâmetros do construtor {:#constructor-parameters}

Como escrever código para atribuir todos os campos da classe
no construtor costuma ser bastante redundante,
o Dart tem um pouco de açúcar sintático para tornar isso mais fácil:

```dart
class Point {
  double x;
  double y;

  // Açúcar sintático para definir x e y
  // antes que o corpo do construtor seja executado.
  Point(this.x, this.y);
}

// Cria uma nova instância da classe Point
Point p = Point(3, 5);
```

Semelhante às funções, os construtores também podem receber
parâmetros posicionais ou nomeados opcionais:

```dart
class Point {
  ...
  // Com um parâmetro posicionado opcional
  Point(this.x, [this.y = 0]);
  // Com parâmetros nomeados
  Point({required this.y, this.x = 0});
  // Com parâmetros posicionais e nomeados
  Point(int x, int y, {int scale = 1}) {
    ...
  }
  ...
}
```

#### Listas de inicializadores {:#initializer-lists}

Você também pode usar listas de inicializadores,
que são executadas após quaisquer campos que sejam definidos diretamente
usando `this` nos parâmetros do construtor,
mas ainda antes do corpo do construtor:

```dart
class Point {
  ...
  Point(Map<String, double> json)
      : x = json['x']!,
        y = json['y']! {
    print('In Point.fromJson(): ($x, $y)');
  }
  ...
}
```

Uma lista de inicializadores é um bom lugar para usar um assert.

#### Construtores nomeados {:#named-constructors}

Ao contrário do Swift, o Dart permite que as classes tenham vários
construtores, permitindo que você os nomeie.
Você tem a opção de usar um construtor sem nome,
mas quaisquer construtores adicionais devem ser nomeados.
Uma classe também pode ter apenas construtores nomeados.

```dart
class Point {
  double x;
  double y;

  Point(this.x, this.y);

  // Construtor nomeado
  Point.fromJson(Map<String, double> json)
      : x = json['x']!,
        y = json['y']!;
}
```

#### Construtores Const {:#const-constructors}

Quando as instâncias de sua classe são sempre imutáveis
(imutáveis), você pode impor isso adicionando um
construtor `const`. Remover um construtor `const`
é uma mudança de quebra para aqueles que usam sua classe,
então empregue esse recurso criteriosamente.
Definir um construtor como `const` torna a classe
imutável: todos os campos não estáticos na classe
devem ser sinalizados como `final`.

```dart
class ImmutablePoint {
  final double x, y;

  const ImmutablePoint(this.x, this.y);
}
```

Isso também significa que você pode usar essa classe como um valor constante,
tornando o objeto uma constante de tempo de compilação:

```dart
const ImmutablePoint origin = ImmutablePoint(0, 0);
```

#### Redirecionamento de construtor {:#constructor-redirection}

Você pode chamar construtores de outros construtores,
por exemplo, para evitar duplicação de código ou para
adicionar padrões adicionais para parâmetros:

```dart
class Point {
  double x, y;

  // O construtor principal para esta classe.
  Point(this.x, this.y);

  // Delega ao construtor principal.
  Point.alongXAxis(double x) : this(x, 0);
}
```

#### Construtores de fábrica {:#factory-constructors}

Você pode usar construtores de fábrica quando não
precisar criar uma nova instância de classe.
Um exemplo é se uma instância em cache puder ser retornada em vez disso:

```dart
class Logger {
  static final Map<String, Logger> _cache =
    <String, Logger>{};
  
  final String name;
  
  // Construtor de fábrica que retorna uma cópia em cache,
  // ou cria uma nova se ainda não estiver disponível.
  factory Logger(String name)=> _cache[name] ??= Logger._internal(name);
  // Construtor privado usado apenas nesta biblioteca
  Logger._internal(this.name);
}
```

### Métodos {:#methods}

Tanto no Dart quanto no Swift, os métodos são funções
que fornecem comportamento para um objeto.

```dart
void doSomething() { // Isso é uma função
 // Implementação..
}

class Example {
 void doSomething() { // Isso é um método
   // Implementação..
 }
}
```

```swift
func doSomething() { // Isso é uma função
  // Implementação..
}

class Example {
  func doSomething() { // Isso é um método
    // Implementação..
  }
}
```

### Getters e setters {:#getters-and-setters}

Você pode definir getters e setters prefixando um nome de campo
com uma palavra-chave `get` ou `set`. Você deve se lembrar
que cada campo de instância tem um getter implícito,
mais um setter, se apropriado. No Swift,
a sintaxe é um pouco diferente,
pois as palavras-chave `get` e `set` precisam ser definidas
dentro de uma declaração de propriedade e só podem ser definidas
como uma declaração, não como uma expressão:

```dart
class Rectangle {
  double left, top, width, height;

  Rectangle(this.left, this.top, this.width, this.height);

  // Define duas propriedades calculadas: right e bottom.
  double get right => left + width;
  set right(double value) => width = value - left;

  double get bottom => top + height;
  set bottom(double value) => height = value - top;
}
```

```swift
class Rectangle {
 var left, top, width, height: Double;

 init(left: Double, top: Double, width: Double, height: Double) {
   self.left = left
   self.top = top
   self.width = width
   self.height = height
 }

 // Define duas propriedades calculadas: right e bottom.
 var right: Double {
   get {
     return left + width
   }
   set { width = newValue - left }
 }

 var bottom: Double {
   get {
     return top + height
   }
   set { height = newValue - top }
 }
}
```

### Classes abstratas {:#abstract-classes}

O Dart tem o conceito de classes _abstratas_,
algo que não é suportado pelo Swift.
Classes abstratas não podem ser instanciadas diretamente e
só podem ser subclasses. Isso torna as classes abstratas
úteis para definir interfaces (comparável a um protocolo no Swift).

Classes abstratas geralmente contêm métodos _abstratos_,
que são declarações de métodos que não possuem uma
implementação. Subclasses não abstratas são forçadas
a sobrescrever esses métodos e fornecer uma
implementação apropriada. Uma classe abstrata também pode conter métodos
com uma implementação padrão.
As subclasses herdam essa implementação
se não sobrescreverem esses métodos ao
estender a classe abstrata.

Para definir uma classe abstrata, use o modificador `abstract`.
O exemplo a seguir declara uma classe abstrata
que possui um método abstrato e um método
contendo uma implementação padrão:

```dart
// Esta classe é declarada abstrata e, portanto, não pode ser instanciada.
abstract class AbstractContainer {
  void updateChildren(); // Método abstrato.

  // Método com implementação padrão.
  String toString() => "AbstractContainer";
}
```

### Interfaces implícitas {:#implicit-interfaces}

Na linguagem Dart, cada classe define implicitamente
uma interface contendo todos os
membros da instância da classe e de qualquer
interface que ela implemente. Se você quiser criar
uma classe `A` que suporte a API da classe `B`
sem herdar a implementação de `B`,
a classe `A` deve implementar a interface `B`.

Ao contrário do Dart, as classes Swift não definem implicitamente
uma interface. A interface precisa ser explicitamente
definida como um protocolo e implementada pelo desenvolvedor.

Uma classe pode implementar uma ou mais interfaces
e então fornecer as APIs exigidas pelas interfaces.
Tanto o Dart quanto o Swift têm maneiras diferentes de
implementar interfaces. Por exemplo:

```dart
abstract class Animal {
  int getLegs();
  void makeNoise();
}

class Dog implements Animal {
  @override
  int getLegs() => 4;

  @override
  void makeNoise() => print('Woof woof');
}
```

```swift
protocol Animal {
   func getLegs() -> Int;
   func makeNoise()
}

class Dog: Animal {
  func getLegs() -> Int {
    return 4;
  }

  func makeNoise() {
    print("Woof woof"); 
  }
}
```

### Estendendo uma classe {:#extending-a-class}

A herança de classe em Dart é muito semelhante ao Swift.
No Dart, você pode usar `extends` para criar uma subclasse,
e `super` para se referir à superclasse:

```dart
abstract class Animal {
  // Define constructors, fields, methods...
}

class Dog extends Animal {
  // Define constructors, fields, methods...
}
```

```swift
class Animal {
  // Define constructors, fields, methods...
}

class Dog: Animal {
  // Define constructors, fields, methods...
}
```

### Mixins {:#mixins}

Mixins permitem que seu código compartilhe funcionalidades entre classes.
Você pode usar os campos e métodos do mixin em uma classe,
utilizando sua funcionalidade como se fosse parte da classe.
Uma classe pode usar múltiplos mixins&mdash;o que é útil
quando várias classes compartilham a mesma funcionalidade&mdash;sem
necessidade de herdar umas das outras ou compartilhar um ancestral comum.

Enquanto Swift não suporta mixins, ele pode aproximar
essa funcionalidade se você escrever um protocolo junto
com uma extensão que fornece implementações padrão
para os métodos especificados no protocolo.
O principal problema com essa abordagem é que,
diferentemente do Dart,
essas extensões de protocolo não mantêm seu próprio estado.

Você pode declarar um mixin assim como uma classe regular,
contanto que ele não estenda nenhuma classe além de `Object`
e não tenha construtores. Use a palavra-chave `with` para adicionar
um ou mais mixins separados por vírgula a uma classe.

O exemplo a seguir mostra como esse comportamento é
alcançado em Dart, e como um comportamento similar é
replicado em Swift:

```dart
abstract class Animal {}

// Definindo os mixins
mixin Flyer {
  fly() => print('Bate as asas');
}
mixin Walker {
  walk() => print('Anda com as pernas');
}
  
class Bat extends Animal with Flyer {}
class Goose extends Animal with Flyer, Walker {}
class Dog extends Animal with Walker {}

// Chamadas corretas
Bat().fly();
Goose().fly();
Goose().walk();
Dog().walk();

// Chamadas incorretas
Bat().walk(); // Não está usando o mixin Walker
Dog().fly(); // Não está usando o mixin Flyer
class Animal {
}
```

```swift
// Definindo os "mixins"
protocol Flyer {
  func fly()
}

extension Flyer {
  func fly() {
    print("Bate as asas")
  }
}

protocol Walker {
  func walk()
}

extension Walker {
  func walk() {
    print("Anda com as pernas")
  }
}

class Bat: Animal, Flyer {}
class Goose: Animal, Flyer, Walker {}
class Dog: Animal, Walker {}

// Chamadas corretas
Bat().fly();
Goose().fly();
Goose().walk();
Dog().walk();

// Chamadas incorretas
Bat().walk(); // `bat` não tem o método `walk`
Dog().fly(); // "dog" não tem o método `fly`
```

Substituir a palavra-chave `class` por `mixin`
impede que o mixin seja usado como uma classe regular.

```dart
mixin Walker {
  walk() => print('Anda com as pernas');
}

// Impossível, pois Walker não é mais uma classe.
class Bat extends Walker {}
```

:::note
A palavra-chave `extends` é abordada mais adiante em
[Estendendo uma classe][Estendendo uma classe] no guia da linguagem Dart.
:::

[Estendendo uma classe]: /language/generics#restricting-the-parameterized-type

Já que você pode usar múltiplos mixins,
seus métodos ou campos podem se sobrepor uns aos outros
quando usados na mesma classe.
Eles podem até se sobrepor com a classe que os usa,
ou com a superclasse dessa classe. Para contornar isso,
Dart os empilha um sobre o outro,
então a ordem em que eles são adicionados a uma classe importa.

Para dar um exemplo:

```dart
class Bird extends Animal with Consumer, Flyer {
```

Quando um método é chamado em uma instância de `Bird`,
Dart começa na base da pilha com sua própria classe,
`Bird`, que tem precedência sobre outras implementações.
Se `Bird` não tiver implementação,
então Dart continua subindo na pilha,
com `Flyer` em seguida, seguido por `Consumer`,
até que uma implementação seja encontrada.
Se nenhuma implementação for encontrada,
a classe pai, `Animal`, é verificada por último.

### Métodos de extensão {:#extension-methods}

Assim como Swift, Dart oferece métodos de extensão que permitem que você
adicione funcionalidade&mdash;especificamente, métodos,
getters, setters e operadores&mdash;a tipos existentes.
A sintaxe tanto em Dart quanto em Swift para criar uma
extensão parece muito similar:

```dart
extension <nome> on <tipo> {
  (<definição de membro>)*
}
```

```swift
extension <tipo> {
  (<definição de membro>)*
}
```

Como exemplo, a extensão a seguir na classe
`String` do SDK do Dart
permite analisar inteiros:

```dart
extension NumberParsing on String {
  int parseInt() {
    return int.parse(this);
  }
}

print('21'.parseInt() * 2); // 42
```

```swift
extension String {
  func parseInt() -> Int {
    return Int(self) ?? 0
  }
}

print("21".parseInt() * 2) // 42
```

Embora as extensões sejam similares em Dart e Swift,
há algumas diferenças importantes. As seções seguintes
cobrem as diferenças mais importantes,
mas confira [Métodos de extensão][Métodos de extensão] para uma
visão geral completa.

[Métodos de extensão]: /language/extension-methods

:::note
Dart não oferece suporte a estender um tipo existente
para fazê-lo adotar um ou mais protocolos.
:::

#### Extensões nomeadas {:#named-extensions}

Embora não seja obrigatório, você pode nomear uma extensão em Dart.
Nomear uma extensão permite que você controle seu
escopo&mdash;significando que é possível tanto
ocultar ou mostrar a extensão caso ela entre em conflito
com outra biblioteca. Se o nome começar com um sublinhado,
a extensão só estará disponível dentro da biblioteca
na qual ela foi definida.

```dart
// Oculta "MyExtension" ao importar tipos de
// "path/to/file.dart".
import 'path/to/file.dart' hide MyExtension;
// Mostra apenas "MyExtension" ao importar tipos
// de "path/to/file.dart".
import 'path/to/file.dart' show MyExtension;

// O método `shout()` está disponível apenas dentro desta biblioteca.
extension _Private on String {
  String shout() => this.toUpperCase();
}
```

#### Inicializadores {:#initializers}

Em Swift, você pode usar extensões para adicionar novos
inicializadores de conveniência a um tipo. Em Dart,
você não pode usar extensões para adicionar construtores
adicionais a uma classe, mas você pode adicionar um
método de extensão estático que cria uma instância
do tipo. Considere o seguinte exemplo:

```dart
class Person {
  Person(this.fullName);

  final String fullName;
}

extension ExtendedPerson on Person {
  static Person create(String firstName, String lastName) {
    return Person("$firstName $lastName");
  }
}

// Para usar o método factory, use o nome da
// extensão, não o tipo.
final person = ExtendedPerson.create('John', 'Doe');
```

### Sobrescrevendo membros {:#overriding-members}

Sobrescrever métodos de instância (incluindo operadores,
getters e setters) também é muito similar entre
as duas linguagens. Em Dart, você pode usar a
anotação `@override` para indicar que você está
intencionalmente sobrescrevendo um membro:

```dart
class Animal {
  void makeNoise => print('Barulho');
}

class Dog implements Animal {
  @override
  void makeNoise() => print('Au au');
}
```

Em Swift, você adiciona a palavra-chave `override`
à definição do método:

```swift
class Animal {
  func makeNoise() {
    print("Barulho")
  }
}

class Dog: Animal {
  override func makeNoise() {
    print("Au au");
  }
}
```

## Genéricos {:#generics}

Como em Swift, Dart oferece suporte ao uso de genéricos
para melhorar a segurança de tipos ou reduzir a duplicação de código.

### Métodos genéricos {:#generic-methods}

Você pode aplicar genéricos a métodos.
Para definir um tipo genérico, coloque-o entre
símbolos `< >` após o nome do método.
Esse tipo pode então ser usado dentro do método
(como o tipo de retorno), ou nos parâmetros do método:

```dart
// Definindo um método que usa genéricos.
T transform<T>(T param) {
  // Por exemplo, fazendo alguma transformação em `param`...
  return param;
}

// Chamando o método. A variável "str" será
// do tipo String.
var str = transform('valor string');
```

Nesse caso, passar `String` para o método `transform`
garante que ele retorne uma `String`.
Da mesma forma, se um `int` for fornecido,
o valor de retorno é um `int`.

Defina múltiplos genéricos separando-os
com uma vírgula:

```dart
// Definindo um método com múltiplos genéricos.
T transform<T, Q>(T param1, Q param2) {
  // ...
}
// Chamando o método com tipos definidos explicitamente.
transform<int, String>(5, 'valor string');
// Os tipos são opcionais quando podem ser inferidos.
transform(5, 'valor string');
```

### Classes genéricas {:#generic-classes}

Genéricos também podem ser aplicados a classes.
Você pode especificar o tipo ao chamar um construtor,
o que permite que você personalize classes reutilizáveis para tipos específicos.

No exemplo a seguir,
a classe `Cache` é para armazenar em cache tipos específicos:

```dart
class Cache<T> {
  T getByKey(String key) {}
  void setByKey(String key, T value) {}
}
// Criando um cache para strings.
// stringCache tem o tipo Cache<String>
var stringCache = Cache<String>();
// Válido, definindo um valor string.
stringCache.setByKey('Foo', 'Bar')
// Inválido, o tipo int não corresponde ao genérico.
stringCache.setByKey('Baz', 5)
```

Se a declaração de tipo for omitida,
o tipo em tempo de execução é `Cache<dynamic>`
e ambas as chamadas para `setByKey` são válidas.

### Restringindo genéricos {:#restricting-generics}
Você pode usar genéricos para restringir seu código a uma
família de tipos usando `extends`. Isso garante
que sua classe seja instanciada com um tipo genérico
que estenda um tipo específico (e é similar ao Swift):

```dart
class NumberManager<T extends num> {
  // ...
}
// Válido
var manager = NumberManager<int>();
var manager = NumberManager<double>();
// Inválido, nem String nem suas classes pai estendem num.
var manager = NumberManager<String>();
```

### Genéricos em literais {:#generics-in-literals}

Literais `Map-`, `Set-` e `List-` podem declarar
tipos genéricos explicitamente, o que é útil quando o
tipo não é inferido ou é inferido incorretamente.

Por exemplo, a classe `List` tem uma definição genérica:
`class List<E>`. O tipo genérico `E` se refere ao tipo
do conteúdo da lista. Normalmente,
esse tipo é inferido automaticamente,
o que é usado em alguns tipos de membros da classe `List`.
(Por exemplo, seu primeiro getter retorna um valor do tipo `E`).
Ao definir um literal `List`,
você pode definir explicitamente o tipo genérico da seguinte forma:

```dart
var objList = [5, 2.0]; // Tipo: List<num> // Inferência automática de tipo
var objList = <Object>[5, 2.0]; // Tipo: List<Object> // Definição explícita de tipo
var objSet = <Object>{5, 2.0}; // Sets funcionam de forma idêntica
```

Isso também é verdade para um `Map`,
que também define seus tipos de `chave` e `valor`
usando genéricos (`class Map<K, V>)`:

```dart
// Inferência automática de tipo
var map = {
  'foo': 'bar'
}; // Tipo: Map<String, String>
// Definição explícita de tipo:
var map = <String, Object>{
  'foo': 'bar'
}; // Tipo: Map<String, Object>
```

## Concorrência {:#concurrency}

Swift suporta multithreading e Dart suporta isolates,
que são similares a threads leves
e não serão abordados aqui.
Cada isolate tem seu próprio loop de eventos.
Para mais informações, veja [Como isolates funcionam][Como isolates funcionam].

[Como isolates funcionam]: /language/concurrency#isolates

### Futures {:#futures}

Swift vanilla não tem uma contraparte para `Future` do Dart.
No entanto, você pode conhecer esse objeto se estiver familiarizado
com o framework Combine da Apple, ou bibliotecas de terceiros
como RxSwift ou PromiseKit.

Em poucas palavras, um future representa o resultado
de uma operação assíncrona, que se torna disponível
em um momento posterior. Se você tem uma função que retorna
um `Future` de uma `String` (`Future<String>`)
em vez de apenas uma `String`,
você está basicamente recebendo um valor que pode existir
algum tempo depois&mdash;no futuro.

Quando a operação assíncrona de um future é concluída,
o valor se torna disponível. Você deve ter em mente,
no entanto, que um future também pode ser concluído com um erro
em vez de um valor.

Um exemplo disso seria se você fizesse uma requisição HTTP,
e imediatamente recebesse um future como a resposta.
Assim que o resultado chegar, o future é concluído
com esse valor. No entanto, se a requisição HTTP falhar,
digamos porque a conexão com a internet foi interrompida,
o future é concluído com um erro.

Futures também podem ser criados manualmente.
A maneira mais fácil de criar um future é
definindo e chamando uma função `async`,
que é discutida na próxima seção.
Quando você tem um valor que precisa ser um `Future`,
você pode facilmente transformá-lo em um usando a classe `Future`:

```dart
String str = 'Valor String';
Future<String> strFuture = Future<String>.value(str);
```

#### Async/await {:#async-await}

Enquanto futures não fazem parte do Swift vanilla,
a sintaxe `async/await` em Dart tem uma contraparte em Swift,
e funciona de forma similar, embora sem objetos `Future`.

Como em Swift, funções podem ser marcadas como `async`.
A diferença em Dart é que qualquer função `async`
sempre retorna implicitamente um `Future`.
Por exemplo, se sua função retorna uma `String`,
a contraparte async dessa função retorna um
`Future<String>`.

A palavra-chave `throws` que é colocada após a
palavra-chave `async` em Swift
(mas apenas se a função for lançável),
não existe na sintaxe do Dart porque
exceções e erros do Dart não são verificados pelo compilador.
Em vez disso, se uma exceção ocorrer em uma função async,
o `Future` retornado falha com a exceção,
que pode então ser tratada apropriadamente.

```dart
// Retorna um future de uma string, pois o método é async
Future<String> fetchString() async {
  // Tipicamente, algumas outras operações async seriam feitas aqui.
  
  Response response = await makeNetworkRequest();
  if (!response.success) {
    throw BadNetwork();
  }

  return 'Valor String';
}
```

Essa função async pode então ser chamada da seguinte forma:

```dart
String stringFuture = await fetchString();
print(str); // "Valor String"
```

A função async equivalente em Swift:

```swift
func fetchString() async throws -> String {
  // Tipicamente, algumas outras operações async seriam feitas aqui.
  let response = makeNetworkRequest()
  if !response.success {
    throw BadNetwork()
  }
  
  return "Valor String"
}
```

Similarmente, qualquer exceção que ocorra na função
`async` pode ser tratada da mesma forma que o tratamento
de um `Future` falho, usando o método `catchError`.

Em Swift, uma função async não pode ser invocada de
um contexto não-async. Em Dart, você tem permissão para fazer isso,
mas você deve tratar o `Future` resultante adequadamente.
É considerado uma má prática chamar uma função async
de um contexto não-async desnecessariamente.

Como Swift, Dart também tem a palavra-chave `await`.
Em Swift, `await` só é utilizável ao chamar
funções `async`, mas o `await` do Dart funciona com
a classe `Future`. Como resultado, `await` também
funciona com funções `async` porque todas as funções `async`
retornam futures em Dart.

Aguardar um future suspende a execução da função atual
e retorna o controle para o loop de eventos,
que pode trabalhar em outra coisa até que o future
se complete com um valor ou um erro.
Algum tempo depois disso, a expressão `await`
é avaliada para esse valor ou lança esse erro.

Quando ele se completa, o valor do future é retornado.
Você só pode usar `await` em um contexto `async`, como em Swift.

```dart
// Nós só podemos aguardar futures dentro de um contexto async.
asyncFunction() async {
  String returnedString = await fetchString();
  print(returnedString); // 'Valor String'
}
```

Quando o future aguardado falha, um objeto de erro
é lançado na linha com a palavra-chave `await`.
Você pode tratar isso usando um bloco `try-catch` regular:

```dart
// Nós só podemos aguardar futures dentro de um contexto async.
Future<void> asyncFunction() async {
  String? returnedString;
  try {
    returnedString = await fetchString();
  } catch (error) {
    print('Future encontrou um erro antes de resolver.');
    return;
  }
  print(returnedString);
}
```

Para mais informações e prática interativa,
confira o tutorial de [Programação assíncrona][Programação assíncrona].

[Programação assíncrona]: /libraries/async/async-await

### Streams {:#streams}

Outra ferramenta na caixa de ferramentas async do Dart é a classe `Stream`.
Enquanto Swift tem seu próprio conceito de streams,
aqueles em Dart são similares a `AsyncSequence` em Swift.
Similarmente, se você conhece `Observables` (em RxSwift) ou
`Publishers` (no framework Combine da Apple),
streams do Dart devem parecer familiares.

Para aqueles não familiarizados com `Streams`,
`AsyncSequence`, `Publishers` ou `Observables`,
o conceito é o seguinte: um `Stream`
essencialmente age como um `Future`,
mas com múltiplos valores distribuídos ao longo do tempo,
como um barramento de eventos. Streams podem ser ouvidos,
para receber eventos de valor ou erro,
e eles podem ser fechados quando não houver mais eventos a serem enviados.

#### Ouvindo {:#listening}

Para ouvir um stream, você pode combinar um stream
com um loop `for-in` em um contexto `async`.
O loop `for` invoca o método de callback
para cada item emitido e termina quando o stream
se completa ou gera um erro:

```dart
Future<int> sumStream(Stream<int> stream) async {
  var sum = 0;
  try {
    await for (final value in stream) {
      sum += value;
    }
  } catch (error) {
    print('Stream encontrou um erro! $err');
  }
  return sum;
}
```

Se um erro ocorrer ao ouvir um stream,
o erro é lançado na linha que contém a
palavra-chave `await`, que você pode tratar com uma
declaração `try-catch`:

```dart
try {
  await for (final value in stream) { ... }
} catch (err) {
  print('Stream encontrou um erro! $err');
}
```

Essa não é a única forma de ouvir um stream:
você também pode chamar seu método `listen` e
fornecer um callback, que é chamado sempre que
o stream emite um valor:

```dart
Stream<int> stream = ...
stream.listen((int value) {
  print('Um valor foi emitido: $value');
});
```

O método `listen` tem alguns callbacks opcionais
para tratamento de erros, ou para quando o stream é concluído:

```dart
stream.listen(
  (int value) { ... },
  onError: (err) {
    print('Stream encontrou um erro! $err');
  },
  onDone: () {
    print('Stream completou!');
  },
);
```

O método `listen` retorna uma instância de um
`StreamSubscription`, que você pode usar para
parar de ouvir o stream:

```dart
StreamSubscription subscription = stream.listen(...);
subscription.cancel();
```

#### Criando streams {:#creating-streams}

Assim como com futures, você tem várias maneiras diferentes
de criar um stream. As duas maneiras mais comuns
usam um gerador async ou um `SteamController`.

##### Geradores Async {:#async-generators}

Uma função geradora async tem a mesma sintaxe
de uma função geradora síncrona,
mas usa a palavra-chave `async*` em vez de `sync*`,
e retorna um `Stream` em vez de um `Iterable`.
Essa abordagem é similar à struct `AsyncStream`
em Swift.

Em uma função geradora async, a palavra-chave `yield`
emite o valor dado para o stream.
A palavra-chave `yield*`, no entanto,
funciona com streams em vez de outros iteráveis.
Isso permite que eventos de outros streams sejam
emitidos para esse stream. No exemplo a seguir,
a função só continua quando o stream recém-gerado
for concluído:

```dart
Stream<int> asynchronousNaturalsTo(int n) async* {
  int k = 0;
  while (k < n) yield k++;
}

Stream<int> stream = asynchronousNaturalsTo(5);
```

Você também pode criar um stream usando a
API `StreamController`. Para mais informações,
veja [Usando um StreamController][Usando um StreamController].

[Usando um StreamController]: /libraries/async/creating-streams#using-a-streamcontroller

## Comentários de documentação {:#doc-comments}

Comentários regulares funcionam da mesma forma em Dart e em Swift.
Usar uma barra dupla (`//`) comenta tudo
após a barra dupla pelo resto da linha,
e blocos `/* ... */` comentam várias linhas.

Além de comentários regulares,
Dart também tem [comentários de documentação][comentários de documentação] que funcionam em conjunto
com [`dart doc`][`dart doc`]: uma ferramenta própria que gera
documentação HTML para pacotes Dart.
É considerada uma boa prática colocar comentários de documentação
acima de todas as declarações de membros públicos.
Você pode notar que esse processo é similar a como
você adiciona comentários para várias ferramentas de geração de documentação
em Swift.

[comentários de documentação]: /effective-dart/documentation
[`dart doc`]: /tools/dart-doc

Como em Swift, você define um comentário de documentação
usando três barras em vez de duas (`///`):

```dart
/// O número de caracteres neste trecho quando não dividido.
int get length => ...
```

Cerque tipos, parâmetros e nomes de métodos
com colchetes dentro de comentários de documentação.

```dart
/// Retorna o resultado da multiplicação [int] de [a] * [b].
multiply(int a, int b) => a * b;
```

Embora haja suporte para comentários de documentação no estilo JavaDoc,
você deve evitá-los e usar a sintaxe `///`.

```dart
/**
 * O número de caracteres neste trecho quando não dividido.
 * (EVITE USAR ESTA SINTAXE, USE /// EM VEZ DISSO.)
 */
int get length => ...
```

## Bibliotecas e visibilidade {:#libraries-and-visibility}

A semântica de visibilidade do Dart é similar à do Swift,
com bibliotecas Dart sendo aproximadamente equivalentes a
módulos Swift.

Dart oferece dois níveis de controle de acesso:
público e privado. Métodos e variáveis
são públicos por padrão. Variáveis privadas
são prefixadas com o caractere de sublinhado (`_`),
e são impostas pelo compilador Dart.

```dart
final foo = 'esta é uma propriedade pública';
final _foo = 'esta é uma propriedade privada';

String bar() {
  return 'este é um método público';
}
String _bar() {
  return 'este é um método privado';
}

// Classe pública
class Foo {
}

// Classe privada
class _Foo {
},
```

Métodos e variáveis privados têm escopo
para sua biblioteca em Dart, e para um módulo em Swift.
Em Dart, você pode definir uma biblioteca em um arquivo,
enquanto em Swift você deve criar um novo alvo de build
para seu módulo. Isso significa que em um único projeto Dart
você pode definir `n` bibliotecas,
mas em Swift você deve criar `n` módulos.

Todos os arquivos que fazem parte de uma biblioteca podem ter acesso
a todos os objetos privados nessa biblioteca.
Mas por razões de segurança, um arquivo ainda precisa
permitir que arquivos específicos tenham acesso aos seus
objetos privados, caso contrário, qualquer arquivo&mdash;mesmo de
fora do seu projeto&mdash;poderia se registrar em sua
biblioteca e obter acesso a dados possivelmente sensíveis.
Em outras palavras,
objetos privados não são compartilhados entre bibliotecas.

```dart title="animal.dart"
library animals;

part 'parrot.dart';

class _Animal {
  final String _name;

  _Animal(this._name);
}
```

```dart title="parrot.dart"
part of animals;

class Parrot extends _Animal {
  Parrot(String name) : super(name);

  // Tem acesso a _name de _Animal
  String introduction() {
    return 'Olá meu nome é $_name';
  }
}
```

Para mais informações, confira
[criando pacotes][criando pacotes].

[criando pacotes]: /tools/pub/create-packages#organizing-a-package

## Próximos passos {:#next-steps}

Este guia apresentou a você as principais diferenças
entre Dart e Swift. Neste ponto,
você pode considerar passar para a documentação geral
para [Dart][Dart] ou [Flutter][Flutter]
(um framework de código aberto que usa Dart para
construir aplicativos multiplataforma, compilados nativamente,
bonitos a partir de uma única base de código),
onde você encontrará informações detalhadas sobre a
linguagem e formas práticas de começar.

[Dart]: /docs
[Flutter]: {{site.flutter-docs}}
