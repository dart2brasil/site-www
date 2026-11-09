---
ia-translate: true
title: "built_value do Dart para Serialização"
description: "Na semana passada apresentei o built_value para modelos de objetos imutáveis. Vimos como definir modelos de objetos no built_value; eles são imutáveis, fáceis de usar e…"
publishDate: 2016-12-07
author: davidmorgan
category: deep-dive
layout: blog
---


Na semana passada apresentei o [built_value para modelos de objetos imutáveis](https://medium.com/@davidmorgan_14314/darts-built-value-for-immutable-object-models-83e2497922d4). Vimos como definir modelos de objetos no built_value; eles são imutáveis, fáceis de usar e, se você gosta desse tipo de coisa, muito divertidos.

Este artigo cobre o restante do pacote built_value. O item mais importante é que, como você deve ter adivinhado pelo título, eles também são serializáveis.

Veja como é usar a serialização do built_value:

```
// Value type defined using built_value.
abstract class Login implements Built<Login, LoginBuilder> {
  // Add serialization support by defining this static getter.
  static Serializer<Login> get serializer => _$loginSerializer;

  ...
}

// Once per app, define a top level "Serializer" to gather together
// all the generated serializers.
Serializers serializers = _$serializers;

// Use it!
var login = new Login((b) => b
  ..username = 'johnsmith'
  ..password = '123456');

print(JSON.encode(serializers.serialize(login)));
-->
["Login", "username", "johnsmith", "password", "123456"]
```


Reparou no “JSON.encode”? O serializador não chega de fato a serializar para uma String; ele converte para primitivos que a serialização JSON embutida do Dart sabe tratar. Então, se quiser, você pode usar outra coisa além de JSON.

Você provavelmente pensa em serialização como algo que deveria “simplesmente funcionar”, mas há alguns trade-offs sutis envolvidos. Vamos mergulhar na serialização do built_value.

## Polimorfismo {:#polymorphism}

O aspecto mais importante da serialização do built_value é que ela oferece suporte a polimorfismo. Especificamente, você pode ter campos de tipos *abstratos* e

* qualquer implementação serializável desse tipo abstrato pode ser serializada;

* informação suficiente será gravada na transmissão para desserializar para os tipos corretos.

O exemplo mais simples é que ele consegue serializar uma lista de Object:

```
serializers.serialize(new BuiltList<Object>([1, 'two', 3]));
-->
['list', ['int', 1, 'string', 'two', 'int', 3]]
```


Informação extra é adicionada na transmissão apenas quando necessário para desambiguar na desserialização. Então, se você tiver um campo do tipo “BuiltList&lt;int&gt;”, ele será serializado como “[1, 2, 3]” e não como “[‘int’, 1, ‘int’, 2, ‘int’, 3]”.

Em resumo, você pode definir seu modelo de objetos do jeito que quiser, e o built_value vai serializá-lo. Se quiser ver isso com mais detalhes, o [teste do serializador de map](https://github.com/google/built_value.dart/blob/master/built_value/test/built_map_serializer_test.dart) explora todas as possibilidades.

## Múltiplas implementações {:#multiple-implementations}

Outro problema que todos os mecanismos de serialização precisam enfrentar é, de alguma forma, definir o *universo* de tipos serializáveis. Aqui o built_json faz algo um pouco incomum: permite *múltiplas implementações* de um mesmo “tipo”.

Isso funciona porque os tipos são definidos na transmissão apenas pelo *nome da classe*. Nenhuma tentativa é feita para desambiguar entre classes diferentes chamadas “Login”, por exemplo; presume-se que tanto o remetente quanto o destinatário tenham disponível um serializador compatível para uma classe chamada “Login”.

Isso adiciona uma flexibilidade útil. Se você usa Dart no servidor e no cliente, por exemplo, tem uma *escolha* para cada classe do modelo de objetos:

* Você pode usar a mesma classe no cliente e no servidor.

* Ou pode usar classes diferentes. As implementações devem ter o mesmo nome e campos compatíveis.

Por exemplo, você poderia ter uma classe “Login” para o cliente que cuida da renderização e do parsing, e uma classe “Login” separada para o servidor que cuida da autenticação e dos bancos de dados. Claro, a implementação só do servidor é livre para usar pacotes como “dart:io”, e a implementação só do cliente, pacotes como “dart:html”.

## Múltiplas linguagens {:#multiple-languages}

Como a serialização do built_value identifica os tipos apenas pelo nome da classe, os dados serializados se encaixam bem em qualquer linguagem orientada a objetos. O suporte a Java está planejado por meio do [AutoValue](https://github.com/google/auto/tree/master/value).

## Múltiplas versões {:#multiple-versions}

Dados serializados do built_value são compatíveis com versões anteriores e posteriores de um jeito bem simples: eles dependem dos nomes das classes e dos campos. Mudanças de nome de classe e de nome de campo obrigatório são quebras de compatibilidade.

Campos anuláveis são mais flexíveis: na serialização, só são gravados se não forem null; na desserialização, assumem null se não forem encontrados. Assim, campos anuláveis podem ser adicionados, removidos ou renomeados sem que isso seja uma quebra de compatibilidade.

Campos não reconhecidos são simplesmente ignorados.

## Sem mirrors {:#no-mirrors}

Por fim, e crucial para o desempenho, o built_value não usa mirrors de forma alguma. Toda a análise é feita em tempo de geração de código, deixando você com um código de serialização mínimo e performático.

Foi isso a serialização com o built_value. Você pode simplesmente sentar e escrever um modelo de objetos, e ele fica imediatamente serializável para uso em RPCs ou para armazenamento de longo prazo.

## EnumClass {:#enumclass}

Por fim, o built_value traz mais um recurso: o EnumClass. Enums do Dart [não são classes](https://www.dartlang.org/guides/language/language-tour#enumerated-types), mas um modelo de objetos poderoso precisa de enums que se comportem como classes. O padrão óbvio é criar uma classe com campos “static const”, e o EnumClass facilita um pouco isso. Ele oferece:

* Código gerado para “values” e “valueOf”.

* Serialização por meio dos serializadores do built_value.

* Um bônus extra para usuários de Angular ou Angular2: a geração de código pode, opcionalmente, produzir um mixin para ajudar você a usar o enum nos templates.

Todos esses recursos podem ser vistos no [exemplo](https://github.com/google/built_value.dart/blob/master/example/lib/enums.dart).

É isso por esta semana! Depois de cobrir o básico do built_value, estou pronto para mergulhar no exemplo de chat em detalhes na próxima semana. Fiquem atentos!

Edição: [próximo artigo](https://medium.com/@davidmorgan_14314/building-a-chat-app-in-dart-815fcd0e5a31#.ncnhb2fh0).
