---
ia-translate: true
title: Entendendo a segurança nula
description: >-
    Um mergulho profundo na linguagem Dart e nas mudanças de biblioteca relacionadas à segurança nula.
---

_Escrito por Bob Nystrom<br>
Julho de 2020_

A segurança nula (null safety) é a maior mudança que fizemos no Dart desde que substituímos
o sistema de tipo opcional unsound original por [um sistema de tipo estático sound][strong]
no Dart 2.0. Quando o Dart foi lançado, a segurança nula em tempo de compilação era um recurso
raro que precisava de uma longa introdução. Hoje, Kotlin, Swift, Rust e outras
linguagens têm suas próprias respostas para o que se tornou um [problema muito familiar.][billion]
Aqui está um exemplo:

[strong]: /language/type-system
[billion]: https://www.infoq.com/presentations/Null-References-The-Billion-Dollar-Mistake-Tony-Hoare/

```dart
// Sem segurança nula:
bool isEmpty(String string) => string.length == 0;

void main() {
  isEmpty(null);
}
```

Se você executar este programa Dart sem segurança nula, ele lançará uma
exceção `NoSuchMethodError` na chamada para `.length`. O valor `null` é uma
instância da classe `Null`, e `Null` não tem um getter "length". Falhas em tempo
de execução são péssimas. Isso é especialmente verdade em uma linguagem como
Dart, que foi projetada para ser executada no dispositivo de um usuário final. Se
um aplicativo de servidor falhar, você pode frequentemente reiniciá-lo antes que
alguém perceba. Mas quando um aplicativo Flutter trava no celular de um usuário,
ele não fica feliz. Quando seus usuários não estão felizes, você não está feliz.

Desenvolvedores gostam de linguagens com tipagem estática como Dart porque elas
permitem que o verificador de tipo encontre erros no código em tempo de
compilação, geralmente diretamente no IDE. Quanto mais cedo você encontrar um
bug, mais cedo poderá corrigi-lo. Quando designers de linguagem falam em
"corrigir erros de referência nula", eles querem dizer enriquecer o verificador
de tipo estático para que a linguagem possa detectar erros como a tentativa acima
de chamar `.length` em um valor que pode ser `null`.

Não existe uma solução única para esse problema. Rust e Kotlin têm sua própria
abordagem que faz sentido no contexto dessas linguagens. Este documento aborda
todos os detalhes da nossa resposta para Dart. Ele inclui mudanças no sistema de
tipo estático e um conjunto de outras modificações e novos recursos da linguagem
para permitir que você não apenas escreva código null-safe, mas, com sorte,
*goste* de fazê-lo.

Este documento é longo. Se você quiser algo mais curto que cubra apenas o que você
precisa saber para começar, comece com a [visão geral][overview]. Quando você estiver pronto
para um entendimento mais profundo e tiver tempo, volte aqui para que você possa
entender *como* a linguagem lida com `null`, *por que* a projetamos dessa forma e
como escrever Dart idiomático, moderno e null-safe. (Alerta de spoiler: ele acaba
ficando surpreendentemente parecido com a forma como você escreve Dart hoje.)

[overview]: /null-safety

As várias maneiras como uma linguagem pode lidar com erros de referência nula
têm seus prós e contras. Estes princípios guiaram as escolhas que fizemos:

*   **O código deve ser seguro por padrão.** Se você escrever um novo código Dart e
    não usar nenhum recurso explicitamente inseguro, ele nunca lançará um erro de
    referência nula em tempo de execução. Todos os possíveis erros de referência
    nula são capturados estaticamente. Se você quiser adiar algumas dessas
    verificações para o tempo de execução para obter maior flexibilidade, você
    pode, mas você tem que escolher isso usando algum recurso que seja
    textualmente visível no código.

    Em outras palavras, não estamos dando a você um colete salva-vidas e
    deixando para você lembrar de colocá-lo toda vez que você sai na água. Em vez
    disso, estamos dando a você um barco que não afunda. Você permanece seco a
    menos que pule no mar.

*   **O código null-safe deve ser fácil de escrever.** A maioria dos códigos Dart
    existentes são dinamicamente corretos e não lançam erros de referência nula.
    Você gosta do seu programa Dart da forma como ele aparece agora, e queremos que
    você possa continuar escrevendo código dessa forma. Segurança não deve exigir
    sacrificar a usabilidade, pagar penitência ao verificador de tipo ou ter que
    mudar significativamente a forma como você pensa.

*   **O código null-safe resultante deve ser totalmente sound.** "Soundness"
    (solidez) no contexto da verificação estática significa coisas diferentes para
    pessoas diferentes. Para nós, no contexto da segurança nula, isso significa que
    se uma expressão tem um tipo estático que não permite `null`, então nenhuma
    execução possível dessa expressão pode ser avaliada como `null`. A linguagem
    fornece essa garantia principalmente através de verificações estáticas, mas
    pode haver algumas verificações em tempo de execução envolvidas também. (No
    entanto, observe o primeiro princípio: qualquer lugar onde essas verificações
    em tempo de execução aconteçam será sua escolha.)

    A solidez é importante para a confiança do usuário. Um barco que *quase
    sempre* permanece flutuando não é um que você esteja entusiasmado para se
    aventurar em mar aberto. Mas também é importante para nossos intrépidos
    hackers de compilador. Quando a linguagem oferece garantias difíceis sobre
    as propriedades semânticas de um programa, isso significa que o compilador
    pode executar otimizações que assumem que essas propriedades são verdadeiras.
    Quando se trata de `null`, isso significa que podemos gerar um código menor
    que elimina verificações `null` desnecessárias e um código mais rápido que
    não precisa verificar se um receptor é não-`null` antes de chamar métodos
    nele.

    Uma ressalva: Nós apenas garantimos a solidez em programas Dart que são
    totalmente null-safe. Dart oferece suporte a programas que contêm uma mistura
    de códigos null-safe mais novos e códigos legados mais antigos. Nesses
    programas de versão mista, erros de referência nula ainda podem ocorrer. Em
    um programa de versão mista, você obtém todos os benefícios de segurança
    *estática* nas partes que são null-safe, mas você não obtém solidez completa
    em tempo de execução até que o aplicativo inteiro seja null-safe.

Observe que *eliminar* `null` não é um objetivo. Não há nada de errado com
`null`. Pelo contrário, é muito útil ser capaz de representar a *ausência* de um
valor. Construir suporte para um valor especial "ausente" diretamente na
linguagem torna o trabalho com ausência flexível e utilizável. Ele sustenta
parâmetros opcionais, o prático operador null-aware `?.` e a inicialização
padrão. Não é o `null` que é ruim, é ter `null` indo *para onde você não
espera* que causa problemas.

Assim, com a segurança nula, nosso objetivo é dar a você *controle* e *insight*
sobre onde `null` pode fluir através do seu programa e certeza de que ele não
pode fluir para algum lugar que possa causar uma falha.

## Nullabilidade no sistema de tipos {:#nullability-in-the-type-system}

A segurança nula começa no sistema de tipo estático porque todo o resto se baseia
nisso. Seu programa Dart tem um universo inteiro de tipos nele: tipos primitivos
como `int` e `String`, tipos de coleção como `List`, e todas as classes e tipos
que você e os pacotes que você usa definem. Antes da segurança nula, o sistema de
tipo estático permitia que o valor `null` fluísse para expressões de qualquer um
desses tipos.

Na linguagem da teoria de tipos, o tipo `Null` era tratado como um subtipo de
todos os tipos:

<img src="/assets/img/null-safety/understanding-null-safety/hierarchy-before.png" alt="Hierarquia da Segurança Nula Antes" width="335">

O conjunto de operações — getters, setters, métodos e operadores — permitidos em
algumas expressões são definidos pelo seu tipo. Se o tipo é `List`, você pode
chamar `.add()` ou `[]` nele. Se for `int`, você pode chamar `+`. Mas o valor
`null` não define nenhum desses métodos. Permitir que `null` flua para uma
expressão de algum outro tipo significa que qualquer uma dessas operações pode
falhar. Essa é realmente a essência dos erros de referência nula — toda falha
vem de tentar procurar um método ou propriedade em `null` que ele não tem.

### Tipos não-anuláveis e anuláveis {:#non-nullable-and-nullable-types}

A segurança nula elimina esse problema pela raiz, alterando a hierarquia de
tipos. O tipo `Null` ainda existe, mas não é mais um subtipo de todos os tipos.
Em vez disso, a hierarquia de tipos é assim:

<img src="/assets/img/null-safety/understanding-null-safety/hierarchy-after.png" alt="Hierarquia da Segurança Nula Depois" width="344">

Como `Null` não é mais um subtipo, nenhum tipo, exceto a classe especial `Null`,
permite o valor `null`. Tornamos todos os tipos *não-anuláveis por padrão*. Se
você tem uma variável do tipo `String`, ela sempre conterá *uma string*. Pronto,
corrigimos todos os erros de referência nula.

Se não pensássemos que `null` fosse útil, poderíamos parar por aqui. Mas `null`
é útil, então ainda precisamos de uma maneira de lidar com ele. Parâmetros
opcionais são um bom caso ilustrativo. Considere este código Dart null-safe:

```dart
// Usando segurança nula:
void makeCoffee(String coffee, [String? dairy]) {
  if (dairy != null) {
    print('$coffee with $dairy');
  } else {
    print('Black $coffee');
  }
}
```

Aqui, queremos permitir que o parâmetro `dairy` aceite qualquer string, ou o
valor `null`, mas nada mais. Para expressar isso, damos a `dairy` um *tipo
anulável* colocando `?` no final do tipo base subjacente `String`. Por baixo
dos panos, isso está essencialmente definindo uma [união][union] do tipo subjacente e
do tipo `Null`. Então, `String?` seria uma abreviação para `String|Null` se Dart
tivesse tipos de união completos.

[union]: https://en.wikipedia.org/wiki/Union_type

### Usando tipos anuláveis {:#using-nullable-types}

Se você tem uma expressão com um tipo anulável, o que você pode fazer com o
resultado? Já que nosso princípio é seguro por padrão, a resposta é que não se
pode fazer muita coisa. Não podemos deixar você chamar métodos do tipo
subjacente nele porque eles podem falhar se o valor for `null`:

```dart
// Segurança nula hipotética unsound:
void bad(String? maybeString) {
  print(maybeString.length);
}

void main() {
  bad(null);
}
```

Isso travaria se deixássemos você executar. Os únicos métodos e propriedades que
podemos permitir que você acesse com segurança são aqueles definidos tanto pelo
tipo subjacente quanto pela classe `Null`. Isso é apenas `toString()`, `==` e
`hashCode`. Então, você pode usar tipos anuláveis como chaves de mapa,
armazená-los em conjuntos, compará-los com outros valores e usá-los em
interpolação de string, mas é só isso.

Como eles interagem com tipos não-anuláveis? É sempre seguro passar um tipo
*não*-anulável para algo que espera um tipo anulável. Se uma função aceita
`String?`, então passar um `String` é permitido porque não causará nenhum
problema. Modelamos isso tornando cada tipo anulável um supertipo de seu tipo
subjacente. Você também pode passar `null` com segurança para algo esperando um
tipo anulável, então `Null` também é um subtipo de cada tipo anulável:

<img src="/assets/img/null-safety/understanding-null-safety/nullable-hierarchy.png" alt="Anulável" width="235">

Mas ir na direção oposta e passar um tipo anulável para algo esperando o tipo
não-anulável subjacente é inseguro. Código que espera um `String` pode chamar
métodos `String` no valor. Se você passar um `String?` para ele, `null` poderia
fluir e isso poderia falhar:

```dart
// Segurança nula hipotética unsound:
void requireStringNotNull(String definitelyString) {
  print(definitelyString.length);
}

void main() {
  String? maybeString = null; // Ou não!
  requireStringNotNull(maybeString);
}
```

Este programa não é seguro e não devemos permiti-lo. No entanto, o Dart sempre
teve essa coisa chamada *downcasts implícitos*. Se você, por exemplo, passar um
valor do tipo `Object` para uma função esperando um `String`, o verificador de
tipos permite isso:

```dart
// Sem segurança nula:
void requireStringNotObject(String definitelyString) {
  print(definitelyString.length);
}

void main() {
  Object maybeString = 'it is';
  requireStringNotObject(maybeString);
}
```

Para manter a solidez, o compilador insere silenciosamente um cast `as String`
no argumento para `requireStringNotObject()`. Esse cast poderia falhar e lançar
uma exceção em tempo de execução, mas em tempo de compilação, Dart diz que isso
está OK. Já que os tipos não-anuláveis são modelados como subtipos de tipos
anuláveis, downcasts implícitos permitiriam que você passasse um `String?` para
algo esperando um `String`. Permitir isso violaria nosso objetivo de ser seguro
por padrão. Portanto, com a segurança nula, estamos removendo os downcasts
implícitos completamente.

Isso faz com que a chamada para `requireStringNotNull()` produza um erro de
compilação, que é o que você deseja. Mas isso também significa que *todos* os
downcasts implícitos se tornam erros de compilação, incluindo a chamada para
`requireStringNotObject()`. Você terá que adicionar o downcast explícito você
mesmo:

```dart
// Usando segurança nula:
void requireStringNotObject(String definitelyString) {
  print(definitelyString.length);
}

void main() {
  Object maybeString = 'it is';
  requireStringNotObject(maybeString as String);
}
```

Achamos que esta é uma boa mudança geral. Nossa impressão é que a maioria dos
usuários nunca gostou de downcasts implícitos. Em particular, você pode ter se
queimado com isso antes:

```dart
// Sem segurança nula:
List<int> filterEvens(List<int> ints) {
  return ints.where((n) => n.isEven);
}
```

Percebeu o bug? O método `.where()` é lazy, então ele retorna um `Iterable`,
não uma `List`. Este programa compila, mas lança uma exceção em tempo de
execução quando tenta fazer o cast desse `Iterable` para o tipo `List` que
`filterEvens` declara que retorna. Com a remoção de downcasts implícitos, isso
se torna um erro de compilação.

Onde estávamos? Certo, OK, então é como se tivéssemos pego o universo de tipos em
seu programa e dividido em duas metades:

<img src="/assets/img/null-safety/understanding-null-safety/bifurcate.png" alt="Tipos Anuláveis e Não-Anuláveis" width="668">

Existe uma região de tipos não-anuláveis. Esses tipos permitem que você acesse
todos os métodos interessantes, mas nunca podem conter `null`. E então existe
uma família paralela de todos os tipos anuláveis correspondentes. Esses permitem
`null`, mas você não pode fazer muito com eles. Deixamos os valores fluírem do
lado não-anulável para o lado anulável porque isso é seguro, mas não na outra
direção.

Parece que os tipos anuláveis são basicamente inúteis. Eles não têm métodos e
você não pode escapar deles. Não se preocupe, temos um conjunto inteiro de
recursos para ajudá-lo a mover valores da metade anulável para o outro lado que
veremos em breve.

### Top e bottom {:#top-and-bottom}

Esta seção é um pouco esotérica. Você pode pular a maior parte, exceto por dois
itens no final, a menos que você goste de coisas do sistema de tipo. Imagine
todos os tipos em seu programa com arestas entre aqueles que são subtipos e
super-tipos uns dos outros. Se você fosse desenhá-lo, como os diagramas neste
documento, ele formaria um enorme grafo direcionado com supertipos como `Object`
perto do topo e classes folha como seus próprios tipos perto da parte inferior.

Se esse grafo direcionado chegar a um ponto no topo onde há um único tipo que é
o supertipo (direta ou indiretamente), esse tipo é chamado de *tipo top*.
Da mesma forma, se houver um tipo estranho na parte inferior que é um subtipo de
cada tipo, você tem um *tipo bottom*. (Nesse caso, seu grafo direcionado é um
[lattice][lattice].)

[lattice]: https://en.wikipedia.org/wiki/Lattice_(order)

É conveniente se o seu sistema de tipos tiver um tipo top e bottom, porque isso
significa que operações no nível do tipo, como o menor limite superior (que a
inferência de tipo usa para descobrir o tipo de uma expressão condicional com
base nos tipos de seus dois ramos) sempre pode produzir um tipo. Antes da
segurança nula, `Object` era o tipo top do Dart e `Null` era seu tipo bottom.

Como `Object` não é anulável agora, ele não é mais um tipo top. `Null` não é
um subtipo dele. Dart não tem um tipo top *nomeado*. Se você precisa de um tipo
top, você quer `Object?`. Da mesma forma, `Null` não é mais o tipo bottom. Se
fosse, tudo ainda seria anulável. Em vez disso, adicionamos um novo tipo bottom
chamado `Never`:

<img src="/assets/img/null-safety/understanding-null-safety/top-and-bottom.png" alt="Top e Bottom" width="360">

Na prática, isso significa:

*   Se você quiser indicar que permite um valor de qualquer tipo, use `Object?`
    em vez de `Object`. De fato, torna-se bastante incomum usar `Object`, já que
    esse tipo significa "poderia ser qualquer valor possível, exceto este valor
    estranhamente proibido `null`".

*   Na rara ocasião em que você precisa de um tipo bottom, use `Never` em vez de
    `Null`.
    Isso é particularmente útil para indicar que uma função nunca retorna
    para [ajudar a análise de alcançabilidade](#never-for-unreachable-code).
    Se você não sabe se precisa de um tipo bottom, provavelmente não precisa.

## Garantindo a correção {:#ensuring-correctness}

Dividimos o universo de tipos em metades anuláveis e não-anuláveis. Para manter a
solidez e nosso princípio de que você nunca pode obter um erro de referência
nula em tempo de execução, a menos que você peça por isso, precisamos garantir
que `null` nunca apareça em nenhum tipo no lado não-anulável.

Livrar-se de downcasts implícitos e remover `Null` como um tipo bottom cobre
todos os principais lugares onde os tipos fluem através de um programa através
de atribuições e de argumentos para parâmetros em chamadas de função. Os
principais lugares restantes onde `null` pode se infiltrar são quando uma
variável surge pela primeira vez e quando você sai de uma função. Portanto,
existem alguns erros de compilação adicionais:

### Retornos inválidos {:#invalid-returns}

Se uma função tem um tipo de retorno não-anulável, então todo caminho através
da função deve alcançar uma instrução `return` que retorna um valor. Antes da
segurança nula, Dart era bastante negligente com relação a retornos ausentes.
Por exemplo:

```dart
// Sem segurança nula:
String missingReturn() {
  // Sem retorno.
}
```

Se você analisasse isso, você recebia uma *dica* suave de que *talvez* você tenha
esquecido um retorno, mas se não, tudo bem. Isso ocorre porque se a execução
atingir o final do corpo de uma função, o Dart retorna implicitamente `null`.
Como todo tipo é anulável, *tecnicamente* esta função é segura, mesmo que
provavelmente não seja o que você deseja.

Com tipos não-anuláveis sound, este programa está completamente errado e
inseguro. Sob segurança nula, você recebe um erro de compilação se uma função
com um tipo de retorno não-anulável não retornar um valor de forma confiável. Por
"confiável", quero dizer que a linguagem analisa todos os caminhos de fluxo de
controle através da função. Contanto que todos eles retornem algo, ele está
satisfeito. A análise é bem inteligente, então até mesmo esta função está OK:

```dart
// Usando segurança nula:
String alwaysReturns(int n) {
  if (n == 0) {
    return 'zero';
  } else if (n < 0) {
    throw ArgumentError('Valores negativos não permitidos.');
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

### Variáveis não inicializadas {:#uninitialized-variables}

Quando você declara uma variável, se você não lhe dá um inicializador
explícito, Dart inicializa a variável com `null` por padrão. Isso é
conveniente, mas obviamente totalmente inseguro se o tipo da variável é
não-anulável. Portanto, temos que apertar as coisas para variáveis não-anuláveis:

*   **Declarações de variáveis de nível superior e de campos estáticos devem ter
    um inicializador.** Já que estes podem ser acessados e atribuídos de qualquer
    lugar no programa, é impossível para o compilador garantir que a variável
    recebeu um valor antes de ser usada. A única opção segura é exigir que a
    própria declaração tenha uma expressão de inicialização que produza um valor
    do tipo correto:

    ```dart
    // Usando segurança nula:
    int topLevel = 0;

    class SomeClass {
      static int staticField = 0;
    }
    ```

*   **Campos de instância devem ter um inicializador na declaração, usar um
    formalizador de inicialização ou ser inicializados na lista de inicialização
    do construtor.** Isso é muita gíria. Aqui estão os exemplos:

    ```dart
    // Usando segurança nula:
    class SomeClass {
      int atDeclaration = 0;
      int initializingFormal;
      int initializationList;

      SomeClass(this.initializingFormal)
          : initializationList = 0;
    }
    ```

    Em outras palavras, contanto que o campo tenha um valor antes de você
    atingir o corpo do construtor, está tudo bem.

*   Variáveis locais são o caso mais flexível. Uma variável local não-anulável
    *não* precisa ter um inicializador. Isso é perfeitamente bom:

    ```dart
    // Usando segurança nula:
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

    A regra é apenas que **uma variável local deve ser *definitivamente
    atribuída* antes de ser usada.** Podemos confiar na nova análise de fluxo
    que aludi para isso também. Contanto que cada caminho para o uso de uma
    variável a inicializa primeiro, o uso está OK.

*   **Parâmetros opcionais devem ter um valor padrão.** Se você não passar um
    argumento para um parâmetro posicional ou nomeado opcional, a linguagem o
    preenche com o valor padrão. Se você não especificar um valor padrão, o valor
    padrão _default_ é `null`, e isso não funciona se o tipo do parâmetro é
    não-anulável.

    Portanto, se você deseja que um parâmetro seja opcional, você precisa torná-lo
    anulável ou especificar um valor padrão não-`null` válido.

Essas restrições parecem trabalhosas, mas não são tão ruins na prática. Elas são
muito semelhantes às restrições existentes em torno de variáveis `final` e você
provavelmente tem trabalhado com elas por anos sem nem mesmo perceber. Além
disso, lembre-se de que elas se aplicam apenas a variáveis *não-anuláveis*. Você
sempre pode tornar o tipo anulável e então obter a inicialização padrão para
`null`.

Mesmo assim, as regras causam atrito. Felizmente, temos um conjunto de novos
recursos da linguagem para lubrificar os padrões mais comuns em que essas novas
limitações o tornam mais lento. Primeiro, porém, é hora de falar sobre análise
de fluxo.

## Análise de fluxo {:#flow-analysis}

A [análise de fluxo de controle][control flow analysis] existe em compiladores há anos. Ela fica
principalmente oculta dos usuários e é usada durante a otimização do compilador,
mas algumas linguagens mais novas começaram a usar as mesmas técnicas para
recursos de linguagem visíveis. O Dart já tem uma pitada de análise de fluxo na
forma de *promoção de tipo*:

```dart
// Com (ou sem) segurança nula:
bool isEmptyList(Object object) {
  if (object is List) {
    return object.isEmpty; // <-- OK!
  } else {
    return false;
  }
}
```

[control flow analysis]: https://en.wikipedia.org/wiki/Control_flow_analysis

Observe como na linha marcada, podemos chamar `isEmpty` em `object`. Esse
método é definido em `List`, não em `Object`. Isso funciona porque o verificador
de tipo analisa todas as expressões `is` e os caminhos de fluxo de controle no
programa. Se o corpo de algum construto de fluxo de controle for executado
apenas quando uma certa expressão `is` em uma variável é verdadeira, então
dentro desse corpo o tipo da variável é "promovido" para o tipo testado.

No exemplo aqui, o branch then da instrução `if` é executado apenas quando
`object` realmente contém uma lista. Portanto, Dart promove `object` para o
tipo `List` em vez de seu tipo declarado `Object`. Este é um recurso útil, mas
é bem limitado. Antes da segurança nula, o programa funcionalmente idêntico
seguinte não funcionava:

```dart
// Sem segurança nula:
bool isEmptyList(Object object) {
  if (object is! List) return false;
  return object.isEmpty; // <-- Erro!
}
```

Novamente, você só pode chegar na chamada `.isEmpty` quando `object` contém uma
lista, então este programa é dinamicamente correto. Mas as regras de promoção de
tipo não eram inteligentes o suficiente para ver que a instrução `return`
significa que a segunda instrução só pode ser alcançada quando `object` é uma
lista.

Para a segurança nula, pegamos essa análise limitada e a tornamos [muito mais
poderosa de várias maneiras.][flow analysis]

[flow analysis]: {{site.repo.dart.lang}}/blob/main/resources/type-system/flow-analysis.md

### Análise de alcançabilidade {:#reachability-analysis}

Primeiramente, corrigimos a [reclamação de longa data][18921] de que a promoção
de tipo não é inteligente sobre retornos antecipados e outros caminhos de código
inalcançáveis. Ao analisar uma função, ela agora leva em consideração `return`,
`break`, `throw` e qualquer outra forma de a execução terminar prematuramente em
uma função. Sob segurança nula, esta função:

[18921]: {{site.repo.dart.sdk}}/issues/18921

```dart
// Usando segurança nula:
bool isEmptyList(Object object) {
  if (object is! List) return false;
  return object.isEmpty;
}
```

Agora é perfeitamente válida. Já que a instrução `if` sairá da função quando
`object` *não* for uma `List`, Dart promove `object` para ser `List` na
segunda instrução. Esta é uma melhoria muito boa que ajuda muito no código Dart,
até mesmo em coisas não relacionadas à nulidade.

### Never para código inalcançável {:#never-for-unreachable-code}

Você também pode *programar* essa análise de alcançabilidade. O novo tipo
bottom `Never` não tem valores. (Que tipo de valor é simultaneamente um
`String`, `bool` e `int`?) Então, o que significa uma expressão ter o tipo
`Never`? Isso significa que a expressão nunca pode terminar de ser avaliada com
sucesso. Ele deve lançar uma exceção, abortar ou garantir que o código
circundante que espera o resultado da expressão nunca seja executado.

De fato, de acordo com a linguagem, o tipo estático de uma expressão `throw` é
`Never`. O tipo `Never` é declarado nas bibliotecas principais e você pode usá-lo
como uma anotação de tipo. Talvez você tenha uma função auxiliar para facilitar
o lançamento de um certo tipo de exceção:

```dart
// Usando segurança nula:
Never wrongType(String type, Object value) {
  throw ArgumentError('Esperado $type, mas era ${value.runtimeType}.');
}
```

Você pode usá-lo assim:

```dart
// Usando segurança nula:
class Point {
  final double x, y;

  bool operator ==(Object other) {
    if (other is! Point) wrongType('Point', other);
    return x == other.x && y == other.y;
  }

  // Construtor e hashCode...
}
```

Este programa é analisado sem erros. Observe que a última linha do método `==`
acessa `.x` e `.y` em `other`. Ele foi promovido para `Point` mesmo que a
função não tenha nenhum `return` ou `throw`. A análise de fluxo de controle sabe
que o tipo declarado de `wrongType()` é `Never`, o que significa que o branch
then da instrução `if` *deve* abortar de alguma forma. Já que a segunda
instrução só pode ser alcançada quando `other` é um `Point`, Dart o promove.

Em outras palavras, usar `Never` em suas próprias APIs permite que você estenda
a análise de alcançabilidade do Dart.

### Análise de atribuição definitiva {:#definite-assignment-analysis}

Eu mencionei isso brevemente com variáveis locais. O Dart precisa garantir que
uma variável local não-anulável seja sempre inicializada antes de ser lida.
Usamos a *análise de atribuição definitiva* para ser o mais flexível possível
sobre isso. A linguagem analisa cada corpo de função e rastreia as atribuições a
variáveis locais e parâmetros através de todos os caminhos de fluxo de controle.
Contanto que a variável seja atribuída em todos os caminhos que atingem algum
uso de uma variável, a variável é considerada inicializada. Isso permite que
você declare uma variável sem um inicializador e a inicialize posteriormente
usando um fluxo de controle complexo, mesmo quando a variável tem um tipo
não-anulável.

Também usamos análise de atribuição definitiva para tornar as variáveis *final*
mais flexíveis. Antes da segurança nula, pode ser difícil usar `final` para
variáveis locais se você precisar inicializá-las de alguma forma interessante:

```dart
// Usando segurança nula:
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

Isso seria um erro, pois a variável `result` é `final` mas não tem
inicializador. Com a análise de fluxo mais inteligente sob segurança nula, este
programa está bom. A análise pode dizer que `result` é definitivamente
inicializado exatamente uma vez em cada caminho de fluxo de controle, então as
restrições para marcar uma variável como `final` são satisfeitas.

### Promoção de Tipo em Verificações de Nulo {:#type-promotion-on-null-checks}

A análise de fluxo (flow analysis) mais inteligente ajuda muito o código Dart,
mesmo códigos não relacionados à anulabilidade. Mas não é coincidência que estamos
fazendo essas mudanças agora. Nós particionamos os tipos em conjuntos anuláveis
e não anuláveis. Se você tem um valor de um tipo anulável, você realmente não
pode *fazer* nada de útil com ele. Nos casos em que o valor *é* `null`, essa
restrição é boa. Ela está impedindo você de ter erros.

Mas se o valor não é `null`, seria bom poder movê-lo para o lado não anulável
para que você possa chamar métodos nele. A análise de fluxo é uma das principais
maneiras de fazer isso para variáveis locais e parâmetros (e campos `private final`,
a partir do Dart 3.2). Estendemos a promoção de tipo para também observar
expressões `== null` e `!= null`.

Se você verificar uma variável local com tipo anulável para ver se ela não é `null`,
o Dart então promove a variável para o tipo não anulável subjacente (underlying):

```dart
// Usando null safety:
String makeCommand(String executable, [List<String>? arguments]) {
  var result = executable;
  if (arguments != null) {
    result += ' ' + arguments.join(' ');
  }
  return result;
}
```

Aqui, `arguments` tem um tipo anulável. Normalmente, isso impede que você chame
`.join()` nele. Mas como nós protegemos essa chamada em uma instrução `if` que
verifica para garantir que o valor não é `null`, o Dart o promove de `List<String>?`
para `List<String>` e permite que você chame métodos nele ou o passe para funções
que esperam listas não anuláveis.

Isso parece algo relativamente pequeno, mas essa promoção baseada em fluxo em
verificações de nulo é o que faz a maior parte do código Dart existente funcionar
sob null safety. A maior parte do código Dart *é* dinamicamente correto e evita
lançar erros de referência nula verificando se há `null` antes de chamar métodos.
A nova análise de fluxo em verificações de nulo transforma essa correção *dinâmica*
em correção *estática* comprovável.

Ela também, é claro, funciona com a análise mais inteligente que fazemos para a
acessibilidade. A função acima pode ser escrita da mesma forma como:

```dart
// Usando null safety:
String makeCommand(String executable, [List<String>? arguments]) {
  var result = executable;
  if (arguments == null) return result;
  return result + ' ' + arguments.join(' ');
}
```

A linguagem também é mais inteligente sobre quais tipos de expressões causam promoção.
Um `== null` ou `!= null` explícito, claro, funciona. Mas casts explícitos usando `as`, ou atribuições,
ou o operador `!` postfix (que abordaremos [adiante](#non-null-assertion-operator))
também causam promoção. O objetivo geral é que, se o código for dinamicamente
correto e for razoável descobrir isso estaticamente, a análise deve ser inteligente
o suficiente para fazê-lo.

Observe que a promoção de tipo originalmente só funcionava em variáveis locais,
e agora também funciona em campos `private final` a partir do Dart 3.2. Para mais
informações sobre como trabalhar com variáveis não locais,
veja [Trabalhando com campos anuláveis](#working-with-nullable-fields).

### Avisos de código desnecessário {:#unnecessary-code-warnings}

Ter uma análise de acessibilidade mais inteligente e saber onde `null` pode
fluir pelo seu programa ajuda a garantir que você *adicione* código para lidar
com `null`. Mas também podemos usar essa mesma análise para detectar códigos
que você *não* precisa. Antes do null safety, se você escrevesse algo como:

```dart
// Usando null safety:
String checkList(List<Object> list) {
  if (list?.isEmpty ?? false) {
    return 'Got nothing';
  }
  return 'Got something';
}
```

O Dart não tinha como saber se esse operador `?.` null-aware é útil ou não.
Pelo  que sabe, você poderia passar `null` para a função. Mas no Dart com null
safety , se você anotou essa função com o tipo agora não anulável `List`, então
ele sab e que `list` nunca será `null`. Isso implica que `?.` nunca fará nada de
útil e  você pode e deve usar apenas `.`.

Para ajudá-lo a simplificar seu código, adici onamos avisos para código desnecessário
como esse agora que a análise estática é  precisa o suficiente para detectá-lo.
Usar um operador null-aware ou mesmo uma  verificação como `== null` ou `!= null`
em um tipo não anulável é reportado como  um aviso.

E, claro, isso também se aplica à promoção de tipo não anulável. Uma vez que uma
variável é promovida a um tipo não anulável, você recebe um aviso se a verificar
redundantemente novamente para `null`:

```dart
// Usando null safety:
String checkList(List<Object>? list) {
  if (list == null) return 'No list';
  if (list?.isEmpty ?? false) {
    return 'Empty list';
  }
  return 'Got something';
}
```

Você recebe um aviso em `?.` aqui porque no ponto em que ele é executado, já
sabemos que `list` não pode ser `null`. O objetivo com esses avisos não é apenas
limpar código sem sentido. Ao remover verificações *desnecessárias* para `null`,
garantimos que as verificações significativas restantes se destaquem. Queremos
que você seja capaz de olhar para o seu código e *ver* onde `null` pode fluir.

## Trabalhando com tipos anuláveis {:#working-with-nullable-types}

Agora nós agrupamos `null` no conjunto de tipos anuláveis. Com análise de fluxo,
podemos com segurança deixar alguns valores não `null` passarem para o lado não
anulável, onde podemos usá-los. Esse é um grande passo, mas se pararmos aqui, o
sistema resultante ainda é dolorosamente restritivo. A análise de fluxo só ajuda
com locais, parâmetros e campos `private final`.

Para tentar recuperar o máximo possível da flexibilidade que o Dart tinha antes
do null safety—e para ir além em alguns lugares—temos um punhado de outros
novos recursos.

### Métodos Null-aware mais inteligentes {:#smarter-null-aware-methods}

O operador null aware `?.` do Dart é muito mais antigo que o null safety.
A semântica de tempo de execução afirma que se o receptor for `null`, então
o acesso à propriedade no lado direito é ignorado e a expressão avalia para `null`:

```dart
// Sem null safety:
String notAString = null;
print(notAString?.length);
```

Em vez de lançar uma exceção, isso imprime "null". O operador null-aware é uma
boa ferramenta para tornar os tipos anuláveis utilizáveis no Dart. Embora não
possamos deixar você chamar métodos em tipos anuláveis, podemos e deixamos você
usar operadores null-aware neles. A versão pós-null safety do programa é:

```dart
// Usando null safety:
String? notAString = null;
print(notAString?.length);
```

Funciona exatamente como o anterior.

No entanto, se você já usou operadores null-aware no Dart, provavelmente encontrou
um incômodo ao usá-los em cadeias de métodos. Digamos que você queira ver se o
tamanho de uma string potencialmente ausente é um número par (não é um problema
particularmente realista, eu sei, mas colabore comigo aqui):

```dart
// Usando null safety:
String? notAString = null;
print(notAString?.length.isEven);
```

Mesmo que este programa use `?.`, ele ainda lança uma exceção em tempo de execução.
O problema é que o receptor da expressão `.isEven` é o resultado de toda a
expressão `notAString?.length` à sua esquerda. Essa expressão avalia para `null`,
então obtemos um erro de referência nula ao tentar chamar `.isEven`. Se você
já usou `?.` no Dart, provavelmente aprendeu da maneira difícil que você tem que
aplicar o operador null-aware a *toda* propriedade ou método em uma cadeia
depois de usá-lo uma vez:

```dart
String? notAString = null;
print(notAString?.length?.isEven);
```

Isso é irritante, mas, pior, obscurece informações importantes. Considere:

```dart
// Usando null safety:
showGizmo(Thing? thing) {
  print(thing?.doohickey?.gizmo);
}
```

Aqui está uma pergunta para você: O getter `doohickey` em `Thing` pode retornar
`null`? Parece que *poderia* porque você está usando `?.` no resultado. Mas pode
ser apenas que o segundo `?.` esteja lá apenas para lidar com casos onde `thing`
é `null`, não o resultado de `doohickey`. Você não pode dizer.

Para resolver isso, pegamos emprestada uma ideia inteligente do design do C#
para o mesmo recurso. Quando você usa um operador null-aware em uma cadeia de
métodos, se o receptor avaliar para `null`, então *todo o resto da cadeia de
métodos é curto-circuitado e ignorado*. Isso significa que, se `doohickey`
tiver um tipo de retorno não anulável, você pode e deve escrever:

```dart
// Usando null safety:
void showGizmo(Thing? thing) {
  print(thing?.doohickey.gizmo);
}
```

Na verdade, você receberá um aviso de código desnecessário no segundo `?.` se
não o fizer. Se você vir um código como:

```dart
// Usando null safety:
void showGizmo(Thing? thing) {
  print(thing?.doohickey?.gizmo);
}
```
Então você sabe com certeza que significa que `doohickey` em si tem um tipo de
retorno anulável. Cada `?.` corresponde a um caminho *único* que pode fazer com
que `null` flua para a cadeia de métodos. Isso torna os operadores que reconhecem
nulos em cadeias de métodos mais concisos e mais precisos.

Enquanto estávamos nisso, adicionamos mais alguns operadores que reconhecem nulos:

```dart
// Usando segurança nula:

// Cascade que reconhece nulo:
receiver?..method();

// Operador de índice que reconhece nulo:
receiver?[index];
```

Não há um operador de chamada de função que reconheça nulo, mas você pode escrever:

```dart
// Permitido com ou sem segurança nula:
function?.call(arg1, arg2);
```

<a id="null-assertion-operator"></a>
### Operador de asserção não nulo {:#non-null-assertion-operator}

O interessante sobre usar a análise de fluxo para mover uma variável anulável para
o lado não anulável do mundo é que fazer isso é comprovadamente seguro. Você pode
chamar métodos na variável anteriormente anulável sem abrir mão da segurança ou do
desempenho de tipos não anuláveis.

Mas muitos usos válidos de tipos anuláveis não podem ser *comprovados* como
seguros de uma forma que agrade a análise estática. Por exemplo:

```dart
// Usando segurança nula, incorretamente:
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

Se você tentar executar isso, receberá um erro de compilação na chamada para `toUpperCase()`.
O campo `error` é anulável porque não terá um valor em uma resposta bem-sucedida.
Podemos ver ao inspecionar a classe que nunca acessamos a mensagem `error` quando
ela é `null`. Mas isso requer entender a relação entre o valor de `code` e a
anulabilidade de `error`. O verificador de tipo não consegue ver essa conexão.

Em outras palavras, nós, mantenedores humanos do código, *sabemos* que error não
será `null` no ponto em que o usamos e precisamos de uma maneira de afirmar isso.
Normalmente, você afirma tipos usando um cast `as`, e você pode fazer a mesma
coisa aqui:

```dart
// Usando segurança nula:
String toString() {
  if (code == 200) return 'OK';
  return 'ERROR $code ${(error as String).toUpperCase()}';
}
```

Converter `error` para o tipo `String` não anulável lançará uma exceção em tempo
de execução se o cast falhar. Caso contrário, ele nos fornece uma string não
anulável na qual podemos então chamar métodos.

"Remover a anulabilidade" aparece com frequência suficiente para termos uma nova
sintaxe abreviada. Um ponto de exclamação sufixo (`!`) pega a expressão à
esquerda e a converte para seu tipo não anulável subjacente. Portanto, a função
acima é equivalente a:

```dart
// Usando segurança nula:
String toString() {
  if (code == 200) return 'OK';
  return 'ERROR $code ${error!.toUpperCase()}';
}
```

Este "operador bang" de um caractere é particularmente útil quando o tipo
subjacente é verboso. Seria muito irritante ter que escrever `as
Map<TransactionProviderFactory, List<Set<ResponseFilter>>>` apenas para remover um
único `?` de algum tipo.

Claro, como qualquer cast, usar `!` vem com uma perda de segurança estática. O
cast deve ser verificado em tempo de execução para preservar a integridade e
pode falhar e lançar uma exceção. Mas você tem controle sobre onde esses casts
são inseridos e sempre pode vê-los ao percorrer seu código.

### Variáveis late (tardias) {:#late-variables}

O lugar mais comum onde o verificador de tipo não pode provar a segurança do código
é em torno de variáveis de nível superior e campos. Aqui está um exemplo:

```dart
// Usando segurança nula, incorretamente:
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

Aqui, o método `heat()` é chamado antes de `serve()`. Isso significa que
`_temperature` será inicializado com um valor não nulo antes de ser usado. Mas
não é viável para uma análise estática determinar isso. (Pode ser possível para
um exemplo trivial como este, mas o caso geral de tentar rastrear o estado de
cada instância de uma classe é intratável.)

Como o verificador de tipo não pode analisar usos de campos e variáveis de nível
superior, ele tem uma regra conservadora de que campos não anuláveis devem ser
inicializados em sua declaração (ou na lista de inicialização do construtor para
campos de instância). Portanto, o Dart relata um erro de compilação nesta classe.

Você pode corrigir o erro tornando o campo anulável e, em seguida, usando
operadores de asserção não nula nos usos:

```dart
// Usando segurança nula:
class Coffee {
  String? _temperature;

  void heat() { _temperature = 'hot'; }
  void chill() { _temperature = 'iced'; }

  String serve() => _temperature! + ' coffee';
}
```

Isso funciona bem. Mas envia um sinal confuso para o mantenedor da classe. Ao
marcar `_temperature` como anulável, você está a implicar que `null` é um valor
útil e significativo para esse campo. Mas essa não é a intenção. O campo
`_temperature` nunca deve ser *observado* em seu estado `null`.

Para lidar com o padrão comum de estado com inicialização atrasada, adicionamos
um novo modificador, `late` (tardio). Você pode usá-lo assim:

```dart
// Usando segurança nula:
class Coffee {
  late String _temperature;

  void heat() { _temperature = 'hot'; }
  void chill() { _temperature = 'iced'; }

  String serve() => _temperature + ' coffee';
}
```

Observe que o campo `_temperature` tem um tipo não anulável, mas não é
inicializado. Além disso, não há asserção nula explícita quando ela é usada.
Existem alguns modelos que você pode aplicar à semântica de `late`, mas eu penso
assim: o modificador `late` significa "reforce as restrições desta variável em
tempo de execução em vez de em tempo de compilação". É quase como se a palavra
"late" descrevesse *quando* ela impõe as garantias da variável.

Nesse caso, como o campo não está definitivamente inicializado, cada vez que o
campo é lido, uma verificação em tempo de execução é inserida para garantir que
ele recebeu um valor. Caso contrário, uma exceção é lançada. Dar à variável o
tipo `String` significa "você nunca deve me ver com um valor diferente de uma
string" e o modificador `late` significa "verifique isso em tempo de execução".

De certa forma, o modificador `late` é mais "mágico" do que usar `?` porque
qualquer uso do campo pode falhar e não há nada textualmente visível no local de
uso. Mas você *tem* que escrever `late` na declaração para obter esse
comportamento, e nossa crença é que ver o modificador lá é explícito o suficiente
para que isso seja sustentável.

Em troca, você obtém uma segurança estática melhor do que usar um tipo anulável.
Como o tipo do campo agora é não anulável, é um erro de *compilação* tentar
atribuir `null` ou uma `String` anulável ao campo. O modificador `late` permite
que você *adie* a inicialização, mas ainda o proíbe de tratá-la como uma variável
anulável.

### Inicialização tardia (lazy) {:#lazy-initialization}

O modificador `late` também tem alguns outros poderes especiais. Pode parecer
paradoxal, mas você pode usar `late` em um campo que tenha um inicializador:

```dart
// Usando segurança nula:
class Weather {
  late int _temperature = _readThermometer();
}
```

Quando você faz isso, o inicializador se torna *lazy* (preguiçoso). Em vez de
executá-lo assim que a instância é construída, ele é adiado e executado
preguiçosamente na primeira vez que o campo é acessado. Em outras palavras, ele
funciona exatamente como um inicializador em uma variável de nível superior ou
campo estático. Isso pode ser útil quando a expressão de inicialização é cara e
pode não ser necessária.

Executar o inicializador preguiçosamente oferece um bônus extra quando você usa
`late` em um campo de instância. Normalmente, os inicializadores de campo de
instância não podem acessar `this` porque você não tem acesso ao novo objeto até
que todos os inicializadores de campo sejam concluídos. Mas com um campo `late`,
isso não é mais verdade, então você *pode* acessar `this`, chamar métodos ou
acessar campos na instância.

### Variáveis late final {:#late-final-variables}

Você também pode combinar `late` com `final`:

```dart
// Usando segurança nula:
class Coffee {
  late final String _temperature;

  void heat() { _temperature = 'hot'; }
  void chill() { _temperature = 'iced'; }

  String serve() => _temperature + ' coffee';
}
```

Ao contrário dos campos `final` normais, você não precisa inicializar o campo em
sua declaração ou na lista de inicialização do construtor. Você pode atribuir a
ele mais tarde em tempo de execução. Mas você só pode atribuir a ele *uma vez*, e
esse fato é verificado em tempo de execução. Se você tentar atribuir a ele mais
de uma vez — como chamar `heat()` e `chill()` aqui — a segunda atribuição lança
uma exceção. Esta é uma ótima maneira de modelar um estado que é inicializado
eventualmente e é imutável depois disso.

Em outras palavras, o novo modificador `late` em combinação com os outros
modificadores de variável do Dart cobre a maior parte do espaço de recursos do
`lateinit` em Kotlin e `lazy` em Swift. Você pode até mesmo usá-lo em variáveis
locais se quiser uma pequena avaliação local preguiçosa.

### Parâmetros nomeados obrigatórios {:#required-named-parameters}

Para garantir que você nunca veja um parâmetro `null` com um tipo não anulável,
o verificador de tipo exige que todos os parâmetros opcionais tenham um tipo
anulável ou um valor padrão. E se você quiser ter um parâmetro nomeado com um
tipo não anulável e nenhum valor padrão? Isso implicaria que você deseja exigir
que o chamador sempre o passe. Em outras palavras, você quer um parâmetro que
seja *nomeado*, mas não opcional.

Eu visualizo os vários tipos de parâmetros do Dart com esta tabela:

```plaintext
             obrigatório    opcional
            +------------+------------+
posicional  | f(int x)   | f([int x]) |
            +------------+------------+
nomeado     | ???        | f({int x}) |
            +------------+------------+
```

Por razões não claras, o Dart há muito tempo suporta três cantos desta tabela,
mas deixou a combinação de nomeado+obrigatório vazia. Com segurança nula, nós a
preenchemos. Você declara um parâmetro nomeado obrigatório colocando `required`
antes do parâmetro:

```dart
// Usando segurança nula:
function({int? a, required int? b, int? c, required int? d}) {}
```

Aqui, todos os parâmetros devem ser passados por nome. Os parâmetros `a` e `c`
são opcionais e podem ser omitidos. Os parâmetros `b` e `d` são obrigatórios e
devem ser passados. Observe que a obrigatoriedade é independente da anulabilidade.
Você pode ter parâmetros nomeados obrigatórios de tipos anuláveis e parâmetros
nomeados opcionais de tipos não anuláveis (se eles tiverem um valor padrão).

Este é outro daqueles recursos que eu acho que torna o Dart melhor
independentemente da segurança nula. Simplesmente faz com que a linguagem pareça
mais completa para mim.

### Campos abstratos {:#abstract-fields}

Um dos recursos interessantes do Dart é que ele mantém uma coisa chamada
[princípio de acesso uniforme][uniform access principle]. Em termos humanos, isso significa que
campos são indistinguíveis de getters e setters. É um detalhe de implementação
se uma "propriedade" em alguma classe Dart é calculada ou armazenada. Por
causa disso, ao definir uma interface usando uma classe abstrata, é típico usar
uma declaração de campo:

[uniform access principle]: https://en.wikipedia.org/wiki/Uniform_access_principle

```dart
abstract class Cup {
  Beverage contents;
}
```

A intenção é que os usuários apenas implementem essa classe e não a estendam. A
sintaxe de campo é simplesmente uma forma mais curta de escrever um par getter/setter:

```dart
abstract class Cup {
  Beverage get contents;
  set contents(Beverage);
}
```

Mas o Dart não *sabe* que esta classe nunca será usada como um tipo concreto.
Ele vê a declaração `contents` como um campo real. E, infelizmente, esse campo
não é anulável e não tem inicializador, então você recebe um erro de compilação.

Uma correção é usar declarações abstratas explícitas de getter/setter como no
segundo exemplo. Mas isso é um pouco verboso, então com segurança nula também
adicionamos suporte para declarações de campo abstratas explícitas:

```dart
abstract class Cup {
  abstract Beverage contents;
}
```

Isso se comporta exatamente como o segundo exemplo. Ele simplesmente declara um
getter e um setter abstrato com o nome e tipo fornecidos.

### Trabalhando com campos anuláveis {:#working-with-nullable-fields}

Esses novos recursos cobrem muitos padrões comuns e tornam o trabalho com `null`
muito fácil na maioria das vezes. Mas mesmo assim, nossa experiência é que
campos anuláveis ainda podem ser difíceis. Nos casos em que você pode tornar o
campo `late` e não anulável, você está no lucro. Mas em muitos casos, você
precisa *verificar* para ver se o campo tem um valor, e isso exige torná-lo
anulável para que você possa observar o `null`.

Campos anuláveis que são privados e finais são capazes de promover o tipo
(exceto por [algumas razões particulares](/tools/non-promotion-reasons)).
Se você não pode tornar um campo privado e final por qualquer motivo,
ainda precisará de uma solução alternativa.

Por exemplo, você pode esperar que isso funcione:

```dart
// Usando segurança nula, incorretamente:
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

Dentro de `checkTemp()`, verificamos se `_temperature` é `null`. Caso
contrário, nós o acessamos e acabamos chamando `+` nele. Infelizmente, isso não é permitido.

A promoção de tipo baseada em fluxo só pode ser aplicada a campos que são *privados e finais*. Caso contrário, a análise estática não pode *provar* que o valor do campo não muda entre o ponto em que você verifica se há `null` e o ponto em que o usa.
(Considere que, em casos patológicos, o próprio campo pode ser substituído por um
getter em uma subclasse que retorna `null` na segunda vez que é chamado.)

Então, como nos preocupamos com a integridade, campos públicos e/ou não finais
não são promovidos, e o método acima não é compilado. Isso é irritante. Em casos
simples como aqui, sua melhor aposta é colocar um `!` no uso do campo. Parece
redundante, mas é mais ou menos assim que o Dart se comporta hoje.

Outro padrão que ajuda é copiar o campo para uma variável local primeiro e, em
seguida, usá-la:

```dart
// Usando segurança nula:
void checkTemp() {
  var temperature = _temperature;
  if (temperature != null) {
    print('Ready to serve ' + temperature + '!');
  }
}
```

Como a promoção de tipo se aplica a variáveis locais, isso agora funciona bem. Se
você precisar *alterar* o valor, lembre-se de armazená-lo de volta no campo e
não apenas na variável local.

Para obter mais informações sobre como lidar com esses e outros problemas de
promoção de tipo, consulte [Corrigindo falhas de promoção de tipo]
(/tools/non-promotion-reasons).

### Anulabilidade e genéricos {:#nullability-and-generics}

Como a maioria das linguagens modernas com tipagem estática, o Dart tem classes
genéricas e métodos genéricos. Eles interagem com a anulabilidade de algumas
maneiras que parecem contra-intuitivas, mas fazem sentido depois que você pensa
nas implicações. Primeiro é que "este tipo é anulável?" não é mais uma simples
questão de sim ou não. Considere:

```dart
// Usando segurança nula:
class Box<T> {
  final T object;
  Box(this.object);
}

void main() {
  Box<String>('a string');
  Box<int?>(null);
}
```

Na definição de `Box`, `T` é um tipo anulável ou um tipo não anulável? Como você
pode ver, ele pode ser instanciado com qualquer tipo. A resposta é que `T` é um
*tipo potencialmente anulável*. Dentro do corpo de uma classe ou método
genérico, um tipo potencialmente anulável tem todas as restrições de tipos
anuláveis *e* tipos não anuláveis.

O primeiro significa que você não pode chamar nenhum método nele, exceto o
punhado definido em Object. O último significa que você deve inicializar
quaisquer campos ou variáveis desse tipo antes de serem usados. Isso pode tornar
os parâmetros de tipo bem difíceis de trabalhar.

Na prática, alguns padrões aparecem. Em classes semelhantes a coleções, onde o
parâmetro de tipo pode ser instanciado com qualquer tipo, você só precisa lidar
com as restrições. Na maioria dos casos, como o exemplo aqui, isso significa
garantir que você tenha acesso a um valor do tipo do argumento de tipo sempre que
precisar trabalhar com um. Felizmente, as classes semelhantes a coleções
raramente chamam métodos em seus elementos.

Em lugares onde você não tem acesso a um valor, você pode tornar o uso do
parâmetro de tipo anulável:


```dart
// Usando segurança nula:
class Box<T> {
  T? object;
  Box.empty();
  Box.full(this.object);
}
```

Observe o `?` na declaração de `object`. Agora o campo tem um tipo
explicitamente anulável, então não há problema em deixá-lo não inicializado.

Quando você torna um parâmetro de tipo anulável como `T?` aqui, pode ser
necessário remover a anulabilidade. A maneira correta de fazer isso é usar um
cast `as T` explícito, *não* o operador `!`:

```dart
// Usando segurança nula:
class Box<T> {
  T? object;
  Box.empty();
  Box.full(this.object);

  T unbox() => object as T;
}
```

O operador `!` *sempre* lança um erro se o valor for `null`. Mas se o parâmetro
de tipo foi instanciado com um tipo anulável, então `null` é um valor
perfeitamente válido para `T`:

```dart
// Usando segurança nula:
void main() {
  var box = Box<int?>.full(null);
  print(box.unbox());
}
```

Este programa deve ser executado sem erros. Usar `as T` consegue isso. Usar `!`
lançaria uma exceção.

Outros tipos genéricos têm algum limite que restringe os tipos de argumentos de
tipo que podem ser aplicados:

```dart
// Usando segurança nula:
class Interval<T extends num> {
  T min, max;

  Interval(this.min, this.max);

  bool get isEmpty => max <= min;
}
```

Se o limite for não anulável, o parâmetro de tipo também é não anulável. Isso
significa que você tem as restrições de tipos não anuláveis — você não pode
deixar campos e variáveis não inicializados. A classe de exemplo aqui deve ter
um construtor que inicializa os campos.

Em troca dessa restrição, você pode chamar qualquer método em valores do tipo do
parâmetro de tipo que são declarados em seu limite. Ter um limite não anulável,
no entanto, impede que os *usuários* de sua classe genérica a instanciem com um
argumento de tipo anulável. Essa é provavelmente uma limitação razoável para a
maioria das classes.

Você também pode usar um *limite* anulável:

```dart
// Usando segurança nula:
class Interval<T extends num?> {
  T min, max;

  Interval(this.min, this.max);

  bool get isEmpty {
    var localMin = min;
    var localMax = max;

    // Nenhum min ou max significa um intervalo aberto.
    if (localMin == null || localMax == null) return false;
    return localMax <= localMin;
  }
}
```

Isso significa que no corpo da classe você tem a flexibilidade de tratar o
parâmetro de tipo como anulável, mas também tem as limitações da anulabilidade.
Você não pode chamar nada em uma variável desse tipo, a menos que lide com a
anulabilidade primeiro. No exemplo aqui, copiamos os campos em variáveis locais
e verificamos se essas variáveis locais são `null` para que a análise de fluxo
as promova para tipos não anuláveis antes de usarmos `<=`.

Observe que um limite anulável não impede que os usuários instanciem a classe
com tipos não anuláveis. Um limite anulável significa que o argumento de tipo
*pode* ser anulável, não que *deva*. (Na verdade, o limite padrão nos parâmetros
de tipo se você não escrever uma cláusula `extends` é o limite anulável
`Object?`.) Não há como *exigir* um argumento de tipo anulável. Se você quiser
que os usos do parâmetro de tipo sejam confiavelmente anuláveis e sejam
inicializados implicitamente como `null`, você pode usar `T?` dentro do corpo da
classe.

## Alterações na biblioteca principal {:#core-library-changes}

Existem alguns outros ajustes aqui e ali na linguagem, mas eles são menores. Coisas
como o tipo padrão de um `catch` sem cláusula `on` agora é `Object` em vez de
`dynamic`. A análise de fallthrough em instruções switch usa a nova análise de fluxo.

As mudanças restantes que realmente importam para você estão nas bibliotecas
principais. Antes de embarcarmos na Grande Aventura da Segurança Nula, nos
preocupamos que não houvesse como tornar nossas bibliotecas principais seguras
para nulos sem quebrar massivamente o mundo. Aconteceu de não ser tão terrível.
*Há* algumas mudanças significativas, mas na maior parte, a migração ocorreu
sem problemas. A maioria das bibliotecas principais não aceitava `null` e
naturalmente passava para tipos não anuláveis, ou aceitava e aceitava
graciosamente com um tipo anulável.

Há alguns cantos importantes, no entanto:

### O operador de índice Map é anulável {:#the-map-index-operator-is-nullable}

Isso não é realmente uma mudança, mas mais algo a saber. O operador de índice
`[]` na classe Map retorna `null` se a chave não estiver presente. Isso implica
que o tipo de retorno desse operador deve ser anulável: `V?` em vez de `V`.

Poderíamos ter alterado esse método para lançar uma exceção quando a chave não
estivesse presente e, em seguida, dar a ele um tipo de retorno não anulável mais
fácil de usar. Mas o código que usa o operador de índice e verifica se há
`null` para ver se a chave está ausente é muito comum, cerca de metade de todos
os usos com base em nossa análise. Quebrar todo esse código teria incendiado o
ecossistema Dart.

Em vez disso, o comportamento em tempo de execução é o mesmo e, portanto, o tipo
de retorno é obrigado a ser anulável. Isso significa que geralmente você não pode
usar imediatamente o resultado de uma pesquisa de mapa:

```dart
// Usando segurança nula, incorretamente:
var map = {'key': 'value'};
print(map['key'].length); // Erro.
```

Isso gera um erro de compilação na tentativa de chamar `.length` em uma string
anulável. Nos casos em que você *sabe* que a chave está presente, você pode
ensinar ao verificador de tipo usando `!`:

```dart
// Usando segurança nula:
var map = {'key': 'value'};
print(map['key']!.length); // OK.
```

Consideramos adicionar outro método ao Map que faria isso para você: procurar a
chave, lançar um erro se não for encontrada ou retornar um valor não anulável
caso contrário. Mas como chamá-lo? Nenhum nome seria mais curto do que o único
caractere `!`, e nenhum nome de método seria mais claro do que ver um `!` com
sua semântica embutida ali no local da chamada. Portanto, a maneira idiomática de
acessar um elemento conhecido presente em um mapa é usar `[]!`. Você se acostuma.

### Nenhum construtor List sem nome {:#no-unnamed-list-constructor}

O construtor sem nome em `List` cria uma nova lista com o tamanho fornecido, mas
não inicializa nenhum dos elementos. Isso abriria um buraco muito grande nas
garantias de integridade se você criasse uma lista de um tipo não anulável e
depois acessasse um elemento.

Para evitar isso, removemos o construtor completamente. É um erro chamar `List()`
em código seguro para nulos, mesmo com um tipo anulável. Isso parece assustador,
mas na prática a maioria dos códigos cria listas usando literais de lista,
`List.filled()`, `List.generate()` ou como resultado da transformação de alguma
outra coleção. Para o caso extremo em que você deseja criar uma lista vazia de
algum tipo, adicionamos um novo construtor `List.empty()`.

O padrão de criar uma lista completamente não inicializada sempre pareceu
fora de lugar no Dart, e agora é ainda mais. Se você tiver código quebrado por
isso, sempre poderá corrigi-lo usando uma das muitas outras maneiras de produzir
uma lista.

### Não é possível definir um comprimento maior em listas não anuláveis {:#cannot-set-a-larger-length-on-non-nullable-lists}

Isso é pouco conhecido, mas o getter `length` em `List` também tem um
*setter* correspondente. Você pode definir o comprimento para um valor mais
curto para truncar a lista. E você também pode defini-lo para um comprimento
*maior* para preencher a lista com elementos não inicializados.

Se você fizesse isso com uma lista de um tipo não anulável, violaria a
integridade quando acessasse posteriormente esses elementos não gravados. Para
evitar isso, o setter `length` lançará uma exceção em tempo de execução se (e
somente se) a lista tiver um tipo de elemento não anulável *e* você o definir
para um comprimento *maior*. Ainda é bom truncar listas de todos os tipos e você
pode aumentar listas de tipos anuláveis.

Há uma consequência importante disso se você definir seus próprios tipos de lista
que estendem `ListBase` ou aplicam `ListMixin`. Ambos os tipos fornecem uma
implementação de `insert()` que anteriormente abria espaço para o elemento
inserido definindo o comprimento. Isso falharia com a segurança nula, então, em
vez disso, mudamos a implementação de `insert()` em `ListMixin` (que `ListBase`
compartilha) para chamar `add()` em vez disso. Sua classe de lista personalizada
deve fornecer uma definição de `add()` se você quiser ser capaz de usar esse
método `insert()` herdado.

### Não é possível acessar Iterator.current antes ou depois da iteração {:#cannot-access-iterator-current-before-or-after-iteration}

A classe `Iterator` é a classe "cursor" mutável usada para percorrer os
elementos de um tipo que implementa `Iterable`. Espera-se que você chame
`moveNext()` antes de acessar quaisquer elementos para avançar para o primeiro
elemento. Quando esse método retorna `false`, você chegou ao fim e não há mais
elementos.

Costumava ser que `current` retornava `null` se você o chamasse antes de chamar
`moveNext()` pela primeira vez ou após o término da iteração. Com segurança
nula, isso exigiria que o tipo de retorno de `current` fosse `E?` e não `E`.
Isso, por sua vez, significa que cada acesso ao elemento exigiria uma verificação
de `null` em tempo de execução.

Essas verificações seriam inúteis, dado que quase ninguém acessa o elemento
atual dessa forma errônea. Em vez disso, tornamos o tipo de `current` como `E`.
Como *pode* haver um valor desse tipo disponível antes ou depois da iteração,
deixamos o comportamento do iterador indefinido se você o chamar quando não
deveria. A maioria das implementações de `Iterator` lançam um `StateError`.

## Resumo {:#summary}

Este é um tour muito detalhado por todas as mudanças de linguagem e biblioteca
em torno da segurança nula. É muita coisa, mas esta é uma mudança de linguagem
muito grande. Mais importante, queríamos chegar a um ponto em que o Dart ainda
parecesse coeso e utilizável. Isso exige mudar não apenas o sistema de tipos,
mas também vários outros recursos de usabilidade em torno dele. Não queríamos
que parecesse que a segurança nula foi adicionada.

Os pontos principais a serem lembrados são:

*   Os tipos são não anuláveis por padrão e tornados anuláveis adicionando `?`.

*   Parâmetros opcionais devem ser anuláveis ou ter um valor padrão. Você pode
    usar `required` para tornar os parâmetros nomeados não opcionais. Variáveis
    de nível superior não anuláveis e campos estáticos devem ter inicializadores.
    Campos de instância não anuláveis devem ser inicializados antes que o corpo
    do construtor comece.

*   Cadeias de métodos após operadores que reconhecem nulos entram em curto-circuito
    se o receptor for `null`. Existem novos operadores de cascade que reconhecem
    nulos (`?..`) e de índice (`?[]`). O operador "bang" de asserção não nula
    sufixo (`!`) converte seu operando anulável para o tipo não anulável
    subjacente.

*   A análise de fluxo permite que você transforme com segurança variáveis
    locais e parâmetros anuláveis (e campos finais privados, a partir do Dart
    3.2) em não anuláveis utilizáveis. A nova análise de fluxo também possui
    regras mais inteligentes para promoção de tipo, retornos ausentes, código
    inalcançável e inicialização de variáveis.

*   O modificador `late` permite que você use tipos não anuláveis e `final` em
    lugares onde você poderia não ser capaz de fazê-lo, ao custo de verificação
    em tempo de execução. Ele também oferece campos inicializados preguiçosamente.

*   A classe `List` é alterada para evitar elementos não inicializados.

Finalmente, depois que você absorve tudo isso e coloca seu código no mundo da
segurança nula, você obtém um programa íntegro que os compiladores podem
otimizar e onde todo lugar onde um erro de tempo de execução pode ocorrer é
visível em seu código. Esperamos que você sinta que vale a pena o esforço para
chegar lá.
