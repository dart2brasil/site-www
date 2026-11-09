---
ia-translate: true
title: "Fundamentos dos métodos de extensão do Dart"
description: "Conheça as considerações de design por trás dos métodos de extensão, um novo recurso que chegará em uma versão futura do SDK do Dart"
publishDate: 2019-11-05
author: lrhn
image: images/1D57vLbx-SwCUSnLXA9zHRQ.webp
category: other
layout: blog
---


## Fundamentos dos métodos de extensão do Dart {:#dart-extension-methods-fundamentals}

<DashImage src="images/1D57vLbx-SwCUSnLXA9zHRQ.webp" alt="Trecho de código com nomes de métodos de extensão e comentários de stack trace ao lado do logo do Dart." />


Em uma versão futura, a linguagem Dart está adicionando um novo recurso, os *métodos de extensão*, que permitem (fingir) adicionar novos membros a tipos existentes. Um método de extensão pode ser invocado como um método normal, `o.extensionMethod(42)`, mesmo que na prática seja apenas uma função estática.

Por que estamos adicionando métodos de extensão? Para que servem? Como você os usa? E por que eu os chamo de “métodos de extensão” quando você também pode adicionar outros membros? (Esta última é fácil: eu pessoalmente penso neles como *membros* de extensão, mas “métodos de extensão” era o título de trabalho, e é como um recurso semelhante se chama em outras linguagens; então, na boa tradição do Dart, optamos por um nome familiar e nada surpreendente. Não vou precisar de getters, setters ou operadores de extensão aqui, mas você pode perfeitamente adicionar um operador `%` a `String` se quiser, independentemente do nome do recurso.)

Como sou uma das pessoas que projetaram o recurso, vou responder oportunisticamente a todas essas perguntas antes que qualquer outra pessoa tenha a chance. (E, como publiquei este artigo antes de terminarmos o recurso, ainda consegui remover as coisas que deixaram de ser verdade!)

Mas, primeiro, um desvio!

## O que eu teria feito antes dos métodos de extensão {:#what-i-would-have-done-before-extension-methods}

Vamos supor, puramente por hipótese, que eu ache a função [`catchError`](https://api.dartlang.org/stable/2.5.0/dart-async/Future/catchError.html) de [`Future`](https://api.dartlang.org/stable/2.5.0/dart-async/Future-class.html) terrível e que ela deveria ser substituída por algo mais novo, mais brilhante e melhor. Digamos que seja porque ela recebe um [`Function`](https://api.dartlang.org/stable/2.5.0/dart-core/Function-class.html) como argumento em vez de um tipo de função adequado, o que ela faz por razões *históricas* perfeitamente razoáveis, e isso significa que você não terá nenhuma verificação estática de tipos. Isso é ruim, e o método deveria se sentir mal por isso.

Obviamente, não posso remover a função; isso quebraria, tipo, todo programa Dart sério que já existiu.

Então eu gostaria de pelo menos adicionar um novo método a `Future&lt;T&gt;` para que os usuários possam usar esse em vez do antigo, digamos algo como:

```dart
abstract class Future<T> {
  ...
  /// Catches any [error] of type [E].
  Future<T> onError<E>(FutureOr<T> handleError(E error, StackTrace stack)) =>
      this.catchError(...something clever...);
}
```

que você pode chamar assim:

```dart
Future<int> eventualInteger = ...;
eventualInteger.onError((FormatException e, s) => ...).then(...);
```

Infelizmente, não posso simplesmente adicionar isso à classe `Future`. Se fizer isso, também o adiciono à interface `Future`, e qualquer outra classe que implemente essa interface ficará incompleta e não compilará mais. Em certo ponto, contamos 76 classes implementando `Future`. Isso foi há um tempo, e paramos de contar. Ainda não podemos quebrar todo mundo, então essa opção também não está na mesa.

Bem, então vou usar uma função auxiliar estática:

```dart
Future<T> onFutureError<T, E>(Future<T> source, 
    FutureOr<T> handleError(E error, StackTrace stack)) =>
  source.catchError(...something clever...);
```

que você pode chamar assim:

```dart
Future<int> eventualInteger = ...;
onFutureError(eventualInteger, 
    (FormatException e, s) => ...).then(...);
```

Quase tão infelizmente, isso simplesmente não se lê bem. Nós *gostamos* de encadeamento de métodos baseado em `.` porque ele permite ler da esquerda para a direita: “Faça isto, depois faça aquilo, depois faça mais uma coisa”. Usar a função auxiliar estática nos obriga a ler assim: “Faça aquilo com o seguinte: Faça isto. Depois disso, faça mais uma coisa”… dizer o quê? Simplesmente não tem o mesmo *fluxo*, a mesma *schwung*. Na prática, é quase impossível de ler.

Ok, então, sem me deixar abater na minha busca, em vez de melhorar a classe `Future`, vou introduzir uma nova interface aprimorada e dar aos usuários uma forma de envolver a interface antiga:

```dart
class MyFuture<T> {
  Future<T> _wrappee;
  MyFuture(Future<T> future) : _wrappee = future;
  Future<T> onError<E>(
      FutureOr<T> handleError(E error, StackTrace stack)) =>
    _wrappee.catchError(...something clever...);
}
```

que você pode usar assim:

```dart
Future<int> eventualInteger = ...;
MyFuture(eventualInteger).onError(
    (FormatException e, s) => ...).then(...);
```

Provavelmente eu até deixaria `MyFuture` implementar `Future` e encaminhar todos os membros de `Future` para o future `_wrappee`, e então faria todos os métodos retornarem um wrapper `MyFuture` de novo, para que eu possa continuar encadeando.

```dart
class MyFuture<T> {
  Future<T> _wrappee;
  MyFuture(Future<T> future) : _wrappee = future;
  MyFuture<R> then<R>(...) => MyFuture(_wrappee.then<R>(...));
  /// Forward other `Future` methods too.
  MyFuture<T> onError<E>(
      FutureOr<T> handleError(E error, StackTrace stack)) =>
    MyFuture(_wrappee.catchError(...something clever...));
}
```

Bonito e fluido, se me permitem dizer!

Isso era praticamente o melhor que se conseguia, antes dos métodos de extensão… o que significava adicionar o wrapper manualmente e aceitar o custo de desempenho dos objetos wrapper extras e das funções de encaminhamento intermediárias.

## O que eu vou fazer com os métodos de extensão {:#what-i-will-do-with-extension-methods}

Quando sairmos da era das trevas sem extensões, posso usar métodos de extensão para conseguir exatamente o que eu realmente, realmente quero. Vou escrever:

```dart
extension MyFuture<T> on Future<T> {
  Future<T> onError<E>(
      FutureOr<T> handleError(E error, StackTrace stack)) =>
    this.catchError(...something clever...);
}
```

e aí você pode chamá-lo assim:

```dart
Future<int> eventualInteger = ...;
eventualInteger.onError((FormatException e, s) => ...).then(...);
```

e é isso. Missão cumprida em cinco linhas!

“Mas como isso *funciona*?”, você pode perguntar. Funciona muito bem, obrigado.

Na verdade, *ele se comporta quase exatamente da mesma forma que a classe wrapper*, mesmo sendo apenas uma função auxiliar estática. Você pode até escrever `MyFuture(eventualInteger).onError(...)` explicitamente, como se a extensão fosse uma classe wrapper. Não é, mas parece e age *quase* como se fosse. E você pode omitir o wrapping explícito e fazer com que ele seja aplicado *implicitamente* quando os tipos forem compatíveis.

## É (ou não é) uma classe wrapper {:#its-not-a-wrapper-class}

O design da declaração `extension` foi feito deliberadamente para parecer com uma declaração de `class` ou `mixin`, e ela age como se fosse uma classe wrapper com um `_wrappee` oculto. Você pode até ter membros estáticos na declaração, e eles funcionam exatamente como membros estáticos em uma declaração de `class` ou `mixin`.

Há uma *melhoria* em relação à classe wrapper: você pode escrever `this` dentro de membros de instância para se referir ao `_wrappee` em vez do objeto wrapper.

Mudar o significado de `this` não foi apenas uma melhoria. Estes são métodos de extensão *estáticos* e, como eu disse antes, eles são na verdade apenas uma forma mais conveniente de chamar funções estáticas. Isso significa que não há um *objeto* wrapper. Ele nunca existiu; apenas fingimos que existia, mas isso significa que não podemos deixar `this` se referir a um objeto que não existe.

Também não podemos permitir que você use `MyFuture(eventualInteger)` como um valor; então, se você tentar fazer `var myFuture = MyFuture(eventualInteger)`, não vamos permitir. A única forma de usar `MyFuture(eventualInteger)` é como alvo de uma invocação de membro de extensão.

```
MyFuture(eventualInteger).onError(...); // GOOD: Use to call method.
var x = MyFuture(eventualInteger); // BAD: Use as stand-alone value.
```


É o mesmo que acontece quando você usa `super` para chamar métodos, mas não pelo seu valor. Ou como um prefixo de biblioteca. Tudo o que você pode fazer é acessar um membro; você não pode tratá-lo como um valor porque ele não tem valor, e não há valor para ele ter.

Como não há objeto, você não pode declarar *campos de instância* em uma declaração `extension`. Você *pode* declarar getters e setters, e talvez até sustentá-los com um [`Expando`](https://api.dartlang.org/stable/2.5.1/dart-core/Expando-class.html). Uma extensão também não pode declarar nenhum construtor, já que nada está sendo construído; ela apenas finge ter um construtor que recebe o objeto wrappee.

## Ela (não) estende o tipo {:#it-does-not-extend-the-type}

Se você tivesse que escrever o wrapping `MyFuture(...)` toda vez que usasse um membro de extensão, isso não seria uma grande melhoria. Provavelmente poderíamos simplesmente escrever as classes wrapper diretamente e gastar algumas horas de engenheiros de compilador garantindo que eliminaríamos o objeto intermediário na otimização.

Eu disse acima que você pode escrever `eventualInteger.onError(...)`. Isso funciona porque nós *envolvemos implicitamente* expressões com base no tipo estático delas e no nome do membro que elas chamam. Envolvemos automaticamente `expr.method()` como `Ext(expr).method()` quando todas as condições a seguir são verdadeiras:

* O tipo estático de `expr` não tem um membro com nome base `method` (a interface sempre vence).

* A extensão `Ext` é importada ou declarada no escopo da biblioteca atual (a extensão é *acessível*).

* A extensão declara um membro com nome base `method`, *e* o tipo estático de `expr` é um subtipo do tipo `on` da declaração `Ext` (a extensão é *aplicável*).

Se houver mais de uma extensão acessível e aplicável para uma invocação de membro, há regras sobre qual delas vence o conflito. Em alguns casos, não há como escolher um vencedor, e então isso é apenas um erro de compilação. Essas regras dependem apenas do tipo `on` da declaração da extensão, não da declaração do membro. (O Dart não tem “sobrecarga”, ou seja, múltiplos métodos com o mesmo nome e assinaturas diferentes, entre os quais você escolhe com base na estrutura ou nos tipos dos argumentos; e os métodos de extensão não oferecem uma porta dos fundos para conseguir sobrecarga.)

## Tudo é estático {:#it-is-all-static}

Eu disse “métodos de extensão *estáticos*” acima, e fiz isso por um motivo!

O Dart é estaticamente tipado. O compilador conhece o tipo de cada expressão em tempo de compilação, então, se você escrever `target.member(42)`, e `member` for um membro de extensão, o compilador precisa descobrir *qual* extensão usar para envolver `target` implicitamente, a fim de encontrar o tipo de toda a invocação do membro.

Se o wrapping implícito de extensão precisa acontecer *entre* descobrir o tipo da expressão alvo *e* descobrir o tipo da invocação do membro, parece óbvio que a “inferência de extensão” precisa acontecer durante a fase de “inferência de tipos”, cujo nome é cada vez mais impreciso. Essa é a fase mais conhecida por preencher genéricos ausentes.

Eu escrevi `eventualInteger.onError((FormatException e, s) {...})`, mesmo que tanto a extensão `MyFuture` quanto o método `onError` sejam genéricos. Durante a inferência de tipos, o compilador do Dart seleciona a extensão e infere os argumentos de tipo ausentes. Aqui, ele primeiro decide usar a extensão `MyFuture`, depois insere o wrapper implícito e, por fim, realiza a inferência de tipos para a aplicação da extensão `MyFuture(eventualInteger).onError((FormatException e, s) {...})` *exatamente da mesma forma* como faria para uma classe wrapper correspondente:

```dart
class MyFuture<T> {
  Future<T> _wrappee;
  MyFuture(Future<T> future) : _wrappee = future;
  MyFuture<T> onError<E>(
      FutureOr<T> handleError(E error, StackTrace stack)) =>
    _wrappee.catchError(...something clever...);
}
```

Nesse caso, a inferência de tipos deduziria a seguinte aplicação da extensão e os tipos completos da invocação:

```dart
MyFuture<int>(eventualInteger).onError<FormatException>(
    (FormatException e, StackTrace s) {...});
```

Isso significa que *os argumentos de tipo da extensão são baseados no tipo estático da expressão envolvida*. Se você tiver um `Future&lt;num&gt; fut = Future&lt;int&gt;.value(42);`, então `fut.onError(...)` vai vincular o parâmetro de tipo `T` de `MyFuture` a `num` em tempo de compilação, e não a `int`. É tudo estático, assim como para quaisquer outros argumentos de tipo inferidos.

Isso também significa que você nunca poderá chamar um membro de extensão em um alvo tipado como `dynamic`.

## Resolução de conflitos {:#conflict-resolution}

Como foi dito acima, há regras sobre qual extensão vence quando há mais de uma no escopo que se aplica. Basicamente, o vencedor é a extensão com um tipo `on` mais próximo do tipo real da expressão na qual você está chamando um membro, com algumas ressalvas e critérios de desempate. Normalmente, ela simplesmente “funciona” para extensões escritas juntas. Em vez de entrar nesses detalhes, vou dizer o que fazer quando ela *não* funciona simplesmente.

Você pode ter um problema quando dois autores diferentes escreveram extensões conflitantes para o mesmo tipo e nome de membro. Digamos que as extensões `Ext1` e `Ext2` definam ambas um método `bubbleSort` que se aplica ao seu objeto `List`, e ou não há um vencedor claro para o conflito, ou o que vence não é o que você realmente quer chamar (digamos que `Ext2` vença e você queira chamar `Ext1.bubbleSort`). Aí você precisa fazer *alguma coisa*.

A solução mais fácil é usar uma aplicação explícita de extensão: `Ext1(list).bubbleSort()`. Isso evita a resolução automática e simplesmente escolhe aquela que você quer. Se você tiver apenas alguns conflitos, isso é ao mesmo tempo fácil e legível.

Porém, se você tiver trezentos conflitos no mesmo arquivo, talvez queira evitar a digitação extra. É difícil mudar se uma extensão é *aplicável* a uma invocação, mas você pode mudar se ela é *acessível*.

Você faz isso *ocultando* a extensão conflitante (ou extensõe*s*, se tiver muito azar) onde a importa: `import "ext2lib.dart" hide Ext2;`. Isso impede que a extensão `Ext2` seja importada para o escopo da biblioteca atual, o que a torna inacessível. Obviamente, não importar `ext2lib.dart` também faria isso, mas, a menos que a extensão seja a única coisa que você usa dessa biblioteca, isso não é prático.

(Editado em 11 de dezembro) Aqui eu costumava dizer que você podia importar uma das extensões conflitantes com um *prefixo* e que, assim, ela não ficaria disponível para uso implícito. Acontece que algumas pessoas declaram métodos de extensão na mesma biblioteca da classe que estendem, e é muito irritante se essa biblioteca não funciona quando importada com um prefixo. Então corrigimos isso. Extensões importadas com um prefixo *também* funcionam implicitamente. Se você realmente precisar usar duas extensões conflitantes na mesma biblioteca, vai precisar usar aplicação explícita de extensão em todos os lugares onde houver conflito. Podemos considerar adicionar uma forma diferente de desabilitar extensões implícitas no futuro, pelo menos se extensões conflitantes se mostrarem um problema recorrente.

## Resumo {:#summary}

O Dart terá *métodos de extensão* em uma próxima versão *—* uma forma bonita de chamar funções estáticas.

Você pode definir membros de extensão para **métodos de instância**, **operadores**, **setters** e **getters**, mas **não campos**.

Você pode invocar métodos de extensão de forma explícita ou, quando não há conflito com um membro da interface ou com outra extensão, de forma implícita:

```
Ext1(list).bubbleSort() // Explicit, like it's a wrapper class.
list.bubbleSort()       // Implicitly, like it extends the type.
```


Invocações implícitas funcionam da mesma forma que as explícitas, mas primeiro *inferem* qual extensão está sendo aplicada. Se a inferência de extensão falhar por causa de extensões conflitantes, você pode fazer qualquer uma das seguintes coisas:

* Aplicar a extensão explicitamente.

* Não importar a extensão conflitante de forma alguma (remover o import ou ocultar a extensão).

* (Editado em 11 de dezembro): E é isso (por enquanto).

Extensões são *estáticas*. Tudo sobre elas é decidido com base em tipos estáticos.

Aproveite com responsabilidade!
