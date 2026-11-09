---
ia-translate: true
title: "Dart 2: O legado do `void`"
description: "Uma das perguntas que mais vejo nas comunidades do StackOverflow, do Gitter e até nos canais de suporte internos do Google é a diferença entre…"
publishDate: 2018-08-30
author: matanlurey
image: images/1qGU6soDvCW0RFfDX8vpUow.webp
category: deep-dive
layout: blog
---


<DashImage src="images/1qGU6soDvCW0RFfDX8vpUow.webp" alt="Mapa de superaglomerados e vazios cósmicos, com o Vazio de Boötes e outros vazios circulados." caption="Uma representação semi-precisa do [universo](https://en.wikipedia.org/wiki/Bo%C3%B6tes_void) de tipos do tipo vazio no Dart 2" />


Uma das perguntas que mais vejo nas comunidades do StackOverflow, do Gitter e até nos canais de suporte internos do Google é a diferença entre os seguintes tipos embutidos no Dart 2: `Object`, `dynamic`, `void` e `Null`.

Resumindo, `Null` ([ou `Bottom` em outras linguagens](https://en.wikipedia.org/wiki/Bottom_type), ou seja, “Nothing”) não deve ser usado na maioria do código real de usuários, e eu suspeito que veremos mais artigos e lints no futuro próximo para desencorajar o uso de forma gentil.

Os outros três não são tão claros, porque, no Dart 2, qualquer coisa pode ser `dynamic`, `Object` ou `void` em tempo de execução, variando apenas pela assinatura de tipo *estático*. Então, vamos ver alguns exemplos práticos de *quando* você deve usar cada assinatura de tipo.

## Object {:#object}

[`Object`](https://api.dartlang.org/stable/2.0.0/dart-core/Object-class.html) é a classe raiz da hierarquia de classes do Dart, e toda outra classe do Dart é uma subclasse de `Object`, incluindo tipos “primitivos” como `int`, `double` ou `bool`. Ele garante algumas coisas: uma [propriedade `hashCode`](https://api.dartlang.org/stable/2.0.0/dart-core/Object/hashCode.html), um [operador `==`](https://api.dartlang.org/stable/2.0.0/dart-core/Object/operator_equals.html) e um [método `toString`](https://api.dartlang.org/stable/2.0.0/dart-core/Object/toString.html).

Na prática, eu uso `Object` como uma espécie de union type improvisado, esperando que os usuários usem o operador `is` para descobrir o tipo real de algo antes de usá-lo. **Eu não uso `dynamic`**, porque, como descrito na próxima seção, ele desativa análises estáticas importantes e facilita colocar o programa em um estado inválido.

```
Object readProperty(String name) { ... }

void main() {
  var age = readProperty('name');
  if (age is int) {
    print('I am $age years old');
  } else if (age is String) {
    print(age);
  }
}
```


Outra opção é usar `Object` para declarar que você *não se importa* com o tipo interno de uma estrutura de dados. Por exemplo, `List&lt;Object&gt;` pode significar “uma lista de qualquer coisa”. Isso é útil, por exemplo, ao escrever uma função que combina o `hashCode` de todos os elementos de uma `List`:

```
int hashList(List<Object> elements) { ... }
```


Uma boa propriedade de `Object` (em comparação com `dynamic`) é que você recebe feedback imediato da análise e do compilador se tentar chamar um método nele que não existe de forma confiável. Por exemplo, o código a seguir produz um *erro estático*:

```
void main() {
  Object a = 5;
  a.aMethodThatDoesNotExist();
}
```


Na prática, porém, `Object` é bastante limitado (e intencionalmente). Espero que [o Dart ganhe suporte a sobrecarga de métodos](https://github.com/dart-lang/sdk/issues/26488) e que isso me permita reduzir drasticamente o uso do tipo `Object` em código real.

## dynamic {:#dynamic}

Eu pessoalmente **nunca** uso o tipo `dynamic` no Dart 2. Do meu ponto de vista, ele é uma espécie de união entre `Object` e uma instrução especial que diz às ferramentas e aos compiladores para *desativar as verificações de análise estática*. Ou seja, o código a seguir é válido e só apresentará um erro em tempo de execução (não estaticamente!):

```
void main() {
  dynamic x = 5;
  x.aMethodThatDoesNotExist();
}
```


No Dart 1, `dynamic` estava em todo lugar, e qualquer outro tipo estático servia apenas para dar suporte à IDE e à análise estática, mas o compilador (e o runtime) tratavam tudo como `dynamic`. Ainda existem algumas “pegadinhas” infelizes no Dart 2 que podem criar acidentalmente uma variável tipada como `dynamic`, porém:

```
computeAge() => 5; // Return type is dynamic

void main() {
  var name; // Static type is dynamic
  var animals = []; // Static and runtime type is List<dynamic>
}
```


Pior ainda, chamadas `dynamic` perdem informações de tipo que são vitais no Dart 2:

```
class User {
  String name;
}

void main() {
  var users = []; // Implicitly List<dynamic>, remember?
  users.add(new User()..name = 'Matan');

  // Runtime error: List<dynamic> is not a Iterable<String>
  Iterable<String> names = users.map((u) => u.name);
}
```


O motivo desse erro é que a chamada real aqui é:

```
users.map((dynamic u) => u.name);
```


… que não tem informação de tipo estático suficiente para produzir um `Iterable&lt;String&gt;`. Ao corrigir `users` para ter o tipo adequado (e evitando chamadas dynamic), tudo funciona:

```
void main() {
  // We also could have written `var users = <User>[
  var users = [new User()..name = 'Matan'];

  // OK!
  Iterable<String> names = users.map((u) => u.name);
}
```


## void {:#void}

Por fim, temos `void`, o tipo mais novo do Dart 2. No Dart 1, `void` só podia ser usado como tipo de retorno de uma função (como em `void main()`), mas no Dart 2 ele foi *generalizado* e pode ser usado em outros lugares, por exemplo, em `Future&lt;void&gt;`.

Um tipo `void` é semanticamente parecido com `Object` (pode ser qualquer coisa), exceto por restrições adicionais: um tipo `void` não pode ser usado para nada (nem mesmo `==` ou `hashCode`), e é inválido atribuir algo a um tipo `void`:

```
void foo() {}

void main() {
  var bar = foo(); // Invalid
}
```


Na *prática*, eu uso `void` para significar “qualquer coisa, e eu não me importo com os elementos” ou, mais comumente, para significar “omitido”, como em `Future&lt;void&gt;` ou `Stream&lt;void&gt;`:

```
/// Clear the cache.
Future<void> purgeCache() { ... }
```


No trecho de código acima, não quero que os usuários tentem usar o valor de retorno do `Future` fornecido, porque ele não é relevante. Já vi exemplos de uso de `Future&lt;Null&gt;` para esse propósito, e isso era, na verdade, um contorno *antes* de ser possível usar `Future&lt;void&gt;`.

Por exemplo, isto é estaticamente OK, mas inválido em tempo de execução no Dart 2:

```
import 'dart:async';

Future<String> _doAThing() async => 'Test';
Future<Null> doAThing() async => _doAThing();

void main() async {
  // Future<String> is not a subtype of type FutureOr<Null>
  await doAThing();
}
```


… enquanto usar `Future&lt;void&gt;` para `doAThing()` é válido e correto.

Outro exemplo pode ser um `Stream` que dispara sem nenhum dado de evento:

```
/// Fires an event when a user signs-out of the system.
Stream<void> get onLogOut { ... }
```


Outro uso mais prático é implementar uma classe com argumentos de tipo genérico que você não vai usar. Por exemplo, ao implementar o popular [padrão `Visitor`](https://en.wikipedia.org/wiki/Visitor_pattern), podemos ignorar o argumento de tipo `C` (contexto) quando ele não é usado, passando `void`:

```
abstract class Visitor<N, C> {
  N visitNode(N node, [C context]);
}

class IdentityVisitor<N> extends Visitor<N, void> {
  @override
  N visitNode(N node, [_]) => node;
}
```


Espero que este breve artigo ajude você com as decisões de API sobre o uso de `Object`, `dynamic` e `void`. Deixe comentários se tiver outras perguntas ou ideias!
