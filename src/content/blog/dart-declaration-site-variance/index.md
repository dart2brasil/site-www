---
ia-translate: true
title: "Variância no nível de declaração do Dart"
description: "Um mergulho profundo em um recurso experimental"
publishDate: 2019-12-19
author: kallentu
image: images/0XcEdm2vmIBW8Wovr.webp
category: deep-dive
layout: blog
---


<DashImage src="images/0XcEdm2vmIBW8Wovr.webp" alt="Gráfico mostrando a variância no nível de declaração do Dart." />


A variância no nível de declaração foi o meu projeto de estágio na equipe do Dart, e documentei minha experiência pessoal na equipe no artigo [Minha vida como estagiário do Dart](/blog/life-as-a-dart-intern). Como principal implementador do [recurso de variância no nível de declaração](https://github.com/dart-lang/language/issues/524), quero compartilhar os usos e os benefícios da variância sólida.

Vamos discutir como usar a variância, por que queremos usar os modificadores, como o recurso pode se apoiar em classes que não usam os modificadores e quais benefícios ele nos traz.

***Nota:** A implementação da variância ainda não está concluída. Embora você possa testá-la habilitando o experimento (instruções abaixo), o recurso pode mudar antes de ser finalizado.*

Antes de mergulhar no recurso de variância no nível de declaração do Dart, vamos fazer um breve desvio para discutir o que é variância e como ela é usada.

## **O que é variância?** {:#what-is-variance}

Para introduzir rapidamente a variância, podemos olhar para este exemplo:

```dart
main() {
  Iterable<Object> objectIterable = <int>[1, 2, 3];
}
```

Daí, um `Iterable` de inteiros pode ser substituído por um `Iterable` de `Object`s, porque um inteiro *é* um `Object` e pode ser usado em um `Iterable` em todo lugar em que um `Object` seria usado. A linguagem permite isso afirmando que duas instanciações do mesmo tipo genérico (como `Iterable&lt;int&gt;` e `Iterable&lt;Object&gt;` aqui) são consideradas subtipos se os argumentos de tipo delas (`int` e `Object`) também forem. Essa relação de subtipagem é considerada **covariância**.

Isso é conveniente e lógico. Faz sentido, isto é, até você olhar para a variância dos parâmetros de um método. Digamos que você queira criar um `objectWriter` em Dart:

```dart
class Writer<T> {
  void write(T x) => print(x);
}

main() {
  Writer<Object> objectWriter = Writer<int>();
  objectWriter.write(2);
}
```

Então, você pede avidamente que o seu `objectWriter` escreva uma `String` e descobre que isso produz um erro em tempo de execução. O compilador permite esse código, mas, quando você o executa, ele lança uma exceção.

```dart
main() {
  // ...
  // Runtime error!
  // Unhandled exception: type 'String' is not a subtype of type 'int' of 'x'
  objectWriter.write("Hello world!");
}
```

Por que isso acontece? Com **contravariância**, a relação de subtipagem é invertida em comparação com a covariância. Precisamos ser capazes de *escrever* qualquer `Object` no `objectWriter`, mas, pelo que vimos antes, sabemos que o `objectWriter` é na verdade um escritor disfarçado de inteiros.

O último tipo de variância que você precisa conhecer é a **invariância**. Uma relação de subtipagem invariante significa que não há relação de subtipo entre dois tipos invariantes, a menos que sejam exatamente o mesmo tipo.

```dart
class ReaderWriter<T> {
  void write(T x) => print(x);
  T read() => null;
}

main() {
  ReaderWriter<int> intRW = ReaderWriter<Object>();
  
  // Any object can be returned, not just integers. This is unsafe.
  intRW.read(); 

  ReaderWriter<Object> anotherObjectRW = ReaderWriter<int>();
  
  // We actually have an integer ReaderWriter. Error!
  anotherObjectRW.write(“Hello world!”); 
}
```

## **O que é o recurso de variância no Dart?** {:#what-is-the-variance-feature-in-dart}

Como a equipe do Dart propôs adicionar modificadores de variância explícitos à linguagem, vamos mostrar uma prévia de algumas das mudanças que podem ser esperadas.

O Dart terá modificadores de variância que podem ser aplicados a parâmetros de tipo em classes e mixins. A sintaxe é semelhante aos modificadores de variância do C#.

Você pode usar as palavras-chave `out`, `in`*,* e `inout` para declarar, respectivamente, um parâmetro de tipo covariante, contravariante e invariante. Isso é usado com tipos genéricos assim:

```dart
class MyContravariantClass<in T> {}
mixin MyInvariantMixin<inout T> {}
```

## **Por que definir variância explícita para tipos genéricos? Por que queremos esse recurso?** {:#why-define-explicit-variance-for-generic-types-why-do-we-want-this-feature}

O sistema de tipos estático do Dart atualmente trata todos os parâmetros de tipo como covariantes. Isso está correto e é conveniente para genéricos em que o tipo é usado em um lugar seguramente covariante, como um tipo de retorno. Mas está errado quando o argumento de tipo deveria ser contravariante ou invariante:

```dart
class Writer<T> {
  void write(T x) => print(x);
}

main() {
  Writer<Object> objectWriter = Writer<int>();
  objectWriter.write(“I’m a string!”);
}
```

Quando você usa `objectWriter`, você *espera* poder escrever qualquer `Object`. Infelizmente, o `objectWriter` só escreve inteiros. O compilador não sabe de nada e, quando você executa o código, recebe o temido erro em tempo de execução. Para evitar a falta de solidez, o Dart lança um erro em tempo de execução se você usar um argumento de tipo de forma insegura.

Felizmente, adicionar um modificador de variância transforma esse uso incorreto de um erro em tempo de execução em um erro em tempo de compilação.

```dart
// Add a contravariant variance modifier
class Writer<in T> {  
  void write(T x) => print(x);
}

main() {
  // Compile-time error: The constructor returns type 'Writer<int>'
  // that isn't of expected type 'Writer<Object>'.
  Writer<Object> objectWriter = Writer<int>();
}
```

Isso é bem melhor. Muito antes de você escrever `objectWriter.write("I'm a string!")`, o compilador vai avisar que há algo errado.

Agora, vamos ver o que adicionar parâmetros de tipo seguros com um modificador de variância oferece a você.

## **Parâmetros de tipo em membros** {:#type-parameters-in-members}

Se você marcar um parâmetro de tipo genérico com `out`, o compilador emite um erro estático se você usar esse tipo em um método ou campo em um lugar que não seja seguramente covariante, como um tipo de retorno. Da mesma forma, um parâmetro de tipo marcado com `in` só pode ser usado em um lugar que seja seguramente contravariante, como o tipo de um parâmetro de método. Parâmetros de tipo marcados com `inout` podem ser usados em qualquer lugar.

Aqui estão alguns erros de posição de variância em métodos e usos corretos que podem ser úteis para você. A mesma verificação de erros também ocorre para mixins.

```dart
class Reader<out T> {
  // Compile-time error: Can't use 'out' type variable 'T' in an 'in' position.
  void write(T x) => print(x);

  // OK
  T read() => null;
}

class Writer<in T> {
  // Compile-time error: Can't use 'in' type variable 'T' in an 'out' position
  // in the return type.
  T read() => null;

  // OK
  void write(T x) => print(x); 
}

class ReaderWriter<inout T> {
  // Both OK
  void write(T value) => print(x);
  T read() => null;
}
```

Erros também podem ser emitidos em campos.

```dart
class Reader<out T> {
  // Compile-time error: Can't use 'out' type variable 'T' in an 'in' position.
  T readableWritableValue;
  
  // OK
  final T readableValue; 
}

class Writer<in T> {
  // Compile-time error: Can't use 'in' type variable 'T' in an 'out' position.
  T readableWritableValue;
  
  // Compile-time error: Can't use 'in' type variable 'T' in an 'out' position.
  final T readableValue;
}

class ReaderWriter<inout T> {
  // Both OK
  T readableWritableValue;
  final T readableValue; 
}
```

## **Atribuição e subtipagem** {:#assignment-and-subtyping}

Os erros que o compilador reporta por mau uso de parâmetros de tipo ajudam o autor da classe genérica a **escrever** código correto. A outra metade é o conjunto de erros que ajudam os demais a **usar** a classe corretamente. Uma das mudanças que acompanham os modificadores de variância sólida é a mudança de subtipagem que podemos ver na atribuição.

Se um parâmetro de tipo genérico é covariante, então você pode atribuí-lo quando o argumento de tipo dele é um subtipo do argumento de tipo esperado. Por exemplo, você pode atribuir um `Reader&lt;int&gt;` a algo que espera um `Reader&lt;Object&gt;`.

```dart
class Reader<out T> { /* ... */ }
main() {
  Reader<Object> objectReader = Reader<int>();
}
```

Da mesma forma, se um parâmetro de tipo genérico é contravariante, a atribuição é permitida quando o argumento de tipo dele é um supertipo do argumento de tipo esperado. Você pode atribuir um `Writer&lt;Object&gt;` a algo que espera um `Writer&lt;int&gt;`, assim:

```dart
class Writer<in T> { /* ... */ }
main() {
  Writer<int> intWriter = Writer<Object>();
}
```

Para parâmetros invariantes, o argumento de tipo precisa ser exatamente o mesmo tipo.

```dart
class ReaderWriter<inout T> { /* ... */ }
main() {
  ReaderWriter<int> intReader = ReaderWriter<int>();
}
```

## **Herança de interfaces** {:#interface-inheritance}

Então você pode estar se perguntando: “*Podemos optar por uma verificação em tempo de compilação mais rigorosa com variância, mesmo ao estender classes antigas?”* A boa notícia é que sim; no entanto, há algumas restrições.

Parâmetros `out` só podem estender posições de parâmetro que sejam covariantes ou que tenham a variância padrão do Dart.

Tenha em mente que quaisquer métodos herdados de classes legadas ainda podem ser variantes de forma insegura e, portanto, ainda podem causar erros em tempo de execução. Caso contrário, todos os novos métodos de uma subclasse com parâmetros de tipo que tenham modificadores de variância emitirão erros se os tipos estiverem em posições inseguras.

```dart
class LegacyReader<T> {}
class NewReader<out T> extends LegacyReader<T> {} // OK

class Reader<out T> {}
class IntegerReader<out T> extends Reader<T> {} // OK
```

Parâmetros `in` só podem estender posições de parâmetro que sejam contravariantes.

```dart
class Writer<in T> {}
class StringWriter<in T> extends Writer<T> {} // OK
```

Parâmetros `inout` podem estender todas as posições de parâmetro. No entanto, um parâmetro definido como `inout` só pode ser herdado por outras posições invariantes.

```dart
class ReaderWriter<inout T> {}
class NewReaderWriter<inout T> extends LegacyReader<T> {} // OK
class IntegerReaderWriter<inout T> extends Reader<T> {} // OK
class StringReaderWriter<inout T> extends Writer<T> {} // OK
```

## Como posso dar feedback sobre o recurso de variância? {:#how-can-i-give-feedback-on-the-variance-feature}

Recomendamos testar o recurso de variância usando o [canal dev mais recente](https://dart.dev/get-dart#about-release-channels-and-version-strings). Brinque com este exemplo para entender como a variância funciona e o que ela pode fazer por você.

```dart
class Writer<in T> {
  void write(T value) => print(value);
}

class Reader<out T> {
  final T value;
  Reader(this.value);
  T read() => value;
}

main() {
  Writer<int> intWriter = Writer<Object>();
  intWriter.write(2);

  Reader<Object> objectReader =
    Reader<String>("Wow, this is soundly variant!");
  print(objectReader.value);
}
```

Como o recurso de variância ainda está sendo implementado, você precisa definir uma flag experimental para habilitá-lo:

```
dart --enable-experiment=variance variance_example.dart
```


Agradecemos qualquer feedback! Você pode nos contar o que acha [nesta issue do GitHub](https://github.com/dart-lang/language/issues/524).

## **Resumo** {:#summary}

Os genéricos atuais do Dart são covariantes por padrão, o que facilita começar a escrever novas classes e dar os primeiros passos. Isso significa, porém, que mais erros aparecem em tempo de execução em vez de em tempo de compilação. O usuário também paga o custo de verificações adicionais em tempo de execução. A ideia principal por trás da variância é oferecer aos usuários verificações de erro mais informativas em tempo de compilação.

A variância é definida apenas para os parâmetros de classes genéricas e mixins. Os usuários podem usar o recurso de variância adicionando uma das palavras-chave `in`, `out` ou `inout` antes de um parâmetro de tipo.

Além disso, novas interfaces genéricas com esses modificadores podem estender interfaces legadas sem modificadores de variância.

A variância no nível de declaração permite que você colha vários benefícios novos, incluindo:

* Verificação, em tempo de compilação, de posições de variância dentro dos membros da interface

* Remoção dos chatos erros em tempo de execução que ocorrem com conversões para baixo e para cima (downcast e upcast)

* Mudanças adicionais de subtipagem baseadas na variância declarada

* Verificação de erros mais informativa e acessível

Agora você não precisa mais se preocupar se esse `objectWriter` é *de verdade* um escritor de qualquer objeto. Você *sabe* que é.
