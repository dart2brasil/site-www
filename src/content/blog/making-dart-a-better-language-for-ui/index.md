---
ia-translate: true
title: "Tornando o Dart uma linguagem melhor para UI"
description: "Na equipe do Dart, estamos ocupados implementando algumas mudanças na linguagem das quais gosto muito. Todas elas se relacionam a literais de coleção…"
publishDate: 2019-03-19
author: munificent
image: images/14PIeARfthvxtn0cvBB5MPw.webp
category: other
layout: blog
---


<DashImage src="images/14PIeARfthvxtn0cvBB5MPw.webp" alt="Close-up of Dart UI code showing a Widget build method." />


Na equipe do [Dart](https://www.dartlang.org/), estamos ocupados implementando algumas mudanças na linguagem das quais gosto muito. Todas se relacionam a literais de coleção, a sintaxe embutida para criar listas, mapas e conjuntos:

```dart
var someList = [1, 2, 3, 4];
var someMap = {key: 1, another: 2};
var someSet = {1, 2, 3, 4};
```

Se você não escreve código Dart hoje, isso talvez não seja muito relevante para você e para os seus Objetivos de Vida, mas espero que continue lendo mesmo assim. Acho que os recursos são interessantes por si só, e o modelo de execução por trás deles pode exercitar sua cabeça de maneiras úteis e/ou envolventes. Sempre acho divertido aprender coisas novas sobre linguagens, mesmo as que não uso atualmente.

## Como os usuários do Flutter constroem sua UI {:#how-flutter-users-build-their-ui}

Se você ouviu alguma coisa sobre Dart no último ano, provavelmente foi no contexto do [Flutter](https://flutter.dev/). Se esse nome não lhe diz nada, o Flutter é um framework de UI para criar apps mobile multiplataforma. Não consigo fazer justiça a ele aqui, mas clique no link e ele responderá a todas as perguntas do seu coração. (Bem, pelo menos a todas as perguntas sobre Flutter. Ele não vai te dizer por que aquele amor do ensino médio nunca retornou sua ligação.)

Uma escolha fundamental que qualquer framework de UI faz é como os elementos visuais básicos da interface — botões, cores, texto, layout etc. — são definidos. Você os escreve em algum tipo de formato separado de “template” ou “markup”, ou direto no código executável onde o comportamento da UI é definido? A cada quinze anos, mais ou menos, a indústria muda de resposta.

[Angular](https://angular.io/) e a maioria dos frameworks web seguem os passos do HTML e usam templates. O [React](https://reactjs.org/) coloca a UI dentro do seu JavaScript, mas também adiciona uma DSL embutida chamada [JSX](https://reactjs.org/docs/introducing-jsx.html) para que pareça HTML. Tentando ter o bolo e comê-lo também, eu acho, embora nem todo mundo descreveria o HTML como algo particularmente parecido com sobremesa.

O Flutter coloca a UI diretamente no seu código Dart, usando a sintaxe normal de expressões do Dart. Veja:

```dart
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Welcome to Flutter',
      home: Scaffold(
        appBar: AppBar(title: Text('Welcome to Flutter')),
        body: Column(
          children: [
            Text('Hello World'),
            Text('This is Flutter'),
            Text('Written in Dart')
          ]
        )
      )
    );
  }
}
```

Tudo depois dessa palavra-chave `return` é uma grande expressão aninhada que produz um pedaço de interface do usuário. Usar Dart para isso tem alguns benefícios concretos:

* **Só existe uma linguagem para aprender: Dart.** Como o Dart foi projetado para ser familiar a pessoas que vêm de outras linguagens, espero que isso não seja muito difícil.

* **Você pode usar todos os recursos de abstração de uma linguagem de propósito geral ao construir sua UI.** Extraia partes para funções reutilizáveis. Dê parâmetros a essas funções para variar a UI gerada. Guarde coisas em variáveis locais. Faça do seu jeito.

* **Você nunca bate numa parede de expressividade e precisa portar para outra linguagem.** Se você já usou uma linguagem declarativa, provavelmente já encontrou a situação em que chega ao limite do que ela consegue de fato expressar. Nesse ponto, ou você abandona o que estava tentando fazer, ou reescreve tudo com trabalho braçal em uma linguagem de nível mais baixo, normalmente imperativa. Como você já *está* em uma linguagem com todos os recursos, com o Dart você nunca bate nessa parede, e o seu código de UI cresce em sofisticação sem atrito.

O principal desafio, claro, e a razão pela qual as pessoas criam linguagens declarativas para começo de conversa, é que definir coisas em uma linguagem imperativa pode ser realmente tedioso e difícil de ler.

Imagine que, em vez deste pequeno trecho de HTML:

```html
<p>I am an <strong>exciting</strong> paragraph!</p>
```

você tivesse que escrever algo como:

```java
doc.beginTag("p");
doc.appendText("I am an ");
doc.beginTag("strong");
doc.appendText("exciting");
doc.endTag("strong");
doc.appendText("paragraph!");
doc.endTag("p");
```

Felizmente, as linguagens e APIs modernas não são *tão* de baixo nível assim. Mesmo que os statements sejam imperativos, as *expressões* são bem declarativas. Enquanto o código acima é complicado, este aqui fica mais ou menos no nível do HTML:

```java
p("I am an ", strong("exciting"), " paragraph!")
```

O paradigma reativo moderno, em que você “constrói” sua UI criando-a do zero como uma única expressão, leva você bem longe. A parte relevante do exemplo do Flutter lá em cima é só isto:

```dart
MaterialApp(
  title: 'Welcome to Flutter',
  home: Scaffold(
    appBar: AppBar(title: Text('Welcome to Flutter')),
    body: Column(
      children: [
        Text('Hello World'),
        Text('This is Flutter'),
        Text('Written in Dart')
      ]
    )
  )
)
```

Usa parênteses e colchetes em vez de sinais de maior e menor, mas, fora isso, não está tão longe de uma linguagem de “markup”. É surpreendente como isso funciona bem. A sintaxe do Dart é baseada em JavaScript, que herdou do Java, que herdou do C. Ao longo do caminho, acrescentamos a sintaxe de literal de lista com colchetes e os parâmetros nomeados, mas essas são mudanças bem pequenas.

O C foi projetado para implementar sistemas operacionais de linha de comando no PDP-11. O fato de sua notação escalar não *tão* mal para construir UIs gráficas em dispositivos móveis é um testemunho do bom gosto de design de Ritchie ou da nossa síndrome de Estocolmo coletiva em relação à sintaxe do C. De qualquer forma, funciona… na maior parte do tempo.

No exemplo aqui, não há nenhuma lógica de runtime interessante necessária para construir a UI. Tudo cabe bem em uma única expressão aninhada. Mas digamos que, por algum motivo, você não queira mostrar a parte “This is Flutter” do texto às terças-feiras. (Talvez você precise abrir espaço na tela para o banner “Taco Tuesday!”.)

Há algumas formas de expressar isso, mas nenhuma parece tão agradável e declarativa quanto o exemplo acima. Aqui está uma delas:

```dart
Widget build(BuildContext context) {
  var texts = [Text('Hello World')];
  if (!isTuesday) {
    texts.add(Text('This is Flutter'));
  }
  texts.add(Text('Written in Dart'));

  return MaterialApp(
    title: 'Welcome to Flutter',
    home: Scaffold(
      appBar: AppBar(title: Text('Welcome to Flutter')),
      body: Column(children: texts)
    )
  );
}
```

Estamos bem mais perto do código imperativo de baixo nível e feio que leva as pessoas a usar templates. Quando olhamos código real de Flutter, ficamos tristes ao ver muita coisa parecida com isto. Então, cerca de um ano atrás, a equipe do Flutter nos pediu, no Dart, que criássemos mudanças na linguagem para tornar o código de UI escrito em Dart mais fácil de escrever, ler e manter.

## “UI as Code” {:#ui-as-code}

Chamamos essa iniciativa de “[UI as code](https://github.com/munificent/ui-as-code)”, já que ela trata de construir sua UI usando código. Mas o objetivo final são recursos de linguagem aplicáveis, em geral, ao maior número possível de programas Dart, com Flutter ou sem Flutter. (Se você quiser muito mais contexto, aqui está [um documento longo de motivação](https://github.com/munificent/ui-as-code/blob/master/Motivation.md) que escrevi.)

Depois de explorar [um monte de opções](https://github.com/munificent/ui-as-code/blob/master/Choices.md), decidimos focar em algumas melhorias direcionadas em torno de literais de coleção. Isso pode não parecer tão sexy quanto enfiar algo como JSX no Dart (não que eu esteja totalmente descartando essa ideia), mas tem a vantagem de ser muito mais fácil para os usuários aproveitarem aos poucos no próprio código.

Deixar os literais de lista mais elegantes pode parecer ter, hum, impacto limitado. Mas, se você olhar código de UI do Flutter como o de cima, ele é basicamente uma grande árvore de chamadas de construtor e literais de lista. Literais de lista são uma grande fatia do território. (Aliás, [linguagens inteiras](https://en.wikipedia.org/wiki/Lisp_(programming_language)) foram projetadas em torno delas.) Se você investigar exemplos em que parece que deveria ser possível escrever algo de forma declarativa, mas acaba tendo que fazer um monte de mutação imperativa e feia, muitas vezes isso está relacionado a listas.

Se conseguirmos tornar as coleções melhores, podemos tornar *muito* código Dart melhor. Para isso, estamos adicionando três novos recursos:

## Spreads {:#spreads}

Muitas vezes, ao montar uma lista de widgets, alguns desses widgets já estão em *outra* lista. Aqui está um trecho de código Flutter:

```dart
Widget build(BuildContext context) {
  var conversation = buildTab2Conversation();
  var listItems = [Tab2Header()];
  listItems.addAll(conversation);
  listItems.add(buildFooter());

  return CupertinoPageScaffold(
    child: ListView(children: conversation),
  );
}
```

O método `buildTab2Conversation()` retorna uma lista de widgets que queremos cercar com o cabeçalho e o rodapé. Ter que montar a lista resultante de forma imperativa é um verdadeiro incômodo. Isso força o código a ser lido “de trás para frente”: você vê um monte de coisas mexendo nos filhos antes de chegar ao código que mostra de quem eles são os filhos.

O Dart tem um recurso chamado [method cascades](https://news.dartlang.org/2012/02/method-cascades-in-dart-posted-by-gilad.html) que ajuda um pouco. Ele permite enfiar uma chamada de método mutável no meio de uma expressão, mantendo o objeto original. Com ele, fica assim:

```dart
Widget build(BuildContext context) {
  return CupertinoPageScaffold(
    child: ListView(children: [
      Tab2Header()
    ]..addAll(buildTab2Conversation())
      ..add(buildFooter())),
  );
}
```

Isso é meio melhor, mas ainda é bem desajeitado. Aquele `..add()` final para acrescentar um único item é particularmente exagerado. Você provavelmente consegue adivinhar como resolvemos isso, já que várias outras linguagens já têm a mesma solução. (Mais de 90% do design de linguagens é descobrir quais recursos tomar emprestado de outras linguagens.) Estamos adicionando [uma nova sintaxe chamada *spreads*](https://github.com/dart-lang/language/blob/master/accepted/future-releases/spread-collections/feature-specification.md).

Dentro de um literal de coleção, um spread desempacota outra coleção e insere o conteúdo dela diretamente no lugar. Por exemplo:

```dart
var a = [2, 3];
var b = [5, 6];
var c = [1, ...a, 4, ...b]; // [1, 2, 3, 4, 5, 6].
```

O `...` antes do elemento da lista faz com que os elementos dele sejam interpolados na lista ao redor. Essa é a mesma sintaxe que o JavaScript usa. Python, Ruby e algumas outras usam um `*` como prefixo para a mesma coisa, mas achamos que isso não se destacava visualmente o suficiente. Com esse recurso, o exemplo do Flutter fica assim:

```dart
Widget build(BuildContext context) {
  return CupertinoPageScaffold(
    child: ListView(children: [
      Tab2Header(),
      ...buildTab2Conversation(),
      buildFooter()
    ]),
  );
}
```

Acredito que isso é uma melhoria real. Todos os filhos da list view ficam aninhados, bem juntinhos, em um único literal de lista. Isso fica mais bonito e também se dá melhor com a inferência de tipos. Com todos os elementos dentro da lista, podemos usar todos eles ao inferir o tipo da lista.

Estou mostrando um exemplo do Flutter aqui, mas passei muito tempo vasculhando um enorme corpus de código Dart para ver onde essa sintaxe seria útil, e ela aparece em vários lugares. Em particular, código que monta listas de argumentos de linha de comando para invocar outros programas se beneficia muito de spreads.

## Elementos {:#elements}

Antes de falar dos dois últimos recursos, quero aprofundar o que um spread realmente *é*. Vai parecer que estou insistindo no ponto, mas prometo que deixar isso claro vai ajudar mais tarde. Aqui vai uma pergunta que guia a discussão: *um spread é uma expressão?*

Parece que sim, porque ele aparece em um literal de lista, em um lugar onde se espera uma expressão:

```dart
var stuff = [1, ...things, 4];
```

Como uma expressão, você a avalia e ela produz alguns dados. Talvez seja uma expressão que avalia para um objeto [Iterable](https://api.dartlang.org/stable/2.2.0/dart-core/Iterable-class.html)? Mas, espere, isso não faz sentido. Isso é o que a expressão *dentro* do spread faz. Se você quer apenas uma expressão que avalie para um Iterable, não há necessidade de colocar o `...` antes dela.

Um spread não avalia para um único objeto Iterable; ele *desempacota* esse objeto e avalia para a *série* de objetos produzida pelo Iterable. Não seria útil então *reempacotar* isso em algum novo objeto. Mas uma expressão sempre avalia para um *único* objeto.

Se um spread fosse uma expressão, o que significaria usá-lo em outros lugares onde uma expressão é permitida?

```dart
var wat = ...things;
```

O que isso faria? Não faz sentido armazenar o Iterable inteiro como um objeto em `wat`. Se você quisesse isso, bastaria omitir o `...`. A resposta é que spreads *não são* expressões. Eles são uma categoria sintática diferente. O Dart, como muitas linguagens, já tem dois grandes grupos de sintaxe: statements e expressões.

Statements são executados, mas não produzem nenhum valor de resultado. Em vez disso, espera-se que tenham algum efeito colateral útil. Eles não podem ser usados em nenhum contexto em que um valor é necessário, porque não vão fornecer um. Por isso, por exemplo, isto é proibido:

```dart
var wat = for (var i = 0; i < 10; i++) print(i);
```

Um statement `for` não produz um valor, então não faz sentido colocá-lo em um inicializador de variável. Existem [linguagens que unificam expressões e statements](https://en.wikipedia.org/wiki/Expression-oriented_programming_language) e permitem código assim. Elas definem que cada statement é executado de alguma forma e *também* produz um valor. Mas o Dart não é uma dessas linguagens.

Expressões avaliam para um único valor de resultado. Você pode usá-las em lugares onde um valor é útil. Também existem os “[expression statements](https://www.eskimo.com/~scs/cclass/notes/sx3a.html)” — uma expressão seguida de ponto e vírgula —, que são statements que contêm uma única expressão. Isso é prático, já que muitas expressões também têm efeitos colaterais e são úteis mesmo quando o resultado não é necessário.

Um spread não é nenhuma dessas coisas. Um spread pode avaliar para zero valores (se você desempacotar uma coleção vazia), para um valor ou para muitos. Ele é uma categoria própria. Um bom nome para essa categoria seria “generator”. Meu modelo para isso vem de [Icon](https://en.wikipedia.org/wiki/Icon_(programming_language)#Generators), em que *toda* expressão pode ser um generator. Mas o Dart já tem [funções geradoras](https://www.dartlang.org/articles/language/beyond-async#generators), então não quis sobrecarregar o termo.

Um spread só pode aparecer em um lugar que consiga lidar com elegância com o recebimento de zero ou mais valores. Sem reformular completamente o modelo de execução da linguagem e transformá-la em Icon (o que, confesso, acho estranhamente atraente, mas provavelmente não é prático…), não há muitos lugares que atendam a essa restrição. Basicamente, literais de coleção e talvez listas de argumentos posicionais. (Escrevi [uma proposta para o último caso](https://github.com/munificent/ui-as-code/blob/master/in-progress/parameter-freedom.md), mas ela é bem complexa, então não estamos fazendo isso, pelo menos não agora.)

Isso deixa o interior do corpo dos literais de coleção. Por causa disso, eu chamo esses itens de “elementos”. Um elemento é um pedaço de código que, quando avaliado, produz zero ou mais valores. Esses valores são então interpolados, no lugar, no contexto ao redor onde aparecem. Assim, em uma lista, eles se tornam uma série de elementos da nova lista. Em um mapa, se tornam uma série de pares chave/valor. Você entendeu a ideia.

O corpo de um literal de coleção pode, portanto, conter expressões ou elementos. Permitir duas categorias é um pouco confuso, mas felizmente podemos simplificar dizendo que uma coleção só contém elementos. Depois definimos um “expression element” como um elemento que contém uma única expressão. Esse elemento sempre produz um resultado — o valor da expressão. Algo como o equivalente, em elemento, de um expression statement.

Pronto, é isso. Mudamos as coleções para conter elementos em vez de expressões e definimos dois tipos de elementos: spreads e expression elements. Para avaliar um literal de coleção, você percorre os elementos, avalia cada um e concatena (ou faz a união, no caso de um conjunto) todos os objetos resultantes.

Com esse modelo em mente, podemos passar pelos outros dois novos recursos:

## If em coleções {:#collection-if}

Escreva qualquer código Flutter e logo você vai dar de cara com casos em que a árvore de widgets que você quer construir muda com base em alguma condição. Digamos que temos:

```dart
Widget build(BuildContext context) {
  return Row(
    children: [
      IconButton(icon: Icon(Icons.menu)),
      Expanded(child: title),
      IconButton(icon: Icon(Icons.search)),
    ],
  );
}
```

Depois, decidimos que queremos usar um botão de busca diferente no Android. Você já consegue fazer isso com uma expressão condicional:

```dart
Widget build(BuildContext context) {
  return Row(
    children: [
      IconButton(icon: Icon(Icons.menu)),
      Expanded(child: title),
      isAndroid
          ? TextButton("Search")
          : IconButton(icon: Icon(Icons.search)),
    ],
  );
}
```

Isso funciona bem, embora eu nunca tenha achado o operador condicional do C muito fácil de ler. Muitas vezes, porém, você não quer *trocar* um widget com base em uma condição; quer simplesmente *omitir* um. Digamos que você não queira mostrar uma caixa de busca no Android. Hoje, os usuários do Flutter costumam usar um de dois padrões. Este é um deles:

```dart
Widget build(BuildContext context) {
  var children = [
    IconButton(icon: Icon(Icons.menu)),
    Expanded(child: title)
  ];

  if (!isAndroid) {
    children.add(IconButton(icon: Icon(Icons.search)));
  }

  return Row(children: children);
}
```

Ele obriga você a reorganizar a função inteira, tirando a lista de filhos para fora e construindo-a de forma imperativa antes de usá-la. O outro padrão fica assim:

```dart
Widget build(BuildContext context) {
  return Row(
    children: [
      IconButton(icon: Icon(Icons.menu)),
      Expanded(child: title),
      !isAndroid ? IconButton(icon: Icon(Icons.search)) : null,
    ].where((widget) => widget != null).toList(),
  );
}
```

Ele usa uma expressão condicional que às vezes produz um `null` e depois filtra esse `null` da lista resultante. Parabéns a quem teve essa ideia, mas nenhum usuário deveria ter que escrever isso para fazer uma tarefa tão simples. Problemas simples deveriam ter soluções simples, e pequenas mudanças conceituais no programa não deveriam exigir grandes mudanças no texto.

Aqui está o novo recurso. Para o primeiro exemplo, em que queremos um botão diferente no Android, fica assim:

```dart
Widget build(BuildContext context) {
  return Row(
    children: [
      IconButton(icon: Icon(Icons.menu)),
      Expanded(child: title),
      if (isAndroid)
        TextButton("Search")
      else
        IconButton(icon: Icon(Icons.search)),
    ],
  );
}
```

Em vez de `?:`, ele usa a sintaxe familiar de `if` e `else`. Isso é literalmente só alguns tokens diferentes da expressão condicional existente, então não parece justificar sua existência. O caso mais interessante é quando queremos *omitir* o botão no Android:

```dart
Widget build(BuildContext context) {
  return Row(
    children: [
      IconButton(icon: Icon(Icons.menu)),
      Expanded(child: title),
      if (!isAndroid)
        IconButton(icon: Icon(Icons.search)),
    ],
  );
}
```

Repare que não há cláusula `else`. Os dois exemplos parecem bem semelhantes a linguagens como Ruby, em que `if` é uma expressão. Mas uma expressão sempre precisa avaliar para um valor, mesmo quando a condição é falsa. Em Ruby, nesse caso, ela avalia implicitamente para `nil`.

Mas isso *não* é o que você quer aqui. Você não quer acabar com um elemento `null` na sua lista de widgets filhos. Por isso o exemplo da expressão condicional lá em cima precisou usar o incômodo `where()` para filtrar o `null`. Felizmente, aqui isso não é um problema. Porque um `if` dentro de uma coleção não é uma *expressão*. É um *elemento*.

Agora você entende por que eu te arrastei por todo aquele assunto dos spreads. Elementos nos dão a base para ter uma sintaxe de `if` que permite omitir completamente um elemento de uma coleção. O elemento `if` produz um único valor se a condição for verdadeira, ou se houver um caso `else`. Se a condição for falsa e não houver cláusula `else`, ele simplesmente não produz valor algum.

Acho esse comportamento muito útil, mas também é confuso se você olhar o código e esperar que o `if` se comporte como uma expressão simples.

## For em coleções {:#collection-for}

O recurso anterior pega uma forma de statement que já existe no Dart e a reaproveita para fazer algo útil no contexto de uma coleção. Existem outras formas de statement que valem a pena aproveitar?

A maioria não faz sentido. Colocar um statement `return` ali não faria nada útil, já que simplesmente sairia da função ao redor. O `while` também não é muito útil. Para sair de um loop `while`, o corpo normalmente contém um `break`, um `return` ou algum tipo de efeito colateral, como uma atribuição. Mas isso implica que o corpo contém *statements*, o que não é o que queremos. O objetivo é tornar as coleções mais *expressivas*, não mais *imperativas*.

Vasculhei vários literais de coleção em código existente procurando padrões que eu achava que poderiam melhorar com uma nova sintaxe. O principal, de longe, era o `if`. Mas vi vários lugares que acredito que poderiam melhorar com o `for`. Aqui está um exemplo ligeiramente limpo de um código que encontrei:

```dart
var command = [
  engineDartPath,
  frontendServer,
];
for (var root in fileSystemRoots) {
  command.add("--filesystem-root=$root");
}
for (var entryPoint in entryPoints) {
  command.add("$entryPoint.json");
}
command.add(mainPath);
```

Toda essa parte do `command.add()` parece desnecessariamente imperativa. Se permitirmos loops `for` dentro de um literal de coleção, isso vira:

```dart
var command = [
  engineDartPath,
  frontendServer,
  for (var root in fileSystemRoots) "--filesystem-root=$root",
  for (var entryPoint in entryPoints) "lib/$entryPoint",
  mainPath
];
```

## Compondo elementos {:#composing-elements}

Como já estamos adicionando spreads, a sintaxe de `for` não parece tão convincente. Não seria possível fazer a mesma coisa usando spread com alguma combinação de métodos de ordem superior em iteráveis? Sim, é possível. Você obteria algo assim:

```dart
var command = [
  engineDartPath,
  frontendServer,
  ...fileSystemRoots.map((root) => "--filesystem-root=$root"),
  ...entryPoints.map((entryPoint) => "lib/$entryPoint"),
  mainPath
];
```

Isso funciona e serve para alguns casos de uso. Vamos considerar um exemplo um pouco diferente. Digamos que queremos incluir um entry point somente se existir um arquivo JSON correspondente. Isso significa que não estamos fazendo um mapeamento simples 1 para 1. Usando apenas spreads, teríamos algo como:

```dart
var command = [
  engineDartPath,
  frontendServer,
  ...fileSystemRoots.map((root) => "--filesystem-root=$root"),
  ...entryPoints
      .where((entryPoint) => fileExists("lib/$entryPoint.json"))
      .map((entryPoint) => "lib/$entryPoint"),
  mainPath
];
```

Isso também funciona. Mas começa a ficar cada vez mais difícil traduzir a lógica simples de “se o arquivo existir, faça isto” para um estilo funcional baseado em streams e ordem superior. Sempre existe alguma combinação de `map()`, `where()` e talvez `transform()` que resolve o problema, mas pode parecer traduzir um haicai para notação polonesa reversa.

Existe uma solução mais limpa, e ela envolve uma pergunta-chave: qual é o *corpo* desses novos elementos `if` e `for`? Nos exemplos que mostrei até agora, ele sempre é uma expressão. Mas não há necessidade de restringir a isso. Em vez disso, permitimos que qualquer elemento vá ali. Em outras palavras, os três novos recursos podem ser compostos livremente. O código acima pode ser expresso assim:

```dart
var command = [
  engineDartPath,
  frontendServer,
  for (var root in fileSystemRoots) "--filesystem-root=$root",
  for (var entryPoint in entryPoints)
    if (fileExists("lib/$entryPoint.json")) "lib/$entryPoint",
  mainPath
];
```

Um `if` simples dentro de um `for`, exatamente como você faria se estivesse escrevendo statements imperativos. As semânticas de composição de elementos acabam sendo bem óbvias:

* Um elemento `if` produz todos os valores produzidos pela sua cláusula then se a condição for verdadeira; caso contrário, produz todos os elementos da cláusula “else”. Se não houver “else”, não produz elemento algum.

* Um elemento `for` produz a concatenação de todos os valores produzidos pelo seu elemento de corpo, a cada vez que o corpo é executado.

Isso habilita alguns padrões que acho legais. Um problema óbvio que você encontra é querer incluir ou omitir *vários* valores com base em uma única condição. Então, digamos que no exemplo anterior queremos pular tanto o título quanto a caixa de busca no Android. Você pode fazer isso envolvendo um spread em um `if`:

```dart
Widget build(BuildContext context) {
  return Row(
    children: [
      IconButton(icon: Icon(Icons.menu)),
      if (!isAndroid) ...[
        Expanded(child: title),
        IconButton(icon: Icon(Icons.search)),
      ]
    ],
  );
}
```

O spread é necessário aqui para desempacotar a lista interna. Caso contrário, quando não estivesse no Android, você incluiria a lista interna inteira como um único valor. (Consideramos achatar implicitamente em casos assim, com base nos tipos estáticos, mas isso fica bem duvidoso quando você pensa em como coisas como um `List&lt;Object&gt;` deveriam se comportar.)

Você pode pensar em usar spread em um literal de lista como o equivalente, em elementos, de um bloco com chaves para statements: ele permite colocar vários elementos em um lugar onde só se espera um. (Se você conhece o [operador vírgula](https://en.wikipedia.org/wiki/Comma_operator), essa é basicamente a forma análoga para expressões. Paralelos em todo lugar.)

Usar `for` e `if` dentro de um literal de coleção vazio dá uma sintaxe não muito distante da sintaxe especial de “list comprehension” suportada por outras linguagens, como Python:

```dart
[for (var i = 1; i <= 5; i++) if (i.isOdd) i * i] // [1, 9, 25].
```

Você pode até aninhar `for`:

```dart
[for (var x in hor) for (var y in vert) Point(x, y)]
```

Isso constrói uma lista contendo o [produto cartesiano](https://en.wikipedia.org/wiki/Cartesian_product) de todos os pontos dos retângulos `hor` e `vert` dados.

Além disso, esses novos recursos funcionam em vários tipos de coleção. Eu usei listas como exemplo porque aparecem com mais frequência, mas todos esses recursos também funcionam dentro de mapas e conjuntos. A única diferença é que, em conjuntos, duplicatas são descartadas implicitamente. E, em mapas, em vez de elementos de expressão primitivos, o elemento básico é um par chave/valor. Por exemplo, isto:

```dart
Map<String, WidgetBuilder>.fromIterable(
  allGalleryDemos.where((demo) => demo.exists),
  key: (demo) => '${demo.routeName}',
  value: (demo) => demo.buildRoute,
);
```

pode ser reescrito como:

```dart
{
  for (var demo in allGalleryDemos)
    if (demo.exists) '${demo.routeName}': demo.buildRoute,
};
```

Uma preocupação real que temos com todos esses recursos é que estamos essencialmente dando novas formas de expressar coisas que você já consegue expressar hoje. Isso tem um custo, porque os usuários precisam gastar energia mental [decidindo *qual* recurso usar](https://en.wikipedia.org/wiki/Hick%27s_law), e ao ler o código dos outros, podem gastar tempo questionando por que uma opção foi escolhida em vez da outra. Simplesmente há mais recursos para aprender, e a linguagem fica maior.

Passamos muito tempo [nos atormentando com isso](https://github.com/munificent/ui-as-code/blob/master/Choices.md). Às vezes, simplesmente não fazer nada é o melhor design. A simplicidade tem muito valor, e é raro ter a chance de tornar uma linguagem mais simples com o tempo. No entanto, depois de olhar muito código e de trabalhar com uma pesquisadora de UX excelente em um estudo, estamos bastante confiantes de que esses recursos são leves e úteis o bastante para justificar sua existência.

Como em qualquer mudança de linguagem, você nunca sabe de fato como ela vai funcionar até chegar às mãos dos usuários. Esses recursos devem chegar às suas mãos no próximo lançamento, o Dart 2.3, e estou muito animado para ver o que vocês vão fazer com eles.
