---
ia-translate: true
title: "Trazendo construtores primários para o Dart"
description: "Um olhar por dentro das decisões de design, dos trade-offs e do açúcar sintático por trás da adição de construtores primários no Dart 3.13."
publishDate: 2026-08-20
author: munificent
image: images/dash-primary-constructors.webp
category: deep-dive
layout: blog
---

<DashImage
  src="images/dash-primary-constructors.webp"
  alt="Illustration of Dash with blueprint drawing of primary constructor syntax."
  caption="Bringing primary constructors to Dart"
/>

(Aviso sobre uso de IA: eu escrevi cada frase deste texto pessoalmente, inclusive os travessões.)

Meu recurso favorito do Dart 3.13 são os
[construtores primários](https://dart.dev/language/primary-constructors).
Chegar até eles levou bastante tempo e muitas iterações, até que a equipe da linguagem
tivesse um design em que confiássemos. Como muitos de vocês vêm esperando
este recurso com paciência, achei que valeria a pena escrever sobre alguns dos
desafios que enfrentamos para trazer essa grande mudança de sintaxe para o Dart.

## Sobre açúcar sintático {:#on-syntactic-sugar}

Os usuários pedem algo como construtores primários há anos.
É um recurso muito desejado, o que é meio estranho quando você para para pensar.
Construtores primários não permitem fazer nada que você já não possa fazer
no Dart. São apenas uma sintaxe diferente, espero que melhor, para algo que você
já consegue expressar.

Na década de 1960, Peter Landin cunhou o termo "syntactic sugaring" para se referir
a adicionar algumas conveniências textuais por cima de uma linguagem mais fundamental,
mas desagradável. Hoje, tendemos a usar o termo mais como substantivo e a chamar
recursos como esses de "açúcar sintático".

O inimigo imortal de toda linguagem de programação é a complexidade.
Até o menor recurso precisa ser projetado,
especificado, implementado, testado e documentado.
O custo é grande. Penso na complexidade de uma linguagem como o peso em um avião.
Uma certa quantidade é necessária para que ele funcione,
mas é preciso cuidado para não adicionar peso sem necessidade, sob o risco de
todo o conjunto não conseguir decolar.

Por esse ângulo, o açúcar sintático parece uma má ideia.
É complexidade adicional sem utilidade adicional.
Pior ainda: depois que o adicionamos, também transferimos complexidade para os usuários.
Agora eles precisam escolher qual sintaxe usar toda vez que querem
expressar algo.

Quando esse tipo de recurso vale a pena?
(Admito que sinto necessidade de justificar isso, porque grande parte do meu trabalho
nos últimos anos foi adicionar esse tipo de recurso ao Dart.)
Acho que o açúcar sintático pode se pagar de algumas maneiras:

### A nova forma é simplesmente melhor {:#the-new-way-is-simply-better}

Apesar do nosso jeito um tanto robótico e da nossa afeição por
[EBNF](https://en.wikipedia.org/wiki/Extended_Backus%E2%80%93Naur_form), nós,
designers de linguagens, somos humanos e cometemos erros.
Além disso, estamos sempre aprendendo, o ecossistema que atendemos está
constantemente descobrindo novas formas de fazer software,
e as expectativas dos usuários mudam com o tempo.

Quando o Dart foi projetado, era preciso usar a palavra-chave `new` explícita
para chamar um construtor. Isso foi deliberado, para ser familiar aos usuários
vindos de C++, Java, JavaScript e outras linguagens.
A intenção era deixar claro no código quando uma chamada aloca um novo
objeto. Conforme os coletores de lixo melhoraram e os usuários ficaram mais
à vontade com o gerenciamento automático de memória, a maioria passou a achar o `new`
mais ruído do que sinal.

(Também, sinceramente, o Dart sempre enfraqueceu esse sinal ao oferecer suporte a
[construtores de fábrica](https://dart.dev/language/constructors#factory-constructors).
Um construtor de fábrica pode retornar um objeto criado anteriormente, mesmo quando
é invocado com `new`.)

No Dart 2.0, lançamos uma mudança de linguagem que permitia omitir a palavra-chave
`new` (e `const` em muitos lugares) ao chamar um construtor.
Ainda suportamos a sintaxe antiga, então essa mudança é essencialmente
açúcar sintático, mas, na prática, mantivemos a sintaxe antiga principalmente
por compatibilidade com versões anteriores.

Queremos sempre que você use a nova sintaxe, mais curta.
Lançamos [ferramentas](https://dart.dev/tools/dart-fix) que removem automaticamente
os `new` desnecessários, e temos [uma lint](https://dart.dev/tools/linter-rules/unnecessary_new)
que avisa quando você esquece. A sintaxe antiga está, na prática, obsoleta, e
com o tempo você a vê cada vez menos. Se você é novo no Dart,
talvez nem tenha percebido que dava para usar `new` em chamadas de construtor.

Isso significa que a complexidade de oferecer suporte a chamadas de construtor
com e sem `new` é baixa. Existe um custo de transição para os usuários atuais
aprenderem a nova sintaxe. Mas os novos usuários vão aprender, em sua maioria,
apenas a nova forma e nunca encontrar a antiga. Há pouca carga cognitiva ao escolher entre as
duas sintaxes, porque você simplesmente sempre usa a nova (e nossas ferramentas
vão lembrá-lo gentilmente se você não usar).

A não ser que tenhamos uma máquina do tempo para voltar e fazer tudo certo logo na
primeira vez, esta é a segunda melhor opção para corrigir um erro na linguagem.

### A sintaxe pode ser muito melhor para um caso de uso comum {:#the-syntax-can-be-much-better-for-a-common-use-case}

Durante os primeiros anos de sua existência pública,
o Dart não tinha suporte a declarações de enum.
A linguagem não permitia escrever:

```dart
enum Color { red, blue, yellow }
```

Em vez disso, era preciso escrever algo assim:

```dart
class Color {
  static const Color red = Color._(0, 'red');
  static const Color blue = Color._(1, 'blue');
  static const Color yellow = Color._(2, 'yellow');

  const Color._(this.index, this.name);

  final int index;
  final String name;
}
```

Quem é veterano de Java vai se lembrar disso como o "typesafe enum pattern" de Josh Bloch.
Por baixo dos panos, essa declaração de classe, mais verbosa, faz quase exatamente
a mesma coisa que uma declaração de enum no Dart atual.
Declarações de enum no Dart são quase inteiramente açúcar.
(Digo "quase" porque declarações de enum oferecem
[verificação de exaustividade](https://dart.dev/language/branches#exhaustiveness-checking)
em switches.)

No entanto, como você pode ver nesses dois exemplos,
declarações de enum são um açúcar *muito bom*.
Uma declaração simples de enum se desdobra em muito código Dart.
Agora, se quase ninguém escrevesse tipos enumerados,
talvez ainda não valesse a pena adicionar sintaxe para otimizar esse caso de uso.
Mas, em uma linguagem que prioriza type safety e validação de dados,
enums são bastante comuns. Só o framework Flutter define dezenas deles.

Uma quantidade relativamente pequena de açúcar sintático pode, às vezes, tornar
*muito* código de usuário mais curto e mais simples.

### A sintaxe pode deixar a intenção mais clara {:#the-syntax-can-make-the-intent-clearer}

A seção anterior faz parecer que a concisão é o objetivo principal.
Suponho que, em um mundo em que estamos cada vez mais pagando agentes de IA por token
para ler e escrever código, há um incentivo financeiro direto.
Mas não se trata apenas da contagem de caracteres.
Considere:

```dart
class Color {
  static const Color red = Color('red', 0xff0000);
  static const Color blue = Color('blue', 0x0000ff);
  static const Color yellow = Color('yellow', 0xff00ff);

  const Color(this.name, this.rgb);

  final String name;
  final int rgb;
}
```

Isso é um tipo enumerado? Quando digo *enumerado*, quero dizer: quem usa essa classe
deve assumir que as *únicas* instâncias de `Color` com as quais precisa se preocupar são
`red`, `blue` ou `yellow`?

Repare que o construtor *é* público,
então outras bibliotecas são livres para invocar o construtor e criar outras cores.
A intenção dessa classe é ser uma lista *fechada* de cores,
ou uma fábrica aberta delas, com alguns valores predefinidos?

Ao ler o código, *não sabemos*. O código é uma grande maquinaria que define
um tipo e algumas constantes. Ele *parece* o código que você escreveria se quisesse
um enum, mas a maquinaria não revela a intenção.
O código diz ao compilador o que ele significa,
mas não diz ao leitor como usá-lo.

Se mudarmos isso para uma declaração de enum,
a política de que se trata de um conjunto fechado de valores fica óbvia.
(E, agora que o Dart tem enums de verdade,
escolher *não* transformar esse código em uma declaração de enum provavelmente
sinaliza que ele *não* é um conjunto fechado.)

Para mim, esse é um motivo convincente para adicionar açúcar sintático.
O código é escrito e executado como sintaxe,
mas o que todo usuário que trabalha com o código se importa é com o que ele *significa*,
sua semântica. Para manter o código corretamente,
precisamos entender suas intenções e sua política.
Isso é cada vez mais verdadeiro em um mundo em que a IA frequentemente gera código
mais rápido do que temos tempo de revisar com cuidado.

Mesmo quando é possível fazer o compilador fazer o que você quer juntando
a maquinaria de vários recursos existentes da linguagem,
pode valer a pena ter um açúcar sintático que produza o mesmo comportamento,
porque uma sintaxe melhor eleva esse comportamento a um nível mais alto de abstração,
no qual a semântica pretendida fica mais óbvia.
Isso pode *reduzir* o trabalho cognitivo necessário para entender o código, mesmo que
a linguagem inteira fique mais complexa.

## Por que construtores primários {:#why-primary-constructors}

Certo, eu deveria estar falando de construtores primários,
não de enums e de palavras-chave `new`. (Mas, como um aviso antecipado, também vou falar
do `new`.) Por muitos anos, a
[issue aberta nº 1](https://github.com/dart-lang/language/issues/314) no repositório
de linguagem do Dart tem sido um pedido de recurso para data classes.
Se você não sabe, data classes são
[um recurso do Kotlin](https://kotlinlang.org/docs/data-classes.html) que permite
definir uma classe com alguns campos, e o compilador fornece de graça igualdade,
hash code e algumas outras coisas.

Se você ler as centenas de comentários nessa issue,
vai ver que a maioria dos usuários está menos interessada na parte de semântica de valor,
ou seja, igualdade e hash code. Trata-se, sobretudo, de ter uma forma mais fácil
de definir uma classe que tenha um construtor e armazene algum estado.

Essa funcionalidade vem, na verdade, de um recurso diferente e mais fundamental
do Kotlin: [construtores primários](https://kotlinlang.org/docs/classes.html#primary-constructor).
Acredito que o Kotlin tirou essa ideia do
[Scala](https://docs.scala-lang.org/scala3/book/domain-modeling-tools.html#classes).
Desde então, [C#](https://learn.microsoft.com/en-us/dotnet/csharp/programming-guide/classes-and-structs/instance-constructors#primary-constructors)
e [Java](https://openjdk.org/jeps/395) adicionaram suas próprias versões do
conceito.

(A parte de semântica de valor das data classes também é útil.
Estamos [explorando isso separadamente](https://github.com/dart-lang/language/blob/main/working/value-classes/feature-specification.md).
)

Há duas peças-chave nos construtores primários:

- Você pode definir um construtor escrevendo uma lista de parâmetros logo dentro
  do cabeçalho da classe. Isso evita a necessidade de escrever uma palavra-chave ou repetir
  o nome da classe para declarar o construtor. Também evita dois níveis de aninhamento e
  indentação, um para o corpo da classe e outro para a lista de parâmetros do construtor,
  em classes muito simples que contêm apenas algum estado.

- Dentro dessa lista de parâmetros, você pode indicar que alguns parâmetros devem
  declarar campos de instância correspondentes, inicializados automaticamente a partir
  do parâmetro.

Sem construtores primários ou qualquer outro tipo de açúcar sintático,
precisamos fazer algo assim no Dart:

```dart
class Point {
  final int x;
  final int y;

  Point(int x, int y) : x = x, y = y;
}
```

Neste exemplo, tivemos de escrever o nome da classe duas vezes.
Para cada pedaço de estado, escrevemos seu tipo duas vezes e seu nome *quatro* vezes.
Não é tão terrível neste exemplo, porque há apenas dois campos e os
nomes são todos curtos. Quando você começa a lidar com coisas complexas do domínio,
com nomes longos e montes de estado,
fica feio.

Esse não é um problema novo, e o Dart tem há muito tempo um pouco de açúcar sintático
chamado "[initializing
formals](https://dart.dev/language/constructors#use-initializing-formal-parameters)"
para ajudar:

```dart
class Point {
  final int x;
  final int y;

  Point(this.x, this.y);
}
```

Usar `this.` nos parâmetros do construtor significa que você só precisa escrever o tipo
de cada campo uma vez e o nome duas vezes. Melhor!
Mas você ainda precisa escrever o nome da classe duas vezes e o nome de cada campo duas vezes.
Os initializing formals são bons, mas os usuários continuam nos dizendo que eles não vão
longe o suficiente.

## Sobre pegar recursos emprestados de outras linguagens {:#on-borrowing-features-from-other-languages}

Então, alguns usuários que chegam ao Dart vindos de outra linguagem nos dizem que sentem
falta de um recurso. O que fazemos com esse tipo de feedback?

Pessoalmente, gosto de pegar recursos emprestados de outras linguagens.
Os criadores dessas linguagens já investiram muito trabalho em projetar
e validar o recurso. Podemos aprender muito com eles,
e essa outra linguagem é uma prova de existência de que o recurso é conceitualmente
coerente e viável de implementar.

Inspirar-se em outras linguagens também pode tornar a nossa linguagem mais fácil de aprender.
A não ser que o usuário seja completamente novo em programação,
ele não está aprendendo Dart do zero.
Ele chega até nós com tudo o que já aprendeu em outras linguagens.
O que resta para ele aprender é a *diferença* entre o que ele sabe e
o que o Dart contém. Quando pegamos sintaxe e semântica emprestadas de outras linguagens,
reduzimos o tamanho dessa diferença e diminuímos o esforço para aprender Dart.

Essa filosofia tem sido fundamental para o sucesso do Dart.
Desde os pontos e vírgulas até as classes,
o Dart foi projetado, de ponta a ponta, para ser familiar e fácil de aprender para
usuários de outras linguagens populares, como JavaScript,
Java e C#.

Ao mesmo tempo, um bom design de linguagem é contextual e holístico.
"Qual é um bom par de sapatos?" tem respostas muito diferentes quando você está
na tundra ártica e quando está em uma praia do Havaí.
Um recurso de linguagem que funciona muito bem em,
digamos, Rust pode não se encaixar com elegância no Dart, com a sintaxe,
a semântica, a história, a base de usuários e o ecossistema próprios dele.

Não quero que o Dart pareça o monstro de Frankenstein, costurado com pedaços arrancados
de outras linguagens.
Assim, quando a equipe da linguagem Dart analisa recursos de outras linguagens,
estamos olhando ao mesmo tempo para como o recurso resolve problemas no contexto
daquela linguagem e para o quanto esse contexto combina com o do próprio Dart.

## Adicionando construtores primários ao Dart {:#adding-primary-constructors-to-dart}

Sabíamos que os usuários queriam uma notação mais agradável para definir uma classe que
inicializa alguns campos a partir de parâmetros do construtor.
Com construtores primários, você escreve o construtor e o compilador sintetiza os campos.
Uma linguagem também poderia seguir o caminho inverso:
você escreve as declarações dos campos e o compilador lhe dá o construtor de graça.
O Swift faz isso com
[inicializadores memberwise](https://docs.swift.org/swift-book/documentation/the-swift-programming-language/initialization/#Memberwise-Initializers-for-Structure-Types).

Um desafio sempre que sua linguagem deriva duas declarações de uma mesma peça de sintaxe
é que essa sintaxe precisa lidar com todas as várias formas que você pode
configurar as duas declarações.
No nosso caso, o campo de instância pode ser final ou não.
Ele pode ter metadados como `@override` ou comentários de documentação.
O construtor pode ser nomeado ou não,
`const` ou não. Um parâmetro do construtor pode ser posicional ou nomeado,
opcional ou obrigatório. Se for opcional,
pode precisar especificar um valor padrão.

Passamos algum tempo investigando
[inferir um construtor a partir das declarações de campos](https://github.com/dart-lang/language/issues/698),
mas, no fim, decidimos que os parâmetros eram a declaração mais útil para um
usuário escrever à mão. Como o construtor costuma ser parte da API pública,
é importante controlar totalmente a assinatura:
o nome do construtor e se ele é `const`,
quais parâmetros são nomeados ou posicionais,
a ordem dos posicionais e seus valores padrão.

Para inferir um campo de instância a partir de um parâmetro do construtor,
a única peça que falta ao usuário informar é se o campo deve ser final. Faz bastante sentido
permitir um `final` ou `var` no início do parâmetro para controlar isso. A ausência
dos dois modificadores significa então que o parâmetro não declara campo de instância algum.
Isso é semelhante ao que Scala e Kotlin fazem com `val` e `var`.
O resultado no Dart fica assim:

```dart
class Point(
  final int x,
  final int y,
);
```

(Como os construtores primários tornam os corpos de classe vazios mais comuns,
agora também permitimos usar `;` em vez de `{}` para um corpo de classe vazio.)

## Sobre precipícios sintáticos {:#on-syntactic-cliffs}

Isso parece bem bonito, mas e se o construtor primário também precisar de um corpo
ou de uma lista de inicializadores? Uma opção seria simplesmente dizer:
"Bem, nesse caso, não use um construtor primário."
O açúcar sintático costuma pegar um subconjunto dos casos de uso e oferecer
uma sintaxe mais concisa para eles. Se você sair desse subconjunto,
é razoável exigir que o usuário volte à sintaxe mais antiga e mais elaborada.

Isso é a decisão certa em alguns casos.
Mas a equipe da linguagem está muito atenta ao fato de que o código evolui com o tempo.
Digamos que você esteja escrevendo uma classe. Ela começa simples, com apenas alguns campos
inicializados a partir de parâmetros do construtor:

```dart
class FormatterOptions({
  final int indent = 0,
  final int pageWidth = 80,
}) {
  // ...
}
```

Um caso de uso perfeito para um construtor primário.
Depois você adiciona mais campos e parâmetros.
Ótimo. Logo, você tem um construtor com um monte de parâmetros
que declaram campos:

```dart
class FormatterOptions(
  final int indent = 0,
  final int pageWidth = 80,
  final Version? languageVersion,
  final TrailingCommas? trailingCommas,
  final bool followLinks = false,
  final Show show = Show.changed,
  final Output output = Output.write,
  final Summary summary = Summary.none,
  final bool setExitIfChanged = false,
  final List<String> experimentFlags = const [],
) {
  // ...
}
```

Então, um dia, você decide fazer um pouco de log no corpo do construtor.
Se os construtores primários não suportassem corpos,
você teria de converter todo esse construtor primário em um construtor com corpo:

```dart
class FormatterOptions {
  final int indent;
  final int pageWidth;
  final Version? languageVersion;
  final TrailingCommas? trailingCommas;
  final bool followLinks;
  final Show show;
  final Output output;
  final Summary summary;
  final bool setExitIfChanged;
  final List<String> experimentFlags;

  FormatterOptions({
    this.indent = 0,
    this.pageWidth = 80,
    this.languageVersion,
    this.trailingCommas,
    this.followLinks,
    this.show = Show.changed,
    this.output = Output.write,
    this.summary = Summary.none,
    this.setExitIfChanged = false,
    this.experimentFlags = const [],
  }) {
    log.write('Created options.');
  }

  // ...
}
```

Isso é viável. O SDK do Dart inclui muitas ferramentas de correção rápida que podem fazer
exatamente esse tipo de mudança com um clique,
então não é *mecanicamente* difícil alterar o código.
Mas continua sendo uma mudança textual grande.
Você só queria adicionar uma linha de log e agora tem 20 linhas de alterações
para revisar.

Na equipe da linguagem, chamamos isso de "precipício sintático".
Você quer fazer uma pequena mudança *semântica* (aqui,
adicionar uma linha de log), mas o que você quer expressar está um pouco
fora dos limites do que a sintaxe otimizada suporta.
Você cai do platô agradável dessa sintaxe e aterrissa no terreno mais verboso logo abaixo.

Não é uma sensação boa quando isso acontece.
Você está tentando explorar livremente o espaço semântico do seu programa,
mas parece que alguns pequenos passos de significado estão fora de alcance em termos
de sintaxe. Quando projetamos recursos de linguagem,
passamos muito tempo discutindo esses tipos de precipício e tentando evitá-los
sempre que possível.

Queremos que a linguagem pareça um terreno liso, em que pequenas mudanças semânticas
exigem apenas mudanças textuais igualmente pequenas.
Quando você faz uma revisão de código, queremos que as linhas alteradas reflitam
as mudanças de comportamento no programa, e não movimentos laterais sem sentido
pela gramática da linguagem.

## Corpos de construtores primários {:#primary-constructor-bodies}

A solução do Kotlin é permitir um
[bloco inicializador](https://kotlinlang.org/docs/classes.html#initializer-blocks)
dentro do corpo da classe. No Dart, oferecemos algo semelhante,
mas usando a palavra-chave `this`:

```dart
class FormatterOptions(
  final int indent = 0,
  final int pageWidth = 80,
  final Version? languageVersion,
  final TrailingCommas? trailingCommas,
  final bool followLinks = false,
  final Show show = Show.changed,
  final Output output = Output.write,
  final Summary summary = Summary.none,
  final bool setExitIfChanged = false,
  final List<String> experimentFlags = const [],
) {
  this {
    log.write('Created options.');
  }
}
```

O bloco inicializador oferece um lugar para preencher um corpo ou uma lista de inicializadores
para o construtor primário. Ele também é um lugar natural para adicionar um comentário de documentação
ao construtor. (Se você colocar o comentário de documentação acima do cabeçalho da classe,
ele se aplica à classe inteira, não apenas ao construtor primário.)

Esses blocos inicializadores são, de certa forma, açúcar sintático sobre açúcar sintático.
Não precisamos deles, mas eles ajudam a evitar que o usuário caia de um
precipício sintático. Você pode começar com um construtor primário enquanto sua classe é
simples, e a linguagem nunca força você a sair dessa escolha conforme a classe evolui.

## Sobre agrupamento semântico {:#on-semantic-bundling}

Agora, mesmo que *a linguagem* não obrigue você a transformar seu construtor primário
em um construtor com corpo,
*você* ainda pode querer definir um construtor dentro do corpo da classe.
Classes podem ter muita coisa acontecendo no cabeçalho:
parâmetros de tipo, uma cláusula `extends`,
mixins em uma cláusula `with` e talvez `implements` também.
Os parâmetros do construtor podem ter comentários de documentação.
Lá em cima, pode ficar confuso e bagunçado.

Ou você pode ter uma classe com vários construtores em que nenhum deles é
claramente mais "primário" que os outros.
(Quando você tem um construtor primário,
todos os demais construtores não-fábrica da classe precisam redirecionar para ele.)
Como alternativa, talvez o construtor mais fundamental seja privado, e você ache
confuso colocar um construtor privado no cabeçalho da classe, que é muito visível.

Por esses motivos e outros, o Dart ainda oferece suporte a construtores declarados
dentro do corpo da classe. Não consideramos os construtores primários *inerentemente superiores*
aos construtores no corpo; eles são apenas diferentes e mais adequados a certos
casos de uso.

No entanto, apenas um construtor primário tem acesso ao açúcar sintático `var` e `final`
em um parâmetro, que declara implicitamente um campo de instância e o inicializa
a partir desse parâmetro.
Essas duas funcionalidades, declarar o construtor no cabeçalho da classe e parâmetros
que induzem campos, estão agrupadas.
Você não pode usar a segunda sem a primeira.

Em geral, nos esforçamos na linguagem para não colocar o usuário em uma posição em que
ele quer apenas um de dois comportamentos, mas a linguagem os amarra e o obriga a levar os dois.
Por exemplo,
quando adicionamos [modificadores de classe](https://dart.dev/language/class-modifiers), adicionamos
deliberadamente tanto `final` quanto `sealed`.
Eles são bem parecidos, mas `final` permite impedir a criação de subclasses *sem*
também optar pela verificação de exaustividade.

Decidir o que agrupar é um exercício de equilíbrio.
Acredito que uma grande parte do que dá a cada linguagem de programação o seu caráter e
a sua adequação a certos domínios é a forma como ela escolhe mapear semântica em sintaxe.
Parte disso é onde ela pendura múltiplos comportamentos em um único trecho de texto.
Por exemplo, na maioria das linguagens orientadas a objetos,
tornar uma classe subclasse de outra também a torna um subtipo no sistema de tipos estático.
Isso não é estritamente necessário, como mostra a herança privada do C++.
Mas, na maioria das linguagens orientadas a objetos,
esse acoplamento parece fazer sentido.

Pode parecer ideal ter um mapeamento estrito, um para um, entre comportamento e texto,
mas agrupar comportamentos pode facilitar a expressão de padrões comuns.
Pense em como é mais fácil entrar em uma hamburgueria e dizer "quero um #2",
em vez de "um cheeseburger duplo com mostarda, mas sem ketchup,
batata frita média e um refrigerante médio".

Quando se trata de combinar a declaração de parâmetros com construtores primários,
isso pareceu um agrupamento relativamente seguro.
Declarar parâmetros já é açúcar sintático e não permite expressar nada que você não
conseguiria expressar em uma declaração de classe normal.
Se você não quiser que um construtor seja primário por qualquer motivo, precisa abrir mão
da conveniência sintática de declarar parâmetros.
Mas a concisão é tudo o que você perde. Você ainda pode definir sua classe com exatamente
a API e a semântica que deseja.

Seria bom poder usar a declaração de parâmetros dentro de construtores no corpo da classe,
e trabalhamos em [uma proposta](https://github.com/dart-lang/language/blob/main/working/declaring-constructors/feature-specification.md)
para permitir isso. No fim, achamos que havia consequências negativas demais.
Se qualquer construtor aleatório em qualquer lugar do corpo da classe puder declarar
campos de instância implicitamente na sua lista de parâmetros,
fica mais difícil encontrar todo o estado que uma classe armazena e raciocinar sobre ele.
Isso é um problema menor com construtores primários, porque o construtor primário
está sempre ali, no topo da classe.

## Construtores no corpo mais curtos {:#shorter-in-body-constructors}

Outra fonte de verbosidade na sintaxe existente de declaração de construtores do Dart
é a necessidade de repetir o nome da classe.
Não parece tão ruim com nomes curtos, em exemplos como `Point`,
mas quando você tem um nome de classe como,
digamos,
[`AnimatedFractionallySizedBox`](https://api.flutter.dev/flutter/widgets/AnimatedFractionallySizedBox-class.html),
repetir esse identificador de 28 caracteres ocupa muito espaço que poderia ser usado
na lista de parâmetros do construtor.

Esse problema *podemos* resolver. A sintaxe de construtores do Dart foi herdada do Java
e do C#, que, por sua vez, a herdaram do C++.
Bjarne Stroustrup escolheu usar o nome da classe para minimizar o número de novas
palavras-chave e espelhar a aparência de uma chamada de construtor.
É uma sintaxe engenhosa, mas ele mesmo admite que "isso pode ter sido inteligente demais".

Fazer uma parte da sintaxe da linguagem espelhar outra parte pode ser uma ferramenta útil
para ajudar os usuários a entender o que o código significa.
Quando dois trechos de código parecem iguais,
isso sinaliza que eles provavelmente se relacionam de alguma forma.
E se as declarações parecerem chamadas, então, depois de ler a declaração,
você já sabe o que escrever para chamá-la.

Pelo menos, essa é a ideia. Mas o Dart já deixa de cumprir esse princípio.
Funciona mais ou menos para declarações de funções e métodos, se você ignorar as anotações de tipo.
Getters são declarados com a palavra-chave `get`, mas não são invocados com ela.
Operadores são declarados com a palavra-chave especial `operator`
e têm o parâmetro da direita entre parênteses, embora você não precise de parênteses
para chamar o operador. Até nas funções,
o Dart usa `{...}` para declarar parâmetros nomeados,
o que não se parece em nada com a forma como eles são passados na chamada.

A maioria das outras linguagens orientadas a objetos não usa o nome da classe para definir
um construtor. Swift, Ruby e Objective-C usam `init()`.
Python acrescenta alguns sublinhados e usa `__init__()`.
JavaScript, TypeScript e Kotlin usam `constructor`.
PHP usa `__construct`.

Isso nos levou a concluir que repetir o nome da classe para um construtor não estava
realmente trazendo muito em termos de familiaridade ou consistência.
E há um custo que os usuários precisam pagar.
Nomes costumam ser longos, e todo ser humano,
processador de templates, gerador de código,
agente de IA que produz código, ou recurso futuro de metaprogramação que queira
injetar um construtor na classe precisa saber usar o nome da classe.
É quase como se cada classe tivesse sua própria palavra-chave contextual especial.

Esse problema é especialmente agudo em outro recurso em que estamos trabalhando agora:
[membros de extensão estáticos](https://github.com/dart-lang/language/blob/main/working/0723-static-extensions/feature-specification.md).
Extensões no Dart permitem anexar membros de instância a tipos existentes,
mas, atualmente, não permitem adicionar membros estáticos nem construtores.
Gostaríamos de oferecer suporte a eles também, mas isso levanta um caso de borda complicado.
Extensões podem ser definidas não apenas em classes,
mas em qualquer tipo estático, incluindo typedefs.
Considere:

```dart
class SomeClass {}

typedef OtherName = SomeClass;

extension on OtherName {
  // ...
}
```

Se você quiser adicionar um construtor nessa extensão,
qual nome usar: `OtherName` ou `SomeClass`?
Tenha em mente que, do ponto de vista do sistema de tipos,
são exatamente o mesmo tipo. Não existe uma classe chamada `OtherName` em nenhum lugar do
programa. O typedef não cria um novo tipo nomeado;
ele apenas define um alias efêmero que pode ser usado para se referir a algum outro
tipo.

Poderíamos exigir que você usasse `OtherName`, porque esse é o nome que você escreveu
no início da declaração da extensão.
Mas isso viola o princípio de que um tipo pode ser substituído por um typedef
que se refere ao mesmo tipo sem quebrar nada.
Normalmente, trocar uma referência a algum tipo por um typedef é uma mudança transparente.
Aqui, e somente aqui, o nome do typedef se tornaria significativo.

Ou poderíamos fazer o contrário e dizer que você precisa usar o nome da classe subjacente
à qual o typedef se resolve.
Mas isso quebra o encapsulamento do typedef.
O typedef pode estar em outra biblioteca e se referir a uma classe privada cujo
nome você nem consegue acessar na sua biblioteca!

Toda a complexidade aqui é um problema que criamos para nós mesmos ao usar o nome da classe
como um identificador mágico para significar "construtor".
Se escolhermos uma palavra-chave universal,
o problema desaparece.

Foi isso que fizemos. No Dart 3.13,
você pode usar `new` em vez do nome da classe para declarar um construtor não-fábrica,
e `factory` para declarar um construtor de fábrica.
Se quiser um construtor nomeado, coloque o nome depois da palavra-chave
`new` ou `factory`.

```dart
// Before Dart 3.13:
class LongClassName {
  LongClassName();                          // Unnamed constructor.
  LongClassName.create();                   // Named constructor.
}

class AnotherLongClass {
  factory AnotherLongClass() { ... }        // Factory constructor.
  factory AnotherLongClass.create() { ... } // Named factory constructor.
}

// New Dart 3.13 syntax:
class LongClassName {
  new();                                    // Unnamed constructor.
  new create();                             // Named constructor.
}

class AnotherLongClass {
  factory () { ... }                        // Factory constructor.
  factory create() { ... }                  // Named factory constructor.
}
```

(A sintaxe para construtores de redirecionamento é semelhante.)

Isso está na categoria de açúcar sintático que achamos estritamente melhor.
A menos que o nome da sua classe tenha menos de três letras,
a nova sintaxe é sempre mais curta. Ela é mais regular.
Além de parecer desconhecida agora (uma sensação que vai passar),
achamos que ela é simplesmente melhor em todos os sentidos.

No entanto, usar `new` para definir um construtor leva a uma combinação estranha.
Se você também quiser que esse construtor seja constante,
precisa de um modificador `const`:

```dart
class SomeClass {
  const new() { ... }
}
```

Admito que `const new` parece um oxímoro.
Isso é especialmente verdade para usuários do Dart que já estão na área há tempo suficiente
para lembrar quando toda *invocação* de construtor começava com `new` ou
`const`. Naquele mundo, as duas palavras eram diretamente opostas.
Mas você não escreve mais `new` para invocar construtores,
então, do jeito que penso agora, a palavra-chave `new` significa basicamente "*declarar*
um construtor", e `const` é sempre um modificador que significa "tornar a coisa
constante".

## Resumo {:#recap}

Obrigado por revisitar este longo processo de design comigo.
Passamos tanto tempo ponderando cada detalhe da semântica e da sintaxe
dos construtores até o Dart 3.13 que eu poderia escrever outras cinco mil
palavras sobre isso. Consideramos colocar a lista de parâmetros do construtor primário depois das
cláusulas `extends`, `implements` e `with` no cabeçalho da classe.
Debatemos cada canto do corpo de uma classe para decidir onde os parâmetros do construtor
primário deveriam estar no escopo. Devemos permitir uma chamada ao superconstrutor no
cabeçalho da classe? O que isso significa para a cláusula `with`?
O que acontece se você tiver um construtor de fábrica chamado `factory`?

Construtores são fundamentais na programação orientada a objetos, e o Dart já
gasta *muita* complexidade de linguagem com eles.
Trazer os construtores primários para o Dart exigiu consertar, com muito cuidado,
dezenas de imperfeições no tecido da linguagem.
Espero que o resultado pareça integrado, mas tenho certeza de que não é perfeito.

Se você encontrar partes dos novos recursos que pareçam estranhas ou arbitrárias,
espero que este longo texto ajude a fazer mais sentido delas.
Se não ajudar, nos avise. A linguagem está sempre evoluindo, e sempre tentamos
torná-la melhor. Enquanto isso,
esperamos que você ache que o seu código no Dart 3.13 fica mais limpo,
mais simples e mais agradável de ler e escrever.
