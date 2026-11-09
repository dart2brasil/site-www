---
ia-translate: true
title: "Anunciando o Dart 3"
description: "Null safety 100% sólido. Records, patterns e class modifiers. 
E uma espiada no futuro."
publishDate: 2023-05-10
author: mit-mit
image: images/12XwxNKHrKb3SGaWEyqg2nA.webp
category: releases
layout: blog
---


### Null safety 100% sólido. Records, patterns e class modifiers. E uma espiada no futuro. {:#100-sound-null-safety-records-patterns-and-class-modifiers-and-a-peek-into-the-future}

Olá do Google I/O 2023. Hoje, ao vivo de Mountain View, anunciamos o Dart 3, a maior versão do Dart até hoje! O Dart 3 traz três grandes avanços. Primeiro, completamos a jornada rumo ao null safety 100% sólido. Segundo, adicionamos grandes novos recursos de linguagem para records, patterns e class modifiers. Terceiro, damos uma prévia do futuro, em que ampliamos o suporte às plataformas com código nativo para a web por meio da compilação para Wasm. Vamos aos detalhes.

<DashImage src="images/12XwxNKHrKb3SGaWEyqg2nA.webp" alt="Banner de lançamento do Dart 3 com o logo do Dart e um ícone de alvo." />


## Null safety 100% sólido {:#100-sound-null-safety}

Nos últimos quatro anos, evoluímos o Dart para uma linguagem rápida, portátil e moderna. Agora, com o Dart 3, ele é uma linguagem com null safety 100% sólido! Como [já discutimos antes](/blog/the-road-to-dart-3-a-fully-sound-null-safe-language), não acreditamos que nenhuma outra linguagem de programação tenha adicionado null safety sólido a uma linguagem existente. Então, foi uma jornada e tanto.

<DashImage src="images/1KPbxBAjFYPCSk2OqwjKs7A.webp" alt="Linha do tempo do null safety do Dart 3, da prévia técnica de julho de 2020 à versão estável de maio de 2023." />


Com o null safety 100% no Dart, temos um sistema de tipos *sólido*. Você pode confiar que, se um tipo diz que um valor não é `null`, então ele nunca pode ser `null`. Isso evita certas classes de erros de codificação, como as exceções de ponteiro nulo. Também permite que nossos compiladores e runtimes otimizem o código de formas que não conseguiriam sem o null safety. Essa escolha de design envolveu um compromisso. Embora as migrações tenham ficado um pouco mais difíceis, acreditamos que fizemos a escolha certa para o Dart.

### Migrando para o Dart 3 {:#migrating-to-dart-3}

Um componente crítico para alcançar o null safety sólido foi o apoio inabalável da comunidade Dart: 99% dos 1000 pacotes mais populares do pub.dev oferecem suporte a null safety!

Diante disso, esperamos que a grande maioria dos pacotes e apps que foram migrados para o null safety funcione com o Dart 3. Em poucos casos, uma limpeza menor e relacionada no Dart 3 pode afetar algum código. Algumas APIs legadas da biblioteca core foram removidas ([#34233](https://github.com/dart-lang/sdk/issues/34233), [#49529](https://github.com/dart-lang/sdk/issues/49529)) e algumas ferramentas foram ajustadas ([#50707](https://github.com/dart-lang/sdk/issues/50707)). Se você tiver algum problema ao migrar para o SDK do Dart 3, consulte o [guia de migração para o Dart 3](https://dart.dev/resources/dart-3-migration). Fora isso, esperamos que você aproveite as novas bibliotecas core e ferramentas racionalizadas.

## Principais recursos da linguagem: Records, patterns e class modifiers {:#major-language-features-record-patterns-and-class-modifiers}

O Dart 3 não se trata apenas de mudar a linguagem existente. Trata-se também de adicionar recursos e capacidades significativos! Eles incluem records, patterns e class modifiers.

### Construindo dados estruturados com records {:#building-up-structured-data-with-records}

Tradicionalmente, uma função Dart só podia retornar um único valor. Por isso, funções que precisavam retornar vários valores tinham que empacotá-los em outros tipos de dados, como mapas ou listas, ou definir novas classes que pudessem armazenar os valores. Usar estruturas de dados sem tipo enfraquecia a segurança de tipos. Ter que definir novas classes só para carregar dados adiciona atrito ao processo de codificação. Vocês deixaram isso bem claro para nós: o pedido de linguagem para múltiplos valores de retorno é a nossa [quarta issue mais bem avaliada](https://github.com/dart-lang/language/issues?q=is%3Aissue+sort%3Areactions-%2B1-desc+).

Com records, você pode construir dados estruturados com uma sintaxe limpa e concisa. Considere esta função. Ela lê o nome e a idade de um blob JSON e retorna os dois em um record:

```dart
(String, int) userInfo(Map<String, dynamic> json) {
  return (json['name'] as String, json['height'] as int);
}
```


Isso deve parecer familiar para todos os desenvolvedores Dart. Um record se parece com um literal de lista, como `[‘Michael’, ‘Product Manager’]`, mas usa parênteses em vez de colchetes. Em Dart, records são um recurso geral. Eles podem ser usados para mais do que valores de retorno de função. Você também pode armazená-los em variáveis, colocá-los em uma lista, usá-los como chaves em um mapa ou criar records que contenham outros records. Você pode adicionar tanto campos sem nome, como fizemos no exemplo anterior, quanto campos nomeados, como `(42, description: ‘Meaning of life’)`.

Records são tipos de valor e não têm identidade. Isso permite que nossos compiladores apaguem completamente o objeto record em alguns casos. Records também vêm com um operador `==` e funções `hashCode` definidos automaticamente. A [documentação de records](https://dart.dev/language/records) traz mais detalhes.

### Trabalhando com dados estruturados usando patterns e pattern matching {:#working-with-structured-data-with-patterns-and-pattern-matching}

Records simplificam a forma como você constrói dados estruturados. Isso não substitui o uso de classes para construir hierarquias de tipos mais formais. Apenas oferece outra opção. Em qualquer dos casos, você pode querer desmembrar esses dados estruturados em seus elementos individuais para trabalhar com eles. É aqui que entra o pattern matching.

Considere uma forma básica de pattern. O pattern de record a seguir desestrutura um record em duas novas variáveis, `name` e `height`. Essas variáveis podem então ser usadas como qualquer outra variável, como em uma chamada a `print`:

```dart
var (String name, int height) = userInfo({'name': 'Michael', 'height': 180});
print('User $name is $height cm tall.');
```


Padrões semelhantes existem para listas e mapas. Para todos eles, você pode pular elementos individuais com o pattern de sublinhado:

```dart
var (String name, _) = userInfo(…);
```


Os patterns brilham quando usados em uma instrução switch. O Dart sempre teve suporte limitado a switch desde o início. No Dart 3, ampliamos o poder e a expressividade da instrução `switch`. Agora oferecemos suporte a pattern matching nesses casos. Eliminamos a necessidade de adicionar `break` ao final de cada case. Também oferecemos suporte a operadores lógicos para combinar cases. O exemplo a seguir mostra uma instrução `switch` limpa e concisa que interpreta um código de caractere:

```dart
switch (charCode) {
  case slash when nextCharCode == slash:
    skipComment();

  case slash || star || plus || minus:
    operator(charCode);

  case >= digit0 && <= digit9:
    number();

  default:
    invalid();
}
```


A instrução switch é uma grande ajuda quando você precisa de uma ou mais instruções para cada `case`. Em alguns casos, tudo o que você quer é calcular um valor. Para esse caso de uso, oferecemos uma *expressão* switch muito sucinta. Ela se parece com a *instrução* switch, mas usa uma sintaxe diferente, ajustada para expressões. A função de exemplo a seguir retorna o valor de uma expressão switch para calcular uma descrição do dia da semana atual:

```dart
String describeDate(DateTime dt) =>
  switch (dt.weekday) {
      1 => 'Feeling the Monday blues?',
      6 || 7 => 'Enjoy the weekend!',
      _ => 'Hang in there.'
  };
```


Um recurso poderoso dos patterns é a capacidade de verificar a "exaustividade". Esse recurso garante que o switch trate todos os casos possíveis. No exemplo anterior, tratamos todos os valores possíveis de weekday, que é um `int`. Esgotamos todos os valores possíveis pela combinação de casos de correspondência para os valores específicos `1`, `6` ou `7` e, em seguida, usando um caso padrão `_` para os demais casos. Para habilitar essa verificação em hierarquias de dados definidas pelo usuário, como uma hierarquia de classes, use o novo modificador `sealed` no topo da hierarquia de classes, como no exemplo a seguir:

```dart
sealed class Animal { … }
class Cow extends Animal { … }
class Sheep extends Animal { … }
class Pig extends Animal { … }

String whatDoesItSay(Animal a) =>
    switch (a) { Cow c => '$c says moo', Sheep s => '$s says baa' };
```


Isso retorna o seguinte erro, nos alertando de que não tratamos o último subtipo possível, Pig:

```
line 6 • The type 'Animal' is not exhaustively matched by the switch cases
since it doesn't match 'Pig()'.
```


Por fim, instruções `if` também podem usar patterns. No próximo exemplo, usamos *if-case* com um pattern de mapa para desestruturar o mapa JSON. Dentro dele, comparamos com valores constantes (strings como `'name'` e `'Michael'`) e com um pattern de teste de tipo `int h` para ler um valor JSON. Se as correspondências do pattern falharem, o Dart executa a instrução `else`.

```dart
final json = {'name': 'Michael', 'height': 180};

// Find Michael's height.
if (json case {'name': 'Michael', 'height': int h}) {
  print('Michael is $h cm tall.'); 
} else { 
  print('Error: json contains no height info for Michael!');
}
```


Isso apenas toca em tudo o que você pode fazer com patterns. Acreditamos que eles vão se tornar onipresentes em todo o código Dart. Para saber mais, confira a [documentação de patterns](http://dart.dev/language/patterns) e o [codelab de patterns](https://codelabs.developers.google.com/codelabs/dart-patterns-records).

### Controles de acesso refinados para classes com class modifiers {:#fine-grained-access-controls-for-classes-with-class-modifiers}

Um terceiro recurso de linguagem do Dart 3 são os class modifiers. Diferentemente de records e patterns, que esperamos que todo desenvolvedor Dart use, este é mais um recurso para usuários avançados. Ele atende às necessidades de desenvolvedores Dart que criam superfícies de API grandes ou constroem apps de classe empresarial.

Os class modifiers permitem que os autores de APIs suportem apenas um conjunto específico de capacidades. Os padrões, porém, continuam os mesmos. Queremos que o Dart continue simples e acessível. Então, como antes, classes comuns podem ser *construídas*, *estendidas* e *implementadas*, como mostrado nos exemplos a seguir:

```dart
class Vehicle {
  String make; String model;
  void moveForward(int meters) { … }
}

// Construct.
var myCar = Vehicle(make: 'Ford', model: 'T',);

// Extend.
class Car extends Vehicle {
  int passengers;
}

// Implement.
class MockVehicle implements Vehicle {
  @override void moveForward …
}
```


Os class modifiers permitem adicionar restrições a isso. Considere alguns casos de uso de exemplo:

* Com uma `interface class`, você pode definir um contrato para outros implementarem. Uma interface class não pode ser estendida.

* Com uma `base class`, você pode garantir que todos os subtipos da sua classe herdem dela, em vez de implementarem sua interface. Isso garante que métodos privados estejam disponíveis em todas as instâncias.

* Com uma `final class`, você pode fechar a hierarquia de tipos, impedindo quaisquer subclasses fora da sua própria biblioteca. Como benefício de exemplo, isso permite que o dono da API adicione novos membros sem o risco de quebras de compatibilidade para os consumidores da API.

Para detalhes, veja a nova [documentação de class modifiers](https://dart.dev/language/class-modifiers).

## Um olhar para o futuro {:#a-view-towards-the-future}

O Dart 3 não é apenas um passo significativo em termos de novos recursos que você pode usar hoje. Também oferecemos uma prévia do que vem a seguir.

### Linguagem Dart {:#dart-language}

Records, patterns e class modifiers são recursos novos e muito grandes, então é possível que partes do seu design possam ser aprimoradas. Continuaremos acompanhando [o seu feedback](https://github.com/dart-lang/language/issues) e vendo se atualizações são necessárias em versões menores após o Dart 3.

Também estamos analisando recursos menores e mais incrementais, totalmente sem quebras e focados em aumentar a produtividade do desenvolvedor sem custo de migração. Dois exemplos que estamos explorando são [inline classes](https://github.com/dart-lang/language/issues/2727), para encapsular tipos existentes com "wrappers" de custo zero, e [primary constructors](https://github.com/dart-lang/language/issues/2364), um recurso que introduz uma sintaxe muito mais concisa para definir classes com alguns campos e um construtor primário.

Já discutimos macros (também chamadas de [metaprogramação](https://github.com/dart-lang/language/blob/main/working/macros/feature-specification.md)). Estamos focados especialmente em usá-las para permitir uma melhor desserialização de JSON (e similares) e para viabilizar classes de dados. Dado o tamanho e o risco inerente à metaprogramação, estamos adotando uma abordagem muito cuidadosa e, portanto, não temos um cronograma concreto para compartilhar, nem mesmo para a finalização das decisões de design.

### Interoperabilidade nativa {:#native-interop}

Apps para celular e desktop normalmente dependem de muitas APIs fornecidas pela plataforma nativa, sejam notificações, pagamentos ou a obtenção da localização do celular. Tradicionalmente, no Flutter, esses recursos são acessados por meio da criação de plugins, o que exige escrever código Dart para a API e uma série de código específico de cada plataforma para fornecer a implementação.

Já oferecemos suporte à interoperabilidade com código compilado em bibliotecas C com [`dart:ffi`](https://dart.dev/guides/libraries/c-interop). Atualmente, estamos trabalhando para expandir isso e oferecer suporte à [interoperabilidade com Java e Kotlin](https://dart.dev/guides/libraries/java-interop) no Android, e à [interoperabilidade com Objective-C e Swift](https://dart.dev/guides/libraries/objective-c-interop) no iOS/macOS. Para uma introdução à interoperabilidade com Android, confira o novo [vídeo sobre interoperabilidade com Android](https://io.google/2023/program/2f02692d-9a41-49c0-8786-1a22b7155628/) do Google I/O 23.

### Compilação para WebAssembly: direcionando a web com código nativo {:#compilation-to-webassembly-targeting-the-web-with-native-code}

[WebAssembly](https://webassembly.org/) (abreviado como Wasm) vem amadurecendo como um formato de instruções binárias neutro em relação à plataforma, presente em [todos os navegadores modernos](https://caniuse.com/wasm). O framework Flutter usa Wasm há algum tempo. É assim que entregamos o mecanismo de renderização gráfica SKIA, escrito em C++, ao navegador por meio de um módulo compilado para Wasm. Há muito tempo temos interesse em usar Wasm para implantar código Dart também, mas estávamos bloqueados. O Dart, como muitas outras linguagens orientadas a objetos, usa coleta de lixo. Ao longo do último ano, colaboramos com várias equipes do ecossistema Wasm para adicionar um novo recurso, o WasmGC, ao padrão WebAssembly. Ele agora está quase estável nos navegadores Chromium e Firefox.

Nosso trabalho de compilar Dart para módulos Wasm tem dois objetivos de alto nível para apps web:

* **Tempo de carregamento:** esperamos conseguir entregar payloads de implantação em Wasm que o navegador possa carregar mais rapidamente, melhorando assim o tempo até o ponto em que o usuário pode interagir com o app web.

* **Desempenho:** apps web baseados em JavaScript precisam de compilação just-in-time para alcançar bom desempenho. Módulos Wasm são mais de baixo nível e mais próximos do código de máquina, então acreditamos que podem entregar desempenho mais alto, com menos travamentos e taxas de quadros mais consistentes.

* **Consistência semântica**: o Dart tem orgulho de ser altamente consistente entre as plataformas que suporta. No entanto, na web, há algumas exceções. Por exemplo, o Dart para web atualmente se diferencia na forma como [os números são representados](https://dart.dev/guides/language/numbers). Com módulos Wasm, poderíamos tratar a web como uma plataforma "nativa", com semântica semelhante à dos outros alvos nativos.

Estamos animados para anunciar hoje a primeira prévia da compilação de Dart para Wasm! Nosso foco inicial é o suporte ao Flutter web. Ainda está no começo e temos muito trabalho pela frente, mas [convidamos você a experimentar](https://flutter.dev/wasm) e ver se isso deixa você tão animado quanto nós.

## Encerramento {:#closing}

Obrigado por ler até o fim. Esperamos que este post tenha deixado você animado com o Dart 3, disponível hoje tanto no [SDK do Dart](https://dart.dev/get-dart) independente quanto no [SDK do Flutter 3.10]({{site.flutter-blog}}/whats-new-in-flutter-3-10).

Concluímos uma grande revisão da linguagem Dart, com null safety sólido e limpeza das bibliotecas core e das ferramentas. Há grandes novos recursos de linguagem que tornam o Dart mais expressivo e conciso, com records e patterns. Para superfícies de API grandes, os class modifiers permitem um controle detalhado. Também incluímos uma prévia do futuro com o nosso suporte próximo ao WebAssembly.

Com todos esses recursos, achamos que o Dart 3 ilustra nossa visão de longo prazo: *construir a linguagem de programação mais produtiva para criar apps rápidos em qualquer plataforma*. Esperamos que você pense assim também!
