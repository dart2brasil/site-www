---
ia-translate: true
title: "built_value do Dart para Modelos de Objetos Imutáveis"
description: "Na semana passada escrevi sobre built_collection. Terminei observando que, para realmente aproveitar coleções imutáveis, você precisa de valores imutáveis…"
publishDate: 2016-11-30
author: davidmorgan
category: deep-dive
layout: blog
---


Na semana passada eu [escrevi sobre](https://medium.com/@davidmorgan_14314/darts-built-collection-for-immutable-collections-db662f705eff#.71roxijm3) o [built_collection](https://github.com/google/built_collection.dart). Terminei observando que, para realmente aproveitar coleções imutáveis, você precisa de valores imutáveis. Então, aqui estamos: o [built_value](https://github.com/google/built_value.dart). Esta é a segunda peça principal da minha palestra na [Dart Developer Summit (vídeo)](https://www.youtube.com/watch?v=TMeJxWltoVo).

## Tipos de valor {:#value-types}

O pacote built_value serve para definir seus próprios *tipos de valor*. O termo tem um [significado preciso](https://en.wikipedia.org/wiki/Value_type), mas nós o usamos informalmente para se referir a tipos em que a igualdade se baseia apenas no valor. Por exemplo, números: meu 3 é igual ao seu 3.

Não só isso: meu 3 *sempre* será igual ao seu 3; ele não pode mudar para 4, ou para null, ou para um tipo completamente diferente. Tipos de valor são naturalmente imutáveis. Isso os torna simples de usar e de raciocinar sobre eles.

Tudo isso soa terrivelmente abstrato. Para que servem os tipos de valor? Acontece que para muita coisa. Muita mesmo. Podemos argumentar — e eu argumento isso com frequência — que qualquer classe usada para modelar o mundo real deveria ser um tipo de valor. Observe:

```
var user1 = new User(name: "John Smith");
var user2 = new User(name: "John Smith");

print(user1 == user2);
```


O que isso deveria imprimir? Crucialmente, as duas instâncias devem se referir a alguém no mundo real. Como seus valores são idênticos, elas precisam se referir à *mesma pessoa*. Portanto, devem ser consideradas iguais.

E quanto à imutabilidade? Considere:

```
user1.nickname = 'Joe';
```


O que significa atualizar o apelido de um “User”? Isso poderia implicar várias mudanças; talvez o texto de boas-vindas na minha página web use o apelido, e ele deveria ser atualizado. Provavelmente eu tenho algum armazenamento em algum lugar, então ele também precisará ser atualizado. Agora tenho dois grandes problemas:

* Não sei quem tem uma referência para “user1”. O valor acabou de mudar por baixo dos seus pés; dependendo de como essas referências são usadas, isso pode ter qualquer número de efeitos imprevisíveis.

* Quem estiver com “user2” ou algo parecido agora tem um valor desatualizado.

A imutabilidade não consegue resolver o segundo problema, mas elimina o primeiro. Isso significa que não há atualizações imprevisíveis, só atualizações explícitas:

```
var updatedUser = new User(name: "John Smith", nickname: "Joe");
saveToDatabase(updatedUser); // Database will notify frontend.
```


Crucialmente, isso significa que as mudanças são *locais até serem publicadas explicitamente*. Isso leva a um código simples, fácil de raciocinar — e de tornar correto e rápido ao mesmo tempo.

## O problema com os tipos de valor {:#the-problem-with-value-types}

Então, a pergunta óbvia: se tipos de valor são tão úteis, por que não os vemos em todo lugar?

Infelizmente, eles são extremamente trabalhosos de implementar. No Dart e na maioria das outras linguagens orientadas a objetos, é preciso uma grande quantidade de [código boilerplate](https://en.wikipedia.org/wiki/Boilerplate_code). Na minha palestra na Dart Developer Summit, mostrei como uma classe simples de dois campos [precisa de tanto boilerplate que ocupa um slide inteiro (vídeo)](https://www.youtube.com/watch?v=TMeJxWltoVo&feature=youtu.be&t=369).

## Apresentando o built_value {:#introducing-built_value}

Precisamos de um recurso da linguagem — o que é empolgante de discutir, mas improvável de chegar tão cedo — ou de alguma forma de [metaprogramação](https://en.wikipedia.org/wiki/Metaprogramming). E o que descobrimos é que o Dart já tem uma forma muito boa de fazer metaprogramação: o [source_gen](https://github.com/dart-lang/source_gen).

O objetivo é claro: tornar tão fácil definir e usar tipos de valor que possamos usá-los sempre que um tipo de valor fizer sentido.

Primeiro, vamos precisar de um pequeno desvio para ver como esse problema pode ser abordado com o source_gen. A ferramenta source_gen cria código-fonte gerado em novos arquivos ao lado do seu código mantido manualmente, então precisamos deixar espaço para uma implementação gerada. Isso significa uma classe abstrata:

```
abstract class User {
  String get name;
  
  @nullable
  String get nickname;
}
```


Isso tem informação suficiente para gerar uma implementação. Por convenção, código gerado começa com “_$”, para marcá-lo como privado e gerado. Então a implementação gerada se chamará “_$User”. Para permitir que ela estenda “User”, haverá um construtor privado com esse propósito chamado “_”:

```
=== user.dart ===

abstract class User {
  String get name;

  @nullable
  String get nickname;

  User._();
  factory User() = UserImpl;
}

=== user.g.dart is generated by source_gen ===

class _$User extends User {
  String name;
  String nickname;

  _$User() : super._();
}
```


Precisamos usar a instrução “part” do Dart para trazer o código gerado:

```
=== user.dart ===

library user;

part 'user.g.dart';

abstract class User {
  String get name;

  @nullable
  String get nickname;

  User._();
  factory User() = _$User;
}

=== user.g.dart is generated by source_gen ===

part of user;

class _$User extends User {
  String name;
  String nickname;

  _$User() : super._();

  // Generated implementation goes here.
}
```


Estamos chegando lá! Temos uma forma de gerar código e plugá-lo no código que escrevemos à mão. Agora voltando à parte interessante: o que você realmente precisa escrever à mão e o que o built_value deveria gerar.

Ainda falta uma forma de especificar valores para os campos. Poderíamos pensar em usar parâmetros nomeados opcionais:

```
factory User({String name, String nickname}) = _$User;
```


Mas isso tem algumas desvantagens: obriga você a repetir todos os nomes dos campos no construtor, e só oferece uma forma de definir todos os campos de uma vez; e se você quiser montar um valor peça por peça?

Felizmente, o [padrão builder](https://en.wikipedia.org/wiki/Builder_pattern) vem para salvar. Já vimos [como ele funciona bem](https://medium.com/@davidmorgan_14314/darts-built-collection-for-immutable-collections-db662f705eff#.oj7boxdoh) para coleções em Dart — graças ao operador de cascata. Supondo que temos um tipo builder, podemos usá-lo no construtor — pedindo uma função que recebe um builder como parâmetro:

```
abstract class User {
  String get name;

  @nullable
  String get nickname;

  User._();
  factory User([updates(UserBuilder b)]) = _$User;
}
```


Isso é um pouco surpreendente, mas leva a uma sintaxe muito simples para instanciação:

```
var user1 = new User((b) => b
    ..name = 'John Smith'
    ..nickname = 'Joe');
```


E quanto a criar novos valores a partir de antigos? O padrão builder tradicional oferece um método “toBuilder” para converter para um builder; então você aplica suas atualizações e chama “build”. Mas um padrão melhor para a maioria dos casos de uso é ter um método “rebuild”. Assim como o construtor, ele recebe uma função que recebe um builder, e permite atualizações inline fáceis:

```
var user2 = user.rebuild((b) => b
    ..nickname = 'Jojo');
```


Ainda queremos “toBuilder”, porém, para os casos em que você quer manter um builder por um tempinho. Então queremos dois métodos para todos os nossos tipos de valor:

```
abstract class Built<V, B> {
  // Creates a new instance: this one with [updates] applied.
  V rebuild(updates(B builder));

  // Converts to a builder.
  B toBuilder();
}
```


Você não precisa escrever a implementação desses métodos; o built_value a gera para você. Então você só precisa declarar que “implementa Built”:

```
library user;

import 'package:built_value/built_value.dart';

part 'user.g.dart';

abstract class User implements Built<User, UserBuilder> {
  String get name;

  @nullable
  String get nickname;

  User._();
  factory User([updates(UserBuilder b)]) = _$User;
}
```


E é isso! Um tipo de valor definido, uma implementação gerada e fácil de usar. Claro, a implementação gerada não é só campos: ela também fornece “operator==”, “hashCode”, “toString” e verificações de null para campos obrigatórios.

Deixei de lado um detalhe importante, porém: eu disse “supondo que temos um tipo builder”. Claro, estamos gerando código, então a resposta é simples: nós geramos para você. O “UserBuilder” referenciado a partir de “User” é criado em “user.g.dart”.

…*a menos que* você queira escrever algum código no builder, o que é um desejo perfeitamente razoável. Se for o caso, você segue o mesmo padrão para o builder. Ele é declarado como abstrato, com um construtor privado e uma factory que delega para a implementação gerada:

```
abstract class UserBuilder extends Builder<V, B> {
  @virtual
  String name;

  @virtual
  String nickname;

  // Parses e.g. John "Joe" Smith into username+nickname.
  void parseUser(String user) {
    ...
  }

  UserBuilder._();
  factory UserBuilder() => _$UserBuilder;
}
```


As anotações “@virtual” vêm de “package:meta” e são necessárias para permitir que a implementação gerada sobrescreva os campos. Agora que você adicionou métodos utilitários ao seu builder, pode usá-los inline assim como faria ao atribuir aos campos:

```
var user = new User((b) => b..parseUser('John "Joe" Smith'));
```


Os casos de uso para personalizar um builder são relativamente raros, mas podem ser muito poderosos. Por exemplo, você pode querer que seus builders implementem uma interface comum para definir campos compartilhados, para que possam ser usados de forma intercambiável.

## Builders aninhados {:#nested-builders}

Há um recurso importante do built_value que você ainda não viu: builders aninhados. Quando um campo do built_value guarda uma built_collection ou outro built_value, por padrão ele fica disponível no builder como um *builder aninhado*. Isso significa que você pode atualizar campos profundamente aninhados *com mais facilidade* do que se toda a estrutura fosse mutável:

```
var structuredData = new Account((b) => b
    ..user.name = 'John Smith'
    ..user.nickname = 'Joe'
    ..credentials.email = 'john.smith@example.com'
    ..credentials.phone.country = Country.us
    ..credentials.phone.number = '555 01234 567');

var updatedStructuredData = structuredData.rebuild((b) => b
    ..credentials.phone.country = Country.switzerland
    ..credentials.phone.number = '555 01234 555');
```


Por que “com mais facilidade” do que se a estrutura fosse mutável?

Em primeiro lugar, o método “update”, fornecido por todos os builders, permite abrir um novo escopo sempre que quiser, “reiniciando” o operador de cascata e fazendo as atualizações desejadas de forma concisa e inline:

```
var updatedStructuredData = structuredData.rebuild((b) => b
    ..user.update((b) => b
        ..name = 'Johnathan Smith')
    ..credentials.phone.update((b) => b
        ..country = Country.switzerland
        ..number = '555 01234 555'));
```


Em segundo lugar, os builders aninhados são criados automaticamente quando necessário. Por exemplo, no código de benchmark do built_value definimos um tipo chamado Node:

```
abstract class Node implements Built<Node, NodeBuilder> {
  @nullable
  String get label;
  @nullable
  Node get left; 
  @nullable
  Node get right;

  Node._();
  factory Node([updates(NodeBuilder b)]) = _$Node;
}
```


E a criação automática de builders nos permite criar qualquer estrutura de árvore que quisermos, inline:

```
var node = new Node((b) => b
  ..left.left.left.right.left.right.label = 'I’m a leaf!'
  ..left.left.right.right.label = 'I’m also a leaf!');

var updatedNode = node.rebuild((b) => b
  ..left.left.right.right.label = 'I’m not a leaf any more!'
  ..left.left.right.right.right.label = 'I’m the leaf now!');
```


Mencionei um benchmark? Ao atualizar, o built_value copia apenas as partes da estrutura que precisam de atualização, reaproveitando o resto. Então é *rápido —* e eficiente em memória*.*

Mas você não precisa se limitar a construir árvores. Com o built_value você tem à disposição modelos de objetos imutáveis totalmente tipados … tão rápidos e poderosos quanto árvores imutáveis eficientes. Você pode combinar dados tipados, estruturas customizadas como o exemplo “Node” e coleções do built_collection:

```
var structuredData = new Account((b) => b
    ..user.update((b) => b
        ..name = 'John Smith')
    ..credentials.phone.update((b) => b
        ..country = Country.us
        ..number = '555 01234 567')
    ..node.left.left.left.account.update((b) => b
        ..user.name = 'John Smith II'
        ..user.nickname = 'Is lost in a tree')
    ..node.left.right.right.account.update((b) => b
        ..user.name = 'John Smith III'));
```


*Esses* são os tipos de valor de que eu falo quando argumento que a maioria dos dados deveria ser de tipos de valor!

## Mais sobre o built_value {:#more-on-built_value}

Eu cobri por que o built_value é necessário e como é usá-lo. Há mais por vir: o built_value também oferece EnumClass, para classes que se comportam como enums, e serialização JSON, para comunicação entre servidor e cliente e armazenamento de dados. Vou falar sobre eles em artigos futuros.

Depois disso, vou explorar o [exemplo de chat](https://github.com/google/built_value.dart/tree/master/chat_example) que usa o built_value em um sistema completo de ponta a ponta, com servidor e cliente.

Edição: [próximo artigo](https://medium.com/@davidmorgan_14314/darts-built-value-for-serialization-f5db9d0f4159#.par5t1142).
