---
ia-translate: true
title: "built_collection do Dart para Coleções Imutáveis"
description: "Há um mês, eu falei na Dart Developer Summit sobre modelos de objetos com source_gen (vídeo). Mencionei alguns pacotes e técnicas que merecem…"
publishDate: 2016-11-24
author: davidmorgan
category: deep-dive
layout: blog
---


Há um mês, eu falei na [Dart Developer Summit](https://events.dartlang.org/2016/summit/) sobre [modelos de objetos com source_gen (vídeo)](https://www.youtube.com/watch?v=TMeJxWltoVo). Mencionei alguns pacotes e técnicas que merecem uma olhada mais de perto, então estou aqui para contar a história completa.

Primeiro, o [built_collection](https://github.com/google/built_collection.dart).

O pacote built_collection oferece coleções no estilo do SDK com imutabilidade. Imutabilidade para:

* Simplicidade e conveniência. Uma coleção imutável pode ser passada adiante sem se preocupar com quem pode modificá-la.

* Desempenho. A mutabilidade leva a padrões caros, como cópias defensivas e detecção de mudanças.

O fato de o built_collection ter que ser *conveniente* impõe alguns desafios à API. Vamos dar uma olhada. Primeiro, uma lista imutável:

```
var list = new BuiltList<int>([1, 2, 3]);
```


Agora eu gostaria de adicionar um valor a ela. Claro, ela é imutável, então não posso; o que eu realmente quero é criar uma *nova* lista com um valor extra no final.

É aqui que encontramos o [padrão builder](https://en.wikipedia.org/wiki/Builder_pattern), que dá nome ao pacote. Você obtém uma nova lista convertendo para um builder, fazendo as modificações e depois construindo:

```
var builder = list.toBuilder();
builder.add(4);
var newList = builder.build();
```


Builders geralmente são usados inline, então vamos fazer isso:

```
var newList = (list.toBuilder()..add(4)).build()
```


Isso é o máximo que o padrão builder costuma alcançar, mas o Dart tem [lambdas](https://www.dartlang.org/guides/language/language-tour#anonymous-functions), então podemos fazer melhor:

```
var newList = list.rebuild((b) => b.add(4));
```


O que descobrimos é que a [cascata de métodos](https://en.wikipedia.org/wiki/Method_cascading) do Dart torna o padrão builder muito poderoso. Você quase sempre consegue fazer o que quer inline:

```
var newList = list.rebuild((b) => b
    ..add(4)
    ..addAll([7, 6, 5])
    ..sort()
    ..remove(1));
```


Então, como esperado, o built_collection é conveniente.

Vamos falar de desempenho.

As Built Collections estão atualmente otimizadas para código que tem um ciclo de atualização/publicação. Isso significa: as coleções são convertidas para um builder, atualizadas, construídas e então publicadas — uma referência é passada — para o restante do código consumir.

Isso se encaixa no uso típico em aplicações web, por exemplo apps Angular. Nelas, uma interação do usuário ou uma resposta de RPC dispara uma atualização. O modelo de dados é reconstruído antes de ser publicado para renderização.

As Built Collections ainda não são otimizadas para reconstruções muito frequentes, o que exigiria implementar sobre [estruturas de dados cuidadosamente escolhidas](https://en.wikipedia.org/wiki/Hash_array_mapped_trie). Se você tem um caso de uso para isso, entre em contato — faz parte do design das Built Collections que isso seja possível quando for necessário.

Além da imutabilidade, o built_collection ajuda você a escrever código bom e correto. Um conjunto de propriedades ajuda nisso:

* Built Collections precisam ser criadas com parâmetros de tipo explícitos; não existe algo como um BuiltList&lt;dynamic&gt;.

```
new BuiltList([1, 2, 3]);     // Throws an exception!
new BuiltList<int>([1, 2, 3]); // Better.
```


* Os valores precisam ser não nulos; nulos não podem ser adicionados a uma Built Collection.

```
new BuiltList([1, 2, null]);  // Throws an exception!
```


* Built Collections são comparáveis e possuem hash. Isso significa que você pode colocá-las em maps, sets e multimaps, criando exatamente as coleções que combinam com seus dados.

Essas propriedades são especialmente adequadas para coleções de *objetos de negócio*: em uma aplicação web de loja, por exemplo, para guardar o conteúdo atual do carrinho de compras do usuário.

Foi uma visão rápida do que o built_collection oferece e do porquê; mais informações estão disponíveis na [página do GitHub](https://github.com/google/built_collection.dart). Para aproveitar bem as coleções imutáveis, porém, você precisa de classes imutáveis. Próximo passo: [built_value](http://github.com/google/built_value.dart)!

Edição: [próximo artigo](https://medium.com/@davidmorgan_14314/darts-built-value-for-immutable-object-models-83e2497922d4#.7uhmlrcz3).
