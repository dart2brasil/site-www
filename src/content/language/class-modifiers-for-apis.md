---
ia-translate: true
title: Modificadores de classe para mantenedores de API
description: >-
  Como usar os modificadores de classe adicionados no Dart 3.0
  para tornar a API do seu pacote mais robusta e sustentável.
prevpage:
  url: /language/class-modifiers
  title: Modificadores de classe
nextpage:
  url: /language/modifier-reference
  title: "Referência de modificadores de classe"
---

O Dart 3.0 adiciona alguns [novos modificadores][class modifiers]
que você pode colocar em declarações de classes e [mixins][mixin].
Se você for o autor de um pacote de biblioteca,
esses modificadores lhe dão mais controle sobre o que os usuários podem fazer
com os tipos que seu pacote exporta.
Isso pode facilitar a evolução do seu pacote,
e saber se uma mudança no seu código pode quebrar o código dos usuários.

[class modifiers]: /language/class-modifiers
[mixin]: /language/mixins

O Dart 3.0 também inclui uma [mudança significativa](/resources/dart-3-migration#mixin)
em relação ao uso de classes como mixins.
Essa mudança pode não quebrar *sua* classe,
mas pode quebrar *usuários* da sua classe.

Este guia orienta você através dessas mudanças
para que você saiba como usar os novos modificadores,
e como eles afetam os usuários de suas bibliotecas.

## O modificador `mixin` em classes {:#the-mixin-modifier-on-classes}

O modificador mais importante a ser observado é `mixin`.
As versões da linguagem anteriores ao Dart 3.0 permitiam que qualquer classe fosse usada como um mixin
na cláusula `with` de outra classe, _A MENOS QUE_ a classe:

*   Declare quaisquer construtores que não sejam factory.
*   Estenda qualquer classe que não seja `Object`.

Isso torna fácil quebrar acidentalmente o código de outra pessoa,
adicionando um construtor ou cláusula `extends` a uma classe
sem perceber que outros a estão usando em uma cláusula `with`.

O Dart 3.0 não permite mais que classes sejam usadas como mixins por padrão.
Em vez disso, você deve explicitamente optar por esse comportamento declarando uma `mixin class`:

```dart
mixin class Both {}

class UseAsMixin with Both {}
class UseAsSuperclass extends Both {}
```

Se você atualizar seu pacote para Dart 3.0 e não alterar nada no seu código,
você pode não ver nenhum erro.
Mas você pode inadvertidamente quebrar usuários do seu pacote
se eles estivessem usando suas classes como mixins.

### Migrando classes como mixins {:#migrating-classes-as-mixins}

Se a classe tiver um construtor não factory, uma cláusula `extends`,
ou uma cláusula `with`, então ela já não pode ser usada como um mixin.
O comportamento não mudará com o Dart 3.0;
não há nada para se preocupar e nada que você precise fazer.

Na prática, isso descreve cerca de 90% das classes existentes.
Para as classes restantes que podem ser usadas como mixins,
você tem que decidir o que quer suportar.

Aqui estão algumas perguntas para ajudar a decidir. A primeira é pragmática:

*   **Você quer arriscar quebrar algum usuário?** Se a resposta for um "não" categórico,
    então coloque `mixin` antes de todas as classes que
    [poderiam ser usadas como mixin](#the-mixin-modifier-on-classes).
    Isso preserva exatamente o comportamento existente da sua API.

Por outro lado, se você quiser aproveitar esta oportunidade para repensar as
possibilidades que sua API oferece, então você pode querer *não* transformá-la em uma `mixin
class`. Considere estas duas questões de design:

*   **Você quer que os usuários sejam capazes de construir instâncias dela diretamente?**
    Em outras palavras, a classe não é deliberadamente abstrata?

*   **Você *quer* que as pessoas possam usar a declaração como um mixin?**
    Em outras palavras, você quer que eles possam usá-la em cláusulas `with`?

Se a resposta para ambos for "sim", então torne-a uma mixin class. Se a resposta para
a segunda for "não", então apenas deixe-a como uma classe. Se a resposta para a primeira
for "não" e a segunda for "sim", então mude-a de uma classe para uma
declaração mixin.

As duas últimas opções, deixá-la como uma classe ou transformá-la em um mixin puro,
são mudanças de API que causam quebra. Você vai querer aumentar a versão principal do seu pacote
se você fizer isso.

## Outros modificadores opt-in {:#other-opt-in-modifiers}

Lidar com classes como mixins é a única mudança crítica no Dart 3.0
que afeta a API do seu pacote. Uma vez que você chegou até aqui,
você pode parar se não quiser fazer outras mudanças
no que seu pacote permite que os usuários façam.

Note que, se você continuar e usar qualquer um dos modificadores descritos abaixo,
isso é potencialmente uma mudança que quebra a API do seu pacote, o que exige
um incremento na versão principal.

## O modificador `interface` {:#the-interface-modifier}

O Dart não tem uma sintaxe separada para declarar interfaces puras.
Em vez disso, você declara uma classe abstrata que por acaso contém apenas
métodos abstratos.
Quando um usuário vê essa classe na API do seu pacote,
ele pode não saber se ela contém código que ele pode reutilizar estendendo a classe,
ou se ela é destinada a ser usada como uma interface.

Você pode esclarecer isso colocando o modificador [`interface`](/language/class-modifiers#interface)
na classe.
Isso permite que a classe seja usada em uma cláusula `implements`,
mas impede que ela seja usada em `extends`.

Mesmo quando a classe *tem* métodos não abstratos, você pode querer impedir
que os usuários a estendam.
A herança é um dos tipos mais poderosos de acoplamento em software,
porque permite a reutilização de código.
Mas esse acoplamento também é [perigoso e frágil][dangerous and fragile].
Quando a herança cruza os limites do pacote,
pode ser difícil evoluir a superclasse sem quebrar as subclasses.

[dangerous and fragile]: https://en.wikipedia.org/wiki/Fragile_base_class

Marcar a classe como `interface` permite que os usuários a construam (a menos que ela [também seja marcada
como `abstract`](/language/class-modifiers#abstract-interface))
e implementem a interface da classe,
mas os impede de reutilizar qualquer parte do seu código.

Quando uma classe é marcada como `interface`, a restrição pode ser ignorada dentro
da biblioteca onde a classe é declarada.
Dentro da biblioteca, você pode estendê-la, pois é tudo o seu código
e, presumivelmente, você sabe o que está fazendo.
A restrição se aplica a outros pacotes,
e até mesmo a outras bibliotecas dentro do seu próprio pacote.

## O modificador `base` {:#the-base-modifier}

O modificador [`base`](/language/class-modifiers#base)
é um pouco o oposto de `interface`.
Ele permite que você use a classe em uma cláusula `extends`,
ou use um mixin ou mixin class em uma cláusula `with`.
Mas, ele impede que código fora da biblioteca da classe
use a classe ou mixin em uma cláusula `implements`.

Isso garante que todo objeto que é uma instância
da sua classe ou interface de mixin herda a sua implementação real.
Em particular, isso significa que cada instância incluirá
todos os membros privados que sua classe ou mixin declara.
Isso pode ajudar a evitar erros de tempo de execução que poderiam ocorrer de outra forma.

Considere esta biblioteca:

```dart title="a.dart"
class A {
  void _privateMethod() {
    print('Eu herdei de A');
  }
}

void callPrivateMethod(A a) {
  a._privateMethod();
}
```

Este código parece bom por si só,
mas não há nada que impeça um usuário de criar outra biblioteca como esta:

```dart title="b.dart"
import 'a.dart';

class B implements A {
  // Nenhuma implementação de _privateMethod()!
}

main() {
  callPrivateMethod(B()); // Exceção de tempo de execução!
}
```

Adicionar o modificador `base` à classe pode ajudar a evitar esses erros de tempo de execução.
Assim como com `interface`, você pode ignorar essa restrição
na mesma biblioteca onde a classe ou mixin `base` é declarada.
Então, as subclasses na mesma biblioteca
serão lembradas de implementar os métodos privados.
Mas note que a próxima seção *se aplica*:

### Transitividade base {:#base-transitivity}

O objetivo de marcar uma classe como `base` é garantir que
cada instância desse tipo herde concretamente dela.
Para manter isso, a restrição base é "contagiosa".
Todo subtipo de um tipo marcado como `base` -- *direto ou indireto* --
também deve impedir de ser implementado.
Isso significa que ele deve ser marcado como `base`
(ou `final` ou `sealed`, que veremos a seguir).

Aplicar `base` a um tipo requer algum cuidado, então.
Ele afeta não apenas o que os usuários podem fazer com sua classe ou mixin,
mas também as possibilidades que *suas* subclasses podem oferecer.
Uma vez que você colocou `base` em um tipo, toda a hierarquia abaixo dele
é proibida de ser implementada.

Isso soa intenso, mas é como a maioria das outras linguagens de programação
sempre funcionaram.
A maioria não tem interfaces implícitas,
então, quando você declara uma classe em Java, C# ou outras linguagens,
você efetivamente tem a mesma restrição.

## O modificador `final` {:#the-final-modifier}

Se você quiser todas as restrições de `interface` e `base`,
você pode marcar uma classe ou mixin class como [`final`](/language/class-modifiers#final).
Isso impede que qualquer pessoa fora de sua biblioteca crie
qualquer tipo de subtipo dela:
não é possível usá-la em cláusulas `implements`, `extends`, `with` ou `on`.

Essa é a opção mais restritiva para os usuários da classe.
Tudo o que eles podem fazer é construí-la (a menos que seja marcada como `abstract`).
Em troca, você tem o menor número de restrições como mantenedor da classe.
Você pode adicionar novos métodos, transformar construtores em construtores factory, etc.
sem se preocupar em quebrar nenhum usuário downstream.

<a id="the-sealed-modifer"></a>
## O modificador `sealed` {:#the-sealed-modifier}

O último modificador, [`sealed`](/language/class-modifiers#sealed), é especial.
Ele existe principalmente para habilitar a [verificação de exaustividade][exhaustiveness checking] na correspondência de padrões.
Se um switch tiver casos para cada subtipo direto de um tipo marcado como `sealed`,
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

Este switch tem um caso para cada um dos subtipos de `Amigo`.
O compilador sabe que toda instância de `Amigo` deve ser uma instância de um
desses subtipos, então ele sabe que o switch é seguramente exaustivo e não
exige nenhum caso padrão final.

Para que isso seja correto, o compilador impõe duas restrições:

1.  A classe sealed não pode ser diretamente construtível.
    Caso contrário, você poderia ter uma instância de `Amigo` que não é
    uma instância de *nenhum* dos subtipos.
    Então, toda classe `sealed` é implicitamente `abstract` também.

2.  Todo subtipo direto do tipo sealed deve estar na mesma biblioteca
    onde o tipo sealed é declarado.
    Dessa forma, o compilador pode encontrar todos eles. Ele sabe que não existem
    outros subtipos ocultos por aí que não corresponderiam a nenhum dos casos.

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
// Isso é um erro:
class Bad extends Amigo {}

// Mas ambos estão corretos:
class OtherLucky extends Lucky {}
class OtherDusty implements Dusty {}
```

Claro, se você *quiser* que os subtipos do seu tipo sealed
também sejam restritos, você pode conseguir isso marcando-os
usando `interface`, `base`, `final` ou `sealed`.

### `sealed` versus `final` {:#sealed-versus-final}

Se você tem uma classe que não quer que os usuários possam subtipificar diretamente,
quando você deve usar `sealed` em vez de `final`?
Algumas regras simples:

*   Se você quer que os usuários possam construir diretamente instâncias da classe,
    então ela *não pode* usar `sealed`, pois os tipos sealed são implicitamente abstratos.

*   Se a classe não tem subtipos em sua biblioteca, então não há sentido em usar
    `sealed`, pois você não obtém nenhum benefício de verificação de exaustividade.

Caso contrário, se a classe tiver alguns subtipos que você define,
então `sealed` é provavelmente o que você quer.
Se os usuários virem que a classe tem alguns subtipos, é útil poder
lidar com cada um deles separadamente como casos de switch
e ter o compilador sabendo que todo o tipo é coberto.

Usar `sealed` significa que, se você adicionar posteriormente outro subtipo à biblioteca,
isso será uma mudança de API que causa quebra.
Quando um novo subtipo aparece,
todos esses switches existentes se tornam não exaustivos
já que eles não lidam com o novo tipo.
É exatamente como adicionar um novo valor a um enum.

Esses erros de compilação de switch não exaustivos são *úteis* para os usuários
porque eles chamam a atenção do usuário para lugares em seu código
onde eles precisarão lidar com o novo tipo.

Mas isso significa que, sempre que você adicionar um novo subtipo, é uma mudança que causa quebra.
Se você quiser a liberdade de adicionar novos subtipos de forma não quebradora,
então é melhor marcar o supertipo usando `final` em vez de `sealed`.
Isso significa que, quando um usuário faz um switch em um valor desse supertipo,
mesmo que eles tenham casos para todos os subtipos,
o compilador os forçará a adicionar outro caso default.
Esse caso default será o que será executado se você adicionar mais subtipos posteriormente.

## Resumo {:#summary}

Como designer de API,
esses novos modificadores dão a você controle sobre como os usuários trabalham com seu código,
e inversamente, como você é capaz de evoluir seu código sem quebrar o deles.

Mas essas opções trazem complexidade com elas:
você agora tem mais escolhas a fazer como designer de API.
Além disso, como esses recursos são novos,
ainda não sabemos quais serão as melhores práticas.
O ecossistema de cada linguagem é diferente e tem necessidades diferentes.

Felizmente, você não precisa descobrir tudo de uma vez.
Escolhemos os defaults deliberadamente para que, mesmo que você não faça nada,
suas classes tenham principalmente as mesmas possibilidades que tinham antes do 3.0.
Se você só quer manter sua API como estava,
coloque `mixin` nas classes que já suportavam isso, e está tudo certo.

Com o tempo, à medida que você tiver uma noção de onde quer um controle mais fino,
você pode considerar a aplicação de alguns dos outros modificadores:

*   Use `interface` para impedir que os usuários reutilizem o código da sua classe
    enquanto permite que eles reimplementem sua interface.

*   Use `base` para exigir que os usuários reutilizem o código da sua classe
    e garantir que toda instância do tipo da sua classe seja uma instância
    dessa classe real ou de uma subclasse.

*   Use `final` para impedir completamente que uma classe seja estendida.

*   Use `sealed` para optar pela verificação de exaustividade em uma família de subtipos.

Quando você fizer isso, incremente a versão principal ao publicar seu pacote,
já que esses modificadores implicam restrições que são mudanças que causam quebra.
