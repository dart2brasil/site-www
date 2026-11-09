---
ia-translate: true
title: "Future<void> vs Future<Null>, qual é a diferença?"
description: "Uma das melhorias legais que conseguimos fazer no Dart 2 (além de uma verificação estática melhor, segurança de tipos em tempo de execução, new/const opcionais, melhorias na biblioteca core e mais) é…"
publishDate: 2018-10-30
author: mfairhurst
image: images/0x0J9DBRyATjtQn42.webp
category: deep-dive
layout: blog
---


Uma das melhorias legais que conseguimos fazer no [Dart 2](/blog/announcing-dart-2-stable-and-the-dart-web-platform) (além de uma verificação estática melhor, segurança de tipos em tempo de execução, new/const opcionais, melhorias na biblioteca core e mais) é formalizar o `void` de um jeito ao mesmo tempo mais útil e menos sujeito a erros. Isso fica especialmente limpo na programação assíncrona, onde você pode escrever `Future&lt;void&gt;` para funções assíncronas que não retornam uma resposta quando o trabalho termina. Antes disso, você provavelmente usava `Future&lt;Null&gt;`, então as perguntas mais comuns que recebemos são: qual é a diferença entre `Future&lt;void&gt;` e `Future&lt;Null&gt;`? Qual devo usar, e quando?

<DashImage src="images/0x0J9DBRyATjtQn42.webp" alt="Meme retrô de um homem fazendo um gesto ao lado do texto 'VOID*'." />


Como meu objetivo aqui é ser útil, vou começar com um TLDR.

TL;DR: **Você quer usar o tipo void 99,99% das vezes.**

Também recomendo que você ative, agora mesmo, duas [regras de lint](https://www.dartlang.org/guides/language/analysis-options) relacionadas a `void` nos seus projetos:

* **prefer_void_to_null:** ajuda você a não voltar ao hábito de digitar o `Null`, em grande parte ultrapassado.

* **void_checks:** oferece uma semântica de "vazio" que você pode achar mais intuitiva, embora ela não seja estritamente necessária para um código seguro.

O resto deste artigo não é leitura leve. É uma combinação de história, casos de borda e teoria de tipos. O que estou prestes a escrever é como tentar explicar uma [Monad](https://en.wikipedia.org/wiki/Monad_(functional_programming)), mas vou fazer o meu melhor, e espero que você acompanhe a viagem.

## Curiosidades rápidas sobre Future&lt;Null&gt; {:#quick-futurelt-nullgt-trivia}

Para demonstrar o valor que você pode tirar da leitura deste post, proponho uma pergunta de curiosidade.

Digamos que nos limitemos a dois `Future`s: um `Future&lt;User&gt;` e um `Future&lt;Null&gt;`. O que as linhas de código a seguir fazem?

```
// does this fail in your editor?
Future<User> f1 = Future<Null>.value(null);

// does this fail at runtime?
Future<Null> f2 = Future<User>.value(0);
```


Ajuda se trocarmos para awaits?

```
User u = await Future<Null>.value(null);
Null n = await Future<User>.value(0);
```


**pausa para efeito dramático**

A resposta é que nenhuma dessas quatro linhas vai mostrar erro no seu editor, a menos que você tenha desativado os downcasts implícitos. Isso mesmo: pegar um `Future&lt;Null&gt;` e fingir que é outra coisa, como um `Future&lt;User&gt;`, é 100% legal. Esse não é o caso de `Future&lt;void&gt;`!

Também de forma pouco intuitiva, a segunda e a quarta linhas falham em tempo de execução (não é "seguro" descartar o resultado de um `Future` dessa forma), e as outras têm sucesso silenciosamente.

Esses comportamentos devem deixar você desconfortável. Mas não se preocupe! Você já conhece a solução: use `Future&lt;void&gt;`. Vou detalhar por que esse comportamento pouco intuitivo funciona assim.

## Como o void funciona hoje {:#how-void-works-now}

Eu fiquei bastante na dúvida sobre qual seria a melhor ordem para este artigo. Há muitos conceitos para explicar aqui. No entanto, vou tentar seguir a ordem de informação mais útil para a menos útil. Portanto, como `void` é muito mais útil do que `Null` no Dart 2, faz sentido começar com a semântica do `void` no Dart 2.

A ideia fundamental por trás de `void` no Dart vem do objetivo de que um valor `void` não deve ser usado.

```
void f() {}
print(f()); // error!
```


Espero que isso seja exatamente o que você esperava que acontecesse! Até aqui, tudo bem.

Vale notar que alcançar esse objetivo *e* tornar `void` um tipo bastante normal pode ficar um pouco estranho:

```
f(void argument) {
  print(argument); // Error!
  // we can receive the argument, but we may not use it!
}
```


É aqui que, no Dart 2, nosso novo "void generalizado" começa a ficar interessante e poderoso… embora às vezes confuso.

Faço a você a pergunta: que tipo de valor poderíamos passar como argumento de `f`?

```
f(void argument) { … }
f(x); // what is x?
```


A resposta é… qualquer coisa! Como não permitimos que você use o valor de `x` dentro da função `f`, podemos afirmar com confiança que *não há nenhum valor* que `x` possa assumir *que possa causar algum erro de tempo de execução*.

```
f(1); // will have no difference compared to
f(“foo”); // will have no difference compared to
f([1, 2, 3]); // will have no difference compared to
// ...
```


Se derivarmos a melhor semântica para `void` com base na ideia de que é um valor que não será *usado*, é isso que obtemos. O que significa que é um valor que pode ser *preenchido* com absolutamente qualquer coisa. É como um vácuo: uma entrada sem saída.

Agora, há casos em que algo nunca causa erro em tempo de execução, mas ainda assim deveria causar erros estáticos. Este é um ótimo caso para um lint! E é exatamente essa a ideia por trás do lint `void_checks`. Ele procura lugares onde você passa qualquer coisa diferente de `null` para uma posição `void`, e eu recomendaria que as equipes o ativassem. Ele não é necessário para a solidez do código, mas passar qualquer coisa que não seja `null` para uma posição `void` ainda é provavelmente um acidente, que o lint vai sinalizar para você.

Como tudo isso se baseia em teoria de tipos fundamental, `void` funciona bem com todas as partes do Dart, até mesmo em continuações que usam inferência de tipos no contexto de um `Future&lt;void&gt;`:

```
Future<void>().then((x) {
  print(x); // error! x has type “void” so you can’t print it!
  // This is what we want!
});

// and yes, this is an error too:
Foo f = await voidFuture();
```


Neste ponto, o desenvolvedor médio provavelmente já sabe tudo o que precisa saber sobre `void` para usá-lo com eficácia.

<DashImage src="images/0_2MNvj3It63IUFUH.webp" alt="GIF de reação de robô com a legenda 'Parabéns. Você está sendo resgatado'." />


Se você ainda está acompanhando, porém, há algumas outras pepitas interessantes.

Mesmo com `void_checks` ativado, posições `void` não vão necessariamente conter `null`. Veja este override:

```
class A {
  void f(Object o) {}
}

class B extends A {
  @override
  Object f(Object o) => o;
}
```


Não queremos tornar esse override ilegal, porque ele é seguro, útil e seria uma mudança incompatível em relação ao Dart 1. E assim somos forçados a aceitar que posições `void` podem conter qualquer valor. Também não podemos "otimizar" o valor que `A.f()` retorna, porque, em tempo de execução, ele pode ser um `B`!

Em vez disso, temos a opção inteligente de tornar `void` um tipo irmão de `Object`. Afinal, ele pode conter qualquer valor, e todos os valores são `Object`s. Não fomos nós que projetamos isso, é apenas a realidade. Reconhecer essa realidade faz com que seja algo que podemos aproveitar.

<DashImage src="images/01ZUU5fNh-kmpPzMU.webp" alt="Texto de meme: 'Preparem-se. A compatibilidade com versões anteriores está chegando'." />


Ao tornar `void` um irmão de `Object`, não nos impomos *nenhum requisito* de que um valor `void` fique *completamente* sem uso. Fazemos o nosso melhor para manter `void` isolado, mas relaxamos deliberadamente essas restrições em alguns pontos por causa da compatibilidade com versões anteriores:

```
dynamic f() => voidFn(); // this is legal
voidFn() as dynamic; // this is legal
```


São casos especiais que seriam legais para um `Object`, e tornamos isso legal para `void` também, para facilitar a adoção do Dart 2.

Tornar `void` um irmão de `Object` também significa que `void` pode ser usado como parâmetro de tipo sem inflar o código compilado (sem "template specialization", para quem vem do C++). Essa redução é boa para manter apps web e Flutter pequenos, ao custo de permitir o seguinte:

```
<void>[1, 2, 3].toString(); // this is legal and prints [1, 2, 3]
```


E, por fim, pode parecer inútil tipar um parâmetro como `void`, principalmente porque ele é uma forma de `Object`. No entanto, valores `void` podem ser *passados para* posições `void`:

```
f(void x) { … }
f(voidFn()); // this is legal
```


Isso é útil para *sequenciamento*, que é usado, por exemplo, pelo [Mockito](https://pub.dartlang.org/packages/mockito) ao simular métodos que retornam `void`. (Substitua `f` por `when` no código acima para uma aproximação mais fiel.)

Em resumo:

* O tipo `void` é um irmão de `Object`.

* Quase sempre, um objeto `void` não pode ser usado.

* Algo marcado como `void` pode ser, na prática, absolutamente qualquer coisa.

* Qualquer coisa pode ser "jogada fora" em uma posição marcada como `void`, e o lint `void_checks` restringe esse comportamento.

* Um valor `void` pode ser passado para outras posições `void`.

## O tipo inferior (bottom) {:#the-bottom-type}

Antes de falar sobre `Null`, é fundamental que falemos sobre o tipo "inferior", ou "bottom".

Este é um tipo que surge naturalmente na teoria de tipos, com uma definição acadêmica curta e algumas aplicações práticas.

Se você parar de ler esta seção porque ela é *estranha demais*, isso é forte evidência do meu TLDR original. A menos que você queira que seu código seja igualmente estranho, provavelmente você quer `void`. Agora, vamos explorar essa toca do coelho e ver até onde ela vai, certo?

O tipo bottom é o subtipo de todos os tipos. Em termos mais simples de orientação a objetos, isso significa que ele é um `Person`. E um `Car`. E um `Animal`. E todos os outros tipos de todos os programas já escritos.

Se isso soa absurdo, é porque é mesmo. Gosto de pensar nele como um tipo "marcador de posição". Mas "tipo absurdo" ou "imaginário" também seria um nome razoável. Em vez disso, ele se chama tipo *bottom* porque é o fundo da hierarquia de tipos, que, na ciência da computação, é de cabeça para baixo. ¯\_(ツ)_/¯ Formalmente, ele pode ser representado pelo símbolo ⊥, que você talvez reconheça como o símbolo de "falso".

Se você tentar imaginar um valor que seja um `Person` *e* um `Car` *e* um `Animal`, não vai conseguir pensar em nada. E, surpreendentemente, é daí que vem o uso prático de ⊥!

E se eu escrever uma função que nunca retorna? Há duas maneiras simples de fazer isso:

```
loopForever() {
  while(true); // first way
}

alwaysThrow() {
  throw Exception(); // second way
}
```


Qual é o melhor tipo de retorno para essas duas funções?

Depende. Como a função nunca retorna, o tipo de retorno não importa muito. Você pode usar qualquer tipo, até mesmo o tipo absurdo bottom, que pode ser usado de várias maneiras em diferentes linguagens.

<DashImage src="images/0TkwIX5BsrbSzHfLr.webp" alt="Texto de meme: 'Você não pode ter um erro de tempo de execução em código que nunca roda'." />


C++ tem isso como `noreturn`. Rust tem `!`, e Scala tem `Nothing`. Mas meu exemplo favorito vem do Haskell, que tem a função `undefined`, bastante usada, que aborta o programa. Ela retorna, adivinhe, o tipo bottom.

Se assumirmos uma função `undefined` em Dart como a do Haskell, que simplesmente lança uma exceção quando chamada e retorna ⊥, ela ficaria assim:

```
Foo foo = cond ? val : undefined();
```


Na linha de uso do exemplo, o programa pode rodar com segurança e armazenar `val` quando `cond` é verdadeiro. E quando `cond` é falso, o programa vai lançar uma exceção durante `undefined()`. É seguro "armazenar" o resultado de `undefined()` em `foo`, independentemente do tipo de `foo`, porque esse armazenamento nunca vai acontecer de fato!

`undefined()` ****aqui não retorna nada. Mas a lição aqui não é que podemos deixar `foo` vazio… é que o tipo bottom é vazio como uma promise vazia. É mais vazio que vazio. Simplesmente nunca acontece.

Uma coisa que preciso ter cuidado em dizer é que você pode e, dependendo do uso, muitas vezes deve retornar `void` dessas funções na prática. Normalmente, código como `return loopForever()` é mais provável de ser um erro do que um padrão útil. No entanto, a escolha é sua.

O tipo bottom também é útil para listas vazias somente leitura. No Dart, `List`s são covariantes, então uma `List&lt;int&gt;` pode ser usada como uma `List&lt;Object&gt;`. Se você então tentar colocar uma `String` dentro dessa `List&lt;Object&gt;`, uma verificação em tempo de execução vai pegar isso e lançar um erro.

Isso significa que, se criarmos uma `List` de ⊥, não há nada que possamos colocar nela, mas podemos tratá-la como uma lista de qualquer coisa:

```
List<int> intList = <⊥>[];
  for(int i in intList) {
  print(i * 2); // valid, because this simply never happens
}
```


Há casos ainda mais interessantes quando olhamos para o que se chama de posicionamento "contravariante" do tipo bottom.

<DashImage src="images/0OyVAekp1iwSQyfur.webp" alt="Meme em close de uma pessoa fazendo um gesto com a palavra 'Contravariância'." />


Digamos que definimos uma função que tem um parâmetro ⊥:

```
void f(⊥ x) {}
```


Isso é quase o oposto do exemplo de `undefined()`. Em vez de uma função que nunca retorna, declaramos uma função que não pode ser chamada! Nenhum valor real pode ser atribuído a esse parâmetro `x`. Você não pode passar um `Person`, porque ele *não é também um* `Car`, e você não pode passar um `Car`, porque ele não é também um `Person`. A única coisa que você poderia passar é o próprio tipo absurdo:

```
f(undefined());
```


Mas, como vimos antes, `undefined()` nunca retorna, então `f()` ainda nunca é realmente chamada neste caso!

Tipar um parâmetro como ⊥ pode parecer inútil, mas tem um valor esotérico, porque todas as funções que *podem* ser chamadas são subtipos das funções que *não podem*. **(Pense nisso: uma função que *pode* ser chamada não *precisa* ser chamada. E se uma função não é chamada, ela não pode produzir erros de tempo de execução.)

Se você ainda está acompanhando, respire fundo e dê um tapinha nas próprias costas.

Especificamente, é seguro fazer cast de qualquer `Function(X)` para `Function(⊥)`, para qualquer `X`. Isso é melhor do que usar o tipo `Function` genérico do Dart, porque é mais específico.

Com isso, você pode, por exemplo, armazenar qualquer função unária em um campo e chamá-la dinamicamente, para contornar erros estáticos e substituí-los por erros de tempo de execução se você cometer um engano:

```
Function(⊥) f;
f = (int x) => x + 1;

// the validity of 123 as an argument to f is checked at runtime
(f as dynamic)(123);
```


É um truque útil para se virar em uma emergência.

Agora podemos falar sobre `Null`.

## Null no Dart 2 {:#null-in-dart-2}

O tipo "inferior" conceitual (um tipo que é subtipo de todos os tipos) existe no Dart, mas isso não é tudo. Esse valor também existe no Dart 2! No Dart, chamamos isso de `Null`, e esse valor é, como você deve ter adivinhado, `null`.

Como eu posso tornar qualquer coisa `null`(/`Null`), o tipo absurdo não é tão absurdo assim no Dart. O que o torna um pouco complicado.

Observação: o valor `null`, claro, não é um `Car`, nem um `Person`. E recebemos pedidos de tipos não nuláveis no Dart. Então, se fizermos essa mudança no Dart, vamos precisar de um novo tipo bottom, provavelmente com um nome como `Nothing`, e ele será um tipo bottom mais verdadeiro.

Não só o `Null` tem todos os mesmos usos absurdos do tipo bottom, como também tem uma válvula de escape. Se algum dia você realmente precisar retornar de uma função que não pode retornar, ou chamar uma função que não pode ser chamada, temos uma saída! Você pode passar `null` ali! Seria, sinceramente, um pouco injusto da nossa parte fazer diferente, quando se olha para o quadro completo.

No entanto, isso traz muitas ressalvas a uma declaração que, de outra forma, seria simples:

```
Null nothing() => null;
```


`Null` é o tipo mais específico para `foo()`, então é uma escolha lógica e um bom ponto de partida. O analyzer também é gentil o suficiente para avisar você se chamar métodos nele que não existem:

```
nothing().x; // error! No member x on Null
```


Mas isso pode dar uma falsa ilusão de segurança.

```
nothing().toString(); // no error: Null defines toString()
Foo foo = nothing(); // no error: foo will become null

// Acceptable for all parameter types in f(x),
// runtime errors if f(x) expects non-null
f(nothing());
```


Se o seu objetivo é que `nothing()` seja um sinônimo de `null`, então esse é o comportamento que você quer, e `Null` é o tipo correto para a sua função que retorna `null`.

Havia boas razões para sugerir `Future&lt;Null&gt;`, e isso funcionou enquanto estávamos definindo a nova semântica de `void`. No entanto, ele tem as mesmas brechas:

```
(await futureNull()).toString(); // no error!
Foo foo = await futureNull(); // no error!
```


Essencialmente, ao fazer uma função `f()` retornar um `Future&lt;Null&gt;`, você está tornando `await f()` um sinônimo de `null` no seu programa! Isso é perigoso, porque você pode usar `null` como se fosse absolutamente qualquer coisa, absolutamente qualquer tipo. Não acho que seja isso que a maioria das pessoas quer.

<DashImage src="images/04NDBhLva40BBuX0f.webp" alt="Texto de meme: 'Null não é o tipo que você está procurando'." />


Por que mais você usaria `Future&lt;Null&gt;` em vez de `Future&lt;void&gt;`? Tudo volta àquele tipo bottom de tirar o fôlego. Você pode considerar `Future&lt;Null&gt;` para futures que precisam ser aguardáveis, mas que nunca completam, ou que sempre completam com um erro. Isso é diretamente comparável ao motivo pelo qual uma função retornaria `Null`.

A mesma lógica se aplica a `Stream&lt;Null&gt;`: use esse tipo para um `Stream` que nunca envia nenhum evento. Isso é diretamente comparável ao motivo pelo qual uma lista vazia somente leitura pode ser tipada como `List&lt;Null&gt;`.

Alguns tipos mais complicados, para os quais é difícil dar uma diretriz, são `StreamController&lt;Null&gt;` e `Sink&lt;Null&gt;`. Eles são comparáveis a funções. A razão mais sólida para usar esses tipos é dizer que eles nunca devem ser usados. A próxima razão mais sólida é que você gostaria que eles aceitassem apenas sinônimos de `Null`, o que só é razoável se você não tiver `void_checks` ativado.

Imagine que o Dart não tivesse `null` como válvula de escape para todos os valores. Você gostaria de criar um tipo `Sink&lt;⊥&gt;` que só aceita eventos de um `Stream&lt;⊥&gt;`, que por sua vez nunca transmite um evento? Se a resposta for sim, então vá em frente e crie um `Sink&lt;Null&gt;`.

Todos esses usos têm garantias fracas, porque o valor `null` em si é uma válvula de escape, e é justamente por isso que você mais provavelmente usaria o próprio tipo `Null`. No entanto, não cometa o erro de pensar que o *valor* é a válvula de escape, e não o bunker. Um é seguro e robusto; o outro serve para poupar você do esforço de cavar para cima através de concreto armado quando o bunker pega fogo com você dentro.

<DashImage src="images/0yepcr98D1YlpsRJF.webp" alt="Texto de meme: 'Eu não uso null no meu código Dart sempre, mas quando uso, deixo um comentário longo explicando por quê.'" />


Em resumo, estes são os principais usos de tipar algo como `Null`:

* Como sinônimo de `null`, utilizável em todo lugar como qualquer coisa

* Como marcador de posição para uma execução que o seu programa nunca vai alcançar

* Como um contêiner que deve permanecer vazio para poder se passar por qualquer tipo

* Como uma saída sem entradas

## Comparação final {:#final-comparison}

*Se você chegou até este ponto do artigo, merece algum tipo de recompensa: entre em contato comigo e vejo se consigo pagar uma cerveja para você na próxima vez que você estiver livre em Portland, OR. :)*

Falei bastante sobre o tipo bottom, mas não entrei de forma alguma em seu oposto, o Top. O tipo top é, como você imaginaria, o oposto polar do tipo bottom. E, enquanto o nome que o Dart dá ao tipo bottom é `Null`, o nome que ele dá ao tipo top é um entre `dynamic`, `Object` e `void` (três cabeças da mesma moeda).

Pode parecer estranho que palavras como "nothing" e "empty" em inglês possam significar duas coisas tão diferentes na teoria de tipos. Ambas são descrições adequadas dos tipos top e bottom, exatamente opostos, e, portanto, de `Null` e `void`. Pode parecer estranho que dois tipos opostos sejam candidatos atraentes para o mesmo trabalho! Pode parecer frustrante que o Dart tenha tantas peculiaridades e casos de borda, agora que você está estudando qual usar.

<DashImage src="images/0ybPT9jlu0yGAnu2v.webp" alt="Uma ilustração mostrando frustração com as peculiaridades e os casos de borda da teoria de tipos." />


Nosso erro, acho, foi ter recomendado o uso de `Null` como `void` em primeiro lugar. Na época, teria sido um desserviço aos usuários omitir o que era um conselho útil, dada a semântica do Dart 1. Mas acidentalmente tornamos um tipo *muito* esotérico *muito* comum.

Bom, agora você leu o artigo. O que você acha? Você espera encontrar um uso válido para `Null` em breve? Você tem uma compreensão firme de onde ele é útil?

E, mais importante, você pode nos ajudar a espalhar a boa notícia de que `void` está aqui para simplificar tudo?
