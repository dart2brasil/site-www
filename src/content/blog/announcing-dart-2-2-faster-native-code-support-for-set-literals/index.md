---
ia-translate: true
title: "Anunciando o Dart 2.2: código nativo mais rápido, suporte a set literals"
description: "Hoje anunciamos o lançamento stable do SDK do Dart 2.2, uma atualização incremental do Dart 2 que oferece melhor desempenho de…"
publishDate: 2019-02-26
author: mit-mit
image: images/1saXdrIB-SjU2EL7gLGPUsA.webp
category: releases
layout: blog
---


Hoje anunciamos o lançamento stable do SDK do Dart 2.2, uma atualização incremental do Dart 2 que oferece melhor desempenho do código nativo [compilado ahead-of-time (AOT)](https://en.wikipedia.org/wiki/Ahead-of-time_compilation) e um novo recurso de linguagem: set literals.

<DashImage src="images/1saXdrIB-SjU2EL7gLGPUsA.webp" alt="Dart 2.2 release banner highlighting improved AOT performance and set literal language support." />


## Melhorias de desempenho do Dart para desenvolvedores Flutter {:#dart-performance-improvements-for-flutter-developers}

Continuamos trabalhando para tornar ainda mais rápido o [código compilado com AOT](https://hackernoon.com/why-flutter-uses-dart-dd635a054ebf), como o de aplicações Flutter. No Dart 2.1, [reduzimos o custo das verificações de tipo](/blog/announcing-dart-2-1-improved-performance-usability), diminuindo muito o custo dessas verificações tanto para o código compilado com AOT quanto para o código executado na VM com compilação JIT (just-in-time).

No Dart 2.2, focamos especificamente no desempenho do código compilado com AOT, melhorando esse desempenho em [11–16% em microbenchmarks](https://github.com/flutter/flutter/pull/27789#issuecomment-464234710) (ao custo de um aumento de cerca de 1% no tamanho do código). Essa melhoria é fruto de vários trimestres de trabalho para reduzir a sobrecarga das chamadas estáticas. Agora, o código AOT otimizado consegue chamar o destino diretamente usando uma chamada relativa ao PC (ou seja, usando o [program counter](https://en.wikipedia.org/wiki/Program_counter)); antes, precisávamos fazer várias buscas em um object pool para determinar o endereço de destino. Essas otimizações são especialmente úteis quando o código contém muitas chamadas de construtores e de métodos estáticos, como o código de interface do Flutter que cria muitos widgets.

## Recurso de linguagem set literals no Dart 2.2 {:#dart-2-2-set-literal-language-feature}

A biblioteca core do Dart (`dart:core`) contém várias classes de coleções para modelar [Maps](https://api.dartlang.org/stable/dart-core/Map-class.html), [Lists](https://api.dartlang.org/stable/dart-core/List-class.html) e [Sets](https://api.dartlang.org/stable/dart-core/Set-class.html) de objetos. Maps são coleções de pares chave-valor. Lists são sequências ordenadas de valores, em que cada valor pode ser acessado por um índice e pode aparecer mais de uma vez. Sets são coleções não ordenadas de valores, em que cada valor pode aparecer apenas uma vez, e em que é possível verificar de forma eficiente se um valor está no set.

Coleções em Dart costumam ser inicializadas com constantes de tempo de compilação, por isso o Dart tem uma sintaxe literal prática para expressar essa inicialização. No Dart, uma List pode ser inicializada assim:

```dart
const List<String> releases = ['Dart 2.0', 'Dart 2.1', 'Dart 2.2'];
```


Antes, o Dart suportava a sintaxe literal apenas para Lists e Maps, então inicializar Sets era trabalhoso, já que era preciso inicializá-los por meio de uma lista:

```dart
Set<String> currencies = Set.of(['EUR', 'USD', 'JPY']);
```


Esse código não é apenas inconveniente e ineficiente; a falta de suporte a literais impede que `currencies` seja uma constante de tempo de compilação. Com a extensão de literais para sets no Dart 2.2, podemos inicializar um set e torná-lo const usando uma nova sintaxe prática:

```dart
const Set<String> currencies = {'EUR', 'USD', 'JPY'};
```


Para exemplos reais de como a equipe do Flutter está começando a aplicar set literals, veja o [PR #27811](https://github.com/flutter/flutter/pull/27811). Para detalhes mais gerais sobre como usar set literals, veja o [tour da linguagem Dart 2.2 atualizado](https://www.dartlang.org/guides/language/language-tour#sets).

## Construindo novos recursos de linguagem com o Dart 2 Common Front-End (CFE) {:#building-new-language-features-with-the-dart-2-common-front-end-cfe}

As implementações da linguagem Dart — a VM do Dart usada pelo Flutter, o compilador dart2js e o Dart dev compiler (dartdevc) — compartilham um front end comum. O Dart Common Front End, ou CFE, faz o parse do código Dart, realiza a inferência de tipos e traduz o Dart para uma linguagem intermediária de nível mais baixo, que as implementações de back end aceitam como entrada.

O recurso de set literals é um exemplo de construção de linguagem que conseguimos desenvolver rapidamente graças ao CFE. O código para fazer o parse de set literals e realizar a inferência de tipos foi implementado uma única vez no CFE, para todos os back ends do Dart. Além disso, criamos uma implementação transitória, apenas de front end, que os back ends podiam usar inicialmente. Na implementação transitória, a versão não const do set literal `currencies` acima era traduzida durante a compilação para o equivalente a:

```dart
Set<String> currencies = Set<String>()..add('EUR')..add('USD')..add('JPY');
```


A implementação transitória de set literals const é diferente, porque sets const não podem ser montados incrementalmente, em partes. Em vez disso, implementamos isso com base em uma classe privada de set imutável que encapsula um map const, em que os elementos do set são as chaves do map:

```dart
const Set<String> currencies =
   _UnmodifiableSet<String>({'EUR': null, 'USD': null, 'JPY': null});
```


A classe de set imutável implementa os métodos da interface Set com base no map encapsulado.

No geral, conseguimos implementar set literals inicialmente como um recurso apenas do CFE. Os back ends podiam usar a implementação do CFE de início e, depois, desenvolver o próprio suporte nativo de forma independente do lançamento inicial do recurso. Isso permitiu que os back ends adiassem o suporte nativo até que os aspectos de desempenho desse recurso fossem mais bem compreendidos.

## Especificação da linguagem Dart 2.2 {:#dart-2-2-language-specification}

O Dart 2 foi uma [atualização tão substancial](/blog/announcing-dart-2-stable-and-the-dart-web-platform) para o Dart que levamos um tempo para atualizar a [especificação formal da linguagem Dart](https://www.dartlang.org/guides/language/spec) de modo a refletir todas as mudanças que fizemos. Finalmente concluímos esse trabalho, e a especificação está atualizada a partir do Dart 2.2. Também movemos o código-fonte da especificação para o novo [repositório da linguagem](https://github.com/dart-lang/language/tree/master/specification) e adicionamos integração contínua para garantir que um rascunho contínuo da especificação seja gerado em PDF conforme evoluímos a especificação para as próximas versões da linguagem Dart. As especificações do Dart 2.2 e a do Dart 2.x contínua estão disponíveis na [página de especificação do Dart](https://www.dartlang.org/guides/language/spec).

## Como obter o Dart 2.2 {:#getting-dart-2-2}

O [SDK do Dart 2.2](https://www.dartlang.org/tools/sdk/archive) está disponível na página inicial do Dart a partir de hoje. Se você é desenvolvedor Flutter, o Dart 2.2 já está incluído. (*Observação*: os canais master e dev atuais do Flutter vão informar Dart 2.2. O [Flutter 1.2 de hoje](https://developers.googleblog.com/2019/02/launching-flutter-12-at-mobile-world.html), na versão stable, vai informar Dart 2.1.2; ele tem os mesmos recursos do Dart 2.2).

Por enquanto é isso. Esperamos que você goste do Dart 2.2!
