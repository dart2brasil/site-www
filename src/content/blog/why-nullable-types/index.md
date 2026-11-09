---
ia-translate: true
title: "Por que tipos nuláveis?"
description: "null no código Dart indica que uma variável não tem valor, mas algumas linguagens não permitem null. Saiba por que as duas abordagens funcionam."
publishDate: 2020-12-07
author: munificent
image: images/1ihpy1Ngzg7SczCKkuh_WhQ.webp
category: other
layout: blog
---


Há algumas semanas, anunciamos o beta do null safety do Dart, um recurso de produtividade importante, feito para ajudar você a evitar erros de null. Falando em valores null, no subreddit /r/dart_lang [um usuário perguntou recentemente](https://www.reddit.com/r/dartlang/comments/jruhji/why_does_nnbd_dart_still_have_null/gbwi364/):
> Mas por que ainda temos (e queremos) valores null? Por que não nos livrarmos deles de vez? Eu também estou brincando com Rust, e ele não tem null nenhum. Então parece possível viver sem eles.

Eu adoro essa pergunta. Por que *não* eliminar `null` por completo? Este artigo é uma versão expandida do que respondi naquela thread.

A resposta curta é que, sim, é totalmente possível viver sem `null`, e linguagens como Rust fazem isso. Mas programadores *usam* `null`, então, antes de tirá-lo, precisamos entender por que ele é usado. O que `null` normalmente *faz* quando o usamos em linguagens que o têm?

Acontece que `null` costuma representar a *ausência* de um valor, o que é extremamente útil. Algumas pessoas não têm nome do meio. Alguns endereços não têm número de apartamento. Alguns monstros não deixam tesouro algum quando você os derrota.

Nesses casos, queremos uma forma de expressar: “esta variável pode ter um valor do tipo X, ou pode não ter valor algum”. A pergunta, então, é como modelar isso?

Uma opção é dizer que uma variável pode conter um valor do tipo esperado, ou pode conter o valor mágico `null`. Se tentarmos usar o valor quando ele for `null`, teremos uma falha em tempo de execução. Foi isso que o Dart fez antes do null safety, o que o SQL faz, o que o Java faz para tipos não primitivos e o que o C# faz para tipos de classe.

Mas falhar em tempo de execução é ruim. Significa que nossos usuários é que encontram o bug. Nós, programadores, preferimos encontrar essas falhas antes deles. Na verdade, ficaríamos felizes se pudéssemos encontrar os bugs até antes de *nós* executarmos o programa. Então, como modelar a ausência de um valor de um jeito que o sistema de tipos entenda? Em outras palavras, como dar tipos estáticos diferentes para valores “potencialmente ausentes” e valores “definitivamente presentes”?

Há duas soluções principais:

1. Use um tipo option ou maybe

1. Use um tipo nulável

## Solução 1: tipos Option {:#solution-1-option-types}

Esta é a abordagem do [ML](https://en.wikipedia.org/wiki/ML_(programming_language)) e da maioria das linguagens funcionais derivadas do ML (incluindo Rust, Scala e Swift). Quando sabemos que teremos definitivamente um valor, simplesmente usamos o tipo subjacente. Se escrevemos `int`, significa: “com certeza há um inteiro aqui”.

Para expressar um valor potencialmente ausente, *envolvemos* o tipo subjacente em um [tipo option](https://en.wikipedia.org/wiki/Option_type). Assim, `Option&lt;int&gt;` representa um valor que pode ser um inteiro ou pode não ser nada. É como um tipo de coleção que pode conter zero ou um item.

Do ponto de vista do sistema de tipos, não há relação direta entre `int` e `Option&lt;int&gt;`. Tratar os dois como tipos distintos significa que não podemos passar acidentalmente um `Option&lt;int&gt;` potencialmente ausente para algo que espera um `int` de verdade. Também não podemos usar acidentalmente um `Option&lt;int&gt;` como se fosse um inteiro, já que ele não suporta nenhuma dessas operações. Não podemos fazer aritmética com um `Option&lt;int&gt;` mais do que poderíamos com um `List&lt;int&gt;`.

Para criar um valor de tipo option a partir de um valor presente do tipo subjacente (digamos, `3`), você constrói o option assim: `Some(3)`. Para criar um tipo option quando o valor está ausente, você escreve algo como `None()`.

Para usar um inteiro potencialmente ausente armazenado em um `Option&lt;int&gt;`, primeiro precisamos verificar se o valor está lá. Se estiver, podemos extrair o inteiro do option e usá-lo, do mesmo jeito que lemos um valor de uma coleção. Linguagens que têm tipos option geralmente também têm uma sintaxe elegante de [pattern matching](https://en.wikipedia.org/wiki/Pattern_matching), que nos dá uma forma elegante de verificar se o valor existe e usá-lo quando existe.

## Solução 2: tipos nuláveis {:#solution-2-nullable-types}

A outra opção (ha), é a que Kotlin, TypeScript e, agora, o Dart adotam. [Tipos nuláveis](https://en.wikipedia.org/wiki/Nullable_type) são um caso especial de [tipos união](https://en.wikipedia.org/wiki/Union_type).

(Digressão: a nomenclatura fica bem confusa aqui. Tipos option, o que o ML e seus parentes fazem acima, são um caso especial de [tipos algébricos de dados](https://en.wikipedia.org/wiki/Algebraic_data_type). Outro nome para tipos algébricos de dados é “uniões discriminadas”. Mas, apesar de “união” estar no nome, “uniões discriminadas” são bem diferentes de “tipos união”. Como disse Phil Karlton, existem apenas dois problemas difíceis na ciência da computação: invalidação de cache e nomear coisas.)

Assim como na abordagem do tipo option, usamos o tipo subjacente para representar um valor definitivamente presente. Portanto, `int` de novo significa que temos absolutamente um inteiro. Se queremos um inteiro potencialmente ausente, usamos o tipo nulável `int?`. A pequena interrogação é um açúcar sintático para escrever o que é essencialmente um tipo união, como `int | Null`.

Assim como com os tipos option, um tipo nulável não suporta as mesmas operações do tipo subjacente. O sistema de tipos não nos deixa tentar fazer aritmética com um `int` nulável, porque isso não é seguro. Da mesma forma, não podemos passar um inteiro nulável para algo que exige um inteiro de fato.

No entanto, o sistema de tipos é um pouco mais flexível do que com os tipos option. Ele entende que um tipo união é um supertipo de seus ramos. Em outras palavras, `int` é um subtipo de `int?`. Isso significa que *podemos* passar um inteiro definitivamente presente para algo que espera um inteiro possivelmente presente, já que isso é seguro. É um upcast, assim como podemos passar uma `String` para uma função que recebe `Object`. O Dart só proíbe o caminho inverso, de nulável para não nulável, porque isso seria um downcast, e downcasts podem falhar.

Quando temos um valor de tipo nulável e queremos saber se há um valor de fato ou se há `null` ali, verificamos o valor de forma imperativa, exatamente como faríamos naturalmente em C ou Java:

```
foo(int? i) {
  if (i != null) {
    print(i + 1);
  }
}
```


Então, a linguagem usa [análise de fluxo](https://en.wikipedia.org/wiki/Control-flow_graph) para determinar quais partes do programa estão protegidas por essas verificações. A análise determina que o código só pode ser alcançado se a variável não for `null`, então, dentro dessas regiões, o sistema de tipos restringe o tipo da variável para não nulável. Assim, aqui ele trata `i` como tendo o tipo `int` dentro do `if`.

## Qual solução uma linguagem deve adotar? {:#which-solution-should-a-language-take}

Então, quando nós, da equipe do Dart, decidimos fazer a linguagem tratar null de forma mais segura, como escolher entre a solução 1 e a 2? Podemos começar observando nossos usuários. Como eles querem escrever código que verifica valores ausentes? Em linguagens funcionais, pattern matching é uma das principais estruturas de controle de fluxo, e os usuários de lá se sentem muito à vontade com isso. Usar tipos option e pattern matching é natural nesse estilo.

Em linguagens imperativas derivadas do C, código como o do meu exemplo anterior é a forma idiomática de verificar `null`. Usar análise de fluxo e tipos nuláveis faz esse código familiar funcionar de forma correta e segura. Na verdade, com o Dart, descobrimos que *a maior parte do código existente já é estaticamente null safe com o novo sistema de tipos*, porque a nova análise de fluxo entende corretamente o código já escrito.

(Isso, de certa forma, não é surpresa. *A maior parte* do código já está *dinamicamente* correta em relação ao tratamento de `null`. Se não estivesse, travaria o tempo todo. Grande parte do trabalho é simplesmente tornar o sistema de tipos inteligente o bastante para ver que esse código já está correto, para que a atenção do usuário seja direcionada aos poucos trechos que *não* estão.)

Então, se nosso objetivo é maximizar a familiaridade e o conforto do usuário (que *são* critérios importantes no design de linguagens), devemos simplesmente seguir o caminho que as estruturas de controle de fluxo da linguagem nos indicam.

## Representando ausência e presença {:#representing-absence-and-presence}

Há uma forma mais profunda de abordar essa questão, baseada nas diferenças entre a representação dos tipos option e dos tipos nuláveis. Essa diferença de representação nos impõe alguns trade-offs importantes, que podem nos empurrar para um lado ou para o outro.

Na primeira abordagem, um valor de tipo option tem uma representação em tempo de execução distinta do valor subjacente. Digamos que escolhêssemos tipos option no Dart, e você criasse um e depois fizesse um upcast para `Object`:

```
var optionalInt = Some(3);
Object obj = optionalInt;
print(obj is int); // false
```


Observe a última linha. Um valor `Option&lt;int&gt;`, mesmo quando presente, *não* é o mesmo tipo de coisa que um valor do tipo subjacente. `Some(3)` e `3` são valores distintos e distinguíveis.

Não é assim que os tipos nuláveis funcionam:

```
var nullableInt = 3 as int?;
Object obj = nullableInt;
print(obj is int); // true
```


Tipos nuláveis existem no *sistema de tipos estático*, mas a representação em tempo de execução dos valores usa o tipo subjacente. Se você tem um “3 nulável”, em tempo de execução ele é apenas o número `3`. Se você tem um valor ausente de algum tipo nulável, em tempo de execução você tem apenas o único valor mágico `null`.

Você pode perguntar se um valor é de um tipo nulável:

```
print(obj is int?);
```


Mas a expressão `is int?` equivale a:

```
print(obj is int || obj is Null);
```


## Options aninhados {:#nested-optionals}

Como os valores de tipos option são diferentes do tipo subjacente, isso nos dá uma capacidade importante: tipos option podem ser aninhados.

Digamos que temos um serviço de rede que devolve strings de recursos quando recebe uma requisição com algum ID inteiro. Alguns recursos não existem, e o servidor responde sem dados para esse ID. Como acessar a rede é lento, queremos guardar localmente o resultado das requisições que já fizemos, em um cache.

No Dart antes do null safety, poderíamos usar um map assim:

```
Map<int, String> cache;
```


Então, antes de fazer uma requisição de rede para algum ID, usamos o operador de índice do map de cache para procurar o ID do recurso. Esse operador, definido em `Map`, retorna `null` se a chave não estiver presente. Mas a chave também pode estar presente e associada a um valor `null`. Se fizermos uma busca e recebermos `null` de volta, isso pode significar uma de duas coisas:

* A chave não estava no map. Isso significa que ainda não fizemos a requisição, então devemos pedir ao servidor que busque o recurso.

* A chave estava presente e associada a `null`. Isso significa que já perguntamos ao servidor, descobrimos que o recurso não existia e guardamos esse resultado no cache. Devemos usar esse resultado e não consultar o servidor de novo.

Como existe um único valor `null` em todo o sistema, não temos uma representação em tempo de execução que distinga esses dois casos. É por isso que a classe `Map` tem um método separado, `containsKey()`. Essa API oferece uma forma de distinguir os dois casos.

Agora, se o Dart tivesse sido construído em torno de tipos option, o cache ficaria assim:

```
Map<int, Option<String>> cache;
```


E o operador de índice retornaria um valor opcional:

```
class Map<K, V> {
  Option<V> operator [](K key) => ...
  ...
}
```


No caso do nosso `Map&lt;int, Option&lt;String&gt;&gt;`, isso significa que o tipo de retorno é `Option&lt;Option&lt;String&gt;&gt;`. Repare no aninhamento! Agora, quando buscamos uma chave no cache, podemos obter alguns resultados diferentes:

* Um `Some(Some(string))` significa que o recurso existia no servidor, e agora ele está no cache.

* Um `Some(None())` significa que pedimos ao servidor e o recurso não estava lá, então guardamos no cache o fato de que o recurso não existe.

* Um `None()` significa que o cache não contém este ID de forma alguma.

Conseguimos distinguir os dois últimos casos porque os options sempre envolvem o valor subjacente com um estado extra. Em tempo de execução, podemos determinar quantas camadas existem e removê-las uma a uma.

Já os tipos nuláveis, como não têm representação explícita em tempo de execução, são achatados implicitamente. Assim, `int?` e `int??` são tipos equivalentes para o sistema de tipos e têm conjuntos de valores equivalentes em tempo de execução. É por isso que os defensores dos tipos option os descrevem como “mais expressivos”: tipos option permitem representar mais tipos de valores do que os tipos nuláveis.

## Substituição de nulos {:#nullable-substitution}

Outra forma de pensar sobre “expressividade” é o quanto de *esforço* o usuário precisa para expressar o que realmente quer. Uma linguagem é mais expressiva se o usuário consegue atingir seu objetivo passando por menos obstáculos.

Uma vantagem de não ter uma representação distinta para tipos nuláveis é que os valores podem fluir de contextos não nuláveis para nuláveis com muito mais facilidade. Digamos que você tenha uma função que aceita um parâmetro inteiro opcional. Com tipos option, a assinatura ficaria parecida com:

```
takesMaybeInt(Option<int> optionalInt) {}
```


Para chamar essa função com um inteiro conhecido, ele precisa ser envolvido em um option antes:

```
takesMaybeInt(Some(3));
```


Com tipos nuláveis, como não há diferença de representação, você pode passar um valor do tipo subjacente diretamente:

```
takesMaybeInt(3);
```


Você tem essa flexibilidade em todo o sistema de tipos. Você pode sobrescrever um método que retorna um tipo nulável para retornar um tipo não nulável. Você pode passar um `List&lt;int&gt;` para uma função que espera um `List&lt;int?&gt;`.

Então, embora os tipos nuláveis percam a capacidade de aninhar e de representar múltiplos *tipos* distintos de “ausência”, em troca eles tornam muito mais fácil trabalhar com a única noção consagrada de `null`.

## Nulabilidade no Dart {:#nullability-for-dart}

O Dart é uma linguagem imperativa, na qual as pessoas já usam instruções `if` para verificar valores ausentes em tempo de execução. Também é uma linguagem orientada a objetos, na qual já existe um valor `null` especial, com sua própria representação em tempo de execução. Por isso, a solução 2, tipos nuláveis, foi a resposta natural para nós. Ela permite que os usuários escrevam o tipo de código a que já estão acostumados e aproveita a forma como o runtime já representa os valores.

Para mais informações sobre nulabilidade no Dart, veja a seção [Onde saber mais](https://dart.dev/null-safety#where-to-learn-more) da [documentação de null safety do Dart](https://dart.dev/null-safety).

<DashImage src="images/1ihpy1Ngzg7SczCKkuh_WhQ.webp" alt="Quebra-cabeça com uma peça faltando." caption="Uma destas peças de quebra-cabeça é null." />
