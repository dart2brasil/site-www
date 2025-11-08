---
ia-translate: true
title: Learning Dart as a JavaScript developer
description: Leverage your JavaScript knowledge when learning Dart.
bodyClass: highlight-languages
showBreadcrumbs: false
lastVerified: 2022-11-21
---

Este guia tem como objetivo aproveitar seu conhecimento de programação
JavaScript ao aprender Dart.
Ele mostra as principais semelhanças e diferenças em ambas as linguagens,
e apresenta conceitos de Dart que não são suportados em JavaScript.
Como um desenvolvedor JavaScript, Dart deve parecer bastante familiar,
pois ambas as linguagens compartilham muitos conceitos.

Assim como JavaScript, Dart é executado em um *event loop* (loop de eventos),
então ambas as linguagens executam o código de maneira semelhante.
Por exemplo, conceitos assíncronos como *futures*
(*promises* em JavaScript) e a sintaxe `async/await` são muito similares.

Dart é fortemente tipado, ao contrário do JavaScript.
Se você já usou TypeScript ou Flow,
isso deve simplificar o aprendizado de Dart.
Se você trabalhou principalmente com JavaScript puro,
pode ser mais uma adaptação.
Com a tipagem forte, Dart detecta muitos erros antes da compilação
que podem existir no código JavaScript.

Dart habilita *null safety* (segurança nula) por padrão.
JavaScript não oferece suporte a *null safety*.
Como desenvolvedor JavaScript,
pode levar um tempo para aprender a escrever código com *null safety*,
mas a vantagem é uma melhor proteção contra
exceções de referência nula que são detectadas mesmo
antes de compilar o código Dart. (Evitando assim aqueles
temidos `TypeError`s que ocorrem ao realizar operações
em uma variável JavaScript que acaba sendo nula.)

## Convenções e *linting* {:#conventions-and-linting}

JavaScript e Dart possuem ferramentas de *linting* para impor convenções
padrão.
Enquanto JavaScript oferece muitas ferramentas, padrões e configurações,
Dart possui um conjunto oficial de convenções de layout e estilo,
além de um *linter* para simplificar a conformidade.
O analisador Dart faz a *lintagem* do código, além de fornecer mais
funções analíticas.
Para personalizar as regras de *lint* do seu projeto,
siga as instruções de [Customizando análise estática][Customizing static analysis].

Dart fornece [`dart fix`][`dart fix`] para encontrar e corrigir erros.

Dart também fornece um formatador de código semelhante a
ferramentas JavaScript como [Prettier][Prettier].
Para formatar o código em qualquer projeto Dart, execute
[`dart format`](/tools/dart-format) em sua linha de comando.
Os plugins IDE para Dart e Flutter também fornecem essa capacidade.

Dart suporta vírgulas à direita para listas separadas por vírgula
de coleções, parâmetros ou argumentos. Quando você adiciona a vírgula
à direita, o formatador coloca cada item da lista em sua própria linha.
Quando você acredita que sua lista pode ter mais itens posteriormente,
adicione a vírgula à direita. Evite adicionar a vírgula à direita apenas
para o benefício da formatação.

JavaScript suporta vírgulas à direita apenas em literais de lista e mapa.

:::secondary Para saber mais sobre:
* Usar vírgulas para fazer seu código parecer mais com HTML, leia
  [Usando vírgulas à direita][Using trailing commas] em flutter.dev.
* Fazer *lint* de Dart, leia [Regras do *Linter*][Linter rules].
* Escrever um bom código Dart, leia [Effective Dart][Effective Dart].
:::

[Customizing static analysis]: /tools/analysis
[`dart fix`]: /tools/dart-fix
[Effective Dart]: /effective-dart
[Linter rules]: /tools/linter-rules
[Prettier]: https://prettier.io/
[Using trailing commas]: {{site.flutter-docs}}/development/tools/formatting#using-trailing-commas

## Tipos embutidos {:#built-in-types}

Tanto JavaScript quanto Dart categorizam seus dados em _tipos_.
Cada variável tem um tipo associado.
O tipo determina o tipo de valor que a variável pode armazenar e
quais operações podem ser realizadas nesses valores.
Dart difere do JavaScript, pois atribui um tipo estático
a cada expressão e variável.
O tipo estático prevê o tipo em tempo de execução
dos valores de uma variável ou do valor de uma expressão.
Isso significa que os aplicativos Dart têm tipagem estática sólida.

JavaScript fornece os tipos primitivos `num`, `string` e `boolean`
e o valor `null`, bem como _arrays_ e um tipo `Map`.

Dart suporta os seguintes tipos embutidos:

* Números (`num`, `int`, `double`)
* Strings (`String`)
* Booleans (`bool`)
* Listas (`List`, também conhecidas como *arrays*)
* Conjuntos (*Sets*) (`Set`)
* Mapas (*Maps*) (`Map`)
* Símbolos (*Symbols*) (`Symbol`)
* O valor `null` (`Null`)

Para saber mais, confira [Tipos embutidos][Built-in types] no [Dart Language Tour][Dart Language Tour](Tour da Linguagem Dart).

Todos os tipos não-`Null` em Dart são subtipos de Object.
Todos os valores também são objetos.
Dart não usa "tipos primitivos" como JavaScript.
Por outro lado, Dart normaliza ou _canoniza_ número, booleanos
e valores `null`.
Isso significa que existe apenas um valor `int` com o valor numérico `1`.

:::note
JavaScript tem dois operadores de igualdade, `==` e `===`.
O operador `==` executa o teste de igualdade após realizar as conversões
de tipo necessárias em ou para valores primitivos.
O operador `===` não realiza conversões de tipo.
Dart usa a função `identical` para verificar se dois valores são o
mesmo objeto e o operador `==` para verificar se os objetos
se consideram iguais.
:::

[Built-in types]: /language/built-in-types
[Dart Language Tour]: /language

Por exemplo:
O operador de igualdade `==` e o método `identical()` retornam `true`
para os mesmos valores de tipos numéricos. Revise o exemplo mostrado no
código a seguir:

```dart
var a = 2;
var b = 1 + 1;

print(a == b); // Imprime true
print(identical(a, b)); // Imprime true; existe apenas um objeto "2"
```

### Tipos Primitivos {:#primitive-types}

Esta seção aborda como Dart representa os tipos primitivos do JavaScript.

#### Números {:#numbers}

Dart tem três tipos de dados para armazenar números:

`num`
: O equivalente ao tipo numérico genérico em JavaScript.

`int`
: Um valor numérico sem parte fracionária.

`double`
: Qualquer número de ponto flutuante de 64 bits (precisão dupla).

A API do Dart inclui todos esses tipos como classes.
Tanto os tipos `int` quanto `double` compartilham `num` como sua classe pai:

<img
  src="/assets/img/guides/number-classes.png"
  alt="num subclasses Object and int and double each subclass num">

Como o Dart considera os números como objetos, os números podem expor seus
próprias funções utilitárias como métodos de objeto.
Você não precisa usar um objeto adicional para aplicar uma função a um número.

Por exemplo, para arredondar um `double` para um inteiro:

```js
let rounded = Math.round(2.5);
```

```dart
var rounded = 2.5.round();
```

#### Strings {:#strings}

Strings em Dart funcionam como strings em JavaScript.
Para escrever um literal de string, coloque-o entre aspas simples (`'`) ou
duplas (`"`).
A maioria dos desenvolvedores Dart usa aspas simples,
mas a linguagem não impõe nenhum padrão.
Use aspas duplas se não quiser escapar
aspas simples dentro da string.

```dart
var a = 'Isto é uma string.';
```

##### Escapando caracteres especiais {:#escaping-special-characters}

Para incluir um caractere com outro significado em uma string,
como um `$` usado para interpolação de string, você deve escapar desse
caractere.
O escape de caracteres especiais em Dart funciona como JavaScript
e a maioria das outras linguagens.
Para escapar caracteres especiais,
preceda esse caractere com a barra invertida (`\`).

O código a seguir mostra alguns exemplos.

```dart
final singleQuotes = 'Eu \'estou aprendendo Dart'; // Eu 'estou aprendendo Dart
final doubleQuotes = "Escapando o caractere \""; // Escapando o caractere "
final dollarEscape = 'O preço é \$3,14.'; // O preço é $3,14.
final backslashEscape = 'O caractere de escape de string Dart é \\.';
final unicode = '\u{1F60E}'; // 😎,  Unicode escalar U+1F60E
```

:::note
Você pode usar caracteres hexadecimais de quatro dígitos com ou sem chaves.
Para saber mais sobre como trabalhar com caracteres unicode,
veja [Runes e *grapheme clusters*][Runes and grapheme clusters].
:::

[Runes and grapheme clusters]: /language/built-in-types#runes-and-grapheme-clusters

##### Interpolação de string {:#string-interpolation}

JavaScript suporta *template literals* (literais de template).
Eles usam delimitadores de caractere de crase (`` ` ``) pelos seguintes motivos:

* Para permitir strings de várias linhas
* Para interpolar strings com expressões incorporadas
* Para criar construções especiais chamadas *tagged templates*

Em Dart, você não precisa colocar uma string entre crases para concatenar
strings ou usar interpolações dentro de literais de string.

Para saber mais, confira [Strings][Strings] no Tour da Linguagem Dart.

[Strings]: /language/built-in-types#strings

Como em *template literals* JavaScript,
você pode usar a sintaxe `${<expressão>}` para inserir expressões em
um literal de string.
Dart usa essa sintaxe e permite que você omita as chaves
quando a expressão usa um único identificador.

```dart
var food = 'pão';
var str = 'Eu como $food'; // Eu como pão
var str = 'Eu como ${food}'; // Eu como pão
```

#### Concatenação de strings e declaração de várias linhas {:#string-concatenation-and-multiline-declaration}

Em JavaScript, você pode definir strings de várias linhas
usando *template literals*.
Dart tem duas maneiras de definir strings de várias linhas.

<ol>
<li> Usando concatenação de string implícita:
    Dart concatena quaisquer literais de string vizinhos,
    mesmo quando distribuídos por várias linhas:

```dart
final s1 = 'String '
    'concatenação'
    " funciona mesmo em quebras de linha.";
```
</li>

<li> Usando um literal de string de várias linhas:
Ao usar três aspas (simples ou duplas)
em ambos os lados da string, o literal pode abranger várias linhas.


```dart
final s2 = '''
Você pode criar
strings de várias linhas como esta.
''';

final s3 = """
Isto também é uma
string de várias linhas.""";
```
</li>
</ol>

#### Igualdade {:#equality}

Dart considera duas strings iguais quando elas contêm a mesma sequência
de unidades de código. Para determinar se duas strings têm as mesmas sequências,
use o operador de igual a (`==`).

```dart
final s1 = 'String '
    'concatenação'
    " funciona mesmo em quebras de linha.";
assert(s1 ==
    'String concatenação funciona mesmo em '
        'quebras de linha.');
```

#### Booleans {:#booleans}

Valores Booleanos tanto em Dart quanto em Javascript expressam uma condição binária.
Esses dois valores representam se um valor ou expressão é
`true` ou `false`.
Você pode retornar os valores usando os literais `true` e `false`,
ou produzi-los usando expressões como `x < 5` ou `y == null`.

```js
let isBananaPeeled = false;
```


```dart
var isBananaPeeled = false;
```

## Variáveis {:#variables}

Variáveis em Dart funcionam como variáveis em JavaScript,
com duas exceções:

1. Cada variável tem um tipo.
2. Dart escopa todas as variáveis no nível do bloco,
   como as variáveis `let` e `const` em JavaScript.

Uma variável Dart obtém seu tipo de uma de duas maneiras:

1. Declarada: um tipo escrito na declaração.
2. Inferida: uma expressão usada para inicializar a variável.
   Por [convenção][omit_local_variable_types],
   use `var` ou `final` quando o analisador puder inferir o tipo.

[omit_local_variable_types]: /effective-dart/design#dont-redundantly-type-annotate-initialized-local-variables

```js
// Declare e inicialize uma variável de uma vez
let name = "bob";
```

```dart
// Declare uma variável com um tipo específico
// quando você não fornece um valor inicial
String name;
// Declare e inicialize uma variável
// ao mesmo tempo e o Dart infere
// o tipo
var name = 'bob';
```

Variáveis só podem aceitar valores de seu tipo.

```dart
var name = 'bob';
name = 5; // Proibido, pois `name` tem tipo `String`.
```

Se você não fornecer um valor inicial ou tipo explícito,
Dart infere que o tipo da variável é o tipo *catch-all* `dynamic`.

Como as variáveis JavaScript, você pode atribuir qualquer valor a variáveis Dart
que usam o tipo `dynamic`.

```js
// Declare uma variável
let name;
// Inicialize a variável
name = "bob";
```

```dart
// Declare uma variável sem tipo ou valor atribuído
// e Dart infere o tipo 'dynamic'
var name;
// Inicialize a variável e o tipo permanece `dynamic`
name = 'bob';
name = 5; // Permitido, pois `name` tem tipo `dynamic`.
```

### Final e const {:#final-and-const}

Tanto JavaScript quanto Dart usam modificadores de variável. Ambos usam `const`, mas
diferem em como `const` funciona. Onde JavaScript usaria `const`,
Dart usa `final`.

Quando você adiciona `final` a uma variável Dart ou `const` a uma variável
JavaScript,
você deve inicializar a variável antes que outro código possa ler seu valor.
Uma vez inicializadas, você não pode alterar as referências dessas variáveis.

Quando Dart usa `const`, ele se refere a valores especiais que ele cria
ao compilar.
Dart usa expressões limitadas para criar esses valores imutáveis.
Essas expressões _não podem_ ter efeitos colaterais.
Sob essas condições, o compilador pode então prever o valor preciso
de uma variável ou expressão constante, não apenas seu tipo estático.

```dart
final String name;
// Não é possível ler o name aqui, não inicializado.
if (useNickname) {
  name = "Bob";
} else {
  name = "Robert";
}
print(name); // Inicializado corretamente aqui.
```

:::note
Quando você cria um objeto, o construtor da classe deve inicializar o
variáveis de instância `final`.
Isso garante que essas variáveis tenham um valor antes que alguém possa lê-las.

Saiba mais na seção [Classes](#classes).
:::

Em Dart, _variáveis constantes devem conter valores constantes_.
Variáveis não constantes podem conter valores constantes que
você também pode marcar como `const`.

```dart
var foo = const [];
  // foo não é constante, mas o valor para o qual ele aponta é.
  // Você pode reatribuir foo a um valor de lista diferente,
  // mas seu valor de lista atual não pode ser alterado.

const baz = []; // Equivalente a `const []`
```

Da mesma forma, as classes podem ter seus próprios construtores `const`
que produzem instâncias imutáveis.

Você não pode modificar uma variável `const` em JavaScript ou Dart.
JavaScript permite que você modifique os campos de um objeto `const`, mas
Dart não permite.

Para saber mais, consulte a seção [Classes](#classes).

## Segurança nula {:#null-safety}

Ao contrário do JavaScript, Dart oferece suporte à segurança nula (*null safety*).
Em Dart, todos os tipos são não anuláveis por padrão.
Isso beneficia os desenvolvedores Dart porque Dart detecta referências nulas
exceções ao escrever código, em vez de em tempo de execução.

### Tipos anuláveis vs. não anuláveis {:#nullable-vs-non-nullable-types}

Nenhuma das variáveis no exemplo de código a seguir pode ser `null`.

```dart
// No Dart com segurança nula, nenhuma delas pode ser nula.
var i = 42; // Inferido como um int.
String name = getFileName();
final b = Foo(); // Foo() invoca um construtor
```

Para indicar que uma variável pode ter o valor `null`,
adicione `?` à sua declaração de tipo:

```dart
int? aNullableInt = null;
```

O mesmo vale para qualquer outra declaração de tipo,
como uma declaração de função:

```dart
String? returnsNullable() {
  return random.nextDouble() < 0.5
    ? 'Às vezes nulo!'
    : null;
}

String returnsNonNullable() {
  return 'Nunca nulo!';
}
```

### Operadores *null-aware* {:#null-aware-operators}

Dart suporta vários operadores para lidar com a possibilidade de ser nulo.
Como em JavaScript, Dart oferece suporte ao operador de atribuição nula (`??=`),
operador de coalescência nula (`??`) e operador de encadeamento opcional (`?.`).
Esses operadores funcionam da mesma forma que o JavaScript.

#### ! Operador {:#operator}

Nos casos em que uma variável ou expressão anulável pode não ser nula,
você pode dizer ao compilador para reprimir quaisquer erros de tempo de compilação
usando o operador (`!`). Coloque este operador após a expressão.

Não confunda isso com o operador not (`!`) do Dart,
que usa o mesmo símbolo, mas colocado antes da expressão.

```dart
int? a = 5;

int b = a; // Não permitido.
int b = a!; // Permitido.
```

Em tempo de execução, se a acabar sendo `null`,
ocorre um erro de tempo de execução.

Como o operador `?.`,
use o operador `!` ao acessar propriedades
ou métodos em um objeto:

```dart
myObject!.someProperty;
myObject!.someMethod();
```

Se `myObject` for `null` em tempo de execução,
ocorre um erro de tempo de execução.

### Funções {:#functions}

Embora as funções do Dart funcionem de maneira muito semelhante
às suas contrapartes em JavaScript,
elas têm alguns recursos adicionais,
e algumas pequenas diferenças de sintaxe ao declará-las.
Semelhante ao JavaScript,
você pode declarar funções praticamente em qualquer lugar,
seja no nível superior,
como um campo de classe ou no escopo local.

```js
// No nível superior
function multiply(a, b) {
  return a * b;
}

// Como um campo de classe
class Multiplier {
  multiply(a, b) {
    return a * b;
  }
}

// Em um escopo local
function main() {
  function multiply(a, b) {
    return a * b;
  }

  console.log(multiply(3, 4));
}
```

```dart
// No nível superior
int multiply(a, b) {
  return a * b;
}

// Como um campo de classe
class Multiplier {
  multiply(a, b) {
    return a * b;
  }
}

// Em um escopo local
main() {
  multiply(a, b) {
    return a * b;
  }

  print(multiply(3, 4));
}
```

### Sintaxe de seta {:#arrow-syntax}

Tanto Dart quanto JavaScript suportam a sintaxe de seta (`=>`),
mas diferem em como eles a suportam.
Em Dart, você só pode usar a sintaxe de seta quando a função
contém uma única expressão ou instrução de retorno.

Por exemplo, as seguintes funções `isNoble` são equivalentes:

```dart
bool isNoble(int atomicNumber) {
  return _nobleGases[atomicNumber] != null;
}
```

```dart
bool isNoble(int atomicNumber) => _nobleGases[atomicNumber] != null;
```

### Parâmetros {:#parameters}

Em JavaScript, todos os parâmetros _podem_ ser parâmetros posicionais.
Por padrão, Dart _exige_ que você passe todos os parâmetros como argumentos
para funções.

```dart
int multiply(int a, int b) {
  return a * b;
}

main() {
  multiply(3, 5); // Válido. Todos os parâmetros são fornecidos.
  multiply(3); // Inválido. Todos os parâmetros devem ser fornecidos.
}
```

Isso pode mudar em duas situações:

1. Os parâmetros posicionais são marcados como opcionais.
2. Os parâmetros são nomeados e não marcados como obrigatórios.

Para definir parâmetros posicionais opcionais, coloque-os
entre colchetes após quaisquer parâmetros posicionais obrigatórios.
Você não pode seguir parâmetros opcionais com parâmetros obrigatórios.

Devido à segurança nula, parâmetros posicionais opcionais
devem ter um valor padrão ou serem marcados como anuláveis.
Para saber mais, consulte a seção anterior sobre [segurança nula](#null-safety).

O código a seguir tem um exemplo válido e dois exemplos inválidos
de funções que definem parâmetros posicionais opcionais.

```dart
// Válido: `b` tem um valor padrão de 5. `c` é marcado como anulável.
multiply(int a, [int b = 5, int? c]) {
  ...
}
// Inválido: um parâmetro posicional obrigatório segue um opcional.
multiply(int a, [int b = 5], int c) {
  ...
}
// Inválido: Nenhum parâmetro posicional opcional tem um padrão
//          valor ou foi sinalizado como anulável.
multiply(int a, [int b, int c]) {
  ...
}
```

O exemplo a seguir mostra como chamar uma função com parâmetros opcionais:

```dart
multiply(int a, [int b = 5, int? c]) {
  ...
}

main() {
  // Todas são chamadas de função válidas.
  multiply(3);
  multiply(3, 5);
  multiply(3, 5, 7);
}
```

Dart oferece suporte a **parâmetros nomeados**.
Eles não precisam ser fornecidos na ordem
em que estão definidos, como com parâmetros posicionais.
Você se refere a eles pelo nome. Por padrão,
estes são opcionais, a menos que sejam sinalizados como obrigatórios.
Parâmetros nomeados são definidos envolvendo-os com chaves.
Você pode combinar parâmetros nomeados com obrigatórios
parâmetros posicionais - neste cenário,
os parâmetros nomeados são sempre colocados após posicionais.
Ao chamar uma função com parâmetros nomeados,
passe valores prefixando o valor passado com o
nome do parâmetro, separados por dois pontos.
Por exemplo, `f(namedParameter: 5)`.

Novamente, com segurança nula, parâmetros nomeados que não são sinalizados como
obrigatórios precisam ter um valor padrão ou serem sinalizados como anuláveis.

O código a seguir define uma função com parâmetros nomeados:

```dart
// Válido:
// - `a` foi sinalizado como obrigatório
// - `b` tem um valor padrão de 5
// - `c` é marcado como anulável
// - Parâmetros nomeados seguem o posicional
multiply(bool x, {required int a, int b = 5, int? c}) {
  ...
}
```

Os exemplos a seguir chamam uma função com parâmetros nomeados:

```dart
// Todas são chamadas de função válidas.
// Além de fornecer o parâmetro posicional obrigatório:
multiply(false, a: 3); // Fornece apenas parâmetros nomeados obrigatórios
multiply(false, a: 3, b: 9); // Substitui o valor padrão de `b`
multiply(false, c: 9, a: 3, b: 2); // Fornece todos os parâmetros nomeados fora de ordem
```

### Funções de primeira classe {:#first-class-functions}

JavaScript e Dart tratam funções como cidadãos de primeira classe.
Isso significa que o Dart trata as funções como qualquer outro objeto.
Por exemplo, o código a seguir mostra como
passar uma função como um parâmetro para outra função:

```dart
void printElement(int element) {
  print(element);
}

var list = [1, 2, 3];

// Passar printElement como um parâmetro.
list.forEach(printElement);
```

### Funções anônimas {:#anonymous-functions}

JavaScript e Dart ambos suportam [_funções anônimas_],
ou funções sem nome. Assim como com funções nomeadas,
você pode passar funções anônimas como qualquer outro valor.
Por exemplo, armazene funções anônimas em uma variável,
passe-as como um argumento para outra função,
ou retorne-as de outra função.

[_anonymous_ functions]: https://en.wikipedia.org/wiki/Anonymous_function

JavaScript tem duas maneiras de declarar uma função anônima:

1. Use uma expressão de função padrão
2. Use a sintaxe de seta

Da mesma forma, Dart também tem duas maneiras de declarar funções anônimas.
Ambas funcionam de maneira semelhante à expressão de seta JavaScript.
As funções anônimas do Dart não suportam a funcionalidade extra
que vem com expressões de função regulares.
Por exemplo, o suporte do JavaScript para uma expressão de função agindo
como um construtor ou criando uma ligação personalizada a este.

Para saber mais, consulte a seção [Classes](#classes).

```js
// Uma expressão de função regular
// atribuída a uma variável
let funcExpr = function(a, b) {
  return a * b;
}
// A mesma função anônima
// expressa como uma seta
// função com chaves.
let arrowFuncExpr = (a, b) => {
  return a * b;
}
// Uma função de seta com apenas
// uma instrução de retorno como
// seu conteúdo não
// requer um bloco.
let arrowFuncExpr2 = (a, b) => a * b;
```

```dart
// Atribua uma função anônima
// a uma variável.
var blockFunc =
  optionalCallback ?? (int a, int b) {
    return a * b;
};

// Para uma expressão com apenas uma instrução de retorno,
// você pode usar a sintaxe de seta:
var singleFunc = (int a, int b) => a * b;
```

Como no JavaScript, você pode passar funções anônimas para outras funções.
Os desenvolvedores geralmente passam funções anônimas ao usar a função `map`
para *arrays* e listas:

```js
// retorna [4, 5, 6]
[1, 2, 3].map(e => e + 3);

// retorna [5, 7, 9]
[1, 2, 3].map(e => {
  e *= 2;
  return e + 3;
});
```

```dart
// retorna [4, 5, 6]
[1, 2, 3].map((e) => e + 3).toList();

// retorna [5, 7, 9]
var list2 = [1, 2, 3].map((e) {
  e *= 2;
  return e + 3;
}).toList();
```

:::note
A função `map` nos exemplos anteriores retorna
um `Iterable<T>`, em vez de um `List<T>`.
A função `toList` converte o retornado
`Iterable` de volta para uma `List`.

Um literal de lista pode atingir o mesmo objetivo.

```dart
// Essas duas instruções são equivalentes:
print([for (var e in [1, 2, 3]) e + 3]);
print([1, 2, 3].map((e) => e + 3).toList());
```
:::

### Funções geradoras {:#generator-functions}

Ambas as linguagens suportam [_funções geradoras_].
Essas funções retornam uma coleção iterável de itens
computados para evitar trabalhos desnecessários.

Para escrever uma função geradora em Dart,
adicione a palavra-chave `sync*` após os parâmetros da função,
e retorne um `Iterable`.
Adicione itens ao iterável final usando o
palavra-chave `yield` ou adicione conjuntos inteiros de itens usando `yield*`.

[_generator functions_]: /language/functions#generators

O exemplo a seguir mostra como escrever um
função geradora básica:

```js
function* naturalsTo(n) {
  let k = 0;
  while (k < n) {
    yield k++;
  }
}

// Retorna [0, 1, 2, 3, 4]
for (let value of naturalsTo(5)) {
  console.log(value);
}
```

```dart
Iterable<int> naturalsTo(int n) sync* {
  int k = 0;
  while (k < n) {
    yield k++;
  }
}

// Retorna um iterável com [0, 1, 2, 3, 4]
print(naturalsTo(5).toList());
```

```js
function* doubleNaturalsTo(n) {
  let k = 0;
  while (k < n) {
    yield* [k, k];
    k++;
  }
}

// Retorna [0, 0, 1, 1, 2, 2]
for (let value of doubleNaturalsTo(3)) {
  console.log(value);
}
```

```dart
Iterable<int> doubleNaturalsTo(int n) sync* {
  int k = 0;
  while (k < n) {
    yield* [k, k];
    k++;
  }
}

// Retorna um iterável com [0, 0, 1, 1, 2, 2]
print(doubleNaturalsTo(3));
```

Você também pode definir funções geradoras assíncronas,
que retornam *streams* em vez de *iterables*.
Saiba mais na próxima seção [Assincronia](#asynchrony).

## Declarações {:#statements}

Esta seção descreve as diferenças nas declarações entre
JavaScript e Dart.

### Fluxo de controle (if/else, for, while, switch) {:#control-flow-if-else-for-while-switch}

A maioria das declarações de controle funciona como suas contrapartes JavaScript.
Alguns têm usos adicionais para [Coleções](#collections).

#### Iteração {:#iteration}

Embora tanto JavaScript quanto Dart tenham loops `for-in`,
seus comportamentos diferem.

O loop `for-in` do JavaScript itera sobre as propriedades de um objeto.
Para iterar sobre os elementos de um objeto iterável do JavaScript,
você deve usar `for-of` ou `Array.forEach()`.
O loop `for-in` do Dart funciona como o `for-of` do JavaScript.

O exemplo a seguir mostra a iteração
sobre uma coleção e imprimindo cada elemento:

```js
for (const element of list) {
  console.log(element);
}
```

```dart
for (final element in list) {
  print(element);
}
```

#### Switch {:#switch}

:::note
Uma diferença fundamental com a declaração `switch`
em JavaScript e Dart: quando um caso não tem `break`,
declaração `continue` ou `return`,
JavaScript permite que a execução avance e continue
com a próxima declaração. No entanto,
Dart só permite isso quando o corpo de um caso está vazio.
:::

Ao usar `continue` em uma declaração `switch`,
você pode combiná-lo com um rótulo que é colocado em um caso:

```dart
switch (testEnum) {
  case TestEnum.A:
    print('A');
    continue b;
  b:
  case TestEnum.B:
    print('B');
    break;
}
```

### Operadores {:#operators}

Tanto Dart quanto JavaScript contêm operadores predefinidos.
Nenhuma das linguagens suporta a adição de novos operadores.
Dart suporta o _overloading_ (sobrecarga) de alguns operadores
existentes com a palavra-chave `operator`. Por exemplo:

```dart
class Vector {
  final double x;
  final double y;
  final double z;
  Vector(this.x, this.y, this.z);
  Vector operator +(Vector other) => Vector(
    x + other.x, 
    y + other.y,
    z + other.z,
  );
  Vector operator *(double scalar) => Vector(
    x * scalar,
    y * scalar,
    z * scalar,
  );
}
```

#### Operadores aritméticos {:#arithmetic-operators}

Os operadores de igualdade e relacionais de ambas as linguagens
são quase idênticos, conforme mostrado na tabela a seguir:

| Significado                                             | Operador JavaScript | Operador Dart |
|---------------------------------------------------------|---------------------|---------------|
| Adição                                                 | `+`                 | `+`           |
| Subtração                                              | `-`                 | `-`           |
| Menos unário, também conhecido como negação             | `-expr`             | `-expr`       |
| Multiplicação                                          | `*`                 | `*`           |
| Divisão                                                | `/`                 | `/`           |
| Divisão retornando um resultado inteiro                 |                     | `~/`          |
| Obter o resto de uma divisão inteira (módulo)            | `%`                 | `%`           |
| `x = x + 1` (o valor da expressão é `x + 1`)            | `++x`               | `++x`         |
| `x = x + 1` (o valor da expressão é `x`)                | `x++`               | `x++`         |
| `x = x - 1` (o valor da expressão é `x - 1`)            | `--x`               | `--x`         |
| `x = x - 1` (o valor da expressão é `x`)                | `x--`               | `x--`         |

{:.table .table-striped}

Por exemplo:

```dart
assert(2 + 3 == 5);
assert(2 - 3 == -1);
assert(2 * 3 == 6);
assert(5 / 2 == 2.5); // Resultado é um double
assert(5 ~/ 2 == 2); // Resultado é um int
assert(5 % 2 == 1); // Resto

a = 0;
b = ++a; // Incrementa a antes que b receba seu valor.
assert(a == b); // 1 == 1

a = 0;
b = a++; // Incrementa a DEPOIS que b recebe seu valor.
assert(a != b); // 1 != 0

a = 0;
b = --a; // Decrementa a antes que b receba seu valor.
assert(a == b); // -1 == -1

a = 0;
b = a--; // Decrementa a DEPOIS que b recebe seu valor.
assert(a != b); // -1 != 0
```

Você provavelmente notou que Dart também contém
um operador `~/` (chamado de _operador de divisão truncada_),
que divide um double e retorna um inteiro com o valor arredondado para baixo:

```dart
assert(25 == 50.4 ~/ 2);
assert(25 == 50.6 ~/ 2);
assert(25 == 51.6 ~/ 2);
```

#### Operadores de igualdade e relacionais {:#equality-and-relational-operators}

Os operadores de igualdade e relacionais de ambas as linguagens
funcionam da mesma maneira:

| Significado                  | Operador JavaScript | Operador Dart |
|------------------------------|---------------------|---------------|
| Estritamente igual           | `===`               | `==`          |
| Igualmente abstrato (Abstract equal) | `==`                |               |
| Estritamente não igual       | `!==`               | `!=`          |
| Não igual abstrato (Abstract not equal)      | `!=`                |               |
| Maior que                    | `>`                 | `>`           |
| Menor que                    | `<`                 | `<`           |
| Maior que ou igual a         | `>=`                | `>=`          |
| Menor que ou igual a         | `<=`                | `<=`          |

{:.table .table-striped}

Os operadores `==` e `!=` de JavaScript não têm equivalentes.

Por exemplo:

```dart
assert(2 == 2);
assert(2 != 3);
assert(3 > 2);
assert(2 < 3);
assert(3 >= 3);
assert(2 <= 3);
```

#### Operadores de teste de tipo {:#type-test-operators}

A implementação de operadores de teste é um pouco
diferente entre as duas linguagens:

| Significado                           | Operador JavaScript | Operador Dart |
|---------------------------------------|---------------------|---------------|
| Typecast (conversão de tipo)                   |                     | `x as T`      |
| Verdadeiro se o objeto tem o tipo especificado | `x instanceof T`    | `x is T`      |
| Verdadeiro se o objeto não tem o tipo especificado | `!(x instanceof T)` | `x is! T`     |

{:.table .table-striped}

O resultado de `obj is T` é verdadeiro se `obj`
implementa a interface especificada por `T`.
Por exemplo, `obj is Object?` é sempre verdadeiro.

Use o operador typecast (`as`) para garantir que um valor
tenha um tipo específico. O compilador pode usar isso,
se você _sabe_ que o objeto terá esse tipo.

Por exemplo:

```dart
(person as Employee).employeeNumber = 4204583;
```

Se você não _sabe_ que o objeto é do tipo `T`,
use `is T` para verificar o tipo _antes_ de usar o objeto.

Em Dart, os tipos de variáveis locais são atualizados dentro
do escopo da instrução `if`.
Este não é o caso para variáveis de instância.

```dart
if (person is Employee) {
   person.employeeNumber = 4204583;
}
```

#### Operadores lógicos {:#logical-operators}

Você pode inverter ou combinar expressões booleanas
usando operadores lógicos. Os operadores lógicos
de ambas as linguagens são idênticos.

| Significado                                                          | Operador JavaScript | Operador Dart |
|----------------------------------------------------------------------|---------------------|---------------|
| Inverte a próxima expressão (altera falso para verdadeiro e vice-versa) | `!x`                | `!x`          |
| OR lógico                                                           | `\|\|`              | `\|\|`        |
| AND lógico                                                          | `&&`                | `&&`          |

{:.table .table-striped}

JavaScript permite que qualquer valor seja usado onde você precisa de um valor booleano.
Em seguida, ele converte esses valores para `true` ou `false`.
JavaScript considera strings vazias e o número `0` como valores "falsy" (falsos).
Dart permite valores `bool` em condições e como operandos de operadores lógicos.

Por exemplo:

```dart
if (!done && (col == 0 || col == 3)) {
  // ...Faça algo...
}
```

#### Operadores bit a bit e de deslocamento {:#bitwise-and-shift-operators}

Você pode manipular os bits individuais de números
usando operadores bit a bit e de deslocamento com inteiros.
Os operadores de ambas as linguagens são quase idênticos,
conforme mostrado na tabela a seguir:

| Significado                                                       | Operador JavaScript | Operador Dart |
|-------------------------------------------------------------------|---------------------|---------------|
| AND bit a bit                                                     | `&`                 | `&`           |
| OR bit a bit                                                      | `\|`                | `\|`          |
| XOR bit a bit                                                     | `^`                 | `^`           |
| Complemento bit a bit unário (0s se tornam 1s; 1s se tornam 0s)  | `~expr`             | `~expr`       |
| Deslocamento para a esquerda                                       | `<<`                | `<<`          |
| Deslocamento para a direita                                        | `>>`                | `>>`          |
| Deslocamento não assinado para a direita                            | `>>>`               | `>>>`         |

{:.table .table-striped}

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
assert((-value >> 4) == -0x03); // Deslocamento para a direita
assert((value >>> 4) == 0x02); // Deslocamento não assinado para a direita
assert((-value >>> 4) > 0); // Deslocamento não assinado para a direita
```

#### Operador condicional {:#conditional-operator}

Tanto Dart quanto JavaScript contêm um operador condicional (`?:`)
para avaliar expressões.
Alguns desenvolvedores se referem a isso como um operador ternário
porque ele recebe três operandos.
Como Dart tem outro operador (`[]=`) que recebe três operandos,
chame este operador (`?:`) de operador condicional.
Este operador funciona para expressões como [if-else][if-else] funciona para instruções.

```js
let visibility = isPublic ? "public" : "private";
```

```dart
final visibility = isPublic ? 'public' : 'private';
```

[if-else]: /language/branches#if

### Operadores de atribuição {:#assignment-operators}

Use o operador (`=`) para atribuir valores.

```dart
// Atribui valor a a
a = value;
```

Este operador também tem uma variante com reconhecimento de nulo (`??=`).

Para saber mais,
consulte a seção do operador de [atribuição nula](#null-aware-operators).

JavaScript e Dart incluem operadores que calculam e atribuem
novos valores à variável na expressão.
Esses operadores de atribuição usam o valor do lado direito e
o valor inicial da variável como operandos.

A tabela a seguir lista esses operadores de atribuição:

| Operador | Descrição                        |
|----------|------------------------------------|
| `=`      | Atribuição                         |
| `+=`     | Atribuição de adição              |
| `-=`     | Atribuição de subtração           |
| `*=`     | Atribuição de multiplicação        |
| `/=`     | Atribuição de divisão             |
| `~/=`    | Atribuição de divisão truncada      |
| `%=`     | Atribuição de resto (módulo)       |
| `>>>=`   | Atribuição de deslocamento não assinado para a direita |
| `^=`     | Atribuição de XOR bit a bit       |
| `<<=`    | Atribuição de deslocamento para a esquerda      |
| `>>=`    | Atribuição de deslocamento para a direita     |
| `&=`     | Atribuição de AND bit a bit        |
| `\|=`    | Atribuição de OR bit a bit         |

{:.table .table-striped}

JavaScript não suporta o operador de atribuição `~/=`.

```dart
var a = 5;
a *= 2; // Multiplica `a` por 2 e atribui o resultado de volta a a.
print(a); // `a` agora é 10.
```

### Cascades (operador `..`) {:#cascades-operator}

Dart permite encadear múltiplas chamadas de método, atribuições de propriedade,
ou ambos em um único objeto. Dart se refere a isso como _cascading_ (em cascata) e
usa a sintaxe de cascade (`..`) para realizar esta ação.

JavaScript não possui esta sintaxe.

O exemplo a seguir mostra o encadeamento de vários métodos
em um objeto recém-construído usando a sintaxe de cascade:

```dart
var animal = Animal() // Define múltiplas propriedades e métodos
  ..name = "Bob"
  ..age = 5
  ..feed()
  ..walk();

print(animal.name); // "Bob"
print(animal.age); // 5
```

Para tornar a primeira sintaxe de cascade com reconhecimento de nulo, escreva-a como `?..`.

```dart
var result = maybePerson
    ?..employment = employer
    ..salary = salary;
```

Dart ignora toda a cascade se o valor de `maybePerson` for `null`.

## Coleções {:#collections}

Esta seção aborda alguns tipos de coleção em Dart e os compara
com tipos semelhantes em JavaScript.

### Listas {:#lists}

Dart escreve literais de lista da mesma forma que _arrays_ em JavaScript.
Dart inclui listas entre colchetes e separa os valores com vírgulas.

```dart
// Inicializa a lista e especifica o tipo completo
final List<String> list1 = <String>['um', 'dois', 'três'];

// Inicializa a lista usando um tipo abreviado
final list2 = <String>['um', 'dois', 'três'];

// Dart também pode inferir o tipo
final list3 = ['um', 'dois', 'três'];
```

Os exemplos de código a seguir fornecem uma visão geral das ações básicas que
você pode realizar em uma `List` do Dart.
O exemplo a seguir mostra como recuperar um valor de uma `List`
usando o operador de índice.

```dart
final fruits = <String>['maçã', 'laranja', 'pera'];
final fruit = fruits[1];
```

Adicione um valor ao final da `List` usando o método `add`.
Adicione outra `List` usando o método `addAll`:

```dart
final fruits = <String>['maçã', 'laranja', 'pera'];
fruits.add('pêssego');
fruits.addAll(['kiwi', 'manga']);
```

Insira um valor em uma posição específica usando o
método `insert`. Insira outra `List` em uma
posição específica usando o método `insertAll`:

```dart
final fruits = <String>['maçã', 'laranja', 'pera'];
fruits.insert(0, 'pêssego');
fruits.insertAll(0, ['kiwi', 'manga']);
```

Atualize um valor na `List` combinando o
índice e os operadores de atribuição:

```dart
final fruits = <String>['maçã', 'laranja', 'pera'];
fruits[2] = 'pêssego';
```

Remova itens de uma `List` usando um dos seguintes métodos:

```dart
final fruits = <String>['maçã', 'laranja', 'pera'];
// Remove o valor 'pera' da lista.
fruits.remove('pera');
// Remove o último elemento da lista.
fruits.removeLast();
// Remove o elemento na posição 1 da lista.
fruits.removeAt(1);
// Remove os elementos com posições maiores ou iguais a
// start (1) e menores que end (3) da lista.
fruits.removeRange(1, 3);
// Remove todos os elementos da lista que correspondem ao predicado fornecido.
fruits.removeWhere((fruit) => fruit.contains('p'));
```

Use `length` para obter o número de valores na `List`:

```dart
final fruits = <String>['maçã', 'laranja', 'pera'];
assert(fruits.length == 3);
```

Use `isEmpty` para verificar se a `List` está vazia:

```dart
var fruits = [];
assert(fruits.isEmpty);
```

Use `isNotEmpty` para verificar se a `List` não está vazia:

```dart
final fruits = <String>['maçã', 'laranja', 'pera'];
assert(fruits.isNotEmpty);
```

#### Filled (preenchido) {:#filled}

A classe `List` do Dart inclui uma maneira de criar uma lista com
cada item tendo o mesmo valor.
Este construtor `filled` cria uma lista de tamanho fixo `n` com
um valor padrão.
O exemplo a seguir cria uma lista de 3 itens:

```dart
final list1 = List.filled(3, 'a'); // Cria: [ 'a', 'a', 'a' ]
```

* Você não pode adicionar ou remover elementos desta lista por padrão.
  Para permitir que esta lista adicione ou remova elementos, adicione `, growable: true`
  ao final da lista de parâmetros.
* Você pode acessar e atualizar elementos desta lista usando seu valor de índice.

#### Generate (gerar) {:#generate}

A classe `List` do Dart inclui uma maneira de criar uma lista de valores incrementados.
Este construtor `generate` cria uma lista de tamanho fixo `n`
com um modelo para construir valores de elementos.
Este modelo usa o índice como um parâmetro.

```dart
// Cria: [ 'a0', 'a1', 'a2' ]
final list1 = List.generate(3, (index) => 'a$index');
```

### Sets (conjuntos) {:#sets}

Ao contrário do JavaScript, o Dart suporta a definição de `Set`s com literais.
Dart define conjuntos da mesma forma que listas,
mas usando chaves em vez de colchetes.
Conjuntos são coleções não ordenadas que contêm apenas itens exclusivos.
Dart impõe a exclusividade desses itens usando códigos hash,
o que significa que os objetos precisam de valores hash para serem armazenados em um `Set`.

:::note
Em Dart, o valor hash assume o padrão como a instância de um objeto
mas você pode substituí-lo para usar um conjunto de propriedades.
Para saber mais, consulte a página da propriedade [`hashCode`][`hashCode`].
:::

[`hashCode`]: {{site.dart-api}}/dart-core/Object/hashCode.html

O trecho de código a seguir mostra como inicializar um `Set`:

```dart
final abc = {'a', 'b', 'c'};
```

A sintaxe para criar um conjunto vazio pode parecer
confusa no início, porque especificar
chaves vazias (`{}`) resulta na criação de um `Map` vazio.
Para criar um `Set` vazio, preceda a declaração `{}`
com um argumento de tipo ou atribua `{}` a uma variável do tipo `Set`:

```dart
final names = <String>{};
// Set<String> names = {}; // Isso também funciona.
// final names = {}; // Cria um mapa vazio, não um conjunto.
```

Os exemplos a seguir fornecem uma visão geral das
ações básicas que você pode realizar em um `Set` do Dart.

Adicione um valor ao `Set` usando o método `add`.
Use o método `addAll` para adicionar vários valores:

```dart
final fruits = {'maçã', 'laranja', 'pera'};
fruits.add('pêssego');
fruits.addAll(['kiwi', 'manga']);
```

Use um dos seguintes métodos em `Set`
para remover o conteúdo do conjunto:

```dart
final fruits = {'maçã', 'laranja', 'pera'};
// Remove o valor 'pera' do conjunto.
fruits.remove('pera');
// Remove todos os elementos da lista fornecida do conjunto.
fruits.removeAll(['laranja', 'maçã']);
// Remove todos os elementos da lista que correspondem ao predicado fornecido.
fruits.removeWhere((fruit) => fruit.contains('p'));
```

Use `length` para obter o número de valores no `Set`:

```dart
final fruits = {'maçã', 'laranja', 'pera'};
assert(fruits.length == 3);
```

Use `isEmpty` para verificar se o `Set` está vazio:

```dart
var fruits = <String>{};
assert(fruits.isEmpty);
```

Use `isNotEmpty` para verificar se o `Set` não está vazio:

```dart
final fruits = {'maçã', 'laranja', 'pera'};
assert(fruits.isNotEmpty);
```

### Maps (mapas) {:#maps}

O tipo `Map` em Dart se assemelha ao tipo `Map` em JavaScript.
Ambos os tipos associam chaves a valores.
Uma chave pode ser qualquer tipo de objeto se todas as chaves tiverem o mesmo tipo.
Essa regra também se aplica aos valores.
Cada chave ocorre no máximo uma vez, mas você pode usar o mesmo valor várias vezes.

Dart baseia o dicionário em uma tabela hash.
Isso significa que as chaves precisam ser hashable (passível de hash).
Cada objeto Dart contém um hash.

:::note
Em Dart, o valor hash de um objeto assume o padrão como um valor derivado da
identidade do objeto, e sendo compatível com uma igualdade onde o
objeto só pode ser igual a si mesmo. Para introduzir uma igualdade baseada no
_conteúdo_ do objeto, substitua `hashCode` e `operator==`.
:::

Considere estes exemplos simples de `Map`, criados usando literais:

```dart
final gifts = {
  'primeiro': 'perdiz',
  'segundo': 'pombas',
  'quinto': 'anéis de ouro'
};

final nobleGases = {
  2: 'hélio',
  10: 'neônio',
  18: 'argônio',
};
```

Os exemplos de código a seguir fornecem uma visão geral das ações básicas que
você pode realizar em um `Map` do Dart.
O exemplo a seguir mostra como recuperar um valor de um `Map` usando
o operador de índice.

```dart
final gifts = {'primeiro': 'perdiz'};
final gift = gifts['primeiro'];
```

:::note
Se o mapa não incluir a chave de pesquisa, o operador de índice retornará `null`.
:::

Use o método `containsKey` para verificar se o `Map` inclui uma chave.

```dart
final gifts = {'primeiro': 'perdiz'};
assert(gifts.containsKey('quinto'));
```

Use o operador de atribuição de índice (`[]=`) para adicionar ou atualizar uma entrada
no `Map`.
Se o `Map` ainda não contiver a chave, Dart adicionará a entrada.
Se a chave existir, Dart atualizará seu valor.

```dart
final gifts = {'primeiro': 'perdiz'};
gifts['segundo'] = 'tartaruga'; // É adicionado
gifts['segundo'] = 'pombas'; // É atualizado
```

Use o método `addAll` para adicionar outro `Map`.
Use o método `addEntries` para adicionar outras entradas ao `Map`.

```dart
final gifts = {'primeiro': 'perdiz'};
gifts['segundo'] = 'pombas';
gifts.addAll({
  'segundo': 'pombas',
  'quinto': 'anéis de ouro',
});
gifts.addEntries([
  MapEntry('segundo', 'pombas'),
  MapEntry('quinto', 'anéis de ouro'),
]);
```

Use o método `remove` para remover uma entrada do `Map`.
Use o método `removeWhere` para remover todas as entradas que satisfaçam um determinado teste.

```dart
final gifts = {'primeiro': 'perdiz'};
gifts.remove('primeiro');
gifts.removeWhere((key, value) => value == 'perdiz');
```

Use `length` para obter o número de pares chave-valor no `Map`.

```dart
final gifts = {'primeiro': 'perdiz'};
gifts['quarto'] = 'pássaros cantores';
assert(gifts.length == 2);
```

Use `isEmpty` para verificar se o `Map` está vazio.

```dart
final gifts = {};
assert(gifts.isEmpty);
```

Use `isNotEmpty` para verificar se o `Map` não está vazio.

```dart
final gifts = {'primeiro': 'perdiz'};
assert(gifts.isNotEmpty);
```

### Não modificável (Unmodifiable) {:#unmodifiable}

JavaScript puro não suporta imutabilidade.
Dart oferece várias maneiras de tornar coleções como _arrays_, conjuntos ou
dicionários imutáveis.

* Se a coleção for uma constante de tempo de compilação e não deva
  ser modificada, use a palavra-chave `const`:<br>
  `const fruits = <String>{'maçã', 'laranja', 'pera'};`
* Atribua o `Set` a um campo `final`, o que significa que
  o próprio `Set` não precisa ser uma constante de tempo de compilação.
  Isso garante que o campo não possa ser sobrescrito com
  outro `Set`, mas ainda permite que o tamanho ou o conteúdo
  do `Set` seja modificado:<br>
  `final fruits = <String>{'maçã', 'laranja', 'pera'};`
* Crie uma versão final do seu tipo de coleção
  usando o construtor `unmodifiable`
  (como mostrado no exemplo a seguir).
  Isso cria uma coleção que não pode alterar seu tamanho ou conteúdo:

```dart
final _set = Set<String>.unmodifiable(['a', 'b', 'c']);
final _list = List<String>.unmodifiable(['a', 'b', 'c']);
final _map = Map<String, String>.unmodifiable({'foo': 'bar'});
```

### Operador Spread {:#spread-operator}

Como em JavaScript, Dart suporta a incorporação de uma lista
em outra lista usando o operador _spread_ (`...`)
e o operador _spread_ com reconhecimento de nulo (`...?`).

```dart
var list1 = [1, 2, 3];
var list2 = [0, ...list1];　// [0, 1, 2, 3]
// Quando a lista a ser inserida pode ser nula:
list1 = null;
var list2 = [0, ...?list1]; // [0]
```

Isso também funciona para conjuntos e mapas:

```dart
// Operador spread com mapas
var map1 = {'foo': 'bar', 'key': 'value'};
var map2 = {'foo': 'baz', ...map1}; // {foo: bar, key: value}
// Operador spread com conjuntos
var set1 = {'foo', 'bar'};
var set2 = {'foo', 'baz', ...set1}; // {foo, baz, bar}
```

### Coleção if/for {:#collection-if-for}

Em Dart, as palavras-chave `for` e `if` têm
funcionalidade adicional quando se trata de coleções.

Uma instrução `if` de coleção inclui itens de um
literal de lista apenas quando a condição especificada é atendida:

```dart
var nav = [
  'Início',
  'Móveis',
  'Plantas',
  if (promoActive) 'Outlet',
];
```

Funciona de forma semelhante para mapas e conjuntos.

Uma instrução `for` de coleção permite que
vários itens sejam mapeados em outra lista:

```dart
var listOfInts = [1, 2, 3];
var listOfStrings = [
  '#0',
  for (var i in listOfInts) '#$i',
]; // [#0, #1, #2, #3]
```

Isso também funciona da mesma forma para mapas e conjuntos.

## Assincronia {:#asynchrony}

Como o JavaScript, a Máquina Virtual (VM) Dart
executa um único _event loop_ (loop de eventos) que processa todo o seu código Dart.
Isso significa que regras semelhantes para assincronia se aplicam aqui.
Todo o seu código é executado de forma síncrona,
mas você pode tratá-lo em uma ordem diferente,
dependendo de como você usa as ferramentas assíncronas à sua disposição.
Aqui estão algumas dessas construções e como elas se relacionam
com suas contrapartes em JavaScript.

### Futures {:#futures}

`Future` é a versão do Dart para um `Promise` do JavaScript.
Ambos são o _resultado_ de uma operação assíncrona que é resolvida em um
momento posterior.

Funções em Dart ou em pacotes Dart podem retornar um `Future`,
em vez do valor que representam, pois o valor pode não estar
disponível até mais tarde.

O exemplo a seguir mostra que o tratamento de um _future_ funciona
da mesma forma em Dart como uma _promise_ funciona em JavaScript.

```js
const httpResponseBody = func();

httpResponseBody.then(value => {
  console.log(
    `Promise resolvida para um valor: ${value}`
  );
});
```


```dart
Future<String> httpResponseBody = func();

httpResponseBody.then((String value) {
  print('Future resolvida para um valor: $value');
});
```

Da mesma forma, _futures_ podem falhar como _promises_.
A captura de erros também funciona da mesma forma:

```js
httpResponseBody
  .then(...)
  .catch(err => {
    console.log(
      "Promise encontrou um erro antes de ser resolvida."
    );
  });
```


```dart
httpResponseBody
  .then(...)
  .catchError((err) {
    print(
      'Future encontrou um erro antes de ser resolvida.'
    );
  });
```

Você também pode criar _futures_.
Para criar um `Future`, defina e chame uma função `async`.
Quando você tem um valor que precisa ser um `Future`,
converta a função como no exemplo a seguir.

```dart
String str = 'Valor String';
Future<String> strFuture = Future<String>.value(str);
```

#### Async/Await {:#async-await}

Se você está familiarizado com _promises_ em JavaScript,
você provavelmente também está familiarizado com a sintaxe `async`/`await`.
Esta sintaxe é idêntica em Dart: funções são marcadas como `async`,
e funções `async` sempre retornam um `Future`.
Se a função retornar uma `String` e for marcada como `async`,
ela retornará um `Future<String>` em vez disso.
Se não retornar nada, mas for `async`,
ela retornará `Future<void>`.

O exemplo a seguir mostra como escrever uma função `async`:

```js
// Retorna uma Promise de uma string,
// pois o método é async
async fetchString() {
  // Normalmente algumas outras async
  // operações seriam feitas aqui.
  return "Valor String";
}
```


```dart
// Retorna uma future de uma string,
// pois o método é async
Future<String> fetchString() async {
  // Normalmente algumas outras async
  // operações seriam feitas aqui.
  return 'Valor String';
}
```

Chame esta função `async` da seguinte forma:

```dart
Future<String> stringFuture = fetchString();
stringFuture.then((String str) {
  print(str); // 'Valor String'
});
```

Obtenha o valor de um _future_ usando a palavra-chave `await`.
Como no JavaScript, isso remove a necessidade de chamar `then`
no `Future` para obter seu valor,
e permite que você escreva código assíncrono de uma
maneira mais semelhante a síncrona.
Como no JavaScript, aguardar _futures_ só é possível
dentro de um contexto `async` (como outra função `async`).

O exemplo a seguir mostra como aguardar um _future_ por seu valor:

```dart
// Só podemos aguardar futures dentro de um contexto async.
Future<void> asyncFunction() async {
  var str = await fetchString();
  print(str); // 'Valor String'
}
```

Para saber mais sobre `Future`s e a
sintaxe `async`/`await`, consulte o
tutorial de [Programação assíncrona][Programação assíncrona].

[Programação assíncrona]: /libraries/async/async-await

### Streams {:#streams}

Outra ferramenta no conjunto de ferramentas assíncronas do Dart são os `Stream`s.
Enquanto o JavaScript tem seu próprio conceito de streams,
os do Dart são mais parecidos com `Observable`s (Observáveis),
como encontrado na biblioteca `rxjs` comumente utilizada.
Se você estiver familiarizado com esta biblioteca,
os streams do Dart devem parecer familiares.

Para aqueles não familiarizados com esses conceitos:
`Stream`s basicamente agem como `Future`s (Futuros),
mas com múltiplos valores espalhados ao longo do tempo,
como um barramento de eventos. Seu código pode escutar um stream,
e ele pode tanto ser completado quanto atingir um estado de falha.

#### Escutando {:#listening}

Para escutar um stream, chame seu método `listen`
e forneça um método de callback (retorno de chamada). Sempre que o stream emite um valor,
o Dart chama este método:

```dart
Stream<int> stream = ...
stream.listen((int value) {
  print('Um valor foi emitido: $value');
});
```

O método `listen` inclui callbacks opcionais
para lidar com erros ou para quando o stream é completado:

```dart
stream.listen(
  (int value) { ... },
  onError: (err) {
    print('Stream encontrou um erro! $err');
  },
  onDone: () {
    print('Stream completado!');
  },
);
```

O método `listen` retorna uma instância de um
`StreamSubscription` (Assinatura de Stream), que você pode usar para parar
de escutar o stream:

```dart
StreamSubscription subscription = stream.listen(...);
subscription.cancel();
```

Esta não é a única maneira de escutar um stream.
Similar à sintaxe `async`/`await` para `Future`s,
você pode combinar um stream com um loop `for-in` em um
contexto `async`. O loop `for` invoca o
método de callback para cada item emitido,
e ele termina quando o stream completa ou gera um erro:

```dart
Future<int> sumStream(Stream<int> stream) async {
  var sum = 0;
  await for (final value in stream) {
    sum += value;
  }
  return sum;
}
```

Quando um erro ocorre ao escutar um stream
dessa forma, o erro é relançado na linha
contendo a palavra-chave `await`.
Você pode lidar com este erro com uma declaração `try-catch`:

```dart
try {
  await for (final value in stream) { ... }
} catch (err) {
  print('Stream encontrou um erro! $err');
}
```

#### Criando streams {:#creating-streams}

Assim como com `Future`s,
você tem diversas maneiras diferentes de criar um stream.
A classe `Stream` possui construtores utilitários para
criar streams de `Future`s ou `Iterable`s,
ou para criar streams que emitem valores em um intervalo de tempo.
Para aprender mais, veja a página da API [`Stream`][`Stream`].

[`Stream`]: {{site.dart-api}}/dart-async/Stream-class.html

##### StreamController {:#streamcontroller}

A classe utilitária [`StreamController`][`StreamController`] pode criar e controlar streams.
Sua propriedade stream expõe o stream que ele controla.
Seus métodos fornecem maneiras de adicionar eventos a esse stream.

Por exemplo, o método `add` pode emitir novos itens e o método `close`
completa o stream.

O exemplo a seguir mostra o uso básico de um controlador de stream:

```dart
var listeners = 0;
StreamController<int>? controller;
controller = StreamController<int>(
  onListen: () {
    // Emite um novo valor toda vez que o stream obtém um novo listener.
    controller!.add(listeners++);
    // Fecha o stream após o quinto listener.
    if (listeners > 5) controller.close();
  }
);
// Obtém o stream para o controlador de stream
var stream = controller.stream;
// Escuta o stream
stream.listen((int value) {
  print('$value');
});
```

[`StreamController`]: {{site.dart-api}}/dart-async/StreamController-class.html

##### Geradores assíncronos {:#async-generators}

Funções geradoras assíncronas podem criar streams.
Estas funções se assemelham a uma função geradora síncrona
mas usam a palavra-chave `async*` e retornam um `Stream`.

Em uma função geradora assíncrona, a palavra-chave `yield`
emite o valor fornecido para o stream. A palavra-chave `yield*`,
no entanto, trabalha com streams ao invés de outros iteráveis.
Isso permite que eventos de outros streams sejam emitidos para este stream.
No exemplo a seguir,
a função continua uma vez que o stream recém emitido tenha completado.

```dart
Stream<int> asynchronousNaturalsTo(int n) async* {
  var k = 0;
  while (k < n) yield k++;
}

Stream<int> stream = asynchronousNaturalsTo(5);

// Imprime cada um de 0 1 2 3 4 em sequência.
stream.forEach(print(value));
```

Aprenda mais sobre futures (futuros), streams,
e outras funcionalidades assíncronas na
documentação de [programação assíncrona][programação assíncrona].

[programação assíncrona]: /libraries/async/using-streams

## Classes {:#classes}

Superficialmente, classes em Dart são similares a classes
em JavaScript, apesar de classes em JavaScript serem tecnicamente
mais um wrapper (invólucro) em torno de prototypes (protótipos). Em Dart,
classes são um recurso padrão da linguagem.
Esta seção aborda como definir e usar classes em Dart
e como elas diferem do JavaScript.

### Contexto "this" {:#this-context}

A palavra-chave `this` em Dart é mais direta
do que em JavaScript. Em Dart, você não pode associar funções
a `this`, e `this` nunca depende do contexto de execução
(como acontece em JavaScript). Em Dart,
`this` é usado somente dentro de classes,
e sempre se refere à instância atual.

### Construtores {:#constructors}

Esta seção discute como os construtores diferem em
Dart do JavaScript.

#### Construtor padrão {:#standard-constructor}

Um construtor de classe padrão parece muito similar a
um construtor de JavaScript. Em Dart,
a palavra-chave `constructor` é substituída pelo nome completo da classe,
e todos os parâmetros devem ser explicitamente tipados. Em Dart,
a palavra-chave `new` era antes requerida para criar instâncias de classe,
mas agora é opcional e seu uso não é mais recomendado.

```dart
class Point {
  final double x;
  final double y;

  Point(double x, double y) : this.x = x, this.y = y { }
}

// Cria uma nova instância da classe Point
Point p = Point(3, 5);
```

#### Listas de inicializadores {:#initializer-lists}

Use listas de inicializadores para escrever seu construtor.
Insira a lista de inicializadores entre os parâmetros do construtor
e o corpo.

```dart
class Point {
  ...
  Point.fromJson(Map<String, double> json)
      : x = json['x']!,
        y = json['y']! {
    print('Em Point.fromJson(): ($x, $y)');
  }
  ...
}
```

#### Parâmetros do construtor {:#constructor-parameters}

Escrever código para atribuir campos de classe no construtor
pode parecer criar código repetitivo,
então Dart tem um "açúcar sintático", chamado
[parâmetros de inicialização][parâmetros de inicialização] para tornar isso mais fácil:

```dart
class Point {
  double x;
  double y;

  // "Açúcar sintático" para definir x e y
  // antes do corpo do construtor rodar.
  Point(this.x, this.y);
}

// Cria uma nova instância da classe Point
Point p = Point(3, 5);
```

[parâmetros de inicialização]: /language/constructors

Similar a funções, construtores têm a
opção de receber parâmetros posicionados ou nomeados:

```dart
class Point {
  ...
  // Com um parâmetro posicional opcional
  Point(this.x, [this.y = 5]);
  // Com parâmetros nomeados
  Point({ required this.y, this.x = 5 });
  // Com parâmetros posicionais e nomeados
  Point(int x, int y, { boolean multiply }) {
    ...
  }
  ...
}
```

#### Construtores nomeados {:#named-constructors}

Diferente de JavaScript, Dart permite que classes tenham
múltiplos construtores, permitindo que você os nomeie.
Você pode opcionalmente ter um único construtor não nomeado,
qualquer construtor adicional deve ser nomeado:

```dart
const double xOrigin = 0;
const double yOrigin = 0;

class Point {
  double x = 0;
  double y = 0;

  Point(this.x, this.y);

  // Construtor nomeado
  Point.origin()
      : x = xOrigin,
        y = yOrigin;
}
```

#### Construtores const {:#const-constructors}

Para habilitar instâncias de classe imutáveis, use um construtor `const`.
Uma classe com um construtor `const` pode ter somente variáveis de instância `final`.

```dart
class ImmutablePoint {
  final double x, y;

  const ImmutablePoint(this.x, this.y);
}
```

#### Redirecionamento de construtor {:#constructor-redirection}

Você pode chamar construtores de outros construtores para evitar código
duplicado ou para adicionar valores padrão adicionais para parâmetros:

```dart
class Point {
  double x, y;

  // O construtor principal para esta classe.
  Point(this.x, this.y);

  // Delega para o construtor principal.
  Point.alongXAxis(double x) : this(x, 0);
}
```

#### Construtores factory {:#factory-constructors}

Você pode usar um construtor factory (fábrica) quando você
não precisa criar uma nova instância de classe.
Um exemplo seria ao retornar uma instância em cache:

```dart
class Logger {
  static final Map<String, Logger> _cache =
      <String, Logger>{};
 
  final String name;
 
  // Construtor factory que retorna uma cópia em cache,
  // ou cria uma nova se ela ainda não estiver disponível.
  factory Logger(String name) {
    return _cache.putIfAbsent(
        name, () => _cache[name] ??= Logger._internal(name);
  }

  // Construtor privado para uso interno somente
  Logger._internal(this.name);
}
```

### Métodos {:#methods}

Tanto em Dart quanto em JavaScript, métodos servem como funções que fornecem
comportamento para um objeto.

```js
function doSomething() { // Isso é uma função
  // Implementação..
}

class Example {
  doSomething() { // Isso é um método
    // Implementação..
  }
}
```

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



### Estendendo classes {:#extending-classes}

Dart permite que classes estendam outra classe,
da mesma forma que JavaScript faz.

```dart
class Animal {
  int eyes;
 
  Animal(this.eyes);
 
  makeNoise() {
    print('???');
  }
}

class Cat extends Animal {
  Cat(): super(2);

  @override
  makeNoise() {
    print('Miau');
  }
}
Animal animal = Cat();
print(animal.eyes); // 2
animal.makeNoise(); // Miau
```

Ao sobrescrever um método da classe pai,
use a anotação `@override`.
Apesar dessa anotação ser opcional,
ela mostra que a sobrescrita é intencional.
O analisador do Dart mostra um aviso se o método
não estiver realmente sobrescrevendo um método de superclasse.

O método pai que está sendo sobrescrito ainda pode
ser chamado usando a palavra-chave `super`:

```dart
class Cat extends Animal {
  ...
  @override
  makeNoise() {
    print('Miau');
    super.makeNoise();
  }
}
Animal animal = Cat();
animal.makeNoise(); // Miau
                    // ???
```

### Classes como interfaces {:#classes-as-interfaces}

Assim como JavaScript, Dart não tem uma
definição separada para interfaces. No entanto,
diferente de JavaScript, todas as definições de classe funcionam
como uma interface; você pode implementar uma classe como
uma interface usando a palavra-chave `implements`.

Quando uma classe é implementada como uma interface,
sua API pública deve ser implementada pela nova classe.
Diferente de `extends`, suas implementações de método e campo
não são compartilhadas com a nova classe.
Enquanto uma classe pode apenas estender uma única classe,
você pode implementar múltiplas interfaces por vez,
mesmo quando a classe que implementa já estende outra.

```dart
class Consumer {
  consume() {
    print('Comendo comida...');
  }
}
class Cat implements Consumer {
  consume() {
    print('Comendo ratos...');
  }
}
Consumer consumer = Cat();
consumer.consume(); // Comendo ratos
```

Ao implementar uma interface,
o método `super` não pode ser chamado
pois os corpos dos métodos não são herdados:

```dart
class Cat implements Consumer {
  @override
  consume() {
    print('Comendo ratos...');
    super.consume(); 
    // Inválido. A superclasse `Object` não tem o método `consume`.
  }
}
```

### Classes e métodos abstratos {:#abstract-classes-and-methods}

Para garantir que uma classe possa somente ser estendida
ou ter sua interface implementada,
mas para não permitir a construção de quaisquer instâncias,
marque-a como `abstract` (abstrata).

Classes marcadas como `abstract` podem ter métodos abstratos,
que não requerem um corpo e são, em vez disso, requeridos
para serem implementados quando a classe é estendida
ou sua interface é implementada:

```dart
abstract class Consumer {
  consume();
}
// Estendendo a classe completa
class Dog extends Consumer {
  consume() {
    print('Comendo biscoitos...');
  }
}
// Apenas implementando a interface
class Cat implements Consumer {
  consume() {
    print('Comendo ratos...');
  }
}
Consumer consumer;
consumer = Dog();
consumer.consume(); // Comendo biscoitos...
consumer = Cat();
consumer.consume(); // Comendo ratos...
```

### Mixins {:#mixins}

Mixins são usados para compartilhar funcionalidades entre classes.
Você pode usar os campos e métodos do mixin na classe,
usando suas funcionalidades como se fossem parte da classe.
Uma classe pode usar múltiplos mixins. Isso ajuda quando múltiplas classes compartilham a
mesma funcionalidade,
sem precisar herdar umas das outras ou compartilhar um ancestral comum.

Use a palavra-chave `with` para adicionar um ou mais mixins separados por vírgula para uma classe.

JavaScript não tem uma palavra-chave equivalente. JavaScript pode usar `Object.assign`
para mesclar objetos adicionais em um objeto existente, após instanciar.

Os exemplos a seguir mostram como JavaScript e Dart alcançam um comportamento similar:

```js
class Animal {}

// Definindo os mixins
class Flyer {
  fly = () => console.log('Bate asas');
}
class Walker {
  walk = () => console.log('Anda sobre as pernas');
}
 
class Bat extends Animal {}
class Goose extends Animal {}
class Dog extends Animal {}

// Compondo as instâncias de classe com
// suas funcionalidades corretas.
const bat =
  Object.assign(
    new Bat(),
    new Flyer()
    );
const goose =
  Object.assign(
    new Goose(),
    new Flyer(),
    new Walker()
    );
const dog =
  Object.assign(
    new Dog(),
    new Walker()
    );

// Chamadas corretas
bat.fly();
goose.fly();
goose.walk();
dog.walk();
// Chamadas incorretas
bat.walk(); // `bat` não tem o método `walk`
dog.fly(); // `dog` não tem o método `fly`
```


```dart
abstract class Animal {}

// Definindo os mixins
class Flyer {
  fly() => print('Bate asas');
}
class Walker {
  walk() => print('Anda sobre as pernas');
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
Bat().walk(); // Não usando o mixin Walker
Dog().fly(); // Não usando o mixin Flyer
```

Alternativamente, você pode substituir a palavra-chave `class`
com `mixin` para impedir que o mixin seja usado
como uma classe regular:

```dart
mixin Walker {
  walk() => print('Anda sobre as pernas');
}
// Não é possível, pois Walker não é mais uma classe.
class Bat extends Walker {}
```

Já que você pode usar múltiplos mixins,
eles podem ter métodos ou campos sobrepostos
uns com os outros quando usados na mesma classe.
Eles podem até se sobrepor com a classe que os usa,
ou com a superclasse daquela classe.
A ordem na qual eles são adicionados a uma classe importa.

Para dar um exemplo:

```dart
class Bird extends Animal with Consumer, Flyer {
```

Quando um método é chamado em uma instância de `Bird`,
Dart começa com sua própria classe, `Bird`,
que tem precedência sobre outras implementações.
Se `Bird` não tem implementação,
então `Flyer` é verificado, seguido por `Consumer`,
até que uma implementação seja encontrada.
A classe pai, `Animal`, é verificada por último.

### Extensões {:#extensions}

Estender classes, implementar interfaces, ou usar
mixins, tudo funciona quando a classe afetada é editável.
No entanto, às vezes é útil estender uma classe que
já existe ou faz parte de outra biblioteca ou do SDK Dart.

Nesses casos, Dart oferece a capacidade de escrever extensões
para classes existentes.

Como um exemplo, a seguinte extensão na classe `String`
do SDK Dart permite analisar inteiros:

```dart
extension NumberParsing on String {
  int parseInt() {
    return int.parse(this);
  }
}
```

Para que a extensão se torne disponível,
ela tem que estar presente no mesmo arquivo,
ou seu arquivo deve ser importado.

Use-a da seguinte forma:

```dart
import 'string_apis.dart'; // Importa o arquivo onde a extensão está
var age = '42'.parseInt(); // Usa o método de extensão.
```

### Getters e setters {:#getters-and-setters}

Getters e setters em Dart funcionam exatamente como
suas contrapartes em JavaScript:

```js
class Person {
  _age = 0;

  get age() {
    return this._age;
  }

  set age(value) {
    if (value < 0) {
      throw new Error(
        'A idade não pode ser negativa'
        );
    }
    this._age = value;
  }
}

var person = new Person();
person.age = 10;
console.log(person.age);
```


```dart
class Person {
  int _age = 0;
 
  int get age {
    return _age;
  }
 
  set age(int value) {
    if (value < 0) {
      throw ArgumentError(
        'A idade não pode ser negativa'
        );
    }
    _age = value;
  }
}

void main() {
  var person = Person();
  person.age = 10;
  print(person.age);
}
```



### Membros públicos e privados {:#public-and-private-members}

Assim como JavaScript, Dart não tem palavras-chave de modificador de acesso:
todos os membros de classe são públicos por padrão.

JavaScript incluirá membros de classe privados na próxima
revisão prática do padrão EcmaScript.
Como tal, implementações para isso têm estado disponíveis em
vários browsers e runtimes por algum tempo.

Para tornar um membro de classe privado em JavaScript,
prefixe seu nome com um símbolo de libra (ou hash) (`#`).

```js
class Animal {
  eyes; // Campo público
  #paws; // Campo privado

  #printEyes() { // Método privado
    print(this.eyes);
  }

  printPaws() { // Método público
    print(this.#paws);
  }
}
```

Para tornar um membro de classe privado em Dart, prefixe seu nome
com um underscore (`_`).

```dart
class Animal {
  int eyes; // Campo público
  int _paws; // Campo privado

  void _printEyes() { // Método privado
    print(this.eyes);
  }

  void printPaws() { // Método público
    print(this._paws);
  }
}
```

JavaScript usa o hash como uma convenção.
O compilador do Dart impõe o uso do underscore para esse recurso.

Dart torna membros privados privados para a biblioteca, não para a classe.
Isso significa que você pode acessar membros privados do código na mesma biblioteca.
Por padrão, o Dart limita o acesso a membros privados de classe ao código no mesmo arquivo.
Para expandir o escopo de uma biblioteca além de um arquivo, adicione a diretiva `part`.
Quando possível, [evite usar `part`][evite usar `part`]. Reserve o uso de `part` para geradores de código.

[evite usar `part`]: /tools/pub/create-packages#organizing-a-package

### Variáveis late {:#late-variables}

Para indicar que Dart inicializa campos de classe em um ponto posterior,
atribua a palavra-chave `late` para esses campos de classe.
Esses campos de classe permanecem não anuláveis.
Faça isso quando uma variável não precisa ser observada ou acessada imediatamente
e pode ser inicializada depois.
Isso difere de rotular o campo como anulável.

* Campos `late` (não anuláveis) não podem ter null atribuído em um ponto posterior.

* Campos `late` (não anuláveis) lançam um erro em tempo de execução quando
  acessados antes de serem inicializados. Isso deve ser evitado.

```dart
class PetOwner {
  final String name;
  late final Pet _pet;
  PetOwner(this.name, String petName) {
    // Gráfico de objeto cíclico, não pode definir _pet antes que o dono exista.
    _pet = Pet(petName, this);
  }
  Pet get pet => _pet;
}
class Pet {
  final String name;
  final PetOwner owner;
  Pet(this.name, this.owner);
}
```

Use `late` para variáveis locais somente se um código não claro resultar
no compilador sendo incapaz de determinar se o código inicializou a variável.

```dart
doSomething(int n, bool capture) {
  late List<Foo> captures;
  if (capture) captures = [];
  for (var i = 0; i < n; i++) {
    var foo = something(i);
    if (capture) captures.add(foo);
  }
}
```

No exemplo anterior, o compilador não sabe atribuir
`captures` se `capture` for verdadeiro. Usar `late` atrasa o normal
"atribuído" verifica até o tempo de execução.

## Generics {:#generics}

Enquanto JavaScript não oferece generics (genéricos),
Dart oferece para melhorar a segurança de tipo e reduzir a duplicação de código.

### Métodos genéricos {:#generic-methods}

Você pode aplicar generics a métodos.
Para definir um parâmetro de tipo genérico, coloque-o entre colchetes angulares `< >`
após o nome do método.
Você pode então usar este tipo dentro do método
como o tipo de retorno ou dentro dos parâmetros do método:

```dart
Map<Object?, Object?> _cache = {};
T cache<T>(T value) => (_cache[value] ??= value) as T;
```

Defina múltiplos tipos genéricos separando-os com uma vírgula:

```dart
// Definindo um método com múltiplos genéricos.
T transform<T, Q>(T param1, Q param2) {
   ...
}
// Chamando o método com tipos explicitamente definidos.
transform<int, String>(5, 'valor string');
// Tipos são opcionais quando o analisador pode inferi-los.
transform(5, 'valor string');
```

### Classes genéricas {:#generic-classes}

Generics também podem ser aplicados a classes.
Você pode incluir o tipo para usar quando chamar um construtor.
Isso permite que você personalize classes reutilizáveis para tipos específicos.

No exemplo a seguir, a classe `Cache` armazena em cache tipos específicos:

```dart
class Cache<T> {
  T getByKey(String key) {}
  void setByKey(String key, T value) {}
}
// Criando um cache para strings
var stringCache = Cache<String>(); // stringCache tem tipo Cache<String>
stringCache.setByKey('Foo', 'Bar'); // Válido, definindo um valor string.
stringCache.setByKey('Baz', 5); // Inválido, o tipo int não corresponde ao genérico.
```

Se você omitir a declaração de tipo,
o tipo de tempo de execução se torna `Cache<dynamic>`
e ambas as chamadas para `setByKey` são válidas.

### Restringindo generics {:#restricting-generics}

Você pode usar generics para restringir seu código para
uma família de tipos usando `extends`. Isso garante
que sua classe é instanciada com um tipo genérico
que estende um tipo específico:

```dart
class NumberManager<T extends num> {
   ...
}
// Válido.
var manager = NumberManager<int>();
var manager = NumberManager<double>();
// Inválido, String nem suas classes pai estendem num.
var manager = NumberManager<String>();
```

### Generics em literais {:#generics-in-literals}

Literais `Map`, `Set` e `List` podem aceitar argumentos de tipo.
Isso ajuda quando Dart não consegue inferir o tipo ou inferir o tipo corretamente.

Por exemplo, a classe `List` tem uma definição genérica:
`class List<E>`. O parâmetro de tipo `E` se refere ao tipo de
conteúdo da lista. Normalmente, esse tipo é automaticamente inferido,
que é usado em alguns tipos de membro da classe `List`.
(Por exemplo, seu primeiro getter retorna um valor de tipo `E`.)
Ao definir um literal `List`,
você pode definir explicitamente o tipo genérico da seguinte forma:

```dart
// Inferência automática de tipo
var objList = [5, 2.0]; // Tipo: List<num>
// Definição explícita de tipo:
var objList = <Object>[5, 2.0]; // Tipo: List<Object>
// Sets funcionam de forma idêntica:
var objSet = <Object>{5, 2.0};
```

Isso também é verdade para `Map`s,
que também definem seus tipos de chave e valor
usando generics (`class Map<K, V>`):

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

## Doc comments {:#doc-comments}

Comentários regulares funcionam da mesma forma em Dart como funcionam
em JavaScript. Usar `//` comenta tudo depois
dele para o restante da linha, e você pode usar `/* ... */`
para bloquear comentários que abrangem múltiplas linhas.

Além de comentários regulares,
Dart também tem [doc comments][doc comments] (comentários de documentação) que funcionam em conjunto
com [`dart doc`][`dart doc`]: uma ferramenta primária que gera
documentação HTML para pacotes Dart.
É considerado uma melhor prática colocar doc comments
acima de todas as declarações para membros públicos.

Defina um doc comment usando três barras para frente
ao invés de duas (`///`):

```dart
/// O número de caracteres neste chunk (pedaço) quando não dividido.
int get length => ...
```

[`dart doc`]: /tools/dart-doc
[doc comments]: /effective-dart/documentation#doc-comments

## Próximos passos {:#next-steps}

Este guia apresentou você às principais diferenças
entre Dart e JavaScript. Neste ponto,
considere ler a documentação do Dart.
Você também pode ler a documentação do [Flutter]({{site.flutter}}).
Construído com Dart, Flutter é um framework de código aberto que
usa Dart para construir aplicações multi-plataforma, compiladas nativamente,
de uma única base de código.
Essas documentações fornecem informações detalhadas sobre a
linguagem e formas práticas de começar.

Alguns possíveis próximos passos:

* [Language tour][Language tour] (Tour da Linguagem) para aprender mais sobre a linguagem Dart
* [Core library documentation][Core library documentation] (Documentação da Biblioteca Principal) para aprender sobre as bibliotecas principais do Dart
* [Dart tutorials][Dart tutorials] (Tutoriais Dart) para prática aplicada cobrindo uma variedade de tópicos
* [Effective Dart][Effective Dart] (Dart Efetivo) para aprender sobre convenções comuns
   e diretrizes ao escrever código Dart

[Language tour]: /language
[Core library documentation]: /libraries
[Dart tutorials]: /tutorials
[Effective Dart]: /effective-dart
