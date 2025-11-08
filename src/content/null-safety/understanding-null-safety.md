---
ia-translate: true
title: Entendendo null safety
description: >-
    Um mergulho profundo nas mudanças da linguagem e bibliotecas Dart relacionadas a null safety.
---

_Escrito por Bob Nystrom<br>
Julho 2020_

Null safety é a maior mudança que fizemos no Dart desde que substituímos o
sistema de tipos opcional original não-seguro (unsound) por [um sistema de tipos estático seguro (sound)][strong]
no Dart 2.0. Quando o Dart foi lançado pela primeira vez, null safety em tempo de compilação era um recurso
raro que precisava de uma longa introdução. Hoje, Kotlin, Swift, Rust e outras
linguagens têm suas próprias respostas para o que se tornou um [problema
muito familiar.][billion] Aqui está um exemplo:

[strong]: /language/type-system
[billion]: https://www.infoq.com/presentations/Null-References-The-Billion-Dollar-Mistake-Tony-Hoare/

```dart
// Without null safety:
bool isEmpty(String string) => string.length == 0;

void main() {
  isEmpty(null);
}
```

Se você executar este programa Dart sem null safety, ele lança uma
exceção `NoSuchMethodError` na chamada para `.length`. O valor `null` é uma
instância da classe `Null`, e `Null` não tem um getter "length". Falhas em tempo de execução
são ruins. Isso é especialmente verdadeiro em uma linguagem como Dart que é projetada
para executar no dispositivo de um usuário final. Se uma aplicação de servidor falha, você pode frequentemente
reiniciá-la antes que alguém perceba. Mas quando um aplicativo Flutter trava no telefone
de um usuário, eles não ficam felizes. Quando seus usuários não estão felizes, você não está feliz.

Desenvolvedores gostam de linguagens estaticamente tipadas como Dart porque elas permitem que o
type checker encontre erros no código em tempo de compilação, geralmente diretamente na IDE.
Quanto mais cedo você encontra um bug, mais cedo você pode corrigi-lo. Quando designers de linguagens
falam sobre "corrigir erros de referência nula", eles querem dizer enriquecer o type
checker estático para que a linguagem possa detectar erros como a tentativa acima de chamar
`.length` em um valor que pode ser `null`.

Não existe uma única solução verdadeira para este problema. Rust e Kotlin têm suas
próprias abordagens que fazem sentido no contexto dessas linguagens. Este documento percorre
todos os detalhes da nossa resposta para o Dart. Inclui mudanças no
sistema de tipos estático e um conjunto de outras modificações e novos recursos de linguagem
para permitir que você não apenas escreva código null-safe, mas esperançosamente *aproveite* fazê-lo.

Este documento é longo. Se você quer algo mais curto que cubra apenas o que você
precisa saber para começar, comece com a [visão geral][]. Quando você estiver
pronto para um entendimento mais profundo e tiver tempo, volte aqui para que você possa
entender *como* a linguagem lida com `null`, *por que* projetamos dessa maneira, e
como escrever código Dart null-safe idiomático e moderno. (Alerta de spoiler: acaba sendo
surpreendentemente próximo de como você escreve Dart hoje.)

[overview]: /null-safety

As várias maneiras pelas quais uma linguagem pode lidar com erros de referência nula têm seus
prós e contras. Estes princípios guiaram as escolhas que fizemos:

*   **O código deve ser seguro por padrão.** Se você escreve novo código Dart e não usa
    nenhum recurso explicitamente não-seguro, ele nunca lança um erro de referência nula em
    tempo de execução. Todos os possíveis erros de referência nula são capturados estaticamente. Se você
    quer adiar parte dessa verificação para o tempo de execução para obter maior flexibilidade,
    você pode, mas você tem que escolher isso usando algum recurso que seja textualmente
    visível no código.

    Em outras palavras, não estamos te dando um colete salva-vidas e deixando para você
    se lembrar de colocá-lo toda vez que você sai na água. Em vez disso, nós
    te damos um barco que não afunda. Você fica seco a menos que você pule para fora.

*   **Código null-safe deve ser fácil de escrever.** A maioria do código Dart existente é
    dinamicamente correto e não lança erros de referência nula. Você gosta do seu
    programa Dart do jeito que ele parece agora, e nós queremos que você possa continuar
    escrevendo código dessa maneira. Segurança não deve exigir sacrificar usabilidade,
    pagar penitência ao type checker, ou ter que mudar significativamente a
    forma como você pensa.

*   **O código null-safe resultante deve ser totalmente seguro (sound).** "Soundness" no
    contexto de verificação estática significa coisas diferentes para pessoas diferentes. Para
    nós, no contexto de null safety, isso significa que se uma expressão tem um
    tipo estático que não permite `null`, então nenhuma execução possível dessa
    expressão pode nunca avaliar para `null`. A linguagem fornece essa garantia
    principalmente através de verificações estáticas, mas pode haver algumas verificações em tempo de execução envolvidas
    também. (Embora, note o primeiro princípio: qualquer lugar onde essas verificações em tempo de execução
    aconteçam será sua escolha.)

    Soundness é importante para a confiança do usuário. Um barco que *na maioria das vezes* fica
    à tona não é um que você está entusiasmado em enfrentar o mar aberto. Mas também é
    importante para nossos intrépidos hackers de compilador. Quando a linguagem faz
    garantias difíceis sobre propriedades semânticas de um programa, isso significa que o
    compilador pode realizar otimizações que assumem que essas propriedades são verdadeiras.
    Quando se trata de `null`, isso significa que podemos gerar código menor que
    elimina verificações de `null` desnecessárias, e código mais rápido que não precisa
    verificar se um receptor é não-`null` antes de chamar métodos nele.

    Uma ressalva: Nós apenas garantimos soundness em programas Dart que são totalmente null
    safe. Dart suporta programas que contêm uma mistura de código null-safe mais novo
    e código legado mais antigo. Nesses programas de versão mista, erros de referência nula
    ainda podem ocorrer. Em um programa de versão mista, você obtém todos os benefícios de segurança *estática*
    nas partes que são null safe, mas você não obtém soundness completa em tempo de execução
    até que toda a aplicação seja null safe.

Note que *eliminar* `null` não é um objetivo. Não há nada de errado com `null`.
Pelo contrário, é realmente útil poder representar a *ausência* de um
valor. Construir suporte para um valor especial "ausente" diretamente na linguagem
torna trabalhar com ausência flexível e utilizável. Isso sustenta parâmetros opcionais, o útil operador null-aware `?.`, e inicialização padrão. Não
é `null` que é ruim, é ter `null` indo *onde você não espera*
que causa problemas.

Assim, com null safety, nosso objetivo é dar a você *controle* e *visão* sobre
onde `null` pode fluir pelo seu programa e certeza de que ele não pode fluir
para algum lugar que causaria uma falha.

## Nullability in the type system

Null safety começa no sistema de tipos estático porque tudo o resto repousa sobre
isso. Seu programa Dart tem um universo inteiro de tipos nele: tipos primitivos
como `int` e `String`, tipos de coleção como `List`, e todas as classes
e tipos que você e os pacotes que você usa definem. Antes de null safety, o sistema de
tipos estático permitia que o valor `null` fluísse para expressões de qualquer um desses
tipos.

Na terminologia da teoria de tipos, o tipo `Null` era tratado como um subtipo de todos os tipos:

<img src="/assets/img/null-safety/understanding-null-safety/hierarchy-before.png" alt="Null Safety Hierarchy Before" width="335">

O conjunto de operações—getters, setters, métodos e
operadores—permitidas em algumas expressões são definidas por seu tipo. Se o tipo
é `List`, você pode chamar `.add()` ou `[]` nele. Se é `int`, você pode chamar `+`.
Mas o valor `null` não define nenhum desses métodos. Permitir que `null`
flua para uma expressão de algum outro tipo significa que qualquer uma dessas operações pode
falhar. Este é realmente o cerne dos erros de referência nula—toda falha vem
de tentar buscar um método ou propriedade em `null` que ele não tem.

### Non-nullable and nullable types

Null safety elimina esse problema na raiz mudando a hierarquia de tipos.
O tipo `Null` ainda existe, mas não é mais um subtipo de todos os tipos.
Em vez disso, a hierarquia de tipos se parece com isto:

<img src="/assets/img/null-safety/understanding-null-safety/hierarchy-after.png" alt="Null Safety Hierarchy After" width="344">

Como `Null` não é mais um subtipo, nenhum tipo exceto a classe especial `Null`
permite o valor `null`. Tornamos todos os tipos *non-nullable por padrão*. Se você
tem uma variável do tipo `String`, ela sempre conterá *uma string*. Pronto,
nós corrigimos todos os erros de referência nula.

Se não achássemos `null` útil de forma alguma, poderíamos parar aqui. Mas `null` é
útil, então ainda precisamos de uma maneira de lidar com ele. Parâmetros opcionais são um bom
caso ilustrativo. Considere este código Dart null-safe:

```dart
// Using null safety:
void makeCoffee(String coffee, [String? dairy]) {
  if (dairy != null) {
    print('$coffee with $dairy');
  } else {
    print('Black $coffee');
  }
}
```

Aqui, queremos permitir que o parâmetro `dairy` aceite qualquer string, ou o valor
`null`, mas nada mais. Para expressar isso, damos a `dairy` um *nullable type*
adicionando `?` no final do tipo base subjacente `String`. Por baixo dos panos,
isso está essencialmente definindo uma [união][union] do tipo subjacente e do tipo `Null`.
Então `String?` seria uma abreviação para `String|Null` se o Dart tivesse
tipos união completos.

[union]: https://en.wikipedia.org/wiki/Union_type

### Using nullable types

Se você tem uma expressão com um nullable type, o que você pode fazer com o resultado?
Como nosso princípio é seguro por padrão, a resposta é não muito. Não podemos deixar você
chamar métodos do tipo subjacente nele porque eles podem falhar se o valor
for `null`:

```dart
// Hypothetical unsound null safety:
void bad(String? maybeString) {
  print(maybeString.length);
}

void main() {
  bad(null);
}
```

Isso travaria se deixássemos você executá-lo. Os únicos métodos e propriedades que podemos
seguramente deixar você acessar são os definidos tanto pelo tipo subjacente quanto pela
classe `Null`. Isso é apenas `toString()`, `==`, e `hashCode`. Então você pode usar
nullable types como chaves de map, armazená-los em sets, compará-los a outros valores,
e usá-los em interpolação de string, mas isso é basicamente tudo.

Como eles interagem com non-nullable types? É sempre seguro passar um
tipo *não*-nullable para algo esperando um nullable type. Se uma função
aceita `String?` então passar uma `String` é permitido porque não causará nenhum
problema. Nós modelamos isso fazendo todo nullable type um supertipo de seu
tipo subjacente. Você também pode passar `null` com segurança para algo esperando um nullable type, então
`Null` também é um subtipo de todo nullable type:

<img src="/assets/img/null-safety/understanding-null-safety/nullable-hierarchy.png" alt="Nullable" width="235">

Mas ir na outra direção e passar um nullable type para algo esperando
o tipo non-nullable subjacente não é seguro. Código que espera uma `String` pode
chamar métodos `String` no valor. Se você passar uma `String?` para ele, `null` poderia
fluir e isso poderia falhar:

```dart
// Hypothetical unsound null safety:
void requireStringNotNull(String definitelyString) {
  print(definitelyString.length);
}

void main() {
  String? maybeString = null; // Or not!
  requireStringNotNull(maybeString);
}
```

Este programa não é seguro e não devemos permiti-lo. No entanto, o Dart sempre teve
essa coisa chamada *implicit downcasts*. Se você, por exemplo, passa um valor do
tipo `Object` para uma função esperando uma `String`, o type checker permite:

```dart
// Without null safety:
void requireStringNotObject(String definitelyString) {
  print(definitelyString.length);
}

void main() {
  Object maybeString = 'it is';
  requireStringNotObject(maybeString);
}
```

Para manter a soundness, o compilador silenciosamente insere um cast `as String` no
argumento para `requireStringNotObject()`. Esse cast pode falhar e lançar uma
exceção em tempo de execução, mas em tempo de compilação, o Dart diz que isso está OK. Como
non-nullable types são modelados como subtipos de nullable types, implicit downcasts
permitiriam que você passasse uma `String?` para algo esperando uma `String`. Permitir isso
violaria nosso objetivo de ser seguro por padrão. Então com null safety estamos
removendo implicit downcasts completamente.

Isso faz a chamada para `requireStringNotNull()` produzir um erro de compilação, que
é o que você quer. Mas também significa que *todos* os implicit downcasts se tornam erros de
compilação, incluindo a chamada para `requireStringNotObject()`. Você terá que adicionar o
downcast explícito você mesmo:

```dart
// Using null safety:
void requireStringNotObject(String definitelyString) {
  print(definitelyString.length);
}

void main() {
  Object maybeString = 'it is';
  requireStringNotObject(maybeString as String);
}
```

Achamos que isso é uma mudança boa no geral. Nossa impressão é que a maioria dos usuários nunca
gostou de implicit downcasts. Em particular, você pode ter sido prejudicado por isto
antes:

```dart
// Without null safety:
List<int> filterEvens(List<int> ints) {
  return ints.where((n) => n.isEven);
}
```

Percebeu o bug? O método `.where()` é preguiçoso, então ele retorna um `Iterable`, não uma
`List`. Este programa compila mas depois lança uma exceção em tempo de execução quando tenta
fazer cast desse `Iterable` para o tipo `List` que `filterEvens` declara que
retorna. Com a remoção de implicit downcasts, isso se torna um erro de compilação.

Onde estávamos? Certo, OK, então é como se tivéssemos pegado o universo de tipos em
seu programa e dividido em duas metades:

<img src="/assets/img/null-safety/understanding-null-safety/bifurcate.png" alt="Nullable and Non-Nullable types" width="668">

Há uma região de non-nullable types. Esses tipos permitem que você acesse todos os
métodos interessantes, mas nunca podem conter `null`. E então há uma
família paralela de todos os nullable types correspondentes. Esses permitem `null`,
mas você não pode fazer muito com eles. Nós deixamos valores fluirem do lado non-nullable
para o lado nullable porque fazer isso é seguro, mas não na outra direção.

Parece que nullable types são basicamente inúteis. Eles não têm métodos e
você não pode se livrar deles. Não se preocupe, temos um conjunto inteiro de recursos para
ajudá-lo a mover valores da metade nullable para o outro lado que veremos
em breve.

### Top and bottom

Esta seção é um pouco esotérica. Você pode pular a maior parte dela, exceto por duas
marcas no final, a menos que você goste de coisas de sistemas de tipos. Imagine todos os
tipos em seu programa com arestas entre aqueles que são subtipos e supertipos
uns dos outros. Se você fosse desenhá-lo, como os diagramas neste documento, ele formaria
um grafo direcionado enorme com supertipos como `Object` perto do topo e classes
folha como seus próprios tipos perto da base.

Se esse grafo direcionado chega a um ponto no topo onde há um único tipo
que é o supertipo (direta ou indiretamente), esse tipo é chamado de *top
type*. Da mesma forma, se há um tipo estranho na base que é um subtipo de
todo tipo, você tem um *bottom type*. (Neste caso, seu grafo direcionado é um
[lattice.][lattice])

[lattice]: https://en.wikipedia.org/wiki/Lattice_(order)

É conveniente se seu sistema de tipos tem um top e bottom type, porque isso significa
que operações em nível de tipo como least upper bound (que type inference usa para
descobrir o tipo de uma expressão condicional baseada nos tipos de seus dois
ramos) sempre podem produzir um tipo. Antes de null safety, `Object` era o top
type do Dart e `Null` era seu bottom type.

Como `Object` é non-nullable agora, não é mais um top type. `Null` não é um
subtipo dele. Dart não tem um top type *nomeado*. Se você precisa de um top type, você quer
`Object?`. Da mesma forma, `Null` não é mais o bottom type. Se fosse, tudo
ainda seria nullable. Em vez disso, adicionamos um novo bottom type chamado `Never`:

<img src="/assets/img/null-safety/understanding-null-safety/top-and-bottom.png" alt="Top and Bottom" width="360">

Na prática, isso significa:

*   Se você quer indicar que você permite um valor de qualquer tipo, use `Object?`
    em vez de `Object`. Na verdade, torna-se bastante incomum usar `Object`
    já que esse tipo significa "poderia ser qualquer valor possível exceto este
    valor estranhamente proibido `null`".

*   Na rara ocasião em que você precisa de um bottom type, use
    `Never` em vez de `Null`.
    Isso é particularmente útil para indicar que uma função nunca retorna
    para [ajudar na análise de acessibilidade](#never-for-unreachable-code).
    Se você não sabe se precisa de um bottom type, provavelmente não precisa.

## Ensuring correctness

Dividimos o universo de tipos em metades nullable e non-nullable. Para
manter a soundness e nosso princípio de que você nunca pode obter um erro de referência
nula em tempo de execução a menos que você peça por isso, precisamos garantir que `null` nunca
apareça em qualquer tipo no lado non-nullable.

Livrar-se de implicit downcasts e remover `Null` como um bottom type cobre
todos os principais lugares onde tipos fluem através de um programa através de atribuições e
de argumentos para parâmetros em chamadas de função. Os principais lugares restantes
onde `null` pode se infiltrar são quando uma variável aparece pela primeira vez e quando
você sai de uma função. Então há alguns erros de compilação adicionais:

### Invalid returns

Se uma função tem um non-nullable return type, então todo caminho através da
função deve atingir uma declaração `return` que retorna um valor. Antes de null
safety, o Dart era bem relaxado sobre retornos faltantes. Por exemplo:

```dart
// Without null safety:
String missingReturn() {
  // No return.
}
```

Se você analisou isso, você recebeu uma *dica* gentil de que *talvez* você esqueceu um retorno,
mas se não, não há problema. Isso porque se a execução alcança o final de um
corpo de função, então o Dart implicitamente retorna `null`. Como todo tipo é nullable,
*tecnicamente* esta função é segura, mesmo que provavelmente não seja o que você
quer.

Com non-nullable types seguros (sound), este programa está completamente errado e inseguro. Com
null safety, você obtém um erro de compilação se uma função com um non-nullable return
type não retorna confiavelmente um valor. Por "confiavelmente", quero dizer que a linguagem
analisa todos os caminhos de fluxo de controle através da função. Desde que todos eles
retornem algo, ela está satisfeita. A análise é bem inteligente, então até esta
função está OK:

```dart
// Using null safety:
String alwaysReturns(int n) {
  if (n == 0) {
    return 'zero';
  } else if (n < 0) {
    throw ArgumentError('Negative values not allowed.');
  } else {
    if (n > 1000) {
      return 'big';
    } else {
      return n.toString();
    }
  }
}
```

Vamos mergulhar mais profundamente na nova análise de fluxo na próxima seção.

### Uninitialized variables

Quando você declara uma variável, se você não der a ela um inicializador explícito, o Dart
inicializa a variável por padrão com `null`. Isso é conveniente, mas obviamente
totalmente inseguro se o tipo da variável é non-nullable. Então temos que apertar
as coisas para variáveis non-nullable:

*   **Declarações de variável de nível superior e campo estático devem ter um
    inicializador.** Como esses podem ser acessados e atribuídos de qualquer lugar no
    programa, é impossível para o compilador garantir que a variável tenha
    recebido um valor antes de ser usada. A única opção segura é exigir
    a própria declaração de ter uma expressão inicializadora que produza um
    valor do tipo certo:

    ```dart
    // Using null safety:
    int topLevel = 0;

    class SomeClass {
      static int staticField = 0;
    }
    ```

*   **Campos de instância devem ter um inicializador na declaração, usar um
    inicializing formal, ou ser inicializados na lista de inicialização do construtor.** Isso é muito jargão. Aqui estão os exemplos:

    ```dart
    // Using null safety:
    class SomeClass {
      int atDeclaration = 0;
      int initializingFormal;
      int initializationList;

      SomeClass(this.initializingFormal)
          : initializationList = 0;
    }
    ```

    Em outras palavras, desde que o campo tenha um valor antes de você alcançar o
    corpo do construtor, você está bem.

*   Variáveis locais são o caso mais flexível. Uma variável local non-nullable
    *não* precisa ter um inicializador. Isso é perfeitamente aceitável:

    ```dart
    // Using null safety:
    int tracingFibonacci(int n) {
      int result;
      if (n < 2) {
        result = n;
      } else {
        result = tracingFibonacci(n - 2) + tracingFibonacci(n - 1);
      }

      print(result);
      return result;
    }
    ```

    A regra é apenas que **uma variável local deve ser *definitivamente atribuída*
    antes de ser usada.** Chegamos a confiar na nova análise de fluxo que aludi
    para isso também. Desde que todo caminho para o uso de uma variável a inicialize
    primeiro, o uso está OK.

*   **Parâmetros opcionais devem ter um valor padrão.** Se você não passar um
    argumento para um parâmetro posicional ou nomeado opcional, então a linguagem
    preenche com o valor padrão. Se você não especifica um valor padrão,
    o valor padrão _padrão_ é `null`, e isso não funciona se o tipo do parâmetro é
    non-nullable.

    Então, se você quer que um parâmetro seja opcional, você precisa torná-lo
    nullable ou especificar um valor padrão não-`null` válido.

Essas restrições soam onerosas, mas não são muito ruins na prática. Elas são
muito similares às restrições existentes em torno de variáveis `final` e você provavelmente
tem trabalhado com elas por anos sem sequer realmente notar. Além disso,
lembre-se de que elas só se aplicam a variáveis *non-nullable*. Você sempre pode tornar
o tipo nullable e então obter a inicialização padrão para `null`.

Mesmo assim, as regras causam fricção. Felizmente, temos um conjunto de novos
recursos de linguagem para lubrificar os padrões mais comuns onde essas novas
limitações te atrasam. Primeiro, porém, é hora de falar sobre análise de fluxo.

## Flow analysis

[Análise de fluxo de controle][Control flow analysis] existe em compiladores há anos. É principalmente
escondida dos usuários e usada durante otimização do compilador, mas algumas linguagens mais novas
começaram a usar as mesmas técnicas para recursos de linguagem visíveis.
O Dart já tem um pouco de análise de fluxo na forma de *type promotion*:

```dart
// With (or without) null safety:
bool isEmptyList(Object object) {
  if (object is List) {
    return object.isEmpty; // <-- OK!
  } else {
    return false;
  }
}
```

[control flow analysis]: https://en.wikipedia.org/wiki/Control_flow_analysis

Note como na linha marcada, podemos chamar `isEmpty` em `object`. Esse método é
definido em `List`, não em `Object`. Isso funciona porque o type checker olha para
todas as expressões `is` e os caminhos de fluxo de controle no programa. Se o
corpo de alguma construção de fluxo de controle só executa quando uma certa expressão `is`
em uma variável é verdadeira, então dentro desse corpo o tipo da variável é "promovido"
para o tipo testado.

No exemplo aqui, o ramo then da declaração `if` só executa quando
`object` realmente contém uma lista. Portanto, o Dart promove `object` para o tipo
`List` em vez de seu tipo declarado `Object`. Isso é um recurso útil, mas é
bem limitado. Antes de null safety, o seguinte programa funcionalmente idêntico
não funcionava:

```dart
// Without null safety:
bool isEmptyList(Object object) {
  if (object is! List) return false;
  return object.isEmpty; // <-- Error!
}
```

Novamente, você só pode alcançar a chamada `.isEmpty` quando `object` contém uma lista, então
este programa é dinamicamente correto. Mas as regras de type promotion não eram inteligentes
o suficiente para ver que a declaração `return` significa que a segunda declaração só pode ser
alcançada quando `object` é uma lista.

Para null safety, pegamos esta análise limitada e a tornamos [muito mais
poderosa de várias maneiras.][flow analysis]

[flow analysis]: {{site.repo.dart.lang}}/blob/main/resources/type-system/flow-analysis.md

### Reachability analysis

Primeiro, corrigimos a [reclamação antiga][18921] de que type promotion
não é inteligente sobre retornos antecipados e outros caminhos de código inalcançáveis. Ao analisar
uma função, agora leva em conta `return`, `break`, `throw`, e qualquer outra
forma de execução poder terminar cedo em uma função. Com null safety, esta função:

[18921]: {{site.repo.dart.sdk}}/issues/18921

```dart
// Using null safety:
bool isEmptyList(Object object) {
  if (object is! List) return false;
  return object.isEmpty;
}
```

Agora é perfeitamente válida. Como a declaração `if` sairá da função quando
`object` *não* é uma `List`, o Dart promove `object` para ser `List` na segunda
declaração. Isso é uma melhoria realmente boa que ajuda muito código Dart, mesmo
coisas não relacionadas a nullability.

### Never for unreachable code

Você também pode *programar* esta análise de acessibilidade. O novo bottom type `Never`
não tem valores. (Que tipo de valor é simultaneamente uma `String`, `bool`, e
`int`?) Então o que significa para uma expressão ter tipo `Never`? Significa
que a expressão nunca pode terminar de avaliar com sucesso. Ela deve lançar uma
exceção, abortar, ou de outra forma garantir que o código circundante esperando o
resultado da expressão nunca execute.

Na verdade, de acordo com a linguagem, o tipo estático de uma expressão `throw` é
`Never`. O tipo `Never` é declarado nas bibliotecas principais e você pode usá-lo
como uma anotação de tipo. Talvez você tenha uma função auxiliar para facilitar o lançamento
de um certo tipo de exceção:

```dart
// Using null safety:
Never wrongType(String type, Object value) {
  throw ArgumentError('Expected $type, but was ${value.runtimeType}.');
}
```

Você pode usá-la assim:

```dart
// Using null safety:
class Point {
  final int x, y;

  Point(this.x, this.y);

  Point operator +(Object other) {
    if (other is int) return Point(x + other, y + other);
    if (other is! Point) wrongType('int | Point', other);

    print('Adding two Point instances together: $this + $other');
    return Point(x + other.x, y + other.y);
  }

  // toString, hashCode, and other implementations...
}
```

Este programa analisa sem erro. Note que a última linha do método `+`
acessa `.x` e `.y` em `other`. Ele foi promovido para `Point` mesmo
que a função não tenha nenhum `return` ou `throw`. A análise de fluxo de controle
sabe que o tipo declarado de `wrongType()` é `Never` o que significa
o ramo then da declaração `if` *deve* abortar de alguma forma. Como a declaração
final só pode ser alcançada quando `other` é um `Point`, o Dart o promove.

Em outras palavras, usar `Never` em suas próprias APIs permite que você estenda a
análise de acessibilidade do Dart.

### Definite assignment analysis

Mencionei isso brevemente com variáveis locais. O Dart precisa garantir que uma
variável local non-nullable seja sempre inicializada antes de ser lida. Usamos
*definite assignment analysis* para ser o mais flexível possível sobre isso. A
linguagem analisa cada corpo de função e rastreia as atribuições a variáveis
locais e parâmetros através de todos os caminhos de fluxo de controle. Desde que a variável
seja atribuída em cada caminho que alcança algum uso de uma variável, a variável é
considerada inicializada. Isso permite que você declare uma variável sem inicializador e
então a inicialize depois usando fluxo de controle complexo, mesmo quando a variável
tem um non-nullable type.

Também usamos definite assignment analysis para tornar variáveis *final* mais
flexíveis. Antes de null safety, pode ser difícil usar `final` para variáveis
locais se você precisa inicializá-las de qualquer forma interessante:

```dart
// Using null safety:
int tracingFibonacci(int n) {
  final int result;
  if (n < 2) {
    result = n;
  } else {
    result = tracingFibonacci(n - 2) + tracingFibonacci(n - 1);
  }

  print(result);
  return result;
}
```

Isso seria um erro já que a variável `result` é `final` mas não tem
inicializador. Com a análise de fluxo mais inteligente com null safety, este programa está
bem. A análise pode dizer que `result` é definitivamente inicializado exatamente uma vez
em cada caminho de fluxo de controle, então as restrições para marcar uma variável `final`
são satisfeitas.

### Type promotion on null checks

A análise de fluxo mais inteligente ajuda muito código Dart, mesmo código não relacionado a
nullability. Mas não é uma coincidência que estamos fazendo essas mudanças agora. Nós
particionamos tipos em conjuntos nullable e non-nullable. Se você tem um valor
de um nullable type, você não pode realmente *fazer* nada útil com ele. Em casos
onde o valor *é* `null`, essa restrição é boa. Está prevenindo você de
travar.

Mas se o valor não é `null`, seria bom poder movê-lo para
o lado non-nullable para que você possa chamar métodos nele. Análise de fluxo é uma das
formas principais de fazer isso para variáveis locais e parâmetros
(e campos privados final, a partir do Dart 3.2). Estendemos type
promotion para também olhar para expressões `== null` e `!= null`.

Se você verifica uma variável local com nullable type para ver se ela não é `null`,
o Dart então promove a variável para o non-nullable type subjacente:

```dart
// Using null safety:
String makeCommand(String executable, [List<String>? arguments]) {
  var result = executable;
  if (arguments != null) {
    result += ' ' + arguments.join(' ');
  }
  return result;
}
```

Aqui, `arguments` tem um nullable type. Normalmente, isso proíbe você de chamar
`.join()` nele. Mas porque protegemos essa chamada em uma declaração `if` que
verifica para garantir que o valor não é `null`, o Dart o promove de `List<String>?`
para `List<String>` e permite que você chame métodos nele ou passe para funções que
esperam listas non-nullable.

Isso parece uma coisa relativamente menor, mas esta promoção baseada em fluxo em verificações de null
é o que faz a maior parte do código Dart existente funcionar com null safety. A maioria do código Dart
*é* dinamicamente correto e evita lançar erros de referência nula
verificando por `null` antes de chamar métodos. A nova análise de fluxo em verificações de null
transforma essa correção *dinâmica* em correção *estática* comprovável.

Também, é claro, funciona com a análise mais inteligente que fazemos para acessibilidade. A
função acima pode ser escrita igualmente bem como:

```dart
// Using null safety:
String makeCommand(String executable, [List<String>? arguments]) {
  var result = executable;
  if (arguments == null) return result;
  return result + ' ' + arguments.join(' ');
}
```

A linguagem também é mais inteligente sobre que tipos de expressões causam promoção. Um
`== null` ou `!= null` explícito é claro que funciona. Mas casts explícitos usando `as`,
ou atribuições, ou o operador postfix `!`
(que cobriremos [mais tarde](#not-null-assertion-operator)) também causam
promoção. O objetivo geral é que se o código é dinamicamente correto e é
razoável descobrir isso estaticamente, a análise deve ser inteligente o suficiente
para fazê-lo.

Note que type promotion originalmente só funcionava em variáveis locais,
e agora também funciona em campos privados final a partir do Dart 3.2.
Para mais informações sobre trabalhar com variáveis não-locais,
veja [Trabalhando com campos nullable](#working-with-nullable-fields).

### Unnecessary code warnings

Ter análise de acessibilidade mais inteligente e saber onde `null` pode fluir através
do seu programa ajuda a garantir que você *adicione* código para lidar com `null`. Mas também podemos
usar a mesma análise para detectar código que você *não* precisa. Antes de null safety,
se você escreveu algo como:

```dart
// Using null safety:
String checkList(List<Object> list) {
  if (list?.isEmpty ?? false) {
    return 'Got nothing';
  }
  return 'Got something';
}
```

O Dart não tinha como saber se aquele operador null-aware `?.` é útil ou não.
Pelo que ele sabe, você poderia passar `null` para a função. Mas em Dart null-safe,
se você anotou essa função com o tipo `List` agora non-nullable, então
ele sabe que `list` nunca será `null`. Isso implica que o `?.` nunca fará
nada útil e você pode e deve usar apenas `.`.

Para ajudá-lo a simplificar seu código, adicionamos avisos para código desnecessário como
este agora que a análise estática é precisa o suficiente para detectá-lo. Usar um
operador null-aware ou mesmo uma verificação como `== null` ou `!= null` em um
non-nullable type é relatado como um aviso.

E, claro, isso funciona com promoção de non-nullable type também. Uma vez que uma
variável foi promovida para um non-nullable type, você recebe um aviso se você
redundantemente verificá-la novamente por `null`:

```dart
// Using null safety:
String checkList(List<Object>? list) {
  if (list == null) return 'No list';
  if (list?.isEmpty ?? false) {
    return 'Empty list';
  }
  return 'Got something';
}
```

Você recebe um aviso no `?.` aqui porque no ponto em que ele executa, já
sabemos que `list` não pode ser `null`. O objetivo com esses avisos não é apenas
limpar código inútil. Ao remover verificações *desnecessárias* por `null`, garantimos
que as verificações significativas restantes se destaquem. Queremos que você seja capaz de olhar
para seu código e *ver* onde `null` pode fluir.

## Working with nullable types

Agora acorralamos `null` no conjunto de nullable types. Com análise de fluxo,
podemos seguramente deixar alguns valores não-`null` pular a cerca para o lado
non-nullable onde podemos usá-los. Isso é um grande passo, mas se pararmos aqui, o
sistema resultante ainda é dolorosamente restritivo. Análise de fluxo só ajuda com
locais, parâmetros e campos privados final.

Para tentar recuperar tanto da flexibilidade que o Dart tinha antes de null
safety—e ir além disso em alguns lugares—temos um punhado de outros
novos recursos.

### Smarter null-aware methods

O operador null aware `?.` do Dart é muito mais antigo que null safety. A semântica
em tempo de execução afirma que se o receptor for `null` então o acesso à propriedade no
lado direito é pulado e a expressão avalia para `null`:

```dart
// Without null safety:
String notAString = null;
print(notAString?.length);
```

Em vez de lançar uma exceção, isso imprime "null". O operador null-aware é
uma ferramenta útil para tornar nullable types utilizáveis em Dart. Embora não possamos deixar você
chamar métodos em nullable types, podemos e deixamos você usar operadores null-aware
neles. A versão pós-null safety do programa é:

```dart
// Using null safety:
String? notAString = null;
print(notAString?.length);
```

Funciona igual ao anterior.

No entanto, se você já usou operadores null-aware em Dart, provavelmente
encontrou um aborrecimento ao usá-los em cadeias de métodos. Digamos que você queira
ver se o comprimento de uma string potencialmente ausente é um número par (não um
problema particularmente realista, eu sei, mas trabalhe comigo aqui):

```dart
// Using null safety:
String? notAString = null;
print(notAString?.length.isEven);
```

Mesmo que este programa use `?.`, ele ainda lança uma exceção em tempo de execução. O
problema é que o receptor da expressão `.isEven` é o resultado de
toda a expressão `notAString?.length` à sua esquerda. Essa expressão avalia para
`null`, então obtemos um erro de referência nula tentando chamar `.isEven`. Se você já
usou `?.` em Dart, provavelmente aprendeu da maneira difícil que você tem que aplicar
o operador null-aware a *toda* propriedade ou método em uma cadeia depois de usá-lo
uma vez:

```dart
String? notAString = null;
print(notAString?.length?.isEven);
```

Isso é irritante, mas, pior, obscurece informações importantes. Considere:

```dart
// Using null safety:
showGizmo(Thing? thing) {
  print(thing?.doohickey?.gizmo);
}
```

Aqui está uma pergunta para você: O getter `doohickey` em `Thing` pode retornar `null`?
Parece que *poderia* porque você está usando `?.` no resultado. Mas pode
ser apenas que o segundo `?.` está lá apenas para lidar com casos onde `thing` é
`null`, não o resultado de `doohickey`. Você não pode dizer.

Para abordar isso, pegamos uma ideia inteligente do design do C# do mesmo recurso.
Quando você usa um operador null-aware em uma cadeia de métodos, se o receptor avalia
para `null`, então *o restante inteiro da cadeia de métodos é curto-circuitado e
pulado*. Isso significa que se `doohickey` tem um non-nullable return type, então você
pode e deve escrever:

```dart
// Using null safety:
void showGizmo(Thing? thing) {
  print(thing?.doohickey.gizmo);
}
```

Na verdade, você receberá um aviso de código desnecessário no segundo `?.` se
não fizer isso. Se você vir código como:

```dart
// Using null safety:
void showGizmo(Thing? thing) {
  print(thing?.doohickey?.gizmo);
}
```

Então você sabe com certeza que isso significa que `doohickey` em si tem um nullable return
type. Cada `?.` corresponde a um caminho *único* que pode causar `null` fluir
para a cadeia de métodos. Isso torna operadores null-aware em cadeias de métodos tanto
mais tersas quanto mais precisas.

Enquanto estávamos nisso, adicionamos alguns outros operadores null-aware:

```dart
// Using null safety:

// Null-aware cascade:
receiver?..method();

// Null-aware index operator:
receiver?[index];
```

Não há um operador de chamada de função null-aware, mas você pode escrever:

```dart
// Allowed with or without null safety:
function?.call(arg1, arg2);
```

<a id="null-assertion-operator" aria-hidden="true"></a>
<a id="non-null-assertion-operator" aria-hidden="true"></a>

### Not-null assertion operator

A grande coisa sobre usar análise de fluxo para mover uma variável nullable para o
lado non-nullable do mundo é que fazer isso é comprovadamente seguro. Você consegue
chamar métodos na variável anteriormente-nullable sem desistir de nada da
segurança ou desempenho de non-nullable types.

Mas muitos usos válidos de nullable types não podem ser *provados* serem seguros de uma forma que
agrade a análise estática. Por exemplo:

```dart
// Using null safety, incorrectly:
class HttpResponse {
  final int code;
  final String? error;

  HttpResponse.ok()
      : code = 200,
        error = null;
  HttpResponse.notFound()
      : code = 404,
        error = 'Not found';

  @override
  String toString() {
    if (code == 200) return 'OK';
    return 'ERROR $code ${error.toUpperCase()}';
  }
}
```

Se você tentar executar isso, você obtém um erro de compilação na chamada para `toUpperCase()`.
O campo `error` é nullable porque não terá um valor em uma
resposta bem-sucedida. Podemos ver inspecionando a classe que nunca acessamos a mensagem `error`
quando ela é `null`. Mas isso requer entender a relação
entre o valor de `code` e a nullability de `error`. O type checker
não pode ver essa conexão.

Em outras palavras, nós mantenedores humanos do código *sabemos* que error não será
`null` no ponto em que o usamos e precisamos de uma maneira de afirmar isso. Normalmente,
você afirma tipos usando um cast `as`, e você pode fazer a mesma coisa aqui:

```dart
// Using null safety:
String toString() {
  if (code == 200) return 'OK';
  return 'ERROR $code ${(error as String).toUpperCase()}';
}
```

Fazer cast de `error` para o tipo `String` non-nullable lançará uma exceção em tempo de execução
se o cast falhar. Caso contrário, nos dá uma string non-nullable que podemos então
chamar métodos.

"Fazer cast da nullability" surge com frequência suficiente que temos uma nova sintaxe
abreviada. Um ponto de exclamação postfix (`!`) pega a expressão à esquerda e
faz cast para seu tipo non-nullable subjacente. Então a função acima é
equivalente a:

```dart
// Using null safety:
String toString() {
  if (code == 200) return 'OK';
  return 'ERROR $code ${error!.toUpperCase()}';
}
```

Este operador "bang" de um caractere é particularmente útil quando o tipo
subjacente é verboso. Seria realmente irritante ter que escrever `as
Map<TransactionProviderFactory, List<Set<ResponseFilter>>>` apenas para fazer cast de um
único `?` de algum tipo.

É claro, como qualquer cast, usar `!` vem com uma perda de segurança estática. O cast
deve ser verificado em tempo de execução para preservar soundness e pode falhar e lançar uma
exceção. Mas você tem controle sobre onde esses casts são inseridos, e você pode
sempre vê-los olhando através do seu código.

### Late variables

O lugar mais comum onde o type checker não pode provar a segurança do código é
em torno de variáveis e campos de nível superior. Aqui está um exemplo:

```dart
// Using null safety, incorrectly:
class Coffee {
  String _temperature;

  void heat() { _temperature = 'hot'; }
  void chill() { _temperature = 'iced'; }

  String serve() => _temperature + ' coffee';
}

void main() {
  var coffee = Coffee();
  coffee.heat();
  coffee.serve();
}
```

Aqui, o método `heat()` é chamado antes de `serve()`. Isso significa que `_temperature`
será inicializado para um valor não-null antes de ser usado. Mas não é viável
para uma análise estática determinar isso. (Pode ser possível para um exemplo
trivial como este, mas o caso geral de tentar rastrear o estado de cada
instância de uma classe é intratável.)

Como o type checker não pode analisar usos de campos e variáveis de nível superior,
ele tem uma regra conservadora de que campos non-nullable têm que ser inicializados
ou em sua declaração (ou na lista de inicialização do construtor para
campos de instância). Então o Dart relata um erro de compilação nesta classe.

Você pode corrigir o erro tornando o campo nullable e então
usando operadores not-null assertion nos usos:

```dart
// Using null safety:
class Coffee {
  String? _temperature;

  void heat() { _temperature = 'hot'; }
  void chill() { _temperature = 'iced'; }

  String serve() => _temperature! + ' coffee';
}
```

Isso funciona bem. Mas envia um sinal confuso ao mantenedor da classe.
Ao marcar `_temperature` nullable, você implica que `null` é um valor útil,
significativo para aquele campo. Mas não é a intenção. O campo `_temperature`
nunca deve ser *observado* em seu estado `null`.

Para lidar com o padrão comum de estado com inicialização atrasada, adicionamos um
novo modificador, `late`. Você pode usá-lo assim:

```dart
// Using null safety:
class Coffee {
  late String _temperature;

  void heat() { _temperature = 'hot'; }
  void chill() { _temperature = 'iced'; }

  String serve() => _temperature + ' coffee';
}
```

Note que o campo `_temperature` tem um non-nullable type,
mas não é inicializado.
Além disso, não há not-null assertion explícita quando é usado.
Há alguns modelos que você pode aplicar à semântica de `late`,
mas eu penso assim: O modificador `late` significa
"impor as restrições desta variável em tempo de execução em vez de em tempo de compilação".
É quase como a palavra "late" descreve *quando*
ele impõe as garantias da variável.

Neste caso, já que o campo não é definitivamente inicializado, toda vez que o
campo é lido, uma verificação em tempo de execução é inserida para ter certeza de que foi atribuído um
valor. Se não foi, uma exceção é lançada. Dar à variável o tipo
`String` significa "você nunca deve me ver com um valor diferente de uma string" e
o modificador `late` significa "verificar isso em tempo de execução".

De algumas maneiras, o modificador `late` é mais "mágico" do que usar `?` porque qualquer
uso do campo pode falhar, e não há nada textualmente visível no
local de uso. Mas você *precisa* escrever `late` na declaração para obter esse
comportamento, e nossa crença é que ver o modificador lá é explícito o suficiente
para que isso seja sustentável.

Em troca, você obtém melhor segurança estática do que usar um nullable type. Porque o
tipo do campo é non-nullable agora, é um erro de *compilação* tentar atribuir
`null` ou uma `String` nullable ao campo. O modificador `late` permite que você *adie*
a inicialização, mas ainda proíbe você de tratá-lo como uma variável
nullable.

### Lazy initialization

O modificador `late` tem alguns outros super poderes também. Pode parecer paradoxal,
mas você pode usar `late` em um campo que tem um inicializador:

```dart
// Using null safety:
class Weather {
  late int _temperature = _readThermometer();
}
```

Quando você faz isso, o inicializador se torna *lazy*. Em vez de executá-lo assim que
a instância é construída, ele é adiado e executado preguiçosamente na primeira vez que o
campo é acessado. Em outras palavras, funciona exatamente como um inicializador em uma
variável de nível superior ou campo estático. Isso pode ser útil quando a expressão de
inicialização é custosa e pode não ser necessária.

Executar o inicializador preguiçosamente te dá um bônus extra quando você usa `late` em
um campo de instância. Normalmente, inicializadores de campos de instância não podem acessar `this`
porque você não tem acesso ao novo objeto até que todos os inicializadores de campo tenham
completado. Mas com um campo `late`, isso não é mais verdade, então você *pode*
acessar `this`, chamar métodos, ou acessar campos na instância.

### Late final variables

Você também pode combinar `late` com `final`:

```dart
// Using null safety:
class Coffee {
  late final String _temperature;

  void heat() { _temperature = 'hot'; }
  void chill() { _temperature = 'iced'; }

  String serve() => _temperature + ' coffee';
}
```

Ao contrário de campos `final` normais, você não precisa inicializar o campo em sua
declaração ou na lista de inicialização do construtor. Você pode atribuir a ele
depois em tempo de execução. Mas você só pode atribuir a ele *uma vez*, e esse fato é verificado
em tempo de execução. Se você tentar atribuir a ele mais de uma vez—como chamar tanto
`heat()` quanto `chill()` aqui—a segunda atribuição lança uma exceção.
Esta é uma ótima maneira de modelar estado que é inicializado eventualmente e é
imutável depois.

Em outras palavras, o novo modificador `late` em combinação com os outros
modificadores de variável do Dart cobre a maior parte do espaço de recursos de `lateinit` em Kotlin e
`lazy` em Swift. Você pode até usá-lo em variáveis locais se quiser um pouco de
avaliação preguiçosa local.

### Required named parameters

Para garantir que você nunca veja um parâmetro `null` com um non-nullable type, o
type checker exige que todos os parâmetros opcionais tenham um nullable type ou
um valor padrão. E se você quiser ter um parâmetro nomeado com um non-nullable
type e sem valor padrão? Isso implicaria que você quer exigir que o chamador
*sempre* passe-o. Em outras palavras, você quer um parâmetro que é *nomeado*
mas não opcional.

Eu visualizo os vários tipos de parâmetros Dart com esta tabela:

```plaintext
             mandatory    optional
            +------------+------------+
positional  | f(int x)   | f([int x]) |
            +------------+------------+
named       | ???        | f({int x}) |
            +------------+------------+
```

Por razões pouco claras, o Dart há muito tempo suporta três cantos desta tabela mas
deixou a combinação de nomeado+obrigatório vazia. Com null safety, preenchemos isso.
Você declara um parâmetro nomeado obrigatório colocando `required` antes do
parâmetro:

```dart
// Using null safety:
function({int? a, required int? b, int? c, required int? d}) {}
```

Aqui, todos os parâmetros devem ser passados por nome. Os parâmetros `a` e `c` são
opcionais e podem ser omitidos. Os parâmetros `b` e `d` são obrigatórios e devem
ser passados. Note que obrigatoriedade é independente de nullability. Você pode ter
parâmetros nomeados obrigatórios de nullable types, e parâmetros nomeados opcionais de
non-nullable types (se eles tiverem um valor padrão).

Este é outro daqueles recursos que acho que torna o Dart melhor independentemente
de null safety. Simplesmente faz a linguagem parecer mais completa para mim.

### Abstract fields

Um dos recursos legais do Dart é que
ele mantém uma coisa chamada [princípio de acesso uniforme][uniform access principle].
Em termos humanos isso significa que
campos são indistinguíveis de getters e setters.
É um detalhe de implementação se uma "propriedade" em alguma classe Dart
é computada ou armazenada.
Por causa disso,
ao definir uma interface usando uma classe abstrata,
é típico usar uma declaração de campo:

[uniform access principle]: https://en.wikipedia.org/wiki/Uniform_access_principle

```dart
abstract class Cup {
  Beverage contents;
}
```

A intenção é que os usuários apenas implementem essa classe e não a estendam.
A sintaxe de campo é simplesmente uma forma mais curta de escrever um par getter/setter:

```dart
abstract class Cup {
  Beverage get contents;
  set contents(Beverage);
}
```

Mas o Dart não *sabe* que esta classe nunca será usada como um tipo concreto.
Ele vê aquela declaração `contents` como um campo real.
E, infelizmente, aquele campo é non-nullable e não tem inicializador,
então você obtém um erro de compilação.

Uma correção é usar declarações explícitas de getter/setter abstratos
como no segundo exemplo.
Mas isso é um pouco verboso,
então com null safety
também adicionamos suporte para declarações de campo abstrato explícitas:

```dart
abstract class Cup {
  abstract Beverage contents;
}
```

Isso se comporta exatamente como o segundo exemplo.
Simplesmente declara um getter e setter abstratos com o nome e tipo dados.

### Working with nullable fields

Esses novos recursos cobrem muitos padrões comuns e tornam trabalhar com `null`
bastante indolor na maioria das vezes. Mas mesmo assim, nossa experiência é que campos nullable
ainda podem ser difíceis. Em casos onde você pode tornar o campo `late` e
non-nullable, você está bem. Mas em muitos casos você precisa *verificar* para ver se o
campo tem um valor, e isso requer torná-lo nullable para que você possa observar o
`null`.

Campos nullable que são tanto privados quanto final podem ser promovidos em tipo
(excluindo [algumas razões particulares](/tools/non-promotion-reasons)).
Se você não pode tornar um campo privado e final
por qualquer razão, você ainda precisará de uma solução alternativa.

Por exemplo, você pode esperar que isso funcione:

```dart
// Using null safety, incorrectly:
class Coffee {
  String? _temperature;

  void heat() { _temperature = 'hot'; }
  void chill() { _temperature = 'iced'; }

  void checkTemp() {
    if (_temperature != null) {
      print('Ready to serve ' + _temperature + '!');
    }
  }

  String serve() => _temperature! + ' coffee';
}
```

Dentro de `checkTemp()`, verificamos para ver se `_temperature` é `null`. Se não for, nós
acessamos e acabamos chamando `+` nele. Infelizmente, isso não é permitido.

Type promotion baseada em fluxo só pode aplicar a campos que são *tanto privados quanto final*.
Caso contrário, a análise estática não pode *provar* que o valor do campo não
muda entre o ponto em que você verifica por `null` e o ponto em que você o usa.
(Considere que em casos patológicos, o campo em si poderia ser sobrescrito por um
getter em uma subclasse que retorna `null` na segunda vez que é chamado.)

Então, já que nos preocupamos com soundness, campos públicos e/ou não-final não promovem,
e o método acima não compila. Isso é irritante.
Em casos simples como aqui, sua melhor aposta é dar um `!` no uso do campo.
Parece redundante, mas isso é mais ou menos como o Dart se comporta hoje.

Outro padrão que ajuda é copiar o campo para uma variável local primeiro e
então usar essa em vez disso:

```dart
// Using null safety:
void checkTemp() {
  var temperature = _temperature;
  if (temperature != null) {
    print('Ready to serve ' + temperature + '!');
  }
}
```

Como type promotion se aplica a locais, isso agora funciona bem. Se você precisa
*mudar* o valor, apenas lembre-se de armazenar de volta no campo e não apenas no
local.

Para mais informações sobre lidar com essas e outras questões de type promotion,
veja [Corrigindo falhas de type promotion](/tools/non-promotion-reasons).

### Nullability and generics

Como a maioria das linguagens estaticamente tipadas modernas, o Dart tem classes genéricas e
métodos genéricos. Eles interagem com nullability de algumas maneiras que parecem
contra-intuitivas mas fazem sentido uma vez que você pensa nas implicações. Primeiro
é que "este tipo é nullable?" não é mais uma simples pergunta sim ou não.
Considere:

```dart
// Using null safety:
class Box<T> {
  final T object;
  Box(this.object);
}

void main() {
  Box<String>('a string');
  Box<int?>(null);
}
```

Na definição de `Box`, `T` é um nullable type ou um non-nullable type? Como
você pode ver, pode ser instanciado com qualquer tipo. A resposta é que `T` é um
*potentially nullable type*. Dentro do corpo de uma classe ou método genérico, um
potentially nullable type tem todas as restrições tanto de nullable types
*quanto* de non-nullable types.

O primeiro significa que você não pode chamar nenhum método nele exceto o punhado definido em
Object. O último significa que você deve inicializar quaisquer campos ou variáveis
desse tipo antes de serem usados. Isso pode tornar parâmetros de tipo bem difíceis de trabalhar.

Na prática, alguns padrões aparecem. Em classes parecidas com coleções onde o parâmetro
de tipo pode ser instanciado com qualquer tipo, você apenas tem que lidar com
as restrições. Na maioria dos casos, como o exemplo aqui, isso significa garantir que você tenha
acesso a um valor do tipo do argumento de tipo sempre que você precisar trabalhar
com um. Felizmente, classes parecidas com coleções raramente chamam métodos em seus
elementos.

Em lugares onde você não tem acesso a um valor, você pode tornar o uso do
parâmetro de tipo nullable:

```dart
// Using null safety:
class Box<T> {
  T? object;
  Box.empty();
  Box.full(this.object);
}
```

Note o `?` na declaração de `object`. Agora o campo tem um
tipo explicitamente nullable, então está tudo bem deixá-lo sem inicializar.

Quando você torna um parâmetro de tipo nullable como `T?` aqui, você pode precisar
fazer cast da nullability. A maneira correta de fazer isso é usando um cast `as
T` explícito, *não* o operador `!`:

```dart
// Using null safety:
class Box<T> {
  T? object;
  Box.empty();
  Box.full(this.object);

  T unbox() => object as T;
}
```

O operador `!` *sempre* lança se o valor for `null`. Mas se o parâmetro
de tipo foi instanciado com um nullable type, então `null` é um valor perfeitamente
válido para `T`:

```dart
// Using null safety:
void main() {
  var box = Box<int?>.full(null);
  print(box.unbox());
}
```

Este programa deve executar sem erro. Usar `as T` consegue isso. Usar
`!` lançaria uma exceção.

Outros tipos genéricos têm algum limite que restringe os tipos de argumentos de tipo
que podem ser aplicados:

```dart
// Using null safety:
class Interval<T extends num> {
  T min, max;

  Interval(this.min, this.max);

  bool get isEmpty => max <= min;
}
```

Se o limite é non-nullable, então o parâmetro de tipo também é non-nullable. Isso
significa que você tem as restrições de non-nullable types—você não pode deixar
campos e variáveis sem inicializar. A classe de exemplo aqui deve ter um
construtor que inicializa os campos.

Em troca por essa restrição, você pode chamar quaisquer métodos em valores do tipo
parâmetro de tipo que são declarados em seu limite. Ter um limite non-nullable, no
entanto, impede *usuários* de sua classe genérica de instanciá-la com um
argumento de tipo nullable. Essa é provavelmente uma limitação razoável para a maioria
das classes.

Você também pode usar um *limite* nullable:

```dart
// Using null safety:
class Interval<T extends num?> {
  T min, max;

  Interval(this.min, this.max);

  bool get isEmpty {
    var localMin = min;
    var localMax = max;

    // No min or max means an open-ended interval.
    if (localMin == null || localMax == null) return false;
    return localMax <= localMin;
  }
}
```

Isso significa que no corpo da classe você obtém a flexibilidade de tratar o
parâmetro de tipo como nullable, mas você também tem as limitações de nullability.
Você não pode chamar nada em uma variável desse tipo
a menos que você lide com a nullability primeiro. No exemplo aqui,
copiamos os campos em variáveis locais e verificamos essas locais por `null`
para que a análise de fluxo as promova para non-nullable types antes de usarmos `<=`.

Note que um limite nullable não impede usuários de instanciar a classe
com non-nullable types. Um limite nullable significa que o argumento de tipo *pode* ser
nullable, não que ele *deve*. (Na verdade, o limite padrão em parâmetros de tipo se
você não escreve uma cláusula `extends` é o limite nullable `Object?`.) Não há
maneira de *exigir* um argumento de tipo nullable. Se você quer que usos do parâmetro
de tipo sejam confiavelmente nullable e sejam implicitamente inicializados para `null`,
você pode usar `T?` dentro do corpo da classe.

## Core library changes

Há algumas outras pequenas mudanças aqui e ali na linguagem, mas elas são
menores. Coisas como o tipo padrão de um `catch` sem cláusula `on` agora é
`Object` em vez de `dynamic`. Análise de fallthrough em declarações switch usa
a nova análise de fluxo.

As mudanças restantes que realmente importam para você estão nas bibliotecas principais.
Antes de embarcarmos na Grande Aventura de Null Safety, nos preocupávamos que acabaria
não havendo maneira de tornar nossas bibliotecas principais null safe sem massivamente
quebrar o mundo. Acabou não sendo tão terrível. Há *algumas* mudanças significativas,
mas na maior parte, a migração foi suave. A maioria das bibliotecas principais
ou não aceitava `null` e naturalmente passam para non-nullable types, ou aceitam e
graciosamente aceitam com um nullable type.

Há alguns cantos importantes, no entanto:

### The Map index operator is nullable

Isso não é realmente uma mudança, mas mais uma coisa para saber. O operador de índice `[]` na
classe Map retorna `null` se a chave não está presente. Isso implica que o
tipo de retorno desse operador deve ser nullable: `V?` em vez de `V`.

Poderíamos ter mudado esse método para lançar uma exceção quando a chave não está
presente e então dado a ele um tipo de retorno non-nullable mais fácil de usar. Mas código
que usa o operador de índice e verifica por `null` para ver se a chave está ausente
é muito comum, cerca de metade de todos os usos baseados em nossa análise. Quebrar todo esse
código teria incendiado o ecossistema Dart.

Em vez disso, o comportamento em tempo de execução é o mesmo e, portanto, o tipo de retorno é obrigado
a ser nullable. Isso significa que você geralmente não pode usar imediatamente o resultado de
uma busca em map:

```dart
// Using null safety, incorrectly:
var map = {'key': 'value'};
print(map['key'].length); // Error.
```

Isso te dá um erro de compilação na tentativa de chamar `.length` em uma
string nullable. Em casos onde você *sabe* que a chave está presente você pode ensinar o type
checker usando `!`:

```dart
// Using null safety:
var map = {'key': 'value'};
print(map['key']!.length); // OK.
```

Consideramos adicionar outro método ao Map que faria isso para você: buscar a
chave, lançar se não encontrada, ou retornar um valor non-nullable caso contrário. Mas como
chamá-lo? Nenhum nome seria mais curto que o `!` de um único caractere, e nenhum
nome de método seria mais claro do que ver um `!` com sua semântica embutida bem
ali no local da chamada. Então a maneira idiomática de acessar um elemento conhecido-presente
em um map é usar `[]!`. Você se acostuma.

### No unnamed List constructor

O construtor sem nome em `List` cria uma nova lista com o tamanho dado mas
não inicializa nenhum dos elementos. Isso abriria um buraco muito grande nas
garantias de soundness se você criasse uma lista de um non-nullable type e então
acessasse um elemento.

Para evitar isso, removemos o construtor completamente. É um erro chamar
`List()` em código null-safe, mesmo com um nullable type. Isso parece assustador, mas
na prática a maioria do código cria listas usando literais de lista, `List.filled()`,
`List.generate()`, ou como resultado de transformar alguma outra coleção. Para
o caso extremo onde você quer criar uma lista vazia de algum tipo, adicionamos um
novo construtor `List.empty()`.

O padrão de criar uma lista completamente não inicializada sempre pareceu fora de
lugar no Dart, e agora é ainda mais. Se você tem código quebrado por isso,
você sempre pode corrigi-lo usando uma das muitas outras maneiras de produzir uma lista.

### Cannot set a larger length on non-nullable lists

Isso é pouco conhecido, mas o getter `length` em `List` também tem um
*setter* correspondente. Você pode definir o length para um valor menor para truncar a lista. E
você também pode defini-lo para um length *maior* para preencher a lista com elementos
não inicializados.

Se você fizesse isso com uma lista de um non-nullable type, você violaria
soundness quando depois acessasse esses elementos não escritos. Para prevenir isso, o
setter `length` lançará uma exceção em tempo de execução se (e somente se) a lista tem um
elemento non-nullable type *e* você defini-lo para um length *maior*. Ainda está
bem truncar listas de todos os tipos, e você pode aumentar listas de nullable types.

Há uma consequência importante disso se você define seus próprios list types que
estendem `ListBase` ou aplicam `ListMixin`. Ambos esses tipos fornecem uma
implementação de `insert()` que anteriormente fazia espaço para o elemento inserido
definindo o length. Isso falharia com null safety, então em vez disso mudamos
a implementação de `insert()` em `ListMixin` (que `ListBase` compartilha) para
chamar `add()` em vez disso. Sua classe de lista personalizada deve fornecer uma definição de
`add()` se você quer ser capaz de usar esse método `insert()` herdado.

### Cannot access Iterator.current before or after iteration

A classe `Iterator` é a classe "cursor" mutável usada para percorrer os elementos
de um tipo que implementa `Iterable`. Você deve chamar `moveNext()`
antes de acessar quaisquer elementos para avançar para o primeiro elemento. Quando esse método
retorna `false`, você alcançou o fim e não há mais elementos.

Costumava ser que `current` retornava `null` se você o chamasse antes
de chamar `moveNext()` pela primeira vez ou depois que a iteração terminasse. Com null
safety, isso exigiria que o tipo de retorno de `current` fosse `E?` e não `E`.
Isso por sua vez significa que todo acesso a elemento exigiria uma verificação de `null` em tempo de execução.

Essas verificações seriam inúteis dado que quase ninguém nunca acessa o elemento
atual dessa maneira errônea. Em vez disso, tornamos o tipo de `current` ser
`E`. Como pode *não haver* um valor desse tipo disponível antes ou depois de
iterar, deixamos o comportamento do iterator indefinido se você chamá-lo quando você
não deveria. A maioria das implementações de `Iterator` lança um `StateError`.

## Summary

Essa é uma tour muito detalhada através de todas as mudanças de linguagem e biblioteca
em torno de null safety. É muita coisa, mas esta é uma mudança de linguagem bem grande.
Mais importante, queríamos chegar a um ponto onde o Dart ainda parecesse
coeso e utilizável. Isso requer mudar não apenas o sistema de tipos, mas um
número de outros recursos de usabilidade em torno dele. Não queríamos que parecesse como
se null safety tivesse sido aparafusado.

Os pontos principais a serem levados são:

*   Tipos são non-nullable por padrão e tornados nullable adicionando `?`.

*   Parâmetros opcionais devem ser nullable ou ter um valor padrão. Você pode usar
    `required` para tornar parâmetros nomeados não-opcionais. Variáveis de nível superior
    e campos estáticos non-nullable devem ter inicializadores. Campos de
    instância non-nullable devem ser inicializados antes do corpo do construtor começar.

*   Cadeias de métodos após operadores null-aware fazem curto-circuito se o receptor é
    `null`. Há novos operadores cascade null-aware (`?..`) e index (`?[]`).
    O operador postfix not-null assertion "bang" (`!`) faz cast de seu
    operando nullable para o non-nullable type subjacente.

*   Análise de fluxo permite que você transforme com segurança variáveis locais e parâmetros
    nullable (e campos privados final, a partir do Dart 3.2)
    em não-nullable utilizáveis. A nova análise de fluxo também tem regras mais inteligentes
    para type promotion, retornos faltantes, código inalcançável e
    inicialização de variável.

*   O modificador `late` permite que você use non-nullable types e `final` em lugares
    que você de outra forma não poderia, às custas de verificação em tempo de execução. Também
    te dá campos inicializados preguiçosamente.

*   A classe `List` foi mudada para prevenir elementos não inicializados.

Finalmente, uma vez que você absorva tudo isso e coloque seu código no mundo de null
safety, você obtém um programa seguro (sound) que os compiladores podem otimizar e onde todo
lugar onde um erro de tempo de execução pode ocorrer é visível em seu código. Esperamos que você sinta que vale
a pena o esforço para chegar lá.
