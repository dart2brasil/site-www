---
ia-translate: true
title: Modificadores de classe para mantenedores de API
description: >-
 Como usar os modificadores de classe adicionados no Dart 3.0
 para tornar a API do seu pacote mais robusta e fácil de manter.
prevpage:
  url: /language/class-modifiers
  title: Class modifiers
nextpage:
  url: /language/modifier-reference
  title: Class modifiers reference
---

O Dart 3.0 adiciona alguns [novos modificadores][class modifiers]
que você pode colocar em declarações de classe e [mixin][mixin].
Se você é o autor de um pacote de biblioteca,
esses modificadores fornecem mais controle sobre o que os usuários podem fazer
com os tipos que seu pacote exporta.
Isso pode facilitar a evolução do seu pacote
e facilitar saber se uma mudança no seu código pode quebrar os usuários.

[class modifiers]: /language/class-modifiers
[mixin]: /language/mixins

O Dart 3.0 também inclui uma [breaking change](/resources/dart-3-migration#mixin)
em relação ao uso de classes como mixins.
Essa mudança pode não quebrar *sua* classe,
mas pode quebrar *usuários* da sua classe.

Este guia aborda essas mudanças
para que você saiba como usar os novos modificadores
e como eles afetam os usuários de suas bibliotecas.

## O modificador `mixin` em classes

O modificador mais importante a ser observado é `mixin`.
Versões da linguagem anteriores ao Dart 3.0 permitem que qualquer classe seja usada como mixin
em uma cláusula `with` de outra classe, _A MENOS QUE_ a classe:

*   Declare qualquer construtor não-factory.
*   Estenda qualquer classe diferente de `Object`.

Isso facilita quebrar acidentalmente o código de outra pessoa,
ao adicionar um construtor ou cláusula `extends` a uma classe
sem perceber que outros a estão usando em uma cláusula `with`.

O Dart 3.0 não permite mais que classes sejam usadas como mixins por padrão.
Em vez disso, você deve explicitamente optar por esse comportamento declarando uma `mixin class`:

```dart
mixin class Both {}

class UseAsMixin with Both {}
class UseAsSuperclass extends Both {}
```

Se você atualizar seu pacote para o Dart 3.0 e não mudar nada no seu código,
você pode não ver nenhum erro.
Mas você pode inadvertidamente quebrar usuários do seu pacote
se eles estavam usando suas classes como mixins.

### Migrando classes como mixins

Se a classe tem um construtor não-factory, uma cláusula `extends`
ou uma cláusula `with`, então ela já não pode ser usada como mixin.
O comportamento não mudará com o Dart 3.0;
não há nada com que se preocupar e nada que você precise fazer.

Na prática, isso descreve cerca de 90% das classes existentes.
Para as classes restantes que podem ser usadas como mixins,
você precisa decidir o que deseja suportar.

Aqui estão algumas perguntas para ajudar a decidir. A primeira é pragmática:

*   **Você quer arriscar quebrar algum usuário?** Se a resposta for um "não" firme,
    então coloque `mixin` antes de qualquer e todas as classes que
    [poderiam ser usadas como mixin](#o-modificador-mixin-em-classes).
    Isso preserva exatamente o comportamento existente da sua API.

Por outro lado, se você quiser aproveitar essa oportunidade para repensar as
affordances que sua API oferece, então você pode querer *não* transformá-la em uma `mixin
class`. Considere estas duas questões de design:

*   **Você quer que os usuários possam construir instâncias dela diretamente?**
    Em outras palavras, a classe é deliberadamente não abstract?

*   **Você *quer* que as pessoas possam usar a declaração como mixin?**
    Em outras palavras, você quer que elas possam usá-la em cláusulas `with`?

Se a resposta para ambas for "sim", então faça dela uma mixin class. Se a resposta para
a segunda for "não", então apenas deixe-a como uma classe. Se a resposta para a primeira
for "não" e a segunda for "sim", então mude-a de uma classe para uma declaração
mixin.

As últimas duas opções, deixá-la como classe ou transformá-la em um mixin puro,
são breaking changes na API. Você precisará incrementar a versão principal do seu pacote
se fizer isso.

## Outros modificadores opt-in

Lidar com classes como mixins é a única mudança crítica no Dart 3.0
que afeta a API do seu pacote. Depois de chegar até aqui,
você pode parar se não quiser fazer outras mudanças
no que seu pacote permite que os usuários façam.

Observe que se você continuar e usar qualquer um dos modificadores descritos abaixo,
isso é potencialmente uma breaking change na API do seu pacote, o que requer
um incremento de versão principal.

## O modificador `interface`

O Dart não tem uma sintaxe separada para declarar interfaces puras.
Em vez disso, você declara uma classe abstract que contém apenas
métodos abstract.
Quando um usuário vê essa classe na API do seu pacote,
ele pode não saber se ela contém código que pode reutilizar estendendo a classe,
ou se é destinada a ser usada como uma interface.

Você pode esclarecer isso colocando o modificador [`interface`](/language/class-modifiers#interface)
na classe.
Isso permite que a classe seja usada em uma cláusula `implements`,
mas impede que seja usada em `extends`.

Mesmo quando a classe *tem* métodos não-abstract, você pode querer impedir que
usuários a estendam.
Herança é um dos tipos mais poderosos de acoplamento em software,
porque permite a reutilização de código.
Mas esse acoplamento também é [perigoso e frágil][dangerous and fragile].
Quando a herança atravessa limites de pacotes,
pode ser difícil evoluir a superclasse sem quebrar as subclasses.

[dangerous and fragile]: https://en.wikipedia.org/wiki/Fragile_base_class

Marcar a classe como `interface` permite que os usuários a construam (a menos que ela [também seja marcada
como `abstract`](/language/class-modifiers#abstract-interface))
e implementem a interface da classe,
mas impede que reutilizem qualquer código dela.

Quando uma classe é marcada como `interface`, a restrição pode ser ignorada dentro
da biblioteca onde a classe é declarada.
Dentro da biblioteca, você é livre para estendê-la, pois é todo o seu código
e presumivelmente você sabe o que está fazendo.
A restrição se aplica a outros pacotes
e até a outras bibliotecas dentro do seu próprio pacote.

## O modificador `base`

O modificador [`base`](/language/class-modifiers#base)
é de certa forma o oposto de `interface`.
Ele permite que você use a classe em uma cláusula `extends`,
ou use um mixin ou mixin class em uma cláusula `with`.
Mas impede que código fora da biblioteca da classe
use a classe ou mixin em uma cláusula `implements`.

Isso garante que cada objeto que seja uma instância
da interface da sua classe ou mixin herde sua implementação real.
Em particular, isso significa que cada instância incluirá
todos os membros privados que sua classe ou mixin declara.
Isso pode ajudar a prevenir erros de runtime que poderiam ocorrer de outra forma.

Considere esta biblioteca:

```dart title="a.dart"
class A {
  void _privateMethod() {
    print('I inherited from A');
  }
}

void callPrivateMethod(A a) {
  a._privateMethod();
}
```

Este código parece bom por si só,
mas não há nada impedindo um usuário de criar outra biblioteca como esta:

```dart title="b.dart"
import 'a.dart';

class B implements A {
  // No implementation of _privateMethod()!
}

main() {
  callPrivateMethod(B()); // Runtime exception!
}
```

Adicionar o modificador `base` à classe pode ajudar a prevenir esses erros de runtime.
Assim como com `interface`, você pode ignorar essa restrição
na mesma biblioteca onde a classe ou mixin `base` é declarado.
Então as subclasses na mesma biblioteca
serão lembradas de implementar os métodos privados.
Mas observe que a próxima seção *se aplica*:

### Transitividade do base

O objetivo de marcar uma classe como `base` é garantir que
cada instância desse tipo concretamente herde dela.
Para manter isso, a restrição base é "contagiosa".
Cada subtipo de um tipo marcado como `base` -- *direto ou indireto* --
também deve impedir ser implementado.
Isso significa que deve ser marcado como `base`
(ou `final` ou `sealed`, que veremos a seguir).

Aplicar `base` a um tipo requer algum cuidado, então.
Isso afeta não apenas o que os usuários podem fazer com sua classe ou mixin,
mas também as affordances que *suas* subclasses podem oferecer.
Uma vez que você coloque `base` em um tipo, toda a hierarquia abaixo dele
é proibida de ser implementada.

Isso parece intenso, mas é como a maioria das outras linguagens de programação
sempre funcionou.
A maioria não tem interfaces implícitas,
então quando você declara uma classe em Java, C# ou outras linguagens,
você efetivamente tem a mesma restrição.

## O modificador `final`

Se você quiser todas as restrições de `interface` e `base`,
você pode marcar uma classe ou mixin class como [`final`](/language/class-modifiers#final).
Isso impede que qualquer pessoa fora da sua biblioteca crie
qualquer tipo de subtipo dela:
não é permitido usá-la em cláusulas `implements`, `extends`, `with` ou `on`.

Essa é a opção mais restritiva para os usuários da classe.
Tudo o que eles podem fazer é construí-la (a menos que seja marcada como `abstract`).
Em troca, você tem as menores restrições como mantenedor da classe.
Você pode adicionar novos métodos, transformar construtores em factory constructors, etc.
sem se preocupar em quebrar usuários downstream.

<a id="the-sealed-modifer"></a>
## O modificador `sealed`

O último modificador, [`sealed`](/language/class-modifiers#sealed), é especial.
Ele existe principalmente para habilitar a [verificação de exaustividade][exhaustiveness checking] na correspondência de padrões.
Se um switch tem cases para cada subtipo direto de um tipo marcado como `sealed`,
então o compilador sabe que o switch é exaustivo.

[exhaustiveness checking]: /language/branches#exhaustiveness-checking

<?code-excerpt "language/lib/class_modifiers/sealed_exhaustiveness.dart"?>
```dart title="amigos.dart"
sealed class Amigo {}

class Lucky extends Amigo {}

class Dusty extends Amigo {}

class Ned extends Amigo {}

String lastName(Amigo amigo) => switch (amigo) {
  Lucky _ => 'Day',
  Dusty _ => 'Bottoms',
  Ned _ => 'Nederlander',
};
```

Este switch tem um case para cada um dos subtipos de `Amigo`.
O compilador sabe que cada instância de `Amigo` deve ser uma instância de um
desses subtipos, então ele sabe que o switch é seguramente exaustivo e não
requer nenhum case default final.

Para que isso seja sólido, o compilador impõe duas restrições:

1.  A classe sealed não pode ser diretamente construível.
    Caso contrário, você poderia ter uma instância de `Amigo` que não é
    uma instância de *nenhum* dos subtipos.
    Então toda classe `sealed` é implicitamente `abstract` também.

2.  Cada subtipo direto do tipo sealed deve estar na mesma biblioteca
    onde o tipo sealed é declarado.
    Dessa forma, o compilador pode encontrar todos eles. Ele sabe que não há
    outros subtipos ocultos flutuando por aí que não corresponderiam a nenhum dos cases.

A segunda restrição é semelhante a `final`.
Como `final`, isso significa que uma classe marcada como `sealed` não pode ser diretamente
estendida, implementada ou misturada fora da biblioteca onde é declarada.
Mas, ao contrário de `base` e `final`, não há restrição *transitiva*:

```dart title="amigo.dart"
sealed class Amigo {}
class Lucky extends Amigo {}
class Dusty extends Amigo {}
class Ned extends Amigo {}
```

```dart title="other.dart"
// This is an error:
class Bad extends Amigo {}

// But these are both fine:
class OtherLucky extends Lucky {}
class OtherDusty implements Dusty {}
```

É claro que, se você *quiser* que os subtipos do seu tipo sealed
sejam restritos também, você pode conseguir isso marcando-os
usando `interface`, `base`, `final` ou `sealed`.

### `sealed` versus `final`

Se você tem uma classe que não quer que os usuários possam subtipificar diretamente,
quando você deve usar `sealed` versus `final`?
Algumas regras simples:

*   Se você quiser que os usuários possam construir instâncias da classe diretamente,
    então ela *não pode* usar `sealed`, pois tipos sealed são implicitamente abstract.

*   Se a classe não tem subtipos na sua biblioteca, então não há sentido em usar
    `sealed`, pois você não obtém benefícios de verificação de exaustividade.

Caso contrário, se a classe tiver alguns subtipos que você define,
então `sealed` é provavelmente o que você quer.
Se os usuários virem que a classe tem alguns subtipos, é útil poder
lidar com cada um deles separadamente como cases de switch
e ter o compilador sabendo que o tipo inteiro está coberto.

Usar `sealed` significa que se você adicionar outro subtipo à biblioteca posteriormente,
será uma breaking API change.
Quando um novo subtipo aparece,
todos aqueles switches existentes tornam-se não exaustivos
já que não lidam com o novo tipo.
É exatamente como adicionar um novo valor a um enum.

Esses erros de compilação de switch não exaustivo são *úteis* aos usuários
porque chamam a atenção do usuário para lugares no código
onde eles precisarão lidar com o novo tipo.

Mas isso significa que sempre que você adicionar um novo subtipo, é uma breaking change.
Se você quiser a liberdade de adicionar novos subtipos de forma não destrutiva,
então é melhor marcar o supertipo usando `final` em vez de `sealed`.
Isso significa que quando um usuário faz switch em um valor desse supertipo,
mesmo que ele tenha cases para todos os subtipos,
o compilador os forçará a adicionar outro case default.
Esse case default será então executado se você adicionar mais subtipos posteriormente.

## Resumo

Como designer de API,
esses novos modificadores fornecem controle sobre como os usuários trabalham com seu código
e, inversamente, como você é capaz de evoluir seu código sem quebrar o deles.

Mas essas opções trazem complexidade consigo:
você agora tem mais escolhas a fazer como designer de API.
Além disso, como esses recursos são novos,
ainda não sabemos quais serão as melhores práticas.
O ecossistema de cada linguagem é diferente e tem necessidades diferentes.

Felizmente, você não precisa descobrir tudo de uma vez.
Escolhemos os padrões deliberadamente para que, mesmo se você não fizer nada,
suas classes tenham em grande parte as mesmas affordances que tinham antes da 3.0.
Se você apenas quiser manter sua API como era,
coloque `mixin` nas classes que já suportavam isso e pronto.

Com o tempo, conforme você percebe onde quer um controle mais fino,
você pode considerar aplicar alguns dos outros modificadores:

*   Use `interface` para impedir que os usuários reutilizem o código da sua classe
    enquanto permitem que reimplementem sua interface.

*   Use `base` para exigir que os usuários reutilizem o código da sua classe
    e garantir que cada instância do tipo da sua classe seja uma instância
    dessa classe real ou de uma subclasse.

*   Use `final` para impedir completamente que uma classe seja estendida.

*   Use `sealed` para optar pela verificação de exaustividade em uma família de subtipos.

Quando você fizer isso, incremente a versão principal ao publicar seu pacote,
já que esses modificadores implicam restrições que são breaking changes.
