---
ia-translate: true
title: "Decisão sobre a sintaxe de nulabilidade do Dart: a?[b] ou a?.[b]"
description: "O Dart está redesenhando seu sistema de tipos para que cada tipo seja anulável (expressões desse tipo podem ter o valor null) ou não anulável…"
publishDate: 2019-08-26
author: kwalrath
image: images/1se-VT1aPyHd3J2VYDzDW5g.webp
category: other
layout: blog
---

> Atualização (3/2021): Graças ao seu feedback, a equipe do Dart [decidiu usar a sintaxe a?[b]](https://github.com/dart-lang/language/issues/376#issuecomment-576924506).

O Dart está [em processo](https://github.com/dart-lang/language/issues/110) de redesenho do seu sistema de tipos para que cada tipo seja *anulável* (expressões desse tipo podem ter o valor null) ou *não anulável*. Mais adiante este ano, contaremos mais sobre o cronograma e o processo de lançamento, mas, com o tempo, o código Dart será não anulável por padrão (*NNBD*), e você precisará usar uma sintaxe especial para dizer que um tipo aceita valores null.

Por exemplo, para declarar que um inteiro pode ser null, você precisará adicionar um `?` após o tipo:

```
int? someInt; // someInt can be null.
```


Essa sintaxe com ponto de interrogação pode ser familiar se você já viu código em Kotlin, Swift ou C#. Mas algumas coisas são diferentes, principalmente o operador de subscrito (`[]`), que você mais comumente vê usado para acessar listas ou arrays. C# e Swift usam `?[]`. O plano atual para o Dart (e, aliás, para o [ECMAScript](https://github.com/tc39/proposal-optional-chaining#syntax)) é usar `?.[]`:

```
e1?.[e2] // null if e1 is null; otherwise it’s e1[e2]
```


Este artigo mostra os bastidores para explicar o raciocínio por trás dessa decisão e para incentivar você a dar sua opinião e suas sugestões. A maior parte deste conteúdo é baseada em um [comentário de Bob Nystrom](https://github.com/dart-lang/language/issues/376#issuecomment-497121257) ([munificent](https://github.com/munificent)) na issue de linguagem [#376](https://github.com/dart-lang/language/issues/376), que resume uma discussão entre Bob e o responsável pela especificação do NNBD, Leaf Petersen ([leafpetersen](https://github.com/leafpetersen)).

## **Por que usar um ponto?** {:#why-use-a-dot}

As duas opções para `[]` têm vantagens.

`e1?[e2]`:

* Segue C# e Swift

* É concisa

* É parecida com a sintaxe do operador `!` (que você poderá adicionar após uma expressão para dizer que o valor dela não é null, mesmo que ela tenha um tipo anulável): `e1![e2]`

`e1?.[e2]`:

* É parecida com a sintaxe de cascata: 
`e1..[e2] // cascade syntax
e1?..[e2] // null-aware cascade syntax`

* É parecida com a outra sintaxe de método null-aware: `e1?.e2()`

* Se estende naturalmente a outros operadores

* Evita a ambiguidade no código a seguir: `{ e1 ? [e2] : e3 }`

Passamos um bom tempo tentando encontrar formas de evitar a ambiguidade de `?[`. O problema é que não dá para saber se um código como `{ e1 ? [e2] : e3 }` é um [literal de conjunto](https://dart.dev/guides/language/language-tour#sets) que contém o resultado de uma expressão condicional, ou um [literal de mapa](https://dart.dev/guides/language/language-tour#maps) que contém o resultado de um subscrito null-aware.

Se adicionarmos parênteses para tornar esse código não ambíguo, poderíamos escolher colocá-los em volta da expressão inteira, `{ (e1 ? [e2] : e3) }`, tornando-o inequivocamente um literal de conjunto. Ou poderíamos colocá-los em volta da primeira parte, `{ (e1 ? [e2]) : e3 }`, tornando-o inequivocamente um literal de mapa. Mas, na ausência de parênteses, o parser não sabe o que fazer.

Existem várias soluções para essa ambiguidade, mas nenhuma parece muito satisfatória. Uma abordagem é depender de espaços em branco para distinguir as opções. Nela, você sempre trata `e1 ? [e2]` como o início de uma expressão condicional, porque há um espaço entre o `?` e o `[`. E você sempre trata `e1?[e2]` como um subscrito null-aware, porque não há espaço entre esses dois tokens. Mas depender de espaços em branco pode prejudicar muito a experiência do usuário.

Em teoria, depender de espaços em branco não é um problema em código formatado. Mas muitos usuários escrevem código Dart não formatado como entrada para o formatador. E esse formato de entrada se tornaria, assim, mais sensível e frágil a espaços nesse canto da linguagem. Até agora, esses tipos de canto são muito raros no Dart, o que é um recurso interessante. (Um desses cantos é que `— — a` e `--a` são ambos válidos, mas têm significados diferentes.)

Ignorando a ambiguidade, há outro motivo para usar o ponto: se adicionarmos formas null-aware para outros operadores, como `e1?.+(e2)`, provavelmente vamos querer exigir o ponto, e nesse caso exigi-lo também para o subscrito é consistente com esse futuro.

Outra adição que discutimos para o NNBD é uma sintaxe de chamada null-aware. Se não exigirmos um ponto ali, ela tem exatamente o mesmo problema de ambiguidade:

```
var wat = { e1?(e2):e3 }; // Map or set?
```


Qualquer correção que encontrarmos para o `?[`, também teremos que aplicar ao `?(`.

Por fim, considere este exemplo de encadeamento de subscritos:

```
someJson?[recipes]?[2]?[ingredients]?[pepper]
```


Para nossos olhos, isso não fica muito bom. Parece menos uma cadeia de métodos e mais uma combinação de operadores infixos, um pouco como `??`. Compare com este código:

```
someJson?.[recipes]?.[2]?.[ingredients]?.[pepper]
```


Aqui, fica mais claramente uma cadeia de métodos. Comunicar isso visualmente também é importante, porque os usuários precisam entender rapidamente quanta parte de uma expressão será interrompida por null.

Juntando tudo isso, parece que devemos usar a forma `?.[` pelos seguintes motivos:

* Evita problemas de ambiguidade. (O lexer já trata `?.` como um único token “null-aware”.)

* Se estende naturalmente a uma chamada null-aware.

* Se estende a outros operadores null-aware.

* Deixa o Dart como uma linguagem de entrada mais robusta para o formatador.

* Fica bastante bom em uma cadeia de métodos.

* Deixa visualmente mais claro quanto de uma cadeia de métodos pode ser interrompido por null.

## O que você acha? {:#what-do-you-think}

Estamos sempre interessados em feedback e sugestões. A melhor forma de dar feedback sobre essa sintaxe é comentar (ou dar um joinha em um comentário) na [issue de linguagem #376](https://github.com/dart-lang/language/issues/376). Já que você está lá, considere também conferir todos os outros recursos legais de linguagem em que estamos trabalhando.

Aqui está onde você pode encontrar mais informações:

NNBD:

* [Especificação do recurso](https://github.com/dart-lang/language/blob/master/accepted/future-releases/nnbd/feature-specification.md)

* [Roadmap](https://github.com/dart-lang/language/blob/master/accepted/future-releases/nnbd/roadmap.md)

* [Issues](https://github.com/dart-lang/language/issues?utf8=%E2%9C%93&q=label%3Annbd)

Outras mudanças e recursos da linguagem Dart:

* [Status das mudanças da linguagem](https://github.com/dart-lang/language/projects/1)

* [Processo de evolução da linguagem](https://github.com/dart-lang/language/blob/master/doc/life_of_a_language_feature.md#dart-language-evolution-process)

* [Especificação da linguagem Dart](https://dart.dev/guides/language/spec)

<DashImage src="images/1se-VT1aPyHd3J2VYDzDW5g.webp" alt="Uma declaração de função demonstrando um tipo de retorno anulável e um argumento anulável." caption="Uma função que aceita um argumento null e pode retornar null." />
